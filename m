Return-Path: <linux-kernel-owner+w=401wt.eu-S1764017AbZEHVFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764017AbZEHVFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZEHVF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:05:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38757 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbZEHVFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:05:25 -0400
Date: Fri, 8 May 2009 17:03:47 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090508210347.GA3121@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been thinking about converting the current ftrace syscall tracer to
the TRACE_EVENT() macros. There are a few issues with the current syscall tracer
approach:

1) It has to be enabled for all processes and all syscalls. By moving to
TRACE_EVENT(), it can be enabled/disabled per tracepoint and can also
make use of the generic tracing filters, such as "trace all process for
pid x"

2) Other tracers can not tie into it, since its not tracepoint based.
TRACE_EVENT() fixes this.

3) data formatting. The syscall tracer I don't believe understands all
the various types for output formatting. By moving to TRACE_EVENT(), we
can print out a more readible syscall trace.

4) The ftrace syscall tracer needs a new arch specific code for each
architecture. By converting to TRACE_EVENT() we don't need any
architecutre specific code.

Other issues to consider:

* Maintainence. The current syscall tracer automatically picks up new
syscalls. The TRACE_EVENT() will be harder to initially set up. But
once its done, syscalls are obviously not added often. So I don't think
this will be too bad.

* Performance. The current syscall tracer adds a 'test_thread_flag()' to
syscall entry/exit. The TRACE_EVENT() would add a per-syscall global to
check. So they are going to have different cache profiles...however, the
tracepoint infrastructure is hopefully moving to the 'immediate' value
work, which will make this more highly optimized.

I've also tested the patch shown below (which uses, DECLARE_TRACE(), as
a preliminary proof of concept), using getpid() in a loop, and tbench,
and saw very small performance differences. Obviously we would have to
do more extensive testing before deciding.

Patch is pretty rough, but should give a rough sense of what the
DECLARE_TRACE() type patch might look like...

thanks,

-Jason


diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 677d159..8d2f90e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -67,6 +67,8 @@ struct perf_counter_hw_event;
 #include <linux/quota.h>
 #include <linux/key.h>
 #include <trace/syscall.h>
+#include <trace/syscalls.h>
+#include <linux/tracepoint.h>
 
 #define __SC_DECL1(t1, a1)	t1 a1
 #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
@@ -75,6 +77,13 @@ struct perf_counter_hw_event;
 #define __SC_DECL5(t5, a5, ...) t5 a5, __SC_DECL4(__VA_ARGS__)
 #define __SC_DECL6(t6, a6, ...) t6 a6, __SC_DECL5(__VA_ARGS__)
 
+#define __SC_ADECL1(t1, a1)	a1
+#define __SC_ADECL2(t2, a2, ...) a2, __SC_ADECL1(__VA_ARGS__)
+#define __SC_ADECL3(t3, a3, ...) a3, __SC_ADECL2(__VA_ARGS__)
+#define __SC_ADECL4(t4, a4, ...) a4, __SC_ADECL3(__VA_ARGS__)
+#define __SC_ADECL5(t5, a5, ...) a5, __SC_ADECL4(__VA_ARGS__)
+#define __SC_ADECL6(t6, a6, ...) a6, __SC_ADECL5(__VA_ARGS__)
+
 #define __SC_LONG1(t1, a1) 	long a1
 #define __SC_LONG2(t2, a2, ...) long a2, __SC_LONG1(__VA_ARGS__)
 #define __SC_LONG3(t3, a3, ...) long a3, __SC_LONG2(__VA_ARGS__)
@@ -97,7 +106,6 @@ struct perf_counter_hw_event;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
-#ifdef CONFIG_FTRACE_SYSCALLS
 #define __SC_STR_ADECL1(t, a)		#a
 #define __SC_STR_ADECL2(t, a, ...)	#a, __SC_STR_ADECL1(__VA_ARGS__)
 #define __SC_STR_ADECL3(t, a, ...)	#a, __SC_STR_ADECL2(__VA_ARGS__)
@@ -112,6 +120,8 @@ struct perf_counter_hw_event;
 #define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
 #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+
 #define SYSCALL_METADATA(sname, nb)				\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
@@ -188,7 +198,26 @@ struct perf_counter_hw_event;
 	SYSCALL_ALIAS(sys##name, SyS##name);				\
 	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
 
-#else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
+#elif defined(CONFIG_TRACEPOINTS)
+
+#define SYSCALL_DEFINE(name) asmlinkage long sys_##name
+
+#define __SYSCALL_DEFINEx(x, name, ...)                                 \
+	DEFINE_TRACE(sysenter##name);					\
+	DEFINE_TRACE(sysexit##name);					\
+        asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__));           \
+        static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__));       \
+        asmlinkage long SyS##name(__SC_LONG##x(__VA_ARGS__))            \
+        {                                                               \
+		long ret;						\
+		trace_sysenter##name(__SC_CAST##x(__VA_ARGS__));       \
+                ret = (long) SYSC##name(__SC_CAST##x(__VA_ARGS__));    \
+		trace_sysexit##name(ret);				\
+		return ret;						\
+        }                                                               \
+        SYSCALL_ALIAS(sys##name, SyS##name);                            \
+        static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
+#else
 
 #define SYSCALL_DEFINE(name) asmlinkage long sys_##name
 #define __SYSCALL_DEFINEx(x, name, ...)					\
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f7a7ae1..76e93bf 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -26,10 +26,6 @@
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
 	DEFINE_TRACE(name)
 
-#undef DECLARE_TRACE
-#define DECLARE_TRACE(name, proto, args)	\
-	DEFINE_TRACE(name)
-
 #undef TRACE_INCLUDE
 #undef __TRACE_INCLUDE
 
diff --git a/include/trace/syscalls.h b/include/trace/syscalls.h
new file mode 100644
index 0000000..5315603
--- /dev/null
+++ b/include/trace/syscalls.h
@@ -0,0 +1,2747 @@
+#ifndef _TRACE_SYSCALLS_H
+#define _TRACE_SYSCALLS_H
+
+#include <linux/tracepoint.h>
+
+
+#ifdef CONFIG_TRACEPOINTS
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
+DECLARE_TRACE(sysenter_time,
+		TP_PROTO(time_t __user *tloc),
+		TP_ARGS(tloc));
+
+DECLARE_TRACE(sysenter_stime,
+		TP_PROTO(time_t __user *tptr),
+		TP_ARGS(tptr));
+
+DECLARE_TRACE(sysenter_gettimeofday,
+		TP_PROTO(struct timeval __user *tv, struct timezone __user *tz),
+		TP_ARGS(tv, tz));
+
+DECLARE_TRACE(sysenter_settimeofday,
+		TP_PROTO(struct timeval __user *tv, struct timezone __user *tz),
+		TP_ARGS(tv, tz));
+
+DECLARE_TRACE(sysenter_adjtimex,
+		TP_PROTO(struct timex __user *txc_p),
+		TP_ARGS(txc_p));
+
+DECLARE_TRACE(sysenter_times,
+		TP_PROTO(struct tms __user *tbuf),
+		TP_ARGS(tbuf));
+
+DECLARE_TRACE(sysenter_gettid,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_nanosleep,
+		TP_PROTO(struct timespec __user *rqtp, struct timespec __user *rmtp),
+		TP_ARGS(rqtp, rmtp));
+
+DECLARE_TRACE(sysenter_alarm,
+		TP_PROTO(unsigned int seconds),
+		TP_ARGS(seconds));
+
+DECLARE_TRACE(sysenter_getpid,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_getppid,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_getuid,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_geteuid,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_getgid,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_getegid,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_getresuid,
+		TP_PROTO(uid_t __user *ruid, uid_t __user *euid, uid_t __user *suid),
+		TP_ARGS(ruid, euid, suid));
+
+DECLARE_TRACE(sysenter_getresgid,
+		TP_PROTO(gid_t __user *rgid, gid_t __user *egid, gid_t __user *sgid),
+		TP_ARGS(rgid, egid, sgid));
+
+DECLARE_TRACE(sysenter_getpgid,
+		TP_PROTO(pid_t pid),
+		TP_ARGS(pid));
+
+DECLARE_TRACE(sysenter_getpgrp,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_getsid,
+		TP_PROTO(pid_t pid),
+		TP_ARGS(pid));
+
+DECLARE_TRACE(sysenter_getgroups,
+		TP_PROTO(int gidsetsize, gid_t __user *grouplist),
+		TP_ARGS(gidsetsize, grouplist));
+
+DECLARE_TRACE(sysenter_setregid,
+		TP_PROTO(gid_t rgid, gid_t egid),
+		TP_ARGS(rgid, egid));
+
+DECLARE_TRACE(sysenter_setgid,
+		TP_PROTO(gid_t gid),
+		TP_ARGS(gid));
+
+DECLARE_TRACE(sysenter_setreuid,
+		TP_PROTO(uid_t ruid, uid_t euid),
+		TP_ARGS(ruid, euid));
+
+DECLARE_TRACE(sysenter_setuid,
+		TP_PROTO(uid_t uid),
+		TP_ARGS(uid));
+
+DECLARE_TRACE(sysenter_setresuid,
+		TP_PROTO(uid_t ruid, uid_t euid, uid_t suid),
+		TP_ARGS(ruid, euid, suid));
+
+DECLARE_TRACE(sysenter_setresgid,
+		TP_PROTO(gid_t rgid, gid_t egid, gid_t sgid),
+		TP_ARGS(rgid, egid, sgid));
+
+DECLARE_TRACE(sysenter_setfsuid,
+		TP_PROTO(uid_t uid),
+		TP_ARGS(uid));
+
+DECLARE_TRACE(sysenter_setfsgid,
+		TP_PROTO(gid_t gid),
+		TP_ARGS(gid));
+
+DECLARE_TRACE(sysenter_setpgid,
+		TP_PROTO(pid_t pid, pid_t pgid),
+		TP_ARGS(pid, pgid));
+
+DECLARE_TRACE(sysenter_setsid,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_setgroups,
+		TP_PROTO(int gidsetsize, gid_t __user *grouplist),
+		TP_ARGS(gidsetsize, grouplist));
+
+DECLARE_TRACE(sysenter_acct,
+		TP_PROTO(const char __user *name),
+		TP_ARGS(name));
+
+DECLARE_TRACE(sysenter_capget,
+		TP_PROTO(cap_user_header_t header, cap_user_data_t dataptr),
+		TP_ARGS(header, dataptr));
+
+DECLARE_TRACE(sysenter_capset,
+		TP_PROTO(cap_user_header_t header, const cap_user_data_t data),
+		TP_ARGS(header, data));
+
+DECLARE_TRACE(sysenter_personality,
+		TP_PROTO(u_long personality),
+		TP_ARGS(personality));
+
+DECLARE_TRACE(sysenter_sigpending,
+		TP_PROTO(old_sigset_t __user *set),
+		TP_ARGS(set));
+
+DECLARE_TRACE(sysenter_sigprocmask,
+		TP_PROTO(int how, old_sigset_t __user *set, old_sigset_t __user *oset),
+		TP_ARGS(how, set, oset));
+
+DECLARE_TRACE(sysenter_getitimer,
+		TP_PROTO(int which, struct itimerval __user *value),
+		TP_ARGS(which, value));
+
+DECLARE_TRACE(sysenter_setitimer,
+		TP_PROTO(int which, struct itimerval __user *value, struct itimerval __user *ovalue),
+		TP_ARGS(which, value, ovalue));
+
+DECLARE_TRACE(sysenter_timer_create,
+		TP_PROTO(clockid_t which_clock, struct sigevent __user *timer_event_spec, timer_t __user * created_timer_id),
+		TP_ARGS(which_clock, timer_event_spec, created_timer_id));
+
+DECLARE_TRACE(sysenter_timer_gettime,
+		TP_PROTO(timer_t timer_id, struct itimerspec __user *setting),
+		TP_ARGS(timer_id, setting));
+
+DECLARE_TRACE(sysenter_timer_getoverrun,
+		TP_PROTO(timer_t timer_id),
+		TP_ARGS(timer_id));
+
+DECLARE_TRACE(sysenter_timer_settime,
+		TP_PROTO(timer_t timer_id, int flags, const struct itimerspec __user *new_setting, struct itimerspec __user *old_setting),
+		TP_ARGS(timer_id, flags, new_setting, old_setting));
+
+DECLARE_TRACE(sysenter_timer_delete,
+		TP_PROTO(timer_t timer_id),
+		TP_ARGS(timer_id));
+
+DECLARE_TRACE(sysenter_clock_settime,
+		TP_PROTO(clockid_t which_clock, const struct timespec __user *tp),
+		TP_ARGS(which_clock, tp));
+
+DECLARE_TRACE(sysenter_clock_gettime,
+		TP_PROTO(clockid_t which_clock, struct timespec __user *tp),
+		TP_ARGS(which_clock, tp));
+
+DECLARE_TRACE(sysenter_clock_getres,
+		TP_PROTO(clockid_t which_clock, struct timespec __user *tp),
+		TP_ARGS(which_clock, tp));
+
+DECLARE_TRACE(sysenter_clock_nanosleep,
+		TP_PROTO(clockid_t which_clock, int flags, const struct timespec __user *rqtp, struct timespec __user *rmtp),
+		TP_ARGS(which_clock, flags, rqtp, rmtp));
+
+DECLARE_TRACE(sysenter_nice,
+		TP_PROTO(int increment),
+		TP_ARGS(increment));
+
+DECLARE_TRACE(sysenter_sched_setscheduler,
+		TP_PROTO(pid_t pid, int policy, struct sched_param __user *param),
+		TP_ARGS(pid, policy, param));
+
+DECLARE_TRACE(sysenter_sched_setparam,
+		TP_PROTO(pid_t pid, struct sched_param __user *param),
+		TP_ARGS(pid, param));
+
+DECLARE_TRACE(sysenter_sched_getscheduler,
+		TP_PROTO(pid_t pid),
+		TP_ARGS(pid));
+
+DECLARE_TRACE(sysenter_sched_getparam,
+		TP_PROTO(pid_t pid, struct sched_param __user *param),
+		TP_ARGS(pid, param));
+
+DECLARE_TRACE(sysenter_sched_setaffinity,
+		TP_PROTO(pid_t pid, unsigned int len, unsigned long __user *user_mask_ptr),
+		TP_ARGS(pid, len, user_mask_ptr));
+
+DECLARE_TRACE(sysenter_sched_getaffinity,
+		TP_PROTO(pid_t pid, unsigned int len, unsigned long __user *user_mask_ptr),
+		TP_ARGS(pid, len, user_mask_ptr));
+
+DECLARE_TRACE(sysenter_sched_yield,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_sched_get_priority_max,
+		TP_PROTO(int policy),
+		TP_ARGS(policy));
+
+DECLARE_TRACE(sysenter_sched_get_priority_min,
+		TP_PROTO(int policy),
+		TP_ARGS(policy));
+
+DECLARE_TRACE(sysenter_sched_rr_get_interval,
+		TP_PROTO(pid_t pid, struct timespec __user *interval),
+		TP_ARGS(pid, interval));
+
+DECLARE_TRACE(sysenter_setpriority,
+		TP_PROTO(int which, int who, int niceval),
+		TP_ARGS(which, who, niceval));
+
+DECLARE_TRACE(sysenter_getpriority,
+		TP_PROTO(int which, int who),
+		TP_ARGS(which, who));
+
+DECLARE_TRACE(sysenter_shutdown,
+		TP_PROTO(int a, int b),
+		TP_ARGS(a, b));
+
+DECLARE_TRACE(sysenter_reboot,
+		TP_PROTO(int magic1, int magic2, unsigned int cmd, void __user *arg),
+		TP_ARGS(magic1, magic2, cmd, arg));
+
+DECLARE_TRACE(sysenter_restart_syscall,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_kexec_load,
+		TP_PROTO(unsigned long entry, unsigned long nr_segments, struct kexec_segment __user *segments, unsigned long flags),
+		TP_ARGS(entry, nr_segments, segments, flags));
+
+DECLARE_TRACE(sysenter_exit,
+		TP_ARGS(int error_code),
+		TP_PROTO(error_code));
+
+DECLARE_TRACE(sysenter_exit_group,
+		TP_ARGS(int error_code),
+		TP_PROTO(error_code));
+
+DECLARE_TRACE(sysenter_wait4,
+		TP_ARGS(pid_t pid, int __user *stat_addr, int options, struct rusage __user *ru),
+		TP_PROTO(pid, stat_addr, options, ru));
+
+DECLARE_TRACE(sysenter_waitid,
+		TP_PROTO(int which, pid_t pid, struct siginfo __user *infop, int options, struct rusage __user *ru),
+		TP_ARGS(which, pid, infop, options, ru));
+
+DECLARE_TRACE(sysenter_waitpid,
+		TP_PROTO(pid_t pid, int __user *stat_addr, int options),
+		TP_ARGS(pid, stat_addr, options));
+
+DECLARE_TRACE(sysenter_set_tid_address,
+		TP_PROTO(int __user *tidptr),
+		TP_ARGS(tidptr));
+
+DECLARE_TRACE(sysenter_futex,
+		TP_PROTO(u32 __user *uaddr, int op, u32 val, struct timespec __user *utime, u32 __user *uaddr2, u32 val3),
+		TP_ARGS(uaddr, op, val, utime, uaddr2, val3));
+
+DECLARE_TRACE(sysenter_init_module,
+		TP_PROTO(void __user *umod, unsigned long len, const char __user *uargs),
+		TP_ARGS(umod, len, uargs));
+
+DECLARE_TRACE(sysenter_delete_module,
+		TP_PROTO(const char __user *name_user, unsigned int flags),
+		TP_ARGS(name_user, flags));
+
+DECLARE_TRACE(sysenter_rt_sigprocmask,
+		TP_PROTO(int how, sigset_t __user *set, sigset_t __user *oset, size_t sigsetsize),
+		TP_ARGS(how, set, oset, sigsetsize));
+
+DECLARE_TRACE(sysenter_rt_sigpending,
+		TP_PROTO(sigset_t __user *set, size_t sigsetsize),
+		TP_ARGS(set, sigsetsize));
+
+DECLARE_TRACE(sysenter_rt_sigtimedwait,
+		TP_PROTO(const sigset_t __user *uthese, siginfo_t __user *uinfo, const struct timespec __user *uts, size_t sigsetsize),
+		TP_ARGS(uthese, uinfo, uts, sigsetsize));
+
+DECLARE_TRACE(sysenter_kill,
+		TP_PROTO(int pid, int sig),
+		TP_ARGS(pid, sig));
+
+DECLARE_TRACE(sysenter_tgkill,
+		TP_PROTO(int tgid, int pid, int sig),
+		TP_ARGS(tgid, pid, sig));
+
+DECLARE_TRACE(sysenter_tkill,
+		TP_PROTO(int pid, int sig),
+		TP_ARGS(pid, sig));
+
+DECLARE_TRACE(sysenter_rt_sigqueueinfo,
+		TP_PROTO(int pid, int sig, siginfo_t __user *uinfo),
+		TP_ARGS(pid, sig, uinfo));
+
+DECLARE_TRACE(sysenter_sgetmask,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_ssetmask,
+		TP_PROTO(int newmask),
+		TP_ARGS(newmask));
+
+DECLARE_TRACE(sysenter_signal,
+		TP_PROTO(int sig, __sighandler_t handler),
+		TP_ARGS(sig, handler));
+
+DECLARE_TRACE(sysenter_pause,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_sync,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_fsync,
+		TP_PROTO(unsigned int fd),
+		TP_ARGS(fd));
+
+DECLARE_TRACE(sysenter_fdatasync,
+		TP_PROTO(unsigned int fd),
+		TP_ARGS(fd));
+
+DECLARE_TRACE(sysenter_bdflush,
+		TP_PROTO(int func, long data),
+		TP_ARGS(func, data));
+
+DECLARE_TRACE(sysenter_mount,
+		TP_PROTO(char __user *dev_name, char __user *dir_name, char __user *type, unsigned long flags, void __user *data),
+		TP_ARGS(dev_name, dir_name, type, flags, data));		
+
+DECLARE_TRACE(sysenter_umount,
+		TP_PROTO(char __user *name, int flags),
+		TP_ARGS(name, flags));
+
+DECLARE_TRACE(sysenter_oldumount,
+		TP_PROTO(char __user *name),
+		TP_ARGS(name));
+
+DECLARE_TRACE(sysenter_truncate,
+		TP_PROTO(const char __user *path, unsigned long length),
+		TP_ARGS(path, length));
+
+DECLARE_TRACE(sysenter_ftruncate,
+		TP_PROTO(unsigned int fd, unsigned long length),
+		TP_ARGS(fd, length));
+
+DECLARE_TRACE(sysenter_stat,
+		TP_PROTO(char __user *filename, struct __old_kernel_stat __user *statbuf),
+		TP_ARGS(filename, statbuf));
+
+DECLARE_TRACE(sysenter_statfs,
+		TP_PROTO(const char __user * path, struct statfs __user *buf),
+		TP_ARGS(path, buf));
+
+DECLARE_TRACE(sysenter_statfs64,
+		TP_PROTO(const char __user *path, size_t sz, struct statfs64 __user *buf),
+		TP_ARGS(path, sz, buf));
+
+DECLARE_TRACE(sysenter_fstatfs,
+		TP_PROTO(unsigned int fd, struct statfs __user *buf),
+		TP_ARGS(fd, buf));
+
+DECLARE_TRACE(sysenter_fstatfs64,
+		TP_PROTO(unsigned int fd, size_t sz, struct statfs64 __user *buf),
+		TP_ARGS(fd, sz, buf));
+
+DECLARE_TRACE(sysenter_lstat,
+		TP_PROTO(char __user *filename, struct __old_kernel_stat __user *statbuf),
+		TP_ARGS(filename, statbuf));
+
+DECLARE_TRACE(sysenter_fstat,
+		TP_PROTO(unsigned int fd, struct __old_kernel_stat __user *statbuf),
+		TP_ARGS(fd, statbuf));
+
+DECLARE_TRACE(sysenter_newstat,
+		TP_PROTO(char __user *filename, struct stat __user *statbuf),
+		TP_ARGS(filename, statbuf));
+
+DECLARE_TRACE(sysenter_newlstat,
+		TP_PROTO(char __user *filename, struct stat __user *statbuf),
+		TP_ARGS(filename, statbuf));
+
+DECLARE_TRACE(sysenter_newfstat,
+		TP_PROTO(unsigned int fd, struct stat __user *statbuf),
+		TP_ARGS(fd, statbuf));
+
+DECLARE_TRACE(sysenter_ustat,
+		TP_PROTO(unsigned dev, struct ustat __user *ubuf),
+		TP_ARGS(dev, ubuf));
+
+#if BITS_PER_LONG == 32
+DECLARE_TRACE(sysenter_stat64,
+		TP_PROTO(char __user *filename, struct stat64 __user *statbuf),
+		TP_ARGS(filename, statbuf));
+
+DECLARE_TRACE(sysenter_fstat64,
+		TP_PROTO(unsigned long fd, struct stat64 __user *statbuf),
+		TP_ARGS(fd, statbuf));
+
+DECLARE_TRACE(sysenter_lstat64,
+		TP_PROTO(char __user *filename, struct stat64 __user *statbuf),
+		TP_ARGS(filename, statbuf));
+
+DECLARE_TRACE(sysenter_truncate64,
+		TP_PROTO(const char __user *path, loff_t length),
+		TP_ARGS(path, length));
+
+DECLARE_TRACE(sysenter_ftruncate64,
+		TP_PROTO(unsigned int fd, loff_t length),
+		TPP_ARGS(fd, length));
+#endif
+
+DECLARE_TRACE(sysenter_setxattr,
+		TP_PROTO(const char __user *path, const char __user *name, const void __user *value, size_t size, int flags),
+		TP_ARGS(path, name, value, size, flags));
+
+DECLARE_TRACE(sysenter_lsetxattr,
+		TP_PROTO(const char __user *path, const char __user *name, const void __user *value, size_t size, int flags),
+		TP_ARGS(path, name, value, size, flags));
+
+DECLARE_TRACE(sysenter_fsetxattr,
+		TP_PROTO(int fd, const char __user *name, const void __user *value, size_t size, int flags),
+		TP_ARGS(fd, name, value, size, flags));
+
+DECLARE_TRACE(sysenter_getxattr,
+		TP_PROTO(const char __user *path, const char __user *name, void __user *value, size_t size),
+		TP_ARGS(path, name, value, size));
+
+DECLARE_TRACE(sysenter_lgetxattr,
+		TP_PROTO(const char __user *path, const char __user *name, void __user *value, size_t size),
+		TP_ARGS(path, name, value, size));
+
+DECLARE_TRACE(sysenter_fgetxattr,
+		TP_PROTO(int fd, const char __user *name, void __user *value, size_t size),
+		TP_ARGS(fd, name, value, size));
+
+DECLARE_TRACE(sysenter_listxattr,
+		TP_PROTO(const char __user *path, char __user *list, size_t size),
+		TP_ARGS(path, list, size));
+
+DECLARE_TRACE(sysenter_llistxattr,
+		TP_PROTO(const char __user *path, char __user *list, size_t size),
+		TP_ARGS(path, list, size));
+
+DECLARE_TRACE(sysenter_flistxattr,
+		TP_PROTO(int fd, char __user *list, size_t size),
+		TP_ARGS(fd, list, size));
+
+DECLARE_TRACE(sysenter_removexattr,
+		TP_PROTO(const char __user *path, const char __user *name),
+		TP_ARGS(path, name));
+
+DECLARE_TRACE(sysenter_lremovexattr,
+		TP_PROTO(const char __user *path, const char __user *name),
+		TP_ARGS(path, name));
+
+DECLARE_TRACE(sysenter_fremovexattr,
+		TP_PROTO(int fd, const char __user *name),
+		TP_ARGS(fd, name));
+
+DECLARE_TRACE(sysenter_brk,
+		TP_PROTO(unsigned long brk),
+		TP_ARGS(brk));
+
+DECLARE_TRACE(sysenter_mprotect,
+		TP_PROTO(unsigned long start, size_t len, unsigned long prot),
+		TP_ARGS(start, len, prot));
+
+DECLARE_TRACE(sysenter_mremap,
+		TP_PROTO(unsigned long addr, unsigned long old_len, unsigned long new_len, unsigned long flags, unsigned long new_addr),
+		TP_ARGS(addr, old_len, new_len, flags, new_addr));
+
+DECLARE_TRACE(sysenter_remap_file_pages,
+		TP_PROTO(unsigned long start, unsigned long size, unsigned long prot, unsigned long pgoff, unsigned long flags),
+		TP_ARGS(start, size, prot, pgoff, flags));		
+
+DECLARE_TRACE(sysenter_msync,
+		TP_PROTO(unsigned long start, size_t len, int flags),
+		TP_ARGS(start, len, flags));
+
+DECLARE_TRACE(sysenter_fadvise64,
+		TP_PROTO(int fd, loff_t offset, size_t len, int advice),
+		TP_ARGS(fd, offset, len, advice));
+
+DECLARE_TRACE(sysenter_fadvise64_64,
+		TP_PROTO(int fd, loff_t offset, loff_t len, int advice),
+		TP_ARGS(fd, offset, len, advice));
+
+DECLARE_TRACE(sysenter_munmap,
+		TP_PROTO(unsigned long addr, size_t len),
+		TP_ARGS(addr, len));
+
+DECLARE_TRACE(sysenter_mlock,
+		TP_PROTO(unsigned long start, size_t len),
+		TP_ARGS(start, len));
+
+DECLARE_TRACE(sysenter_munlock,
+		TP_PROTO(unsigned long start, size_t len),
+		TP_ARGS(start, len));
+
+DECLARE_TRACE(sysenter_mlockall,
+		TP_PROTO(int flags),
+		TP_ARGS(flags));
+
+DECLARE_TRACE(sysenter_munlockall,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_madvise,
+		TP_PROTO(unsigned long start, size_t len, int behavior),
+		TP_ARGS(start, len, behavior));
+
+DECLARE_TRACE(sysenter_mincore,
+		TP_PROTO(unsigned long start, size_t len, unsigned char __user * vec),
+		TP_ARGS(start, len, vec));
+
+DECLARE_TRACE(sysenter_pivot_root,
+		TP_PROTO(const char __user *new_root, const char __user *put_old),
+		TP_ARGS(new_root, put_old));
+
+DECLARE_TRACE(sysenter_chroot,
+		TP_PROTO(const char __user *filename),
+		TP_ARGS(filename));
+
+DECLARE_TRACE(sysenter_mknod,
+		TP_PROTO(const char __user *filename, int mode, unsigned dev),
+		TP_ARGS(filename, mode, dev));
+
+DECLARE_TRACE(sysenter_link,
+		TP_PROTO(const char __user *oldname, const char __user *newname),
+		TP_ARGS(oldname, newname));
+
+DECLARE_TRACE(sysenter_symlink,
+		TP_PROTO(const char __user *old, const char __user *new),
+		TP_ARGS(old, new));
+
+DECLARE_TRACE(sysenter_unlink,
+		TP_PROTO(const char __user *pathname),
+		TP_ARGS(pathname));
+
+DECLARE_TRACE(sysenter_rename,
+		TP_PROTO(const char __user *oldname, const char __user *newname),
+		TP_ARGS(oldname, newname));
+
+DECLARE_TRACE(sysenter_chmod,
+		TP_PROTO(const char __user *filename, mode_t mode),
+		TP_ARGS(filename, mode));
+
+DECLARE_TRACE(sysenter_fchmod,
+		TP_PROTO(unsigned int fd, mode_t mode),
+		TP_ARGS(fd, mode));
+
+DECLARE_TRACE(sysenter_fcntl,
+		TP_PROTO(unsigned int fd, unsigned int cmd, unsigned long arg),
+		TP_ARGS(fd, cmd, arg));
+
+#if BITS_PER_LONG == 32
+DECLARE_TRACE(sysenter_fcntl64,
+		TP_PROTO(unsigned int fd, unsigned int cmd, unsigned long arg),
+		TP_ARGS(fd, cmd, arg));
+#endif
+DECLARE_TRACE(sysenter_dup,
+		TP_PROTO(unsigned int fildes),
+		TP_ARGS(fildes));
+
+DECLARE_TRACE(sysenter_dup2,
+		TP_PROTO(unsigned int oldfd, unsigned int newfd),
+		TP_ARGS(oldfd, newfd));
+
+DECLARE_TRACE(sysenter_dup3,
+		TP_PROTO(unsigned int oldfd, unsigned int newfd, int flags),
+		TP_ARGS(oldfd, newfd, flags));
+
+DECLARE_TRACE(sysenter_ioperm,
+		TP_PROTO(unsigned long from, unsigned long num, int on),
+		TP_ARGS(from, num, on));
+
+DECLARE_TRACE(sysenter_ioctl,
+		TP_PROTO(unsigned int fd, unsigned int cmd, unsigned long arg),
+		TP_ARGS(fd, cmd, arg));
+
+DECLARE_TRACE(sysenter_flock,
+		TP_PROTO(unsigned int fd, unsigned int cmd),
+		TP_ARGS(fd, cmd));
+
+DECLARE_TRACE(sysenter_io_setup,
+		TP_PROTO(unsigned nr_reqs, aio_context_t __user *ctx),
+		TP_ARGS(nr_reqs, ctx));
+
+DECLARE_TRACE(sysenter_io_destroy,
+		TP_PROTO(aio_context_t ctx),
+		TP_ARGS(ctx));
+
+DECLARE_TRACE(sysenter_io_getevents,
+		TP_PROTO(aio_context_t ctx_id, long min_nr, long nr, struct io_event __user *events, struct timespec __user *timeout),
+		TP_ARGS(ctx_id, min_nr, nr, events, timeout));
+
+DECLARE_TRACE(sysenter_io_submit,
+		TP_PROTO(aio_context_t ctx_id, long nr, struct iocb __user * __user * iocbpp),
+		TP_ARGS(ctx_id, nr, iocbpp));
+
+DECLARE_TRACE(sysenter_io_cancel,
+		TP_PROTO(aio_context_t ctx_id, struct iocb __user *iocb, struct io_event __user *result),
+		TP_ARGS(ctx_id, iocb, result));
+
+DECLARE_TRACE(sysenter_sendfile,
+		TP_PROTO(int out_fd, int in_fd, off_t __user *offset, size_t count),
+		TP_ARGS(out_fd, in_fd, offset, count));
+
+DECLARE_TRACE(sysenter_sendfile64,
+		TP_PROTO(int out_fd, int in_fd, loff_t __user *offset, size_t count),
+		TP_ARGS(out_fd, in_fd, offset, count));
+
+DECLARE_TRACE(sysenter_readlink,
+		TP_PROTO(const char __user *path, char __user *buf, int bufsiz),
+		TP_ARGS(path, buf, bufsiz));
+
+DECLARE_TRACE(sysenter_creat,
+		TP_PROTO(const char __user *pathname, int mode),
+		TP_ARGS(pathname, mode));
+
+DECLARE_TRACE(sysenter_open,
+		TP_PROTO(const char __user *filename, int flags, int mode),
+		TP_ARGS(filename, flags, mode));
+
+DECLARE_TRACE(sysenter_close,
+		TP_PROTO(unsigned int fd),
+		TP_ARGS(fd));
+
+DECLARE_TRACE(sysenter_access,
+		TP_PROTO(const char __user *filename, int mode),
+		TP_ARGS(filename, mode));
+
+DECLARE_TRACE(sysenter_vhangup,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_chown,
+		TP_PROTO(const char __user *filename, uid_t user, gid_t group),
+		TP_ARGS(filename, user, group));
+
+DECLARE_TRACE(sysenter_lchown,
+		TP_PROTO(const char __user *filename, uid_t user, gid_t group),
+		TP_ARGS(filename, user, group));
+
+DECLARE_TRACE(sysenter_fchown,
+		TP_PROTO(unsigned int fd, uid_t user, gid_t group),
+		TP_ARGS(fd, user, group));
+
+#ifdef CONFIG_UID16
+DECLARE_TRACE(sysenter_chown16,
+		TP_PROTO(const char __user *filename, old_uid_t user, old_gid_t group),
+		TP_ARGS(filename, user, group));
+
+DECLARE_TRACE(sysenter_lchown16,
+		TP_PROTO(const char __user *filename, old_uid_t user, old_gid_t group),
+		TP_ARGS(filename, user, group));
+
+DECLARE_TRACE(sysenter_fchown16,
+		TP_PROTO(unsigned int fd, old_uid_t user, old_gid_t group),
+		TP_ARGS(fd, user, group));
+
+DECLARE_TRACE(sysenter_setregid16,
+		TP_PROTO(old_gid_t rgid, old_gid_t egid),
+		TP_ARGS(rgid, egid));
+
+DECLARE_TRACE(sysenter_setgid16,
+		TP_PROTO(old_gid_t gid),
+		TP_ARGS(gid));
+
+DECLARE_TRACE(sysenter_setreuid16,
+		TP_PROTO(old_uid_t ruid, old_uid_t euid),
+		TP_ARGS(ruid, euid));
+
+DECLARE_TRACE(sysenter_setuid16,
+		TP_PROTO(old_uid_t uid),
+		TP_ARGS(uid));
+
+DECLARE_TRACE(sysenter_setresuid16,
+		TP_PROTO(old_uid_t ruid, old_uid_t euid, old_uid_t suid),
+		TP_ARGS(ruid, euid, suid));
+
+DECLARE_TRACE(sysenter_getresuid16,
+		TP_PROTO(old_uid_t __user *ruid, old_uid_t __user *euid, old_uid_t __user *suid),
+		TP_ARGS(ruid, euid, suid));
+
+DECLARE_TRACE(sysenter_setresgid16,
+		TP_PROTO(old_gid_t rgid, old_gid_t egid, old_gid_t sgid),
+		TP_ARGS(rgid, egid, sgid));
+
+DECLARE_TRACE(sysenter_getresgid16,
+		TP_PROTO(old_gid_t __user *rgid, old_gid_t __user *egid, old_gid_t __user *sgid),
+		TP_ARGS(rgid, egid, sgid));
+
+DECLARE_TRACE(sysenter_setfsuid16,
+		TP_PROTO(old_uid_t uid),
+		TP_ARGS(uid));
+
+DECLARE_TRACE(sysenter_setfsgid16,
+		TP_PROTO(old_gid_t gid),
+		TP_ARGS(gid));
+
+DECLARE_TRACE(sysenter_getgroups16,
+		TP_PROTO(int gidsetsize, old_gid_t __user *grouplist),
+		TP_ARGS(gidsetsize, grouplist));
+
+DECLARE_TRACE(sysenter_setgroups16,
+		TP_PROTO(int gidsetsize, old_gid_t __user *grouplist),
+		TP_ARGS(gidsetsize, grouplist));
+
+DECLARE_TRACE(sysenter_getuid16,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_geteuid16,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_getgid16,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_getegid16,
+		TP_PROTO(void),
+		TP_ARGS());
+#endif
+
+DECLARE_TRACE(sysenter_utime,
+		TP_PROTO(char __user *filename, struct utimbuf __user *times),
+		TP_ARGS(filename, times));
+
+DECLARE_TRACE(sysenter_utimes,
+		TP_PROTO(char __user *filename, struct timeval __user *utimes),
+		TP_ARGS(filename, utimes));
+
+DECLARE_TRACE(sysenter_lseek,
+		TP_PROTO(unsigned int fd, off_t offset, unsigned int origin),
+		TP_ARGS(fd, offset, origin));
+
+DECLARE_TRACE(sysenter_llseek,
+		TP_PROTO(unsigned int fd, unsigned long offset_high, unsigned long offset_low, loff_t __user *result, unsigned int origin),
+		TP_ARGS(fd, offset_high, offset_low, result, origin));
+
+DECLARE_TRACE(sysenter_read,
+		TP_PROTO(unsigned int fd, char __user *buf, size_t count),
+		TP_ARGS(fd, buf, count));
+
+DECLARE_TRACE(sysenter_readahead,
+		TP_PROTO(int fd, loff_t offset, size_t count),
+		TP_ARGS(fd, offset, count));
+
+DECLARE_TRACE(sysenter_readv,
+		TP_PROTO(unsigned long fd, const struct iovec __user *vec, unsigned long vlen),
+		TP_ARGS(fd, vec, vlen));
+
+DECLARE_TRACE(sysenter_write,
+		TP_PROTO(unsigned int fd, const char __user *buf, size_t count),
+		TP_ARGS(fd, buf, count));
+
+DECLARE_TRACE(sysenter_writev,
+		TP_PROTO(unsigned long fd, const struct iovec __user *vec, unsigned long vlen),
+		TP_ARGS(fd, vec, vlen));
+
+DECLARE_TRACE(sysenter_pread64,
+		TP_PROTO(unsigned int fd, char __user *buf, size_t count, loff_t pos),
+		TP_ARGS(fd, buf, count, pos));
+
+DECLARE_TRACE(sysenter_pwrite64,
+		TP_PROTO(unsigned int fd, const char __user *buf, size_t count, loff_t pos),
+		TP_ARGS(fd, buf, count, pos));
+
+DECLARE_TRACE(sysenter_preadv,
+		TP_PROTO(unsigned long fd, const struct iovec __user *vec, unsigned long vlen, unsigned long pos_l, unsigned long pos_h),
+		TP_ARGS(fd, vec, vlen, pos_l, pos_h));
+
+DECLARE_TRACE(sysenter_pwritev,
+		TP_PROTO(unsigned long fd, const struct iovec __user *vec, unsigned long vlen, unsigned long pos_l, unsigned long pos_h),
+		TP_ARGS(fd, vec, vlen, pos_l, pos_h));
+
+DECLARE_TRACE(sysenter_getcwd,
+		TP_PROTO(char __user *buf, unsigned long size),
+		TP_ARGS(buf, size));
+
+DECLARE_TRACE(sysenter_mkdir,
+		TP_PROTO(const char __user *pathname, int mode),
+		TP_ARGS(pathname, mode));
+
+DECLARE_TRACE(sysenter_chdir,
+		TP_PROTO(const char __user *filename),
+		TP_ARGS(filename));
+
+DECLARE_TRACE(sysenter_fchdir,
+		TP_PROTO(unsigned int fd),
+		TP_ARGS(fd));
+
+DECLARE_TRACE(sysenter_rmdir,
+		TP_PROTO(const char __user *pathname),
+		TP_ARGS(pathname));
+
+DECLARE_TRACE(sysenter_lookup_dcookie,
+		TP_PROTO(u64 cookie64, char __user *buf, size_t len),
+		TP_ARGS(cookie64, buf, len));
+
+DECLARE_TRACE(sysenter_quotactl,
+		TP_PROTO(unsigned int cmd, const char __user *special, qid_t id, void __user *addr),
+		TP_ARGS(cmd, special, id, addr));
+
+DECLARE_TRACE(sysenter_getdents,
+		TP_PROTO(unsigned int fd, struct linux_dirent __user *dirent, unsigned int count),
+		TP_ARGS(fd, dirent, count));
+
+DECLARE_TRACE(sysenter_getdents64,
+		TP_PROTO(unsigned int fd, struct linux_dirent64 __user *dirent, unsigned int count),
+		TP_ARGS(fd, dirent, count));
+
+DECLARE_TRACE(sysenter_setsockopt,
+		TP_PROTO(int fd, int level, int optname, char __user *optval, int optlen),
+		TP_ARGS(fd, level, optname, optval, optlen));
+
+DECLARE_TRACE(sysenter_getsockopt,
+		TP_PROTO(int fd, int level, int optname, char __user *optval, int __user *optlen),
+		TP_ARGS(fd, level, optname, optval, optlen));
+
+DECLARE_TRACE(sysenter_bind,
+		TP_PROTO(int a, struct sockaddr __user * saddr, int b),
+		TP_ARGS(a, saddr, b));
+
+DECLARE_TRACE(sysenter_connect,
+		TP_PROTO(int a, struct sockaddr __user * saddr, int b),
+		TP_ARGS(a, saddr, b));
+
+DECLARE_TRACE(sysenter_accept,
+		TP_PROTO(int a, struct sockaddr __user * saddr, int __user * uptr),
+		TP_ARGS(a, saddr, uptr));
+
+DECLARE_TRACE(sysenter_accept4,
+		TP_PROTO(int a, struct sockaddr __user *saddr, int __user * uptr, int b),
+		TP_ARGS(a, saddr, uptr, b));
+
+DECLARE_TRACE(sysenter_getsockname,
+		TP_PROTO(int a, struct sockaddr __user *saddr, int __user * uptr),
+		TP_ARGS(a, saddr, uptr));
+
+DECLARE_TRACE(sysenter_getpeername,
+		TP_PROTO(int a, struct sockaddr __user * saddr, int __user * uptr),
+		TP_ARGS(a, saddr, uptr));
+
+DECLARE_TRACE(sysenter_send,
+		TP_PROTO(int a, void __user * uptr, size_t size, unsigned len),
+		TP_ARGS(a, uptr, size, len));
+
+DECLARE_TRACE(sysenter_sendto,
+		TP_PROTO(int a, void __user * uptr, size_t size, unsigned len, struct sockaddr __user * saddr, int b),
+		TP_ARGS(a, uptr, size, len, saddr, b));
+
+DECLARE_TRACE(sysenter_sendmsg,
+		TP_PROTO(int fd, struct msghdr __user *msg, unsigned flags),
+		TP_ARGS(fd, msg, flags));
+
+DECLARE_TRACE(sysenter_recv,
+		TP_PROTO(int a, void __user * uptr, size_t size, unsigned b),
+		TP_ARGS(a, uptr, size, b));
+
+DECLARE_TRACE(sysenter_recvfrom,
+		TP_PROTO(int a, void __user * uptr, size_t size, unsigned b, struct sockaddr __user * saddr, int __user * uptr2),
+		TP_ARGS(a, uptr, size, b, saddr, uptr2));
+
+DECLARE_TRACE(sysenter_recvmsg,
+		TP_PROTO(int fd, struct msghdr __user *msg, unsigned flags),
+		TP_ARGS(fd, msg, flags));
+
+DECLARE_TRACE(sysenter_socket,
+		TP_PROTO(int a, int b, int c),
+		TP_ARGS(a, b, c));
+
+DECLARE_TRACE(sysenter_socketpair,
+		TP_PROTO(int a, int b, int c, int __user * uptr),
+		TP_ARGS(a, b, c, uptr));
+
+DECLARE_TRACE(sysenter_socketcall,
+		TP_PROTO(int call, unsigned long __user *args),
+		TP_ARGS(call, args));
+
+DECLARE_TRACE(sysenter_listen,
+		TP_PROTO(int a, int b),
+		TP_ARGS(a, b));
+
+DECLARE_TRACE(sysenter_poll,
+		TP_PROTO(struct pollfd __user *ufds, unsigned int nfds, long timeout),
+		TP_ARGS(ufds, nfds, timeout));
+
+DECLARE_TRACE(sysenter_select,
+		TP_PROTO(int n, fd_set __user *inp, fd_set __user *outp, fd_set __user *exp, struct timeval __user *tvp),
+		TP_ARGS(n, inp, outp, exp, tvp));
+
+DECLARE_TRACE(sysenter_epoll_create,
+		TP_PROTO(int size),
+		TP_ARGS(size));
+
+DECLARE_TRACE(sysenter_epoll_create1,
+		TP_PROTO(int flags),
+		TP_ARGS(flags));
+
+DECLARE_TRACE(sysenter_epoll_ctl,
+		TP_PROTO(int epfd, int op, int fd, struct epoll_event __user *event),
+		TP_ARGS(epfd, op, fd, event));
+
+DECLARE_TRACE(sysenter_epoll_wait,
+		TP_PROTO(int epfd, struct epoll_event __user *events, int maxevents, int timeout),
+		TP_ARGS(epfd, events, maxevents, timeout));
+
+DECLARE_TRACE(sysenter_epoll_pwait,
+		TP_PROTO(int epfd, struct epoll_event __user *events, int maxevents, int timeout, const sigset_t __user *sigmask, size_t sigsetsize),
+		TP_ARGS(epfd, events, maxevents, timeout, sigmask, sigsetsize));
+
+DECLARE_TRACE(sysenter_gethostname,
+		TP_PROTO(char __user *name, int len),
+		TP_ARGS(name, len));
+
+DECLARE_TRACE(sysenter_sethostname,
+		TP_PROTO(char __user *name, int len),
+		TP_ARGS(name, len));
+
+DECLARE_TRACE(sysenter_setdomainname,
+		TP_PROTO(char __user *name, int len),
+		TP_ARGS(name, len));
+
+DECLARE_TRACE(sysenter_newuname,
+		TP_PROTO(struct new_utsname __user *name),
+		TP_ARGS(name));
+
+DECLARE_TRACE(sysenter_getrlimit,
+		TP_PROTO(unsigned int resource, struct rlimit __user *rlim),
+		TP_ARGS(resource, rlim));
+
+#if defined(COMPAT_RLIM_OLD_INFINITY) || !(defined(CONFIG_IA64))
+DECLARE_TRACE(sysenter_old_getrlimit,
+		TP_PROTO(unsigned int resource, struct rlimit __user *rlim),
+		TP_ARGS(resource, rlim));
+#endif
+DECLARE_TRACE(sysenter_setrlimit,
+		TP_PROTO(unsigned int resource, struct rlimit __user *rlim),
+		TP_ARGS(resource, rlim));
+
+DECLARE_TRACE(sysenter_getrusage,
+		TP_PROTO(int who, struct rusage __user *ru),
+		TP_ARGS(who, ru));
+
+DECLARE_TRACE(sysenter_umask,
+		TP_PROTO(int mask),
+		TP_ARGS(mask));
+
+DECLARE_TRACE(sysenter_msgget,
+		TP_PROTO(key_t key, int msgflg),
+		TP_ARGS(key, msgflg));
+
+DECLARE_TRACE(sysenter_msgsnd,
+		TP_PROTO(int msqid, struct msgbuf __user *msgp, size_t msgsz, int msgflg),
+		TP_ARGS(msqid, msgp, msgsz, msgflg));
+
+DECLARE_TRACE(sysenter_msgrcv,
+		TP_PROTO(int msqid, struct msgbuf __user *msgp, size_t msgsz, long msgtyp, int msgflg),
+		TP_ARGS(msqid, msgp, msgsz, msgtyp, msgflg));
+
+DECLARE_TRACE(sysenter_msgctl,
+		TP_PROTO(int msqid, int cmd, struct msqid_ds __user *buf),
+		TP_ARGS(msqid, cmd, buf));
+
+DECLARE_TRACE(sysenter_semget,
+		TP_PROTO(key_t key, int nsems, int semflg),
+		TP_ARGS(key, nsems, semflg));
+
+DECLARE_TRACE(sysenter_semop,
+		TP_PROTO(int semid, struct sembuf __user *sops, unsigned nsops),
+		TP_ARGS(semid, sops, nsops));
+
+DECLARE_TRACE(sysenter_semctl,
+		TP_PROTO(int semid, int semnum, int cmd, union semun arg),
+		TP_ARGS(semid, semnum, cmd, arg));
+
+DECLARE_TRACE(sysenter_semtimedop,
+		TP_PROTO(int semid, struct sembuf __user *sops, unsigned nsops, const struct timespec __user *timeout),
+		TP_ARGS(semid, sops, nsops, timeout));
+
+DECLARE_TRACE(sysenter_shmat,
+		TP_PROTO(int shmid, char __user *shmaddr, int shmflg),
+		TP_ARGS(shmid, shmaddr, shmflg));
+
+DECLARE_TRACE(sysenter_shmget,
+		TP_PROTO(key_t key, size_t size, int flag),
+		TP_ARGS(key, size, flag));
+
+DECLARE_TRACE(sysenter_shmdt,
+		TP_PROTO(char __user *shmaddr),
+		TP_ARGS(shmaddr));
+
+DECLARE_TRACE(sysenter_shmctl,
+		TP_PROTO(int shmid, int cmd, struct shmid_ds __user *buf),
+		TP_ARGS(shmid, cmd, buf));
+
+DECLARE_TRACE(sysenter_mq_open,
+		TP_PROTO(const char __user *name, int oflag, mode_t mode, struct mq_attr __user *attr),
+		TP_ARGS(name, oflag, mode, attr));
+
+DECLARE_TRACE(sysenter_mq_unlink,
+		TP_PROTO(const char __user *name),
+		TP_ARGS(name));
+
+DECLARE_TRACE(sysenter_mq_timedsend,
+		TP_PROTO(mqd_t mqdes, const char __user *msg_ptr, size_t msg_len, unsigned int msg_prio, const struct timespec __user *abs_timeout),
+		TP_ARGS(mqdes, msg_ptr, msg_len, msg_prio, abs_timeout));
+
+DECLARE_TRACE(sysenter_mq_timedreceive,
+		TP_PROTO(mqd_t mqdes, char __user *msg_ptr, size_t msg_len, unsigned int __user *msg_prio, const struct timespec __user *abs_timeout),
+		TP_ARGS(mqdes, msg_ptr, msg_len, msg_prio, abs_timeout));
+
+DECLARE_TRACE(sysenter_mq_notify,
+		TP_PROTO(mqd_t mqdes, const struct sigevent __user *notification),
+		TP_ARGS(mqdes, notification));
+
+DECLARE_TRACE(sysenter_mq_getsetattr,
+		TP_PROTO(mqd_t mqdes, const struct mq_attr __user *mqstat, struct mq_attr __user *omqstat),
+		TP_ARGS(mqdes, mqstat, omqstat));
+
+DECLARE_TRACE(sysenter_pciconfig_iobase,
+		TP_PROTO(long which, unsigned long bus, unsigned long devfn),
+		TP_ARGS(which, bus, devfn));
+
+DECLARE_TRACE(sysenter_pciconfig_read,
+		TP_PROTO(unsigned long bus, unsigned long dfn, unsigned long off, unsigned long len, void __user *buf),
+		TP_ARGS(bus, dfn, off, len, buf));
+
+DECLARE_TRACE(sysenter_pciconfig_write,
+		TP_PROTO(unsigned long bus, unsigned long dfn, unsigned long off, unsigned long len, void __user *buf),
+		TP_ARGS(bus, dfn, off, len, buf));
+
+DECLARE_TRACE(sysenter_prctl,
+		TP_PROTO(int option, unsigned long arg2, unsigned long arg3, unsigned long arg4, unsigned long arg5),
+		TP_ARGS(option, arg2, arg3, arg4, arg5));
+
+DECLARE_TRACE(sysenter_swapon,
+		TP_PROTO(const char __user *specialfile, int swap_flags),
+		TP_ARGS(specialfile, swap_flags));
+
+DECLARE_TRACE(sysenter_swapoff,
+		TP_PROTO(const char __user *specialfile),
+		TP_ARGS(specialfile));
+
+DECLARE_TRACE(sysenter_sysctl,
+		TP_PROTO(struct __sysctl_args __user *args),
+		TP_ARGS(args));
+
+DECLARE_TRACE(sysenter_sysinfo,
+		TP_PROTO(struct sysinfo __user *info),
+		TP_ARGS(info));
+
+DECLARE_TRACE(sysenter_sysfs,
+		TP_PROTO(int option, unsigned long arg1, unsigned long arg2),
+		TP_ARGS(option, arg1, arg2));
+
+DECLARE_TRACE(sysenter_nfsservctl,
+		TP_PROTO(int cmd, struct nfsctl_arg __user *arg, void __user *res),
+		TP_ARGS(cmd, arg, res));
+
+DECLARE_TRACE(sysenter_syslog,
+		TP_PROTO(int type, char __user *buf, int len),
+		TP_ARGS(type, buf, len));
+
+DECLARE_TRACE(sysenter_uselib,
+		TP_PROTO(const char __user *library),
+		TP_ARGS(library));
+
+DECLARE_TRACE(sysenter_ni_syscall,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_ptrace,
+		TP_PROTO(long request, long pid, long addr, long data),
+		TP_ARGS(request, pid, addr, data));
+
+DECLARE_TRACE(sysenter_add_key,
+		TP_PROTO(const char __user *_type, const char __user *_description, const void __user *_payload, size_t plen, key_serial_t destringid),
+		TP_ARGS(_type, _description, _payload, plen, destringid));
+
+DECLARE_TRACE(sysenter_request_key,
+		TP_PROTO(const char __user *_type, const char __user *_description, const char __user *_callout_info, key_serial_t destringid),
+		TP_ARGS(_type, _description, _callout_info, destringid));
+
+DECLARE_TRACE(sysenter_keyctl,
+		TP_PROTO(int cmd, unsigned long arg2, unsigned long arg3, unsigned long arg4, unsigned long arg5),
+		TP_ARGS(cmd, arg2, arg3, arg4, arg5));
+
+DECLARE_TRACE(sysenter_ioprio_set,
+		TP_PROTO(int which, int who, int ioprio),
+		TP_ARGS(which, who, ioprio));
+
+DECLARE_TRACE(sysenter_ioprio_get,
+		TP_PROTO(int which, int who),
+		TP_ARGS(which, who));
+
+DECLARE_TRACE(sysenter_set_mempolicy,
+		TP_PROTO(int mode, unsigned long __user *nmask, unsigned long maxnode),
+		TP_ARGS(mode, nmask, maxnode));
+
+DECLARE_TRACE(sysenter_migrate_pages,
+		TP_PROTO(pid_t pid, unsigned long maxnode, const unsigned long __user *from, const unsigned long __user *to),
+		TP_ARGS(pid, maxnode, from, to));
+
+DECLARE_TRACE(sysenter_move_pages,
+		TP_PROTO(pid_t pid, unsigned long nr_pages, const void __user * __user *pages, const int __user *nodes, int __user *status, int flags),
+		TP_ARGS(pid, nr_pages, pages, nodes, status, flags));
+
+DECLARE_TRACE(sysenter_mbind,
+		TP_PROTO(unsigned long start, unsigned long len, unsigned long mode, unsigned long __user *nmask, unsigned long maxnode, unsigned flags),
+		TP_ARGS(start, len, mode, nmask, maxnode, flags));
+
+DECLARE_TRACE(sysenter_get_mempolicy,
+		TP_PROTO(int __user *policy, unsigned long __user *nmask, unsigned long maxnode, unsigned long addr, unsigned long flags),
+		TP_ARGS(policy, nmask, maxnode, addr, flags));
+
+DECLARE_TRACE(sysenter_inotify_init,
+		TP_PROTO(void),
+		TP_ARGS());
+
+DECLARE_TRACE(sysenter_inotify_init1,
+		TP_PROTO(int flags),
+		TP_ARGS(flags));
+
+DECLARE_TRACE(sysenter_inotify_add_watch,
+		TP_PROTO(int fd, const char __user *path, u32 mask),
+		TP_ARGS(fd, path, mask));
+
+DECLARE_TRACE(sysenter_inotify_rm_watch,
+		TP_PROTO(int fd, __s32 wd),
+		TP_ARGS(fd, wd));
+
+DECLARE_TRACE(sysenter_spu_run,
+		TP_PROTO(int fd, __u32 __user *unpc, __u32 __user *ustatus),
+		TP_ARGS(fd, unpc, ustatus));
+
+DECLARE_TRACE(sysenter_spu_create,
+		TP_PROTO(const char __user *name, unsigned int flags, mode_t mode, int fd),
+		TP_ARGS(name, flags, mode, fd));
+
+DECLARE_TRACE(sysenter_mknodat,
+		TP_PROTO(int dfd, const char __user * filename, int mode, unsigned dev),
+		TP_ARGS(dfd, filename, mode, dev));
+
+DECLARE_TRACE(sysenter_mkdirat,
+		TP_PROTO(int dfd, const char __user * pathname, int mode),
+		TP_ARGS(dfd, pathname, mode));
+
+DECLARE_TRACE(sysenter_unlinkat,
+		TP_PROTO(int dfd, const char __user * pathname, int flag),
+		TP_ARGS(dfd, pathname, flag));
+
+DECLARE_TRACE(sysenter_symlinkat,
+		TP_PROTO(const char __user * oldname, int newdfd, const char __user * newname),
+		TP_ARGS(oldname, newdfd, newname));
+
+DECLARE_TRACE(sysenter_linkat,
+		TP_PROTO(int olddfd, const char __user *oldname, int newdfd, const char __user *newname, int flags),
+		TP_ARGS(olddfd, oldname, newdfd, newname, flags));
+
+DECLARE_TRACE(sysenter_renameat,
+		TP_PROTO(int olddfd, const char __user * oldname, int newdfd, const char __user * newname),
+		TP_ARGS(olddfd, oldname, newdfd, newname));
+
+DECLARE_TRACE(sysenter_futimesat,
+		TP_PROTO(int dfd, char __user *filename, struct timeval __user *utimes),
+		TP_ARGS(dfd, filename, utimes));
+
+DECLARE_TRACE(sysenter_faccessat,
+		TP_PROTO(int dfd, const char __user *filename, int mode),
+		TP_ARGS(dfd, filename, mode));
+
+DECLARE_TRACE(sysenter_fchmodat,
+		TP_PROTO(int dfd, const char __user * filename, mode_t mode),
+		TP_ARGS(dfd, filename, mode));
+
+DECLARE_TRACE(sysenter_fchownat,
+		TP_PROTO(int dfd, const char __user *filename, uid_t user, gid_t group, int flag),
+		TP_ARGS(dfd, filename, user, group, flag));
+
+DECLARE_TRACE(sysenter_openat,
+		TP_PROTO(int dfd, const char __user *filename, int flags, int mode),
+		TP_ARGS(dfd, filename, flags, mode));
+
+DECLARE_TRACE(sysenter_newfstatat,
+		TP_PROTO(int dfd, char __user *filename, struct stat __user *statbuf, int flag),
+		TP_ARGS(dfd, filename, statbuf, flag));
+
+DECLARE_TRACE(sysenter_fstatat64,
+		TP_PROTO(int dfd, char __user *filename, struct stat64 __user *statbuf, int flag),
+		TP_ARGS(dfd, filename, statbuf, flag));
+
+DECLARE_TRACE(sysenter_readlinkat,
+		TP_PROTO(int dfd, const char __user *path, char __user *buf, int bufsiz),
+		TP_ARGS(dfd, path, buf, bufsiz));
+
+DECLARE_TRACE(sysenter_utimensat,
+		TP_PROTO(int dfd, char __user *filename, struct timespec __user *utimes, int flags),
+		TP_ARGS(dfd, filename, utimes, flags));
+
+DECLARE_TRACE(sysenter_unshare,
+		TP_PROTO(unsigned long unshare_flags),
+		TP_ARGS(unshare_flags));
+
+DECLARE_TRACE(sysenter_splice,
+		TP_PROTO(int fd_in, loff_t __user *off_in, int fd_out, loff_t __user *off_out, size_t len, unsigned int flags),
+		TP_ARGS(fd_in, off_in, fd_out, off_out, len, flags));
+
+DECLARE_TRACE(sysenter_vmsplice,
+		TP_PROTO(int fd, const struct iovec __user *iov, unsigned long nr_segs, unsigned int flags),
+		TP_ARGS(fd, iov, nr_segs, flags));
+
+DECLARE_TRACE(sysenter_tee,
+		TP_PROTO(int fdin, int fdout, size_t len, unsigned int flags),
+		TP_ARGS(fdin, fdout, len, flags));
+
+DECLARE_TRACE(sysenter_sync_file_range,
+		TP_PROTO(int fd, loff_t offset, loff_t nbytes, unsigned int flags),
+		TP_ARGS(fd, offset, nbytes, flags));
+
+DECLARE_TRACE(sysenter_sync_file_range2,
+		TP_PROTO(int fd, unsigned int flags, loff_t offset, loff_t nbytes),
+		TP_ARGS(fd, flags, offset, nbytes));
+
+DECLARE_TRACE(sysenter_get_robust_list,
+		TP_PROTO(int pid, struct robust_list_head __user * __user *head_ptr, size_t __user *len_ptr),
+		TP_ARGS(pid, head_ptr, len_ptr));
+
+DECLARE_TRACE(sysenter_set_robust_list,
+		TP_PROTO(struct robust_list_head __user *head, size_t len),
+		TP_ARGS(head, len));
+
+DECLARE_TRACE(sysenter_getcpu,
+		TP_PROTO(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache),
+		TP_ARGS(cpu, node, cache));
+
+DECLARE_TRACE(sysenter_signalfd,
+		TP_PROTO(int ufd, sigset_t __user *user_mask, size_t sizemask),
+		TP_ARGS(ufd, user_mask, sizemask));
+
+DECLARE_TRACE(sysenter_signalfd4,
+		TP_PROTO(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags),
+		TP_ARGS(ufd, user_mask, sizemask, flags));
+
+DECLARE_TRACE(sysenter_timerfd_create,
+		TP_PROTO(int clockid, int flags),
+		TP_ARGS(clockid, flags));
+
+DECLARE_TRACE(sysenter_timerfd_settime,
+		TP_PROTO(int ufd, int flags, const struct itimerspec __user *utmr, struct itimerspec __user *otmr),
+		TP_ARGS(ufd, flags, utmr, otmr));
+
+DECLARE_TRACE(sysenter_timerfd_gettime,
+		TP_PROTO(int ufd, struct itimerspec __user *otmr),
+		TP_ARGS(ufd, otmr));
+
+DECLARE_TRACE(sysenter_eventfd,
+		TP_PROTO(unsigned int count),
+		TP_ARGS(count));
+
+DECLARE_TRACE(sysenter_eventfd2,
+		TP_PROTO(unsigned int count, int flags),
+		TP_ARGS(count, flags));
+
+DECLARE_TRACE(sysenter_fallocate,
+		TP_PROTO(int fd, int mode, loff_t offset, loff_t len),
+		TP_ARGS(fd, mode, offset, len));
+
+DECLARE_TRACE(sysenter_old_readdir,
+		TP_PROTO(unsigned int a, struct old_linux_dirent __user *dir, unsigned int b),
+		TP_ARGS(a, dir, b));
+
+DECLARE_TRACE(sysenter_pselect6,
+		TP_PROTO(int a, fd_set __user *fds, fd_set __user *fds2, fd_set __user *fds3, struct timespec __user *time, void __user *use),
+		TP_ARGS(a, fds, fds2, fds3, time, use));
+
+DECLARE_TRACE(sysenter_ppoll,
+		TP_PROTO(struct pollfd __user *poll, unsigned int a, struct timespec __user * time, const sigset_t __user *sigs, size_t size),
+		TP_ARGS(poll, a, time, sigs, size));
+
+DECLARE_TRACE(sysenter_pipe2,
+		TP_PROTO(int __user *uptr, int a),
+		TP_ARGS(uptr, a));
+
+DECLARE_TRACE(sysenter_pipe,
+		TP_PROTO(int __user *uptr),
+		TP_ARGS(uptr));
+
+DECLARE_TRACE(sysenter_perf_counter_open,
+		TP_PROTO(const struct perf_counter_hw_event __user *hw_event_uptr, pid_t pid, int cpu, int group_fd, unsigned long flags),
+		TP_ARGS(hw_event_uptr, pid, cpu, group_fd, flags));
+
+
+DECLARE_TRACE(sysenter_rt_sigsuspend,
+		TP_PROTO(sigset_t __user * unewset, size_t sigsetsize),
+		TP_ARGS(unewset, sigsetsize));
+
+DECLARE_TRACE(sysenter_rt_tgsigqueueinfo,
+		TP_PROTO(pid_t tgid, pid_t pid, int sig, siginfo_t __user * uinfo),
+		TP_ARGS(tgid, pid, sig, uinfo));
+
+DECLARE_TRACE(sysenter_rt_sigaction,
+		TP_PROTO(int sig, const struct sigaction __user * act, struct sigaction __user * oact, size_t sigsetsize),
+		TP_ARGS(sig, act, oact, sigsetsize));
+
+/* exits */
+
+DECLARE_TRACE(sysexit_time,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_stime,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_gettimeofday,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_settimeofday,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_adjtimex,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_times,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_gettid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_nanosleep,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_alarm,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getpid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getppid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getuid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_geteuid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getgid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getegid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getresuid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getresgid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getpgid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getpgrp,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getsid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getgroups,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setregid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setgid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setreuid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setuid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setresuid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setresgid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setfsuid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setfsgid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setpgid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setsid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setgroups,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_acct,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_capget,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_capset,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_personality,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sigpending,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sigprocmask,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getitimer,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setitimer,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_timer_create,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_timer_gettime,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_timer_getoverrun,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_timer_settime,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_timer_delete,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_clock_settime,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_clock_gettime,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_clock_getres,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_clock_nanosleep,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_nice,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_setscheduler,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_setparam,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_getscheduler,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_getparam,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_setaffinity,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_getaffinity,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_yield,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_get_priority_max,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_get_priority_min,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sched_rr_get_interval,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setpriority,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+
+DECLARE_TRACE(sysexit_getpriority,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_shutdown,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_reboot,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_restart_syscall,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_kexec_load,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_exit,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_exit_group,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_wait4,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_waitid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_waitpid,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_set_tid_address,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_futex,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_init_module,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_delete_module,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_rt_sigprocmask,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_rt_sigpending,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_rt_sigtimedwait,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_kill,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_tgkill,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_tkill,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_rt_sigqueueinfo,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sgetmask,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ssetmask,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_signal,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pause,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sync,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fsync,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fdatasync,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_bdflush,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mount,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));		
+
+DECLARE_TRACE(sysexit_umount,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_oldumount,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_truncate,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ftruncate,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_stat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_statfs,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_statfs64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fstatfs,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fstatfs64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lstat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fstat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_newstat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_newlstat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_newfstat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ustat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+#if BITS_PER_LONG == 32
+DECLARE_TRACE(sysexit_stat64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fstat64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lstat64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_truncate64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ftruncate64,
+		TP_PROTO(long ret),
+		TPP_ARGS(fd, length));
+#endif
+
+DECLARE_TRACE(sysexit_setxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lsetxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fsetxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lgetxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fgetxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_listxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_llistxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_flistxattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_removexattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lremovexattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fremovexattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_brk,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mprotect,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mremap,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_remap_file_pages,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));		
+
+DECLARE_TRACE(sysexit_msync,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fadvise64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fadvise64_64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_munmap,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mlock,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_munlock,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mlockall,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_munlockall,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_madvise,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mincore,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pivot_root,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_chroot,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mknod,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_link,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_symlink,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_unlink,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_rename,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_chmod,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fchmod,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fcntl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+#if BITS_PER_LONG == 32
+DECLARE_TRACE(sysexit_fcntl64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+#endif
+DECLARE_TRACE(sysexit_dup,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_dup2,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_dup3,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ioperm,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ioctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_flock,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_io_setup,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_io_destroy,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_io_getevents,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_io_submit,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_io_cancel,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sendfile,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sendfile64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_readlink,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_creat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_open,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_close,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_access,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_vhangup,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_chown,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lchown,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fchown,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+#ifdef CONFIG_UID16
+DECLARE_TRACE(sysexit_chown16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lchown16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fchown16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setregid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setgid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setreuid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setuid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setresuid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getresuid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setresgid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getresgid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setfsuid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setfsgid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getgroups16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setgroups16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getuid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_geteuid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getgid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getegid16,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+#endif
+
+DECLARE_TRACE(sysexit_utime,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_utimes,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lseek,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_llseek,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_read,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_readahead,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_readv,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_write,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_writev,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pread64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pwrite64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_preadv,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pwritev,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getcwd,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mkdir,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_chdir,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fchdir,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_rmdir,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_lookup_dcookie,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_quotactl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getdents,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getdents64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setsockopt,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getsockopt,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_bind,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_connect,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_accept,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_accept4,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getsockname,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getpeername,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_send,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sendto,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sendmsg,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_recv,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_recvfrom,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_recvmsg,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_socket,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_socketpair,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_socketcall,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_listen,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_poll,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_select,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_epoll_create,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_epoll_create1,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_epoll_ctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_epoll_wait,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_epoll_pwait,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_gethostname,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sethostname,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_setdomainname,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_newuname,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getrlimit,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+#if defined(COMPAT_RLIM_OLD_INFINITY) || !(defined(CONFIG_IA64))
+DECLARE_TRACE(sysexit_old_getrlimit,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+#endif
+DECLARE_TRACE(sysexit_setrlimit,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getrusage,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_umask,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_msgget,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_msgsnd,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_msgrcv,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_msgctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_semget,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_semop,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_semctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_semtimedop,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_shmat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_shmget,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_shmdt,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_shmctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mq_open,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mq_unlink,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mq_timedsend,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mq_timedreceive,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mq_notify,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mq_getsetattr,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pciconfig_iobase,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pciconfig_read,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pciconfig_write,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_prctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_swapon,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_swapoff,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sysctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sysinfo,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sysfs,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_nfsservctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_syslog,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_uselib,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ni_syscall,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ptrace,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_add_key,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_request_key,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_keyctl,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ioprio_set,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ioprio_get,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_set_mempolicy,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_migrate_pages,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_move_pages,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mbind,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_get_mempolicy,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_inotify_init,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_inotify_init1,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_inotify_add_watch,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_inotify_rm_watch,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_spu_run,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_spu_create,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mknodat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_mkdirat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_unlinkat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_symlinkat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_linkat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_renameat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_futimesat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_faccessat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fchmodat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fchownat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_openat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_newfstatat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fstatat64,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_readlinkat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_utimensat,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_unshare,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_splice,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_vmsplice,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_tee,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sync_file_range,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_sync_file_range2,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_get_robust_list,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_set_robust_list,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_getcpu,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_signalfd,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_signalfd4,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_timerfd_create,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_timerfd_settime,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_timerfd_gettime,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_eventfd,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_eventfd2,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_fallocate,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_old_readdir,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pselect6,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_ppoll,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pipe2,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_pipe,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_perf_counter_open,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+
+DECLARE_TRACE(sysexit_rt_sigsuspend,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_rt_tgsigqueueinfo,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+DECLARE_TRACE(sysexit_rt_sigaction,
+		TP_PROTO(long ret),
+		TP_ARGS(ret));
+
+
+#endif
+
+#endif
