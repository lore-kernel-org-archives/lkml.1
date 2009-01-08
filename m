Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZAHESx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZAHESx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZAHESo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:18:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZAHESn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:18:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=V5Lg5aA9rtp4hT69lLMs/9tLC10rlB5AuMKi6ItS+bLdOBk+PXRgVItBqaurI4MP5
	lDmidXXfSu1DiaUI5ztGA==
MIME-Version: 1.0
In-Reply-To: <6991.1231194895@turing-police.cc.vt.edu>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090105010726.c0433fea.akpm@linux-foundation.org>
	 <6991.1231194895@turing-police.cc.vt.edu>
Date: Wed, 7 Jan 2009 20:18:34 -0800
Message-ID: <604427e00901072018o42ff0627yb5282f2a81a13c65@mail.gmail.com>
Subject: Re: 2.6.29 -mm merge plans
From: Ying Han <yinghan@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.75
X-GMailtapped: yinghan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis:
     Please try this fix and i tested on ubunbu8.10 with xmms and it helps.

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9e268b6..f4bbd9b 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -593,6 +593,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigne
 	unsigned long flags;
 	int sig;
 #endif
+	unsigned int retry_flag = FAULT_FLAG_RETRY;

 	tsk = current;
 	mm = tsk->mm;
@@ -690,6 +691,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigne
 		down_read(&mm->mmap_sem);
 	}

+retry:
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -716,6 +718,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigne
 good_area:
 	si_code = SEGV_ACCERR;
 	write = 0;
+	write |= retry_flag;
 	switch (error_code & (PF_PROT|PF_WRITE)) {
 	default:	/* 3: write, present */
 		/* fall through */
@@ -744,6 +747,21 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
+
+	/*
+	 * Here we retry fault once and switch to synchronous mode. The
+	 * main reason is to prevent us from the cases of starvation.
+	 * The retry logic open a starvation hole in which case pages might
+	 * be removed or changed after the retry.
+	 */
+	if (fault & VM_FAULT_RETRY) {
+		if (write & FAULT_FLAG_RETRY) {
+			retry_flag &= ~FAULT_FLAG_RETRY;
+			goto retry;
+		}
+		BUG();
+	}
+
 	if (fault & VM_FAULT_MAJOR)
 		tsk->maj_flt++;
 	else
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4a3d28c..be770f9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -144,6 +144,7 @@ extern pgprot_t protection_map[16];

 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping */
+#define FAULT_FLAG_RETRY	0x04	/* Retry major fault */

 /*
  * This interface is used by x86 PAT code to identify a pfn mapping that is
@@ -707,6 +708,7 @@ static inline int page_mapped(struct page *page)

 #define VM_FAULT_MINOR	0 /* For backwards compat. Remove me quickly. */

+#define VM_FAULT_RETRY	0x0010
 #define VM_FAULT_OOM	0x0001
 #define VM_FAULT_SIGBUS	0x0002
 #define VM_FAULT_MAJOR	0x0004
diff --git a/mm/filemap.c b/mm/filemap.c
index 2f55a1e..aed5a3f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -714,6 +714,58 @@ repeat:
 EXPORT_SYMBOL(find_lock_page);

 /**
+ * find_lock_page_retry - locate, pin and lock a pagecache page
+ * @mapping: the address_space to search
+ * @offset: the page index
+ * @vma: vma in which the fault was taken
+ * @ppage: zero if page not present, otherwise point to the page in pagecache
+ * @retry: 1 indicate caller tolerate a retry.
+ *
+ * If retry flag is on, and page is already locked by someone else, return
+ * a hint of retry.
+ *
+ * Return *ppage==NULL if page is not in pagecache. Otherwise return *ppage
+ * points to the page in the pagecache with ret=VM_FAULT_RETRY indicate a
+ * hint to caller for retry, or ret=0 which means page is succefully
+ * locked.
+ */
+unsigned find_lock_page_retry(struct address_space *mapping, pgoff_t offset,
+				struct vm_area_struct *vma, struct page **ppage,
+				int retry)
+{
+	unsigned int ret = 0;
+	struct page *page;
+
+repeat:
+	page = find_get_page(mapping, offset);
+	if (page) {
+		if (!retry)
+			lock_page(page);
+		else {
+			if (!trylock_page(page)) {
+				struct mm_struct *mm = vma->vm_mm;
+
+				up_read(&mm->mmap_sem);
+				wait_on_page_locked(page);
+				down_read(&mm->mmap_sem);
+
+				page_cache_release(page);
+				return VM_FAULT_RETRY;
+			}
+		}
+		if (unlikely(page->mapping != mapping)) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto repeat;
+		}
+		VM_BUG_ON(page->index != offset);
+	}
+	*ppage = page;
+	return ret;
+}
+EXPORT_SYMBOL(find_lock_page_retry);
+
+/**
  * find_or_create_page - locate or add a pagecache page
  * @mapping: the page's address_space
  * @index: the page's index into the mapping
@@ -1452,6 +1504,8 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_
 	pgoff_t size;
 	int did_readaround = 0;
 	int ret = 0;
+	int retry_flag = vmf->flags & FAULT_FLAG_RETRY;
+	int retry_ret;

 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
@@ -1466,6 +1520,8 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_
 	 */
 retry_find:
 	page = find_lock_page(mapping, vmf->pgoff);
+
+retry_find_nopage:
 	/*
 	 * For sequential accesses, we use the generic readahead logic.
 	 */
@@ -1473,9 +1529,12 @@ retry_find:
 		if (!page) {
 			page_cache_sync_readahead(mapping, ra, file,
 							   vmf->pgoff, 1);
-			page = find_lock_page(mapping, vmf->pgoff);
+			retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
+						vma, &page, retry_flag);
 			if (!page)
 				goto no_cached_page;
+			if (retry_ret == VM_FAULT_RETRY)
+				return retry_ret;
 		}
 		if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping, ra, file, page,
@@ -1512,14 +1571,18 @@ retry_find:
 				start = vmf->pgoff - ra_pages / 2;
 			do_page_cache_readahead(mapping, file, start, ra_pages);
 		}
-		page = find_lock_page(mapping, vmf->pgoff);
+		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
+				vma, &page, retry_flag);
 		if (!page)
 			goto no_cached_page;
+		if (retry_ret == VM_FAULT_RETRY)
+			return retry_ret;
 	}

 	if (!did_readaround)
 		ra->mmap_miss--;

+retry_page_update:
 	/*
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
@@ -1554,8 +1617,23 @@ no_cached_page:
 	 * In the unlikely event that someone removed it in the
 	 * meantime, we'll just come back here and read it again.
 	 */
-	if (error >= 0)
-		goto retry_find;
+	if (error >= 0) {
+		/*
+		 * If caller cannot tolerate a retry in the ->fault path
+		 * go back to check the page again.
+		 */
+		if (!retry_flag)
+			goto retry_find;
+
+		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
+					vma, &page, retry_flag);
+		if (!page)
+			goto retry_find_nopage;
+		else if (retry_ret == VM_FAULT_RETRY)
+			return retry_ret;
+		else
+			goto retry_page_update;
+	}

 	/*
 	 * An error return from page_cache_read can result if the
diff --git a/mm/memory.c b/mm/memory.c
index 3f8fa06..534ba1d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2572,6 +2572,13 @@ static int __do_fault(struct mm_struct *mm, struct vm_a
 	vmf.page = NULL;

 	ret = vma->vm_ops->fault(vma, &vmf);
+
+	/* page may be available, but we have to restart the process
+	 * because mmap_sem was dropped during the ->fault
+	 */
+	if (ret & VM_FAULT_RETRY)
+		return ret;
+
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;

@@ -2713,8 +2720,10 @@ static int do_linear_fault(struct mm_struct *mm, struct
 {
 	pgoff_t pgoff = (((address & PAGE_MASK)
 			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
+	int write = write_access & ~FAULT_FLAG_RETRY;
+	unsigned int flags = (write ? FAULT_FLAG_WRITE : 0);

+	flags |= (write_access & FAULT_FLAG_RETRY);
 	pte_unmap(page_table);
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }


On Mon, Jan 5, 2009 at 2:34 PM, <Valdis.Kletnieks@vt.edu> wrote:
>
> On Mon, 05 Jan 2009 01:07:26 PST, Andrew Morton said:
> > (cc's added)
> >
> > On Mon,  5 Jan 2009 18:00:33 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.
> fujitsu.com> wrote:
> >
> > > > #
> > > > page_fault-retry-with-nopage_retry.patch
> > > > page_fault-retry-with-nopage_retry-fix.patch
> > > > page_fault-retry-with-nopage_retry-fix-fix.patch
> > >
> > > I oppose this.
> > >
> > > Valdis.Kletnieks@vt.edu reported this patch has bug in
> > > "28-rc9-mmotm1219 page_fault-retry-with-nopage_retry.patch hoses xmms"
> > > thread.
> > >
> > > Nobody answer his question yet.
> >
> > OK, thanks.  I actually thought we'd fixed that?
>
> I'll check mmotm-0105 later tonight, I was still seeing the issue in -1230.
