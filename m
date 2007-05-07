Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbXEGHGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbXEGHGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 03:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXEGHGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 03:06:36 -0400
Received: from holomorphy.com ([66.93.40.71]:46799 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbXEGHGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 03:06:35 -0400
Date: Mon, 7 May 2007 00:06:38 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Chinner <dgc@sgi.com>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070507070638.GC19966@holomorphy.com>
References: <20070427000403.6013d1fa.akpm@linux-foundation.org> <20070427080321.GG32602149@melbourne.sgi.com> <20070427014849.41f383f7.akpm@linux-foundation.org> <20070427164535.GH24852@thunk.org> <m1abwku30d.fsf@ebiederm.dsl.xmission.com> <20070507042925.GT32602149@melbourne.sgi.com> <m1tzupkzmw.fsf@ebiederm.dsl.xmission.com> <20070507052729.GV32602149@melbourne.sgi.com> <m17irlkubc.fsf@ebiederm.dsl.xmission.com> <20070507064925.GB19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507064925.GB19966@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:
>>> Right - so how do we efficiently  manipulate data inside a large
>>> block that spans multiple discontigous pages if we don't vmap
>>> it?

On Mon, May 07, 2007 at 12:43:19AM -0600, Eric W. Biederman wrote:
>> You don't manipulate data except for copy_from_user, copy_to_user.
>> That is easy comparatively to deal with, and certainly doesn't
>> need vmap.
>> Meta-data may be trickier, but a lot of that depends on your
>> individual filesystem and how it organizes it's meta-data.

On Sun, May 06, 2007 at 11:49:25PM -0700, William Lee Irwin III wrote:
> I wonder what happened to my pagearray patches.

I never really got the thing working, but I had an idea for a sort of
library to do this. This is/was probably against something like 2.6.5
but I honestly have no idea. Maybe this makes it something of an API
proposal.


-- wli


Index: linux-2.6/include/linux/pagearray.h
===================================================================
--- linux-2.6.orig/include/linux/pagearray.h	2004-04-06 10:56:48.000000000 -0700
+++ linux-2.6/include/linux/pagearray.h	2005-04-22 06:06:02.677494584 -0700
@@ -0,0 +1,24 @@
+#ifndef _LINUX_PAGEARRAY_H
+#define _LINUX_PAGEARRAY_H
+
+struct scatterlist;
+struct vm_area_struct;
+struct page;
+
+struct pagearray {
+	struct page **pages;
+	int nr_pages;
+	size_t length;
+};
+
+int alloc_page_array(struct pagearray *, const int, const size_t);
+void free_page_array(struct pagearray *);
+void zero_page_array(struct pagearray *);
+struct page *nopage_page_array(const struct vm_area_struct *, unsigned long, unsigned long, int *, struct pagearray *);
+int mmap_page_array(const struct vm_area_struct *, struct pagearray *, const size_t, const size_t);
+int copy_page_array_to_user(struct pagearray *, void __user *, const size_t, const size_t);
+int copy_page_array_from_user(struct pagearray *, void __user *, const size_t, const size_t);
+struct scatterlist *pagearray_to_scatterlist(struct pagearray *, size_t, size_t, int *);
+void *vmap_pagearray(struct pagearray *);
+
+#endif /* _LINUX_PAGEARRAY_H */
Index: linux-2.6/mm/Makefile
===================================================================
--- linux-2.6.orig/mm/Makefile	2005-04-22 06:01:29.786980248 -0700
+++ linux-2.6/mm/Makefile	2005-04-22 06:06:02.677494584 -0700
@@ -10,7 +10,7 @@
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o slab.o swap.o truncate.o vmscan.o \
-			   prio_tree.o $(mmu-y)
+			   prio_tree.o pagearray.o $(mmu-y)
 
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
Index: linux-2.6/mm/pagearray.c
===================================================================
--- linux-2.6.orig/mm/pagearray.c	2004-04-06 10:56:48.000000000 -0700
+++ linux-2.6/mm/pagearray.c	2005-04-22 06:20:26.154226168 -0700
@@ -0,0 +1,293 @@
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/highmem.h>
+#include <linux/pagearray.h>
+#include <asm/uaccess.h>
+#include <asm/scatterlist.h>
+
+/**
+ * alloc_page_array - allocate an array of pages
+ * @pages: the array of pages to be allocated
+ * @gfp_mask: the GFP flags to be passed to the allocator
+ * @length: the amount of data the array needs to hold
+ *
+ * Allocate an array of page pointers long enough so that when full of
+ * pages, the amount of data in length may be stored, then allocate the
+ * pages for each position in the array.
+ */
+int alloc_page_array(struct pagearray *pages, const int gfp_mask, const size_t length)
+{
+	int k;
+	pages->length = PAGE_ALIGN(length);
+	pages->nr_pages = PAGE_ALIGN(length) >> PAGE_SHIFT;
+	pages->pages = kmalloc(pages->nr_pages*sizeof(struct page *), gfp_mask);
+	if (!pages->pages)
+		return -ENOMEM;
+	memset(pages->pages, 0, pages->nr_pages*sizeof(struct page *));
+	for (k = 0; k < pages->nr_pages; ++k) {
+		pages->pages[k] = alloc_page(gfp_mask);
+		if (!pages->pages[k])
+			goto enomem;
+	}
+	return 0;
+enomem:
+	for (--k; k >= 0; --k)
+		__free_page(pages->pages[k]);
+	kfree(pages->pages);
+	memset(pages, 0, sizeof(struct pagearray));
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(alloc_page_array);
+
+/**
+ * free_page_array - free an array of pages
+ * @pages: the array of pages to be freed
+ *
+ * Free an array of pages, including the pages pointed to by the array.
+ */
+void free_page_array(struct pagearray *pages)
+{
+	int k;
+	for (k = 0; k < pages->nr_pages; ++k)
+		__free_page(pages->pages[k]);
+	kfree(pages->pages);
+	memset(pages, 0, sizeof(struct pagearray));
+}
+EXPORT_SYMBOL(free_page_array);
+
+/**
+ * zero_page_array - zero an array of pages
+ * @pages: the array of pages
+ *
+ * Zero out a set of pages pointed to by an array of page pointers.
+ */
+void zero_page_array(struct pagearray *pages)
+{
+	int k;
+	for (k = 0; k < pages->nr_pages; ++k)
+		clear_highpage(pages->pages[k]);
+}
+EXPORT_SYMBOL(zero_page_array);
+
+/**
+ * nopage_page_array - retrieve the page to satisfy a fault with
+ * @vma: the user virtual memory area the fault occurred on
+ * @pgoff: an offset into the underlying array to add to ->vm_pgoff
+ * @vaddr: the user virtual address the fault occurred on
+ * @type: the type of fault that occurred, to be returned
+ * @pages: the array of page pointers
+ *
+ * This is a trivial helper for ->nopage() methods. Simply return the
+ * result of this function after retrieving the page array and its
+ * descriptive parameters from vma->vm_private_data, for instance:
+ * return nopage_page_array(vma, pgoff, vaddr, type, pages);
+ * as the last thing in the ->nopage() method after fetching the
+ * parameters from vma->vm_private_data.
+ */
+struct page *nopage_page_array(const struct vm_area_struct *vma, unsigned long pgoff, unsigned long vaddr, int *type, struct pagearray *pages)
+{
+	if (vaddr >= vma->vm_end)
+		goto sigbus;
+	pgoff += vma->vm_pgoff + ((vaddr - vma->vm_start) >> PAGE_SHIFT);
+	if (pgoff > PAGE_ALIGN(pages->length)/PAGE_SIZE)
+		goto sigbus;
+	if (pgoff > pages->nr_pages)
+		goto sigbus;
+	get_page(pages->pages[pgoff]);
+	if (type)
+		*type = VM_FAULT_MINOR;
+	return pages->pages[pgoff];
+sigbus:
+	if (type)
+		*type = VM_FAULT_SIGBUS;
+	return NOPAGE_SIGBUS;
+}
+EXPORT_SYMBOL(nopage_page_array);
+
+/**
+ * mmap_page_array - mmap an array of pages
+ * @vma: the vma where the mmapping is done
+ * @pages: the array of page pointers
+ * @offset: the offset into the vma in bytes where mmapping should be done
+ * @length: the amount of data that should be mmap'd, in bytes
+ *
+ * vma->vm_pgoff specifies how far out into the page array mmapping
+ * should be done. The page array is treated as a list of the pieces
+ * of an object and vma->vm_pgoff the offset into that object.
+ * vma->vm_page_prot in turn specifies the protections to map with.
+ * offset says where in userspace relative to vma->vm_start to put
+ * the mappings of the pieces of the page array. length specifies how
+ * much data should be mapped into userspace.
+ */
+#ifdef CONFIG_MMU
+int mmap_page_array(const struct vm_area_struct *vma, struct pagearray *pages, const size_t offset, const size_t length)
+{
+	int k, ret = 0;
+	unsigned long end, off, vaddr = vma->vm_start + offset;
+	off = (vma->vm_pgoff << PAGE_SHIFT) + offset;
+	end = vaddr + length;
+	if (vaddr >= end)
+		return -EINVAL;
+	else if (offset != PAGE_ALIGN(offset))
+		return -EINVAL;
+	else if (offset + length > pages->length)
+		return -EINVAL;
+	k = off >> PAGE_SHIFT;
+	while (vaddr < end && !ret) {
+		pgd_t *pgd;
+		pud_t *pud;
+
+		spin_lock(&vma->vm_mm->page_table_lock);
+		pgd = pgd_offset(vma->vm_mm, vaddr);
+		pud = pud_alloc(vma->vm_mm, pgd, vaddr);
+		if (!pud) {
+			ret = -ENOMEM;
+			break;
+		} else {
+			pmd_t *pmd = pmd_alloc(vma->vm_mm, pud, vaddr);
+			if (!pmd) {
+				ret = -ENOMEM;
+				break;
+			} else {
+				pte_t val, *pte;
+
+				pte = pte_alloc_map(vma->vm_mm, pmd, vaddr);
+				if (!pte) {
+					ret = -ENOMEM;
+					break;
+				} else {
+					val = mk_pte(pages->pages[k], vma->vm_page_prot);
+					set_pte(pte, val);
+					pte_unmap(pte);
+					update_mmu_cache(vma, vaddr, val);
+				}
+			}
+		}
+		spin_unlock(&vma->vm_mm->page_table_lock);
+		vaddr += PAGE_SIZE;
+		off += PAGE_SIZE;
+		++k;
+	}
+	return ret;
+}
+#else
+int mmap_page_array(const struct vm_area_struct *vma, struct pagearray *pages, const size_t offset, const size_t length)
+{
+	return -ENOSYS;
+}
+#endif
+EXPORT_SYMBOL(mmap_page_array);
+
+static int copy_page_array(struct pagearray *pages, char __user *buf, const size_t offset, const size_t length, const int rw)
+{
+	size_t pos = 0, off = offset, remaining = length;
+	int k;
+
+	if (length > pages->length)
+		return -EFAULT;
+	else if (length > MM_VM_SIZE(current->mm))
+		return -EFAULT;
+	else if ((unsigned long)buf > MM_VM_SIZE(current->mm) - length)
+		return -EFAULT;
+
+	for (k = off >> PAGE_SHIFT; k < pages->nr_pages && remaining > 0; ++k) {
+		unsigned long left, tail, suboff = off & PAGE_MASK;
+		char *kbuf = kmap_atomic(pages->pages[k], KM_USER0);
+		tail = min(PAGE_SIZE - suboff, (unsigned long)remaining);
+		if (rw)
+			left = __copy_to_user(&buf[pos], &kbuf[suboff], tail);
+		else
+			left = __copy_from_user(&kbuf[suboff], &buf[pos], tail);
+		kunmap_atomic(kbuf, KM_USER0);
+		if (left) {
+			kbuf = kmap(pages->pages[k]);
+			if (rw)
+				left = __copy_to_user(&buf[pos], &kbuf[suboff], tail);
+			else
+				left = __copy_from_user(&kbuf[suboff], &buf[pos], tail);
+			kunmap(pages->pages[k]);
+		}
+		BUG_ON(tail - left > remaining);
+		remaining -= tail - left;
+		pos += tail - left;
+		off = (off + PAGE_SIZE) & PAGE_MASK;
+		if (left)
+			break;
+	}
+	return remaining;
+}
+
+/**
+ * copy_page_array_to_user - copy data from a page array to userspace
+ * @pages: the array of page pointers holding the data
+ * @buf: the user virtual address to start depositing the data at
+ * @offset: the offset into the page array to start copying data from
+ * @length: how much data to copy
+ *
+ * Copy data from a page array, starting offset bytes into the array
+ * when it's treated as a list of the pieces of an object in order,
+ * to userspace.
+ */
+int copy_page_array_to_user(struct pagearray *pages, void __user *buf, const size_t offset, const size_t length)
+{
+	return copy_page_array(pages, buf, offset, length, 1);
+}
+EXPORT_SYMBOL(copy_page_array_to_user);
+
+/**
+ * copy_page_array_from_user - copy data from userspace to a page array
+ * @pages: the array of page pointers holding the data
+ * @buf: the user virtual address to start reading the data from
+ * @offset: the offset into the page array to start copying data to
+ * @length: how much data to copy
+ *
+ * Copy data to a page array, starting offset bytes into the array
+ * when it's treated as a list of the pieces of an object in order,
+ * from userspace.
+ */
+int copy_page_array_from_user(struct pagearray *pages, void __user *buf, const size_t offset, const size_t length)
+{
+	return copy_page_array(pages, buf, offset, length, 0);
+}
+EXPORT_SYMBOL(copy_page_array_from_user);
+
+/**
+ * pagearray_to_scatterlist - generate a scatterlist for a slice of a pagearray
+ * @pages: the pagearray to make a scatterlist for
+ * @offset: the offset into the pagearray of the start of the slice
+ * @length: the length of the slice of the pagearray
+ * @sglist_len: the size of the generated scatterlist
+ *
+ * Set up a scatterlist covering a slice of a pagearray, starting at offset
+ * bytes into the pagearray, with length length.
+ */
+struct scatterlist *pagearray_to_scatterlist(struct pagearray *pages, size_t offset, size_t length, int *sglist_len)
+{
+	struct scatterlist *sg;
+	int i, nr_pages =
+		(PAGE_ALIGN(offset + length) - (offset & PAGE_MASK))/PAGE_SIZE;
+	sg = kmalloc(nr_pages * sizeof(struct scatterlist), GFP_KERNEL);
+	if (!sg)
+		return NULL;
+	memset(sg, 0, nr_pages * sizeof(struct scatterlist));
+	sg[0].page = pages->pages[offset >> PAGE_SHIFT];
+	sg[0].offset = offset & ~PAGE_MASK;
+	sg[0].length = PAGE_SIZE - sg[0].offset;
+	offset = (offset + PAGE_SIZE) & PAGE_MASK;
+	for (i = 1; i < nr_pages - 1; ++i) {
+		sg[i].page = pages->pages[i];
+		sg[i].length = PAGE_SIZE;
+	}
+	sg[i].page = pages->pages[i];
+	sg[i].length = (offset + length) & ~PAGE_MASK;
+	*sglist_len = nr_pages;
+	return sg;
+}
+EXPORT_SYMBOL(pagearray_to_scatterlist);
+
+void *vmap_pagearray(struct pagearray *pages)
+{
+	return vmap(pages->pages, pages->nr_pages, VM_MAP, PAGE_KERNEL);
+}
+EXPORT_SYMBOL(vmap_pagearray);
