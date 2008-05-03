Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbYECJRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbYECJRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbYECJRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:17:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbYECJRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:17:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Williams <john.williams@petalogix.com>
Subject: Re: microblaze syscall list
Date: Sat, 3 May 2008 11:16:49 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, Matthew Wilcox <matthew@wil.cx>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>, Ulrich Drepper <drepper@redhat.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <481ACE51.80202@seznam.cz> <481BE0E4.7010904@petalogix.com>
In-Reply-To: <481BE0E4.7010904@petalogix.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805031116.50236.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/pvxSx4C10mpnKobrDM09m5GOpMNEq4a0uSpc
 8XarapMPHZB1l7YdaZIb7zF4oSPA7pkiFr8LnmOEtHLwdlddXu
 a+TA/f8FkVlnaHcG0qqhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008, John Williams wrote:

> As a first pass at assessing the C library impact on a completely 
> renovated syscall list, I took Michal's proposed new unistd.h and used 
> it to grep over both the uClibc implementation that (almost) every 
> existing microblaze user uses (!MMU), plus the glibc (cough cough) 
> implementation that is our default with the emerging MMU support.
> 
> To test the implementation / reference of a syscall number, I grepped 
> the entire source trees for
> 
>    __NR_xxx
> 
> or
> 
>    _system[0-9](.*xxxx    (stripped leading __NR_X)
>
> to try and find any mention at all of a particular syscall in that C 
> library implementation.

I think for glibc, you also need to look for INLINE_SYSCALL and
INTERNAL_SYSCALL, possibly more.

However, note that many of the syscall numbers that are referenced
by glibc are not _required_ by it, because it already contains
alternative implementations.

> The results are interesting, and verbose.  In fact, the lists are so 
> long I'm almost certain I've missed some other obscure way that uClibc 
> or glibc can access a __NR_ macro.  Please let me know if this is the case.
> 
> Certainly there are many implemented in neither, such as as splice and 
> friends.
> 
> Also interesting is e.g. openat() - it is implemented/referenced by 
> neither!  So, surely it would be premature to phase out open() in favour 
> of openat() when the latter is not in any viable MicroBlaze C library yet.

openat was added in glibc-2.4 as a syscall, see
http://sourceware.org/cgi-bin/cvsweb.cgi/libc/sysdeps/unix/sysv/linux/openat.c?rev=1.2.2.7&content-type=text/x-cvsweb-markup&cvsroot=glibc

What is not yet there is code to implement open() using openat() in the
absense of __NR_open.

> I guess we need some help to find the other critical ones.

I think your approach is flawed, it doesn't help at all to look at what
your libc currently does if you already think that you will need to change
the libc code.

A more relevant question is what changes should be done in glibc for this
in the first place, and I would like to hear Ulis opinion on that.

Uli: The question at hand is what syscalls a new linux architecture
should implement. To take utimes() as an example, the kernel currently
has utime(), utimes(), futimesat() and utimensat(), while glibc
provides utime(), utimes(), futimes(), futimesat(), futimens() and
utimensat(). In theory, all the glibc interfaces could be provided
on top of the utimensat() syscall, but should they?
Currently, glibc has fallback code to implement utime() using utimes(),
but not any of the others.

The same argument can be made about others, including
{,f}{mknod,mkdir,symlink,rename,access,chmod,open}{,at}
select/pselect,poll/ppoll,epoll_wait/epoll_pwait
vfork/fork/clone
{,rt_}{sigaction,sigsuspend,sigreturn,sigprocmask,sigpending}
any of your newly proposed syscalls with flags

If a new architecture should override these, should that be
done in the architecture specific code, or should the common
code be modified to handle this implicitly?

On a similar note, do you agree that a new 32 bit architecture should
define 32 bit uid_t and 64 bit off_t, and consequently leave
out all the uid16_t and loff_t based syscalls that are then simple
duplicates?

> If there's a cleaner analysis I can do, please let me know and I'll repeat.
> 
> Here goes - uClibc first, then glibc
> 
> ** Not implemented/referenced in uClibc 0.9.27 12 January 2005
> __NR_add_key
> __NR_clock_getres
> __NR_clock_gettime
> __NR_clock_nanosleep
> __NR_clock_settime
> __NR_creat
> __NR_epoll_pwait
> __NR_eventfd
> __NR__exit
> __NR_exit_group
> __NR_faccessat
> __NR_fadvise64_64
> __NR_fallocate
> __NR_fchmodat
> __NR_fchownat
> __NR_fstatat64
> __NR_fstatfs64
> __NR_futex
> __NR_futimesat
> __NR_getcpu
> __NR_get_robust_list
> __NR_gettid
> __NR_inotify_add_watch
> __NR_inotify_init
> __NR_inotify_rm_watch
> __NR_io_cancel
> __NR_io_destroy
> __NR_io_getevents
> __NR_ioprio_get
> __NR_ioprio_set
> __NR_io_setup
> __NR_io_submit
> __NR_kexec_load
> __NR_keyctl
> __NR_linkat
> __NR_lookup_dcookie
> __NR_mkdirat
> __NR_mknodat
> __NR_newfstat
> __NR_newlstat
> __NR_newstat
> __NR_newuname
> __NR_nfsservctl
> __NR_openat
> __NR_ppoll
> __NR_pselect7
> __NR_readahead
> __NR_readlinkat
> __NR_removexattrs
> __NR_renameat
> __NR_request_key
> __NR_restart_syscall
> __NR_rt_sigqueueinfo
> __NR_sched_getaffinity
> __NR_sched_setaffinity
> __NR_semtimedop
> __NR_set_robust_list
> __NR_set_tid_address
> __NR_sgetmask
> __NR_signal
> __NR_signalfd
> __NR_splice
> __NR_ssetmask
> __NR_statfs64
> __NR_symlinkat
> __NR_sync_file_range
> __NR_syscalls
> __NR_tee
> __NR_tgkill
> __NR_timerfd_create
> __NR_timerfd_gettime
> __NR_timerfd_settime
> __NR_tkill
> __NR_unlinkat
> __NR_unshare
> __NR_utimensat
> __NR_vmsplice
> __NR_waitid

This list is possibly more useful as a "what's wrong with uClibc" list.
Most of these syscalls were added recently and should be added in uClibc
eventually, at least the subset of them that is also provided by glibc.

> ** Not implemented/referenced in glibc
> __NR_add_key
> __NR_adjtimex
> __NR_alarm
> __NR_capget
> __NR_capset
> __NR_chdir
> __NR_chown
> __NR_chroot
> __NR_close
> __NR_creat
> __NR_delete_module
> __NR_dup
> __NR_dup2
> __NR_epoll_create
> __NR_epoll_ctl
> __NR_epoll_pwait
> __NR_eventfd
> __NR_execve
> __NR_faccessat
> __NR_fallocate
> __NR_fchdir
> __NR_fchmod
> __NR_fchmodat
> __NR_fchown
> __NR_fchownat
> __NR_fdatasync
> __NR_fgetxattr
> __NR_flistxattr
> __NR_flock
> __NR_fremovexattr
> __NR_fsetxattr
> __NR_fstatat64
> __NR_fsync
> __NR_futimesat
> __NR_getcpu
> __NR_getegid
> __NR_geteuid
> __NR_getgroups
> __NR_getitimer
> __NR_getpgid
> __NR_getpgrp
> __NR_getppid
> __NR_getpriority
> __NR_getrlimit
> __NR_get_robust_list
> __NR_getrusage
> __NR_getsid
> __NR_gettid
> __NR_getxattr
> __NR_init_module
> __NR_inotify_add_watch
> __NR_inotify_init
> __NR_inotify_rm_watch
> __NR_io_cancel
> __NR_io_destroy
> __NR_io_getevents
> __NR_ioprio_get
> __NR_ioprio_set
> __NR_io_setup
> __NR_io_submit
> __NR_kexec_load
> __NR_keyctl
> __NR_kill
> __NR_lgetxattr
> __NR_link
> __NR_linkat
> __NR_listxattr
> __NR_llistxattr
> __NR_lookup_dcookie
> __NR_lremovexattr
> __NR_lseek
> __NR_lsetxattr
> __NR_mkdirat
> __NR_mknodat
> __NR_mount
> __NR_msgctl
> __NR_msgget
> __NR_msgrcv
> __NR_msgsnd
> __NR_munmap
> __NR_nanosleep
> __NR_newfstat
> __NR_newlstat
> __NR_newstat
> __NR_newuname
> __NR_nfsservctl
> __NR_nice
> __NR_openat
> __NR_pause
> __NR_personality
> __NR_pivot_root
> __NR_ppoll
> __NR_prctl
> __NR_pselect7
> __NR_ptrace
> __NR_quotactl
> __NR_read
> __NR_readlinkat
> __NR_readv
> __NR_reboot
> __NR_removexattrs
> __NR_renameat
> __NR_request_key
> __NR_restart_syscall
> __NR_sched_getparam
> __NR_sched_get_priority_max
> __NR_sched_get_priority_min
> __NR_sched_getscheduler
> __NR_sched_rr_get_interval
> __NR_sched_setparam
> __NR_sched_setscheduler
> __NR_sched_yield
> __NR_semctl
> __NR_semget
> __NR_semop
> __NR_sendfile64
> __NR_setdomainname
> __NR_setgid
> __NR_setgroups
> __NR_sethostname
> __NR_setitimer
> __NR_setpgid
> __NR_setpriority
> __NR_setregid
> __NR_setreuid
> __NR_setrlimit
> __NR_set_robust_list
> __NR_setsid
> __NR_settimeofday
> __NR_setuid
> __NR_setxattr
> __NR_sgetmask
> __NR_shmat
> __NR_shmctl
> __NR_shmdt
> __NR_shmget
> __NR_signal
> __NR_signalfd
> __NR_splice
> __NR_ssetmask
> __NR_stime
> __NR_swapoff
> __NR_swapon
> __NR_symlinkat
> __NR_sync
> __NR_sync_file_range
> __NR_syscalls
> __NR_sysinfo
> __NR_syslog
> __NR_tee
> __NR_time
> __NR_timerfd_create
> __NR_timerfd_gettime
> __NR_timerfd_settime
> __NR_times
> __NR_umask
> __NR_umount
> __NR_unlink
> __NR_unlinkat
> __NR_unshare
> __NR_uselib
> __NR_utimensat
> __NR_vhangup
> __NR_vmsplice
> __NR_write
> __NR_writev

You are obviously missing the INLINE_SYSCALL and INTERNAL_SYSCALL here.
I do think that having this list (in a correct form) is useful for the
discussion, so it would be nice if you could do it again, including those.

	Arnd <><
