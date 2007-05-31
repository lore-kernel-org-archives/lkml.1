Return-Path: <linux-kernel-owner+w=401wt.eu-S1760558AbXEaTn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbXEaTn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbXEaTnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:43:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49799 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011AbXEaTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:43:20 -0400
Message-ID: <465F2554.2030104@oracle.com>
Date: Thu, 31 May 2007 12:43:16 -0700
From: Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070418)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mm: include private data mappings in RLIMIT_DATA limit
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch I would like to submit for limiting process private 
memory allocations via setrlimit(RLIMIT_DATA).

Thanks,
Herbert van den Bergh.


This patch changes how the kernel limits memory allocations that are
controlled by setrlimit() using the RLIMIT_DATA resource.  Currently the
kernel can limit the size of a process data, bss, and heap, but does not
limit the amount of process private memory that can be allocated with
the mmap() call.  Since malloc() calls mmap() to allocate process memory
once brk() calls can no longer grow the heap, process private memory
allocations cannot be limited with RLIMIT_DATA.

With this patch, not only memory in the data segment of a process, but
also private data mappings, both file-based and anonymous, are counted
toward the RLIMIT_DATA resource limit.  Executable mappings, such as
text segments of shared objects, are not counted toward the private data
limit.  The result is that malloc() will fail once the combined size of
the data segment and private data mappings reaches this limit.

This brings the Linux behavior in line with what is documented in the
POSIX man page for setrlimit(3p).

Signed-off-by: Herbert van den Bergh (herbert.van.den.bergh@oracle.com)
Signed-off-by: Dave McCracken (dave.mccracken@oracle.com)

----------------------------------------------------------------------------------
--- linux-2.6.21/fs/proc/task_mmu.c.orig        2007-05-29 21:05:31.000000000 -0700
+++ linux-2.6.21/fs/proc/task_mmu.c     2007-05-30 08:17:44.000000000 -0700
@@ -31,7 +31,7 @@
        if (hiwater_rss < mm->hiwater_rss)
                hiwater_rss = mm->hiwater_rss;

-       data = mm->total_vm - mm->shared_vm - mm->stack_vm;
+       data = mm->total_vm - mm->shared_vm - mm->stack_vm - mm->exec_vm;
        text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
        lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
        buffer += sprintf(buffer,
--- linux-2.6.21/mm/mprotect.c.orig     2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21/mm/mprotect.c  2007-05-30 08:34:36.000000000 -0700
@@ -162,6 +162,21 @@
                }
        }

+        /*
+        * Check against private data size limit. When execute permission
+        * is removed, the mapping is counted toward the private data size.
+        */
+       if (!(newflags & VM_EXEC) && (vma->vm_flags & VM_EXEC)) {
+               unsigned long rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+               if (rlim < RLIM_INFINITY) {
+                       unsigned long priv_vm;
+                       priv_vm = mm->total_vm - mm->shared_vm - mm->exec_vm;
+                       priv_vm <<= PAGE_SHIFT;
+                       if (priv_vm + (end - start) > rlim)
+                               return -ENOMEM;
+               }
+        }
+
        /*
         * First try to merge with previous and/or next vma.
         */
--- linux-2.6.21/mm/mremap.c.orig       2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21/mm/mremap.c    2007-05-30 08:38:28.000000000 -0700
@@ -343,6 +343,22 @@
                goto out;
        }

+        /*
+        * Check against private data size limit. Count memory allocations
+        * which are not shared and not executable code as private data.
+        */
+       if (!(vma->vm_flags & (VM_EXEC|VM_SHARED))) {
+               unsigned long rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+               if (rlim < RLIM_INFINITY) {
+                       unsigned long priv_vm;
+                       struct mm_struct *mm = current->mm;
+                       priv_vm = mm->total_vm - mm->shared_vm - mm->exec_vm;
+                       priv_vm <<= PAGE_SHIFT;
+                       if (priv_vm + (new_len - old_len) > rlim)
+                               goto out;
+               }
+        }
+
        if (vma->vm_flags & VM_ACCOUNT) {
                charged = (new_len - old_len) >> PAGE_SHIFT;
                if (security_vm_enough_memory(charged))
--- linux-2.6.21/mm/mmap.c.orig 2007-05-29 21:05:58.000000000 -0700
+++ linux-2.6.21/mm/mmap.c      2007-05-30 08:27:55.000000000 -0700
@@ -245,16 +245,6 @@
        if (brk < mm->end_code)
                goto out;

-       /*
-        * Check against rlimit here. If this check is done later after the test
-        * of oldbrk with newbrk then it can escape the test and let the data
-        * segment grow beyond its set limit the in case where the limit is
-        * not page aligned -Ram Gupta
-        */
-       rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
-       if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
-               goto out;
-
        newbrk = PAGE_ALIGN(brk);
        oldbrk = PAGE_ALIGN(mm->brk);
        if (oldbrk == newbrk)
@@ -267,6 +257,18 @@
                goto out;
        }

+        /*
+        * Check against private data size limit. Count memory allocations
+        * which are not shared and not executable code as private data.
+        */
+        rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+        if (rlim < RLIM_INFINITY) {
+            unsigned long priv_vm;
+            priv_vm = (mm->total_vm - mm->shared_vm - mm->exec_vm) << PAGE_SHIFT;
+            if (priv_vm + (newbrk-oldbrk) > rlim)
+                goto out;
+        }
+
        /* Check against existing mmap mappings. */
        if (find_vma_intersection(mm, oldbrk, newbrk+PAGE_SIZE))
                goto out;
@@ -875,7 +877,8 @@
                = VM_STACK_FLAGS & (VM_GROWSUP|VM_GROWSDOWN);

        if (file) {
-               mm->shared_vm += pages;
+               if (flags & VM_SHARED)
+                       mm->shared_vm += pages;
                if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
                        mm->exec_vm += pages;
        } else if (flags & stack_flags)
@@ -1041,6 +1044,20 @@
        if (!may_expand_vm(mm, len >> PAGE_SHIFT))
                return -ENOMEM;

+        /*
+        * Check against private data size limit. Count memory allocations
+        * which are not shared and not executable code as private data.
+        */
+       if (!(vm_flags & (VM_SHARED|VM_EXEC))) {
+            unsigned long rlim, priv_vm;
+            rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+           if (rlim < RLIM_INFINITY) {
+                priv_vm = (mm->total_vm - mm->shared_vm - mm->exec_vm) << PAGE_SHIFT;
+                if (priv_vm + len > rlim)
+                   return -ENOMEM;
+            }
+        }
+
        if (accountable && (!(flags & MAP_NORESERVE) ||
                            sysctl_overcommit_memory == OVERCOMMIT_NEVER)) {
                if (vm_flags & VM_SHARED) {


