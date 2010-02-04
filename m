Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab0BDU4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:56:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab0BDU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:56:29 -0500
Date: Thu, 4 Feb 2010 15:56:16 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jdike@addtoit.com, heiko.carstens@de.ibm.com, davem@davemloft.net,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 5/6] improve sys_newuname for compat architectures
Message-ID: <20100204205616.GD21957@bombadil.infradead.org>
References: <20100201185624.GE11045@lst.de> <20100204204733.GA16150@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204204733.GA16150@lst.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 09:47:33PM +0100, Christoph Hellwig wrote:
> Updated version to apply without the previous sys_personality patch.
> The last patch still applies fine after this one.
> 

Looks good to me.

Acked-by: Kyle McMartin <kyle@mcmartin.ca>

> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: improve sys_newuname for compat architectures
> 
> On an architecture that supports 32-bit compat we need to override
> the reported machine in uname with the 32-bit value.  Instead of
> doing this separately in every architecture introduce a COMPAT_UTS_MACHINE
> define in <asm/compat.h> and apply it directly in sys_newuname.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> 
> Index: linux-2.6/arch/ia64/ia32/ia32_entry.S
> ===================================================================
> --- linux-2.6.orig/arch/ia64/ia32/ia32_entry.S	2010-02-04 21:04:47.515006002 +0100
> +++ linux-2.6/arch/ia64/ia32/ia32_entry.S	2010-02-04 21:04:59.370004548 +0100
> @@ -300,7 +300,7 @@ ia32_syscall_table:
>  	data8 sys32_sigreturn
>  	data8 ia32_clone	  /* 120 */
>  	data8 sys_setdomainname
> -	data8 sys32_newuname
> +	data8 sys_newuname
>  	data8 sys32_modify_ldt
>  	data8 compat_sys_adjtimex
>  	data8 sys32_mprotect	  /* 125 */
> Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
> ===================================================================
> --- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2010-02-04 21:04:56.089006537 +0100
> +++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2010-02-04 21:04:59.371005234 +0100
> @@ -1613,17 +1613,6 @@ sys32_msync (unsigned int start, unsigne
>  }
>  
>  asmlinkage long
> -sys32_newuname (struct new_utsname __user *name)
> -{
> -	int ret = sys_newuname(name);
> -
> -	if (!ret)
> -		if (copy_to_user(name->machine, "i686\0\0\0", 8))
> -			ret = -EFAULT;
> -	return ret;
> -}
> -
> -asmlinkage long
>  sys32_getresuid16 (u16 __user *ruid, u16 __user *euid, u16 __user *suid)
>  {
>  	uid_t a, b, c;
> Index: linux-2.6/arch/ia64/include/asm/compat.h
> ===================================================================
> --- linux-2.6.orig/arch/ia64/include/asm/compat.h	2010-02-04 21:04:16.423254134 +0100
> +++ linux-2.6/arch/ia64/include/asm/compat.h	2010-02-04 21:04:59.376003844 +0100
> @@ -5,7 +5,8 @@
>   */
>  #include <linux/types.h>
>  
> -#define COMPAT_USER_HZ	100
> +#define COMPAT_USER_HZ		100
> +#define COMPAT_UTS_MACHINE	"i686\0\0\0"
>  
>  typedef u32		compat_size_t;
>  typedef s32		compat_ssize_t;
> Index: linux-2.6/arch/mips/include/asm/compat.h
> ===================================================================
> --- linux-2.6.orig/arch/mips/include/asm/compat.h	2010-02-04 21:04:16.433255265 +0100
> +++ linux-2.6/arch/mips/include/asm/compat.h	2010-02-04 21:04:59.378004517 +0100
> @@ -8,7 +8,8 @@
>  #include <asm/page.h>
>  #include <asm/ptrace.h>
>  
> -#define COMPAT_USER_HZ	100
> +#define COMPAT_USER_HZ		100
> +#define COMPAT_UTS_MACHINE	"mips\0\0\0"
>  
>  typedef u32		compat_size_t;
>  typedef s32		compat_ssize_t;
> Index: linux-2.6/arch/mips/kernel/scall64-n32.S
> ===================================================================
> --- linux-2.6.orig/arch/mips/kernel/scall64-n32.S	2010-02-04 21:04:16.444004048 +0100
> +++ linux-2.6/arch/mips/kernel/scall64-n32.S	2010-02-04 21:04:59.379004505 +0100
> @@ -181,7 +181,7 @@ EXPORT(sysn32_call_table)
>  	PTR	sys_exit
>  	PTR	compat_sys_wait4
>  	PTR	sys_kill			/* 6060 */
> -	PTR	sys_32_newuname
> +	PTR	sys_newuname
>  	PTR	sys_semget
>  	PTR	sys_semop
>  	PTR	sys_n32_semctl
> Index: linux-2.6/arch/mips/kernel/scall64-o32.S
> ===================================================================
> --- linux-2.6.orig/arch/mips/kernel/scall64-o32.S	2010-02-04 21:04:16.461004603 +0100
> +++ linux-2.6/arch/mips/kernel/scall64-o32.S	2010-02-04 21:04:59.382004187 +0100
> @@ -325,7 +325,7 @@ sys_call_table:
>  	PTR	sys32_sigreturn
>  	PTR	sys32_clone			/* 4120 */
>  	PTR	sys_setdomainname
> -	PTR	sys_32_newuname
> +	PTR	sys_newuname
>  	PTR	sys_ni_syscall			/* sys_modify_ldt */
>  	PTR	compat_sys_adjtimex
>  	PTR	sys_mprotect			/* 4125 */
> Index: linux-2.6/arch/powerpc/include/asm/syscalls.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/include/asm/syscalls.h	2010-02-04 21:04:58.164033881 +0100
> +++ linux-2.6/arch/powerpc/include/asm/syscalls.h	2010-02-04 21:04:59.389273337 +0100
> @@ -7,7 +7,6 @@
>  #include <linux/types.h>
>  #include <asm/signal.h>
>  
> -struct new_utsname;
>  struct pt_regs;
>  struct rtas_args;
>  struct sigaction;
> @@ -38,7 +37,6 @@ asmlinkage long sys_rt_sigaction(int sig
>  asmlinkage long ppc64_personality(unsigned long personality);
>  asmlinkage int ppc_rtas(struct rtas_args __user *uargs);
>  asmlinkage time_t sys64_time(time_t __user * tloc);
> -asmlinkage long ppc_newuname(struct new_utsname __user * name);
>  
>  asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset,
>  		size_t sigsetsize);
> Index: linux-2.6/arch/powerpc/include/asm/systbl.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/include/asm/systbl.h	2010-02-04 21:04:16.488004403 +0100
> +++ linux-2.6/arch/powerpc/include/asm/systbl.h	2010-02-04 21:04:59.392274487 +0100
> @@ -125,7 +125,7 @@ SYSCALL_SPU(fsync)
>  SYS32ONLY(sigreturn)
>  PPC_SYS(clone)
>  COMPAT_SYS_SPU(setdomainname)
> -PPC_SYS_SPU(newuname)
> +SYSCALL_SPU(newuname)
>  SYSCALL(ni_syscall)
>  COMPAT_SYS_SPU(adjtimex)
>  SYSCALL_SPU(mprotect)
> Index: linux-2.6/kernel/sys.c
> ===================================================================
> --- linux-2.6.orig/kernel/sys.c	2010-02-04 21:04:16.711004050 +0100
> +++ linux-2.6/kernel/sys.c	2010-02-04 21:38:18.120254277 +0100
> @@ -33,6 +33,7 @@
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/seccomp.h>
>  #include <linux/cpu.h>
> +#include <linux/personality.h>
>  #include <linux/ptrace.h>
>  #include <linux/fs_struct.h>
>  
> @@ -1118,6 +1119,15 @@ out:
>  
>  DECLARE_RWSEM(uts_sem);
>  
> +#ifdef COMPAT_UTS_MACHINE
> +#define override_architecture(name) \
> +	(current->personality == PER_LINUX32 && \
> +	 copy_to_user(name->machine, COMPAT_UTS_MACHINE, \
> +		      sizeof(COMPAT_UTS_MACHINE)))
> +#else
> +#define override_architecture(name)	0
> +#endif
> +
>  SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
>  {
>  	int errno = 0;
> @@ -1126,6 +1136,9 @@ SYSCALL_DEFINE1(newuname, struct new_uts
>  	if (copy_to_user(name, utsname(), sizeof *name))
>  		errno = -EFAULT;
>  	up_read(&uts_sem);
> +
> +	if (!errno && override_architecture(name))
> +		errno = -EFAULT;
>  	return errno;
>  }
>  
> Index: linux-2.6/arch/parisc/include/asm/compat.h
> ===================================================================
> --- linux-2.6.orig/arch/parisc/include/asm/compat.h	2010-02-04 21:04:16.533024372 +0100
> +++ linux-2.6/arch/parisc/include/asm/compat.h	2010-02-04 21:04:59.408253613 +0100
> @@ -7,7 +7,8 @@
>  #include <linux/sched.h>
>  #include <linux/thread_info.h>
>  
> -#define COMPAT_USER_HZ 100
> +#define COMPAT_USER_HZ 		100
> +#define COMPAT_UTS_MACHINE	"parisc\0\0"
>  
>  typedef u32	compat_size_t;
>  typedef s32	compat_ssize_t;
> Index: linux-2.6/arch/parisc/kernel/sys_parisc.c
> ===================================================================
> --- linux-2.6.orig/arch/parisc/kernel/sys_parisc.c	2010-02-04 21:04:16.548004349 +0100
> +++ linux-2.6/arch/parisc/kernel/sys_parisc.c	2010-02-04 21:04:59.413274852 +0100
> @@ -234,18 +234,3 @@ long parisc_personality(unsigned long pe
>  
>  	return err;
>  }
> -
> -long parisc_newuname(struct new_utsname __user *name)
> -{
> -	int err = sys_newuname(name);
> -
> -#ifdef CONFIG_COMPAT
> -	if (!err && personality(current->personality) == PER_LINUX32) {
> -		if (__put_user(0, name->machine + 6) ||
> -		    __put_user(0, name->machine + 7))
> -			err = -EFAULT;
> -	}
> -#endif
> -
> -	return err;
> -}
> Index: linux-2.6/arch/parisc/kernel/syscall_table.S
> ===================================================================
> --- linux-2.6.orig/arch/parisc/kernel/syscall_table.S	2010-02-04 21:04:16.559004630 +0100
> +++ linux-2.6/arch/parisc/kernel/syscall_table.S	2010-02-04 21:04:59.416005436 +0100
> @@ -127,7 +127,7 @@
>  	ENTRY_SAME(socketpair)
>  	ENTRY_SAME(setpgid)
>  	ENTRY_SAME(send)
> -	ENTRY_OURS(newuname)
> +	ENTRY_SAME(newuname)
>  	ENTRY_SAME(umask)		/* 60 */
>  	ENTRY_SAME(chroot)
>  	ENTRY_COMP(ustat)
> Index: linux-2.6/arch/powerpc/include/asm/compat.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/include/asm/compat.h	2010-02-04 21:04:16.501004310 +0100
> +++ linux-2.6/arch/powerpc/include/asm/compat.h	2010-02-04 21:04:59.420261913 +0100
> @@ -7,7 +7,8 @@
>  #include <linux/types.h>
>  #include <linux/sched.h>
>  
> -#define COMPAT_USER_HZ	100
> +#define COMPAT_USER_HZ		100
> +#define COMPAT_UTS_MACHINE	"ppc\0\0"
>  
>  typedef u32		compat_size_t;
>  typedef s32		compat_ssize_t;
> Index: linux-2.6/arch/powerpc/kernel/syscalls.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/syscalls.c	2010-02-04 21:04:58.166021355 +0100
> +++ linux-2.6/arch/powerpc/kernel/syscalls.c	2010-02-04 21:38:17.842254529 +0100
> @@ -132,19 +132,6 @@ static inline int override_machine(char 
>  	return 0;
>  }
>  
> -long ppc_newuname(struct new_utsname __user * name)
> -{
> -	int err = 0;
> -
> -	down_read(&uts_sem);
> -	if (copy_to_user(name, utsname(), sizeof(*name)))
> -		err = -EFAULT;
> -	up_read(&uts_sem);
> -	if (!err)
> -		err = override_machine(name->machine);
> -	return err;
> -}
> -
>  int sys_uname(struct old_utsname __user *name)
>  {
>  	int err = 0;
> Index: linux-2.6/arch/s390/include/asm/compat.h
> ===================================================================
> --- linux-2.6.orig/arch/s390/include/asm/compat.h	2010-02-04 21:04:16.572004467 +0100
> +++ linux-2.6/arch/s390/include/asm/compat.h	2010-02-04 21:04:59.428253990 +0100
> @@ -35,7 +35,8 @@
>  
>  extern long psw32_user_bits;
>  
> -#define COMPAT_USER_HZ	100
> +#define COMPAT_USER_HZ		100
> +#define COMPAT_UTS_MACHINE	"s390\0\0\0\0"
>  
>  typedef u32		compat_size_t;
>  typedef s32		compat_ssize_t;
> Index: linux-2.6/arch/s390/kernel/compat_wrapper.S
> ===================================================================
> --- linux-2.6.orig/arch/s390/kernel/compat_wrapper.S	2010-02-04 21:04:16.579004379 +0100
> +++ linux-2.6/arch/s390/kernel/compat_wrapper.S	2010-02-04 21:04:59.431280911 +0100
> @@ -547,7 +547,7 @@ sys32_setdomainname_wrapper:
>  	.globl	sys32_newuname_wrapper
>  sys32_newuname_wrapper:
>  	llgtr	%r2,%r2			# struct new_utsname *
> -	jg	sys_s390_newuname	# branch to system call
> +	jg	sys_newuname		# branch to system call
>  
>  	.globl	compat_sys_adjtimex_wrapper
>  compat_sys_adjtimex_wrapper:
> Index: linux-2.6/arch/s390/kernel/entry.h
> ===================================================================
> --- linux-2.6.orig/arch/s390/kernel/entry.h	2010-02-04 21:04:58.169004346 +0100
> +++ linux-2.6/arch/s390/kernel/entry.h	2010-02-04 21:05:25.732256977 +0100
> @@ -24,7 +24,6 @@ int __cpuinit start_secondary(void *cpuv
>  void __init startup_init(void);
>  void die(const char * str, struct pt_regs * regs, long err);
>  
> -struct new_utsname;
>  struct s390_mmap_arg_struct;
>  struct fadvise64_64_args;
>  struct old_sigaction;
> @@ -32,7 +31,6 @@ struct old_sigaction;
>  long sys_mmap2(struct s390_mmap_arg_struct __user  *arg);
>  long sys_s390_ipc(uint call, int first, unsigned long second,
>  	     unsigned long third, void __user *ptr);
> -long sys_s390_newuname(struct new_utsname __user *name);
>  long sys_s390_personality(unsigned long personality);
>  long sys_s390_fadvise64(int fd, u32 offset_high, u32 offset_low,
>  		    size_t len, int advice);
> Index: linux-2.6/arch/s390/kernel/syscalls.S
> ===================================================================
> --- linux-2.6.orig/arch/s390/kernel/syscalls.S	2010-02-04 21:04:58.176004467 +0100
> +++ linux-2.6/arch/s390/kernel/syscalls.S	2010-02-04 21:04:59.444255674 +0100
> @@ -130,7 +130,7 @@ SYSCALL(sys_fsync,sys_fsync,sys32_fsync_
>  SYSCALL(sys_sigreturn,sys_sigreturn,sys32_sigreturn)
>  SYSCALL(sys_clone,sys_clone,sys_clone_wrapper)			/* 120 */
>  SYSCALL(sys_setdomainname,sys_setdomainname,sys32_setdomainname_wrapper)
> -SYSCALL(sys_newuname,sys_s390_newuname,sys32_newuname_wrapper)
> +SYSCALL(sys_newuname,sys_newuname,sys32_newuname_wrapper)
>  NI_SYSCALL							/* modify_ldt for i386 */
>  SYSCALL(sys_adjtimex,sys_adjtimex,compat_sys_adjtimex_wrapper)
>  SYSCALL(sys_mprotect,sys_mprotect,sys32_mprotect_wrapper)	/* 125 */
> Index: linux-2.6/arch/sparc/include/asm/compat.h
> ===================================================================
> --- linux-2.6.orig/arch/sparc/include/asm/compat.h	2010-02-04 21:04:16.619005623 +0100
> +++ linux-2.6/arch/sparc/include/asm/compat.h	2010-02-04 21:04:59.448255624 +0100
> @@ -5,7 +5,8 @@
>   */
>  #include <linux/types.h>
>  
> -#define COMPAT_USER_HZ	100
> +#define COMPAT_USER_HZ		100
> +#define COMPAT_UTS_MACHINE	"sparc\0\0"
>  
>  typedef u32		compat_size_t;
>  typedef s32		compat_ssize_t;
> Index: linux-2.6/arch/x86/include/asm/compat.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/compat.h	2010-02-04 21:04:16.650004536 +0100
> +++ linux-2.6/arch/x86/include/asm/compat.h	2010-02-04 21:04:59.450256088 +0100
> @@ -8,7 +8,8 @@
>  #include <linux/sched.h>
>  #include <asm/user32.h>
>  
> -#define COMPAT_USER_HZ	100
> +#define COMPAT_USER_HZ		100
> +#define COMPAT_UTS_MACHINE	"i686\0\0"
>  
>  typedef u32		compat_size_t;
>  typedef s32		compat_ssize_t;
> Index: linux-2.6/arch/x86/include/asm/syscalls.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/syscalls.h	2010-02-04 21:04:58.213255780 +0100
> +++ linux-2.6/arch/x86/include/asm/syscalls.h	2010-02-04 21:38:17.929254492 +0100
> @@ -68,11 +68,8 @@ int sys_vm86(unsigned long, unsigned lon
>  long sys_arch_prctl(int, unsigned long);
>  
>  /* kernel/sys_x86_64.c */
> -struct new_utsname;
> -
>  asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
>  			 unsigned long, unsigned long, unsigned long);
> -asmlinkage long sys_uname(struct new_utsname __user *);
>  
>  #endif /* CONFIG_X86_32 */
>  #endif /* _ASM_X86_SYSCALLS_H */
> Index: linux-2.6/arch/x86/include/asm/unistd_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/unistd_64.h	2010-02-04 21:04:16.670004354 +0100
> +++ linux-2.6/arch/x86/include/asm/unistd_64.h	2010-02-04 21:38:17.955255146 +0100
> @@ -146,7 +146,7 @@ __SYSCALL(__NR_wait4, sys_wait4)
>  #define __NR_kill				62
>  __SYSCALL(__NR_kill, sys_kill)
>  #define __NR_uname				63
> -__SYSCALL(__NR_uname, sys_uname)
> +__SYSCALL(__NR_uname, sys_newuname)
>  
>  #define __NR_semget				64
>  __SYSCALL(__NR_semget, sys_semget)
> Index: linux-2.6/arch/x86/kernel/sys_x86_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/sys_x86_64.c	2010-02-04 21:04:16.679004381 +0100
> +++ linux-2.6/arch/x86/kernel/sys_x86_64.c	2010-02-04 21:04:59.457258794 +0100
> @@ -209,15 +209,3 @@ bottomup:
>  
>  	return addr;
>  }
> -
> -
> -SYSCALL_DEFINE1(uname, struct new_utsname __user *, name)
> -{
> -	int err;
> -	down_read(&uts_sem);
> -	err = copy_to_user(name, utsname(), sizeof(*name));
> -	up_read(&uts_sem);
> -	if (personality(current->personality) == PER_LINUX32)
> -		err |= copy_to_user(&name->machine, "i686", 5);
> -	return err ? -EFAULT : 0;
> -}
> Index: linux-2.6/arch/um/sys-x86_64/syscall_table.c
> ===================================================================
> --- linux-2.6.orig/arch/um/sys-x86_64/syscall_table.c	2010-02-04 21:04:16.686004503 +0100
> +++ linux-2.6/arch/um/sys-x86_64/syscall_table.c	2010-02-04 21:04:59.461254902 +0100
> @@ -26,11 +26,6 @@
>  
>  /* On UML we call it this way ("old" means it's not mmap2) */
>  #define sys_mmap old_mmap
> -/*
> - * On x86-64 sys_uname is actually sys_newuname plus a compatibility trick.
> - * See arch/x86_64/kernel/sys_x86_64.c
> - */
> -#define sys_uname sys_uname64
>  
>  #define stub_clone sys_clone
>  #define stub_fork sys_fork
> Index: linux-2.6/arch/um/sys-x86_64/syscalls.c
> ===================================================================
> --- linux-2.6.orig/arch/um/sys-x86_64/syscalls.c	2010-02-04 21:04:16.698004422 +0100
> +++ linux-2.6/arch/um/sys-x86_64/syscalls.c	2010-02-04 21:04:59.461254902 +0100
> @@ -12,20 +12,6 @@
>  #include "asm/uaccess.h"
>  #include "os.h"
>  
> -asmlinkage long sys_uname64(struct new_utsname __user * name)
> -{
> -	int err;
> -
> -	down_read(&uts_sem);
> -	err = copy_to_user(name, utsname(), sizeof (*name));
> -	up_read(&uts_sem);
> -
> -	if (personality(current->personality) == PER_LINUX32)
> -		err |= copy_to_user(&name->machine, "i686", 5);
> -
> -	return err ? -EFAULT : 0;
> -}
> -
>  long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
>  {
>  	unsigned long *ptr = addr, tmp;
> Index: linux-2.6/arch/mips/kernel/linux32.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/kernel/linux32.c	2010-02-04 21:04:39.686255300 +0100
> +++ linux-2.6/arch/mips/kernel/linux32.c	2010-02-04 21:05:03.925004298 +0100
> @@ -250,22 +250,6 @@ SYSCALL_DEFINE5(n32_msgrcv, int, msqid, 
>  }
>  #endif
>  
> -SYSCALL_DEFINE1(32_newuname, struct new_utsname __user *, name)
> -{
> -	int ret = 0;
> -
> -	down_read(&uts_sem);
> -	if (copy_to_user(name, utsname(), sizeof *name))
> -		ret = -EFAULT;
> -	up_read(&uts_sem);
> -
> -	if (current->personality == PER_LINUX32 && !ret)
> -		if (copy_to_user(name->machine, "mips\0\0\0", 8))
> -			ret = -EFAULT;
> -
> -	return ret;
> -}
> -
>  SYSCALL_DEFINE1(32_personality, unsigned long, personality)
>  {
>  	int ret;
> Index: linux-2.6/arch/s390/kernel/sys_s390.c
> ===================================================================
> --- linux-2.6.orig/arch/s390/kernel/sys_s390.c	2010-02-04 21:05:58.941255359 +0100
> +++ linux-2.6/arch/s390/kernel/sys_s390.c	2010-02-04 21:06:10.576254718 +0100
> @@ -131,17 +131,6 @@ SYSCALL_DEFINE5(s390_ipc, uint, call, in
>  }
>  
>  #ifdef CONFIG_64BIT
> -SYSCALL_DEFINE1(s390_newuname, struct new_utsname __user *, name)
> -{
> -	int ret = sys_newuname(name);
> -
> -	if (personality(current->personality) == PER_LINUX32 && !ret) {
> -		ret = copy_to_user(name->machine, "s390\0\0\0\0", 8);
> -		if (ret) ret = -EFAULT;
> -	}
> -	return ret;
> -}
> -
>  SYSCALL_DEFINE1(s390_personality, unsigned long, personality)
>  {
>  	int ret;
> Index: linux-2.6/arch/sparc/kernel/sys_sparc_64.c
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/sys_sparc_64.c	2010-02-04 21:06:31.211005185 +0100
> +++ linux-2.6/arch/sparc/kernel/sys_sparc_64.c	2010-02-04 21:06:39.533004293 +0100
> @@ -511,17 +511,6 @@ out:
>  	return err;
>  }
>  
> -SYSCALL_DEFINE1(sparc64_newuname, struct new_utsname __user *, name)
> -{
> -	int ret = sys_newuname(name);
> -	
> -	if (current->personality == PER_LINUX32 && !ret) {
> -		ret = (copy_to_user(name->machine, "sparc\0\0", 8)
> -		       ? -EFAULT : 0);
> -	}
> -	return ret;
> -}
> -
>  SYSCALL_DEFINE1(sparc64_personality, unsigned long, personality)
>  {
>  	int ret;
> Index: linux-2.6/arch/sparc/kernel/systbls.h
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/systbls.h	2010-02-04 21:06:50.988254973 +0100
> +++ linux-2.6/arch/sparc/kernel/systbls.h	2010-02-04 21:07:03.292254939 +0100
> @@ -6,15 +6,12 @@
>  #include <asm/utrap.h>
>  #include <asm/signal.h>
>  
> -struct new_utsname;
> -
>  extern asmlinkage unsigned long sys_getpagesize(void);
>  extern asmlinkage long sparc_pipe(struct pt_regs *regs);
>  extern asmlinkage long sys_sparc_ipc(unsigned int call, int first,
>  			       unsigned long second,
>  			       unsigned long third,
>  			       void __user *ptr, long fifth);
> -extern asmlinkage long sparc64_newuname(struct new_utsname __user *name);
>  extern asmlinkage long sparc64_personality(unsigned long personality);
>  extern asmlinkage long sys64_munmap(unsigned long addr, size_t len);
>  extern asmlinkage unsigned long sys64_mremap(unsigned long addr,
> Index: linux-2.6/arch/sparc/kernel/systbls.h.rej
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/systbls.h.rej	2010-02-04 21:06:51.001255089 +0100
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,18 +0,0 @@
> ---- arch/sparc/kernel/systbls.h	2010-01-30 22:45:23.821271031 +0100
> -+++ arch/sparc/kernel/systbls.h	2010-01-30 22:45:24.324006540 +0100
> -@@ -6,15 +6,12 @@
> - #include <asm/utrap.h>
> - #include <asm/signal.h>
> - 
> --struct new_utsname;
> --
> - extern asmlinkage unsigned long sys_getpagesize(void);
> - extern asmlinkage long sparc_pipe(struct pt_regs *regs);
> - extern asmlinkage long sys_sparc_ipc(unsigned int call, int first,
> - 			       unsigned long second,
> - 			       unsigned long third,
> - 			       void __user *ptr, long fifth);
> --extern asmlinkage long sparc64_newuname(struct new_utsname __user *name);
> - extern asmlinkage long sys64_munmap(unsigned long addr, size_t len);
> - extern asmlinkage unsigned long sys64_mremap(unsigned long addr,
> - 					     unsigned long old_len,
> Index: linux-2.6/arch/sparc/kernel/systbls_64.S
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/systbls_64.S	2010-02-04 21:07:26.630004919 +0100
> +++ linux-2.6/arch/sparc/kernel/systbls_64.S	2010-02-04 21:07:52.078255284 +0100
> @@ -55,7 +55,7 @@ sys_call_table32:
>  /*170*/	.word sys32_lsetxattr, sys32_fsetxattr, sys_getxattr, sys_lgetxattr, compat_sys_getdents
>  	.word sys_setsid, sys_fchdir, sys32_fgetxattr, sys_listxattr, sys_llistxattr
>  /*180*/	.word sys32_flistxattr, sys_removexattr, sys_lremovexattr, compat_sys_sigpending, sys_ni_syscall
> -	.word sys32_setpgid, sys32_fremovexattr, sys32_tkill, sys32_exit_group, sys_sparc64_newuname
> +	.word sys32_setpgid, sys32_fremovexattr, sys32_tkill, sys32_exit_group, sys_newuname
>  /*190*/	.word sys32_init_module, sys_sparc64_personality, sys_remap_file_pages, sys32_epoll_create, sys32_epoll_ctl
>  	.word sys32_epoll_wait, sys32_ioprio_set, sys_getppid, sys32_sigaction, sys_sgetmask
>  /*200*/	.word sys32_ssetmask, sys_sigsuspend, compat_sys_newlstat, sys_uselib, compat_sys_old_readdir
> @@ -130,7 +130,7 @@ sys_call_table:
>  /*170*/	.word sys_lsetxattr, sys_fsetxattr, sys_getxattr, sys_lgetxattr, sys_getdents
>  	.word sys_setsid, sys_fchdir, sys_fgetxattr, sys_listxattr, sys_llistxattr
>  /*180*/	.word sys_flistxattr, sys_removexattr, sys_lremovexattr, sys_nis_syscall, sys_ni_syscall
> -	.word sys_setpgid, sys_fremovexattr, sys_tkill, sys_exit_group, sys_sparc64_newuname
> +	.word sys_setpgid, sys_fremovexattr, sys_tkill, sys_exit_group, sys_newuname
>  /*190*/	.word sys_init_module, sys_sparc64_personality, sys_remap_file_pages, sys_epoll_create, sys_epoll_ctl
>  	.word sys_epoll_wait, sys_ioprio_set, sys_getppid, sys_nis_syscall, sys_sgetmask
>  /*200*/	.word sys_ssetmask, sys_nis_syscall, sys_newlstat, sys_uselib, sys_nis_syscall
> 
