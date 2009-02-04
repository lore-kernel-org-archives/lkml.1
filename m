Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZBDMkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZBDMkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZBDMkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:40:04 -0500
Received: from flicker.mariinsky.ru ([84.204.53.66]:55602 "EHLO
	mail.581.spb.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZBDMkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:40:01 -0500
X-Greylist: delayed 1819 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 07:40:01 EST
Message-ID: <49898573.8070509@581.spb.su>
Date: Wed, 04 Feb 2009 15:09:23 +0300
From: Pavel Levshin <lpk@581.spb.su>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Major page faults counter is zero with MADV_RANDOM 
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.


There is something wrong with page fault counter in mm/filemap.c, when 
using madvise() with MADV_RANDOM flag set. Every page fault in this case 
should be considered major, as it causes disk I/O. But in reality, 
majflt/s in "sar -B" stays zero. I'm using 2.6.24 right now, but this 
piece of code is identical in current kernel.

The page is read into cache but no counter updated. The same applies 
when kernel decides to disable read ahead due to excessive miss. 
Furthermore, the code makes it possible to read ahead even with 
MADV_RANDOM flag in some cases, as it loops from no_cached_page to 
retry_find. And I am not sure, but does "no read ahead" really mean "no 
page caching"?

Please CC me if you want me to read your answer.


In mm/filemap.c:

#define MMAP_LOTSAMISS  (100)

/**
 * filemap_fault - read in file data for page fault handling
 * @vma:        vma in which the fault was taken
 * @vmf:        struct vm_fault containing details of the fault
 *
 * filemap_fault() is invoked via the vma operations vector for a
 * mapped memory region to read in file data during a page fault.
 *
 * The goto's are kind of ugly, but this streamlines the normal case of 
having
 * it in the page cache, and handles the special cases reasonably without
 * having a lot of duplicated code.
 */
int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
{
        int error;
        struct file *file = vma->vm_file;
        struct address_space *mapping = file->f_mapping;
        struct file_ra_state *ra = &file->f_ra;
        struct inode *inode = mapping->host;
        struct page *page;
        unsigned long size;
        int did_readaround = 0;
        int ret = 0;

        size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> 
PAGE_CACHE_SHIFT;
        if (vmf->pgoff >= size)
                return VM_FAULT_SIGBUS;

        /* If we don't want any read-ahead, don't bother */
        if (VM_RandomReadHint(vma))
                goto no_cached_page;

        /*
         * Do we have something in the page cache already?
         */
retry_find:
        page = find_lock_page(mapping, vmf->pgoff);
        /*
         * For sequential accesses, we use the generic readahead logic.
         */
        if (VM_SequentialReadHint(vma)) {
                if (!page) {
                        page_cache_sync_readahead(mapping, ra, file,
                                                           vmf->pgoff, 1);
                        page = find_lock_page(mapping, vmf->pgoff);
                        if (!page)
                                goto no_cached_page;
                }
                if (PageReadahead(page)) {
                        page_cache_async_readahead(mapping, ra, file, page,
                                                           vmf->pgoff, 1);
                }
        }
               
        if (!page) {
                unsigned long ra_pages;

                ra->mmap_miss++;

                /*
                 * Do we miss much more than hit in this file? If so,
                 * stop bothering with read-ahead. It will only hurt.
                 */
                if (ra->mmap_miss > MMAP_LOTSAMISS)
                        goto no_cached_page;

                /*
                 * To keep the pgmajfault counter straight, we need to
                 * check did_readaround, as this is an inner loop.
                 */
                if (!did_readaround) {
                        ret = VM_FAULT_MAJOR;
                        count_vm_event(PGMAJFAULT);
                }
                did_readaround = 1;
                ra_pages = max_sane_readahead(file->f_ra.ra_pages);
                if (ra_pages) {
                        pgoff_t start = 0;

                        if (vmf->pgoff > ra_pages / 2)
                                start = vmf->pgoff - ra_pages / 2;
                        do_page_cache_readahead(mapping, file, start, 
ra_pages);
                }
                page = find_lock_page(mapping, vmf->pgoff);
                if (!page)
                        goto no_cached_page;
        }
       
        if (!did_readaround)
                ra->mmap_miss--;

        /*
         * We have a locked page in the page cache, now we need to check
         * that it's up-to-date. If not, it is going to be due to an error.
         */
        if (unlikely(!PageUptodate(page)))
                goto page_not_uptodate;

        /* Must recheck i_size under page lock */
        size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> 
PAGE_CACHE_SHIFT;
        if (unlikely(vmf->pgoff >= size)) {
                unlock_page(page);
                page_cache_release(page);
                return VM_FAULT_SIGBUS;
        }

        /*
         * Found the page and have a reference on it.
         */
        mark_page_accessed(page);
        ra->prev_pos = (loff_t)page->index << PAGE_CACHE_SHIFT;
        vmf->page = page;
        return ret | VM_FAULT_LOCKED;

no_cached_page:
        /*
         * We're only likely to ever get here if MADV_RANDOM is in
         * effect.
         */
        error = page_cache_read(file, vmf->pgoff);

        /*
         * The page we want has now been added to the page cache.
         * In the unlikely event that someone removed it in the
         * meantime, we'll just come back here and read it again.
         */
        if (error >= 0)
                goto retry_find;

        /*
         * An error return from page_cache_read can result if the
         * system is low on memory, or a problem occurs while trying
         * to schedule I/O.
         */
        if (error == -ENOMEM)
                return VM_FAULT_OOM;
        return VM_FAULT_SIGBUS;

page_not_uptodate:
        /* IO error path */
        if (!did_readaround) {
                ret = VM_FAULT_MAJOR;
                count_vm_event(PGMAJFAULT);
        }
       
        /*
         * Umm, take care of errors if the page isn't up-to-date.
         * Try to re-read it _once_. We do this synchronously,
         * because there really aren't any performance issues here
         * and we need to check for errors.
         */
        ClearPageError(page);
        error = mapping->a_ops->readpage(file, page);
        page_cache_release(page);

        if (!error || error == AOP_TRUNCATED_PAGE)
                goto retry_find;

        /* Things didn't work out. Return zero to tell the mm layer so. */
        shrink_readahead_size_eio(file, ra);
        return VM_FAULT_SIGBUS;
}
EXPORT_SYMBOL(filemap_fault);

--
Pavel Levshin

