Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYFTIo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYFTIo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYFTIoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:44:19 -0400
Received: from 187.Red-80-37-203.staticIP.rima-tde.net ([80.37.203.187]:13303
	"EHLO betty.it.uc3m.es" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751482AbYFTIoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:44:17 -0400
Date: Fri, 20 Jun 2008 10:44:05 +0200
Message-Id: <200806200844.m5K8i5J3009179@betty.it.uc3m.es>
From: "Peter T. Breuer" <ptb@oboe.it.uc3m.es>
Subject: Re: zero-copy recv ?
Newsgroups: gmane.linux.kernel
References: <200806192235.m5JMZsYD007864@betty.it.uc3m.es>
To: undisclosed-recipients:;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter T. Breuer <ptb@inv.it.uc3m.es> wrote:
> References: <200806191411.m5JEBE56008942@betty.it.uc3m.es>
>  ftp://oboe.it.uc3m.es/pub/Programs/enbd-2.4.36.tgz

> I wrote a quick summary of the relevant code in my lost answer :(.
> Please ask me to repeat if it is really AWOL.

The code uses the "nopage" technique from rubini. That is, the mmap
call simply replies "yes" without doing any work, but loads the
vma struct with its own nopage method. 

The nopage method gets called when the mmapped region is actually
accessed. That will be at once.

What is happening in the larger picture is that the block device driver
has received a r/w request, has notified a user daemon, and the user
daemon is responding by attemping to mmap the region on the device
corresponding to the r/w request it's just been informed about.  The
intention is that it will then recv/send on a tcp socket with the data
directly to/from the mmapped address as recv/send buffer.

This works fine for send, but *recv* *hangs* (oww! why?).

The nopage method simply goes and seaches in the request bio buffers
for any page it is told is needed. It's guaranteed to find it, because
it's been asked to do this as part of an mmap attempt on exactly the device
area corresponding to the r/w request that's currently sitting on its
queue, packed with nice juicy buffers.

Here is the mmap, simplified

int
enbd_mmap(struct file *file, struct vm_area_struct * vma)
{
        unsigned long long vma_offset_in_disk
                = ((unsigned long long)vma->vm_pgoff) << PAGE_SHIFT;
        unsigned long vma_len = vma->vm_end - vma->vm_start; 
        // ...

        // device data to be stored in vma private field
        vma->vm_private_data = slot;

        // set VMA flags
        if (vma_offset_in_disk >= __pa(high_memory) || (file->f_flags & O_SYNC))
                vma->vm_flags |= VM_IO;
        vma->vm_flags |= VM_RESERVED;
        vma->vm_flags |= VM_MAYREAD;    // for good luck
        vma->vm_flags |= VM_MAYWRITE;

        vma->vm_ops = &enbd_vm_ops;     // vm_ops contains my nopage method

        enbd_vma_open(vma);             // accounting

        return 0;
}

and here's the simplified nopage method

static struct page *
enbd_vma_nopage(struct vm_area_struct * vma, unsigned long addr, int *type)
{
        struct page *page = NULL;

        // device data retrieved from vma private field
        struct enbd_slot * const slot = vma->vm_private_data;
        // ...

        // used in scanning requests on local queue
        struct request *xreq, *req = NULL;
        struct bio *bio;

        // offset data
        const unsigned long page_offset_in_vma = addr - vma->vm_start; 
        const unsigned long long vma_offset_in_disk = 
                ((unsigned long long)vma->vm_pgoff) << PAGE_SHIFT;
        const unsigned long long page_offset_in_disk =
                page_offset_in_vma + vma_offset_in_disk;
        const long vma_len = vma->vm_end - vma->vm_start; 
        const unsigned long long page_end_in_disk
                           = page_offset_in_disk + PAGE_SIZE;
        const unsigned long long page_index
                           = page_offset_in_disk >> PAGE_SHIFT;

        // begin seeking a matching req on local device queue under lock
        spin_lock(&slot->lock);
        list_for_each_entry_reverse (xreq, &slot->queue, queuelist) {

                unsigned long long xreq_end_sector =
                    xreq->sector + xreq->nr_sectors;
                    
		if (xreq->sector    <= (page_offset_in_disk >> 9)
                &&  xreq_end_sector >= (page_end_in_disk >> 9) ) {
			// PTB found the request with the wanted buffer
                        req = xreq;
			break;
                }
	}
        // end seeking a matching req on local queue, still under lock

        if (!req) {
                spin_unlock(&slot->lock);
                goto got_no_page;
        }

        // can't release lock yet. Look inside the req for buffer page

        __rq_for_each_bio(bio, req) {

                int i;
                struct bio_vec * bvec;
                // set the offset in req since bios may be noncontiguous
                int current_offset_in_req = (bio->bi_sector - req->sector) << 9;

                bio_for_each_segment(bvec, bio, i) {

                        const unsigned current_segment_size // <= PAGE_SIZE
                                    = bvec->bv_len;
                        const unsigned long long current_sector
                                    = req->sector
                                    + (current_offset_in_req >> 9);
                        const unsigned long long current_page
                                    = current_sector >> (PAGE_SHIFT - 9);

                        // are we on the same page?
                        if (current_page == page_index)  {

                                page = bvec->bv_page;
                                // increment page use count for mmap
                                get_page(page);
                                spin_unlock(&slot->lock);
                                goto got_page;
                        }

		        current_offset_in_req += current_segment_size;
	        }
	}
        spin_unlock(&slot->lock);

        goto got_no_page;

got_no_page:
        if (type)
                *type = VM_FAULT_MAJOR;
        return NOPAGE_SIGBUS;

got_page:
         if (type)
                 *type = VM_FAULT_MINOR;
         return page;
}


I've tried prefaulting in the mmap pages at mmap time, but not been
successful.  vm_insert won't touch the pages for insertion in the vma
because it thinks they're anonymous.

I can run nopage on each page all the same, without doing the
vma insertion, and that looks as though it is initially helpful, but a
random looking oops happens a little later, probably because of bad
refcount management. 

It does remove the recv hang, though, so the hang might be that the
recv has to bring the buffer it is receiving to into existence
first, and that takes one through memory.

I'd like to know how to prefault in the intended mmap pages properly.
vm_insert_page won't let me do it, using the page addresses found in 
the i/o request, because it thinks they're anonymous. Help?


Peter
