Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYDXLLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYDXLLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYDXLL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:11:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYDXLLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:11:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: microblaze syscall list
Date: Thu, 24 Apr 2008 13:11:08 +0200
User-Agent: KMail/1.9.9
Cc: Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200804221515.28075.arnd@arndb.de> <480FA729.3000406@seznam.cz>
In-Reply-To: <480FA729.3000406@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241311.09881.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/1c4ga+4tGcNnLOtoXlgNEHv3j2QBdv614Xzd
 PYCblwXGHaoaXmLiZGFAcFtyoKTStewR4YB8FDiGfN/zKPOOUG
 +YZfVRSKJzYp2X/rTwpHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, Michal Simek wrote:

> I would like to fix syscalls in Microblaze repo. Can you give me a hint how to
> do it?

I think we need to do it on a case-by-case basis, best here on the
linux-arch mailing list. I'm sure there are some controversial ones,
but most should be pretty clear.
 
> I look at Blackfin arch and I compared files with microblaze. There are some
> differences but not so much.
> Can you tell me how to test it which syscall is necessary for platform.
> I have never found any documentation about.

Hopefully we can get to this kind of documentation by the end of this
discussion. scripts/checksyscalls.sh is some part of the documentation,
and we can refine that.

Maybe we can even have an asm-generic/unistd.h that defines all the
still relevant syscalls, plus a per-architecture range that you can
use for microblaze-specific calls in your own unistd.h.

> In my syscall_table.S (on some arch in entry.S) is one big jump table with
> reference to syscalls. In unistd.h is definition.
> 
> Is there any convention which syscalls are use for all archs and which are
> architecture specific?

Not really. There are very few syscalls that are needed only on certain
architectures. The more common case is that a syscall has been replaced
by a more complex interface, and a new architecture only needs one of the
two, while older architectures still need both.

Let me just comment on your syscall table as it is today:

> ENTRY(sys_call_table)
> 	.long sys_restart_syscall	/* 0 - old "setup()" system call,
> 					 * used for restarting */

The comment is irrelevant and misleading -- microblaze never had sys_setup.

> 	.long sys_exit
> 	.long sys_ni_syscall		/* was fork */

it might be useful to renumber your calls once all the irrelevant ones
have been removed, so you can get rid of all the sys_ni_syscalls here.

> 	.long sys_read
> 	.long sys_write
> 	.long sys_open			/* 5 */

Since we have all the new sys_*at calls like openat, we don't really
need the old versions any more. The kernel implementation of sys_open
basically calls openat. You could do the same in libc instead.
Don't know if that's worth it though, opinions?

> 	.long sys_close
> 	.long sys_waitpid

waitpid and wait4 can be replaced with waitid

> 	.long sys_creat
> 	.long sys_link
> 	.long sys_unlink		/* 10 */
> 	.long sys_execve_wrapper

having an execve_wrapper instead of execve looks like a strange convention,
though I guess you had a good reason for it, could you explain?

This one looks architecture specific, so you may want to rename it
microblaze_execve_wrapper instead of sys_execve_wrapper.

> 	.long sys_chdir
> 	.long sys_time

__ARCH_WANT_SYS_TIME

> 	.long sys_mknod
> 	.long sys_chmod			/* 15 */

the mknod and chmod calls fall in the same category as open, as
you can express them with fmknodat and fchmodat.

> 	.long sys_lchown16

Anything that uses 16 bit uids should really go away in new architectures.
We have a CONFIG_UID16 for that, which you should define to 'n'.


> 	.long sys_ni_syscall		/* old break syscall holder */
> 	.long sys_ni_syscall		/* stat */
> 	.long sys_lseek

You should not have both lseek and llseek. In general, I'd recommend
implementing only the large-file interfaces, so your lseek syscall
should probably point at sys_llseek.

> 	.long sys_getpid		/* 20 */
> 	.long sys_mount
> 	.long sys_oldumount

If a call has 'old' in its name, you don't need it in general. You certainly
shouldn't have oldumount.

> 	.long sys_setuid16
> 	.long sys_getuid16

uid16 --> kill these.

> 	.long sys_stime			/* 25 */

this should not be there, it depends on __ARCH_WANT_SYS_TIME, which you
should not set, and it has been replaced with sys_settimeofday ages ago.

> 	.long sys_ptrace
> 	.long sys_alarm

same for __ARCH_WANT_SYS_ALARM

> 	.long sys_ni_syscall		/* fstat */
> 	.long sys_pause

__ARCH_WANT_SYS_PAUSE

> 	.long sys_utime			/* 30 */

superceded by utimes, __ARCH_WANT_SYS_UTIME

> 	.long sys_ni_syscall		/* old stty syscall holder */
> 	.long sys_ni_syscall		/* old gtty syscall holder */
> 	.long sys_access

faccessat

> 	.long sys_nice

The sys_nice function has a __ARCH_WANT_SYS_NICE ifdef around it,
though I'm not sure what the replacement is. sys_setpriority?

> 	.long sys_ni_syscall		/* 35 - old ftime syscall holder */
> 	.long sys_sync
> 	.long sys_kill

We have sys_kill, sys_tkill and sys_tgkill, but afaics we need all three
of them. It would be nice to have them use consecutive numbers though.

> 	.long sys_rename
> 	.long sys_mkdir
> 	.long sys_rmdir			/* 40 */

renameat, mkdirat, unlinkat

> 	.long sys_dup
> 	.long sys_pipe
> 	.long sys_times
> 	.long sys_ni_syscall		/* old prof syscall holder */
> 	.long sys_brk			/* 45 */
> 	.long sys_setgid16
> 	.long sys_getgid16

uid16 again

> 	.long sys_signal

__ARCH_WANT_SYS_SIGNAL

> 	.long sys_geteuid16
> 	.long sys_getegid16		/* 50 */

uid16

> 	.long sys_acct

this one is an optional feature, but it should remain in the table.

> 	.long sys_umount		/* recycled never used phys() */
> 	.long sys_ni_syscall		/* old lock syscall holder */
> 	.long sys_ioctl
> 	.long sys_fcntl			/* 55 */

fcntl64

> 	.long sys_ni_syscall		/* old mpx syscall holder */
> 	.long sys_setpgid
> 	.long sys_ni_syscall		/* old ulimit syscall holder */
> 	.long sys_ni_syscall		/* olduname */
> 	.long sys_umask			/* 60 */
> 	.long sys_chroot
> 	.long sys_ustat

we have ustat, statfs, fstatfs, statfs64, fstatfs64. Maybe we
can reduce that to just statfs64 and fstatfs64 now?

> 	.long sys_dup2
> 	.long sys_getppid
> 	.long sys_getpgrp		/* 65 */

__ARCH_WANT_SYS_GETPGRP. what's the replacement?

> 	.long sys_setsid
> 	.long sys_sigaction

sigaction is one of the old signal-handling calls that have
been superceded by rt signals. This one should be rt_sigaction.

Interestingly, there is a __ARCH_WANT_SYS_SIGPROCMASK and
__ARCH_WANT_SYS_RT_SIGACTION, but they work the other way round
in that you actually should set them for a new architecture that
doesn't come with its own version.

Maybe we should invert the logic and define __ARCH_HAVE_SYS_RT_SIGACTION
on those architectures that don't use the generic code?

> 	.long sys_sgetmask
> 	.long sys_ssetmask

__ARCH_WANT_SYS_SGETMASK

> 	.long sys_setreuid16		/* 70 */
> 	.long sys_setregid16

uid16

> 	.long sys_sigsuspend_wrapper
> 	.long sys_sigpending

old signals

> 	.long sys_sethostname
> 	.long sys_setrlimit		/* 75 */
> 	.long sys_ni_syscall		/* old_getrlimit */
> 	.long sys_getrusage
> 	.long sys_gettimeofday
> 	.long sys_settimeofday
> 	.long sys_getgroups16		/* 80 */
> 	.long sys_setgroups16

uid16

> 	.long sys_ni_syscall		/* old_select */
> 	.long sys_symlink
> 	.long sys_ni_syscall		/* lstat */
> 	.long sys_readlink		/* 85 */

symlinkat, readlinkat

> 	.long sys_uselib

This should get hidden in __ARCH_WANT_SYS_USELIB, which we don't have
yet.

> 	.long sys_swapon
> 	.long sys_reboot
> 	.long sys_ni_syscall		/* old_readdir */
> 	.long sys_mmap			/* 90 */ /* old_mmap */

mmap2

> 	.long sys_munmap
> 	.long sys_truncate
> 	.long sys_ftruncate

these should be truncate64 and ftruncate64. They are also missing
an __ARCH_WANT_SYS_TRUNCATE.

Question: why is there no sys_truncateat?

> 	.long sys_fchmod
> 	.long sys_fchown16		/* 95 */

uid16

> 	.long sys_getpriority
> 	.long sys_setpriority
> 	.long sys_ni_syscall		/* old profil syscall holder */

> 	.long sys_statfs
> 	.long sys_fstatfs		/* 100 */

see comment about ustat

> 	.long sys_ni_syscall		/* ioperm */

> 	.long sys_socketcall

socketcall must die. please put the separate calls into you sys_call_table.

> 	.long sys_syslog

> 	.long sys_setitimer
> 	.long sys_getitimer		/* 105 */

do we still need these, or can we replace them with posix timers
for new architectures?

> 	.long sys_newstat
> 	.long sys_newlstat
> 	.long sys_newfstat

these are the right ones, but you should probably replace the
definition of struct stat with the definition of the struct
stat64 from glibc. your struct stat64 has issues with broken
padding and should just go away.

> 	.long sys_ni_syscall		/* uname */
> 	.long sys_ni_syscall		/* 110 */ /* iopl */
> 	.long sys_vhangup
> 	.long sys_ni_syscall		/* old "idle" system call */
> 	.long sys_ni_syscall		/* old sys_vm86old */
> 	.long sys_wait4

waitid

> 	.long sys_swapoff		/* 115 */
> 	.long sys_sysinfo

> 	.long sys_ipc

same as sys_socketcall, ipc should be replaced with separate
syscalls for its subfunctions.

> 	.long sys_fsync


> 	.long sys_sigreturn_wrapper

old signals

> 	.long sys_clone_wrapper		/* 120 */
> 	.long sys_setdomainname
> 	.long sys_newuname
> 	.long sys_ni_syscall		/* modify_ldt */
> 	.long sys_adjtimex
> 	.long sys_ni_syscall		/* 125:	sys_mprotect */

> 	.long sys_sigprocmask

old signals

> 	.long sys_ni_syscall		/* old "create_module" */
> 	.long sys_init_module
> 	.long sys_delete_module
> 	.long sys_ni_syscall		/* 130:	old "get_kernel_syms" */
> 	.long sys_quotactl
> 	.long sys_getpgid
> 	.long sys_fchdir

question: should there be an fchdirat?

> 	.long sys_bdflush

entirely obsolete

> 	.long sys_sysfs			/* 135 */

same here

> 	.long sys_personality
> 	.long sys_ni_syscall		/* reserved for afs_syscall */
> 	.long sys_setfsuid16
> 	.long sys_setfsgid16

uid16

> 	.long sys_llseek		/* 140 */

> 	.long sys_getdents

getdents64

> 	.long sys_select

pselect6 or pselect7

> 	.long sys_flock
> 	.long sys_ni_syscall		/* sys_msync */
> 	.long sys_readv			/* 145 */
> 	.long sys_writev
> 	.long sys_getsid
> 	.long sys_fdatasync

> 	.long sys_sysctl

sys_sysctl has been deprecated on other platforms for years,
don't introduce it here.

> 	.long sys_ni_syscall		/* 150:	sys_mlock */
> 	.long sys_ni_syscall		/* sys_munlock */
> 	.long sys_ni_syscall		/* sys_mlockall */
> 	.long sys_ni_syscall		/* sys_munlockall */

ok to have placeholders for these, but only if you can potentially
get an mmu version of the architecture.

Of course, you can always add them at the end of the list if
necessary.

> 	.long sys_sched_setparam
> 	.long sys_sched_getparam	/* 155 */
> 	.long sys_sched_setscheduler
> 	.long sys_sched_getscheduler
> 	.long sys_sched_yield
> 	.long sys_sched_get_priority_max
> 	.long sys_sched_get_priority_min	/* 160 */
> 	.long sys_sched_rr_get_interval
> 	.long sys_nanosleep
> 	.long sys_ni_syscall		/* sys_mremap */

> 	.long sys_setresuid16
> 	.long sys_getresuid16		/* 165 */

uid16

> 	.long sys_ni_syscall		/* sys_vm86 */
> 	.long sys_ni_syscall		/* Old sys_query_module */
> 	.long sys_poll

ppoll

> 	.long sys_nfsservctl

This used to be deprecated, but I think the replacement nfsctl file system
never got popular use from user space, so you may need to keep it.
Does anyone have more information on this?

> 	.long sys_setresgid16		/* 170 */
> 	.long sys_getresgid16

uid16

> 	.long sys_prctl
> 	.long sys_rt_sigreturn_wrapper
> 	.long sys_rt_sigaction
> 	.long sys_rt_sigprocmask	/* 175 */
> 	.long sys_rt_sigpending
> 	.long sys_rt_sigtimedwait
> 	.long sys_rt_sigqueueinfo
> 	.long sys_rt_sigsuspend_wrapper

fine, but please use the generic version of sys_rt_sigsuspend
rather than rolling your own.

I also wonder if there could be a more generalized version of
sys_rt_sigreturn, probably not.

> 	.long sys_pread64		/* 180 */
> 	.long sys_pwrite64

> 	.long sys_chown16

uid16

> 	.long sys_getcwd
> 	.long sys_capget
> 	.long sys_capset		/* 185 */
> 	.long sys_ni_syscall		/* sigaltstack */
> 	.long sys_sendfile

sys_sendfile64

> 	.long sys_ni_syscall		/* reserved for streams1 */
> 	.long sys_ni_syscall		/* reserved for streams2 */
> 	.long sys_vfork_wrapper		/* 190 */

you already have clone, so you don't need vfork

> 	.long sys_getrlimit
> 	.long sys_mmap2			/* mmap2 */

> 	.long sys_truncate64
> 	.long sys_ftruncate64
> 	.long sys_stat64		/* 195 */
> 	.long sys_lstat64
> 	.long sys_fstat64

these are the LFS versions of syscalls, so you want them
instead of the older ones, as mentioned there.

An interesting question for the mailing list: should a new architecture
'typedef unsigned long long off_t', or ignore all syscalls that deal with
off_t and use the loff_t versions instead?

> 	.long sys_lchown
> 	.long sys_getuid
> 	.long sys_getgid		/* 200 */
> 	.long sys_geteuid
> 	.long sys_getegid
> 	.long sys_setreuid
> 	.long sys_setregid
> 	.long sys_getgroups		/* 205 */
> 	.long sys_setgroups
> 	.long sys_fchown
> 	.long sys_setresuid
> 	.long sys_getresuid
> 	.long sys_setresgid		/* 210 */
> 	.long sys_getresgid
> 	.long sys_chown
> 	.long sys_setuid
> 	.long sys_setgid
> 	.long sys_setfsuid		/* 215 */
> 	.long sys_setfsgid

same for these, which replace the uid16 calls.

> 	.long sys_pivot_root
> 	.long sys_ni_syscall		/* sys_mincore */
> 	.long sys_ni_syscall		/* sys_madvise */
> 	.long sys_getdents64		/* 220 */
> 	.long sys_fcntl64
> 	.long sys_ni_syscall		/* reserved for TUX */
> 	.long sys_ni_syscall
> 	.long sys_gettid
> 	.long sys_readahead		/* 225 */
> 	.long sys_setxattr
> 	.long sys_lsetxattr
> 	.long sys_fsetxattr
> 	.long sys_getxattr
> 	.long sys_lgetxattr		/* 230 */
> 	.long sys_fgetxattr
> 	.long sys_listxattr
> 	.long sys_llistxattr
> 	.long sys_flistxattr
> 	.long sys_removexattr		/* 235 */
> 	.long sys_lremovexattr
> 	.long sys_fremovexattr
> 	.long sys_tkill
> 	.long sys_sendfile64
> 	.long sys_futex			/* 240 */
> 	.long sys_sched_setaffinity
> 	.long sys_sched_getaffinity
> 	.long sys_ni_syscall		/* set_thread_area */
> 	.long sys_ni_syscall		/* get_thread_area */
> 	.long sys_io_setup		/* 245 */
> 	.long sys_io_destroy
> 	.long sys_io_getevents
> 	.long sys_io_submit
> 	.long sys_io_cancel
> 	.long sys_fadvise64		/* 250 */

fadvise64_64

> 	.long sys_ni_syscall
> 	.long sys_exit_group
> 	.long sys_lookup_dcookie
> 	.long sys_epoll_create
> 	.long sys_epoll_ctl		/* 255 */
> 	.long sys_epoll_wait

epoll_pwait

> 	.long sys_ni_syscall		/* sys_remap_file_pages */
> 	.long sys_set_tid_address
> 	.long sys_timer_create
> 	.long sys_timer_settime		/* 260 */
> 	.long sys_timer_gettime
> 	.long sys_timer_getoverrun
> 	.long sys_timer_delete
> 	.long sys_clock_settime
> 	.long sys_clock_gettime		/* 265 */
> 	.long sys_clock_getres
> 	.long sys_clock_nanosleep
> 	.long sys_statfs64
> 	.long sys_fstatfs64
> 	.long sys_tgkill		/* 270 */

> 	.long sys_utimes

futimensat

> 	.long sys_fadvise64_64
> 	.long sys_ni_syscall		/* sys_vserver */

> 	.long sys_mbind
> 	.long sys_get_mempolicy
> 	.long sys_set_mempolicy

probably not very useful for nommu.

> 	.long sys_mq_open
> 	.long sys_mq_unlink
> 	.long sys_mq_timedsend
> 	.long sys_mq_timedreceive	/* 280 */
> 	.long sys_mq_notify
> 	.long sys_mq_getsetattr

> 	.long sys_kexec_load

you don't implement kexec, but I guess it doesn't hurt to define
it anyway.

> 	.long sys_waitid
> 	.long sys_ni_syscall		/* 285 */ /* available */
> 	.long sys_add_key
> 	.long sys_request_key
> 	.long sys_keyctl
> 	.long sys_ioprio_set
> 	.long sys_ioprio_get		/* 290 */
> 	.long sys_inotify_init
> 	.long sys_inotify_add_watch
> 	.long sys_inotify_rm_watch
> 	.long sys_ni_syscall		/* sys_migrate_pages */

> 	.long sys_ni_syscall		/* 295 */ /* sys_openat */
> 	.long sys_ni_syscall		/* sys_mkdirat */
> 	.long sys_ni_syscall		/* sys_mknodat */
> 	.long sys_ni_syscall		/* sys_fchownat */
> 	.long sys_ni_syscall		/* sys_futimesat */
> 	.long sys_ni_syscall		/* 300 */ /* sys_fstatat64 */
> 	.long sys_ni_syscall		/* sys_unlinkat */
> 	.long sys_ni_syscall		/* sys_renameat */
> 	.long sys_ni_syscall		/* sys_linkat */
> 	.long sys_ni_syscall		/* sys_symlinkat */
> 	.long sys_ni_syscall		/* 305 */ /* sys_readlinkat */
> 	.long sys_ni_syscall		/* sys_fchmodat */
> 	.long sys_ni_syscall		/* sys_faccessat */
> 	.long sys_ni_syscall		/* pselect6 */
> 	.long sys_ni_syscall		/* ppoll */
> 	.long sys_ni_syscall		/* 310 */ /* sys_unshare */
> 	.long sys_ni_syscall		/* sys_set_robust_list */
> 	.long sys_ni_syscall		/* sys_get_robust_list */
> 	.long sys_ni_syscall		/* sys_splice */
> 	.long sys_ni_syscall		/* sys_sync_file_range */
> 	.long sys_ni_syscall		/* 315 */ /* sys_tee */
> 	.long sys_ni_syscall		/* sys_vmsplice */

I think you should enable all of these, except sys_futimesat,
which has already been obsoleted again.

> 	.long sys_move_pages

but not this one, on nommu.
You can either define all the mmu syscalls and let them get
handled by cond_syscall, or not define them at all, but please
be consistent.

> 	.long sys_getcpu
> 	.long sys_epoll_pwait
> 	.long sys_utimensat		/* 320 */
> 	.long sys_signalfd
> 	.long sys_timerfd_create
> 	.long sys_eventfd
> 	.long sys_fallocate
> 	.long sys_semtimedop		/* 325 */

semtimedop is a bit lonely here, all the other sys_ipc 
functions belong here as well.

> 	.long sys_timerfd_settime
> 	.long sys_timerfd_gettime

	Arnd <><
