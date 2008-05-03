Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbYECDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbYECDu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 23:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbYECDuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 23:50:19 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:36867 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbYECDuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 23:50:18 -0400
X-ClientAddr: 220.233.82.121
Message-ID: <481BE0E4.7010904@petalogix.com>
Date: Sat, 03 May 2008 13:49:56 +1000
From: John Williams <john.williams@petalogix.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: monstr@seznam.cz
CC: Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <matthew@wil.cx>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <48151726.9000204@itee.uq.edu.au> <200804281431.26570.arnd@arndb.de> <200805012117.12991.arnd@arndb.de> <481AA8CC.10405@petalogix.com> <481ACE51.80202@seznam.cz>
In-Reply-To: <481ACE51.80202@seznam.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, Arnd et al,

Michal Simek wrote:

>>>> How about this strategy then:
>>>> * Change all the data types and syscall numbers in the -for-2.6.27
>>>> branch to only include the minimal set, and a modern ABI
>>>> * Add the old interfaces as an out-of-tree patch that adds source
>>>> level compatibility with the old libc, but does not modify any
>>>> of the new interfaces, so that a patched kernel can run all binaries
>>>> built for the upstream version.
>>>> * phase out the old source interface gradually, as all users update
>>>> their libc source code.
>>>
>>> Any news on this from the microblaze people? Have you made up your mind
>>> on what route you want to go?
>> I think we're still digesting it.  I need to sync up with Michal and the
>> Xilinx people.  The libc and kernel API changes have to happen in
>> tandem, otherwise Michal can't properly test the kernel he's pushing.
>>
>> I am the defacto MicroBlaze uClibc and toolchain "builder" but somewhat
>> reluctantly - am trying to convince Xilnx to hand that over to someone
>> who is expert at it.
>>
>> Michal, John L, any thoughts?
>>
>> John
> 
> I am convinced we need to change syscall table. I don't want to maintain old
> syscalls. It will be easier to test smaller amount of syscalls. I would like to
> talk about with you (John W) via Skype. (Can you send me private email where you
> have time?) I talked with Steve about this week. After that I will publish our
> proposed way.

As a first pass at assessing the C library impact on a completely 
renovated syscall list, I took Michal's proposed new unistd.h and used 
it to grep over both the uClibc implementation that (almost) every 
existing microblaze user uses (!MMU), plus the glibc (cough cough) 
implementation that is our default with the emerging MMU support.

To test the implementation / reference of a syscall number, I grepped 
the entire source trees for

   __NR_xxx

or

   _system[0-9](.*xxxx    (stripped leading __NR_X)

to try and find any mention at all of a particular syscall in that C 
library implementation.

The results are interesting, and verbose.  In fact, the lists are so 
long I'm almost certain I've missed some other obscure way that uClibc 
or glibc can access a __NR_ macro.  Please let me know if this is the case.

Certainly there are many implemented in neither, such as as splice and 
friends.

Also interesting is e.g. openat() - it is implemented/referenced by 
neither!  So, surely it would be premature to phase out open() in favour 
of openat() when the latter is not in any viable MicroBlaze C library yet.

I guess we need some help to find the other critical ones.

What's also curious is that uClibc not-implemented list is shorter than 
glibc's.  Does this just mean glibc uses fewer of the legacy APIs?  I 
really don't know, but I'm sure someone else does.

If there's a cleaner analysis I can do, please let me know and I'll repeat.

Here goes - uClibc first, then glibc

** Not implemented/referenced in uClibc 0.9.27 12 January 2005
__NR_add_key
__NR_clock_getres
__NR_clock_gettime
__NR_clock_nanosleep
__NR_clock_settime
__NR_creat
__NR_epoll_pwait
__NR_eventfd
__NR__exit
__NR_exit_group
__NR_faccessat
__NR_fadvise64_64
__NR_fallocate
__NR_fchmodat
__NR_fchownat
__NR_fstatat64
__NR_fstatfs64
__NR_futex
__NR_futimesat
__NR_getcpu
__NR_get_robust_list
__NR_gettid
__NR_inotify_add_watch
__NR_inotify_init
__NR_inotify_rm_watch
__NR_io_cancel
__NR_io_destroy
__NR_io_getevents
__NR_ioprio_get
__NR_ioprio_set
__NR_io_setup
__NR_io_submit
__NR_kexec_load
__NR_keyctl
__NR_linkat
__NR_lookup_dcookie
__NR_mkdirat
__NR_mknodat
__NR_newfstat
__NR_newlstat
__NR_newstat
__NR_newuname
__NR_nfsservctl
__NR_openat
__NR_ppoll
__NR_pselect7
__NR_readahead
__NR_readlinkat
__NR_removexattrs
__NR_renameat
__NR_request_key
__NR_restart_syscall
__NR_rt_sigqueueinfo
__NR_sched_getaffinity
__NR_sched_setaffinity
__NR_semtimedop
__NR_set_robust_list
__NR_set_tid_address
__NR_sgetmask
__NR_signal
__NR_signalfd
__NR_splice
__NR_ssetmask
__NR_statfs64
__NR_symlinkat
__NR_sync_file_range
__NR_syscalls
__NR_tee
__NR_tgkill
__NR_timerfd_create
__NR_timerfd_gettime
__NR_timerfd_settime
__NR_tkill
__NR_unlinkat
__NR_unshare
__NR_utimensat
__NR_vmsplice
__NR_waitid



** Not implemented/referenced in glibc
__NR_add_key
__NR_adjtimex
__NR_alarm
__NR_capget
__NR_capset
__NR_chdir
__NR_chown
__NR_chroot
__NR_close
__NR_creat
__NR_delete_module
__NR_dup
__NR_dup2
__NR_epoll_create
__NR_epoll_ctl
__NR_epoll_pwait
__NR_eventfd
__NR_execve
__NR_faccessat
__NR_fallocate
__NR_fchdir
__NR_fchmod
__NR_fchmodat
__NR_fchown
__NR_fchownat
__NR_fdatasync
__NR_fgetxattr
__NR_flistxattr
__NR_flock
__NR_fremovexattr
__NR_fsetxattr
__NR_fstatat64
__NR_fsync
__NR_futimesat
__NR_getcpu
__NR_getegid
__NR_geteuid
__NR_getgroups
__NR_getitimer
__NR_getpgid
__NR_getpgrp
__NR_getppid
__NR_getpriority
__NR_getrlimit
__NR_get_robust_list
__NR_getrusage
__NR_getsid
__NR_gettid
__NR_getxattr
__NR_init_module
__NR_inotify_add_watch
__NR_inotify_init
__NR_inotify_rm_watch
__NR_io_cancel
__NR_io_destroy
__NR_io_getevents
__NR_ioprio_get
__NR_ioprio_set
__NR_io_setup
__NR_io_submit
__NR_kexec_load
__NR_keyctl
__NR_kill
__NR_lgetxattr
__NR_link
__NR_linkat
__NR_listxattr
__NR_llistxattr
__NR_lookup_dcookie
__NR_lremovexattr
__NR_lseek
__NR_lsetxattr
__NR_mkdirat
__NR_mknodat
__NR_mount
__NR_msgctl
__NR_msgget
__NR_msgrcv
__NR_msgsnd
__NR_munmap
__NR_nanosleep
__NR_newfstat
__NR_newlstat
__NR_newstat
__NR_newuname
__NR_nfsservctl
__NR_nice
__NR_openat
__NR_pause
__NR_personality
__NR_pivot_root
__NR_ppoll
__NR_prctl
__NR_pselect7
__NR_ptrace
__NR_quotactl
__NR_read
__NR_readlinkat
__NR_readv
__NR_reboot
__NR_removexattrs
__NR_renameat
__NR_request_key
__NR_restart_syscall
__NR_sched_getparam
__NR_sched_get_priority_max
__NR_sched_get_priority_min
__NR_sched_getscheduler
__NR_sched_rr_get_interval
__NR_sched_setparam
__NR_sched_setscheduler
__NR_sched_yield
__NR_semctl
__NR_semget
__NR_semop
__NR_sendfile64
__NR_setdomainname
__NR_setgid
__NR_setgroups
__NR_sethostname
__NR_setitimer
__NR_setpgid
__NR_setpriority
__NR_setregid
__NR_setreuid
__NR_setrlimit
__NR_set_robust_list
__NR_setsid
__NR_settimeofday
__NR_setuid
__NR_setxattr
__NR_sgetmask
__NR_shmat
__NR_shmctl
__NR_shmdt
__NR_shmget
__NR_signal
__NR_signalfd
__NR_splice
__NR_ssetmask
__NR_stime
__NR_swapoff
__NR_swapon
__NR_symlinkat
__NR_sync
__NR_sync_file_range
__NR_syscalls
__NR_sysinfo
__NR_syslog
__NR_tee
__NR_time
__NR_timerfd_create
__NR_timerfd_gettime
__NR_timerfd_settime
__NR_times
__NR_umask
__NR_umount
__NR_unlink
__NR_unlinkat
__NR_unshare
__NR_uselib
__NR_utimensat
__NR_vhangup
__NR_vmsplice
__NR_write
__NR_writev


> 
> Michal
> 
> 
> 

