Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZG1Iq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZG1Iq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 04:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZG1Iq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 04:46:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52923 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbZG1Iq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 04:46:27 -0400
Date: Tue, 28 Jul 2009 18:46:13 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: rdreier@cisco.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: perf_counter: Track all mmaps, heap and stack extensions
Message-ID: <20090728084612.GA4603@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Right now perf_counter only logs executable mmaps. While this is enough
for instruction profiling, at some stage we are also going to want
to do data profiling. This will require us to log non-executable mmaps as
well as stack and heap extensions.

Why would we care about heap and stack? A few examples:

1. We can monitor TLB miss rates to suggest what regions of memory should be
   put into hugepages.
 
2. We can look into various TLB miss issues. On PowerPC a data prefetch
   that goes to an unmapped area takes a significant amount of time (it
   initiates a tablewalk that may take 40+ cycles). With accurate mapping
   data we can catch areas of code with bad prefetch instructions.

Taking it a bit further, since in some sense perf_counter is a channel for
getting events out to userspace, I wonder if we could solve Roland's RDMA
address space unmap issue with perf_counter:

http://patchwork.kernel.org/patch/37267/

Below is a dodgy hack I've been using to prototype tracking of all mmaps
and heap/stack extensions. Naturally we'd want a perf_counter feature to turn
this on and keep instruction profiles more compact. We'd also want munmap
events.

The only tricky part is having to set start_stack before we call expand_stack
for the first time, so we can easily identify it in perf_counter_mmap_event.

Thoughts?

Anton
---

Index: linux.trees.git/mm/mmap.c
===================================================================
--- linux.trees.git.orig/mm/mmap.c	2009-07-27 10:45:37.000000000 +1000
+++ linux.trees.git/mm/mmap.c	2009-07-27 10:49:18.000000000 +1000
@@ -1680,6 +1680,7 @@ static int expand_downwards(struct vm_ar
 		if (!error) {
 			vma->vm_start = address;
 			vma->vm_pgoff -= grow;
+			perf_counter_mmap(vma);
 		}
 	}
 	anon_vma_unlock(vma);
@@ -2071,6 +2072,7 @@ unsigned long do_brk(unsigned long addr,
 	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 out:
+	perf_counter_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED) {
 		if (!mlock_vma_pages_range(vma, addr, addr + len))
Index: linux.trees.git/include/linux/perf_counter.h
===================================================================
--- linux.trees.git.orig/include/linux/perf_counter.h	2009-07-27 10:48:58.000000000 +1000
+++ linux.trees.git/include/linux/perf_counter.h	2009-07-27 10:49:18.000000000 +1000
@@ -702,8 +702,7 @@ extern void __perf_counter_mmap(struct v
 
 static inline void perf_counter_mmap(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_EXEC)
-		__perf_counter_mmap(vma);
+	__perf_counter_mmap(vma);
 }
 
 extern void perf_counter_comm(struct task_struct *tsk);
Index: linux.trees.git/kernel/perf_counter.c
===================================================================
--- linux.trees.git.orig/kernel/perf_counter.c	2009-07-27 10:48:58.000000000 +1000
+++ linux.trees.git/kernel/perf_counter.c	2009-07-27 10:49:18.000000000 +1000
@@ -3142,6 +3142,14 @@ static void perf_counter_mmap_event(stru
 		if (!vma->vm_mm) {
 			name = strncpy(tmp, "[vdso]", sizeof(tmp));
 			goto got_name;
+		} else if (vma->vm_start <= vma->vm_mm->start_brk &&
+				vma->vm_end >= vma->vm_mm->brk) {
+			name = strncpy(tmp, "[heap]", sizeof(tmp));
+			goto got_name;
+		} else if (vma->vm_start <= vma->vm_mm->start_stack &&
+				vma->vm_end >= vma->vm_mm->start_stack) {
+			name = strncpy(tmp, "[stack]", sizeof(tmp));
+			goto got_name;
 		}
 
 		name = strncpy(tmp, "//anon", sizeof(tmp));
Index: linux.trees.git/fs/exec.c
===================================================================
--- linux.trees.git.orig/fs/exec.c	2009-07-27 10:49:17.000000000 +1000
+++ linux.trees.git/fs/exec.c	2009-07-27 10:49:18.000000000 +1000
@@ -631,6 +631,7 @@ int setup_arg_pages(struct linux_binprm 
 #else
 	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
 #endif
+	current->mm->start_stack = bprm->p;
 	ret = expand_stack(vma, stack_base);
 	if (ret)
 		ret = -EFAULT;
