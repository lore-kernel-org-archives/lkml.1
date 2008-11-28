Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYK1JJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYK1JJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYK1JJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:09:41 -0500
Received: from verein.lst.de ([213.95.11.210]:52959 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYK1JJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:09:38 -0500
Date: Fri, 28 Nov 2008 10:09:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: linux-kernel@vger.kernel.org
Cc: sandeen@sandeen.net, davem@davemloft.net, tony.luck@intel.com,
       ralf@linux-mips.org, kyle@mcmartin.ca, schwidefsky@de.ibm.com
Subject: Re: [PATCH] generic compat_sys_ustat
Message-ID: <20081128090909.GA28299@lst.de>
References: <20081121084105.GA7155@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121084105.GA7155@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.499 () BAYES_44,REMOVE_REMOVAL_2WORD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a different size of ino_t ustat needs a compat handler, but
currently only x86 and mips provide one.  Add a generic compat_sys_ustat
and switch all architectures over to it.  Instead of doing various
user copy hacks compat_sys_ustat just reimplements sys_ustat as
it's trivial.  This was suggested by Arnd Bergmann.

Found by Eric Sandeen when running xfstests/017 on ppc64, which causes
stack smashing warnings on RHEL/Fedora due to the too large amount of
data writen by the syscall.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: linux-2.6/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86/ia32/ia32entry.S	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/x86/ia32/ia32entry.S	2008-11-28 14:09:16.000000000 +0530
@@ -555,7 +555,7 @@ ia32_sys_call_table:
 	.quad sys32_olduname
 	.quad sys_umask		/* 60 */
 	.quad sys_chroot
-	.quad sys32_ustat
+	.quad compat_sys_ustat
 	.quad sys_dup2
 	.quad sys_getppid
 	.quad sys_getpgrp		/* 65 */
Index: linux-2.6/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2008-11-28 14:09:16.000000000 +0530
@@ -638,28 +638,6 @@ long sys32_uname(struct old_utsname __us
 	return err ? -EFAULT : 0;
 }
 
-long sys32_ustat(unsigned dev, struct ustat32 __user *u32p)
-{
-	struct ustat u;
-	mm_segment_t seg;
-	int ret;
-
-	seg = get_fs();
-	set_fs(KERNEL_DS);
-	ret = sys_ustat(dev, (struct ustat __user *)&u);
-	set_fs(seg);
-	if (ret < 0)
-		return ret;
-
-	if (!access_ok(VERIFY_WRITE, u32p, sizeof(struct ustat32)) ||
-	    __put_user((__u32) u.f_tfree, &u32p->f_tfree) ||
-	    __put_user((__u32) u.f_tinode, &u32p->f_tfree) ||
-	    __copy_to_user(&u32p->f_fname, u.f_fname, sizeof(u.f_fname)) ||
-	    __copy_to_user(&u32p->f_fpack, u.f_fpack, sizeof(u.f_fpack)))
-		ret = -EFAULT;
-	return ret;
-}
-
 asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 			     compat_uptr_t __user *envp, struct pt_regs *regs)
 {
Index: linux-2.6/fs/compat.c
===================================================================
--- linux-2.6.orig/fs/compat.c	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/fs/compat.c	2008-11-28 14:09:16.000000000 +0530
@@ -378,6 +378,34 @@ out:
 	return error;
 }
 
+/*
+ * This is a copy of sys_ustat, just dealing with a structure layout.
+ * Given how simple this syscall is that apporach is more maintainable
+ * than the various conversion hacks.
+ */
+asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u)
+{
+	struct super_block *sb;
+	struct compat_ustat tmp;
+	struct kstatfs sbuf;
+	int err;
+
+	sb = user_get_super(new_decode_dev(dev));
+	if (!sb)
+		return -EINVAL;
+	err = vfs_statfs(sb->s_root, &sbuf);
+	drop_super(sb);
+	if (err)
+		return err;
+
+	memset(&tmp, 0, sizeof(struct compat_ustat));
+	tmp.f_tfree = sbuf.f_bfree;
+	tmp.f_tinode = sbuf.f_ffree;
+	if (copy_to_user(u, &tmp, sizeof(struct compat_ustat)))
+		return -EFAULT;
+	return 0;
+}
+
 static int get_compat_flock(struct flock *kfl, struct compat_flock __user *ufl)
 {
 	if (!access_ok(VERIFY_READ, ufl, sizeof(*ufl)) ||
Index: linux-2.6/include/linux/compat.h
===================================================================
--- linux-2.6.orig/include/linux/compat.h	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/include/linux/compat.h	2008-11-28 14:09:16.000000000 +0530
@@ -125,6 +125,13 @@ struct compat_dirent {
 	char		d_name[256];
 };
 
+struct compat_ustat {
+	compat_daddr_t		f_tfree;
+	compat_ino_t		f_tinode;
+	char			f_fname[6];
+	char			f_fpack[6];
+};
+
 typedef union compat_sigval {
 	compat_int_t	sival_int;
 	compat_uptr_t	sival_ptr;
@@ -178,6 +185,7 @@ long compat_sys_semtimedop(int semid, st
 		unsigned nsems, const struct compat_timespec __user *timeout);
 asmlinkage long compat_sys_keyctl(u32 option,
 			      u32 arg2, u32 arg3, u32 arg4, u32 arg5);
+asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32);
 
 asmlinkage ssize_t compat_sys_readv(unsigned long fd,
 		const struct compat_iovec __user *vec, unsigned long vlen);
Index: linux-2.6/arch/ia64/ia32/ia32_entry.S
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/ia32_entry.S	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/ia64/ia32/ia32_entry.S	2008-11-28 14:09:16.000000000 +0530
@@ -240,7 +240,7 @@ ia32_syscall_table:
 	data8 sys_ni_syscall
 	data8 sys_umask		  /* 60 */
 	data8 sys_chroot
-	data8 sys_ustat
+	data8 compat_sys_ustat
 	data8 sys_dup2
 	data8 sys_getppid
 	data8 sys_getpgrp	  /* 65 */
Index: linux-2.6/arch/mips/kernel/linux32.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/linux32.c	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/mips/kernel/linux32.c	2008-11-28 14:09:16.000000000 +0530
@@ -347,40 +347,6 @@ asmlinkage int sys32_personality(unsigne
 	return ret;
 }
 
-/* ustat compatibility */
-struct ustat32 {
-	compat_daddr_t	f_tfree;
-	compat_ino_t	f_tinode;
-	char		f_fname[6];
-	char		f_fpack[6];
-};
-
-extern asmlinkage long sys_ustat(dev_t dev, struct ustat __user * ubuf);
-
-asmlinkage int sys32_ustat(dev_t dev, struct ustat32 __user * ubuf32)
-{
-	int err;
-	struct ustat tmp;
-	struct ustat32 tmp32;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	err = sys_ustat(dev, (struct ustat __user *)&tmp);
-	set_fs(old_fs);
-
-	if (err)
-		goto out;
-
-	memset(&tmp32, 0, sizeof(struct ustat32));
-	tmp32.f_tfree = tmp.f_tfree;
-	tmp32.f_tinode = tmp.f_tinode;
-
-	err = copy_to_user(ubuf32, &tmp32, sizeof(struct ustat32)) ? -EFAULT : 0;
-
-out:
-	return err;
-}
-
 asmlinkage int sys32_sendfile(int out_fd, int in_fd, compat_off_t __user *offset,
 	s32 count)
 {
Index: linux-2.6/arch/mips/kernel/scall64-n32.S
===================================================================
--- linux-2.6.orig/arch/mips/kernel/scall64-n32.S	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/mips/kernel/scall64-n32.S	2008-11-28 14:09:16.000000000 +0530
@@ -253,7 +253,7 @@ EXPORT(sysn32_call_table)
 	PTR	compat_sys_utime		/* 6130 */
 	PTR	sys_mknod
 	PTR	sys32_personality
-	PTR	sys32_ustat
+	PTR	compat_sys_ustat
 	PTR	compat_sys_statfs
 	PTR	compat_sys_fstatfs		/* 6135 */
 	PTR	sys_sysfs
Index: linux-2.6/arch/mips/kernel/scall64-o32.S
===================================================================
--- linux-2.6.orig/arch/mips/kernel/scall64-o32.S	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/mips/kernel/scall64-o32.S	2008-11-28 14:09:16.000000000 +0530
@@ -267,7 +267,7 @@ sys_call_table:
 	PTR	sys_olduname
 	PTR	sys_umask			/* 4060 */
 	PTR	sys_chroot
-	PTR	sys32_ustat
+	PTR	compat_sys_ustat
 	PTR	sys_dup2
 	PTR	sys_getppid
 	PTR	sys_getpgrp			/* 4065 */
Index: linux-2.6/arch/parisc/kernel/syscall_table.S
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/syscall_table.S	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/parisc/kernel/syscall_table.S	2008-11-28 14:09:16.000000000 +0530
@@ -130,7 +130,7 @@
 	ENTRY_OURS(newuname)
 	ENTRY_SAME(umask)		/* 60 */
 	ENTRY_SAME(chroot)
-	ENTRY_SAME(ustat)
+	ENTRY_COMP(ustat)
 	ENTRY_SAME(dup2)
 	ENTRY_SAME(getppid)
 	ENTRY_SAME(getpgrp)		/* 65 */
Index: linux-2.6/arch/powerpc/include/asm/systbl.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/systbl.h	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/powerpc/include/asm/systbl.h	2008-11-28 14:09:16.000000000 +0530
@@ -65,7 +65,7 @@ SYSCALL(ni_syscall)
 SYSX(sys_ni_syscall,sys_olduname, sys_olduname)
 COMPAT_SYS_SPU(umask)
 SYSCALL_SPU(chroot)
-SYSCALL(ustat)
+COMPAT_SYS(ustat)
 SYSCALL_SPU(dup2)
 SYSCALL_SPU(getppid)
 SYSCALL_SPU(getpgrp)
Index: linux-2.6/arch/s390/kernel/compat_wrapper.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/compat_wrapper.S	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/s390/kernel/compat_wrapper.S	2008-11-28 14:09:16.000000000 +0530
@@ -252,7 +252,7 @@ sys32_chroot_wrapper:
 sys32_ustat_wrapper:
 	llgfr	%r2,%r2			# dev_t
 	llgtr	%r3,%r3			# struct ustat *
-	jg	sys_ustat
+	jg	compat_sys_ustat
 
 	.globl	sys32_dup2_wrapper
 sys32_dup2_wrapper:
Index: linux-2.6/arch/sparc64/kernel/systbls.S
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/systbls.S	2008-11-28 14:09:01.000000000 +0530
+++ linux-2.6/arch/sparc64/kernel/systbls.S	2008-11-28 14:09:16.000000000 +0530
@@ -51,7 +51,7 @@ sys_call_table32:
 /*150*/	.word sys_nis_syscall, sys_inotify_init, sys_inotify_add_watch, sys_poll, sys_getdents64
 	.word compat_sys_fcntl64, sys_inotify_rm_watch, compat_sys_statfs, compat_sys_fstatfs, sys_oldumount
 /*160*/	.word compat_sys_sched_setaffinity, compat_sys_sched_getaffinity, sys32_getdomainname, sys32_setdomainname, sys_nis_syscall
-	.word sys_quotactl, sys_set_tid_address, compat_sys_mount, sys_ustat, sys32_setxattr
+	.word sys_quotactl, sys_set_tid_address, compat_sys_mount, compat_sys_ustat, sys32_setxattr
 /*170*/	.word sys32_lsetxattr, sys32_fsetxattr, sys_getxattr, sys_lgetxattr, compat_sys_getdents
 	.word sys_setsid, sys_fchdir, sys32_fgetxattr, sys_listxattr, sys_llistxattr
 /*180*/	.word sys32_flistxattr, sys_removexattr, sys_lremovexattr, compat_sys_sigpending, sys_ni_syscall
Index: linux-2.6/arch/x86/include/asm/ia32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/ia32.h	2008-11-28 14:10:12.000000000 +0530
+++ linux-2.6/arch/x86/include/asm/ia32.h	2008-11-28 14:10:36.000000000 +0530
@@ -147,13 +147,6 @@ struct rt_sigframe32 {
 	struct _fpstate_ia32 fpstate;
 };
 
-struct ustat32 {
-	__u32			f_tfree;
-	compat_ino_t		f_tinode;
-	char			f_fname[6];
-	char			f_fpack[6];
-};
-
 #define IA32_STACK_TOP IA32_PAGE_OFFSET
 
 #ifdef __KERNEL__
