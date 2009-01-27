Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZA0L1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZA0L1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZA0L1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:27:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50707 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZA0L1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:27:36 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 36/51] revert "mm: vmalloc use mutex for purge"
Cc: kosaki.motohiro@jp.fujitsu.com, Christophe Saout <christophe@saout.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1232982471.7679.76.camel@lts-notebook>
References: <20090127163443.1BEC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1232982471.7679.76.camel@lts-notebook>
Message-Id: <20090127201836.D48E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 20:27:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > hm, I guess you test both UNEVICTABLE_LRU on/off and this problem 
> > happend only if CONFIG_UNEVICTABLE_LRU=y, right?
> > 
> > if so, I really wonder this result.
> > above mean the page have both following two condition.
> > 
> >  - vma of the page have VM_LOCKED flag.
> >  - pte of the page is NOT present
> > 
> > I can't imazine how to reproduce it.
> > Could you please tell me how to reproduce? (sorry, I don't know xen at all)
> 
> I'm in the same boat, vis a vis xen.  But, if xen has cleared the ptes
> in the process of tearing down the mm before we try to munlock the vmas
> in exit_mmap(), we'll see this situation.   The munlock code assumes
> that VM_LOCKED vmas were fully populated when mlocked, so
> get_user_pages() should always find and return resident pages.  If it
> does find a non-present pte, get_user_pages() will try to fault it
> in--answering Christophe's confusion about getting into swap code.  
> 
> Now, we could let get_user_pages() ignore non-present pte's when called
> for munlock [we can detect this condition], but that would probably
> strand pages on the unevictable lru.  We've been careful, so far, not to
> let this happen. 

No problem :)

Fortunately, current swap-in logic always move the page into anon list, 
never unevictable list.
Then, I think current code is race free.



> Hmmm, we may need to ignore non-present pte during munlock() to handle
> the case where the task was OOM-killed during mlock()--or SIGKILLed, now
> that get_user_pages() is "preemptible"--leaving a partially populated
> vma.  But, we need to be sure that any resident pages mlocked by the vma
> do get munlocked.  Need to think about this more.

Oh, very good point.
I understand this issue doesn't only happend on xen, but also happend on
native linux.

How about following patch?

> In any case, if xen wants to tear down an mm with VM_LOCKED vmas
> independent of exit_mmap() [and I don't understand why it needs to do
> this], then it must also take the responsibility to munlock any pages
> mapped into that vma, while the mm and ptes are still intact, and then
> clear the VM_LOCKED so we don't try to munlock them later.  A call to
> munlock_vma_pages_all() for each VM_LOCKED vma should handle this.   See
> exit_mmap().

Yup, I also don't understand why xen does so strangeness.



Andrew, please don't pick up this patch yet.
I want to test on stress workload awhile.


====
Subject: [RFC][PATCH] munlock don't page fault

Recently, mlock() become to be able to be interrupted by SIGKILL.
at that time, (vma->vm_flags & VM_LOCKED) don't guarantee that 
the page resident on memory.

unfortunately, current munlock logic assume it.
then if the process is killed during mlock()ing, unlocking processing
(via exit_mmap) can cause page fault and unnecessary page allocation.

Definitly, it's wrong.
  

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/internal.h |    1 +
 mm/memory.c   |   11 +++++++++--
 mm/mlock.c    |   38 +++++++++++++++++++++++---------------
 3 files changed, 33 insertions(+), 17 deletions(-)

Index: b/mm/internal.h
===================================================================
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -277,6 +277,7 @@ static inline void mminit_validate_memmo
 #define GUP_FLAGS_FORCE                  0x2
 #define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
 #define GUP_FLAGS_IGNORE_SIGKILL         0x8
+#define GUP_FLAGS_NO_PAGEFAULT		 0x10
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int len, int flags,
Index: b/mm/memory.c
===================================================================
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1211,6 +1211,7 @@ int __get_user_pages(struct task_struct 
 	int force = !!(flags & GUP_FLAGS_FORCE);
 	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 	int ignore_sigkill = !!(flags & GUP_FLAGS_IGNORE_SIGKILL);
+	int no_pagefault = !!(flags & GUP_FLAGS_NO_PAGEFAULT);
 
 	if (len <= 0)
 		return 0;
@@ -1305,6 +1306,10 @@ int __get_user_pages(struct task_struct 
 			cond_resched();
 			while (!(page = follow_page(vma, start, foll_flags))) {
 				int ret;
+
+				if (no_pagefault)
+					break;
+
 				ret = handle_mm_fault(mm, vma, start,
 						foll_flags & FOLL_WRITE);
 				if (ret & VM_FAULT_ERROR) {
@@ -1342,8 +1347,10 @@ int __get_user_pages(struct task_struct 
 			if (pages) {
 				pages[i] = page;
 
-				flush_anon_page(vma, page, start);
-				flush_dcache_page(page);
+				if (page) {
+					flush_anon_page(vma, page, start);
+					flush_dcache_page(page);
+				}
 			}
 			if (vmas)
 				vmas[i] = vma;
Index: b/mm/mlock.c
===================================================================
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -161,7 +161,8 @@ static long __mlock_vma_pages_range(stru
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
 	struct page *pages[16]; /* 16 gives a reasonable batch */
-	int nr_pages = (end - start) / PAGE_SIZE;
+	int remain_pages;
+	int nr_batch;
 	int ret = 0;
 	int gup_flags = 0;
 
@@ -173,18 +174,21 @@ static long __mlock_vma_pages_range(stru
 		  (atomic_read(&mm->mm_users) != 0));
 
 	/*
-	 * mlock:   don't page populate if vma has PROT_NONE permission.
-	 * munlock: always do munlock although the vma has PROT_NONE
+	 * mlock:   Don't page populate if vma has PROT_NONE permission.
+	 * munlock: Always do munlock although the vma has PROT_NONE
 	 *          permission, or SIGKILL is pending.
+	 *          In addition, don't interrupted by SIGKILL and don't swap-in
+	 *	    if the page is swapped.
 	 */
 	if (!mlock)
 		gup_flags |= GUP_FLAGS_IGNORE_VMA_PERMISSIONS |
-			     GUP_FLAGS_IGNORE_SIGKILL;
+			     GUP_FLAGS_IGNORE_SIGKILL |
+			     GUP_FLAGS_NO_PAGEFAULT;
 
 	if (vma->vm_flags & VM_WRITE)
 		gup_flags |= GUP_FLAGS_WRITE;
 
-	while (nr_pages > 0) {
+	while (addr < end) {
 		int i;
 
 		cond_resched();
@@ -195,9 +199,12 @@ static long __mlock_vma_pages_range(stru
 		 * disable migration of this page.  However, page may
 		 * still be truncated out from under us.
 		 */
-		ret = __get_user_pages(current, mm, addr,
-				min_t(int, nr_pages, ARRAY_SIZE(pages)),
-				gup_flags, pages, NULL);
+		remain_pages = (end - addr) / PAGE_SIZE;
+		nr_batch = min_t(int, remain_pages, ARRAY_SIZE(pages));
+		ret = __get_user_pages(current, mm, addr, nr_batch,
+				       gup_flags, pages, NULL);
+		addr += nr_batch * PAGE_SIZE;
+
 		/*
 		 * This can happen for, e.g., VM_NONLINEAR regions before
 		 * a page has been allocated and mapped at a given offset,
@@ -221,6 +228,13 @@ static long __mlock_vma_pages_range(stru
 		for (i = 0; i < ret; i++) {
 			struct page *page = pages[i];
 
+			/*
+			 * if the process killed during mlock()ing,
+			 * the page can be NULL.
+			 */
+			if (!page)
+				continue;
+
 			lock_page(page);
 			/*
 			 * Because we lock page here and migration is blocked
@@ -235,14 +249,8 @@ static long __mlock_vma_pages_range(stru
 			}
 			unlock_page(page);
 			put_page(page);		/* ref from get_user_pages() */
-
-			/*
-			 * here we assume that get_user_pages() has given us
-			 * a list of virtually contiguous pages.
-			 */
-			addr += PAGE_SIZE;	/* for next get_user_pages() */
-			nr_pages--;
 		}
+
 		ret = 0;
 	}
 


