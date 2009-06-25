Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZFYJ7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZFYJ7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZFYJ7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:59:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbZFYJ67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:58:59 -0400
Subject: [PATCH] clarify get_user_pages() prototype
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <1245897826.2560.421.camel@ymzhang>
References: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain>
	 <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain>
	 <alpine.LFD.2.00.0906242146500.2767@localhost.localdomain>
	 <1245897826.2560.421.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Jun 2009 11:58:55 +0200
Message-Id: <1245923935.31755.104.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 10:43 +0800, Zhang, Yanmin wrote:

> > +static int fault_in_user_writeable(u32 __user *uaddr)
> > +{
> > +	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
> > +				 sizeof(*uaddr), 1, 0, NULL, NULL);
> The 4th parameter of get_user_pages means page number. ﻿sizeof(*uaddr) is equal to
> 4, so you want 4 pages?

crap... that's what you get for only looking at the prototype :/

---
Subject: clarify get_user_pages() prototype

Currently the 4th parameter of get_user_pages() is called len, but its
in pages, not bytes. Rename the thing to nr_pages to avoid future
confusion.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mm.h |    2 +-
 mm/memory.c        |   26 ++++++++++++--------------
 mm/nommu.c         |   12 +++++-------
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d006e93..ba3a7cb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -826,7 +826,7 @@ extern int make_pages_present(unsigned long addr, unsigned long end);
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-			unsigned long start, int len, int write, int force,
+			unsigned long start, int nr_pages, int write, int force,
 			struct page **pages, struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
diff --git a/mm/memory.c b/mm/memory.c
index f46ac18..6521619 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1207,8 +1207,8 @@ static inline int use_zero_page(struct vm_area_struct *vma)
 
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int len, int flags,
-		struct page **pages, struct vm_area_struct **vmas)
+		     unsigned long start, int nr_pages, int flags,
+		     struct page **pages, struct vm_area_struct **vmas)
 {
 	int i;
 	unsigned int vm_flags = 0;
@@ -1217,7 +1217,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 	int ignore_sigkill = !!(flags & GUP_FLAGS_IGNORE_SIGKILL);
 
-	if (len <= 0)
+	if (nr_pages <= 0)
 		return 0;
 	/* 
 	 * Require read or write permissions.
@@ -1269,7 +1269,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				vmas[i] = gate_vma;
 			i++;
 			start += PAGE_SIZE;
-			len--;
+			nr_pages--;
 			continue;
 		}
 
@@ -1280,7 +1280,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
-						&start, &len, i, write);
+						&start, &nr_pages, i, write);
 			continue;
 		}
 
@@ -1357,9 +1357,9 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				vmas[i] = vma;
 			i++;
 			start += PAGE_SIZE;
-			len--;
-		} while (len && start < vma->vm_end);
-	} while (len);
+			nr_pages--;
+		} while (nr_pages && start < vma->vm_end);
+	} while (nr_pages);
 	return i;
 }
 
@@ -1368,7 +1368,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
  * @tsk:	task_struct of target task
  * @mm:		mm_struct of target mm
  * @start:	starting user address
- * @len:	number of pages from start to pin
+ * @nr_pages:	number of pages from start to pin
  * @write:	whether pages will be written to by the caller
  * @force:	whether to force write access even if user mapping is
  *		readonly. This will result in the page being COWed even
@@ -1380,7 +1380,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
  *		Or NULL if the caller does not require them.
  *
  * Returns number of pages pinned. This may be fewer than the number
- * requested. If len is 0 or negative, returns 0. If no pages
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
  * were pinned, returns -errno. Each page returned must be released
  * with a put_page() call when it is finished with. vmas will only
  * remain valid while mmap_sem is held.
@@ -1414,7 +1414,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
  * See also get_user_pages_fast, for performance critical applications.
  */
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, int len, int write, int force,
+		unsigned long start, int nr_pages, int write, int force,
 		struct page **pages, struct vm_area_struct **vmas)
 {
 	int flags = 0;
@@ -1424,9 +1424,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	if (force)
 		flags |= GUP_FLAGS_FORCE;
 
-	return __get_user_pages(tsk, mm,
-				start, len, flags,
-				pages, vmas);
+	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
 }
 
 EXPORT_SYMBOL(get_user_pages);
diff --git a/mm/nommu.c b/mm/nommu.c
index 2fd2ad5..bf0cc76 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -173,8 +173,8 @@ unsigned int kobjsize(const void *objp)
 }
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int len, int flags,
-		struct page **pages, struct vm_area_struct **vmas)
+		     unsigned long start, int nr_pages, int flags,
+		     struct page **pages, struct vm_area_struct **vmas)
 {
 	struct vm_area_struct *vma;
 	unsigned long vm_flags;
@@ -189,7 +189,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	vm_flags  = write ? (VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
 	vm_flags &= force ? (VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
 
-	for (i = 0; i < len; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		vma = find_vma(mm, start);
 		if (!vma)
 			goto finish_or_fault;
@@ -224,7 +224,7 @@ finish_or_fault:
  * - don't permit access to VMAs that don't support it, such as I/O mappings
  */
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-	unsigned long start, int len, int write, int force,
+	unsigned long start, int nr_pages, int write, int force,
 	struct page **pages, struct vm_area_struct **vmas)
 {
 	int flags = 0;
@@ -234,9 +234,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	if (force)
 		flags |= GUP_FLAGS_FORCE;
 
-	return __get_user_pages(tsk, mm,
-				start, len, flags,
-				pages, vmas);
+	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
 }
 EXPORT_SYMBOL(get_user_pages);
 

