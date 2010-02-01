Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0BAS7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:59:13 -0500
Received: from verein.lst.de ([213.95.11.210]:58739 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab0BAS7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:59:09 -0500
Date: Mon, 1 Feb 2010 19:56:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: tony.luck@intel.com, ralf@linux-mips.org, kyle@mcmartin.ca,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, davem@davemloft.net, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: [PATCH 4/6] improve sys_personality for compat architectures
Message-ID: <20100201185607.GD11045@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.499 () BAYES_44,REMOVE_REMOVAL_2WORD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an architecture that supports 32-bit compat we need to claim to be
PER_LINUX even if we're actually PER_LINUX32.  Instead of duplicating
the code for that in all architectures and having various bugs in the
handling of personality flags do it once and right in the common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/ia64/ia32/ia32_entry.S
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/ia32_entry.S	2010-01-09 15:59:17.798254100 +0100
+++ linux-2.6/arch/ia64/ia32/ia32_entry.S	2010-01-09 15:59:53.246257041 +0100
@@ -314,7 +314,7 @@ ia32_syscall_table:
 	data8 sys_fchdir
 	data8 sys_ni_syscall	/* sys_bdflush */
 	data8 sys_sysfs		/* 135 */
-	data8 sys32_personality
+	data8 sys_personality
 	data8 sys_ni_syscall	  /* for afs_syscall */
 	data8 sys_setfsuid	/* 16-bit version */
 	data8 sys_setfsgid	/* 16-bit version */
Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2010-01-09 15:54:26.822004121 +0100
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2010-01-09 15:59:34.255256737 +0100
@@ -1867,19 +1867,6 @@ sys32_sendfile (int out_fd, int in_fd, i
 	return ret;
 }
 
-asmlinkage long
-sys32_personality (unsigned int personality)
-{
-	long ret;
-
-	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-
 asmlinkage unsigned long
 sys32_brk (unsigned int brk)
 {
Index: linux-2.6/arch/mips/kernel/linux32.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/linux32.c	2010-01-09 15:54:26.833004126 +0100
+++ linux-2.6/arch/mips/kernel/linux32.c	2010-01-09 16:02:21.474255762 +0100
@@ -266,19 +266,6 @@ SYSCALL_DEFINE1(32_newuname, struct new_
 	return ret;
 }
 
-SYSCALL_DEFINE1(32_personality, unsigned long, personality)
-{
-	int ret;
-	personality &= 0xffffffff;
-	if (personality(current->personality) == PER_LINUX32 &&
-	    personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-
 SYSCALL_DEFINE4(32_sendfile, long, out_fd, long, in_fd,
 	compat_off_t __user *, offset, s32, count)
 {
Index: linux-2.6/arch/mips/kernel/scall64-n32.S
===================================================================
--- linux-2.6.orig/arch/mips/kernel/scall64-n32.S	2010-01-09 16:02:16.619010490 +0100
+++ linux-2.6/arch/mips/kernel/scall64-n32.S	2010-01-09 16:02:25.979009804 +0100
@@ -252,7 +252,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys32_sigaltstack
 	PTR	compat_sys_utime		/* 6130 */
 	PTR	sys_mknod
-	PTR	sys_32_personality
+	PTR	sys_personality
 	PTR	compat_sys_ustat
 	PTR	compat_sys_statfs
 	PTR	compat_sys_fstatfs		/* 6135 */
Index: linux-2.6/arch/mips/kernel/scall64-o32.S
===================================================================
--- linux-2.6.orig/arch/mips/kernel/scall64-o32.S	2010-01-09 16:02:16.629003942 +0100
+++ linux-2.6/arch/mips/kernel/scall64-o32.S	2010-01-09 16:02:30.447006413 +0100
@@ -339,7 +339,7 @@ sys_call_table:
 	PTR	sys_fchdir
 	PTR	sys_bdflush
 	PTR	sys_sysfs			/* 4135 */
-	PTR	sys_32_personality
+	PTR	sys_personality
 	PTR	sys_ni_syscall	 		/* for afs_syscall */
 	PTR	sys_setfsuid
 	PTR	sys_setfsgid
Index: linux-2.6/arch/parisc/kernel/sys_parisc.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/sys_parisc.c	2010-01-09 15:54:26.845004188 +0100
+++ linux-2.6/arch/parisc/kernel/sys_parisc.c	2010-01-09 16:02:59.107284814 +0100
@@ -220,21 +220,6 @@ asmlinkage int sys_free_hugepages(unsign
 	return -EINVAL;
 }
 
-long parisc_personality(unsigned long personality)
-{
-	long err;
-
-	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
-
-	err = sys_personality(personality);
-	if (err == PER_LINUX32)
-		err = PER_LINUX;
-
-	return err;
-}
-
 long parisc_newuname(struct new_utsname __user *name)
 {
 	int err = sys_newuname(name);
Index: linux-2.6/arch/parisc/kernel/syscall_table.S
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/syscall_table.S	2010-01-09 16:03:09.201254147 +0100
+++ linux-2.6/arch/parisc/kernel/syscall_table.S	2010-01-09 16:03:19.524006340 +0100
@@ -216,7 +216,7 @@
 	ENTRY_SAME(fchdir)
 	ENTRY_SAME(bdflush)
 	ENTRY_SAME(sysfs)		/* 135 */
-	ENTRY_OURS(personality)
+	ENTRY_SAME(personality)
 	ENTRY_SAME(ni_syscall)	/* for afs_syscall */
 	ENTRY_SAME(setfsuid)
 	ENTRY_SAME(setfsgid)
Index: linux-2.6/arch/powerpc/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/syscalls.h	2010-01-09 16:03:50.533254207 +0100
+++ linux-2.6/arch/powerpc/include/asm/syscalls.h	2010-01-09 16:04:09.905006020 +0100
@@ -35,7 +35,6 @@ asmlinkage long sys_pipe2(int __user *fi
 asmlinkage long sys_rt_sigaction(int sig,
 		const struct sigaction __user *act,
 		struct sigaction __user *oact, size_t sigsetsize);
-asmlinkage long ppc64_personality(unsigned long personality);
 asmlinkage int ppc_rtas(struct rtas_args __user *uargs);
 asmlinkage time_t sys64_time(time_t __user * tloc);
 asmlinkage long ppc_newuname(struct new_utsname __user * name);
Index: linux-2.6/arch/powerpc/include/asm/systbl.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/systbl.h	2010-01-09 16:03:50.545011431 +0100
+++ linux-2.6/arch/powerpc/include/asm/systbl.h	2010-01-09 16:04:35.106016944 +0100
@@ -139,7 +139,7 @@ COMPAT_SYS_SPU(getpgid)
 SYSCALL_SPU(fchdir)
 SYSCALL_SPU(bdflush)
 COMPAT_SYS(sysfs)
-SYSX_SPU(ppc64_personality,ppc64_personality,sys_personality)
+SYSCALL_SPU(personality)
 SYSCALL(ni_syscall)
 SYSCALL_SPU(setfsuid)
 SYSCALL_SPU(setfsgid)
Index: linux-2.6/arch/powerpc/kernel/syscalls.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/syscalls.c	2010-01-09 15:54:26.864028329 +0100
+++ linux-2.6/arch/powerpc/kernel/syscalls.c	2010-01-09 16:04:05.443006187 +0100
@@ -102,21 +102,6 @@ ppc_select(int n, fd_set __user *inp, fd
 #endif
 
 #ifdef CONFIG_PPC64
-long ppc64_personality(unsigned long personality)
-{
-	long ret;
-
-	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-#endif
-
-#ifdef CONFIG_PPC64
 #define OVERRIDE_MACHINE    (personality(current->personality) == PER_LINUX32)
 #else
 #define OVERRIDE_MACHINE    0
Index: linux-2.6/arch/s390/kernel/compat_wrapper.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/compat_wrapper.S	2010-01-09 16:01:01.331004004 +0100
+++ linux-2.6/arch/s390/kernel/compat_wrapper.S	2010-01-09 16:01:34.845278668 +0100
@@ -615,7 +615,7 @@ sys32_sysfs_wrapper:
 	.globl	sys32_personality_wrapper
 sys32_personality_wrapper:
 	llgfr	%r2,%r2			# unsigned long
-	jg	sys_s390_personality	# branch to system call
+	jg	sys_personality		# branch to system call
 
 	.globl	sys32_setfsuid16_wrapper
 sys32_setfsuid16_wrapper:
Index: linux-2.6/arch/s390/kernel/entry.h
===================================================================
--- linux-2.6.orig/arch/s390/kernel/entry.h	2010-01-09 16:01:01.303003789 +0100
+++ linux-2.6/arch/s390/kernel/entry.h	2010-01-09 16:01:17.120005686 +0100
@@ -33,7 +33,6 @@ long sys_mmap2(struct s390_mmap_arg_stru
 long sys_s390_ipc(uint call, int first, unsigned long second,
 	     unsigned long third, void __user *ptr);
 long sys_s390_newuname(struct new_utsname __user *name);
-long sys_s390_personality(unsigned long personality);
 long sys_s390_fadvise64(int fd, u32 offset_high, u32 offset_low,
 		    size_t len, int advice);
 long sys_s390_fadvise64_64(struct fadvise64_64_args __user *args);
Index: linux-2.6/arch/s390/kernel/sys_s390.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/sys_s390.c	2010-01-09 15:54:26.875004240 +0100
+++ linux-2.6/arch/s390/kernel/sys_s390.c	2010-01-09 16:01:35.909033444 +0100
@@ -141,19 +141,6 @@ SYSCALL_DEFINE1(s390_newuname, struct ne
 	}
 	return ret;
 }
-
-SYSCALL_DEFINE1(s390_personality, unsigned long, personality)
-{
-	int ret;
-
-	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-
-	return ret;
-}
 #endif /* CONFIG_64BIT */
 
 /*
Index: linux-2.6/arch/s390/kernel/syscalls.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/syscalls.S	2010-01-09 16:01:01.321004266 +0100
+++ linux-2.6/arch/s390/kernel/syscalls.S	2010-01-09 16:01:25.248256321 +0100
@@ -144,7 +144,7 @@ SYSCALL(sys_getpgid,sys_getpgid,sys32_ge
 SYSCALL(sys_fchdir,sys_fchdir,sys32_fchdir_wrapper)
 SYSCALL(sys_bdflush,sys_bdflush,sys32_bdflush_wrapper)
 SYSCALL(sys_sysfs,sys_sysfs,sys32_sysfs_wrapper)		/* 135 */
-SYSCALL(sys_personality,sys_s390_personality,sys32_personality_wrapper)
+SYSCALL(sys_personality,sys_personality,sys32_personality_wrapper)
 NI_SYSCALL							/* for afs_syscall */
 SYSCALL(sys_setfsuid16,sys_ni_syscall,sys32_setfsuid16_wrapper)	/* old setfsuid16 syscall */
 SYSCALL(sys_setfsgid16,sys_ni_syscall,sys32_setfsgid16_wrapper)	/* old setfsgid16 syscall */
Index: linux-2.6/arch/sparc/kernel/sys_sparc_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/sys_sparc_64.c	2010-01-09 15:54:26.892253994 +0100
+++ linux-2.6/arch/sparc/kernel/sys_sparc_64.c	2010-01-09 16:05:19.386006452 +0100
@@ -522,20 +522,6 @@ SYSCALL_DEFINE1(sparc64_newuname, struct
 	return ret;
 }
 
-SYSCALL_DEFINE1(sparc64_personality, unsigned long, personality)
-{
-	int ret;
-
-	if (current->personality == PER_LINUX32 &&
-	    personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-
-	return ret;
-}
-
 int sparc_mmap_check(unsigned long addr, unsigned long len)
 {
 	if (test_thread_flag(TIF_32BIT)) {
Index: linux-2.6/arch/sparc/kernel/systbls.h
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/systbls.h	2010-01-09 16:05:09.055003976 +0100
+++ linux-2.6/arch/sparc/kernel/systbls.h	2010-01-09 16:05:22.368014946 +0100
@@ -15,7 +15,6 @@ extern asmlinkage long sys_sparc_ipc(uns
 			       unsigned long third,
 			       void __user *ptr, long fifth);
 extern asmlinkage long sparc64_newuname(struct new_utsname __user *name);
-extern asmlinkage long sparc64_personality(unsigned long personality);
 extern asmlinkage long sys64_munmap(unsigned long addr, size_t len);
 extern asmlinkage unsigned long sys64_mremap(unsigned long addr,
 					     unsigned long old_len,
Index: linux-2.6/arch/sparc/kernel/systbls_64.S
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/systbls_64.S	2010-01-09 16:05:09.066003772 +0100
+++ linux-2.6/arch/sparc/kernel/systbls_64.S	2010-01-09 16:05:34.090007134 +0100
@@ -56,7 +56,7 @@ sys_call_table32:
 	.word sys_setsid, sys_fchdir, sys32_fgetxattr, sys_listxattr, sys_llistxattr
 /*180*/	.word sys32_flistxattr, sys_removexattr, sys_lremovexattr, compat_sys_sigpending, sys_ni_syscall
 	.word sys32_setpgid, sys32_fremovexattr, sys32_tkill, sys32_exit_group, sys_sparc64_newuname
-/*190*/	.word sys32_init_module, sys_sparc64_personality, sys_remap_file_pages, sys32_epoll_create, sys32_epoll_ctl
+/*190*/	.word sys32_init_module, sys_personality, sys_remap_file_pages, sys32_epoll_create, sys32_epoll_ctl
 	.word sys32_epoll_wait, sys32_ioprio_set, sys_getppid, sys32_sigaction, sys_sgetmask
 /*200*/	.word sys32_ssetmask, sys_sigsuspend, compat_sys_newlstat, sys_uselib, compat_sys_old_readdir
 	.word sys32_readahead, sys32_socketcall, sys32_syslog, sys32_lookup_dcookie, sys32_fadvise64
@@ -131,7 +131,7 @@ sys_call_table:
 	.word sys_setsid, sys_fchdir, sys_fgetxattr, sys_listxattr, sys_llistxattr
 /*180*/	.word sys_flistxattr, sys_removexattr, sys_lremovexattr, sys_nis_syscall, sys_ni_syscall
 	.word sys_setpgid, sys_fremovexattr, sys_tkill, sys_exit_group, sys_sparc64_newuname
-/*190*/	.word sys_init_module, sys_sparc64_personality, sys_remap_file_pages, sys_epoll_create, sys_epoll_ctl
+/*190*/	.word sys_init_module, sys_personality, sys_remap_file_pages, sys_epoll_create, sys_epoll_ctl
 	.word sys_epoll_wait, sys_ioprio_set, sys_getppid, sys_nis_syscall, sys_sgetmask
 /*200*/	.word sys_ssetmask, sys_nis_syscall, sys_newlstat, sys_uselib, sys_nis_syscall
 	.word sys_readahead, sys_socketcall, sys_syslog, sys_lookup_dcookie, sys_fadvise64
Index: linux-2.6/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2010-01-09 15:54:26.902011033 +0100
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2010-01-09 16:00:03.493006184 +0100
@@ -414,20 +414,6 @@ asmlinkage long sys32_pwrite(unsigned in
 			  ((loff_t)AA(poshi) << 32) | AA(poslo));
 }
 
-
-asmlinkage long sys32_personality(unsigned long personality)
-{
-	int ret;
-
-	if (personality(current->personality) == PER_LINUX32 &&
-		personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-
 asmlinkage long sys32_sendfile(int out_fd, int in_fd,
 			       compat_off_t __user *offset, s32 count)
 {
Index: linux-2.6/arch/x86/include/asm/sys_ia32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/sys_ia32.h	2010-01-09 15:59:17.810253534 +0100
+++ linux-2.6/arch/x86/include/asm/sys_ia32.h	2010-01-09 15:59:50.459006232 +0100
@@ -51,7 +51,6 @@ asmlinkage long sys32_rt_sigqueueinfo(in
 asmlinkage long sys32_pread(unsigned int, char __user *, u32, u32, u32);
 asmlinkage long sys32_pwrite(unsigned int, char __user *, u32, u32, u32);
 
-asmlinkage long sys32_personality(unsigned long);
 asmlinkage long sys32_sendfile(int, int, compat_off_t __user *, s32);
 
 struct oldold_utsname;
Index: linux-2.6/kernel/exec_domain.c
===================================================================
--- linux-2.6.orig/kernel/exec_domain.c	2010-01-09 15:54:26.811263995 +0100
+++ linux-2.6/kernel/exec_domain.c	2010-01-09 15:58:46.675006021 +0100
@@ -188,17 +188,26 @@ static int __init proc_execdomains_init(
 module_init(proc_execdomains_init);
 #endif
 
+/*
+ * Get/set the personality.
+ *
+ * Note that we simply return PER_LINUX even if we actually have a 32-bit
+ * task (PER_LINUX32) as this is expected by 32-bit userland.
+ */
 SYSCALL_DEFINE1(personality, u_long, personality)
 {
 	u_long old = current->personality;
 
 	if (personality != 0xffffffff) {
+		if (personality(old) == PER_LINUX32 &&
+		    personality == PER_LINUX)
+			personality = PER_LINUX32;
 		set_personality(personality);
 		if (current->personality != personality)
 			return -EINVAL;
 	}
 
-	return (long)old;
+	return (long)(old == PER_LINUX32 ? PER_LINUX : old);
 }
 
 
