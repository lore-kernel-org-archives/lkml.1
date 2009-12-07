Return-Path: <linux-kernel-owner+w=401wt.eu-S934652AbZLGD4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbZLGD4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934589AbZLGD4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:56:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51476 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172AbZLGDwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:52:55 -0500
Date: Mon, 07 Dec 2009 03:53:00 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 7/19] kill useless checks in sparc mremap variants
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUei-0007w8-Pa@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/sys_sparc32.c  |   22 ----------------------
 arch/sparc/kernel/sys_sparc_32.c |   21 ---------------------
 arch/sparc/kernel/sys_sparc_64.c |    6 ------
 arch/sparc/kernel/systbls_32.S   |    2 +-
 arch/sparc/kernel/systbls_64.S   |    2 +-
 5 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index 04e28b2..e671be3 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -569,28 +569,6 @@ asmlinkage long sparc32_open(const char __user *filename,
 	return do_sys_open(AT_FDCWD, filename, flags, mode);
 }
 
-extern unsigned long do_mremap(unsigned long addr,
-	unsigned long old_len, unsigned long new_len,
-	unsigned long flags, unsigned long new_addr);
-                
-asmlinkage unsigned long sys32_mremap(unsigned long addr,
-	unsigned long old_len, unsigned long new_len,
-	unsigned long flags, u32 __new_addr)
-{
-	unsigned long ret = -EINVAL;
-	unsigned long new_addr = __new_addr;
-
-	if (unlikely(sparc_mmap_check(addr, old_len)))
-		goto out;
-	if (unlikely(sparc_mmap_check(new_addr, new_len)))
-		goto out;
-	down_write(&current->mm->mmap_sem);
-	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
-	up_write(&current->mm->mmap_sem);
-out:
-	return ret;       
-}
-
 struct __sysctl_args32 {
 	u32 name;
 	int nlen;
diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index 03035c8..10c43be 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -287,27 +287,6 @@ long sparc_remap_file_pages(unsigned long start, unsigned long size,
 				    (pgoff >> (PAGE_SHIFT - 12)), flags);
 }
 
-extern unsigned long do_mremap(unsigned long addr,
-	unsigned long old_len, unsigned long new_len,
-	unsigned long flags, unsigned long new_addr);
-                
-asmlinkage unsigned long sparc_mremap(unsigned long addr,
-	unsigned long old_len, unsigned long new_len,
-	unsigned long flags, unsigned long new_addr)
-{
-	unsigned long ret = -EINVAL;
-
-	if (unlikely(sparc_mmap_check(addr, old_len)))
-		goto out;
-	if (unlikely(sparc_mmap_check(new_addr, new_len)))
-		goto out;
-	down_write(&current->mm->mmap_sem);
-	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
-	up_write(&current->mm->mmap_sem);
-out:
-	return ret;       
-}
-
 /* we come to here via sys_nis_syscall so it can setup the regs argument */
 asmlinkage unsigned long
 c_sys_nis_syscall (struct pt_regs *regs)
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index e2d1024..ddda12f 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -614,12 +614,6 @@ SYSCALL_DEFINE5(64_mremap, unsigned long, addr,	unsigned long, old_len,
 
 	if (test_thread_flag(TIF_32BIT))
 		goto out;
-	if (unlikely(new_len >= VA_EXCLUDE_START))
-		goto out;
-	if (unlikely(sparc_mmap_check(addr, old_len)))
-		goto out;
-	if (unlikely(sparc_mmap_check(new_addr, new_len)))
-		goto out;
 
 	down_write(&current->mm->mmap_sem);
 	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
index 0f1658d..81822a8 100644
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -67,7 +67,7 @@ sys_call_table:
 /*235*/	.long sys_fstatfs64, sys_llseek, sys_mlock, sys_munlock, sys_mlockall
 /*240*/	.long sys_munlockall, sys_sched_setparam, sys_sched_getparam, sys_sched_setscheduler, sys_sched_getscheduler
 /*245*/	.long sys_sched_yield, sys_sched_get_priority_max, sys_sched_get_priority_min, sys_sched_rr_get_interval, sys_nanosleep
-/*250*/	.long sparc_mremap, sys_sysctl, sys_getsid, sys_fdatasync, sys_nfsservctl
+/*250*/	.long sys_mremap, sys_sysctl, sys_getsid, sys_fdatasync, sys_nfsservctl
 /*255*/	.long sys_sync_file_range, sys_clock_settime, sys_clock_gettime, sys_clock_getres, sys_clock_nanosleep
 /*260*/	.long sys_sched_getaffinity, sys_sched_setaffinity, sys_timer_settime, sys_timer_gettime, sys_timer_getoverrun
 /*265*/	.long sys_timer_delete, sys_timer_create, sys_nis_syscall, sys_io_setup, sys_io_destroy
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 009825f..fa3d4d7 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -68,7 +68,7 @@ sys_call_table32:
 	.word compat_sys_fstatfs64, sys_llseek, sys_mlock, sys_munlock, sys32_mlockall
 /*240*/	.word sys_munlockall, sys32_sched_setparam, sys32_sched_getparam, sys32_sched_setscheduler, sys32_sched_getscheduler
 	.word sys_sched_yield, sys32_sched_get_priority_max, sys32_sched_get_priority_min, sys32_sched_rr_get_interval, compat_sys_nanosleep
-/*250*/	.word sys32_mremap, sys32_sysctl, sys32_getsid, sys_fdatasync, sys32_nfsservctl
+/*250*/	.word sys_mremap, sys32_sysctl, sys32_getsid, sys_fdatasync, sys32_nfsservctl
 	.word sys32_sync_file_range, compat_sys_clock_settime, compat_sys_clock_gettime, compat_sys_clock_getres, sys32_clock_nanosleep
 /*260*/	.word compat_sys_sched_getaffinity, compat_sys_sched_setaffinity, sys32_timer_settime, compat_sys_timer_gettime, sys_timer_getoverrun
 	.word sys_timer_delete, compat_sys_timer_create, sys_ni_syscall, compat_sys_io_setup, sys_io_destroy
-- 
1.5.6.5


