Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYECEEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYECEEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 00:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbYECEDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 00:03:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYECEDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 00:03:50 -0400
Date: Sat, 3 May 2008 00:03:45 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805030403.m4343j5u014868@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] unify sys_pipe implementation
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for adding pipe2, the variant with a flag parameter, this
is a patch which unifies the implementation of the majority of the
architectures.  There is a difference in the way sys_pipe is implemented
for some architectures.  This is why so far each architecture defined
its own copy in arch/*/kernel/sys*.c.  Most of the time these are
exact copies.  To avoid this fs/pipe.c now contains this common code
and the architecture's unistd.h file defines if necessary the macro
__ARCH_WANT_SYS_PIPE.

A few architectures still have their own sys_pipe files.  In a few
cases I can imagine this not to be necessary.  I leave this to the
arch maintainers.

The net result is that we have 230 lines less.


 arch/arm/kernel/sys_arm.c         |   17 -----------------
 arch/avr32/kernel/sys_avr32.c     |   13 -------------
 arch/blackfin/kernel/sys_bfin.c   |   17 -----------------
 arch/frv/kernel/sys_frv.c         |   17 -----------------
 arch/h8300/kernel/sys_h8300.c     |   17 -----------------
 arch/m68k/kernel/sys_m68k.c       |   17 -----------------
 arch/m68knommu/kernel/sys_m68k.c  |   17 -----------------
 arch/mn10300/kernel/sys_mn10300.c |   17 -----------------
 arch/parisc/kernel/sys_parisc.c   |   13 -------------
 arch/powerpc/kernel/syscalls.c    |   17 -----------------
 arch/s390/kernel/sys_s390.c       |   17 -----------------
 arch/sh/kernel/sys_sh64.c         |   17 -----------------
 arch/um/kernel/syscall.c          |   17 -----------------
 arch/v850/kernel/syscalls.c       |   17 -----------------
 arch/x86/kernel/sys_i386_32.c     |   17 -----------------
 arch/x86/kernel/sys_x86_64.c      |   17 -----------------
 fs/pipe.c                         |   20 ++++++++++++++++++++
 include/asm-arm/unistd.h          |    1 +
 include/asm-avr32/unistd.h        |    1 +
 include/asm-blackfin/unistd.h     |    1 +
 include/asm-frv/unistd.h          |    1 +
 include/asm-h8300/unistd.h        |    1 +
 include/asm-m68k/unistd.h         |    1 +
 include/asm-m68knommu/unistd.h    |    1 +
 include/asm-mn10300/unistd.h      |    1 +
 include/asm-parisc/unistd.h       |    1 +
 include/asm-powerpc/unistd.h      |    1 +
 include/asm-s390/unistd.h         |    1 +
 include/asm-sh/unistd_64.h        |    1 +
 include/asm-v850/unistd.h         |    1 +
 include/asm-x86/unistd_32.h       |    1 +
 include/asm-x86/unistd_64.h       |    1 +
 32 files changed, 35 insertions(+), 264 deletions(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

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
index f73492b..f082ba5 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -20,6 +20,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
+#include <asm/unistd.h>
 
 /*
  * We use a start+len construction, which provides full use of the 
@@ -1075,6 +1076,25 @@ int do_pipe(int *fd)
 	return error;
 }
 
+#ifdef __ARCH_WANT_SYS_PIPE
+/*
+ * sys_pipe() is the normal C calling standard for creating
+ * a pipe. It's not the way Unix traditionally does this, though.
+ */
+asmlinkage long sys_pipe(unsigned long __user *fildes)
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
+#endif
+
 /*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
diff --git a/include/asm-arm/unistd.h b/include/asm-arm/unistd.h
index 7c57008..541d10a 100644
--- a/include/asm-arm/unistd.h
+++ b/include/asm-arm/unistd.h
@@ -422,6 +422,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_PIPE
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 #define __ARCH_WANT_SYS_TIME
diff --git a/include/asm-avr32/unistd.h b/include/asm-avr32/unistd.h
index 89861a2..6ef20ac 100644
--- a/include/asm-avr32/unistd.h
+++ b/include/asm-avr32/unistd.h
@@ -331,6 +331,7 @@
 #define __ARCH_WANT_SYS_GETPGRP
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-blackfin/unistd.h b/include/asm-blackfin/unistd.h
index 42955d0..fa0320f 100644
--- a/include/asm-blackfin/unistd.h
+++ b/include/asm-blackfin/unistd.h
@@ -418,6 +418,7 @@
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-frv/unistd.h b/include/asm-frv/unistd.h
index f184eb8..d739a8c 100644
--- a/include/asm-frv/unistd.h
+++ b/include/asm-frv/unistd.h
@@ -361,6 +361,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-h8300/unistd.h b/include/asm-h8300/unistd.h
index 99f3c35..56f9c38 100644
--- a/include/asm-h8300/unistd.h
+++ b/include/asm-h8300/unistd.h
@@ -352,6 +352,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-m68k/unistd.h b/include/asm-m68k/unistd.h
index e72ba56..871265c 100644
--- a/include/asm-m68k/unistd.h
+++ b/include/asm-m68k/unistd.h
@@ -352,6 +352,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_PIPE
 
 /* whitelist for checksyscalls */
 #define __IGNORE_restart_syscall
diff --git a/include/asm-m68knommu/unistd.h b/include/asm-m68knommu/unistd.h
index 4ba98b9..734cc86 100644
--- a/include/asm-m68knommu/unistd.h
+++ b/include/asm-m68knommu/unistd.h
@@ -353,6 +353,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-mn10300/unistd.h b/include/asm-mn10300/unistd.h
index 3721aa9..e08149e 100644
--- a/include/asm-mn10300/unistd.h
+++ b/include/asm-mn10300/unistd.h
@@ -369,6 +369,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-parisc/unistd.h b/include/asm-parisc/unistd.h
index a7d857f..cc5aa18 100644
--- a/include/asm-parisc/unistd.h
+++ b/include/asm-parisc/unistd.h
@@ -974,6 +974,7 @@ type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4, type5 arg5)	\
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_PIPE
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/include/asm-powerpc/unistd.h b/include/asm-powerpc/unistd.h
index ce91bb6..09d8947 100644
--- a/include/asm-powerpc/unistd.h
+++ b/include/asm-powerpc/unistd.h
@@ -371,6 +371,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_PIPE
 #ifdef CONFIG_PPC32
 #define __ARCH_WANT_OLD_STAT
 #endif
diff --git a/include/asm-s390/unistd.h b/include/asm-s390/unistd.h
index 583da80..2c5a3b0 100644
--- a/include/asm-s390/unistd.h
+++ b/include/asm-s390/unistd.h
@@ -383,6 +383,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_PIPE
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
 # ifndef CONFIG_64BIT
 #   define __ARCH_WANT_STAT64
diff --git a/include/asm-sh/unistd_64.h b/include/asm-sh/unistd_64.h
index 9d21eab..ee56c3e 100644
--- a/include/asm-sh/unistd_64.h
+++ b/include/asm-sh/unistd_64.h
@@ -402,6 +402,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-v850/unistd.h b/include/asm-v850/unistd.h
index 2241ed4..61cbb7d 100644
--- a/include/asm-v850/unistd.h
+++ b/include/asm-v850/unistd.h
@@ -226,6 +226,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 8317d94..8e37dbd 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -358,6 +358,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_PIPE
 
 /*
  * "Conditional" syscalls
diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index fe26e36..f73c873 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -665,6 +665,7 @@ __SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #endif	/* __NO_STUBS */
+#define __ARCH_WANT_SYS_PIPE
 
 #ifdef __KERNEL__
 /*
