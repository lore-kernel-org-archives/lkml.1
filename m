Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbYFSRQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbYFSRQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYFSRQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:16:07 -0400
Received: from smtp03.uc3m.es ([163.117.176.133]:35923 "EHLO smtp03.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbYFSRQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:16:05 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 13:16:05 EDT
Date: Thu, 19 Jun 2008 19:01:45 +0200
Message-Id: <200806191701.m5JH1jI20752@inv.it.uc3m.es>
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
To: Frederik Deweerdt <deweerdt@free.fr>
Subject: Re: zero-copy recv ?
Cc: linux-kernel@vger.kernel.org
X-Newsgroups: gmane.linux.kernel
In-Reply-To: <20080619150248.GA13463@slug>
User-Agent: tin/1.4.4-20000803 ("Vet for the Insane") (UNIX) (Linux/2.2.15 
	(i686))
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:N SM:2
X-imss-tmaseResult: TT:1 TS:-11.8510 TC:1F TRN:64 TV:5.5.1026(15982.000)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080619150248.GA13463@slug> you wrote:
> On Thu, Jun 19, 2008 at 04:11:14PM +0200, Peter T. Breuer wrote:
>> G'day all
>> 
>> I've been mmapping the request's bio buffers received on my block device
>> driver for userspace to use directly as tcp send/receive buffers.
> Is the code available somewhere by any chance?

Sure. It's just the unstable snapshot release of my enbd device
driver.

  ftp://oboe.it.uc3m.es/pub/Programs/enbd-2.4.36.tgz

would be the current image. It gets updated nightly. I imagine there
are mirrors several places.

If you would like me to describe the code, I'll say that originally I
was using the "nopage" method as described in Rubini, and nowadays I do
a tiny bit more than only that.

Generally speaking, on receiving a read/write request, the driver just
queues it and notifies a user space daemon.  The daemon gets told about
the request pending, and then mmaps the corresponding area of the
device.

The driver just replies "yes" to the mmap call, and waits for an actual
page fault from an access before doing any real work (though nowabouts,
as I mentioned, I'm prefaulting in the mmap call itself, so I can walk
the pages and decide if they're OK before letting the mmap return OK,
and then also benefit from reduced latency).

At the page fault or whenever I prefault it, we supplied a nopage method
to the vma struct at mmap time, and that gets called.  In the nopage
method we go hunt down the individual buffer in the kernel request that
corresponds to the notional device offset of the missing mmapped page.

The advantage of using nopage is that I can count on only having to
deal with one page at a time, thus making things conceptually simpler.

The only thing the mmap call does is load the private field of the vma
with a pointer to the device, and do various tests, then prefaults all
the vma struct pages in (at the mo).

int
enbd_mmap(struct file *file, struct vm_area_struct * vma)
{
        unsigned long long vma_offset_in_disk
                = ((unsigned long long)vma->vm_pgoff) << PAGE_SHIFT;
        unsigned long vma_len = vma->vm_end - vma->vm_start;

        // used in pre-faulting in pages
        unsigned long addr, len;

        // device parameters
        int dev;
        struct enbd_device *lo;
        int nbd;
        int part;
        int islot;

        // setup device parameters from @file arg
        // ...
        
        // various sanity tests cause -EINVAL return if failed
        // ...

       if (vma_offset_in_disk >= __pa(high_memory) || (file->f_flags & O_SYNC))
                vma->vm_flags |= VM_IO; // don't core dump this area
        vma->vm_flags |= VM_RESERVED;   // don't swap out this area

        vma->vm_flags |= VM_MAYREAD;    // for good luck. Not definitive
        vma->vm_flags |= VM_MAYWRITE;

        // our vm_ops has the nopage method
        vma->vm_ops = &enbd_vm_ops;

        // begin pre-fault in the pages
        addr = vma->vm_start;
        len  = vma_len;
        while (len > 0) {

                struct page * page = enbd_vma_nopage(vma, addr, NULL);

                if (page == NOPAGE_SIGBUS || page == NOPAGE_OOM) {
                        // got too few pages
                        return -EINVAL;
                }
                if (vm_insert_page(vma, addr, page)) {
                        // reverse an extra get_page we did in nopage
                        put_page(page);
                        return -EINVAL;
                }
                // reverse an extra get_page we did in nopage
                put_page(page);
                len  -= PAGE_SIZE;
                addr += PAGE_SIZE;
        }
        // end pre-fault in pages

        enbd_vma_open(vma);
        return 0;
}


and the nopage method ... it goes searchabout on the local device queue
for the request with the page that is wanted as one of its buffers, and
then grabs the page reference from the buffer and returns it (after
incrementing the use count with get_page under lock).

static struct page *
enbd_vma_nopage(struct vm_area_struct * vma, unsigned long addr, int
*type)
{
        struct page *page;

        // get stored device params out of vma private data
        struct enbd_slot * const slot = vma->vm_private_data;
        const int islot = slot->i;
        const int part  = islot + 1;
        struct enbd_device * const lo = slot->lo;

        // for scanning requests
        struct request *xreq, *req = NULL;
        struct bio *bio;
        struct buffer_head *bh;

        // offset data
        const unsigned long page_offset_in_vma = addr - vma->vm_start;
        const unsigned long long vma_offset_in_disk =
                ((unsigned long long)vma->vm_pgoff) << PAGE_SHIFT;
        const unsigned long long page_offset_in_disk =
                page_offset_in_vma + vma_offset_in_disk;

        // look under local lock on our queue for matching request

        spin_lock(&slot->lock);
        list_for_each_entry_reverse (xreq, &slot->queue, queuelist) {

                if (xreq->sector <= (page_offset_in_disk >> 9)
                &&  xreq->sector + xreq->nr_sectors >= ((page_offset_in_disk + PAGE_SIZE)>> 9)) {
                        req = xreq; // found the request 
                        break;
                }
        }

        if (!req) {
                spin_unlock(&slot->lock);
                goto try_searching_general_memory_pages;
        }

        // still under local device queue lock
        page = NULL;
        __rq_for_each_bio(bio, req) {

                int i;
                struct bio_vec * bvec;
                // set the offset in req since bios may be noncontiguous
                int offset_in_req = (bio->bi_sector - req->sector) << 9;

                bio_for_each_segment(bvec, bio, i) {

                        const unsigned current_segment_size // <= PAGE_SIZE
                                    = bvec->bv_len;

                        // PTB are we on the same page of the device?
                        if (((req->sector + (offset_in_req >> 9)) >> (PAGE_SHIFT - 9)) == (page_offset_in_disk >> PAGE_SHIFT))  {

                                struct page *old_page = page;

                                page = bvec->bv_page;
                                if (page != old_page) {
                                        // increment page use count
                                        get_page(page);
                                }
         			spin_unlock(&slot->lock);
                                goto got_page;
                        }
                       offset_in_req += current_segment_size;
                }
        }
        spin_unlock(&slot->lock);

        // not possible
        goto nopage;

try_searching_general_memory_pages:
        // This one does not sleep
        bh = __find_get_block(lo->bdev,
            (sector_t) (page_offset_in_disk >> lo->logblksize), PAGE_SIZE);
        if (bh) {
                page = bh->b_page;
                // increment page use count. Decremented by unmap.
                get_page(page);
                put_bh(bh);
                goto got_page;
        }
        // dropthru

nopage:
        if (type)
                *type = VM_FAULT_MAJOR;
        return NOPAGE_SIGBUS;

got_page:
        if (type)
                 *type = VM_FAULT_MINOR;
         return page;
}




                                                          






Peter
