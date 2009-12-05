Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZLEUQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZLEUQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbZLEUQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:16:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41322 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbZLEUQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:16:27 -0500
Date: Sat, 05 Dec 2009 19:08:51 +0000
To: linux-arch@vger.kernel.org
Subject: [RFC][PATCH 13/18] Unify sys_mmap*
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NGzzv-0008Rn-4G@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


New helper - sys_mmap_pgoff(); switch syscalls to using it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/osf_sys.c               |   19 ++-----
 arch/arm/kernel/entry-common.S            |    4 +-
 arch/arm/kernel/sys_arm.c                 |   30 +----------
 arch/avr32/include/asm/syscalls.h         |    4 --
 arch/avr32/kernel/sys_avr32.c             |   31 -----------
 arch/avr32/kernel/syscall-stubs.S         |    2 +-
 arch/blackfin/kernel/sys_bfin.c           |   33 -----------
 arch/blackfin/mach-common/entry.S         |    2 +-
 arch/cris/kernel/sys_cris.c               |   30 +---------
 arch/frv/kernel/sys_frv.c                 |   66 +----------------------
 arch/h8300/kernel/sys_h8300.c             |   83 +----------------------------
 arch/h8300/kernel/syscalls.S              |    2 +-
 arch/ia64/kernel/sys_ia64.c               |   37 +------------
 arch/m32r/kernel/sys_m32r.c               |   24 --------
 arch/m32r/kernel/syscall_table.S          |    2 +-
 arch/m68k/kernel/sys_m68k.c               |   79 ++--------------------------
 arch/m68knommu/kernel/sys_m68k.c          |   38 +------------
 arch/m68knommu/kernel/syscalltable.S      |    2 +-
 arch/microblaze/kernel/sys_microblaze.c   |   38 +------------
 arch/microblaze/kernel/syscall_table.S    |    2 +-
 arch/mips/kernel/linux32.c                |   19 +------
 arch/mips/kernel/syscall.c                |   29 +---------
 arch/mn10300/kernel/entry.S               |    2 +-
 arch/mn10300/kernel/sys_mn10300.c         |   31 +----------
 arch/parisc/kernel/sys_parisc.c           |   30 ++---------
 arch/powerpc/kernel/syscalls.c            |   15 +-----
 arch/s390/kernel/compat_linux.c           |   32 +----------
 arch/s390/kernel/sys_s390.c               |   30 +----------
 arch/score/kernel/sys_score.c             |   21 +------
 arch/sh/kernel/sys_sh.c                   |   28 +---------
 arch/sparc/kernel/sys_sparc_32.c          |   31 ++---------
 arch/sparc/kernel/sys_sparc_64.c          |   22 ++------
 arch/um/kernel/syscall.c                  |   28 +---------
 arch/um/sys-i386/shared/sysdep/syscalls.h |    4 --
 arch/x86/ia32/ia32entry.S                 |    2 +-
 arch/x86/ia32/sys_ia32.c                  |   43 +---------------
 arch/x86/include/asm/sys_ia32.h           |    3 -
 arch/x86/include/asm/syscalls.h           |    2 -
 arch/x86/kernel/sys_i386_32.c             |   27 +---------
 arch/x86/kernel/sys_x86_64.c              |   17 +------
 arch/x86/kernel/syscall_table_32.S        |    2 +-
 arch/xtensa/include/asm/syscall.h         |    2 -
 arch/xtensa/include/asm/unistd.h          |    2 +-
 arch/xtensa/kernel/syscall.c              |   25 ---------
 include/linux/syscalls.h                  |    4 ++
 mm/util.c                                 |   29 ++++++++++
 46 files changed, 105 insertions(+), 903 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 9a3334a..62619f2 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -178,25 +178,18 @@ SYSCALL_DEFINE6(osf_mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags, unsigned long, fd,
 		unsigned long, off)
 {
-	struct file *file = NULL;
-	unsigned long ret = -EBADF;
+	unsigned long ret = -EINVAL;
 
 #if 0
 	if (flags & (_MAP_HASSEMAPHORE | _MAP_INHERIT | _MAP_UNALIGNED))
 		printk("%s: unimplemented OSF mmap flags %04lx\n", 
 			current->comm, flags);
 #endif
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	down_write(&current->mm->mmap_sem);
-	ret = do_mmap(file, addr, len, prot, flags, off);
-	up_write(&current->mm->mmap_sem);
-	if (file)
-		fput(file);
+	if ((off + PAGE_ALIGN(len)) < off)
+		goto out;
+	if (off & ~PAGE_MASK)
+		goto out;
+	ret = sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
  out:
 	return ret;
 }
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index f0fe95b..2c1db77 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -416,12 +416,12 @@ sys_mmap2:
 		tst	r5, #PGOFF_MASK
 		moveq	r5, r5, lsr #PAGE_SHIFT - 12
 		streq	r5, [sp, #4]
-		beq	do_mmap2
+		beq	sys_mmap_pgoff
 		mov	r0, #-EINVAL
 		mov	pc, lr
 #else
 		str	r5, [sp, #4]
-		b	do_mmap2
+		b	sys_mmap_pgoff
 #endif
 ENDPROC(sys_mmap2)
 
diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 3b89744..ae4027b 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -28,34 +28,6 @@
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
 
-/* common code for old and new mmaps */
-inline long do_mmap2(
-	unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	int error = -EINVAL;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	error = -EBADF;
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 struct mmap_arg_struct {
 	unsigned long addr;
 	unsigned long len;
@@ -77,7 +49,7 @@ asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
 	if (a.offset & ~PAGE_MASK)
 		goto out;
 
-	error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
+	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
 out:
 	return error;
 }
diff --git a/arch/avr32/include/asm/syscalls.h b/arch/avr32/include/asm/syscalls.h
index 483d666..66a1972 100644
--- a/arch/avr32/include/asm/syscalls.h
+++ b/arch/avr32/include/asm/syscalls.h
@@ -29,10 +29,6 @@ asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
 			       struct pt_regs *);
 asmlinkage int sys_rt_sigreturn(struct pt_regs *);
 
-/* kernel/sys_avr32.c */
-asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
-			  unsigned long, unsigned long, off_t);
-
 /* mm/cache.c */
 asmlinkage int sys_cacheflush(int, void __user *, size_t);
 
diff --git a/arch/avr32/kernel/sys_avr32.c b/arch/avr32/kernel/sys_avr32.c
index 5d2daea..459349b 100644
--- a/arch/avr32/kernel/sys_avr32.c
+++ b/arch/avr32/kernel/sys_avr32.c
@@ -5,39 +5,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/file.h>
-#include <linux/mm.h>
 #include <linux/unistd.h>
 
-#include <asm/mman.h>
-#include <asm/uaccess.h>
-#include <asm/syscalls.h>
-
-asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
-			  unsigned long prot, unsigned long flags,
-			  unsigned long fd, off_t offset)
-{
-	int error = -EBADF;
-	struct file *file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			return error;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, offset);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-	return error;
-}
-
 int kernel_execve(const char *file, char **argv, char **envp)
 {
 	register long scno asm("r8") = __NR_execve;
diff --git a/arch/avr32/kernel/syscall-stubs.S b/arch/avr32/kernel/syscall-stubs.S
index f7244cd..0447a3e 100644
--- a/arch/avr32/kernel/syscall-stubs.S
+++ b/arch/avr32/kernel/syscall-stubs.S
@@ -61,7 +61,7 @@ __sys_execve:
 __sys_mmap2:
 	pushm	lr
 	st.w	--sp, ARG6
-	call	sys_mmap2
+	call	sys_mmap_pgoff
 	sub	sp, -4
 	popm	pc
 
diff --git a/arch/blackfin/kernel/sys_bfin.c b/arch/blackfin/kernel/sys_bfin.c
index afcef12..2e7f8e1 100644
--- a/arch/blackfin/kernel/sys_bfin.c
+++ b/arch/blackfin/kernel/sys_bfin.c
@@ -22,39 +22,6 @@
 #include <asm/cacheflush.h>
 #include <asm/dma.h>
 
-/* common code for old and new mmaps */
-static inline long
-do_mmap2(unsigned long addr, unsigned long len,
-	 unsigned long prot, unsigned long flags,
-	 unsigned long fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file *file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
- out:
-	return error;
-}
-
-asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
-			  unsigned long prot, unsigned long flags,
-			  unsigned long fd, unsigned long pgoff)
-{
-	return do_mmap2(addr, len, prot, flags, fd, pgoff);
-}
-
 asmlinkage void *sys_sram_alloc(size_t size, unsigned long flags)
 {
 	return sram_alloc_with_lsl(size, flags);
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 94a0375..1d8f00a 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1422,7 +1422,7 @@ ENTRY(_sys_call_table)
 	.long _sys_ni_syscall	/* streams2 */
 	.long _sys_vfork		/* 190 */
 	.long _sys_getrlimit
-	.long _sys_mmap2
+	.long _sys_mmap_pgoff
 	.long _sys_truncate64
 	.long _sys_ftruncate64
 	.long _sys_stat64	/* 195 */
diff --git a/arch/cris/kernel/sys_cris.c b/arch/cris/kernel/sys_cris.c
index 2ad962c..c2bbb1a 100644
--- a/arch/cris/kernel/sys_cris.c
+++ b/arch/cris/kernel/sys_cris.c
@@ -26,31 +26,6 @@
 #include <asm/uaccess.h>
 #include <asm/segment.h>
 
-/* common code for old and new mmaps */
-static inline long
-do_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
-        unsigned long flags, unsigned long fd, unsigned long pgoff)
-{
-        int error = -EBADF;
-        struct file * file = NULL;
-
-        flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-        if (!(flags & MAP_ANONYMOUS)) {
-                file = fget(fd);
-                if (!file)
-                        goto out;
-        }
-
-        down_write(&current->mm->mmap_sem);
-        error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-        up_write(&current->mm->mmap_sem);
-
-        if (file)
-                fput(file);
-out:
-        return error;
-}
-
 asmlinkage unsigned long old_mmap(unsigned long __user *args)
 {        
 	unsigned long buffer[6];
@@ -63,7 +38,7 @@ asmlinkage unsigned long old_mmap(unsigned long __user *args)
 	if (buffer[5] & ~PAGE_MASK) /* verify that offset is on page boundary */
 		goto out;
 
-	err = do_mmap2(buffer[0], buffer[1], buffer[2], buffer[3],
+	err = sys_mmap_pgoff(buffer[0], buffer[1], buffer[2], buffer[3],
                        buffer[4], buffer[5] >> PAGE_SHIFT);
 out:
 	return err;
@@ -73,7 +48,8 @@ asmlinkage long
 sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
           unsigned long flags, unsigned long fd, unsigned long pgoff)
 {
-        return do_mmap2(addr, len, prot, flags, fd, pgoff);
+	/* bug(?): 8Kb pages here */
+        return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
 
 /*
diff --git a/arch/frv/kernel/sys_frv.c b/arch/frv/kernel/sys_frv.c
index 2b6b528..1d3d4c9 100644
--- a/arch/frv/kernel/sys_frv.c
+++ b/arch/frv/kernel/sys_frv.c
@@ -31,9 +31,6 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, unsigned long pgoff)
 {
-	int error = -EBADF;
-	struct file * file = NULL;
-
 	/* As with sparc32, make sure the shift for mmap2 is constant
 	   (12), no matter what PAGE_SIZE we have.... */
 
@@ -41,69 +38,10 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 	   trying to map something we can't */
 	if (pgoff & ((1 << (PAGE_SHIFT - 12)) - 1))
 		return -EINVAL;
-	pgoff >>= PAGE_SHIFT - 12;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
-#if 0 /* DAVIDM - do we want this */
-struct mmap_arg_struct64 {
-	__u32 addr;
-	__u32 len;
-	__u32 prot;
-	__u32 flags;
-	__u64 offset; /* 64 bits */
-	__u32 fd;
-};
-
-asmlinkage long sys_mmap64(struct mmap_arg_struct64 *arg)
-{
-	int error = -EFAULT;
-	struct file * file = NULL;
-	struct mmap_arg_struct64 a;
-	unsigned long pgoff;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-
-	if ((long)a.offset & ~PAGE_MASK)
-		return -EINVAL;
-
-	pgoff = a.offset >> PAGE_SHIFT;
-	if ((a.offset >> PAGE_SHIFT) != pgoff)
-		return -EINVAL;
-
-	if (!(a.flags & MAP_ANONYMOUS)) {
-		error = -EBADF;
-		file = fget(a.fd);
-		if (!file)
-			goto out;
-	}
-	a.flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, a.addr, a.len, a.prot, a.flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-	if (file)
-		fput(file);
-out:
-	return error;
+	return sys_mmap_pgoff(addr, len, prot, flags, fd,
+			      pgoff >> (PAGE_SHIFT - 12));
 }
-#endif
 
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
diff --git a/arch/h8300/kernel/sys_h8300.c b/arch/h8300/kernel/sys_h8300.c
index 8cb5d73..b5969db 100644
--- a/arch/h8300/kernel/sys_h8300.c
+++ b/arch/h8300/kernel/sys_h8300.c
@@ -26,39 +26,6 @@
 #include <asm/traps.h>
 #include <asm/unistd.h>
 
-/* common code for old and new mmaps */
-static inline long do_mmap2(
-	unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
-asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	return do_mmap2(addr, len, prot, flags, fd, pgoff);
-}
-
 /*
  * Perform the select(nd, in, out, ex, tv) and mmap() system
  * calls. Linux/m68k cloned Linux/i386, which didn't use to be able to
@@ -87,57 +54,11 @@ asmlinkage int old_mmap(struct mmap_arg_struct *arg)
 	if (a.offset & ~PAGE_MASK)
 		goto out;
 
-	a.flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
-#if 0 /* DAVIDM - do we want this */
-struct mmap_arg_struct64 {
-	__u32 addr;
-	__u32 len;
-	__u32 prot;
-	__u32 flags;
-	__u64 offset; /* 64 bits */
-	__u32 fd;
-};
-
-asmlinkage long sys_mmap64(struct mmap_arg_struct64 *arg)
-{
-	int error = -EFAULT;
-	struct file * file = NULL;
-	struct mmap_arg_struct64 a;
-	unsigned long pgoff;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-
-	if ((long)a.offset & ~PAGE_MASK)
-		return -EINVAL;
-
-	pgoff = a.offset >> PAGE_SHIFT;
-	if ((a.offset >> PAGE_SHIFT) != pgoff)
-		return -EINVAL;
-
-	if (!(a.flags & MAP_ANONYMOUS)) {
-		error = -EBADF;
-		file = fget(a.fd);
-		if (!file)
-			goto out;
-	}
-	a.flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, a.addr, a.len, a.prot, a.flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-	if (file)
-		fput(file);
+	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
+			       a.offset >> PAGE_SHIFT);
 out:
 	return error;
 }
-#endif
 
 struct sel_arg_struct {
 	unsigned long n;
diff --git a/arch/h8300/kernel/syscalls.S b/arch/h8300/kernel/syscalls.S
index 4eb67fa..2d69881 100644
--- a/arch/h8300/kernel/syscalls.S
+++ b/arch/h8300/kernel/syscalls.S
@@ -206,7 +206,7 @@ SYMBOL_NAME_LABEL(sys_call_table)
 	.long SYMBOL_NAME(sys_ni_syscall)	/* streams2 */
 	.long SYMBOL_NAME(sys_vfork)            /* 190 */
 	.long SYMBOL_NAME(sys_getrlimit)
-	.long SYMBOL_NAME(sys_mmap2)
+	.long SYMBOL_NAME(sys_mmap_pgoff)
 	.long SYMBOL_NAME(sys_truncate64)
 	.long SYMBOL_NAME(sys_ftruncate64)
 	.long SYMBOL_NAME(sys_stat64)		/* 195 */
diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index 92ed83f..ae384a2 100644
--- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -185,39 +185,6 @@ int ia64_mmap_check(unsigned long addr, unsigned long len,
 	return 0;
 }
 
-static inline unsigned long
-do_mmap2 (unsigned long addr, unsigned long len, int prot, int flags, int fd, unsigned long pgoff)
-{
-	struct file *file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			return -EBADF;
-
-		if (!file->f_op || !file->f_op->mmap) {
-			addr = -ENODEV;
-			goto out;
-		}
-	}
-
-	/* Careful about overflows.. */
-	len = PAGE_ALIGN(len);
-	if (!len || len > TASK_SIZE) {
-		addr = -EINVAL;
-		goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	addr = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-out:	if (file)
-		fput(file);
-	return addr;
-}
-
 /*
  * mmap2() is like mmap() except that the offset is expressed in units
  * of PAGE_SIZE (instead of bytes).  This allows to mmap2() (pieces
@@ -226,7 +193,7 @@ out:	if (file)
 asmlinkage unsigned long
 sys_mmap2 (unsigned long addr, unsigned long len, int prot, int flags, int fd, long pgoff)
 {
-	addr = do_mmap2(addr, len, prot, flags, fd, pgoff);
+	addr = sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 	if (!IS_ERR((void *) addr))
 		force_successful_syscall_return();
 	return addr;
@@ -238,7 +205,7 @@ sys_mmap (unsigned long addr, unsigned long len, int prot, int flags, int fd, lo
 	if (offset_in_page(off) != 0)
 		return -EINVAL;
 
-	addr = do_mmap2(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
+	addr = sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
 	if (!IS_ERR((void *) addr))
 		force_successful_syscall_return();
 	return addr;
diff --git a/arch/m32r/kernel/sys_m32r.c b/arch/m32r/kernel/sys_m32r.c
index 305ac85..d3c865c 100644
--- a/arch/m32r/kernel/sys_m32r.c
+++ b/arch/m32r/kernel/sys_m32r.c
@@ -76,30 +76,6 @@ asmlinkage int sys_tas(int __user *addr)
 	return oldval;
 }
 
-asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file *file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
diff --git a/arch/m32r/kernel/syscall_table.S b/arch/m32r/kernel/syscall_table.S
index aa3bf4c..60536e2 100644
--- a/arch/m32r/kernel/syscall_table.S
+++ b/arch/m32r/kernel/syscall_table.S
@@ -191,7 +191,7 @@ ENTRY(sys_call_table)
 	.long sys_ni_syscall		/* streams2 */
 	.long sys_vfork			/* 190 */
 	.long sys_getrlimit
-	.long sys_mmap2
+	.long sys_mmap_pgoff
 	.long sys_truncate64
 	.long sys_ftruncate64
 	.long sys_stat64		/* 195 */
diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
index 7deb402..fdab0f0 100644
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -29,37 +29,12 @@
 #include <asm/page.h>
 #include <asm/unistd.h>
 
-/* common code for old and new mmaps */
-static inline long do_mmap2(
-	unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 	unsigned long prot, unsigned long flags,
 	unsigned long fd, unsigned long pgoff)
 {
-	return do_mmap2(addr, len, prot, flags, fd, pgoff);
+	/* this is wrong for sun3, BTW */
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
 
 /*
@@ -90,57 +65,11 @@ asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
 	if (a.offset & ~PAGE_MASK)
 		goto out;
 
-	a.flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
-#if 0
-struct mmap_arg_struct64 {
-	__u32 addr;
-	__u32 len;
-	__u32 prot;
-	__u32 flags;
-	__u64 offset; /* 64 bits */
-	__u32 fd;
-};
-
-asmlinkage long sys_mmap64(struct mmap_arg_struct64 *arg)
-{
-	int error = -EFAULT;
-	struct file * file = NULL;
-	struct mmap_arg_struct64 a;
-	unsigned long pgoff;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-
-	if ((long)a.offset & ~PAGE_MASK)
-		return -EINVAL;
-
-	pgoff = a.offset >> PAGE_SHIFT;
-	if ((a.offset >> PAGE_SHIFT) != pgoff)
-		return -EINVAL;
-
-	if (!(a.flags & MAP_ANONYMOUS)) {
-		error = -EBADF;
-		file = fget(a.fd);
-		if (!file)
-			goto out;
-	}
-	a.flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, a.addr, a.len, a.prot, a.flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-	if (file)
-		fput(file);
+	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
+			       a.offset >> PAGE_SHIFT);
 out:
 	return error;
 }
-#endif
 
 struct sel_arg_struct {
 	unsigned long n;
diff --git a/arch/m68knommu/kernel/sys_m68k.c b/arch/m68knommu/kernel/sys_m68k.c
index efdd090..b67cbc7 100644
--- a/arch/m68knommu/kernel/sys_m68k.c
+++ b/arch/m68knommu/kernel/sys_m68k.c
@@ -27,39 +27,6 @@
 #include <asm/cacheflush.h>
 #include <asm/unistd.h>
 
-/* common code for old and new mmaps */
-static inline long do_mmap2(
-	unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
-asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	return do_mmap2(addr, len, prot, flags, fd, pgoff);
-}
-
 /*
  * Perform the select(nd, in, out, ex, tv) and mmap() system
  * calls. Linux/m68k cloned Linux/i386, which didn't use to be able to
@@ -88,9 +55,8 @@ asmlinkage int old_mmap(struct mmap_arg_struct *arg)
 	if (a.offset & ~PAGE_MASK)
 		goto out;
 
-	a.flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
+	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
+				a.offset >> PAGE_SHIFT);
 out:
 	return error;
 }
diff --git a/arch/m68knommu/kernel/syscalltable.S b/arch/m68knommu/kernel/syscalltable.S
index 23535cc..486837e 100644
--- a/arch/m68knommu/kernel/syscalltable.S
+++ b/arch/m68knommu/kernel/syscalltable.S
@@ -210,7 +210,7 @@ ENTRY(sys_call_table)
 	.long sys_ni_syscall	/* streams2 */
 	.long sys_vfork		/* 190 */
 	.long sys_getrlimit
-	.long sys_mmap2
+	.long sys_mmap_pgoff
 	.long sys_truncate64
 	.long sys_ftruncate64
 	.long sys_stat64	/* 195 */
diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
index 07cabed..9f3c205 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -62,46 +62,14 @@ out:
 	return error;
 }
 
-asmlinkage long
-sys_mmap2(unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	struct file *file = NULL;
-	int ret = -EBADF;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file) {
-			printk(KERN_INFO "no fd in mmap\r\n");
-			goto out;
-		}
-	}
-
-	down_write(&current->mm->mmap_sem);
-	ret = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-	if (file)
-		fput(file);
-out:
-	return ret;
-}
-
 asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, off_t pgoff)
 {
-	int err = -EINVAL;
-
-	if (pgoff & ~PAGE_MASK) {
-		printk(KERN_INFO "no pagemask in mmap\r\n");
-		goto out;
-	}
+	if (pgoff & ~PAGE_MASK)
+		return -EINVAL;
 
-	err = sys_mmap2(addr, len, prot, flags, fd, pgoff >> PAGE_SHIFT);
-out:
-	return err;
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff >> PAGE_SHIFT);
 }
 
 /*
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index ecec191..eb50ce5 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -196,7 +196,7 @@ ENTRY(sys_call_table)
 	.long sys_ni_syscall		/* reserved for streams2 */
 	.long sys_vfork		/* 190 */
 	.long sys_getrlimit
-	.long sys_mmap2			/* mmap2 */
+	.long sys_mmap_pgoff		/* mmap2 */
 	.long sys_truncate64
 	.long sys_ftruncate64
 	.long sys_stat64		/* 195 */
diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index b77fefa..ea4a746 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -67,28 +67,13 @@ SYSCALL_DEFINE6(32_mmap2, unsigned long, addr, unsigned long, len,
 	unsigned long, prot, unsigned long, flags, unsigned long, fd,
 	unsigned long, pgoff)
 {
-	struct file * file = NULL;
 	unsigned long error;
 
 	error = -EINVAL;
 	if (pgoff & (~PAGE_MASK >> 12))
 		goto out;
-	pgoff >>= PAGE_SHIFT-12;
-
-	if (!(flags & MAP_ANONYMOUS)) {
-		error = -EBADF;
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-	if (file)
-		fput(file);
-
+	error = sys_mmap_pgoff(addr, len, prot, flags, fd,
+			       pgoff >> (PAGE_SHIFT-12));
 out:
 	return error;
 }
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index fe0d798..c25b2e7 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -129,31 +129,6 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	}
 }
 
-/* common code for old and new mmaps */
-static inline unsigned long
-do_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
-        unsigned long flags, unsigned long fd, unsigned long pgoff)
-{
-	unsigned long error = -EBADF;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 SYSCALL_DEFINE6(mips_mmap, unsigned long, addr, unsigned long, len,
 	unsigned long, prot, unsigned long, flags, unsigned long,
 	fd, off_t, offset)
@@ -164,7 +139,7 @@ SYSCALL_DEFINE6(mips_mmap, unsigned long, addr, unsigned long, len,
 	if (offset & ~PAGE_MASK)
 		goto out;
 
-	result = do_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+	result = sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
 
 out:
 	return result;
@@ -177,7 +152,7 @@ SYSCALL_DEFINE6(mips_mmap2, unsigned long, addr, unsigned long, len,
 	if (pgoff & (~PAGE_MASK >> 12))
 		return -EINVAL;
 
-	return do_mmap2(addr, len, prot, flags, fd, pgoff >> (PAGE_SHIFT-12));
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff >> (PAGE_SHIFT-12));
 }
 
 save_static_function(sys_fork);
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index a94e7ea..c9ee6c0 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -578,7 +578,7 @@ ENTRY(sys_call_table)
 	.long sys_ni_syscall	/* reserved for streams2 */
 	.long sys_vfork		/* 190 */
 	.long sys_getrlimit
-	.long sys_mmap2
+	.long sys_mmap_pgoff
 	.long sys_truncate64
 	.long sys_ftruncate64
 	.long sys_stat64	/* 195 */
diff --git a/arch/mn10300/kernel/sys_mn10300.c b/arch/mn10300/kernel/sys_mn10300.c
index ec4100d..17cc6ce 100644
--- a/arch/mn10300/kernel/sys_mn10300.c
+++ b/arch/mn10300/kernel/sys_mn10300.c
@@ -23,42 +23,13 @@
 
 #include <asm/uaccess.h>
 
-/*
- * memory mapping syscall
- */
-asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
-			  unsigned long prot, unsigned long flags,
-			  unsigned long fd, unsigned long pgoff)
-{
-	struct file *file = NULL;
-	long error = -EINVAL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	error = -EBADF;
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 asmlinkage long old_mmap(unsigned long addr, unsigned long len,
 			 unsigned long prot, unsigned long flags,
 			 unsigned long fd, unsigned long offset)
 {
 	if (offset & ~PAGE_MASK)
 		return -EINVAL;
-	return sys_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
 }
 
 struct sel_arg_struct {
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 71b3195..9147391 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -110,37 +110,14 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	return addr;
 }
 
-static unsigned long do_mmap2(unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags, unsigned long fd,
-	unsigned long pgoff)
-{
-	struct file * file = NULL;
-	unsigned long error = -EBADF;
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file != NULL)
-		fput(file);
-out:
-	return error;
-}
-
 asmlinkage unsigned long sys_mmap2(unsigned long addr, unsigned long len,
 	unsigned long prot, unsigned long flags, unsigned long fd,
 	unsigned long pgoff)
 {
 	/* Make sure the shift for mmap2 is constant (12), no matter what PAGE_SIZE
 	   we have. */
-	return do_mmap2(addr, len, prot, flags, fd, pgoff >> (PAGE_SHIFT - 12));
+	return sys_mmap_pgoff(addr, len, prot, flags, fd,
+			      pgoff >> (PAGE_SHIFT - 12));
 }
 
 asmlinkage unsigned long sys_mmap(unsigned long addr, unsigned long len,
@@ -148,7 +125,8 @@ asmlinkage unsigned long sys_mmap(unsigned long addr, unsigned long len,
 		unsigned long offset)
 {
 	if (!(offset & ~PAGE_MASK)) {
-		return do_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+		return sys_mmap_pgoff(addr, len, prot, flags, fd,
+					offset >> PAGE_SHIFT);
 	} else {
 		return -EINVAL;
 	}
diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index c04832c..3370e62 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -140,7 +140,6 @@ static inline unsigned long do_mmap2(unsigned long addr, size_t len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, unsigned long off, int shift)
 {
-	struct file * file = NULL;
 	unsigned long ret = -EINVAL;
 
 	if (!arch_validate_prot(prot))
@@ -151,20 +150,8 @@ static inline unsigned long do_mmap2(unsigned long addr, size_t len,
 			goto out;
 		off >>= shift;
 	}
-		
-	ret = -EBADF;
-	if (!(flags & MAP_ANONYMOUS)) {
-		if (!(file = fget(fd)))
-			goto out;
-	}
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	down_write(&current->mm->mmap_sem);
-	ret = do_mmap_pgoff(file, addr, len, prot, flags, off);
-	up_write(&current->mm->mmap_sem);
-	if (file)
-		fput(file);
+	ret = sys_mmap_pgoff(addr, len, prot, flags, fd, off);
 out:
 	return ret;
 }
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index c5a9fba..9c746c0 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -683,33 +683,6 @@ struct mmap_arg_struct_emu31 {
 	u32	offset;
 };
 
-/* common code for old and new mmaps */
-static inline long do_mmap2(
-	unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	struct file * file = NULL;
-	unsigned long error = -EBADF;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:    
-	return error;
-}
-
-
 asmlinkage unsigned long
 old32_mmap(struct mmap_arg_struct_emu31 __user *arg)
 {
@@ -723,7 +696,8 @@ old32_mmap(struct mmap_arg_struct_emu31 __user *arg)
 	if (a.offset & ~PAGE_MASK)
 		goto out;
 
-	error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT); 
+	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
+			       a.offset >> PAGE_SHIFT);
 out:
 	return error;
 }
@@ -736,7 +710,7 @@ sys32_mmap2(struct mmap_arg_struct_emu31 __user *arg)
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		goto out;
-	error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
+	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
 out:
 	return error;
 }
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index e9d94f6..86a74c9 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -32,32 +32,6 @@
 #include <asm/uaccess.h>
 #include "entry.h"
 
-/* common code for old and new mmaps */
-static inline long do_mmap2(
-	unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags,
-	unsigned long fd, unsigned long pgoff)
-{
-	long error = -EBADF;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 /*
  * Perform the select(nd, in, out, ex, tv) and mmap() system
  * calls. Linux for S/390 isn't able to handle more than 5
@@ -81,7 +55,7 @@ SYSCALL_DEFINE1(mmap2, struct mmap_arg_struct __user *, arg)
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		goto out;
-	error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
+	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
 out:
 	return error;
 }
@@ -98,7 +72,7 @@ SYSCALL_DEFINE1(s390_old_mmap, struct mmap_arg_struct __user *, arg)
 	if (a.offset & ~PAGE_MASK)
 		goto out;
 
-	error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
+	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
 out:
 	return error;
 }
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index 0012494..5299a47 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -36,33 +36,18 @@ asmlinkage long
 sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
 	  unsigned long flags, unsigned long fd, unsigned long pgoff)
 {
-	int error = -EBADF;
-	struct file *file = NULL;
-
 	if (pgoff & (~PAGE_MASK >> 12))
 		return -EINVAL;
 
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			return error;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-
-	return error;
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
+	/* sic - almost certainly should shift pgoff as well */
 }
 
 asmlinkage long
 sys_mmap(unsigned long addr, unsigned long len, unsigned long prot,
 	unsigned long flags, unsigned long fd, off_t pgoff)
 {
+	/* where's the alignment check? */
 	return sys_mmap2(addr, len, prot, flags, fd, pgoff >> PAGE_SHIFT);
 }
 
diff --git a/arch/sh/kernel/sys_sh.c b/arch/sh/kernel/sys_sh.c
index 8aa5d1c..71399cd 100644
--- a/arch/sh/kernel/sys_sh.c
+++ b/arch/sh/kernel/sys_sh.c
@@ -28,37 +28,13 @@
 #include <asm/cacheflush.h>
 #include <asm/cachectl.h>
 
-static inline long
-do_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
-	 unsigned long flags, int fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file *file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 asmlinkage int old_mmap(unsigned long addr, unsigned long len,
 	unsigned long prot, unsigned long flags,
 	int fd, unsigned long off)
 {
 	if (off & ~PAGE_MASK)
 		return -EINVAL;
-	return do_mmap2(addr, len, prot, flags, fd, off>>PAGE_SHIFT);
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, off>>PAGE_SHIFT);
 }
 
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
@@ -74,7 +50,7 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 
 	pgoff >>= PAGE_SHIFT - 12;
 
-	return do_mmap2(addr, len, prot, flags, fd, pgoff);
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
 
 /*
diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index 10c43be..36f6f26 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -234,31 +234,6 @@ int sparc_mmap_check(unsigned long addr, unsigned long len)
 }
 
 /* Linux version of mmap */
-static unsigned long do_mmap2(unsigned long addr, unsigned long len,
-	unsigned long prot, unsigned long flags, unsigned long fd,
-	unsigned long pgoff)
-{
-	struct file * file = NULL;
-	unsigned long retval = -EBADF;
-
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	len = PAGE_ALIGN(len);
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	down_write(&current->mm->mmap_sem);
-	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return retval;
-}
 
 asmlinkage unsigned long sys_mmap2(unsigned long addr, unsigned long len,
 	unsigned long prot, unsigned long flags, unsigned long fd,
@@ -266,14 +241,16 @@ asmlinkage unsigned long sys_mmap2(unsigned long addr, unsigned long len,
 {
 	/* Make sure the shift for mmap2 is constant (12), no matter what PAGE_SIZE
 	   we have. */
-	return do_mmap2(addr, len, prot, flags, fd, pgoff >> (PAGE_SHIFT - 12));
+	return sys_mmap_pgoff(addr, len, prot, flags, fd,
+			      pgoff >> (PAGE_SHIFT - 12));
 }
 
 asmlinkage unsigned long sys_mmap(unsigned long addr, unsigned long len,
 	unsigned long prot, unsigned long flags, unsigned long fd,
 	unsigned long off)
 {
-	return do_mmap2(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
+	/* no alignment check? */
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
 }
 
 long sparc_remap_file_pages(unsigned long start, unsigned long size,
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index d498b32..8f9cd58 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -572,23 +572,13 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags, unsigned long, fd,
 		unsigned long, off)
 {
-	struct file * file = NULL;
-	unsigned long retval = -EBADF;
+	unsigned long retval = -EINVAL;
 
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	len = PAGE_ALIGN(len);
-
-	down_write(&current->mm->mmap_sem);
-	retval = do_mmap(file, addr, len, prot, flags, off);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
+	if ((off + PAGE_ALIGN(len)) < off)
+		goto out;
+	if (off & ~PAGE_MASK)
+		goto out;
+	retval = sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
 out:
 	return retval;
 }
diff --git a/arch/um/kernel/syscall.c b/arch/um/kernel/syscall.c
index a4625c7..cccab85 100644
--- a/arch/um/kernel/syscall.c
+++ b/arch/um/kernel/syscall.c
@@ -8,6 +8,7 @@
 #include "linux/mm.h"
 #include "linux/sched.h"
 #include "linux/utsname.h"
+#include "linux/syscalls.h"
 #include "asm/current.h"
 #include "asm/mman.h"
 #include "asm/uaccess.h"
@@ -37,31 +38,6 @@ long sys_vfork(void)
 	return ret;
 }
 
-/* common code for old and new mmaps */
-long sys_mmap2(unsigned long addr, unsigned long len,
-	       unsigned long prot, unsigned long flags,
-	       unsigned long fd, unsigned long pgoff)
-{
-	long error = -EBADF;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
- out:
-	return error;
-}
-
 long old_mmap(unsigned long addr, unsigned long len,
 	      unsigned long prot, unsigned long flags,
 	      unsigned long fd, unsigned long offset)
@@ -70,7 +46,7 @@ long old_mmap(unsigned long addr, unsigned long len,
 	if (offset & ~PAGE_MASK)
 		goto out;
 
-	err = sys_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+	err = sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
  out:
 	return err;
 }
diff --git a/arch/um/sys-i386/shared/sysdep/syscalls.h b/arch/um/sys-i386/shared/sysdep/syscalls.h
index 9056981..e778767 100644
--- a/arch/um/sys-i386/shared/sysdep/syscalls.h
+++ b/arch/um/sys-i386/shared/sysdep/syscalls.h
@@ -20,7 +20,3 @@ extern syscall_handler_t *sys_call_table[];
 #define EXECUTE_SYSCALL(syscall, regs) \
 	((long (*)(struct syscall_args)) \
 	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
-
-extern long sys_mmap2(unsigned long addr, unsigned long len,
-		      unsigned long prot, unsigned long flags,
-		      unsigned long fd, unsigned long pgoff);
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 581b056..5294d84 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -696,7 +696,7 @@ ia32_sys_call_table:
 	.quad quiet_ni_syscall		/* streams2 */
 	.quad stub32_vfork            /* 190 */
 	.quad compat_sys_getrlimit
-	.quad sys32_mmap2
+	.quad sys_mmap_pgoff
 	.quad sys32_truncate64
 	.quad sys32_ftruncate64
 	.quad sys32_stat64		/* 195 */
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 9f55271..016218c 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -155,9 +155,6 @@ struct mmap_arg_struct {
 asmlinkage long sys32_mmap(struct mmap_arg_struct __user *arg)
 {
 	struct mmap_arg_struct a;
-	struct file *file = NULL;
-	unsigned long retval;
-	struct mm_struct *mm ;
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
@@ -165,22 +162,8 @@ asmlinkage long sys32_mmap(struct mmap_arg_struct __user *arg)
 	if (a.offset & ~PAGE_MASK)
 		return -EINVAL;
 
-	if (!(a.flags & MAP_ANONYMOUS)) {
-		file = fget(a.fd);
-		if (!file)
-			return -EBADF;
-	}
-
-	mm = current->mm;
-	down_write(&mm->mmap_sem);
-	retval = do_mmap_pgoff(file, a.addr, a.len, a.prot, a.flags,
+	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
 			       a.offset>>PAGE_SHIFT);
-	if (file)
-		fput(file);
-
-	up_write(&mm->mmap_sem);
-
-	return retval;
 }
 
 asmlinkage long sys32_mprotect(unsigned long start, size_t len,
@@ -539,30 +522,6 @@ asmlinkage long sys32_sendfile(int out_fd, int in_fd,
 	return ret;
 }
 
-asmlinkage long sys32_mmap2(unsigned long addr, unsigned long len,
-			    unsigned long prot, unsigned long flags,
-			    unsigned long fd, unsigned long pgoff)
-{
-	struct mm_struct *mm = current->mm;
-	unsigned long error;
-	struct file *file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			return -EBADF;
-	}
-
-	down_write(&mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&mm->mmap_sem);
-
-	if (file)
-		fput(file);
-	return error;
-}
-
 asmlinkage long sys32_olduname(struct oldold_utsname __user *name)
 {
 	char *arch = "x86_64";
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
index 72a6dcd..77c1184 100644
--- a/arch/x86/include/asm/sys_ia32.h
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -62,9 +62,6 @@ asmlinkage long sys32_pwrite(unsigned int, char __user *, u32, u32, u32);
 asmlinkage long sys32_personality(unsigned long);
 asmlinkage long sys32_sendfile(int, int, compat_off_t __user *, s32);
 
-asmlinkage long sys32_mmap2(unsigned long, unsigned long, unsigned long,
-			    unsigned long, unsigned long, unsigned long);
-
 struct oldold_utsname;
 struct old_utsname;
 asmlinkage long sys32_olduname(struct oldold_utsname __user *);
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 372b76e..1bb6e39 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -55,8 +55,6 @@ struct sel_arg_struct;
 struct oldold_utsname;
 struct old_utsname;
 
-asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
-			  unsigned long, unsigned long, unsigned long);
 asmlinkage int old_mmap(struct mmap_arg_struct __user *);
 asmlinkage int old_select(struct sel_arg_struct __user *);
 asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index 1884a8d..dee1ff7 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -24,31 +24,6 @@
 
 #include <asm/syscalls.h>
 
-asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
-			  unsigned long prot, unsigned long flags,
-			  unsigned long fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file *file = NULL;
-	struct mm_struct *mm = current->mm;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 /*
  * Perform the select(nd, in, out, ex, tv) and mmap() system
  * calls. Linux/i386 didn't use to be able to handle more than
@@ -77,7 +52,7 @@ asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
 	if (a.offset & ~PAGE_MASK)
 		goto out;
 
-	err = sys_mmap2(a.addr, a.len, a.prot, a.flags,
+	err = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags,
 			a.fd, a.offset >> PAGE_SHIFT);
 out:
 	return err;
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 45e00eb..8aa2057 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -23,26 +23,11 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, fd, unsigned long, off)
 {
 	long error;
-	struct file *file;
-
 	error = -EINVAL;
 	if (off & ~PAGE_MASK)
 		goto out;
 
-	error = -EBADF;
-	file = NULL;
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, off >> PAGE_SHIFT);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
+	error = sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
 out:
 	return error;
 }
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 0157cd2..76d70a4 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -191,7 +191,7 @@ ENTRY(sys_call_table)
 	.long sys_ni_syscall	/* reserved for streams2 */
 	.long ptregs_vfork	/* 190 */
 	.long sys_getrlimit
-	.long sys_mmap2
+	.long sys_mmap_pgoff
 	.long sys_truncate64
 	.long sys_ftruncate64
 	.long sys_stat64	/* 195 */
diff --git a/arch/xtensa/include/asm/syscall.h b/arch/xtensa/include/asm/syscall.h
index 05cebf8..4352dbe 100644
--- a/arch/xtensa/include/asm/syscall.h
+++ b/arch/xtensa/include/asm/syscall.h
@@ -13,8 +13,6 @@ struct sigaction;
 asmlinkage long xtensa_execve(char*, char**, char**, struct pt_regs*);
 asmlinkage long xtensa_clone(unsigned long, unsigned long, struct pt_regs*);
 asmlinkage long xtensa_pipe(int __user *);
-asmlinkage long xtensa_mmap2(unsigned long, unsigned long, unsigned long,
-    			     unsigned long, unsigned long, unsigned long);
 asmlinkage long xtensa_ptrace(long, long, long, long);
 asmlinkage long xtensa_sigreturn(struct pt_regs*);
 asmlinkage long xtensa_rt_sigreturn(struct pt_regs*);
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index c092c8f..9a5c354 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -189,7 +189,7 @@ __SYSCALL( 79, sys_fremovexattr, 2)
 /* File Map / Shared Memory Operations */
 
 #define __NR_mmap2 				 80
-__SYSCALL( 80, xtensa_mmap2, 6)
+__SYSCALL( 80, sys_mmap_pgoff, 6)
 #define __NR_munmap 				 81
 __SYSCALL( 81, sys_munmap, 2)
 #define __NR_mprotect 				 82
diff --git a/arch/xtensa/kernel/syscall.c b/arch/xtensa/kernel/syscall.c
index ac15ecb..1e67bab 100644
--- a/arch/xtensa/kernel/syscall.c
+++ b/arch/xtensa/kernel/syscall.c
@@ -57,31 +57,6 @@ asmlinkage long xtensa_pipe(int __user *userfds)
 	return error;
 }
 
-
-asmlinkage long xtensa_mmap2(unsigned long addr, unsigned long len,
-   			     unsigned long prot, unsigned long flags,
-			     unsigned long fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
 asmlinkage long xtensa_shmat(int shmid, char __user *shmaddr, int shmflg)
 {
 	unsigned long ret;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a990ace..93515c6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -879,4 +879,8 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 asmlinkage long sys_perf_event_open(
 		struct perf_event_attr __user *attr_uptr,
 		pid_t pid, int cpu, int group_fd, unsigned long flags);
+
+asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, unsigned long pgoff);
 #endif
diff --git a/mm/util.c b/mm/util.c
index 7c35ad9..3bf81b2 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -4,6 +4,10 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/sched.h>
+#include <linux/hugetlb.h>
+#include <linux/syscalls.h>
+#include <linux/mman.h>
+#include <linux/file.h>
 #include <asm/uaccess.h>
 
 #define CREATE_TRACE_POINTS
@@ -268,6 +272,31 @@ int __attribute__((weak)) get_user_pages_fast(unsigned long start,
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
+SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, pgoff)
+{
+	struct file * file = NULL;
+	unsigned long retval = -EBADF;
+
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file)
+			goto out;
+	}
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+
+	down_write(&current->mm->mmap_sem);
+	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+
+	if (file)
+		fput(file);
+out:
+	return retval;
+}
+
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
-- 
1.5.6.5


