Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYEEBKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYEEBKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 21:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYEEBKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 21:10:42 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:48046 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYEEBKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 21:10:41 -0400
X-ClientAddr: 220.233.82.121
Message-ID: <481E5E58.8040906@petalogix.com>
Date: Mon, 05 May 2008 11:09:44 +1000
From: John Williams <john.williams@petalogix.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: monstr@seznam.cz, Matthew Wilcox <matthew@wil.cx>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <481ACE51.80202@seznam.cz> <481BE0E4.7010904@petalogix.com> <200805031116.50236.arnd@arndb.de>
In-Reply-To: <200805031116.50236.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

>> As a first pass at assessing the C library impact on a completely 
>> renovated syscall list, I took Michal's proposed new unistd.h and used 
>> it to grep over both the uClibc implementation that (almost) every 
>> existing microblaze user uses (!MMU), plus the glibc (cough cough) 
>> implementation that is our default with the emerging MMU support.
>>
>> To test the implementation / reference of a syscall number, I grepped 
>> the entire source trees for
>>
>>    __NR_xxx
>>
>> or
>>
>>    _system[0-9](.*xxxx    (stripped leading __NR_X)
>>
>> to try and find any mention at all of a particular syscall in that C 
>> library implementation.
> 
> I think for glibc, you also need to look for INLINE_SYSCALL and
> INTERNAL_SYSCALL, possibly more.

OK, new list at the end of this email.

> However, note that many of the syscall numbers that are referenced
> by glibc are not _required_ by it, because it already contains
> alternative implementations.

Sure.

>> The results are interesting, and verbose.  In fact, the lists are so 
>> long I'm almost certain I've missed some other obscure way that uClibc 
>> or glibc can access a __NR_ macro.  Please let me know if this is the case.
>>
>> Certainly there are many implemented in neither, such as as splice and 
>> friends.
>>
>> Also interesting is e.g. openat() - it is implemented/referenced by 
>> neither!  So, surely it would be premature to phase out open() in favour 
>> of openat() when the latter is not in any viable MicroBlaze C library yet.
> 
> openat was added in glibc-2.4 as a syscall, see
> http://sourceware.org/cgi-bin/cvsweb.cgi/libc/sysdeps/unix/sysv/linux/openat.c?rev=1.2.2.7&content-type=text/x-cvsweb-markup&cvsroot=glibc

OK.  Our glibc patches are against 2.3.3.  I realise it's not the most 
recent, but it's the best we've got for now.

> What is not yet there is code to implement open() using openat() in the
> absense of __NR_open.

>> I guess we need some help to find the other critical ones.
> 
> I think your approach is flawed, it doesn't help at all to look at what
> your libc currently does if you already think that you will need to change
> the libc code.

I can't help but feel we've got our wires crossed here.

If, for example, neither C library has code to use openat in the absence 
of __NR_open, then surely it is premature to remove __NR_open from any 
arch, microblaze included?

> A more relevant question is what changes should be done in glibc for this
> in the first place, and I would like to hear Ulis opinion on that.

This is all very reasonable, but it's not clear why broad changes in 
glibc would be part of MicroBlaze's critical path into kernel.org. 
There are already N arch's in the kernel using mixture of obsolete and 
new API's, I don't see the problem with MicroBlaze making it N+1.

> Uli: The question at hand is what syscalls a new linux architecture

<snip>

> This list is possibly more useful as a "what's wrong with uClibc" list.
> Most of these syscalls were added recently and should be added in uClibc
> eventually, at least the subset of them that is also provided by glibc.

I'm not interested in a glibc vs uClibc debate. For deeply embedded 
systems that MicroBlaze targets, uClibc's smaller footprint makes a lot 
of sense.

The installed base of uClibc vs glibc for MicroBlaze is probably 10000:1 
or more in uClibc's favour due to our history being entirely !MMU until 
2008.  I don't expect that to change much once we get the MMU and ld.so 
functionality into our uClibc port.

> You are obviously missing the INLINE_SYSCALL and INTERNAL_SYSCALL here.
> I do think that having this list (in a correct form) is useful for the
> discussion, so it would be nice if you could do it again, including those.

OK, new list below (note glibc 2.3.3) - it's still pretty long but 32 
fewer than the last iteration.

FYI here's the search expression ($syscall is the __NR_ macro)

egrep -R \ 
"(\<$syscall\>|_syscall[0-9].*\<${syscall/#__NR_/}\>|INTERNAL_SYSCALL.*\<${syscall/#__NR_/}\>|INLINE_SYSCALL.*\<${syscall/#__NR_/}\>)"
  $GLIBC_PATH

Not implemented/referenced in glibc
__NR_add_key
__NR_alarm
__NR_capget
__NR_capset
__NR_chdir
__NR_chroot
__NR_creat
__NR_delete_module
__NR_dup
__NR_dup2
__NR_epoll_create
__NR_epoll_ctl
__NR_epoll_pwait
__NR_eventfd
__NR_faccessat
__NR_fallocate
__NR_fchdir
__NR_fchmod
__NR_fchmodat
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
__NR_getitimer
__NR_getpgid
__NR_getpgrp
__NR_getppid
__NR_get_robust_list
__NR_getrusage
__NR_getsid
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
__NR_msgget
__NR_msgrcv
__NR_msgsnd
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
__NR_pselect7
__NR_quotactl
__NR_readlinkat
__NR_removexattrs
__NR_renameat
__NR_request_key
__NR_restart_syscall
__NR_sched_rr_get_interval
__NR_sched_setparam
__NR_sched_yield
__NR_semget
__NR_semop
__NR_sendfile64
__NR_setdomainname
__NR_setgid
__NR_sethostname
__NR_setitimer
__NR_setpgid
__NR_setpriority
__NR_setregid
__NR_setreuid
__NR_set_robust_list
__NR_setsid
__NR_settimeofday
__NR_setuid
__NR_setxattr
__NR_sgetmask
__NR_shmat
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
__NR_umask
__NR_unlink
__NR_unlinkat
__NR_unshare
__NR_uselib
__NR_utimensat
__NR_vhangup
__NR_vmsplice



