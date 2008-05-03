Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYECTKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYECTKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYECTKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:10:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYECTKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:10:44 -0400
Date: Sat, 3 May 2008 15:10:37 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805031910.m43JAbSx001173@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v3] unified (weak) sys_pipe implementation
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Linus]
> That said, I think that in order to not break other architectures, and to 
> make it even easier to do this transformation, how about we just mark the 
> generic version with __weak?


OK with me.  I haven't tested any architecture but x86-64, though, but
since __weak is used elsewhere now it'll be a generic problem.

I still haven't changed the cris version even though Linus says the BKL
isn't needed.  The arch maintainer can easily do it if there are really
no obstacles.


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
 fs/pipe.c                         |   17 +++++++++++++++++
 include/asm-powerpc/syscalls.h    |    2 +-
 18 files changed, 18 insertions(+), 265 deletions(-)


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
index f73492b..3499f9f 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1076,6 +1076,23 @@ int do_pipe(int *fd)
 }
 
 /*
+ * sys_pipe() is the normal C calling standard for creating
+ * a pipe. It's not the way Unix traditionally does this, though.
+ */
+asmlinkage long __weak sys_pipe(int __user *fildes)
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
