Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbYD0Pvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbYD0Pvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 11:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYD0Pvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 11:51:36 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:60223 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbYD0Pvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 11:51:33 -0400
Message-ID: <4814A153.3040600@seznam.cz>
Date: Sun, 27 Apr 2008 17:52:51 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
Cc: Matthew Wilcox <matthew@wil.cx>, Arnd Bergmann <arnd@arndb.de>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200804221515.28075.arnd@arndb.de> <480FA729.3000406@seznam.cz> <200804241311.09881.arnd@arndb.de> <4810D4A4.7050900@seznam.cz> <4811A623.80104@itee.uq.edu.au> <20080425100614.GB14990@parisc-linux.org> <4813DF3E.6080800@itee.uq.edu.au>
In-Reply-To: <4813DF3E.6080800@itee.uq.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi John, Arnd, Metthew and others,

>>> Please remember that MicroBlaze has been around as an arch for > 4
>>> years, just not in the kernel.org tree.  These older style syscall
>>> interfaces are all part of the uClibc and glibc ports for MicroBlaze.
>>
>> So is it fair to say that you now understand this was the Wrong Way To
>> Do Things, and if anyone asks, you'd recommend getting an arch merged
>> into kernel.org sooner rather than later?
>>
> 
> Without question!  If some abject humility will smooth the path for
> MicroBlaze, I'm happy to show it.
> 
> By way of history, as a no-MMU arch starting on the 2.4 kernel series,
> there was no home for us in kernel.org originally, however we were
> always in the uClinux "mainline" at uclinux.org from the first release I
> did back in 2002.
> 
> We jumped in at 2.6.20 basing from some vendor patches that were never
> going to fly in kernel.org.  Since then we have been improving and
> cleaning them up to where they might actually stand a chance.
> 
> I am lobbying Xilinx (the effective "silicon vendor") as hard as I can
> to support both the push to and maintenance within kernel.org.  They had
> someone at ELC in Mountain View week before last, which is a good sign I
> think.

I see that current situation needs some comments from my site.

What are facts?
* We have old GCC, old syscall table and all programs use old syscalls.
* I looked at all cpu and their syscalls. There is really big mess in every
architecture. They use almost the same syscalls as is in syscall table for
Microblaze.

Arnd commented current syscall table and send me long email about(Thanks again).
On the base on this email I did converted table for future use - for porting old
application to new version. Below is my table with syscalls and there is a short
description. (or http://www.monstr.eu/wiki/doku.php?id=kernel:syscall)

I counted how big impact will be syscall change to programs which are in John W
distribution
all programs
mknod - 174
rmdir - 488
mkdir - 1128
symlink - 404
rename - 1536
access - 1664
chmod -  1122
open - 22583 (crazy)
ipc - 26

Only busybox
open - 667
chmod 44
access 52
rename 32
symlink 8
mkdir 19
rmdir 9
mknod 16

I thing you understand that we can't change all application per night. This is
not possible. But we have to start with change this.

There is two opinions:
* One is take syscall table with old syscalls for backward compatibility.
As John W wrote. Microblaze has history around 4 years and 2.6 kernel almost 2
years.
 * Second is change everything and start with new gcc and syscall.

I feel second version is better for future and the first is better for now.

We definitely need to start with change but this change must not break what is
done. For this purpose I would like to have a table which told me which syscall
is old or new. On the base on this table we can continuously rewrite all
applications.
I think that rewriting syscalls is not only problem for Microblaze cpu.

Can you look at my table and correct it if I am wrong with some syscalls?

I labeled syscalls like ok - this means ok for Microblaze without MMU. mmu is
marked for MMU port. I hope I covered most syscalls which are in current kernel.

Regards,
Michal Simek

ENTRY(sys_call_table)

/* Microblaze don't use any compat syscalls */

/* fs/aio.c */
ok	.long sys_io_setup
ok	.long sys_io_destroy
ok	.long sys_io_submit
ok	.long sys_io_cancel
ok	.long sys_io_getevents

/* fs/xattr.c */
ok	.long sys_setxattr
ok	.long sys_lsetxattr
ok	.long sys_fsetxattr
ok	.long sys_getxattr
ok	.long sys_lgetxattr
ok	.long sys_fgetxattr
ok	.long sys_listxattr
ok	.long sys_llistxattr
ok	.long sys_flistxattr
ok	.long sys_removexattrs
ok	.long sys_lremovexattr
ok	.long sys_fremovexattr

/* fs/buffer.c */
	.long sys_bdflush /* obsolete */

/* fs/compat.c */
	.long compat_sys_utime
	.long compat_sys_utimensat
	.long compat_sys_futimesat
	.long compat_sys_utimes
	.long compat_sys_newstat
	.long compat_sys_newlstat
	.long compat_sys_newfstatat
	.long compat_sys_newfstat
	.long compat_sys_statfs
	.long compat_sys_fstatfs
	.long compat_sys_statfs64
	.long compat_sys_fstatfs64
	.long compat_sys_fcntl64
	.long compat_sys_fcntl
	.long compat_sys_mount
	.long compat_sys_old_readdir
	.long compat_sys_getdents
	.long compat_sys_getdents64
	.long compat_sys_select
	.long compat_sys_pselect7
	.long compat_sys_pselect6
	.long compat_sys_ppoll
	.long compat_sys_nfsservctl
	.long compat_sys_nfsservctl
	.long compat_sys_epoll_pwait
	.long compat_sys_signalfd
	.long compat_sys_timerfd_settime
	.long compat_sys_timerfd_gettime

/* fs/compat_ioctl.c */
	.long compat_sys_ioctl

/* fs/dcache.c */
ok	.long sys_getcwd

/* fs/cookies.c */
ok	.long sys_lookup_dcookie

/* fs/eventfd.c */
ok	.long sys_eventfd

/* fs/eventpoll.c */
ok	.long sys_epoll_create
ok	.long sys_epoll_ctl
	.long sys_epoll_wait /* obsolete -> sys_epoll_pwait */
ok	.long sys_epoll_pwait

/* fs/exec.c */
ok	.long sys_uselib /* #ifdef __ARCH_WANT_SYS_USELIB */

/* fs/fcntl.c */
ok	.long sys_dup
ok	.long sys_dup2
	.long sys_fcntl /* obsolete -> fcntl64 */
ok	.long sys_fcntl64

/* fs/filesystems.c */
	.long sys_sysfs /* obsolete */


/* fs/inotify_user.c */
ok	.long sys_inotify_init
ok	.long sys_inotify_add_watch
ok	.long sys_inotify_rm_watch

/* fs/ioctl.c */
ok	.long sys_ioctl

/* fs/ioprio.c */
ok	.long sys_ioprio_set
ok	.long sys_ioprio_get

/* fs/locks.c */
ok	.long sys_flock

/* fs/namei.c */
ok	.long sys_mknodat
	.long sys_mknod /* obsolete -> mknodat */
ok	.long sys_mkdirat
	.long sys_mkdir /* obsolete -> mkdirat */
	.long sys_rmdir /* obsolete -> unlinkat */
ok	.long sys_unlinkat
ok	.long sys_unlink
ok	.long sys_symlinkat
	.long sys_symlink /* obsolete -> sys_symlinkat */
ok	.long sys_linkat
ok	.long sys_link
ok	.long sys_renameat
	.long sys_rename /* obsolete -> renameat */

/* fs/namespace.c */
ok	.long sys_umount
	.long sys_oldumount /*_ARCH_WANT_SYS_OLDUMOUNT obsolate -> sys_umount */
ok	.long sys_mount
ok	.long sys_pivot_root


/* fs/nfsctl.c */
ok	.long sys_nfsservctl

/* fs/open.c */
	.long sys_statfs /* obsolete -> statfs64 */
ok	.long sys_statfs64
	.long sys_fstatfs /* obsolete -> fstatfs64 */
ok	.long sys_fstatfs64
	.long sys_truncate /* obsolete -> truncate64 */
	.long sys_ftruncate /* obsolete -> ftruncate64 */
ok	.long sys_truncate64 /* __ARCH_WANT_SYS_TRUNCATE */
ok	.long sys_ftruncate64 /* __ARCH_WANT_SYS_TRUNCATE */
ok	.long sys_fallocate
ok	.long sys_faccessat
	.long sys_access /* obsolete -> faccessat */
ok	.long sys_chdir
ok	.long sys_fchdir
ok	.long sys_chroot
ok	.long sys_fchmod
ok	.long sys_fchmodat
	.long sys_chmod /* obsolete -> fchmodat */
ok	.long sys_chown
ok	.long sys_fchownat
ok	.long sys_lchown
ok	.long sys_fchown
	.long sys_open /* obsolete -> openat */
ok	.long sys_openat
ok	.long sys_creat
ok	.long sys_close
ok	.long sys_vhangup

/* fs/quota.c */
ok	.long sys_quotactl

/* fs/readdir.c */
	.long sys_getdents /* obsolete -> sys_getdents64 */
ok	.long sys_getdents64

/* fs/read_write.c */
	.long sys_lseek /* only lseek or llseek */
ok	.long sys_llseek /* _ARCH_WANT_SYS_LLSEEK */
ok	.long sys_read
ok	.long sys_readv
ok	.long sys_write
ok	.long sys_writev
ok	.long sys_pread64
ok	.long sys_pwrite64
	.long sys_sendfile /* obsolete -> sys_sendfile64 */
ok	.long sys_sendfile64


/* fs/select.c */
	.long sys_select /* obsolete -> sys_pselect6 */
ok	.long sys_pselect7
	.long sys_pselect6 /* obsolete -> sys_pselect7 */
	.long sys_poll /* obsolete -> sys_ppoll */
ok	.long sys_ppoll

/* fs/signalfd.c */
ok	.long sys_signalfd



/* fs/splice.c */
ok	.long sys_vmsplice
ok	.long sys_splice
ok	.long sys_tee

/* fs/stat.c */
	.long sys_stat /*_ARCH_WANT_OLD_STAT */
	.long sys_lstat /* _ARCH_WANT_OLD_STAT */
	.long sys_fstat /* _ARCH_WANT_OLD_STAT */
ok	.long sys_newstat
ok	.long sys_newlstat
	.long sys_newfstatat /* _ARCH_WANT_SYS_NEWFSTATAT */
ok	.long sys_newfstat
ok	.long sys_readlinkat
	.long sys_readlink /* obsolete -> sys_readlinkat */
ok	.long sys_stat64 /* _ARCH_WANT_STAT64 */
ok	.long sys_lstat64 /* _ARCH_WANT_STAT64 */
ok	.long sys_fstat64 /* _ARCH_WANT_STAT64 */
ok	.long sys_fstatat64 /* _ARCH_WANT_STAT64 */

/* fs/super.c */
	.long sys_ustat /* obsolete -> statfs64 */

/* fs/sync.c */
ok	.long sys_sync
ok	.long sys_fsync
ok	.long sys_fdatasync
ok	.long sys_sync_file_range
	/* .long sys_sync_file_range2 */


/* fs/timerfd.c */
ok	.long sys_timerfd_create
ok	.long sys_timerfd_settime
ok	.long sys_timerfd_gettime

/* fs/utimes.c */
ok	.long sys_utime	/* _ARCH_WANT_SYS_TIME */
ok	.long sys_utimensat
ok	.long sys_futimesat
	.long sys_utimes /* obsolete -> sys_futimesat */

/* kernel/acct.c */
opt	.long sys_acct

/* kernel/capability.c */
ok	.long sys_capget
ok	.long sys_capset

/* kernel/compat.c */
	.long compat_sys_nanosleep
	.long compat_sys_getitimer
	.long compat_sys_setitimer
	.long compat_sys_times
	.long compat_sys_sigpending
	.long compat_sys_sigprocmask
	.long compat_sys_setrlimit
	.long compat_sys_old_getrlimit
	.long compat_sys_getrlimit
	.long compat_sys_getrusage
	.long compat_sys_waitid
	.long compat_sys_sched_setaffinity
	.long compat_sys_sched_getaffinity
	.long compat_sys_time	/* _ARCH_WANT_COMPAT_SYS_TIME */
	.long compat_sys_stime	/* _ARCH_WANT_COMPAT_SYS_TIME */
ok	.long compat_sys_rt_sigsuspend /* _ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND */
	.long compat_sys_adjtimex
	.long compat_sys_move_pages
	.long compat_sys_migrate_pages

/* kernel/exec_domain.c */
ok	.long sys_personality

/* kernel/exit.c */
ok	.long sys_exit
ok	.long sys_exit_group
ok	.long sys_waitid
	.long sys_wait4	/* obsolete -> waitid */
	.long sys_waitpid /*_ARCH_WANT_SYS_WAITPID */ /* obsolete -> waitid */

/* kernel/fork.c */
ok	.long sys_set_tid_address
ok	.long sys_unshare

/* kernel/futex.c */
ok	.long sys_futex
ok	.long sys_set_robust_list
ok	.long sys_get_robust_list

/* kernel/futex_compat.c */
	.long compat_sys_futex
	.long compat_sys_set_robust_list
	.long compat_sys_get_robust_list

/* kernel/hrtimer.c */
ok	.long sys_nanosleep

/* kernel/itimer.c */
ok	.long sys_getitimer
ok	.long sys_setitimer


/* kernel/kexec.c */
ok	.long sys_kexec_load
	.long compat_sys_kexec_load

/* kernel/module.c */
ok	.long sys_init_module
ok	.long sys_delete_module


/* kernel/posix-timers.c */
ok	.long sys_timer_create
ok	.long sys_timer_gettime
ok	.long sys_timer_getoverrun
ok	.long sys_timer_settime
ok	.long sys_timer_delete
ok	.long sys_clock_settime
ok	.long sys_clock_gettime
ok	.long sys_clock_getres
ok	.long sys_clock_nanosleep

/* kernel/printk.c */
ok	.long sys_syslog

/* kernel/ptrace.c */
ok	.long sys_ptrace
	.long compat_sys_ptrace /* _ARCH_WANT_COMPAT_SYS_PTRACE */

/* kernel/sched.c */
ok	.long sys_nice /* __ARCH_WANT_SYS_NICE */
ok	.long sys_sched_setparam
ok	.long sys_sched_setscheduler
ok	.long sys_sched_getscheduler
ok	.long sys_sched_getparam
ok	.long sys_sched_setaffinity
ok	.long sys_sched_getaffinity
ok	.long sys_sched_yield
ok	.long sys_sched_get_priority_max
ok	.long sys_sched_get_priority_min
ok	.long sys_sched_rr_get_interval

/* kernel/signal.c */
ok	.long sys_restart_syscall
ok	.long sys_kill
ok	.long sys_tkill
ok	.long sys_tgkill
ok	.long sys_rt_sigsuspend /* _ARCH_WANT_SYS_RT_SIGSUSPEND */
ok	.long sys_rt_sigaction /* _ARCH_WANT_SYS_RT_SIGACTION */
ok	.long sys_rt_sigprocmask /* _ARCH_WANT_SYS_SIGPROCMASK */
ok	.long sys_rt_sigpending	/* _ARCH_WANT_SYS_SIGPENDING */
ok	.long sys_rt_sigtimedwait
ok	.long sys_rt_sigqueueinfo
	.long sys_sigprocmask /* obsolete -> sys_rt_sigprocmask */
	.long sys_sigpending /* obsolete -> sys_rt_sigpending */
ok	.long sys_signal	/* __ARCH_WANT_SYS_SIGNAL */
ok	.long sys_pause		/* __ARCH_WANT_SYS_PAUSE */
ok	.long sys_sgetmask /* __ARCH_WANT_SYS_SGETMASK */
ok	.long sys_ssetmask /* __ARCH_WANT_SYS_SGETMASK */


/* kernel/sys.c */
ok	.long sys_setpriority
ok	.long sys_getpriority
ok	.long sys_reboot
ok	.long sys_setregid
ok	.long sys_setgid
ok	.long sys_setreuid
ok	.long sys_setuid
ok	.long sys_setresuid
ok	.long sys_getresuid
ok	.long sys_setresgid
ok	.long sys_getresgid
ok	.long sys_setfsuid
ok	.long sys_setfsgid
ok	.long sys_times
ok	.long sys_setpgid
ok	.long sys_getpgid
ok	.long sys_getpgrp /* __ARCH_WANT_SYS_GETPGRP */
ok	.long sys_getsid
ok	.long sys_setsid
ok	.long sys_getgroups
ok	.long sys_setgroups
ok	.long sys_newuname
ok	.long sys_sethostname
	.long sys_gethostname /* _ARCH_WANT_SYS_GETHOSTNAME */
ok	.long sys_setdomainname
ok	.long sys_getrlimit
	.long sys_old_getrlimit /* _ARCH_WANT_SYS_OLD_GETRLIMIT */
ok	.long sys_setrlimit
ok	.long sys_getrusage
ok	.long sys_umask
ok	.long sys_prctl
ok	.long sys_getcpu



/* kernel/sysctl.c */
	.long sys_sysctl /* deprecated */

/* kernel/sys_ni.c */
	.long sys_ni_syscall /* :-) */


/* kernel/time.c */
ok	.long sys_time /* __ARCH_WANT_SYS_TIME */
ok	.long sys_stime /* __ARCH_WANT_SYS_TIME */
ok	.long sys_gettimeofday
ok	.long sys_settimeofday
ok	.long sys_adjtimex

	.
/* kernel/timer.c */
ok	.long sys_alarm /* __ARCH_WANT_SYS_ALARM */
ok	.long sys_getpid
ok	.long sys_getppid
ok	.long sys_getuid
ok	.long sys_geteuid
ok	.long sys_getgid
ok	.long sys_getegid
ok	.long sys_gettid
ok	.long sys_sysinfo


/* kernel/uid16.c */ /* all replace by full version CONFIG_UID16 */
	.long sys_chown16
	.long sys_lchown16
	.long sys_fchown16
	.long sys_setregid16
	.long sys_setgid16
	.long sys_setreuid16
	.long sys_setuid16
	.long sys_setresuid16
	.long sys_getresuid16
	.long sys_setresgid16
	.long sys_getresgid16
	.long sys_setfsuid16
	.long sys_setfsgid16
	.long sys_getgroups16
	.long sys_setgroups16
	.long sys_getuid16
	.long sys_geteuid16
	.long sys_getgid16
	.long sys_getegid16

/* ipc/compat_mq.c */
	.long compat_sys_mq_open
	.long compat_sys_mq_timedsend
	.long compat_sys_mq_timedreceive
	.long compat_sys_mq_notify
	.long compat_sys_mq_getsetattr

/* ipc/mqueue.c */
ok	.long sys_mq_open
ok	.long sys_mq_unlink
ok	.long sys_mq_timedsend
ok	.long sys_mq_timedreceive
ok	.long sys_mq_notify
ok	.long sys_mq_getsetattr

/* ipc/msg.c */
ok	.long sys_msgget
ok	.long sys_msgctl
ok	.long sys_msgrcv
ok	.long sys_msgsnd

/* ipc/sem.c */
ok	.long sys_semget
ok	.long sys_semctl
ok	.long sys_semtimedop
ok	.long sys_semop

/* ipc/shm.c */
ok	.long sys_shmget
ok	.long sys_shmctl
ok	.long sys_shmat
ok	.long sys_shmdt


/* net/compat.c */
	.long compat_sys_setsockopt
	.long compat_sys_getsockopt
	.long compat_sys_sendmsg
	.long compat_sys_recvmsg
	.long compat_sys_socketcall

/* net/socket.c */
	.long sys_socket
	.long sys_socketpair
	.long sys_bind
	.long sys_listen
	.long sys_accept
	.long sys_connect
	.long sys_getsockname
	.long sys_getpeername
	.long sys_sendto
	.long sys_send
	.long sys_recvfrom
	.long sys_recv
	.long sys_setsockopt
	.long sys_getsockopt
	.long sys_shutdown
	.long sys_sendmsg
	.long sys_recvmsg
	.long sys_socketcall /* _ARCH_WANT_SYS_SOCKETCALL - deprecated */

/* mm/fadvise.c */
ok	.long sys_fadvise64_64
	.long sys_fadvise64 /*_ARCH_WANT_SYS_FADVISE64 obsolete -> sys_fadvise64_64 */

/* mm/filemap.c */
ok	.long sys_readahead


/* mm/fremap.c */
	.long sys_remap_file_pages

/* mm/madvise.c */
	.long sys_madvise

/* mm/mempolicy.c */
mmu	.long sys_mbind
mmu	.long sys_set_mempolicy
mmu	.long sys_migrate_pages
mmu	.long sys_get_mempolicy
	.long compat_sys_get_mempolicy
	.long compat_sys_set_mempolicy
	.long compat_sys_mbind

/* mm/migrate.c */
mmu	.long sys_move_pages

/* mm/mincore.c */
	.long sys_mincore

/* mm/mlock.c */
mmu	.long sys_mlock
mmu	.long sys_munlock
mmu	.long sys_mlockall
mmu	.long sys_munlockall

/* mm/mmap.c */
mmu	.long sys_brk
mmu	.long sys_munmap

/* mm/mremap.c */
	.long sys_mremap

/* mm/msync.c */
	.long sys_msync

/* mm/nommu.c */
ok	.long sys_brk
ok	.long sys_munmap
	.long sys_mremap


/* mm/swapfile.c */
ok	.long sys_swapoff
ok	.long sys_swapon


/* security/keys/compat.c */
	.long compat_sys_keyctl

/* security/keys/keyctl.c */
ok	.long sys_add_key
ok	.long sys_request_key
ok	.long sys_keyctl

/* arch - microblaze specific */
/* arch/microblaze/kernel/signal.c */
	.long sys_sigreturn /* obsolete -> sys_rt_sigreturn */
ok	.long sys_rt_sigreturn_wrapper /*.long sys_rt_sigreturn*/
	.long sys_sigaction /* obsolete -> rt_sigaction */
	.long sys_sigsuspend /* obsolete -> rt_sigsuspend */

/*arch/microblaze/kernel/sys_microblaze.c*/
	.long sys_vfork		/* I don't need it if I have clone vfork_wrapper */
ok	.long sys_clone		/* .long sys_clone_wrapper */
ok	.long sys_execve	/* .long sys_execve_wrapper */
ok	.long sys_pipe
ok	.long sys_mmap2
	.long sys_mmap	/* obsolete -> sys_mmap2 */
	.long sys_ipc /* obsolete -> replace by subcall */



