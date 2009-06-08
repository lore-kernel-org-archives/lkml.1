Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZFHUZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZFHUZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZFHUZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:25:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40924 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbZFHUZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:25:24 -0400
Date: Mon, 8 Jun 2009 16:24:07 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 2/2] convert to syscall tracepoints
Message-ID: <20090608202406.GA3181@redhat.com>
References: <cover.1244222378.git.jbaron@redhat.com> <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com> <20090607132936.GC12088@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090607132936.GC12088@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 03:29:36PM +0200, Ingo Molnar wrote:
> the functionality is fine and very desired IMO, but the 
> implementation is pretty large and ugly, isnt it?
> 
> Wouldnt it be possible to compress this:
> 
> > +#ifdef __NR_setgroups
> > +trace_event_syscall_enter(2, setgroups, int, gidsetsize, gid_t __user *, grouplist);
> > +trace_event_syscall_exit(setgroups);
> > +#define ENTERCASEsetgroups create_syscall_enter(2, setgroups, int, gid_t __user *);
> > +#define EXITCASEsetgroups create_syscall_exit(setgroups);
> > +#else
> > +#define ENTERCASEsetgroups
> > +#define EXITCASEsetgroups
> > +#endif
> 
> down to some sane syntax? Do we really want to replicate all the 
> DEFINE_SYSCALL() information again in a separate header? Is there no 
> way to somehow define the tracepoint in-situ, where the 
> DEFINE_SYSCALL macro is present? That would eliminate 
> include/trace/events/syscalls.h altogether.
> 
> 	Ingo

ok, I've re-worked the implmentation a bit and I've gotten each syscall
down to:

#ifdef __NR_setgroups
trace_event_syscall(2, setgroups, int, gidsetsize, gid_t __user *,
grouplist);
#endif

However, I'm still creating a separate syscalls.h trace file. I think
that doing this via DEFINE_SYSCALL() is going to be difficult. We can
easily define the tracepoints via DEFINE_SYSCALL(), but then we are
going to need to reference these tracepoints somehow from ptrace.c. I
don't see how to do this easily. Further, over time we hope to replace
most of the default tracepoints, with customized tracepoints that are
more human readable. We need to store these somewhere. In the new
implementation I can do this as follows:

#ifdef __NR_clock_settime
#ifdef SYSCALL_OVERRIDE
TRACE_EVENT(sysenter_clock_settime,
        TP_PROTO(clockid_t which_clock, struct timespec __user *tp),
        TP_ARGS(which_clock, tp),
        TP_STRUCT__entry(
                __field(clockid_t, which_clock)
                __field(struct timespec __user *, tp)
        ),
        TP_fast_assign(
                __entry->which_clock = which_clock;
                __entry->tp = tp;
        ),
        TP_printk("%s %016Lx",
clock_id_toname((u64)__entry->which_clock), (u64)__entry->tp)
);
trace_event_syscall_exit(clock_settime);
#else
trace_event_syscall(2, clock_settime, clockid_t, which_clock, struct
timespec __user *, tp);
#endif
#endif

The new 2/2 patch is below.

thanks,

-Jason


---
 arch/x86/kernel/ptrace.c             |    8 +-
 include/asm-generic/syscall.h        |    3 +
 include/trace/events/syscalls-core.h | 1341 ++++++++++++++++++++++++++++++++++
 include/trace/events/syscalls.h      |  158 ++++
 include/trace/syscall.h              |   64 ++
 kernel/trace/Makefile                |    1 -
 kernel/trace/trace.c                 |  100 +++
 kernel/trace/trace_syscalls.c        |  250 -------
 8 files changed, 1672 insertions(+), 253 deletions(-)
 create mode 100644 include/trace/events/syscalls-core.h
 create mode 100644 include/trace/events/syscalls.h
 delete mode 100644 kernel/trace/trace_syscalls.c

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 09ecbde..f6f5b52 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -35,6 +35,10 @@
 #include <asm/proto.h>
 #include <asm/ds.h>
 
+#include <linux/ftrace.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+#undef CREATE_TRACE_POINTS
 #include <trace/syscall.h>
 
 #include "tls.h"
@@ -1498,7 +1502,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 		ret = -1L;
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_enter(regs);
+		syscall_tracepoints_enter(regs);
 
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
@@ -1524,7 +1528,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_exit(regs);
+		syscall_tracepoints_exit(regs);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
diff --git a/include/asm-generic/syscall.h b/include/asm-generic/syscall.h
index ea8087b..ef4c68e 100644
--- a/include/asm-generic/syscall.h
+++ b/include/asm-generic/syscall.h
@@ -22,6 +22,9 @@
 struct task_struct;
 struct pt_regs;
 
+
+struct syscall_metadata *syscall_nr_to_meta(int nr);
+
 /**
  * syscall_get_nr - find what system call a task is executing
  * @task:	task of interest, must be blocked
diff --git a/include/trace/events/syscalls-core.h b/include/trace/events/syscalls-core.h
new file mode 100644
index 0000000..824e092
--- /dev/null
+++ b/include/trace/events/syscalls-core.h
@@ -0,0 +1,1341 @@
+#ifdef __NR_time
+trace_event_syscall(1, time, time_t __user *, tloc);
+#endif
+
+#ifdef __NR_stime
+trace_event_syscall(1, stime, time_t __user *, tptr);
+#endif
+
+#ifdef __NR_gettimeofday
+trace_event_syscall(2, gettimeofday, struct timeval __user *, tv, struct timezone __user *, tz);
+#endif
+
+#ifdef __NR_settimeofday
+trace_event_syscall(2, settimeofday, struct timeval __user *, tv, struct timezone __user *, tz);
+#endif
+
+#ifdef __NR_adjtimex
+trace_event_syscall(1, adjtimex, struct timex __user *, txc_p);
+#endif
+
+#ifdef __NR_times
+trace_event_syscall(1, times, struct tms __user *, tbuf);
+#endif
+
+#ifdef __NR_gettid
+trace_event_syscall(0, gettid);
+#endif
+
+#ifdef __NR_nanosleep
+trace_event_syscall(2, nanosleep, struct timespec __user *, rqtp, struct timespec __user *, rmtp);
+#endif
+
+#ifdef __NR_alarm
+trace_event_syscall(1, alarm, unsigned int, seconds);
+#endif
+
+#ifdef __NR_getpid
+trace_event_syscall(0, getpid);
+#endif
+
+#ifdef __NR_getppid
+trace_event_syscall(0, getppid);
+#endif
+
+#ifdef __NR_getuid
+trace_event_syscall(0, getuid);
+#endif
+
+#ifdef __NR_geteuid
+trace_event_syscall(0, geteuid);
+#endif
+
+#ifdef __NR_getgid
+trace_event_syscall(0, getgid);
+#endif
+
+#ifdef __NR_getegid
+trace_event_syscall(0, getegid);
+#endif
+
+#ifdef __NR_getresuid
+trace_event_syscall(3, getresuid, uid_t __user *, ruid, uid_t __user *, euid, uid_t __user *, suid);
+#endif
+
+#ifdef __NR_getresgid
+trace_event_syscall(3, getresgid, gid_t __user *, rgid, gid_t __user *, egid, gid_t __user *, sgid);
+#endif
+
+#ifdef __NR_getpgid
+trace_event_syscall(1, getpgid, pid_t, pid);
+#endif
+
+#ifdef __NR_getpgrp
+trace_event_syscall(0, getpgrp);
+#endif
+
+#ifdef __NR_getsid
+trace_event_syscall(1, getsid, pid_t, pid);
+#endif
+
+#ifdef __NR_getgroups
+trace_event_syscall(2, getgroups, int, gidsetsize, gid_t __user *, grouplist);
+#endif
+
+#ifdef __NR_setregid
+trace_event_syscall(2, setregid, gid_t, rgid, gid_t, egid);
+#endif
+
+#ifdef __NR_setgid
+trace_event_syscall(1, setgid, gid_t, gid);
+#endif
+
+#ifdef __NR_setreuid
+trace_event_syscall(2, setreuid, uid_t, ruid, uid_t, euid);
+#endif
+
+#ifdef __NR_setuid
+trace_event_syscall(1, setuid, uid_t, uid);
+#endif
+
+#ifdef __NR_setresuid
+trace_event_syscall(3, setresuid, uid_t, ruid, uid_t, euid, uid_t, suid);
+#endif
+
+#ifdef __NR_setresgid
+trace_event_syscall(3, setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid);
+#endif
+
+#ifdef __NR_setfsuid
+trace_event_syscall(1, setfsuid, uid_t, uid);
+#endif
+
+#ifdef __NR_setfsgid
+trace_event_syscall(1, setfsgid, gid_t, gid);
+#endif
+
+#ifdef _NR_setpgid
+trace_event_syscall(2, setpgid, pid_t, pid, pid_t, pgid);
+#endif
+
+#ifdef _NR_setsid
+trace_event_syscall(0, setsid);
+#endif
+
+#ifdef __NR_setgroups
+trace_event_syscall(2, setgroups, int, gidsetsize, gid_t __user *, grouplist);
+#endif
+
+#ifdef __NR_acct
+trace_event_syscall(1, acct, const char __user *, name);
+#endif
+
+#ifdef __NR_capget
+trace_event_syscall(2, capget, cap_user_header_t, header, cap_user_data_t, dataptr);
+#endif
+
+#ifdef __NR_capset
+trace_event_syscall(2, capset, cap_user_header_t, header, cap_user_data_t, data);
+#endif
+
+#ifdef __NR_personality
+trace_event_syscall(1, personality, u_long, personality);
+#endif
+
+#ifdef __NR_sigpending
+trace_event_syscall(1, sigpending, old_sigset_t __user, *set);
+#endif
+
+#ifdef __NR_sigprocmask
+trace_event_syscall(3, sigprocmask, int, how, old_sigset_t __user *, set, old_sigset_t __user *, oset);
+#endif
+
+#ifdef __NR_getitimer
+trace_event_syscall(2, getitimer, int, which, struct itimerval __user *, value);
+#endif
+
+#ifdef __NR_setitimer
+trace_event_syscall(3, setitimer, int, which, struct itimerval __user *, value, struct itimerval __user *, ovalue);
+#endif
+
+#ifdef __NR_timer_create
+trace_event_syscall(3, timer_create, clockid_t, which_clock, struct sigevent __user *, timer_event_spec, timer_t __user *, created_timer_id);
+#endif
+
+#ifdef __NR_timer_gettime
+trace_event_syscall(2, timer_gettime, clockid_t, which_clock, struct timespec __user *, tp);
+#endif
+
+#ifdef __NR_timer_getoverrun
+trace_event_syscall(1, timer_getoverrun, timer_t, timer_id);
+#endif
+
+#ifdef __NR_timer_settime
+trace_event_syscall(4, timer_settime, timer_t, timer_id, int, flags, const struct itimerspec __user *, new_setting, struct itimerspec __user *, old_setting);
+#endif
+
+#ifdef __NR_timer_delete
+trace_event_syscall(1, timer_delete, timer_t, timer_id);
+#endif
+
+#ifdef __NR_clock_settime
+#ifdef SYSCALL_OVERRIDE
+TRACE_EVENT(sysenter_clock_settime,
+	TP_PROTO(clockid_t which_clock, struct timespec __user *tp),
+	TP_ARGS(which_clock, tp),
+	TP_STRUCT__entry(
+		__field(clockid_t, which_clock)
+		__field(struct timespec __user *, tp)
+	),
+	TP_fast_assign(
+		__entry->which_clock = which_clock;
+		__entry->tp = tp;
+	),
+	TP_printk("%s %016Lx", clock_id_toname((u64)__entry->which_clock), (u64)__entry->tp)
+);
+trace_event_syscall_exit(clock_settime);
+#else
+trace_event_syscall(2, clock_settime, clockid_t, which_clock, struct timespec __user *, tp);
+#endif
+#endif
+
+#ifdef __NR_clock_gettime
+trace_event_syscall(2, clock_gettime, clockid_t, which_clock, struct timespec __user *, tp);
+#endif
+
+#ifdef __NR_clock_getres
+trace_event_syscall(2, clock_getres, clockid_t, which_clock, struct timespec __user *, tp);
+#endif
+
+#ifdef __NR_clock_nanosleep
+trace_event_syscall(4, clock_nanosleep, clockid_t, which_clock, int, flags, const struct timespec __user *, rqtp, struct timespec __user *, rmtp);
+#endif
+
+#ifdef __NR_nice
+trace_event_syscall(1, nice, int, increment);
+#endif
+
+#ifdef __NR_sched_setscheduler
+trace_event_syscall(3, sched_setscheduler, pid_t, pid, int, policy, struct sched_param __user *, param);
+#endif
+
+#ifdef __NR_sched_setparam
+trace_event_syscall(2, sched_setparam, pid_t, pid, struct sched_param __user *, param);
+#endif
+
+#ifdef __NR_sched_getscheduler
+trace_event_syscall(1, sched_getscheduler, pid_t, pid);
+#endif
+
+#ifdef __NR_sched_getparam
+trace_event_syscall(2, sched_getparam, pid_t, pid, struct sched_param __user *, param);
+#endif
+
+#ifdef __NR_sched_setaffinity
+trace_event_syscall(3, sched_setaffinity, pid_t, pid, unsigned int, len, unsigned long __user *, user_mask_ptr);
+#endif
+
+#ifdef __NR_sched_getaffinity
+trace_event_syscall(3, sched_getaffinity, pid_t, pid, unsigned int, len, unsigned long __user *, user_mask_ptr);
+#endif
+
+#ifdef __NR_sched_yield
+trace_event_syscall(0, sched_yield);
+#endif
+
+#ifdef __NR_sched_get_priority_max
+trace_event_syscall(1, sched_get_priority_max, int, policy);
+#endif
+
+#ifdef __NR_sched_get_priority_min
+trace_event_syscall(1, sched_get_priority_min, int, policy);
+#endif
+
+#ifdef __NR_sched_rr_get_interval
+trace_event_syscall(2, sched_rr_get_interval, pid_t, pid, struct timespec __user *, interval);
+#endif
+
+#ifdef __NR_setpriority
+trace_event_syscall(3, setpriority, int, which, int, who, int, niceval);
+#endif
+
+#ifdef __NR_getpriority
+trace_event_syscall(2, getpriority, int, which, int, who);
+#endif
+
+#ifdef __NR_shutdown
+trace_event_syscall(2, shutdown, int, a, int, b);
+#endif
+
+#ifdef __NR_reboot
+trace_event_syscall(4, reboot, int, magic1, int, magic2, unsigned int, cmd, void __user *, arg);
+#endif
+
+#ifdef __NR_restart_syscall
+trace_event_syscall(0, restart_syscall);
+#endif
+
+#ifdef __NR_kexec_load
+trace_event_syscall(4, kexec_load, unsigned long, e, unsigned long, nr_segments, struct kexec_segment __user *, segments, unsigned long, flags);
+#endif
+
+#ifdef __NR_exit
+trace_event_syscall(1, exit, int, error_code);
+#endif
+
+#ifdef __NR_exit_group
+trace_event_syscall(1, exit_group, int, error_code);
+#endif
+
+#ifdef __NR_wait4
+trace_event_syscall(4, wait4, pid_t, pid, int __user *, stat_addr, int, options, struct rusage __user *, ru);
+#endif
+
+#ifdef __NR_waitid
+trace_event_syscall(5, waitid, int, which, pid_t, pid, struct siginfo __user *, infop, int, options, struct rusage __user *, ru);
+#endif
+
+#ifdef __NR_waitpid
+trace_event_syscall(3, waitpid, pid_t, pid, int __user *, stat_addr, int, options);
+#endif
+
+#ifdef __NR_set_tid_address
+trace_event_syscall(1, set_tid_address, int __user *, tidptr);
+#endif
+
+#ifdef __NR_futex
+trace_event_syscall(6, futex, u32 __user *, uaddr, int, op, u32, val, struct timespec __user *, utime, u32 __user *, uaddr2, u32, val3);
+#endif
+
+#ifdef __NR_init_module
+trace_event_syscall(3, init_module, void __user *, umod, unsigned long, len, const char __user *, uargs);
+#endif
+
+#ifdef __NR_delete_module
+trace_event_syscall(2, delete_module, const char __user *, name_user, unsigned int, flags);
+#endif
+
+#ifdef __NR_rt_sigprocmask
+trace_event_syscall(4, rt_sigprocmask, int, how, sigset_t __user *, set, sigset_t __user *, oset, size_t, sigsetsize);
+#endif
+
+#ifdef __NR_rt_sigpending
+trace_event_syscall(2, rt_sigpending, sigset_t __user *, set, size_t, sigsetsize);
+#endif
+
+#ifdef __NR_rt_sigtimedwait
+trace_event_syscall(4, rt_sigtimedwait, const sigset_t __user *, uthese, siginfo_t __user *, uinfo, const struct timespec __user *, uts, size_t, sigsetsize);
+#endif
+
+#ifdef __NR_kill
+trace_event_syscall(2, kill, int, pid, int, sig);
+#endif
+
+#ifdef __NR_tgkill
+trace_event_syscall(3, tgkill, int, tgid, int, pid, int, sig);
+#endif
+
+#ifdef __NR_tkill
+trace_event_syscall(2, tkill, int, pid, int, sig);
+#endif
+
+#ifdef __NR_rt_sigqueueinfo
+trace_event_syscall(3, rt_sigqueueinfo, int, pid, int, sig, siginfo_t __user *, uinfo);
+#endif
+
+#ifdef __NR_sgetmask
+trace_event_syscall(0, sgetmask);
+#endif
+
+#ifdef __NR_ssetmask
+trace_event_syscall(1, ssetmask, int, newmask);
+#endif
+
+#ifdef __NR_signal
+trace_event_syscall(2, signal, int, sig, __sighandler_t, handler);
+#endif
+
+#ifdef __NR_pause
+trace_event_syscall(0, pause);
+#endif
+
+#ifdef __NR_sync
+trace_event_syscall(0, sync);
+#endif
+
+#ifdef __NR_fsync
+trace_event_syscall(1, fsync, unsigned int, fd);
+#endif
+
+#ifdef __NR_fdatasync
+trace_event_syscall(1, fdatasync, unsigned int, fd);
+#endif
+
+#ifdef __NR_bdflush
+trace_event_syscall(2, bdflush, int, func, long, data);
+#endif
+
+#ifdef __NR_mount
+trace_event_syscall(5, mount, char __user *, dev_name, char __user *, dir_name, char __user *, type, unsigned long, flags, void __user *, data);
+#endif
+
+#ifdef __NR_umount
+trace_event_syscall(2, umount, char __user *, name, int, flags);
+#endif
+
+#ifdef __NR_oldumount
+trace_event_syscall(1, oldumount, char __user *, name);
+#endif
+
+#ifdef __NR_truncate
+trace_event_syscall(2, truncate, const char __user *, path, unsigned long, length);
+#endif
+
+#ifdef __NR_ftruncate
+trace_event_syscall(2, ftruncate, unsigned int, fd, unsigned long, length);
+#endif
+
+#ifdef __NR_stat
+trace_event_syscall(2, stat, char __user *, filename, struct __old_kernel_stat __user *, statbuf);
+#endif
+
+#ifdef __NR_statfs
+trace_event_syscall(2, statfs, const char __user *, path, struct statfs __user *, buf);
+#endif
+
+#ifdef __NR_statfs64
+trace_event_syscall(3, statfs64, const char __user *, path, size_t, sz, struct statfs64 __user *, buf);
+#endif
+
+#ifdef __NR_fstatfs
+trace_event_syscall(2, fstatfs, unsigned int, fd, struct statfs __user *, buf);
+#endif
+
+#ifdef __NR_fstatfs64
+trace_event_syscall(3, fstatfs64, unsigned int, fd, size_t, sz, struct statfs64 __user *, buf);
+#endif
+
+#ifdef __NR_lstat
+trace_event_syscall(2, lstat, char __user *, filename, struct __old_kernel_stat __user *, statbuf);
+#endif
+
+#ifdef __NR_fstat
+trace_event_syscall(2, fstat, unsigned int, fd, struct __old_kernel_stat __user *, statbuf);
+#endif
+
+#ifdef __NR_newstat
+trace_event_syscall(2, newstat, char __user *, filename, struct stat __user *, statbuf);
+#endif
+
+#ifdef __NR_newlstat
+trace_event_syscall(2, newlstat, char __user *, filename, struct stat __user *, statbuf);
+#endif
+
+#ifdef __NR_newfstat
+trace_event_syscall(2, newfstat, unsigned int, fd, struct stat __user *, statbuf);
+#endif
+
+#ifdef __NR_ustat
+trace_event_syscall(2, ustat, unsigned, dev, struct ustat __user *, ubuf);
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_stat64)
+trace_event_syscall(2, stat64, char __user *, filename, struct stat64 __user *, statbuf);
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_fstat64)
+trace_event_syscall(2, fstat64, char __user *, filename, struct stat64 __user *, statbuf);
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_lstat64)
+trace_event_syscall(2, lstat64, char __user *, filename, struct stat64 __user *, statbuf);
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_truncate64)
+trace_event_syscall(2, truncate64, const char __user *, path, loff_t, length);
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_ftruncate64)
+trace_event_syscall(2, ftruncate64, unsigned int, fd, loff_t, length);
+#endif
+
+#ifdef __NR_setxattr
+trace_event_syscall(5, setxattr, const char __user *, path, const char __user *, name, const void __user *, value, size_t, size, int, flags);
+#endif
+
+#ifdef __NR_lsetxattr
+trace_event_syscall(5, lsetxattr, const char __user *, path, const char __user *, name, const void __user *, value, size_t, size, int, flags);
+#endif
+
+#ifdef __NR_fsetxattr
+trace_event_syscall(5, fsetxattr, int, fd, const char __user *, name, const void __user *, value, size_t, size, int, flags);
+#endif
+
+#ifdef __NR_getxattr
+trace_event_syscall(4, getxattr, const char __user *, path, const char __user *, name, void __user *, value, size_t, size);
+#endif
+
+#ifdef __NR_lgetxattr
+trace_event_syscall(4, lgetxattr, const char __user *, path, const char __user *, name, void __user *, value, size_t, size);
+#endif
+
+#ifdef __NR_fgetxattr
+trace_event_syscall(4, fgetxattr, int, fd, const char __user *, name, void __user *, value, size_t, size);
+#endif
+
+#ifdef _NR_listxattr
+trace_event_syscall(3, listxattr, const char __user *, path, char __user *, list, size_t, size);
+#endif
+
+#ifdef __NR_llistxattr
+trace_event_syscall(3, llistxattr, const char __user *, path, char __user *, list, size_t, size);
+#endif
+
+#ifdef __NR_flistxattr
+trace_event_syscall(3, flistxattr, int, fd, char __user *, list, size_t, size);
+#endif
+
+#ifdef __NR_removexattr
+trace_event_syscall(2, removexattr, const char __user *, path, const char __user *, name);
+#endif
+
+#ifdef __NR_lremovexattr
+trace_event_syscall(2, lremovexattr, const char __user *, path, const char __user *, name);
+#endif
+
+#ifdef __NR_fremovexattr
+trace_event_syscall(2, fremovexattr, int, fd, const char __user *, name);
+#endif
+
+#ifdef __NR_brk
+trace_event_syscall(1, brk, unsigned long, brk);
+#endif
+
+#ifdef __NR_mprotect
+trace_event_syscall(3, mprotect, unsigned long, start, size_t, len, unsigned long, prot);
+#endif
+
+#ifdef __NR_mremap
+trace_event_syscall(5, mremap, unsigned long, addr, unsigned long, old_len, unsigned long, new_len, unsigned long, flags, unsigned long, new_addr);
+#endif
+
+#ifdef __NR_remap_file_pages
+trace_event_syscall(5, remap_file_pages, unsigned long, start, unsigned long, size, unsigned long, prot, unsigned long, pgoff, unsigned long, flags);
+#endif
+
+#ifdef __NR_msync
+trace_event_syscall(3, msync, unsigned long, start, size_t, len, int, flags);
+#endif
+
+#ifdef __NR_fadvise64
+trace_event_syscall(4, fadvise64, int, fd, loff_t, offset, size_t, len, int, advice);
+#endif
+
+#ifdef __NR_fadvise64_64
+trace_event_syscall(4, fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice);
+#endif
+
+#ifdef __NR_munmap
+trace_event_syscall(2, munmap, unsigned long, addr, size_t, len);
+#endif
+
+#ifdef __NR_mlock
+trace_event_syscall(2, mlock, unsigned long, start, size_t, len);
+#endif
+
+#ifdef __NR_munlock
+trace_event_syscall(2, munlock, unsigned long, start, size_t, len);
+#endif
+
+#ifdef __NR_mlockall
+trace_event_syscall(1, mlockall, int, flags);
+#endif
+
+#ifdef __NR_munlockall
+trace_event_syscall(0, munlockall);
+#endif
+
+#ifdef __NR_madvise
+trace_event_syscall(3, madvise, unsigned long, start, size_t, len, int, behavior);
+#endif
+
+#ifdef __NR_mincore
+trace_event_syscall(3, mincore, unsigned long, start, size_t, len, unsigned char __user *, vec);
+#endif
+
+#ifdef __NR_pivot_root
+trace_event_syscall(2, pivot_root, const char __user *, new_root, const char __user *, put_old);
+#endif
+
+#ifdef __NR_chroot
+trace_event_syscall(1, chroot, const char __user *, filename);
+#endif
+
+#ifdef __NR_mknod
+trace_event_syscall(3, mknod, const char __user *, filename, int, mode, unsigned, dev);
+#endif
+
+#ifdef __NR_link
+trace_event_syscall(2, link, const char __user *, oldname, const char __user *, newname);
+#endif
+
+#ifdef __NR_symlink
+trace_event_syscall(2, symlink, const char __user *, old, const char __user *, new);
+#endif
+
+#ifdef __NR_unlink
+trace_event_syscall(1, unlink, const char __user *, pathname);
+#endif
+
+#ifdef __NR_rename
+trace_event_syscall(2, rename, const char __user *, oldname, const char __user *, newname);
+#endif
+
+#ifdef __NR_chmod
+trace_event_syscall(2, chmod, const char __user *, filename, mode_t, mode);
+#endif
+
+#ifdef __NR_fchmod
+trace_event_syscall(2, fchmod, unsigned int, fd, mode_t, mode);
+#endif
+
+#ifdef __NR_fcntl
+trace_event_syscall(3, fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg);
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_fcntl64)
+trace_event_syscall(3, fcntl64, unsigned int, fd, unsigned int, cmd, unsigned long, arg);
+#endif
+
+#ifdef __NR_dup
+trace_event_syscall(1, dup, unsigned int, fildes);
+#endif
+
+#ifdef __NR_dup2
+trace_event_syscall(2, dup2, unsigned int, oldfd, unsigned int, newfd);
+#endif
+
+#ifdef __NR_dup3
+trace_event_syscall(3, dup3, unsigned int, oldfd, unsigned int, newfd, int, flags);
+#endif
+
+#ifdef __NR_ioperm
+trace_event_syscall(3, ioperm, unsigned long, from, unsigned long, num, int, on);
+#endif
+
+#ifdef __NR_ioctl
+trace_event_syscall(3, ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg);
+#endif
+
+#ifdef __NR_flock
+trace_event_syscall(2, flock, unsigned int, fd, unsigned int, cmd);
+#endif
+
+#ifdef __NR_io_setup
+trace_event_syscall(2, io_setup, unsigned, nr_reqs, aio_context_t __user *, ctx);
+#endif
+
+#ifdef __NR_io_destroy
+trace_event_syscall(1, io_destroy, aio_context_t, ctx);
+#endif
+
+#ifdef __NR_io_getevents
+trace_event_syscall(5, io_getevents, aio_context_t, ctx_id, long, min_nr, long, nr, struct io_event __user *, events, struct timespec __user *, timeout);
+#endif
+
+#ifdef __NR_io_submit
+trace_event_syscall(3, io_submit, aio_context_t, ctx, long, nr, struct iocb __user * __user *, iocb);
+#endif
+
+#ifdef __NR_io_cancel
+trace_event_syscall(3, io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb, struct io_event __user *, result);
+#endif
+
+#ifdef __NR_sendfile
+trace_event_syscall(4, sendfile, int, out_fd, int, in_fd, off_t __user *, offset, size_t, count);
+#endif
+
+#ifdef __NR_sendfile64
+trace_event_syscall(4, sendfile64, int, out_fd, int, in_fd, loff_t __user *, offset, size_t, count);
+#endif
+
+#ifdef __NR_readlink
+trace_event_syscall(3, readlink, const char __user *, path, char __user *, buf, int, bufsiz);
+#endif
+
+#ifdef __NR_creat
+trace_event_syscall(2, creat, const char __user *, pathname, int, mode);
+#endif
+
+#ifdef __NR_open
+trace_event_syscall(3, open, const char __user *, filename, int, flags, int, mode);
+#endif
+
+#ifdef __NR_close
+trace_event_syscall(1, close, unsigned int, fd);
+#endif
+
+#ifdef __NR_access
+trace_event_syscall(2, access, const char __user *, filename, int, mode);
+#endif
+
+#ifdef __NR_vhangup
+trace_event_syscall(0, vhangup);
+#endif
+
+#ifdef __NR_chown
+trace_event_syscall(3, chown, const char __user *, filename, uid_t, user, gid_t, group);
+#endif
+
+#ifdef __NR_lchown
+trace_event_syscall(3, lchown, const char __user *, filename, uid_t, user, gid_t, group);
+#endif
+
+#ifdef __NR_fchown
+trace_event_syscall(3, fchown, unsigned int, fd, uid_t, user, gid_t, group);
+#endif
+
+#if defined( __NR_chown16) && defined(CONFIG_UID16)
+trace_event_syscall(3, chown16, const char __user *, filename, old_uid_t, user, old_gid_t, group);
+#endif
+
+#if defined(__NR_lchown16) && defined(CONFIG_UID16)
+trace_event_syscall(3, lchown16, const char __user *, filename, old_uid_t, user, old_gid_t, group);
+#endif
+
+#if defined(__NR_fchown16) && defined(CONFIG_UID16)
+trace_event_syscall(3, fchown16, unsigned int, fd, old_uid_t, user, old_gid_t, group);
+#endif
+
+#if defined(__NR_setregid16) && defined(CONFIG_UID16)
+trace_event_syscall(2, setregid16, old_gid_t, rgid, old_gid_t, egid);
+#endif
+
+#if defined(__NR_setgid16) && defined(CONFIG_UID16)
+trace_event_syscall(1, setgid16, old_gid_t, gid);
+#endif
+
+#if defined(__NR_setreuid16) && defined(CONFIG_UID16)
+trace_event_syscall(2, setreuid16, old_uid_t, ruid, old_uid_t, euid);
+#endif
+
+#if defined(__NR_setuid16) && defined(CONFIG_UID16)
+trace_event_syscall(1, setuid16, old_uid_t, uid);
+#endif
+
+#if defined(__NR_setresuid16) && defined(CONFIG_UID16)
+trace_event_syscall(3, setresuid16, old_uid_t, ruid, old_uid_t, euid, old_uid_t, suid);
+#endif
+
+#if defined(__NR_getresuid16) && defined(CONFIG_UID16)
+trace_event_syscall(3, getresuid16, old_uid_t __user *, ruid, old_uid_t __user *, euid, old_uid_t __user *, suid);
+#endif
+
+#if defined(_NR_setresgid16) && defined(CONFIG_UID16)
+trace_event_syscall(3, setresgid16, old_gid_t, rgid, old_gid_t, egid, old_gid_t, sgid);
+#endif
+
+#if defined(__NR_getresgid16) && defined(CONFIG_UID16)
+trace_event_syscall(3, getresgid16, old_gid_t __user *, rgid, old_gid_t __user *, egid, old_gid_t __user *, sgid);
+#endif
+
+#if defined(__NR_setfsuid16) && defined(CONFIG_UID16)
+trace_event_syscall(1, setfsuid16, old_uid_t, uid);
+#endif
+
+#if defined(__NR_setfsgid16) && defined(CONFIG_UID16)
+trace_event_syscall(setfsgid16, 1, old_gid_t, gid);
+#endif
+
+#if defined(__NR_getgroups16) && defined(CONFIG_UID16)
+trace_event_syscall(2, getgroups16, int, gidsetsize, old_gid_t __user *, grouplist);
+#endif
+
+#if defined(__NR_setgroups16) && defined(CONFIG_UID16)
+trace_event_syscall(2, setgroups16, int, gidsetsize, old_gid_t __user *, grouplist);
+#endif
+
+#if defined(__NR_getuid16) && defined(CONFIG_UID16)
+trace_event_syscall(0, getuid16);
+#endif
+
+#if defined(__NR_geteuid16) && defined(CONFIG_UID16)
+trace_event_syscall(0, geteuid16);
+#endif
+
+#if defined(__NR_getgid16) && defined(CONFIG_UID16)
+trace_event_syscall(0, getgid16);
+#endif
+
+#if defined(__NR_getegid16) && defined(CONFIG_UID16)
+trace_event_syscall(0, getegid16);
+#endif
+
+#ifdef __NR_utime
+trace_event_syscall(2, utime, char __user *, filename, struct utimbuf __user *, times);
+#endif
+
+#ifdef __NR_utimes
+trace_event_syscall(2, utimes, char __user *, filename, struct timeval __user *, utimes);
+#endif
+
+#ifdef __NR_lseek
+trace_event_syscall(3, lseek, unsigned int, fd, off_t, offset, unsigned int, origin);
+#endif
+
+#ifdef __NR_llseek
+trace_event_syscall(5, llseek, unsigned int, fd, unsigned long, offset_high, unsigned long, offset_low, loff_t __user *, result, unsigned int, origin);
+#endif
+
+#ifdef __NR_read
+trace_event_syscall(3, read, unsigned int, fd, char __user *, buf, size_t, count);
+#endif
+
+#ifdef __NR_readahead
+trace_event_syscall(3, readahead, int, fd, loff_t, offset, size_t, count);
+#endif
+
+#ifdef __NR_readv
+trace_event_syscall(3, readv, unsigned long, fd, const struct iovec __user *, vec, unsigned long, vlen);
+#endif
+
+#ifdef __NR_write
+trace_event_syscall(3, write, unsigned int, fd, const char __user *, buf, size_t, count);
+#endif
+
+#ifdef __NR_writev
+trace_event_syscall(3, writev, unsigned long, fd, const struct iovec __user *, vec, unsigned long, vlen);
+#endif
+
+#ifdef __NR_pread64
+trace_event_syscall(4, pread64, unsigned int, fd, char __user *, buf, size_t, count, loff_t, pos);
+#endif
+
+#ifdef __NR_pwrite64
+trace_event_syscall(4, pwrite64, unsigned int, fd, const char __user *, buf, size_t, count, loff_t, pos);
+#endif
+
+#ifdef __NR_preadv
+trace_event_syscall(5, preadv, unsigned long, fd, const struct iovec __user *, vec, unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h);
+#endif
+
+#ifdef __NR_pwritev
+trace_event_syscall(5, pwritev, unsigned long, fd, const struct iovec __user *, vec, unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h);
+#endif
+
+#ifdef __NR_getcwd
+trace_event_syscall(2, getcwd, char __user *, buf, unsigned long, size);
+#endif
+
+#ifdef __NR_mkdir
+trace_event_syscall(2, mkdir, const char __user *, pathname, int, mode);
+#endif
+
+#ifdef __NR_chdir
+trace_event_syscall(1, chdir, const char __user *, filename);
+#endif
+
+#ifdef __NR_fchdir
+trace_event_syscall(1, fchdir, unsigned int, fd);
+#endif
+
+#ifdef __NR_rmdir
+trace_event_syscall(1, rmdir, const char __user *, pathname);
+#endif
+
+#ifdef __NR_lookup_dcookie
+trace_event_syscall(3, lookup_dcookie, u64, cookie64, char __user *, buf, size_t, len);
+#endif
+
+#ifdef __NR_quotactl
+trace_event_syscall(4, quotactl, unsigned int, cmd, const char __user *, special, qid_t, id, void __user *, addr);
+#endif
+
+#ifdef __NR_getdents
+trace_event_syscall(3, getdents, unsigned int, fd, struct linux_dirent __user *, dirent, unsigned int, count);
+#endif
+
+#ifdef __NR_getdents64
+trace_event_syscall(3, getdents64, unsigned int, fd, struct linux_dirent64 __user *, dirent, unsigned int, count);
+#endif
+
+#ifdef __NR_setsockopt
+trace_event_syscall(5, setsockopt, int, fd, int, level, int, optname, char __user *, optval, int, optlen);
+#endif
+
+#ifdef __NR_getsockopt
+trace_event_syscall(5, getsockopt, int, fd, int, level, int, optname, char __user *, optval, int __user *, optlen);
+#endif
+
+#ifdef __NR_bind
+trace_event_syscall(3, bind, int, a, struct sockaddr __user *, usr, int, b);
+#endif
+
+#ifdef __NR_connect
+trace_event_syscall(3, connect, int, a, struct sockaddr __user *, saddr, int, b);
+#endif
+
+#ifdef __NR_accept
+trace_event_syscall(3, accept, int, a, struct sockaddr __user *, saddr, int __user *, ptr);
+#endif
+
+#ifdef __NR_accept4
+trace_event_syscall(4, accept4, int, a, struct sockaddr __user *, saddr, int __user *, ptr, int, b);
+#endif
+
+#ifdef __NR_getsockname
+trace_event_syscall(3, getsockname, int, a, struct sockaddr __user *, saddr, int __user *, ptr);
+#endif
+
+#ifdef __NR_getpeername
+trace_event_syscall(3, getpeername, int, a, struct sockaddr __user *, saddr, int __user *, ptr);
+#endif
+
+#ifdef __NR_send
+trace_event_syscall(4, send, int, a, void __user *, ptr, size_t, size, unsigned, b);
+#endif
+
+#ifdef __NR_sendto
+trace_event_syscall(6, sendto, int, a, void __user *, ptr, size_t, size, unsigned, b, struct sockaddr __user *, saddr, int, c);
+#endif
+
+#ifdef __NR_sendmsg
+trace_event_syscall(3, sendmsg, int, fd, struct msghdr __user *, msg, unsigned, flags);
+#endif
+
+#ifdef __NR_recv
+trace_event_syscall(4, recv, int, a, void __user *, ptr, size_t, size, unsigned, b);
+#endif
+
+#ifdef __NR_recvfrom
+trace_event_syscall(6, recvfrom, int, a, void __user *, ptr, size_t, size, unsigned, b, struct sockaddr __user *, saddr, int __user *, uptr);
+#endif
+
+#ifdef __NR_recvmsg
+trace_event_syscall(3, recvmsg, int, fd, struct msghdr __user *, msg, unsigned, flags);
+#endif
+
+#ifdef __NR_socket
+trace_event_syscall(3, socket, int, a, int, b, int, c);
+#endif
+
+#ifdef __NR_socketpair
+trace_event_syscall(4, socketpair, int, a, int, b, int, c, int __user *, ptr);
+#endif
+
+#ifdef __NR_socketcall
+trace_event_syscall(2, socketcall, int, call, unsigned long __user *, args);
+#endif
+
+#ifdef __NR_listen
+trace_event_syscall(2, listen, int, a, int, b);
+#endif
+
+#ifdef __NR_poll
+trace_event_syscall(3, poll, struct pollfd __user *, ufds, unsigned int, nfds, long, timeout);
+#endif
+
+#ifdef __NR_select
+trace_event_syscall(5, select, int, n, fd_set __user *, inp, fd_set __user *, outp,  fd_set __user *, exp, struct timeval __user *, tvp);
+#endif
+
+#ifdef __NR_epoll_create
+trace_event_syscall(1, epoll_create, int, size);
+#endif
+
+#ifdef __NR_epoll_create1
+trace_event_syscall(1, epoll_create1, int, flags);
+#endif
+
+#ifdef __NR_epoll_ctl
+trace_event_syscall(4, epoll_ctl, int, epfd, int, op, int, fd, struct epoll_event __user *, eve);
+#endif
+
+#ifdef __NR_epoll_wait
+trace_event_syscall(4, epoll_wait, int, epfd, struct epoll_event __user *, events, int, maxevents, int, timeout);
+#endif
+
+#ifdef __NR_epoll_pwait
+trace_event_syscall(6, epoll_pwait, int, epfd, struct epoll_event __user *, events, int, maxevents, int, timeout, const sigset_t __user *, sigmask, size_t, sigsetsize);
+#endif
+
+#ifdef __NR_gethostname
+trace_event_syscall(2, gethostname, char __user *, name, int, len);
+#endif
+
+#ifdef __NR_sethostname
+trace_event_syscall(2, sethostname, char __user *, name, int, len);
+#endif
+
+#ifdef __NR_setdomainname
+trace_event_syscall(2, setdomainname, char __user *, name, int, len);
+#endif
+
+#ifdef __NR_newuname
+trace_event_syscall(1, newuname, struct new_utsname __user *, name);
+#endif
+
+#ifdef __NR_getrlimit
+trace_event_syscall(2, getrlimit, unsigned int, resource, struct rlimit __user *, rlim );
+#endif
+
+#if (defined(COMPAT_RLIM_OLD_INFINITY) || !(defined(CONFIG_IA64))) && defined(__NR_old_getrlimit)
+trace_event_syscall(2, old_getrlimit, unsigned int, resource, struct rlimit __user *, rlim);
+#endif
+
+#ifdef __NR_setrlimit
+trace_event_syscall(2, setrlimit, unsigned int, resource, struct rlimit __user *, rlim);
+#endif
+
+#ifdef __NR_getrusage
+trace_event_syscall(2, getrusage, int, who, struct rusage __user *, ru);
+#endif
+
+#ifdef __NR_umask
+trace_event_syscall(1, umask, int, mask);
+#endif
+
+#ifdef __NR_msgget
+trace_event_syscall(2, msgget, key_t, key, int, msgflg);
+#endif
+
+#ifdef __NR_msgsnd
+trace_event_syscall(4, msgsnd, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz, int, msgflg);
+#endif
+
+#ifdef __NR_msgrcv
+trace_event_syscall(5, msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz, long, msgtyp, int, msgflg);
+#endif
+
+#ifdef __NR_msgctl
+trace_event_syscall(3, msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf);
+#endif
+
+#ifdef __NR_semget
+trace_event_syscall(3, semget, key_t, key, int, nsems, int, semflg);
+#endif
+
+#ifdef __NR_semop
+trace_event_syscall(3, semop, int, semid, struct sembuf __user *, sops, unsigned, nsops);
+#endif
+
+#ifdef __NR_semctl
+trace_event_syscall(4, semctl, int, semid, int, semnum, int, cmd, int, arg);
+#endif
+
+#ifdef __NR_semtimedop
+trace_event_syscall(4, semtimedop, int, semid, struct sembuf __user *, sops, unsigned, nsops, const struct timespec __user *, timeout);
+#endif
+
+#ifdef __NR_shmat
+trace_event_syscall(3, shmat, int, shmid, char __user *, shmaddr, int, shmflg);
+#endif
+
+#ifdef __NR_shmget
+trace_event_syscall(3, shmget, key_t, key, size_t, size, int, flag);
+#endif
+
+#ifdef __NR_shmdt
+trace_event_syscall(1, shmdt, char __user *, shmaddr);
+#endif
+
+#ifdef __NR_shmctl
+trace_event_syscall(3, shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf);
+#endif
+
+#ifdef __NR_mq_open
+trace_event_syscall(4, mq_open, const char __user *, name, int, oflag, mode_t, mode, struct mq_attr __user *, attr);
+#endif
+
+#ifdef __NR_mq_unlink
+trace_event_syscall(1, mq_unlink, const char __user *, name);
+#endif
+
+#ifdef __NR_mq_timedsend
+trace_event_syscall(5, mq_timedsend, mqd_t, mqdes, const char __user *, msg_ptr, size_t, msg_len, unsigned int, msg_prio, const struct timespec __user *, abs_timeout);
+#endif
+
+#ifdef __NR_mq_timedreceive
+trace_event_syscall(5, mq_timedreceive, mqd_t, mqdes, char __user *, msg_ptr, size_t, msg_len, unsigned int __user *, msg_prio, const struct timespec __user *, abs_timeout);
+#endif
+
+#ifdef __NR_mq_notify
+trace_event_syscall(2, mq_notify, mqd_t, mqdes, const struct sigevent __user *, notification);
+#endif
+
+#ifdef __NR_mq_getsetattr
+trace_event_syscall(3, mq_getsetattr, mqd_t, mqdes, const struct mq_attr __user *, mqstat, struct mq_attr __user *, omqstat);
+#endif
+
+#ifdef __NR_pciconfig_iobase
+trace_event_syscall(3, pciconfig_iobase, long, which, unsigned long, bus, unsigned long, devfn);
+#endif
+
+#ifdef __NR_pciconfig_read
+trace_event_syscall(5, pciconfig_read, unsigned long bus, unsigned long dfn, unsigned long off, unsigned long len, void __user *buf);
+#endif
+
+#ifdef __NR_pciconfig_write
+trace_event_syscall(5, pciconfig_write, unsigned long, bus, unsigned long, dfn, unsigned long, off, unsigned long, len, void __user *, buf);
+#endif
+
+#ifdef __NR_prctl
+trace_event_syscall(5, prctl, int, option, unsigned long, arg2, unsigned long, arg3, unsigned long, arg4, unsigned long, arg5);
+#endif
+
+#ifdef __NR_swapon
+trace_event_syscall(2, swapon, const char __user *, specialfile, int, swap_flags);
+#endif
+
+#ifdef __NR_swapoff
+trace_event_syscall(1, swapoff, const char __user *, specialfile);
+#endif
+
+#ifdef __NR_sysctl
+trace_event_syscall(1, sysctl, struct __sysctl_args __user *, args);
+#endif
+
+#ifdef __NR_sysinfo
+trace_event_syscall(1, sysinfo, struct sysinfo __user *, info);
+#endif
+
+#ifdef __NR_sysfs
+trace_event_syscall(3, sysfs, int, option, unsigned long, arg1, unsigned long, arg2);
+#endif
+
+#ifdef __NR_nfsservctl
+trace_event_syscall(3, nfsservctl, int, cmd, struct nfsctl_arg __user *, arg, void __user *, res);
+#endif
+
+#ifdef __NR_syslog
+trace_event_syscall(3, syslog, int, type, char __user *, buf, int, len);
+#endif
+
+#ifdef __NR_uselib
+trace_event_syscall(1, uselib, const char __user *, library);
+#endif
+
+#ifdef __NR_ni_syscall
+trace_event_syscall(0, ni_syscall);
+#endif
+
+#ifdef __NR_ptrace
+trace_event_syscall(4, ptrace, long, request, long, pid, long, addr, long, data);
+#endif
+
+#ifdef __NR_add_key
+trace_event_syscall(5, add_key, const char __user *, _type, const char __user *, _description, const void __user *, _payload, size_t, plen, key_serial_t, destringid);
+#endif
+
+#ifdef __NR_request_key
+trace_event_syscall(4, request_key, const char __user *, _type, const char __user *, _description, const char __user *, _callout_info, key_serial_t, destringid);
+#endif
+
+#ifdef __NR_keyctl
+trace_event_syscall(5, keyctl, int, cmd, unsigned long, arg2, unsigned long, arg3, unsigned long, arg4, unsigned long, arg5);
+#endif
+
+#ifdef __NR_ioprio_set
+trace_event_syscall(3, ioprio_set, int, which, int, who, int, ioprio);
+#endif
+
+#ifdef __NR_ioprio_get
+trace_event_syscall(2, ioprio_get, int, which, int, who);
+#endif
+
+#ifdef __NR_set_mempolicy
+trace_event_syscall(3, set_mempolicy, int, mode, unsigned long __user *, nmask, unsigned long, maxnode);
+#endif
+
+#ifdef __NR_migrate_pages
+trace_event_syscall(4, migrate_pages, pid_t, pid, unsigned long, maxnode, const unsigned long __user *, from, const unsigned long __user *, to);
+#endif
+
+#ifdef __NR_move_pages
+trace_event_syscall(6, move_pages, pid_t, pid, unsigned long, nr_pages, const void __user * __user *, pages, const int __user *, nodes, int __user *, status, int, flags);
+#endif
+
+#ifdef __NR_mbind
+trace_event_syscall(6, mbind, unsigned long, start, unsigned long, len, unsigned long, mode, unsigned long __user *, nmask, unsigned long, maxnode, unsigned, flags);
+#endif
+
+#ifdef __NR_get_mempolicy
+trace_event_syscall(5, get_mempolicy, int __user *, policy, unsigned long __user *, nmask, unsigned long, maxnode, unsigned long, addr, unsigned long, flags);
+#endif
+
+#ifdef __NR_inotify_init
+trace_event_syscall(0, inotify_init);
+#endif
+
+#ifdef __NR_inotify_init1
+trace_event_syscall(1, inotify_init1, int, flags);
+#endif
+
+#ifdef __NR_inotify_add_watch
+trace_event_syscall(3, inotify_add_watch, int, fd, const char __user *, path, u32, mask);
+#endif
+
+#ifdef __NR_inotify_rm_watch
+trace_event_syscall(2, inotify_rm_watch, int, fd, __s32, wd);
+#endif
+
+#ifdef __NR_spu_run
+trace_event_syscall(3, spu_run, int, fd, __u32 __user *, unpc, __u32 __user *, ustatus);
+#endif
+
+#ifdef __NR_spu_create
+trace_event_syscall(4, spu_create, const char __user *, name, unsigned int, flags, mode_t, mode, int, fd);
+#define EXITCASEspu_create
+#endif
+
+#ifdef __NR_mknodat
+trace_event_syscall(4, mknodat, int, dfd, const char __user *, filename, int, mode, unsigned, dev);
+#endif
+
+#ifdef __NR_mkdirat
+trace_event_syscall(3, mkdirat, int, dfd, const char __user *, pathname, int, mode);
+#endif
+
+#ifdef __NR_unlinkat
+trace_event_syscall(3, unlinkat, int, dfd, const char __user *, pathname, int, flag);
+#endif
+
+#ifdef __NR_symlinkat
+trace_event_syscall(3, symlinkat, const char __user *, oldname, int, newdfd, const char __user *, newname);
+#endif
+
+#ifdef __NR_linkat
+trace_event_syscall(5, linkat, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname, int, flags);
+#endif
+
+#ifdef __NR_renameat
+trace_event_syscall(4, renameat, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname);
+#endif
+
+#ifdef __NR_futimesat
+trace_event_syscall(3, futimesat, int, dfd, char __user *, filename, struct timeval __user *, utimes);
+#endif
+
+#ifdef __NR_faccessat
+trace_event_syscall(3, faccessat, int, dfd, const char __user *, filename, int, mode);
+#endif
+
+#ifdef __NR_fchmodat
+trace_event_syscall(3, fchmodat, int, dfd, const char __user *, filename, mode_t, mode);
+#endif
+
+#ifdef __NR_fchownat
+trace_event_syscall(5, fchownat, int, dfd, const char __user *, filename, uid_t, user, gid_t, group, int, flag);
+#endif
+
+#ifdef __NR_openat
+trace_event_syscall(4, openat, int, dfd, const char __user *, filename, int, flags, int, mode);
+#endif
+
+#ifdef __NR_newfstatat
+trace_event_syscall(4, newfstatat, int, dfd, char __user *, filename, struct stat __user *, statbuf, int, flag);
+#endif
+
+#ifdef __NR_fstatat64
+trace_event_syscall(4, fstatat64, int dfd, char __user *filename, struct stat64 __user *statbuf, int, flag);
+#endif
+
+#ifdef __NR_readlinkat
+trace_event_syscall(4, readlinkat, int, dfd, const char __user *, path, char __user *, buf, int, bufsiz);
+#endif
+
+#ifdef __NR_utimensat
+trace_event_syscall(4, utimensat, int, dfd, char __user *, filename, struct timespec __user *, utimes, int, flags);
+#endif
+
+#ifdef __NR_unshare
+trace_event_syscall(1, unshare, unsigned long, unshare_flags);
+#endif
+
+#ifdef __NR_splice
+trace_event_syscall(6, splice, int, fd_in, loff_t __user *, off_in, int, fd_out, loff_t __user *, off_out, size_t, len, unsigned int, flags);
+#endif
+
+#ifdef __NR_vmsplice
+trace_event_syscall(4, vmsplice, int, fd, const struct iovec __user *, iov, unsigned long, nr_segs, unsigned int, flags);
+#endif
+
+#ifdef __NR_tee
+trace_event_syscall(4, tee, int, fdin, int, fdout, size_t, len, unsigned int, flags);
+#endif
+
+#ifdef __NR_sync_file_range
+trace_event_syscall(4, sync_file_range, int, fd, loff_t, offset, loff_t, nbytes, unsigned int, flags);
+#endif
+
+#ifdef __NR_sync_file_range2
+trace_event_syscall(4, sync_file_range2, int, fd, unsigned int, flags, loff_t, offset, loff_t, nbytes);
+#endif
+
+#ifdef __NR_get_robust_list
+trace_event_syscall(3, get_robust_list, int, pid, struct robust_list_head __user * __user *, head_ptr, size_t __user *, len_ptr);
+#endif
+
+#ifdef __NR_set_robust_list
+trace_event_syscall(2, set_robust_list, struct robust_list_head __user *, head, size_t, len);
+#endif
+
+#ifdef __NR_getcpu
+trace_event_syscall(3, getcpu, unsigned __user *, cpu, unsigned __user *, node, struct getcpu_cache __user *, cache);
+#endif
+
+#ifdef __NR_signalfd
+trace_event_syscall(3, signalfd, int, ufd, sigset_t __user *, user_mask, size_t, sizemask);
+#endif
+
+#ifdef __NR_signalfd4
+trace_event_syscall(4, signalfd4, int, ufd, sigset_t __user *, user_mask, size_t, sizemask, int, flags);
+#endif
+
+#ifdef __NR_timerfd_create
+trace_event_syscall(2, timerfd_create, int, clockid, int, flags);
+#endif
+
+#ifdef __NR_timerfd_settime
+trace_event_syscall(4, timerfd_settime, int, ufd, int, flags, const struct itimerspec __user *, utmr, struct itimerspec __user *, otmr);
+#endif
+
+#ifdef __NR_timerfd_gettime
+trace_event_syscall(2, timerfd_gettime, int, ufd, struct itimerspec __user *, otmr);
+#endif
+
+#ifdef __NR_eventfd
+trace_event_syscall(1, eventfd, unsigned int, count);
+#endif
+
+#ifdef __NR_eventfd2
+trace_event_syscall(2, eventfd2, unsigned int, count, int, flags);
+#endif
+
+#ifdef __NR_fallocate
+trace_event_syscall(4, fallocate, int, fd, int, mode, loff_t, offset, loff_t, len);
+#endif
+
+#ifdef __NR_old_readdir
+trace_event_syscall(3, old_readdir, unsigned int, a, struct old_linux_dirent __user *, uptr, unsigned int, b);
+#endif
+
+#ifdef __NR_pselect6
+trace_event_syscall(6, pselect6, int, a, fd_set __user *, b, fd_set __user *, c, fd_set __user *, d, struct timespec __user *, e, void __user *, f);
+#endif
+
+#ifdef __NR_ppoll
+trace_event_syscall(5, ppoll, struct pollfd __user *, a, unsigned int, b, struct timespec __user *, c, const sigset_t __user *, d, size_t, e);
+#endif
+
+#ifdef __NR_pipe2
+trace_event_syscall(2, pipe2, int __user *, uptr, int, a);
+#endif
+
+#ifdef __NR_pipe
+trace_event_syscall(1, pipe, int __user *, uptr);
+#endif
+
+#ifdef __NR_perf_counter_open
+trace_event_syscall(5, perf_counter_open, const struct perf_counter_hw_event __user *, hw_event_uptr, pid_t, pid, int, cpu, int, group_fd, unsigned long, flags);
+#endif
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
new file mode 100644
index 0000000..0bb99a2
--- /dev/null
+++ b/include/trace/events/syscalls.h
@@ -0,0 +1,158 @@
+#if !defined(_TRACE_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SYSCALLS_H
+
+#include <asm/syscall.h>
+#include <asm-generic/syscall.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM syscalls
+
+struct epoll_event;
+struct iattr;
+struct inode;
+struct iocb;
+struct io_event;
+struct iovec;
+struct itimerspec;
+struct itimerval;
+struct kexec_segment;
+struct linux_dirent;
+struct linux_dirent64;
+struct list_head;
+struct msgbuf;
+struct msghdr;
+struct msqid_ds;
+struct new_utsname;
+struct nfsctl_arg;
+struct __old_kernel_stat;
+struct pollfd;
+struct rlimit;
+struct rusage;
+struct sched_param;
+struct semaphore;
+struct sembuf;
+struct shmid_ds;
+struct sockaddr;
+struct stat;
+struct stat64;
+struct statfs;
+struct statfs64;
+struct __sysctl_args;
+struct sysinfo;
+struct timespec;
+struct timeval;
+struct timex;
+struct timezone;
+struct tms;
+struct utimbuf;
+struct mq_attr;
+struct compat_stat;
+struct compat_timeval;
+struct robust_list_head;
+struct getcpu_cache;
+struct old_linux_dirent;
+struct perf_counter_hw_event;
+
+/* misc macros */
+
+#define SYSCALL_OVERRIDE 1
+
+#define clock_id_toname(id) \
+	(id == CLOCK_REALTIME ? "CLOCK_REALTIME" : \
+		id == CLOCK_MONOTONIC ? "CLOCK_MONOTONIC" : \
+		id == CLOCK_PROCESS_CPUTIME_ID ? "CLOCK_PROCESS_CPUTIME_ID" : \
+		id == CLOCK_MONOTONIC_RAW ? "CLOCK_MONOTONIC_RAW" : \
+		id == CLOCK_SGI_CYCLE ? "CLOCK_SGI_CYCLE" : \
+		"UNKNOWN CLOCK")
+
+/* enter helper macros */
+
+#define MAX_SYS_ARGS 6
+
+#define expand_enter_proto_0() void
+#define expand_enter_proto_1(t1, p1) t1 p1
+#define expand_enter_proto_2(t2, p2, ...) t2 p2, expand_enter_proto_1(__VA_ARGS__)
+#define expand_enter_proto_3(t3, p3, ...) t3 p3, expand_enter_proto_2(__VA_ARGS__)
+#define expand_enter_proto_4(t4, p4, ...) t4 p4, expand_enter_proto_3(__VA_ARGS__)
+#define expand_enter_proto_5(t5, p5, ...) t5 p5, expand_enter_proto_4(__VA_ARGS__)
+#define expand_enter_proto_6(t6, p6, ...) t6 p6, expand_enter_proto_5(__VA_ARGS__)
+
+#define expand_enter_args_0()
+#define expand_enter_args_1(t1, p1) p1
+#define expand_enter_args_2(t2, p2, ...) p2, expand_enter_args_1(__VA_ARGS__)
+#define expand_enter_args_3(t3, p3, ...) p3, expand_enter_args_2(__VA_ARGS__)
+#define expand_enter_args_4(t4, p4, ...) p4, expand_enter_args_3(__VA_ARGS__)
+#define expand_enter_args_5(t5, p5, ...) p5, expand_enter_args_4(__VA_ARGS__)
+#define expand_enter_args_6(t6, p6, ...) p6, expand_enter_args_5(__VA_ARGS__)
+
+#define expand_enter_entry_0()
+#define expand_enter_entry_1(t1, p1) __field(t1, p1) 
+#define expand_enter_entry_2(t2, p2, ...) __field(t2, p2) expand_enter_entry_1(__VA_ARGS__)
+#define expand_enter_entry_3(t3, p3, ...) __field(t3, p3) expand_enter_entry_2(__VA_ARGS__)
+#define expand_enter_entry_4(t4, p4, ...) __field(t4, p4) expand_enter_entry_3(__VA_ARGS__)
+#define expand_enter_entry_5(t5, p5, ...) __field(t5, p5) expand_enter_entry_4(__VA_ARGS__)
+#define expand_enter_entry_6(t6, p6, ...) __field(t6, p6) expand_enter_entry_5(__VA_ARGS__)
+
+#define expand_enter_assign_0()
+#define expand_enter_assign_1(t1, p1) __entry->p1 = p1; 
+#define expand_enter_assign_2(t2, p2, ...) __entry->p2 = p2; expand_enter_assign_1(__VA_ARGS__)
+#define expand_enter_assign_3(t3, p3, ...) __entry->p3 = p3; expand_enter_assign_2(__VA_ARGS__)
+#define expand_enter_assign_4(t4, p4, ...) __entry->p4 = p4; expand_enter_assign_3(__VA_ARGS__)
+#define expand_enter_assign_5(t5, p5, ...) __entry->p5 = p5; expand_enter_assign_4(__VA_ARGS__)
+#define expand_enter_assign_6(t6, p6, ...) __entry->p6 = p6; expand_enter_assign_5(__VA_ARGS__)
+
+#define expand_enter_printk_1(t1, p1) (u64)__entry->p1
+#define expand_enter_printk_2(t2, p2, ...) (u64)__entry->p2, expand_enter_printk_1(__VA_ARGS__)
+#define expand_enter_printk_3(t3, p3, ...) (u64)__entry->p3, expand_enter_printk_2(__VA_ARGS__)
+#define expand_enter_printk_4(t4, p4, ...) (u64)__entry->p4, expand_enter_printk_3(__VA_ARGS__)
+#define expand_enter_printk_5(t5, p5, ...) (u64)__entry->p5, expand_enter_printk_4(__VA_ARGS__)
+#define expand_enter_printk_6(t6, p6, ...) (u64)__entry->p6, expand_enter_printk_5(__VA_ARGS__)
+
+#define TP_printk_0() TP_printk()
+#define TP_printk_1(...) TP_printk("%016Lx", expand_enter_printk_1(__VA_ARGS__))
+#define TP_printk_2(...) TP_printk("%016Lx %016Lx", expand_enter_printk_2(__VA_ARGS__))
+#define TP_printk_3(...) TP_printk("%016Lx %016Lx %016Lx", expand_enter_printk_3(__VA_ARGS__))
+#define TP_printk_4(...) TP_printk("%016Lx %016Lx %016Lx %016Lx", expand_enter_printk_4(__VA_ARGS__))
+#define TP_printk_5(...) TP_printk("%016Lx %016Lx %016Lx %016Lx %016Lx", \
+						expand_enter_printk_5(__VA_ARGS__))
+#define TP_printk_6(...) TP_printk("%016Lx %016Lx %016Lx %016Lx %016Lx %016Lx", \
+						expand_enter_printk_6(__VA_ARGS__))
+
+#define trace_event_syscall_enter(n, name, ...)			\
+	TRACE_EVENT(sysenter_##name,				\
+		TP_PROTO(expand_enter_proto_##n(__VA_ARGS__)),	\
+		TP_ARGS(expand_enter_args_##n(__VA_ARGS__)),	\
+		TP_STRUCT__entry(expand_enter_entry_##n(__VA_ARGS__)), \
+		TP_fast_assign(expand_enter_assign_##n(__VA_ARGS__)), \
+		TP_printk_##n(__VA_ARGS__) \
+	);							
+
+/* exit helper macros */
+
+#define trace_event_syscall_exit(name)				\
+	TRACE_EVENT(sysexit_##name,				\
+		TP_PROTO(long ret),				\
+		TP_ARGS(ret),					\
+		TP_STRUCT__entry(				\
+			__field(long, retval)			\
+		),						\
+		TP_fast_assign(					\
+			__entry->retval = ret;			\
+		),						\
+		TP_printk("return value: %ld", __entry->retval) \
+	);							
+
+#undef trace_event_syscall
+#define trace_event_syscall(n, name, ...)			\
+	trace_event_syscall_enter(n, name, __VA_ARGS__);	\
+	trace_event_syscall_exit(name);
+
+
+#include <trace/events/syscalls-core.h>
+
+#endif /* _TRACE_SYSCALLS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 8cfe515..7d1b28c 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -2,6 +2,7 @@
 #define _TRACE_SYSCALL_H
 
 #include <asm/ptrace.h>
+#include <trace/events/syscalls.h>
 
 /*
  * A syscall entry in the ftrace syscalls array.
@@ -25,11 +26,74 @@ extern void start_ftrace_syscalls(void);
 extern void stop_ftrace_syscalls(void);
 extern void ftrace_syscall_enter(struct pt_regs *regs);
 extern void ftrace_syscall_exit(struct pt_regs *regs);
+extern struct syscall_metadata *syscall_nr_to_meta(int nr);
+extern void syscall_tracepoints_enter(struct pt_regs *regs);
+extern void syscall_tracepoints_exit(struct pt_regs *regs);
 #else
 static inline void start_ftrace_syscalls(void)			{ }
 static inline void stop_ftrace_syscalls(void)			{ }
 static inline void ftrace_syscall_enter(struct pt_regs *regs)	{ }
 static inline void ftrace_syscall_exit(struct pt_regs *regs)	{ }
+extern struct syscall_metadata *syscall_nr_to_meta(int nr);
+static inline void syscall_tracepoints_enter(struct pt_regs *regs)	{ }
+static inline void syscall_tracepoints_exit(struct pt_regs *regs)	{ }
 #endif
 
+#define MAX_SYS_ARGS 6
+
+#define expand_enter_sys_args_0()
+#define expand_enter_sys_args_1(t1, a1) (t1) sys_args[0]
+#define expand_enter_sys_args_2(t1, a1, t2, a2) expand_enter_sys_args_1(t1, a1), (t2) sys_args[1]
+#define expand_enter_sys_args_3(t1, a1, t2, a2, t3, a3) expand_enter_sys_args_2(t1, a1, t2, a2), (t3) sys_args[2]
+#define expand_enter_sys_args_4(t1, a1, t2, a2, t3, a3, t4, a4) expand_enter_sys_args_3(t1, a1, t2, a2, t3, a3), (t4) sys_args[3]
+#define expand_enter_sys_args_5(t1, a1, t2, a2, t3, a3, t4, a4, t5, a5) expand_enter_sys_args_4(t1, a1, t2, a2, t3, a3, t4, a4), (t5) sys_args[4]
+#define expand_enter_sys_args_6(t1, a1, t2, a2, t3, a3, t4, a4, t5, a5, t6, a6) expand_enter_sys_args_5(t1, a1, t2, a2, t3, a3, t4, a4, t5, a5), (t6) sys_args[5]
+
+
+#define create_syscall_enter(n, sysname, ...)           \
+        case __NR_##sysname:                            \
+                syscall_get_arguments(current, regs, 0, n, sys_args); \
+                trace_sysenter_##sysname(expand_enter_sys_args_##n(__VA_ARGS__)); \
+                break;
+
+#define create_syscall_exit(sysname)                            \
+        case __NR_##sysname:                                    \
+                trace_sysexit_##sysname(ret);                   \
+                break;                                          \
+
+#undef trace_event_syscall
+#define trace_event_syscall(n, name, ...)			\
+	create_syscall_enter(n, name, __VA_ARGS__);
+
+#undef SYSCALL_OVERRIDE
+
+static inline void __syscall_tracepoints_enter(struct pt_regs *regs)
+{
+	int syscall_nr;
+	long sys_args[MAX_SYS_ARGS];
+
+	syscall_nr = syscall_get_nr(current, regs);
+	switch (syscall_nr) {	
+#include <trace/events/syscalls-core.h>
+	}
+}
+
+#undef trace_event_syscall
+#define trace_event_syscall(n, name, ...)			\
+	create_syscall_exit(name);
+
+static inline void __syscall_tracepoints_exit(struct pt_regs * regs)
+{
+        int syscall_nr;
+        long ret;
+
+        syscall_nr = syscall_get_nr(current, regs);
+        ret = syscall_get_return_value(current, regs);
+        switch (syscall_nr) {
+#include <trace/events/syscalls-core.h>
+	}
+}
+
+
+
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 848e5ce..9d9bb61 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -48,7 +48,6 @@ obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events.o
 obj-$(CONFIG_EVENT_TRACING) += trace_export.o
-obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_EVENT_TRACING) += trace_mm.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 665a915..bd6ea5f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -36,6 +36,8 @@
 #include <linux/poll.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
+#include <trace/syscall.h>
+#include <trace/events/syscalls.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -3312,6 +3314,100 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+
+void syscall_tracepoints_enter(struct pt_regs *regs)
+{
+	__syscall_tracepoints_enter(regs);
+}
+
+void syscall_tracepoints_exit(struct pt_regs *regs)
+{
+	__syscall_tracepoints_exit(regs);
+}
+
+/* Prevent from races on thread flags toggling */
+static DEFINE_MUTEX(syscall_trace_lock);
+static bool sys_enabled;
+
+void start_ftrace_syscalls(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	mutex_lock(&syscall_trace_lock);
+	/* Don't enable the flag on the tasks twice */
+	if (sys_enabled)
+		goto unlock;
+	arch_init_ftrace_syscalls();
+	read_lock_irqsave(&tasklist_lock, flags);
+	do_each_thread(g, t) {
+		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+	} while_each_thread(g, t);
+	read_unlock_irqrestore(&tasklist_lock, flags);
+	sys_enabled = true;
+
+unlock:
+	mutex_unlock(&syscall_trace_lock);
+}
+
+void stop_ftrace_syscalls(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	mutex_lock(&syscall_trace_lock);
+	read_lock_irqsave(&tasklist_lock, flags);
+	do_each_thread(g, t) {
+		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+	} while_each_thread(g, t);
+	read_unlock_irqrestore(&tasklist_lock, flags);
+	sys_enabled = false;
+	mutex_unlock(&syscall_trace_lock);
+}
+
+static ssize_t write_tracesys(struct file *file, const char __user *user_buf,
+                                                size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case '1':
+		start_ftrace_syscalls();
+		break;
+	case '0':
+		stop_ftrace_syscalls();
+		break;
+	}
+	return count;
+}
+
+static ssize_t read_tracesys(struct file *file,
+               char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+
+	if (sys_enabled)
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static struct file_operations tracing_syscall_fops = {
+	.write =        write_tracesys,
+	.read =         read_tracesys
+};
+
+#endif
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -4095,6 +4191,10 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
+#ifdef CONFIG_FTRACE_SYSCALLS
+	trace_create_file("trace_syscalls", 0644, d_tracer,
+			NULL, &tracing_syscall_fops);
+#endif
 #ifdef CONFIG_SYSPROF_TRACER
 	init_tracer_sysprof_debugfs(d_tracer);
 #endif
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
deleted file mode 100644
index 5e57964..0000000
--- a/kernel/trace/trace_syscalls.c
+++ /dev/null
@@ -1,250 +0,0 @@
-#include <trace/syscall.h>
-#include <linux/kernel.h>
-#include <asm/syscall.h>
-
-#include "trace_output.h"
-#include "trace.h"
-
-/* Keep a counter of the syscall tracing users */
-static int refcount;
-
-/* Prevent from races on thread flags toggling */
-static DEFINE_MUTEX(syscall_trace_lock);
-
-/* Option to display the parameters types */
-enum {
-	TRACE_SYSCALLS_OPT_TYPES = 0x1,
-};
-
-static struct tracer_opt syscalls_opts[] = {
-	{ TRACER_OPT(syscall_arg_type, TRACE_SYSCALLS_OPT_TYPES) },
-	{ }
-};
-
-static struct tracer_flags syscalls_flags = {
-	.val = 0, /* By default: no parameters types */
-	.opts = syscalls_opts
-};
-
-enum print_line_t
-print_syscall_enter(struct trace_iterator *iter, int flags)
-{
-	struct trace_seq *s = &iter->seq;
-	struct trace_entry *ent = iter->ent;
-	struct syscall_trace_enter *trace;
-	struct syscall_metadata *entry;
-	int i, ret, syscall;
-
-	trace_assign_type(trace, ent);
-
-	syscall = trace->nr;
-
-	entry = syscall_nr_to_meta(syscall);
-	if (!entry)
-		goto end;
-
-	ret = trace_seq_printf(s, "%s(", entry->name);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	for (i = 0; i < entry->nb_args; i++) {
-		/* parameter types */
-		if (syscalls_flags.val & TRACE_SYSCALLS_OPT_TYPES) {
-			ret = trace_seq_printf(s, "%s ", entry->types[i]);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-		/* parameter values */
-		ret = trace_seq_printf(s, "%s: %lx%s ", entry->args[i],
-				       trace->args[i],
-				       i == entry->nb_args - 1 ? ")" : ",");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
-end:
-	trace_seq_printf(s, "\n");
-	return TRACE_TYPE_HANDLED;
-}
-
-enum print_line_t
-print_syscall_exit(struct trace_iterator *iter, int flags)
-{
-	struct trace_seq *s = &iter->seq;
-	struct trace_entry *ent = iter->ent;
-	struct syscall_trace_exit *trace;
-	int syscall;
-	struct syscall_metadata *entry;
-	int ret;
-
-	trace_assign_type(trace, ent);
-
-	syscall = trace->nr;
-
-	entry = syscall_nr_to_meta(syscall);
-	if (!entry) {
-		trace_seq_printf(s, "\n");
-		return TRACE_TYPE_HANDLED;
-	}
-
-	ret = trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
-				trace->ret);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
-}
-
-void start_ftrace_syscalls(void)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-
-	mutex_lock(&syscall_trace_lock);
-
-	/* Don't enable the flag on the tasks twice */
-	if (++refcount != 1)
-		goto unlock;
-
-	arch_init_ftrace_syscalls();
-	read_lock_irqsave(&tasklist_lock, flags);
-
-	do_each_thread(g, t) {
-		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
-	} while_each_thread(g, t);
-
-	read_unlock_irqrestore(&tasklist_lock, flags);
-
-unlock:
-	mutex_unlock(&syscall_trace_lock);
-}
-
-void stop_ftrace_syscalls(void)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-
-	mutex_lock(&syscall_trace_lock);
-
-	/* There are perhaps still some users */
-	if (--refcount)
-		goto unlock;
-
-	read_lock_irqsave(&tasklist_lock, flags);
-
-	do_each_thread(g, t) {
-		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
-	} while_each_thread(g, t);
-
-	read_unlock_irqrestore(&tasklist_lock, flags);
-
-unlock:
-	mutex_unlock(&syscall_trace_lock);
-}
-
-void ftrace_syscall_enter(struct pt_regs *regs)
-{
-	struct syscall_trace_enter *entry;
-	struct syscall_metadata *sys_data;
-	struct ring_buffer_event *event;
-	int size;
-	int syscall_nr;
-
-	syscall_nr = syscall_get_nr(current, regs);
-
-	sys_data = syscall_nr_to_meta(syscall_nr);
-	if (!sys_data)
-		return;
-
-	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
-
-	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_ENTER, size,
-							0, 0);
-	if (!event)
-		return;
-
-	entry = ring_buffer_event_data(event);
-	entry->nr = syscall_nr;
-	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
-
-	trace_current_buffer_unlock_commit(event, 0, 0);
-	trace_wake_up();
-}
-
-void ftrace_syscall_exit(struct pt_regs *regs)
-{
-	struct syscall_trace_exit *entry;
-	struct syscall_metadata *sys_data;
-	struct ring_buffer_event *event;
-	int syscall_nr;
-
-	syscall_nr = syscall_get_nr(current, regs);
-
-	sys_data = syscall_nr_to_meta(syscall_nr);
-	if (!sys_data)
-		return;
-
-	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_EXIT,
-				sizeof(*entry), 0, 0);
-	if (!event)
-		return;
-
-	entry = ring_buffer_event_data(event);
-	entry->nr = syscall_nr;
-	entry->ret = syscall_get_return_value(current, regs);
-
-	trace_current_buffer_unlock_commit(event, 0, 0);
-	trace_wake_up();
-}
-
-static int init_syscall_tracer(struct trace_array *tr)
-{
-	start_ftrace_syscalls();
-
-	return 0;
-}
-
-static void reset_syscall_tracer(struct trace_array *tr)
-{
-	stop_ftrace_syscalls();
-	tracing_reset_online_cpus(tr);
-}
-
-static struct trace_event syscall_enter_event = {
-	.type	 	= TRACE_SYSCALL_ENTER,
-	.trace		= print_syscall_enter,
-};
-
-static struct trace_event syscall_exit_event = {
-	.type	 	= TRACE_SYSCALL_EXIT,
-	.trace		= print_syscall_exit,
-};
-
-static struct tracer syscall_tracer __read_mostly = {
-	.name	     	= "syscall",
-	.init		= init_syscall_tracer,
-	.reset		= reset_syscall_tracer,
-	.flags		= &syscalls_flags,
-};
-
-__init int register_ftrace_syscalls(void)
-{
-	int ret;
-
-	ret = register_ftrace_event(&syscall_enter_event);
-	if (!ret) {
-		printk(KERN_WARNING "event %d failed to register\n",
-		       syscall_enter_event.type);
-		WARN_ON_ONCE(1);
-	}
-
-	ret = register_ftrace_event(&syscall_exit_event);
-	if (!ret) {
-		printk(KERN_WARNING "event %d failed to register\n",
-		       syscall_exit_event.type);
-		WARN_ON_ONCE(1);
-	}
-
-	return register_tracer(&syscall_tracer);
-}
-device_initcall(register_ftrace_syscalls);
-- 
1.6.0.6



