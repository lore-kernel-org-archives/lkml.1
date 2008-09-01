Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYIADGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYIADGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 23:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYIADGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 23:06:15 -0400
Received: from verein.lst.de ([213.95.11.210]:45135 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYIADGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 23:06:13 -0400
Date: Mon, 1 Sep 2008 05:06:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] compat: move cp_compat_stat to common code
Message-ID: <20080901030612.GA10736@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strcut stat / compat_stat is the same on all architectures, so
cp_compat_stat should be, too.

Turns out it is, except that various architectures have slightly
different bugs in error handling or zeroing the user buffer,
and some high2lowuid/high2lowgid or the direct assignment instead
of the SET_UID/SET_GID that expands to the correct one anyway.

This patch replaces the arch-specific cp_compat_stat implementations
with a common one based on the x86-64 one.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2008-08-22 12:26:45.000000000 -0300
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2008-08-22 12:29:09.000000000 -0300
@@ -118,41 +118,6 @@ sys32_execve (char __user *name, compat_
 	return error;
 }
 
-int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
-{
-	compat_ino_t ino;
-	int err;
-
-	if ((u64) stat->size > MAX_NON_LFS ||
-	    !old_valid_dev(stat->dev) ||
-	    !old_valid_dev(stat->rdev))
-		return -EOVERFLOW;
-
-	ino = stat->ino;
-	if (sizeof(ino) < sizeof(stat->ino) && ino != stat->ino)
-		return -EOVERFLOW;
-
-	if (clear_user(ubuf, sizeof(*ubuf)))
-		return -EFAULT;
-
-	err  = __put_user(old_encode_dev(stat->dev), &ubuf->st_dev);
-	err |= __put_user(ino, &ubuf->st_ino);
-	err |= __put_user(stat->mode, &ubuf->st_mode);
-	err |= __put_user(stat->nlink, &ubuf->st_nlink);
-	err |= __put_user(high2lowuid(stat->uid), &ubuf->st_uid);
-	err |= __put_user(high2lowgid(stat->gid), &ubuf->st_gid);
-	err |= __put_user(old_encode_dev(stat->rdev), &ubuf->st_rdev);
-	err |= __put_user(stat->size, &ubuf->st_size);
-	err |= __put_user(stat->atime.tv_sec, &ubuf->st_atime);
-	err |= __put_user(stat->atime.tv_nsec, &ubuf->st_atime_nsec);
-	err |= __put_user(stat->mtime.tv_sec, &ubuf->st_mtime);
-	err |= __put_user(stat->mtime.tv_nsec, &ubuf->st_mtime_nsec);
-	err |= __put_user(stat->ctime.tv_sec, &ubuf->st_ctime);
-	err |= __put_user(stat->ctime.tv_nsec, &ubuf->st_ctime_nsec);
-	err |= __put_user(stat->blksize, &ubuf->st_blksize);
-	err |= __put_user(stat->blocks, &ubuf->st_blocks);
-	return err;
-}
 
 #if PAGE_SHIFT > IA32_PAGE_SHIFT
 
Index: linux-2.6/arch/mips/kernel/linux32.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/linux32.c	2008-08-22 12:32:37.000000000 -0300
+++ linux-2.6/arch/mips/kernel/linux32.c	2008-08-22 12:32:53.000000000 -0300
@@ -63,41 +63,6 @@
 #define merge_64(r1, r2) ((((r2) & 0xffffffffUL) << 32) + ((r1) & 0xffffffffUL))
 #endif
 
-/*
- * Revalidate the inode. This is required for proper NFS attribute caching.
- */
-
-int cp_compat_stat(struct kstat *stat, struct compat_stat __user *statbuf)
-{
-	struct compat_stat tmp;
-
-	if (!new_valid_dev(stat->dev) || !new_valid_dev(stat->rdev))
-		return -EOVERFLOW;
-
-	memset(&tmp, 0, sizeof(tmp));
-	tmp.st_dev = new_encode_dev(stat->dev);
-	tmp.st_ino = stat->ino;
-	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
-		return -EOVERFLOW;
-	tmp.st_mode = stat->mode;
-	tmp.st_nlink = stat->nlink;
-	SET_UID(tmp.st_uid, stat->uid);
-	SET_GID(tmp.st_gid, stat->gid);
-	tmp.st_rdev = new_encode_dev(stat->rdev);
-	tmp.st_size = stat->size;
-	tmp.st_atime = stat->atime.tv_sec;
-	tmp.st_mtime = stat->mtime.tv_sec;
-	tmp.st_ctime = stat->ctime.tv_sec;
-#ifdef STAT_HAVE_NSEC
-	tmp.st_atime_nsec = stat->atime.tv_nsec;
-	tmp.st_mtime_nsec = stat->mtime.tv_nsec;
-	tmp.st_ctime_nsec = stat->ctime.tv_nsec;
-#endif
-	tmp.st_blocks = stat->blocks;
-	tmp.st_blksize = stat->blksize;
-	return copy_to_user(statbuf, &tmp, sizeof(tmp)) ? -EFAULT : 0;
-}
-
 asmlinkage unsigned long
 sys32_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
          unsigned long flags, unsigned long fd, unsigned long pgoff)
Index: linux-2.6/arch/parisc/kernel/sys_parisc32.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/sys_parisc32.c	2008-08-22 12:35:33.000000000 -0300
+++ linux-2.6/arch/parisc/kernel/sys_parisc32.c	2008-08-22 12:35:47.000000000 -0300
@@ -237,53 +237,6 @@ int sys32_settimeofday(struct compat_tim
 	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
 }
 
-int cp_compat_stat(struct kstat *stat, struct compat_stat __user *statbuf)
-{
-	compat_ino_t ino;
-	int err;
-
-	if (stat->size > MAX_NON_LFS || !new_valid_dev(stat->dev) ||
-	    !new_valid_dev(stat->rdev))
-		return -EOVERFLOW;
-
-	ino = stat->ino;
-	if (sizeof(ino) < sizeof(stat->ino) && ino != stat->ino)
-		return -EOVERFLOW;
-
-	err  = put_user(new_encode_dev(stat->dev), &statbuf->st_dev);
-	err |= put_user(ino, &statbuf->st_ino);
-	err |= put_user(stat->mode, &statbuf->st_mode);
-	err |= put_user(stat->nlink, &statbuf->st_nlink);
-	err |= put_user(0, &statbuf->st_reserved1);
-	err |= put_user(0, &statbuf->st_reserved2);
-	err |= put_user(new_encode_dev(stat->rdev), &statbuf->st_rdev);
-	err |= put_user(stat->size, &statbuf->st_size);
-	err |= put_user(stat->atime.tv_sec, &statbuf->st_atime);
-	err |= put_user(stat->atime.tv_nsec, &statbuf->st_atime_nsec);
-	err |= put_user(stat->mtime.tv_sec, &statbuf->st_mtime);
-	err |= put_user(stat->mtime.tv_nsec, &statbuf->st_mtime_nsec);
-	err |= put_user(stat->ctime.tv_sec, &statbuf->st_ctime);
-	err |= put_user(stat->ctime.tv_nsec, &statbuf->st_ctime_nsec);
-	err |= put_user(stat->blksize, &statbuf->st_blksize);
-	err |= put_user(stat->blocks, &statbuf->st_blocks);
-	err |= put_user(0, &statbuf->__unused1);
-	err |= put_user(0, &statbuf->__unused2);
-	err |= put_user(0, &statbuf->__unused3);
-	err |= put_user(0, &statbuf->__unused4);
-	err |= put_user(0, &statbuf->__unused5);
-	err |= put_user(0, &statbuf->st_fstype); /* not avail */
-	err |= put_user(0, &statbuf->st_realdev); /* not avail */
-	err |= put_user(0, &statbuf->st_basemode); /* not avail */
-	err |= put_user(0, &statbuf->st_spareshort);
-	err |= put_user(stat->uid, &statbuf->st_uid);
-	err |= put_user(stat->gid, &statbuf->st_gid);
-	err |= put_user(0, &statbuf->st_spare4[0]);
-	err |= put_user(0, &statbuf->st_spare4[1]);
-	err |= put_user(0, &statbuf->st_spare4[2]);
-
-	return err;
-}
-
 /*** copied from mips64 ***/
 /*
  * Ooo, nasty.  We need here to frob 32-bit unsigned longs to
Index: linux-2.6/arch/powerpc/kernel/sys_ppc32.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/sys_ppc32.c	2008-08-22 12:37:09.000000000 -0300
+++ linux-2.6/arch/powerpc/kernel/sys_ppc32.c	2008-08-22 12:37:20.000000000 -0300
@@ -61,42 +61,6 @@ asmlinkage long ppc32_select(u32 n, comp
 	return compat_sys_select((int)n, inp, outp, exp, compat_ptr(tvp_x));
 }
 
-int cp_compat_stat(struct kstat *stat, struct compat_stat __user *statbuf)
-{
-	compat_ino_t ino;
-	long err;
-
-	if (stat->size > MAX_NON_LFS || !new_valid_dev(stat->dev) ||
-	    !new_valid_dev(stat->rdev))
-		return -EOVERFLOW;
-
-	ino = stat->ino;
-	if (sizeof(ino) < sizeof(stat->ino) && ino != stat->ino)
-		return -EOVERFLOW;
-
-	err  = access_ok(VERIFY_WRITE, statbuf, sizeof(*statbuf)) ? 0 : -EFAULT;
-	err |= __put_user(new_encode_dev(stat->dev), &statbuf->st_dev);
-	err |= __put_user(ino, &statbuf->st_ino);
-	err |= __put_user(stat->mode, &statbuf->st_mode);
-	err |= __put_user(stat->nlink, &statbuf->st_nlink);
-	err |= __put_user(stat->uid, &statbuf->st_uid);
-	err |= __put_user(stat->gid, &statbuf->st_gid);
-	err |= __put_user(new_encode_dev(stat->rdev), &statbuf->st_rdev);
-	err |= __put_user(stat->size, &statbuf->st_size);
-	err |= __put_user(stat->atime.tv_sec, &statbuf->st_atime);
-	err |= __put_user(stat->atime.tv_nsec, &statbuf->st_atime_nsec);
-	err |= __put_user(stat->mtime.tv_sec, &statbuf->st_mtime);
-	err |= __put_user(stat->mtime.tv_nsec, &statbuf->st_mtime_nsec);
-	err |= __put_user(stat->ctime.tv_sec, &statbuf->st_ctime);
-	err |= __put_user(stat->ctime.tv_nsec, &statbuf->st_ctime_nsec);
-	err |= __put_user(stat->blksize, &statbuf->st_blksize);
-	err |= __put_user(stat->blocks, &statbuf->st_blocks);
-	err |= __put_user(0, &statbuf->__unused4[0]);
-	err |= __put_user(0, &statbuf->__unused4[1]);
-
-	return err;
-}
-
 /* Note: it is necessary to treat option as an unsigned int,
  * with the corresponding cast to a signed int to insure that the 
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
Index: linux-2.6/arch/s390/kernel/compat_linux.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/compat_linux.c	2008-08-22 12:34:23.000000000 -0300
+++ linux-2.6/arch/s390/kernel/compat_linux.c	2008-08-22 12:34:33.000000000 -0300
@@ -362,41 +362,6 @@ asmlinkage long sys32_ftruncate64(unsign
 		return sys_ftruncate(fd, (high << 32) | low);
 }
 
-int cp_compat_stat(struct kstat *stat, struct compat_stat __user *statbuf)
-{
-	compat_ino_t ino;
-	int err;
-
-	if (!old_valid_dev(stat->dev) || !old_valid_dev(stat->rdev))
-		return -EOVERFLOW;
-
-	ino = stat->ino;
-	if (sizeof(ino) < sizeof(stat->ino) && ino != stat->ino)
-		return -EOVERFLOW;
-
-	err = put_user(old_encode_dev(stat->dev), &statbuf->st_dev);
-	err |= put_user(stat->ino, &statbuf->st_ino);
-	err |= put_user(stat->mode, &statbuf->st_mode);
-	err |= put_user(stat->nlink, &statbuf->st_nlink);
-	err |= put_user(high2lowuid(stat->uid), &statbuf->st_uid);
-	err |= put_user(high2lowgid(stat->gid), &statbuf->st_gid);
-	err |= put_user(old_encode_dev(stat->rdev), &statbuf->st_rdev);
-	err |= put_user(stat->size, &statbuf->st_size);
-	err |= put_user(stat->atime.tv_sec, &statbuf->st_atime);
-	err |= put_user(stat->atime.tv_nsec, &statbuf->st_atime_nsec);
-	err |= put_user(stat->mtime.tv_sec, &statbuf->st_mtime);
-	err |= put_user(stat->mtime.tv_nsec, &statbuf->st_mtime_nsec);
-	err |= put_user(stat->ctime.tv_sec, &statbuf->st_ctime);
-	err |= put_user(stat->ctime.tv_nsec, &statbuf->st_ctime_nsec);
-	err |= put_user(stat->blksize, &statbuf->st_blksize);
-	err |= put_user(stat->blocks, &statbuf->st_blocks);
-/* fixme
-	err |= put_user(0, &statbuf->__unused4[0]);
-	err |= put_user(0, &statbuf->__unused4[1]);
-*/
-	return err;
-}
-
 asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
 				struct compat_timespec __user *interval)
 {
Index: linux-2.6/arch/sparc64/kernel/sys_sparc32.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/sys_sparc32.c	2008-08-22 12:38:07.000000000 -0300
+++ linux-2.6/arch/sparc64/kernel/sys_sparc32.c	2008-08-22 12:38:18.000000000 -0300
@@ -148,41 +148,6 @@ asmlinkage long sys32_ftruncate64(unsign
 		return sys_ftruncate(fd, (high << 32) | low);
 }
 
-int cp_compat_stat(struct kstat *stat, struct compat_stat __user *statbuf)
-{
-	compat_ino_t ino;
-	int err;
-
-	if (stat->size > MAX_NON_LFS || !old_valid_dev(stat->dev) ||
-	    !old_valid_dev(stat->rdev))
-		return -EOVERFLOW;
-
-	ino = stat->ino;
-	if (sizeof(ino) < sizeof(stat->ino) && ino != stat->ino)
-		return -EOVERFLOW;
-
-	err  = put_user(old_encode_dev(stat->dev), &statbuf->st_dev);
-	err |= put_user(stat->ino, &statbuf->st_ino);
-	err |= put_user(stat->mode, &statbuf->st_mode);
-	err |= put_user(stat->nlink, &statbuf->st_nlink);
-	err |= put_user(high2lowuid(stat->uid), &statbuf->st_uid);
-	err |= put_user(high2lowgid(stat->gid), &statbuf->st_gid);
-	err |= put_user(old_encode_dev(stat->rdev), &statbuf->st_rdev);
-	err |= put_user(stat->size, &statbuf->st_size);
-	err |= put_user(stat->atime.tv_sec, &statbuf->st_atime);
-	err |= put_user(stat->atime.tv_nsec, &statbuf->st_atime_nsec);
-	err |= put_user(stat->mtime.tv_sec, &statbuf->st_mtime);
-	err |= put_user(stat->mtime.tv_nsec, &statbuf->st_mtime_nsec);
-	err |= put_user(stat->ctime.tv_sec, &statbuf->st_ctime);
-	err |= put_user(stat->ctime.tv_nsec, &statbuf->st_ctime_nsec);
-	err |= put_user(stat->blksize, &statbuf->st_blksize);
-	err |= put_user(stat->blocks, &statbuf->st_blocks);
-	err |= put_user(0, &statbuf->__unused4[0]);
-	err |= put_user(0, &statbuf->__unused4[1]);
-
-	return err;
-}
-
 static int cp_compat_stat64(struct kstat *stat,
 			    struct compat_stat64 __user *statbuf)
 {
Index: linux-2.6/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2008-08-22 12:26:45.000000000 -0300
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2008-08-22 12:27:30.000000000 -0300
@@ -49,41 +49,6 @@
 
 #define AA(__x)		((unsigned long)(__x))
 
-int cp_compat_stat(struct kstat *kbuf, struct compat_stat __user *ubuf)
-{
-	compat_ino_t ino;
-
-	typeof(ubuf->st_uid) uid = 0;
-	typeof(ubuf->st_gid) gid = 0;
-	SET_UID(uid, kbuf->uid);
-	SET_GID(gid, kbuf->gid);
-	if (!old_valid_dev(kbuf->dev) || !old_valid_dev(kbuf->rdev))
-		return -EOVERFLOW;
-	if (kbuf->size >= 0x7fffffff)
-		return -EOVERFLOW;
-	ino = kbuf->ino;
-	if (sizeof(ino) < sizeof(kbuf->ino) && ino != kbuf->ino)
-		return -EOVERFLOW;
-	if (!access_ok(VERIFY_WRITE, ubuf, sizeof(struct compat_stat)) ||
-	    __put_user(old_encode_dev(kbuf->dev), &ubuf->st_dev) ||
-	    __put_user(ino, &ubuf->st_ino) ||
-	    __put_user(kbuf->mode, &ubuf->st_mode) ||
-	    __put_user(kbuf->nlink, &ubuf->st_nlink) ||
-	    __put_user(uid, &ubuf->st_uid) ||
-	    __put_user(gid, &ubuf->st_gid) ||
-	    __put_user(old_encode_dev(kbuf->rdev), &ubuf->st_rdev) ||
-	    __put_user(kbuf->size, &ubuf->st_size) ||
-	    __put_user(kbuf->atime.tv_sec, &ubuf->st_atime) ||
-	    __put_user(kbuf->atime.tv_nsec, &ubuf->st_atime_nsec) ||
-	    __put_user(kbuf->mtime.tv_sec, &ubuf->st_mtime) ||
-	    __put_user(kbuf->mtime.tv_nsec, &ubuf->st_mtime_nsec) ||
-	    __put_user(kbuf->ctime.tv_sec, &ubuf->st_ctime) ||
-	    __put_user(kbuf->ctime.tv_nsec, &ubuf->st_ctime_nsec) ||
-	    __put_user(kbuf->blksize, &ubuf->st_blksize) ||
-	    __put_user(kbuf->blocks, &ubuf->st_blocks))
-		return -EFAULT;
-	return 0;
-}
 
 asmlinkage long sys32_truncate64(char __user *filename,
 				 unsigned long offset_low,
Index: linux-2.6/fs/compat.c
===================================================================
--- linux-2.6.orig/fs/compat.c	2008-08-22 12:26:45.000000000 -0300
+++ linux-2.6/fs/compat.c	2008-08-22 12:44:55.000000000 -0300
@@ -137,6 +137,45 @@ asmlinkage long compat_sys_utimes(char _
 	return compat_sys_futimesat(AT_FDCWD, filename, t);
 }
 
+static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
+{
+	compat_ino_t ino = stat->ino;
+	typeof(ubuf->st_uid) uid = 0;
+	typeof(ubuf->st_gid) gid = 0;
+	int err;
+
+	SET_UID(uid, stat->uid);
+	SET_GID(gid, stat->gid);
+
+	if ((u64) stat->size > MAX_NON_LFS ||
+	    !old_valid_dev(stat->dev) ||
+	    !old_valid_dev(stat->rdev))
+		return -EOVERFLOW;
+	if (sizeof(ino) < sizeof(stat->ino) && ino != stat->ino)
+		return -EOVERFLOW;
+
+	if (clear_user(ubuf, sizeof(*ubuf)))
+		return -EFAULT;
+
+	err  = __put_user(old_encode_dev(stat->dev), &ubuf->st_dev);
+	err |= __put_user(ino, &ubuf->st_ino);
+	err |= __put_user(stat->mode, &ubuf->st_mode);
+	err |= __put_user(stat->nlink, &ubuf->st_nlink);
+	err |= __put_user(uid, &ubuf->st_uid);
+	err |= __put_user(gid, &ubuf->st_gid);
+	err |= __put_user(old_encode_dev(stat->rdev), &ubuf->st_rdev);
+	err |= __put_user(stat->size, &ubuf->st_size);
+	err |= __put_user(stat->atime.tv_sec, &ubuf->st_atime);
+	err |= __put_user(stat->atime.tv_nsec, &ubuf->st_atime_nsec);
+	err |= __put_user(stat->mtime.tv_sec, &ubuf->st_mtime);
+	err |= __put_user(stat->mtime.tv_nsec, &ubuf->st_mtime_nsec);
+	err |= __put_user(stat->ctime.tv_sec, &ubuf->st_ctime);
+	err |= __put_user(stat->ctime.tv_nsec, &ubuf->st_ctime_nsec);
+	err |= __put_user(stat->blksize, &ubuf->st_blksize);
+	err |= __put_user(stat->blocks, &ubuf->st_blocks);
+	return err;
+}
+
 asmlinkage long compat_sys_newstat(char __user * filename,
 		struct compat_stat __user *statbuf)
 {
Index: linux-2.6/include/linux/compat.h
===================================================================
--- linux-2.6.orig/include/linux/compat.h	2008-08-22 12:40:14.000000000 -0300
+++ linux-2.6/include/linux/compat.h	2008-08-22 12:40:39.000000000 -0300
@@ -78,7 +78,6 @@ typedef struct {
 	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
 } compat_sigset_t;
 
-extern int cp_compat_stat(struct kstat *, struct compat_stat __user *);
 extern int get_compat_timespec(struct timespec *, const struct compat_timespec __user *);
 extern int put_compat_timespec(const struct timespec *, struct compat_timespec __user *);
 
