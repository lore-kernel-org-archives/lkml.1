Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbYECSB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbYECSB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbYECSBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:01:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763819AbYECSBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:01:08 -0400
Date: Sat, 3 May 2008 14:01:00 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805031801.m43I109q032242@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] unify sys_pipe implementation
Cc: akpm@linux-foundation.org, linux-mips@linux-mips.org,
       sparclinux@vger.kernel.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second version of this patch with Linus' comments addressed.  I've
changed the code for a few architectures to use a new name (<arch>_pipe
instead of sys_pipe) as per Linus' suggestion.  I haven't touched MIPS
and Sparc, they use too much magic in this area.  Should be easy enough
for the arch maintainer to clean up.  sys_pipe is now unconditionally
created in fs/pipe.c and they will lead to link errors in case the
arch code isn't cleaned up.

Some arch maintainers might want to take a look at their remaining
special versions.  The cris version, for instance, only differs from
the generic version in that it takes the BKL.  Is this still needed
these days?


 arch/alpha/kernel/entry.S         |    8 ++++----
 arch/alpha/kernel/systbls.S       |    2 +-
 arch/arm/kernel/sys_arm.c         |   17 -----------------
 arch/avr32/kernel/sys_avr32.c     |   13 -------------
 arch/blackfin/kernel/sys_bfin.c   |   17 -----------------
 arch/cris/arch-v10/kernel/entry.S |    2 +-
 arch/cris/arch-v32/kernel/entry.S |    2 +-
 arch/cris/kernel/sys_cris.c       |    4 ++--
 arch/frv/kernel/sys_frv.c         |   17 -----------------
 arch/h8300/kernel/sys_h8300.c     |   17 -----------------
 arch/ia64/kernel/entry.S          |    2 +-
 arch/ia64/kernel/sys_ia64.c       |    2 +-
 arch/m32r/kernel/sys_m32r.c       |    4 ++--
 arch/m32r/kernel/syscall_table.S  |    2 +-
 arch/m68k/kernel/sys_m68k.c       |   17 -----------------
 arch/m68knommu/kernel/sys_m68k.c  |   17 -----------------
 arch/mn10300/kernel/sys_mn10300.c |   17 -----------------
 arch/parisc/kernel/sys_parisc.c   |   13 -------------
 arch/powerpc/kernel/syscalls.c    |   17 -----------------
 arch/s390/kernel/entry.h          |    1 -
 arch/s390/kernel/sys_s390.c       |   17 -----------------
 arch/sh/kernel/sys_sh32.c         |    4 ++--
 arch/sh/kernel/sys_sh64.c         |   17 -----------------
 arch/sh/kernel/syscalls_32.S      |    2 +-
 arch/um/kernel/syscall.c          |   17 -----------------
 arch/v850/kernel/syscalls.c       |   17 -----------------
 arch/x86/kernel/sys_i386_32.c     |   17 -----------------
 arch/x86/kernel/sys_x86_64.c      |   17 -----------------
 fs/pipe.c                         |   17 +++++++++++++++++
 include/asm-ia64/unistd.h         |    2 +-
 include/asm-powerpc/syscalls.h    |    2 +-
 31 files changed, 36 insertions(+), 284 deletions(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index 5fc61e2..c7a72a5 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -894,9 +894,9 @@ sys_getxpid:
 .end sys_getxpid
 
 	.align	4
-	.globl	sys_pipe
-	.ent	sys_pipe
-sys_pipe:
+	.globl	alpha_pipe
+	.ent	alpha_pipe
+alpha_pipe:
 	lda	$sp, -16($sp)
 	stq	$26, 0($sp)
 	.prologue 0
@@ -914,7 +914,7 @@ sys_pipe:
 	stq	$1, 80+16($sp)
 1:	lda	$sp, 16($sp)
 	ret
-.end sys_pipe
+.end alpha_pipe
 
 	.align	4
 	.globl	sys_execve
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index ba914af..863f23a 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -52,7 +52,7 @@ sys_call_table:
 	.quad sys_setpgid
 	.quad alpha_ni_syscall			/* 40 */
 	.quad sys_dup
-	.quad sys_pipe
+	.quad alpha_pipe
 	.quad osf_set_program_attributes
 	.quad alpha_ni_syscall
 	.quad sys_open				/* 45 */
diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 9bd1870..0128687 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -34,23 +34,6 @@ extern unsigned long do_mremap(unsigned long addr, unsigned long old_len,
 			       unsigned long new_len, unsigned long flags,
 			       unsigned long new_addr);
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-asmlinkage int sys_pipe(unsigned long __user *fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 /* common code for old and new mmaps */
 inline long do_mmap2(
 	unsigned long addr, unsigned long len,
diff --git a/arch/avr32/kernel/sys_avr32.c b/arch/avr32/kernel/sys_avr32.c
index 8deb600..8e8911e 100644
--- a/arch/avr32/kernel/sys_avr32.c
+++ b/arch/avr32/kernel/sys_avr32.c
@@ -14,19 +14,6 @@
 #include <asm/mman.h>
 #include <asm/uaccess.h>
 
-asmlinkage int sys_pipe(unsigned long __user *filedes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(filedes, fd, sizeof(fd)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, off_t offset)
diff --git a/arch/blackfin/kernel/sys_bfin.c b/arch/blackfin/kernel/sys_bfin.c
index efb7b25..fce49d7 100644
--- a/arch/blackfin/kernel/sys_bfin.c
+++ b/arch/blackfin/kernel/sys_bfin.c
@@ -45,23 +45,6 @@
 #include <asm/cacheflush.h>
 #include <asm/dma.h>
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-asmlinkage int sys_pipe(unsigned long __user *fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2 * sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 /* common code for old and new mmaps */
 static inline long
 do_mmap2(unsigned long addr, unsigned long len,
diff --git a/arch/cris/arch-v10/kernel/entry.S b/arch/cris/arch-v10/kernel/entry.S
index 3a65f32..c0811c7 100644
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -644,7 +644,7 @@ sys_call_table:
 	.long sys_mkdir
 	.long sys_rmdir		/* 40 */
 	.long sys_dup
-	.long sys_pipe
+	.long cris_pipe
 	.long sys_times
 	.long sys_ni_syscall	/* old prof syscall holder */
 	.long sys_brk		/* 45 */
diff --git a/arch/cris/arch-v32/kernel/entry.S b/arch/cris/arch-v32/kernel/entry.S
index eebbaba..adbc57a 100644
--- a/arch/cris/arch-v32/kernel/entry.S
+++ b/arch/cris/arch-v32/kernel/entry.S
@@ -567,7 +567,7 @@ sys_call_table:
 	.long sys_mkdir
 	.long sys_rmdir		/* 40 */
 	.long sys_dup
-	.long sys_pipe
+	.long cris_pipe
 	.long sys_times
 	.long sys_ni_syscall	/* old prof syscall holder */
 	.long sys_brk		/* 45 */
diff --git a/arch/cris/kernel/sys_cris.c b/arch/cris/kernel/sys_cris.c
index 8b99841..0e7f220 100644
--- a/arch/cris/kernel/sys_cris.c
+++ b/arch/cris/kernel/sys_cris.c
@@ -28,10 +28,10 @@
 #include <asm/segment.h>
 
 /*
- * sys_pipe() is the normal C calling standard for creating
+ * cris_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way Unix traditionally does this, though.
  */
-asmlinkage int sys_pipe(unsigned long __user * fildes)
+asmlinkage int cris_pipe(unsigned long __user * fildes)
 {
         int fd[2];
         int error;
diff --git a/arch/frv/kernel/sys_frv.c b/arch/frv/kernel/sys_frv.c
index 04c6b16..49b2cf2 100644
--- a/arch/frv/kernel/sys_frv.c
+++ b/arch/frv/kernel/sys_frv.c
@@ -28,23 +28,6 @@
 #include <asm/setup.h>
 #include <asm/uaccess.h>
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-asmlinkage long sys_pipe(unsigned long __user * fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, unsigned long pgoff)
diff --git a/arch/h8300/kernel/sys_h8300.c b/arch/h8300/kernel/sys_h8300.c
index 00608be..2745656 100644
--- a/arch/h8300/kernel/sys_h8300.c
+++ b/arch/h8300/kernel/sys_h8300.c
@@ -27,23 +27,6 @@
 #include <asm/traps.h>
 #include <asm/unistd.h>
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-asmlinkage int sys_pipe(unsigned long * fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 /* common code for old and new mmaps */
 static inline long do_mmap2(
 	unsigned long addr, unsigned long len,
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index e49ad8c..f567bcc 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1402,7 +1402,7 @@ sys_call_table:
 	data8 sys_mkdir				// 1055
 	data8 sys_rmdir
 	data8 sys_dup
-	data8 sys_pipe
+	data8 ia64_pipe
 	data8 sys_times
 	data8 ia64_brk				// 1060
 	data8 sys_setgid
diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index 1eda194..6070826 100644
--- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -154,7 +154,7 @@ out:
  * and r9) as this is faster than doing a copy_to_user().
  */
 asmlinkage long
-sys_pipe (void)
+ia64_pipe (void)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	int fd[2];
diff --git a/arch/m32r/kernel/sys_m32r.c b/arch/m32r/kernel/sys_m32r.c
index 6d7a80f..7475510 100644
--- a/arch/m32r/kernel/sys_m32r.c
+++ b/arch/m32r/kernel/sys_m32r.c
@@ -77,11 +77,11 @@ asmlinkage int sys_tas(int __user *addr)
 }
 
 /*
- * sys_pipe() is the normal C calling standard for creating
+ * m32r_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way Unix traditionally does this, though.
  */
 asmlinkage int
-sys_pipe(unsigned long r0, unsigned long r1, unsigned long r2,
+m32r_pipe(unsigned long r0, unsigned long r1, unsigned long r2,
 	unsigned long r3, unsigned long r4, unsigned long r5,
 	unsigned long r6, struct pt_regs regs)
 {
diff --git a/arch/m32r/kernel/syscall_table.S b/arch/m32r/kernel/syscall_table.S
index aa3bf4c..911913d 100644
--- a/arch/m32r/kernel/syscall_table.S
+++ b/arch/m32r/kernel/syscall_table.S
@@ -41,7 +41,7 @@ ENTRY(sys_call_table)
 	.long sys_mkdir
 	.long sys_rmdir			/* 40 */
 	.long sys_dup
-	.long sys_pipe
+	.long m32r_pipe
 	.long sys_times
 	.long sys_ni_syscall		/* old prof syscall holder */
 	.long sys_brk			/* 45 */
diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
index e892f17..7f54efa 100644
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -30,23 +30,6 @@
 #include <asm/page.h>
 #include <asm/unistd.h>
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-asmlinkage int sys_pipe(unsigned long __user * fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 /* common code for old and new mmaps */
 static inline long do_mmap2(
 	unsigned long addr, unsigned long len,
diff --git a/arch/m68knommu/kernel/sys_m68k.c b/arch/m68knommu/kernel/sys_m68k.c
index 65f7a95..7002816 100644
--- a/arch/m68knommu/kernel/sys_m68k.c
+++ b/arch/m68knommu/kernel/sys_m68k.c
@@ -28,23 +28,6 @@
 #include <asm/cacheflush.h>
 #include <asm/unistd.h>
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-asmlinkage int sys_pipe(unsigned long * fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 /* common code for old and new mmaps */
 static inline long do_mmap2(
 	unsigned long addr, unsigned long len,
diff --git a/arch/mn10300/kernel/sys_mn10300.c b/arch/mn10300/kernel/sys_mn10300.c
index 5f17a1e..bca5a84 100644
--- a/arch/mn10300/kernel/sys_mn10300.c
+++ b/arch/mn10300/kernel/sys_mn10300.c
@@ -29,23 +29,6 @@
 #define MIN_MAP_ADDR	PAGE_SIZE	/* minimum fixed mmap address */
 
 /*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way Unix traditionally does this, though.
- */
-asmlinkage long sys_pipe(unsigned long __user *fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2 * sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
-/*
  * memory mapping syscall
  */
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 4f58921..71b3195 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -33,19 +33,6 @@
 #include <linux/utsname.h>
 #include <linux/personality.h>
 
-int sys_pipe(int __user *fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 static unsigned long get_unshared_area(unsigned long addr, unsigned long len)
 {
 	struct vm_area_struct *vma;
diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index e722a4e..4fe69ca 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -136,23 +136,6 @@ int sys_ipc(uint call, int first, unsigned long second, long third,
 	return ret;
 }
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-int sys_pipe(int __user *fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 static inline unsigned long do_mmap2(unsigned long addr, size_t len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, unsigned long off, int shift)
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index 6b18963..9febc89 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -30,7 +30,6 @@ struct fadvise64_64_args;
 struct old_sigaction;
 struct sel_arg_struct;
 
-long sys_pipe(unsigned long __user *fildes);
 long sys_mmap2(struct mmap_arg_struct __user  *arg);
 long old_mmap(struct mmap_arg_struct __user *arg);
 long sys_ipc(uint call, int first, unsigned long second,
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index 988d0d6..5fdb799 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -32,23 +32,6 @@
 #include <asm/uaccess.h>
 #include "entry.h"
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way Unix traditionally does this, though.
- */
-asmlinkage long sys_pipe(unsigned long __user *fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 /* common code for old and new mmaps */
 static inline long do_mmap2(
 	unsigned long addr, unsigned long len,
diff --git a/arch/sh/kernel/sys_sh32.c b/arch/sh/kernel/sys_sh32.c
index 125e493..da25089 100644
--- a/arch/sh/kernel/sys_sh32.c
+++ b/arch/sh/kernel/sys_sh32.c
@@ -18,10 +18,10 @@
 #include <asm/unistd.h>
 
 /*
- * sys_pipe() is the normal C calling standard for creating
+ * sh32_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way Unix traditionally does this, though.
  */
-asmlinkage int sys_pipe(unsigned long r4, unsigned long r5,
+asmlinkage int sh32_pipe(unsigned long r4, unsigned long r5,
 	unsigned long r6, unsigned long r7,
 	struct pt_regs __regs)
 {
diff --git a/arch/sh/kernel/sys_sh64.c b/arch/sh/kernel/sys_sh64.c
index 578004d..91fb844 100644
--- a/arch/sh/kernel/sys_sh64.c
+++ b/arch/sh/kernel/sys_sh64.c
@@ -31,23 +31,6 @@
 #include <asm/unistd.h>
 
 /*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way Unix traditionally does this, though.
- */
-asmlinkage int sys_pipe(unsigned long * fildes)
-{
-        int fd[2];
-        int error;
-
-        error = do_pipe(fd);
-        if (!error) {
-                if (copy_to_user(fildes, fd, 2*sizeof(int)))
-                        error = -EFAULT;
-        }
-        return error;
-}
-
-/*
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
diff --git a/arch/sh/kernel/syscalls_32.S b/arch/sh/kernel/syscalls_32.S
index a46cc3a..b17cef2 100644
--- a/arch/sh/kernel/syscalls_32.S
+++ b/arch/sh/kernel/syscalls_32.S
@@ -58,7 +58,7 @@ ENTRY(sys_call_table)
 	.long sys_mkdir
 	.long sys_rmdir		/* 40 */
 	.long sys_dup
-	.long sys_pipe
+	.long sh32_pipe
 	.long sys_times
 	.long sys_ni_syscall	/* old prof syscall holder */
 	.long sys_brk		/* 45 */
diff --git a/arch/um/kernel/syscall.c b/arch/um/kernel/syscall.c
index 9cffc62..128ee85 100644
--- a/arch/um/kernel/syscall.c
+++ b/arch/um/kernel/syscall.c
@@ -73,23 +73,6 @@ long old_mmap(unsigned long addr, unsigned long len,
  out:
 	return err;
 }
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-long sys_pipe(unsigned long __user * fildes)
-{
-	int fd[2];
-	long error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, sizeof(fd)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 
 long sys_uname(struct old_utsname __user * name)
 {
diff --git a/arch/v850/kernel/syscalls.c b/arch/v850/kernel/syscalls.c
index 003db9c..1a83daf 100644
--- a/arch/v850/kernel/syscalls.c
+++ b/arch/v850/kernel/syscalls.c
@@ -132,23 +132,6 @@ sys_ipc (uint call, int first, int second, int third, void *ptr, long fifth)
 	return ret;
 }
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way unix traditionally does this, though.
- */
-int sys_pipe (int *fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe (fd);
-	if (!error) {
-		if (copy_to_user (fildes, fd, 2*sizeof (int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 static inline unsigned long
 do_mmap2 (unsigned long addr, size_t len,
 	 unsigned long prot, unsigned long flags,
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index a86d26f..d2ab52c 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -22,23 +22,6 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way Unix traditionally does this, though.
- */
-asmlinkage int sys_pipe(unsigned long __user * fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, unsigned long pgoff)
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index bd802a5..3b360ef 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -17,23 +17,6 @@
 #include <asm/uaccess.h>
 #include <asm/ia32.h>
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way Unix traditionally does this, though.
- */
-asmlinkage long sys_pipe(int __user *fildes)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(fildes, fd, 2*sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 asmlinkage long sys_mmap(unsigned long addr, unsigned long len, unsigned long prot, unsigned long flags,
 	unsigned long fd, unsigned long off)
 {
diff --git a/fs/pipe.c b/fs/pipe.c
index f73492b..8400ebf 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1076,6 +1076,23 @@ int do_pipe(int *fd)
 }
 
 /*
+ * sys_pipe() is the normal C calling standard for creating
+ * a pipe. It's not the way Unix traditionally does this, though.
+ */
+asmlinkage long sys_pipe(int __user *fildes)
+{
+	int fd[2];
+	int error;
+
+	error = do_pipe(fd);
+	if (!error) {
+		if (copy_to_user(fildes, fd, sizeof(fd)))
+			error = -EFAULT;
+	}
+	return error;
+}
+
+/*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
  * any operations on the root directory. However, we need a non-trivial
diff --git a/include/asm-ia64/unistd.h b/include/asm-ia64/unistd.h
index e603147..74350b2 100644
--- a/include/asm-ia64/unistd.h
+++ b/include/asm-ia64/unistd.h
@@ -357,7 +357,7 @@ struct pt_regs;
 struct sigaction;
 long sys_execve(char __user *filename, char __user * __user *argv,
 			   char __user * __user *envp, struct pt_regs *regs);
-asmlinkage long sys_pipe(void);
+asmlinkage long ia64_pipe(void);
 asmlinkage long sys_rt_sigaction(int sig,
 				 const struct sigaction __user *act,
 				 struct sigaction __user *oact,
diff --git a/include/asm-powerpc/syscalls.h b/include/asm-powerpc/syscalls.h
index b3ca41f..2b8a458 100644
--- a/include/asm-powerpc/syscalls.h
+++ b/include/asm-powerpc/syscalls.h
@@ -30,7 +30,7 @@ asmlinkage int sys_fork(unsigned long p1, unsigned long p2,
 asmlinkage int sys_vfork(unsigned long p1, unsigned long p2,
 		unsigned long p3, unsigned long p4, unsigned long p5,
 		unsigned long p6, struct pt_regs *regs);
-asmlinkage int sys_pipe(int __user *fildes);
+asmlinkage long sys_pipe(int __user *fildes);
 asmlinkage long sys_rt_sigaction(int sig,
 		const struct sigaction __user *act,
 		struct sigaction __user *oact, size_t sigsetsize);
