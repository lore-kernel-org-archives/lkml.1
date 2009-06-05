Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZFESJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZFESJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZFESJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:09:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZFESJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:09:09 -0400
Date: Fri, 5 Jun 2009 14:08:08 -0400
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com>
In-Reply-To: <cover.1244222378.git.jbaron@redhat.com>
References: <cover.1244222378.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/2] convert to syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implements syscall tracer via tracepoints and TRACE_EVENT(). Introduces
a new tracing flag 'trace_syscalls', which must be toggled to enable this
feature.


Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 arch/x86/kernel/ptrace.c        |    8 +-
 include/asm-generic/syscall.h   |    3 +
 include/trace/events/syscalls.h | 4202 +++++++++++++++++++++++++++++++++++++++
 include/trace/syscall.h         |    6 +
 kernel/trace/Makefile           |    1 -
 kernel/trace/trace.c            |  101 +
 kernel/trace/trace_syscalls.c   |  250 ---
 7 files changed, 4317 insertions(+), 254 deletions(-)
 create mode 100644 include/trace/events/syscalls.h
 delete mode 100644 kernel/trace/trace_syscalls.c

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 09ecbde..1016619 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -35,7 +35,9 @@
 #include <asm/proto.h>
 #include <asm/ds.h>
 
-#include <trace/syscall.h>
+#include <linux/ftrace.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
 
 #include "tls.h"
 
@@ -1498,7 +1500,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 		ret = -1L;
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_enter(regs);
+		syscall_tracepoints_enter(regs);
 
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
@@ -1524,7 +1526,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
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
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
new file mode 100644
index 0000000..de7143d
--- /dev/null
+++ b/include/trace/events/syscalls.h
@@ -0,0 +1,4202 @@
+#if !defined(_TRACE_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SYSCALLS_H
+
+#include <asm/syscall.h>
+#include <asm-generic/syscall.h>
+#include <linux/tracepoint.h>
+#include <trace/syscall.h>
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
+#define expand_enter_sys_args_0()
+#define expand_enter_sys_args_1(t1) (t1) sys_args[0]
+#define expand_enter_sys_args_2(t1, t2) expand_enter_sys_args_1(t1), (t2) sys_args[1]
+#define expand_enter_sys_args_3(t1, t2, t3) expand_enter_sys_args_2(t1, t2), (t3) sys_args[2]
+#define expand_enter_sys_args_4(t1, t2, t3, t4) expand_enter_sys_args_3(t1, t2, t3), (t4) sys_args[3]
+#define expand_enter_sys_args_5(t1, t2, t3, t4, t5) expand_enter_sys_args_4(t1, t2, t3, t4), (t5) sys_args[4]
+#define expand_enter_sys_args_6(t1, t2, t3, t4, t5, t6) expand_enter_sys_args_5(t1, t2, t3, t4, t5), (t6) sys_args[5]
+
+#define create_syscall_enter(n, sysname, ...)		\
+        case __NR_##sysname:				\
+		syscall_get_arguments(current, regs, 0, n, sys_args); \
+		trace_sysenter_##sysname(expand_enter_sys_args_##n(__VA_ARGS__)); \
+		break;
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
+#define create_syscall_exit(sysname)               		\
+        case __NR_##sysname:					\
+                trace_sysexit_##sysname(ret);                   \
+                break;                                          \
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
+#ifdef __NR_time
+trace_event_syscall_enter(1, time, time_t __user *, tloc);
+trace_event_syscall_exit(time);
+#define ENTERCASEtime create_syscall_enter(1, time, time_t __user *);
+#define EXITCASEtime create_syscall_exit(time);
+#else
+#define ENTERCASEtime
+#define EXITCASEtime
+#endif
+
+#ifdef __NR_stime
+trace_event_syscall_enter(1, stime, time_t __user *, tptr);
+trace_event_syscall_exit(stime);
+#define ENTERCASEstime create_syscall_enter(1, stime, time_t __user *);
+#define EXITCASEstime create_syscall_exit(stime);
+#else
+#define ENTERCASEstime
+#define EXITCASEstime
+#endif
+
+#ifdef __NR_gettimeofday
+trace_event_syscall_enter(2, gettimeofday, struct timeval __user *, tv, struct timezone __user *, tz);
+trace_event_syscall_exit(gettimeofday);
+#define ENTERCASEgettimeofday create_syscall_enter(2, gettimeofday, struct timeval __user *, struct timezone __user *);
+#define EXITCASEgettimeofday create_syscall_exit(gettimeofday);
+#else
+#define ENTERCASEgettimeofday
+#define EXITCASEgettimeofday
+#endif
+
+#ifdef __NR_settimeofday
+trace_event_syscall_exit(settimeofday);
+TRACE_EVENT(sysenter_settimeofday,
+	TP_PROTO(struct timeval __user *tv, struct timezone __user *tz),
+	TP_ARGS(tv, tz),
+	TP_STRUCT__entry(
+		__field(struct timeval __user *, tv)
+		__field(struct timezone __user *, tz)
+	),
+	TP_fast_assign(
+		__entry->tv = tv;
+		__entry->tz = tz;
+	),
+	TP_printk("%016Lx %016Lx", (u64)__entry->tv, (u64)__entry->tz)
+);
+#define ENTERCASEsettimeofday create_syscall_enter(2, settimeofday, struct timeval __user *, struct timezone __user *);
+#define EXITCASEsettimeofday create_syscall_exit(settimeofday);
+#else
+#define ENTERCASEsettimeofday
+#define EXITCASEsettimeofday
+#endif
+
+#ifdef __NR_adjtimex
+trace_event_syscall_enter(1, adjtimex, struct timex __user *, txc_p);
+trace_event_syscall_exit(adjtimex);
+#define ENTERCASEadjtimex create_syscall_enter(1, adjtimex, struct timex __user *);
+#define EXITCASEadjtimex create_syscall_exit(adjtimex);
+#else
+#define ENTERCASEadjtimex
+#define EXITCASEadjtimex
+#endif
+
+#ifdef __NR_times
+trace_event_syscall_enter(1, times, struct tms __user *, tbuf);
+trace_event_syscall_exit(times);
+#define ENTERCASEtimes create_syscall_enter(1, times, struct tms __user *);
+#define EXITCASEtimes create_syscall_exit(times);
+#else
+#define ENTERCASEtimes
+#define EXITCASEtimes
+#endif
+
+#ifdef __NR_gettid
+trace_event_syscall_exit(gettid);
+trace_event_syscall_enter(0, gettid);
+#define ENTERCASEgettid create_syscall_enter(0, gettid);
+#define EXITCASEgettid create_syscall_exit(gettid);
+#else
+#define ENTERCASEgettid
+#define EXITCASEgettid
+#endif
+
+#ifdef __NR_nanosleep
+trace_event_syscall_enter(2, nanosleep, struct timespec __user *, rqtp, struct timespec __user *, rmtp);
+trace_event_syscall_exit(nanosleep);
+#define ENTERCASEnanosleep create_syscall_enter(2, nanosleep, struct timespec __user *, struct timespec __user *);
+#define EXITCASEnanosleep create_syscall_exit(nanosleep);
+#else
+#define ENTERCASEnanosleep
+#define EXITCASEnanosleep
+#endif
+
+#ifdef __NR_alarm
+trace_event_syscall_enter(1, alarm, unsigned int, seconds);
+trace_event_syscall_exit(alarm);
+#define ENTERCASEalarm create_syscall_enter(1, alarm, unsigned int);
+#define EXITCASEalarm create_syscall_exit(alarm);
+#else
+#define ENTERCASEalarm
+#define EXITCASEalarm
+#endif
+
+#ifdef __NR_getpid
+trace_event_syscall_exit(getpid);
+trace_event_syscall_enter(0, getpid);
+#define EXITCASEgetpid create_syscall_exit(getpid);
+#define ENTERCASEgetpid create_syscall_enter(0, getpid);
+#else
+#define EXITCASEgetpid
+#define ENTERCASEgetpid
+#endif
+
+#ifdef __NR_getppid
+trace_event_syscall_enter(0, getppid);
+trace_event_syscall_exit(getppid);
+#define ENTERCASEgetppid create_syscall_enter(0, getppid);
+#define EXITCASEgetppid create_syscall_exit(getppid);
+#else
+#define ENTERCASEgetppid
+#define EXITCASEgetppid
+#endif
+
+#ifdef __NR_getuid
+trace_event_syscall_enter(0, getuid);
+trace_event_syscall_exit(getuid);
+#define ENTERCASEgetuid create_syscall_enter(0, getuid);
+#define EXITCASEgetuid create_syscall_exit(getuid);
+#else
+#define ENTERCASEgetuid
+#define EXITCASEgetuid
+#endif
+
+#ifdef __NR_geteuid
+trace_event_syscall_enter(0, geteuid);
+trace_event_syscall_exit(geteuid);
+#define ENTERCASEgeteuid create_syscall_enter(0, geteuid);
+#define EXITCASEgeteuid create_syscall_exit(geteuid);
+#else
+#define ENTERCASEgeteuid
+#define EXITCASEgeteuid
+#endif
+
+#ifdef __NR_getgid
+trace_event_syscall_enter(0, getgid);
+trace_event_syscall_exit(getgid);
+#define ENTERCASEgetgid create_syscall_enter(0, getgid);
+#define EXITCASEgetgid create_syscall_exit(getgid);
+#else
+#define ENTERCASEgetgid
+#define EXITCASEgetgid
+#endif
+
+#ifdef __NR_getegid
+trace_event_syscall_enter(0, getegid);
+trace_event_syscall_exit(getegid);
+#define ENTERCASEgetegid create_syscall_enter(0, getegid);
+#define EXITCASEgetegid create_syscall_exit(getegid);
+#else
+#define ENTERCASEgetegid
+#define EXITCASEgetegid
+#endif
+
+#ifdef __NR_getresuid
+trace_event_syscall_enter(3, getresuid, uid_t __user *, ruid, uid_t __user *, euid, uid_t __user *, suid);
+trace_event_syscall_exit(getresuid);
+#define ENTERCASEgetresuid create_syscall_enter(3, getresuid, uid_t __user *, uid_t __user *, uid_t __user *);
+#define EXITCASEgetresuid create_syscall_exit(getresuid);
+#else
+#define ENTERCASEgetresuid
+#define EXITCASEgetresuid
+#endif
+
+#ifdef __NR_getresgid
+trace_event_syscall_enter(3, getresgid, gid_t __user *, rgid, gid_t __user *, egid, gid_t __user *, sgid);
+trace_event_syscall_exit(getresgid);
+#define ENTERCASEgetresgid create_syscall_enter(3, getresgid, gid_t __user *, gid_t __user *, gid_t __user *);
+#define EXITCASEgetresgid create_syscall_exit(getresgid);
+#else
+#define ENTERCASEgetresgid
+#define EXITCASEgetresgid
+#endif
+
+#ifdef __NR_getpgid
+trace_event_syscall_enter(1, getpgid, pid_t, pid);
+trace_event_syscall_exit(getpgid);
+#define ENTERCASEgetpgid create_syscall_enter(1, getpgid, pid_t);
+#define EXITCASEgetpgid create_syscall_exit(getpgid);
+#else
+#define ENTERCASEgetpgid
+#define EXITCASEgetpgid
+#endif
+
+#ifdef __NR_getpgrp
+trace_event_syscall_enter(0, getpgrp);
+trace_event_syscall_exit(getpgrp);
+#define ENTERCASEgetpgrp create_syscall_enter(0, getpgrp);
+#define EXITCASEgetpgrp create_syscall_exit(getpgrp);
+#else
+#define ENTERCASEgetpgrp
+#define EXITCASEgetpgrp
+#endif
+
+#ifdef __NR_getsid
+trace_event_syscall_enter(1, getsid, pid_t, pid);
+trace_event_syscall_exit(getsid);
+#define ENTERCASEgetsid create_syscall_enter(1, getsid, pid_t);
+#define EXITCASEgetsid create_syscall_exit(getsid);
+#else
+#define ENTERCASEgetsid
+#define EXITCASEgetsid
+#endif
+
+#ifdef __NR_getgroups
+trace_event_syscall_enter(2, getgroups, int, gidsetsize, gid_t __user *, grouplist);
+trace_event_syscall_exit(getgroups);
+#define ENTERCASEgetgroups create_syscall_enter(2, getgroups, int, gid_t __user *);
+#define EXITCASEgetgroups create_syscall_exit(getgroups);
+#else
+#define ENTERCASEgetgroups
+#define EXITCASEgetgroups
+#endif
+
+#ifdef __NR_setregid
+trace_event_syscall_enter(2, setregid, gid_t, rgid, gid_t, egid);
+trace_event_syscall_exit(setregid);
+#define ENTERCASEsetregid create_syscall_enter(2, setregid, gid_t, gid_t);
+#define EXITCASEsetregid create_syscall_exit(setregid);
+#else
+#define ENTERCASEsetregid
+#define EXITCASEsetregid
+#endif
+
+#ifdef __NR_setgid
+trace_event_syscall_enter(1, setgid, gid_t, gid);
+trace_event_syscall_exit(setgid);
+#define ENTERCASEsetgid create_syscall_enter(1, setgid, gid_t);
+#define EXITCASEsetgid create_syscall_exit(setgid);
+#else
+#define ENTERCASEsetgid
+#define EXITCASEsetgid
+#endif
+
+#ifdef __NR_setreuid
+trace_event_syscall_enter(2, setreuid, uid_t, ruid, uid_t, euid);
+trace_event_syscall_exit(setreuid);
+#define ENTERCASEsetreuid create_syscall_enter(2, setreuid, uid_t, uid_t);
+#define EXITCASEsetreuid create_syscall_exit(setreuid);
+#else
+#define ENTERCASEsetreuid
+#define EXITCASEsetreuid
+#endif
+
+#ifdef __NR_setuid
+trace_event_syscall_enter(1, setuid, uid_t, uid);
+trace_event_syscall_exit(setuid);
+#define ENTERCASEsetuid create_syscall_enter(1, setuid, uid_t);
+#define EXITCASEsetuid create_syscall_exit(setuid);
+#else
+#define ENTERCASEsetuid
+#define EXITCASEsetuid
+#endif
+
+#ifdef __NR_setresuid
+trace_event_syscall_enter(3, setresuid, uid_t, ruid, uid_t, euid, uid_t, suid);
+trace_event_syscall_exit(setresuid);
+#define ENTERCASEsetresuid create_syscall_enter(3, setresuid, uid_t, uid_t, uid_t);
+#define EXITCASEsetresuid create_syscall_exit(setresuid);
+#else
+#define ENTERCASEsetresuid
+#define EXITCASEsetresuid
+#endif
+
+#ifdef __NR_setresgid
+trace_event_syscall_enter(3, setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid);
+trace_event_syscall_exit(setresgid);
+#define ENTERCASEsetresgid create_syscall_enter(3, setresgid, gid_t, gid_t, gid_t);
+#define EXITCASEsetresgid create_syscall_exit(setresgid);
+#else
+#define ENTERCASEsetresgid
+#define EXITCASEsetresgid
+#endif
+
+#ifdef __NR_setfsuid
+trace_event_syscall_enter(1, setfsuid, uid_t, uid);
+trace_event_syscall_exit(setfsuid);
+#define ENTERCASEsetfsuid create_syscall_enter(1, setfsuid, uid_t);
+#define EXITCASEsetfsuid create_syscall_exit(setfsuid);
+#else
+#define ENTERCASEsetfsuid
+#define EXITCASEsetfsuid
+#endif
+
+#ifdef __NR_setfsgid
+trace_event_syscall_enter(1, setfsgid, gid_t, gid);
+trace_event_syscall_exit(setfsgid);
+#define ENTERCASEsetfsgid create_syscall_enter(1, setfsgid, gid_t);
+#define EXITCASEsetfsgid create_syscall_exit(setfsgid);
+#else
+#define ENTERCASEsetfsgid
+#define EXITCASEsetfsgid
+#endif
+
+#ifdef _NR_setpgid
+trace_event_syscall_enter(2, setpgid, pid_t, pid, pid_t, pgid);
+trace_event_syscall_exit(setpgid);
+#define ENTERCASEsetpgid create_syscall_enter(setpgid, pid_t, pid_t);
+#define EXITCASEsetpgid create_syscall_exit(setpgid);
+#else
+#define ENTERCASEsetpgid
+#define EXITCASEsetpgid
+#endif
+
+#ifdef _NR_setsid
+trace_event_syscall_enter(0, setsid);
+trace_event_syscall_exit(setsid);
+#define ENTERCASEsetsid create_syscall_enter(0, setsid);
+#define EXITCASEsetsid create_syscall_exit(setsid);
+#else
+#define ENTERCASEsetsid
+#define EXITCASEsetsid
+#endif
+
+#ifdef __NR_setgroups
+trace_event_syscall_enter(2, setgroups, int, gidsetsize, gid_t __user *, grouplist);
+trace_event_syscall_exit(setgroups);
+#define ENTERCASEsetgroups create_syscall_enter(2, setgroups, int, gid_t __user *);
+#define EXITCASEsetgroups create_syscall_exit(setgroups);
+#else
+#define ENTERCASEsetgroups
+#define EXITCASEsetgroups
+#endif
+
+#ifdef __NR_acct
+trace_event_syscall_enter(1, acct, const char __user *, name);
+trace_event_syscall_exit(acct);
+#define ENTERCASEacct create_syscall_enter(1, acct, const char __user *);
+#define EXITCASEacct create_syscall_exit(acct);
+#else
+#define ENTERCASEacct
+#define EXITCASEacct
+#endif
+
+#ifdef __NR_capget
+trace_event_syscall_enter(2, capget, cap_user_header_t, header, cap_user_data_t, dataptr);
+trace_event_syscall_exit(capget);
+#define ENTERCASEcapget create_syscall_enter(2, capget, cap_user_header_t, cap_user_data_t);
+#define EXITCASEcapget create_syscall_exit(capget);
+#else
+#define ENTERCASEcapget
+#define EXITCASEcapget
+#endif
+
+#ifdef __NR_capset
+trace_event_syscall_enter(2, capset, cap_user_header_t, header, cap_user_data_t, data);
+trace_event_syscall_exit(capset);
+#define ENTERCASEcapset create_syscall_enter(2, capset, cap_user_header_t, const cap_user_data_t);
+#define EXITCASEcapset create_syscall_exit(capset);
+#else
+#define ENTERCASEcapset
+#define EXITCASEcapset
+#endif
+
+#ifdef __NR_personality
+trace_event_syscall_enter(1, personality, u_long, personality);
+trace_event_syscall_exit(personality);
+#define ENTERCASEpersonality create_syscall_enter(1, personality, u_long);
+#define EXITCASEpersonality create_syscall_exit(personality);
+#else
+#define ENTERCASEpersonality
+#define EXITCASEpersonality
+#endif
+
+#ifdef __NR_sigpending
+trace_event_syscall_enter(1, sigpending, old_sigset_t __user, *set);
+trace_event_syscall_exit(sigpending);
+#define ENTERCASEsigpending create_syscall_exit(1, sigpending, old_sigset_t __user);
+#define EXITCASEsigpending create_syscall_exit(sigpending);
+#else
+#define ENTERCASEsigpending
+#define EXITCASEsigpending
+#endif
+
+#ifdef __NR_sigprocmask
+trace_event_syscall_enter(3, sigprocmask, int, how, old_sigset_t __user *, set, old_sigset_t __user *, oset);
+trace_event_syscall_exit(sigprocmask);
+#define ENTERCASEsigprocmask create_syscall_enter(3, sigprocmask, int, old_sigset_t __user *, old_sigset_t __user *);
+#define EXITCASEsigprocmask create_syscall_exit(sigprocmask);
+#else
+#define ENTERCASEsigprocmask
+#define EXITCASEsigprocmask
+#endif
+
+#ifdef __NR_getitimer
+trace_event_syscall_enter(2, getitimer, int, which, struct itimerval __user *, value);
+trace_event_syscall_exit(getitimer);
+#define ENTERCASEgetitimer create_syscall_enter(2, getitimer, int, struct itimerval __user *);
+#define EXITCASEgetitimer create_syscall_exit(getitimer);
+#else
+#define ENTERCASEgetitimer
+#define EXITCASEgetitimer
+#endif
+
+#ifdef __NR_setitimer
+trace_event_syscall_enter(3, setitimer, int, which, struct itimerval __user *, value, struct itimerval __user *, ovalue);
+trace_event_syscall_exit(setitimer);
+#define ENTERCASEsetitimer create_syscall_enter(3, setitimer, int, struct itimerval __user *, struct itimerval __user *);
+#define EXITCASEsetitimer create_syscall_exit(setitimer);
+#else
+#define ENTERCASEsetitimer
+#define EXITCASEsetitimer
+#endif
+
+#ifdef __NR_timer_create
+trace_event_syscall_enter(3, timer_create, clockid_t, which_clock, struct sigevent __user *, timer_event_spec, timer_t __user *, created_timer_id);
+trace_event_syscall_exit(timer_create);
+#define ENTERCASEtimer_create create_syscall_enter(3, timer_create, clockid_t, struct sigevent __user *, timer_t __user *);
+#define EXITCASEtimer_create create_syscall_exit(timer_create);
+#else
+#define ENTERCASEtimer_create
+#define EXITCASEtimer_create
+#endif
+
+#ifdef __NR_timer_gettime
+TRACE_EVENT(sysenter_timer_gettime,
+        TP_PROTO(clockid_t which_clock, struct timespec __user *tp),
+        TP_ARGS(which_clock, tp),
+        TP_STRUCT__entry(
+                __field(clockid_t, which_clock)
+                __field(struct timespec __user *, tp)
+        ),
+        TP_fast_assign(
+                __entry->which_clock = which_clock;
+                __entry->tp = tp;
+        ),
+        TP_printk("%s %016Lx", clock_id_toname((u64)__entry->which_clock), (u64)__entry->tp)
+);
+trace_event_syscall_exit(timer_gettime);
+#define ENTERCASEtimer_gettime create_syscall_enter(2, timer_gettime, clockid_t, struct timespec __user *);
+#define EXITCASEtimer_gettime create_syscall_exit(timer_gettime);
+#else
+#define ENTERCASEtimer_gettime
+#define EXITCASEtimer_gettime
+#endif
+
+#ifdef __NR_timer_getoverrun
+trace_event_syscall_enter(1, timer_getoverrun, timer_t, timer_id);
+trace_event_syscall_exit(timer_getoverrun);
+#define ENTERCASEtimer_getoverrun create_syscall_enter(1, timer_getoverrun, timer_t);
+#define EXITCASEtimer_getoverrun create_syscall_exit(timer_getoverrun);
+#else
+#define ENTERCASEtimer_getoverrun
+#define EXITCASEtimer_getoverrun
+#endif
+
+#ifdef __NR_timer_settime
+trace_event_syscall_enter(4, timer_settime, timer_t, timer_id, int, flags, const struct itimerspec __user *, new_setting, struct itimerspec __user *, old_setting);
+trace_event_syscall_exit(timer_settime);
+#define ENTERCASEtimer_settime create_syscall_enter(4, timer_settime, timer_t, int, const struct itimerspec __user *, struct itimerspec __user *);
+#define EXITCASEtimer_settime create_syscall_exit(timer_settime);
+#else
+#define ENTERCASEtimer_settime
+#define EXITCASEtimer_settime
+#endif
+
+#ifdef __NR_timer_delete
+trace_event_syscall_enter(1, timer_delete, timer_t, timer_id);
+trace_event_syscall_exit(timer_delete);
+#define ENTERCASEtimer_delete create_syscall_enter(1, timer_delete, timer_t);
+#define EXITCASEtimer_delete create_syscall_exit(timer_delete);
+#else
+#define ENTERCASEtimer_delete
+#define EXITCASEtimer_delete
+#endif
+
+#ifdef __NR_clock_settime
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
+#define ENTERCASEclock_settime create_syscall_enter(2, clock_settime, clockid_t, struct timespec __user *);
+#define EXITCASEclock_settime create_syscall_exit(clock_settime);
+#else
+#define ENTERCASEclock_settime
+#define EXITCASEclock_settime
+#endif
+
+#ifdef __NR_clock_gettime
+trace_event_syscall_enter(2, clock_gettime, clockid_t, which_clock, struct timespec __user *, tp);
+trace_event_syscall_exit(clock_gettime);
+#define ENTERCASEclock_gettime create_syscall_enter(2, clock_gettime, clockid_t, struct timespec __user *);
+#define EXITCASEclock_gettime create_syscall_exit(clock_gettime);
+#else
+#define ENTERCASEclock_gettime
+#define EXITCASEclock_gettime
+#endif
+
+#ifdef __NR_clock_getres
+trace_event_syscall_enter(2, clock_getres, clockid_t, which_clock, struct timespec __user *, tp);
+trace_event_syscall_exit(clock_getres);
+#define ENTERCASEclock_getres create_syscall_enter(2, clock_getres, clockid_t, struct timespec __user *);
+#define EXITCASEclock_getres create_syscall_exit(clock_getres);
+#else
+#define ENTERCASEclock_getres
+#define EXITCASEclock_getres
+#endif
+
+#ifdef __NR_clock_nanosleep
+trace_event_syscall_enter(4, clock_nanosleep, clockid_t, which_clock, int, flags, const struct timespec __user *, rqtp, struct timespec __user *, rmtp);
+trace_event_syscall_exit(clock_nanosleep);
+#define ENTERCASEclock_nanosleep create_syscall_enter(4, clock_nanosleep, clockid_t, int, const struct timespec __user *, struct timespec __user *);
+#define EXITCASEclock_nanosleep create_syscall_exit(clock_nanosleep);
+#else
+#define ENTERCASEclock_nanosleep
+#define EXITCASEclock_nanosleep
+#endif
+
+#ifdef __NR_nice
+trace_event_syscall_enter(1, nice, int, increment);
+trace_event_syscall_exit(nice);
+#define ENTERCASEnice create_syscall_enter(1, nice, int);
+#define EXITCASEnice create_syscall_exit(nice);
+#else
+#define ENTERCASEnice
+#define EXITCASEnice
+#endif
+
+#ifdef __NR_sched_setscheduler
+trace_event_syscall_enter(3, sched_setscheduler, pid_t, pid, int, policy, struct sched_param __user *, param);
+trace_event_syscall_exit(sched_setscheduler);
+#define ENTERCASEsched_setscheduler create_syscall_enter(3, sched_setscheduler, pid_t, int, struct sched_param __user *);
+#define EXITCASEsched_setscheduler create_syscall_exit(sched_setscheduler);
+#else
+#define ENTERCASEsched_setscheduler
+#define EXITCASEsched_setscheduler
+#endif
+
+#ifdef __NR_sched_setparam
+trace_event_syscall_enter(2, sched_setparam, pid_t, pid, struct sched_param __user *, param);
+trace_event_syscall_exit(sched_setparam);
+#define ENTERCASEsched_setparam create_syscall_enter(2, sched_setparam, pid_t, struct sched_param __user *);
+#define EXITCASEsched_setparam create_syscall_exit(sched_setparam);
+#else
+#define ENTERCASEsched_setparam
+#define EXITCASEsched_setparam
+#endif
+
+#ifdef __NR_sched_getscheduler
+trace_event_syscall_enter(1, sched_getscheduler, pid_t, pid);
+trace_event_syscall_exit(sched_getscheduler);
+#define ENTERCASEsched_getscheduler create_syscall_enter(1, sched_getscheduler, pid_t);
+#define EXITCASEsched_getscheduler create_syscall_exit(sched_getscheduler);
+#else
+#define ENTERCASEsched_getscheduler
+#define EXITCASEsched_getscheduler
+#endif
+
+#ifdef __NR_sched_getparam
+trace_event_syscall_enter(2, sched_getparam, pid_t, pid, struct sched_param __user *, param);
+trace_event_syscall_exit(sched_getparam);
+#define ENTERCASEsched_getparam create_syscall_enter(2, sched_getparam, pid_t, struct sched_param __user *);
+#define EXITCASEsched_getparam create_syscall_exit(sched_getparam);
+#else
+#define ENTERCASEsched_getparam
+#define EXITCASEsched_getparam
+#endif
+
+#ifdef __NR_sched_setaffinity
+trace_event_syscall_enter(3, sched_setaffinity, pid_t, pid, unsigned int, len, unsigned long __user *, user_mask_ptr);
+trace_event_syscall_exit(sched_setaffinity);
+#define ENTERCASEsched_setaffinity create_syscall_enter(3, sched_setaffinity, pid_t, unsigned int, unsigned long __user *);
+#define EXITCASEsched_setaffinity create_syscall_exit(sched_setaffinity);
+#else
+#define ENTERCASEsched_setaffinity
+#define EXITCASEsched_setaffinity
+#endif
+
+#ifdef __NR_sched_getaffinity
+trace_event_syscall_enter(3, sched_getaffinity, pid_t, pid, unsigned int, len, unsigned long __user *, user_mask_ptr);
+trace_event_syscall_exit(sched_getaffinity);
+#define ENTERCASEsched_getaffinity create_syscall_enter(3, sched_getaffinity, pid_t, unsigned int, unsigned long __user *);
+#define EXITCASEsched_getaffinity create_syscall_exit(sched_getaffinity);
+#else
+#define ENTERCASEsched_getaffinity
+#define EXITCASEsched_getaffinity
+#endif
+
+#ifdef __NR_sched_yield
+trace_event_syscall_enter(0, sched_yield);
+trace_event_syscall_exit(sched_yield);
+#define ENTERCASEsched_yield create_syscall_enter(0, sched_yield);
+#define EXITCASEsched_yield create_syscall_exit(sched_yield);
+#else
+#define ENTERCASEsched_yield
+#define EXITCASEsched_yield
+#endif
+
+#ifdef __NR_sched_get_priority_max
+trace_event_syscall_enter(1, sched_get_priority_max, int, policy);
+trace_event_syscall_exit(sched_get_priority_max);
+#define ENTERCASEsched_get_priority_max create_syscall_enter(1, sched_get_priority_max, int);
+#define EXITCASEsched_get_priority_max create_syscall_exit(sched_get_priority_max);
+#else
+#define ENTERCASEsched_get_priority_max
+#define EXITCASEsched_get_priority_max
+#endif
+
+#ifdef __NR_sched_get_priority_min
+trace_event_syscall_enter(1, sched_get_priority_min, int, policy);
+trace_event_syscall_exit(sched_get_priority_min);
+#define ENTERCASEsched_get_priority_min create_syscall_enter(1, sched_get_priority_min, int);
+#define EXITCASEsched_get_priority_min create_syscall_exit(sched_get_priority_min);
+#else
+#define ENTERCASEsched_get_priority_min
+#define EXITCASEsched_get_priority_min
+#endif
+
+#ifdef __NR_sched_rr_get_interval
+trace_event_syscall_enter(2, sched_rr_get_interval, pid_t, pid, struct timespec __user *, interval);
+trace_event_syscall_exit(sched_rr_get_interval);
+#define ENTERCASEsched_rr_get_interval create_syscall_enter(2, sched_rr_get_interval, pid_t, struct timespec __user *);
+#define EXITCASEsched_rr_get_interval create_syscall_exit(sched_rr_get_interval);
+#else
+#define ENTERCASEsched_rr_get_interval
+#define EXITCASEsched_rr_get_interval
+#endif
+
+#ifdef __NR_setpriority
+trace_event_syscall_enter(3, setpriority, int, which, int, who, int, niceval);
+trace_event_syscall_exit(setpriority);
+#define ENTERCASEsetpriority create_syscall_enter(3, setpriority, int, int, int);
+#define EXITCASEsetpriority create_syscall_exit(setpriority);
+#else
+#define ENTERCASEsetpriority
+#define EXITCASEsetpriority
+#endif
+
+#ifdef __NR_getpriority
+trace_event_syscall_enter(2, getpriority, int, which, int, who);
+trace_event_syscall_exit(getpriority);
+#define ENTERCASEgetpriority create_syscall_enter(2, getpriority, int, int);
+#define EXITCASEgetpriority create_syscall_exit(getpriority);
+#else
+#define ENTERCASEgetpriority
+#define EXITCASEgetpriority
+#endif
+
+#ifdef __NR_shutdown
+trace_event_syscall_enter(2, shutdown, int, a, int, b);
+trace_event_syscall_exit(shutdown);
+#define ENTERCASEshutdown create_syscall_enter(2, shutdown, int, int);
+#define EXITCASEshutdown create_syscall_exit(shutdown);
+#else
+#define ENTERCASEshutdown
+#define EXITCASEshutdown
+#endif
+
+#ifdef __NR_reboot
+trace_event_syscall_enter(4, reboot, int, magic1, int, magic2, unsigned int, cmd, void __user *, arg);
+trace_event_syscall_exit(reboot);
+#define ENTERCASEreboot create_syscall_enter(4, reboot, int, int, unsigned int, void __user *);
+#define EXITCASEreboot create_syscall_exit(reboot);
+#else
+#define ENTERCASEreboot
+#define EXITCASEreboot
+#endif
+
+#ifdef __NR_restart_syscall
+trace_event_syscall_enter(0, restart_syscall);
+trace_event_syscall_exit(restart_syscall);
+#define ENTERCASErestart_syscall create_syscall_enter(0, restart_syscall);
+#define EXITCASErestart_syscall create_syscall_exit(restart_syscall);
+#else
+#define ENTERCASErestart_syscall
+#define EXITCASErestart_syscall
+#endif
+
+#ifdef __NR_kexec_load
+trace_event_syscall_enter(4, kexec_load, unsigned long, e, unsigned long, nr_segments, struct kexec_segment __user *, segments, unsigned long, flags);
+trace_event_syscall_exit(kexec_load);
+#define ENTERCASEkexec_load create_syscall_enter(4, kexec_load, unsigned long, unsigned long, struct kexec_segment __user *, unsigned long);
+#define EXITCASEkexec_load create_syscall_exit(kexec_load);
+#else
+#define ENTERCASEkexec_load
+#define EXITCASEkexec_load
+#endif
+
+#ifdef __NR_exit
+trace_event_syscall_enter(1, exit, int, error_code);
+trace_event_syscall_exit(exit);
+#define ENTERCASEexit create_syscall_enter(1, exit, int);
+#define EXITCASEexit create_syscall_exit(exit);
+#else
+#define ENTERCASEexit
+#define EXITCASEexit
+#endif
+
+#ifdef __NR_exit_group
+trace_event_syscall_enter(1, exit_group, int, error_code);
+trace_event_syscall_exit(exit_group);
+#define ENTERCASEexit_group create_syscall_enter(1, exit_group, int);
+#define EXITCASEexit_group create_syscall_exit(exit_group);
+#else
+#define ENTERCASEexit_group
+#define EXITCASEexit_group
+#endif
+
+#ifdef __NR_wait4
+trace_event_syscall_enter(4, wait4, pid_t, pid, int __user *, stat_addr, int, options, struct rusage __user *, ru);
+trace_event_syscall_exit(wait4);
+#define ENTERCASEwait4 create_syscall_enter(4, wait4, pid_t, int __user *, int, struct rusage __user *);
+#define EXITCASEwait4 create_syscall_exit(wait4);
+#else
+#define ENTERCASEwait4
+#define EXITCASEwait4
+#endif
+
+#ifdef __NR_waitid
+trace_event_syscall_enter(5, waitid, int, which, pid_t, pid, struct siginfo __user *, infop, int, options, struct rusage __user *, ru);
+trace_event_syscall_exit(waitid);
+#define ENTERCASEwaitid create_syscall_enter(5, waitid, int, pid_t, struct siginfo __user *, int, struct rusage __user *);
+#define EXITCASEwaitid create_syscall_exit(waitid);
+#else
+#define ENTERCASEwaitid
+#define EXITCASEwaitid
+#endif
+
+#ifdef __NR_waitpid
+trace_event_syscall_enter(3, waitpid, pid_t, pid, int __user *, stat_addr, int, options);
+trace_event_syscall_exit(waitpid);
+#define ENTERCASEwaitpid create_syscall_enter(3, waitpid, pid_t, int __user *, int);
+#define EXITCASEwaitpid create_syscall_exit(waitpid);
+#else
+#define ENTERCASEwaitpid
+#define EXITCASEwaitpid
+#endif
+
+#ifdef __NR_set_tid_address
+trace_event_syscall_enter(1, set_tid_address, int __user *, tidptr);
+trace_event_syscall_exit(set_tid_address);
+#define ENTERCASEset_tid_address create_syscall_enter(1, set_tid_address, int __user *);
+#define EXITCASEset_tid_address create_syscall_exit(set_tid_address);
+#else
+#define ENTERCASEset_tid_address
+#define EXITCASEset_tid_address
+#endif
+
+#ifdef __NR_futex
+trace_event_syscall_enter(6, futex, u32 __user *, uaddr, int, op, u32, val, struct timespec __user *, utime, u32 __user *, uaddr2, u32, val3);
+trace_event_syscall_exit(futex);
+#define ENTERCASEfutex create_syscall_enter(6, futex, u32 __user *, int, u32, struct timespec __user *, u32 __user *, u32);
+#define EXITCASEfutex create_syscall_exit(futex);
+#else
+#define ENTERCASEfutex
+#define EXITCASEfutex
+#endif
+
+#ifdef __NR_init_module
+trace_event_syscall_enter(3, init_module, void __user *, umod, unsigned long, len, const char __user *, uargs);
+trace_event_syscall_exit(init_module);
+#define ENTERCASEinit_module create_syscall_enter(3, init_module, void __user *, unsigned long, const char __user *);
+#define EXITCASEinit_module create_syscall_exit(init_module);
+#else
+#define ENTERCASEinit_module
+#define EXITCASEinit_module
+#endif
+
+#ifdef __NR_delete_module
+trace_event_syscall_enter(2, delete_module, const char __user *, name_user, unsigned int, flags);
+trace_event_syscall_exit(delete_module);
+#define ENTERCASEdelete_module create_syscall_enter(2, delete_module, const char __user *, unsigned int);
+#define EXITCASEdelete_module create_syscall_exit(delete_module);
+#else
+#define ENTERCASEdelete_module
+#define EXITCASEdelete_module
+#endif
+
+#ifdef __NR_rt_sigprocmask
+trace_event_syscall_enter(4, rt_sigprocmask, int, how, sigset_t __user *, set, sigset_t __user *, oset, size_t, sigsetsize);
+trace_event_syscall_exit(rt_sigprocmask);
+#define ENTERCASErt_sigprocmask create_syscall_enter(4, rt_sigprocmask, int, sigset_t __user *, sigset_t __user *, size_t);
+#define EXITCASErt_sigprocmask create_syscall_exit(rt_sigprocmask);
+#else
+#define ENTERCASErt_sigprocmask
+#define EXITCASErt_sigprocmask
+#endif
+
+#ifdef __NR_rt_sigpending
+trace_event_syscall_enter(2, rt_sigpending, sigset_t __user *, set, size_t, sigsetsize);
+trace_event_syscall_exit(rt_sigpending);
+#define ENTERCASErt_sigpending create_syscall_enter(2, rt_sigpending, sigset_t __user *, size_t);
+#define EXITCASErt_sigpending create_syscall_exit(rt_sigpending);
+#else
+#define ENTERCASErt_sigpending
+#define EXITCASErt_sigpending
+#endif
+
+#ifdef __NR_rt_sigtimedwait
+trace_event_syscall_enter(4, rt_sigtimedwait, const sigset_t __user *, uthese, siginfo_t __user *, uinfo, const struct timespec __user *, uts, size_t, sigsetsize);
+trace_event_syscall_exit(rt_sigtimedwait);
+#define ENTERCASErt_sigtimedwait create_syscall_enter(4, rt_sigtimedwait, const sigset_t __user *, siginfo_t __user *, const struct timespec __user *, size_t);
+#define EXITCASErt_sigtimedwait create_syscall_exit(rt_sigtimedwait);
+#else
+#define ENTERCASErt_sigtimedwait
+#define EXITCASErt_sigtimedwait
+#endif
+
+#ifdef __NR_kill
+trace_event_syscall_enter(2, kill, int, pid, int, sig);
+trace_event_syscall_exit(kill);
+#define ENTERCASEkill create_syscall_enter(2, kill, int, int);
+#define EXITCASEkill create_syscall_exit(kill);
+#else
+#define ENTERCASEkill
+#define EXITCASEkill
+#endif
+
+#ifdef __NR_tgkill
+trace_event_syscall_enter(3, tgkill, int, tgid, int, pid, int, sig);
+trace_event_syscall_exit(tgkill);
+#define ENTERCASEtgkill create_syscall_enter(3, tgkill, int, int, int);
+#define EXITCASEtgkill create_syscall_exit(tgkill);
+#else
+#define ENTERCASEtgkill
+#define EXITCASEtgkill
+#endif
+
+#ifdef __NR_tkill
+trace_event_syscall_enter(2, tkill, int, pid, int, sig);
+trace_event_syscall_exit(tkill);
+#define ENTERCASEtkill create_syscall_enter(2, tkill, int, int);
+#define EXITCASEtkill create_syscall_exit(tkill);
+#else
+#define ENTERCASEtkill
+#define EXITCASEtkill
+#endif
+
+#ifdef __NR_rt_sigqueueinfo
+trace_event_syscall_enter(3, rt_sigqueueinfo, int, pid, int, sig, siginfo_t __user *, uinfo);
+trace_event_syscall_exit(rt_sigqueueinfo);
+#define ENTERCASErt_sigqueueinfo create_syscall_enter(3, rt_sigqueueinfo, int, int, siginfo_t __user *);
+#define EXITCASErt_sigqueueinfo create_syscall_exit(rt_sigqueueinfo);
+#else
+#define ENTERCASErt_sigqueueinfo
+#define EXITCASErt_sigqueueinfo
+#endif
+
+#ifdef __NR_sgetmask
+trace_event_syscall_enter(0, sgetmask);
+trace_event_syscall_exit(sgetmask);
+#define ENTERCASEsgetmask create_syscall_enter(0, sgetmask);
+#define EXITCASEsgetmask create_syscall_exit(sgetmask);
+#else
+#define ENTERCASEsgetmask
+#define EXITCASEsgetmask
+#endif
+
+#ifdef __NR_ssetmask
+trace_event_syscall_enter(1, ssetmask, int, newmask);
+trace_event_syscall_exit(ssetmask);
+#define ENTERCASEssetmask create_syscall_enter(1, ssetmask, int);
+#define EXITCASEssetmask create_syscall_exit(ssetmask);
+#else
+#define ENTERCASEssetmask
+#define EXITCASEssetmask
+#endif
+
+#ifdef __NR_signal
+trace_event_syscall_enter(2, signal, int, sig, __sighandler_t, handler);
+trace_event_syscall_exit(signal);
+#define ENTERCASEsignal create_syscall_enter(2, signal, int, __sighandler_t);
+#define EXITCASEsignal create_syscall_exit(signal);
+#else
+#define ENTERCASEsignal
+#define EXITCASEsignal
+#endif
+
+#ifdef __NR_pause
+trace_event_syscall_enter(0, pause);
+trace_event_syscall_exit(pause);
+#define ENTERCASEpause create_syscall_enter(0, pause);
+#define EXITCASEpause create_syscall_exit(pause);
+#else
+#define ENTERCASEpause
+#define EXITCASEpause
+#endif
+
+#ifdef __NR_sync
+trace_event_syscall_enter(0, sync);
+trace_event_syscall_exit(sync);
+#define ENTERCASEsync create_syscall_enter(0, sync);
+#define EXITCASEsync create_syscall_exit(sync);
+#else
+#define ENTERCASEsync
+#define EXITCASEsync
+#endif
+
+#ifdef __NR_fsync
+trace_event_syscall_enter(1, fsync, unsigned int, fd);
+trace_event_syscall_exit(fsync);
+#define ENTERCASEfsync create_syscall_enter(1, fsync, unsigned int);
+#define EXITCASEfsync create_syscall_exit(fsync);
+#else
+#define ENTERCASEfsync
+#define EXITCASEfsync
+#endif
+
+#ifdef __NR_fdatasync
+trace_event_syscall_enter(1, fdatasync, unsigned int, fd);
+trace_event_syscall_exit(fdatasync);
+#define ENTERCASEfdatasync create_syscall_enter(1, fdatasync, unsigned int);
+#define EXITCASEfdatasync create_syscall_exit(fdatasync);
+#else
+#define ENTERCASEfdatasync
+#define EXITCASEfdatasync
+#endif
+
+#ifdef __NR_bdflush
+trace_event_syscall_enter(2, bdflush, int, func, long, data);
+trace_event_syscall_exit(bdflush);
+#define ENTERCASEbdflush create_syscall_exit(2, bdflush, int long);
+#define EXITCASEbdflush create_syscall_exit(bdflush);
+#else
+#define ENTERCASEbdflush
+#define EXITCASEbdflush
+#endif
+
+#ifdef __NR_mount
+trace_event_syscall_enter(5, mount, char __user *, dev_name, char __user *, dir_name, char __user *, type, unsigned long, flags, void __user *, data);
+trace_event_syscall_exit(mount);
+#define ENTERCASEmount create_syscall_enter(5, mount, char __user *, char __user *, char __user *, unsigned long, void __user *);
+#define EXITCASEmount create_syscall_exit(mount);
+#else
+#define ENTERCASEmount
+#define EXITCASEmount
+#endif
+
+#ifdef __NR_umount
+trace_event_syscall_enter(2, umount, char __user *, name, int, flags);
+trace_event_syscall_exit(umount);
+#define ENTERCASEumount create_syscall_enter(2, umount, char __user *, int);
+#define EXITCASEumount create_syscall_exit(umount);
+#else
+#define ENTERCASEumount
+#define EXITCASEumount
+#endif
+
+#ifdef __NR_oldumount
+trace_event_syscall_enter(1, oldumount, char __user *, name);
+trace_event_syscall_exit(oldumount);
+#define ENTERCASEoldumount create_syscall_enter(1, oldumount, char __user );
+#define EXITCASEoldumount create_syscall_exit(oldumount);
+#else
+#define ENTERCASEoldumount
+#define EXITCASEoldumount
+#endif
+
+#ifdef __NR_truncate
+trace_event_syscall_enter(2, truncate, const char __user *, path, unsigned long, length);
+trace_event_syscall_exit(truncate);
+#define ENTERCASEtruncate create_syscall_enter(2, truncate, const char __user *, unsigned long);
+#define EXITCASEtruncate create_syscall_exit(truncate);
+#else
+#define ENTERCASEtruncate
+#define EXITCASEtruncate
+#endif
+
+#ifdef __NR_ftruncate
+trace_event_syscall_enter(2, ftruncate, unsigned int, fd, unsigned long, length);
+trace_event_syscall_exit(ftruncate);
+#define ENTERCASEftruncate create_syscall_enter(2, ftruncate, unsigned int, unsigned long);
+#define EXITCASEftruncate create_syscall_exit(ftruncate);
+#else
+#define ENTERCASEftruncate
+#define EXITCASEftruncate
+#endif
+
+#ifdef __NR_stat
+trace_event_syscall_enter(2, stat, char __user *, filename, struct __old_kernel_stat __user *, statbuf);
+trace_event_syscall_exit(stat);
+#define ENTERCASEstat create_syscall_enter(2, stat, char __user *, struct __old_kernel_stat __user *);
+#define EXITCASEstat create_syscall_exit(stat);
+#else
+#define ENTERCASEstat
+#define EXITCASEstat
+#endif
+
+#ifdef __NR_statfs
+trace_event_syscall_enter(2, statfs, const char __user *, path, struct statfs __user *, buf);
+trace_event_syscall_exit(statfs);
+#define ENTERCASEstatfs create_syscall_enter(2, statfs, const char __user *, struct statfs __user *);
+#define EXITCASEstatfs create_syscall_exit(statfs);
+#else
+#define ENTERCASEstatfs
+#define EXITCASEstatfs
+#endif
+
+#ifdef __NR_statfs64
+trace_event_syscall_enter(3, statfs64, const char __user *, path, size_t, sz, struct statfs64 __user *, buf);
+trace_event_syscall_exit(statfs64);
+#define ENTERCASEstatfs64 create_syscall_enter(2, statfs64, const char __user *, size_t, struct statfs64 __user *);
+#define EXITCASEstatfs64 create_syscall_exit(statfs64);
+#else
+#define ENTERCASEstatfs64
+#define EXITCASEstatfs64
+#endif
+
+#ifdef __NR_fstatfs
+trace_event_syscall_enter(2, fstatfs, unsigned int, fd, struct statfs __user *, buf);
+trace_event_syscall_exit(fstatfs);
+#define ENTERCASEfstatfs create_syscall_enter(2, fstatfs, unsigned int, struct statfs __user *);
+#define EXITCASEfstatfs create_syscall_exit(fstatfs);
+#else
+#define ENTERCASEfstatfs
+#define EXITCASEfstatfs
+#endif
+
+#ifdef __NR_fstatfs64
+trace_event_syscall_enter(3, fstatfs64, unsigned int, fd, size_t, sz, struct statfs64 __user *, buf);
+trace_event_syscall_exit(fstatfs64);
+#define ENTERCASEfstatfs64 create_syscall_enter(3, fstatfs64, unsigned int, size_t, struct statfs64 __user *);
+#define EXITCASEfstatfs64 create_syscall_exit(fstatfs64);
+#else
+#define ENTERCASEfstatfs64
+#define EXITCASEfstatfs64
+#endif
+
+#ifdef __NR_lstat
+trace_event_syscall_enter(2, lstat, char __user *, filename, struct __old_kernel_stat __user *, statbuf);
+trace_event_syscall_exit(lstat);
+#define ENTERCASElstat create_syscall_enter(2, lstat, char __user *, struct __old_kernel_stat __user *);
+#define EXITCASElstat create_syscall_exit(lstat);
+#else
+#define ENTERCASElstat
+#define EXITCASElstat
+#endif
+
+#ifdef __NR_fstat
+trace_event_syscall_enter(2, fstat, unsigned int, fd, struct __old_kernel_stat __user *, statbuf);
+trace_event_syscall_exit(fstat);
+#define ENTERCASEfstat create_syscall_enter(2, fstat, unsigned int, struct __old_kernel_stat __user *);
+#define EXITCASEfstat create_syscall_exit(fstat);
+#else
+#define ENTERCASEfstat
+#define EXITCASEfstat
+#endif
+
+#ifdef __NR_newstat
+trace_event_syscall_enter(2, newstat, char __user *, filename, struct stat __user *, statbuf);
+trace_event_syscall_exit(newstat);
+#define ENTERCASEnewstat create_syscall_enter(2, newstat, char __user *, struct stat __user *);
+#define EXITCASEnewstat create_syscall_exit(newstat);
+#else
+#define ENTERCASEnewstat
+#define EXITCASEnewstat
+#endif
+
+#ifdef __NR_newlstat
+trace_event_syscall_enter(2, newlstat, char __user *, filename, struct stat __user *, statbuf);
+trace_event_syscall_exit(newlstat);
+#define ENTERCASEnewlstat create_syscall_enter(2, newlstat,  char __user *, struct stat __user *);
+#define EXITCASEnewlstat create_syscall_exit(newlstat);
+#else
+#define ENTERCASEnewlstat
+#define EXITCASEnewlstat
+#endif
+
+#ifdef __NR_newfstat
+trace_event_syscall_enter(2, newfstat, unsigned int, fd, struct stat __user *, statbuf);
+trace_event_syscall_exit(newfstat);
+#define ENTERCASEnewfstat create_syscall_enter(2, newfstat, unsigned int, struct stat __user *);
+#define EXITCASEnewfstat create_syscall_exit(newfstat);
+#else
+#define ENTERCASEnewfstat
+#define EXITCASEnewfstat
+#endif
+
+#ifdef __NR_ustat
+trace_event_syscall_enter(2, ustat, unsigned, dev, struct ustat __user *, ubuf);
+trace_event_syscall_exit(ustat);
+#define ENTERCASEustat create_syscall_enter(2, ustat, unsigned, struct ustat __user *);
+#define EXITCASEustat create_syscall_exit(ustat);
+#else
+#define ENTERCASEustat
+#define EXITCASEustat
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_stat64)
+trace_event_syscall_enter(2, stat64, char __user *, filename, struct stat64 __user *, statbuf);
+trace_event_syscall_exit(stat64);
+#define ENTERCASEstat64 create_syscall_enter(2, stat64, char __user *, struct stat64 __user *);
+#define EXITCASEstat64 create_syscall_exit(stat64);
+#else
+#define ENTERCASEstat64
+#define EXITCASEstat64
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_fstat64)
+trace_event_syscall_enter(2, fstat64, char __user *, filename, struct stat64 __user *, statbuf);
+trace_event_syscall_exit(fstat64);
+#define ENTERCASEfstat64 create_syscall_enter(2, fstat64, char __user *, struct stat64 __user *);
+#define EXITCASEfstat64 create_syscall_exit(fstat64);
+#else
+#define ENTERCASEfstat64
+#define EXITCASEfstat64
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_lstat64)
+trace_event_syscall_enter(2, lstat64, char __user *, filename, struct stat64 __user *, statbuf);
+trace_event_syscall_exit(lstat64);
+#define ENTERCASElstat64 create_syscall_enter(2, lstat64, char __user *, struct stat64 __user *);
+#define EXITCASElstat64 create_syscall_exit(lstat64);
+#else
+#define ENTERCASElstat64
+#define EXITCASElstat64
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_truncate64)
+trace_event_syscall_enter(2, truncate64, const char __user *, path, loff_t, length);
+trace_event_syscall_exit(truncate64);
+#define ENTERCASEtruncate64 create_syscall_enter(2, truncate64, const char __user *, loff_t);
+#define EXITCASEtruncate64 create_syscall_exit(truncate64);
+#else
+#define ENTERCASEtruncate64
+#define EXITCASEtruncate64
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_ftruncate64)
+trace_event_syscall_enter(2, ftruncate64, unsigned int, fd, loff_t, length);
+trace_event_syscall_exit(ftruncate64);
+#define ENTERCASEftruncate64 create_syscall_enter(2, ftruncate64, unsigned int, loff_t);
+#define EXITCASEftruncate64 create_syscall_exit(ftruncate64);
+#else
+#define ENTERCASEftruncate64
+#define EXITCASEftruncate64
+#endif
+
+#ifdef __NR_setxattr
+trace_event_syscall_enter(5, setxattr, const char __user *, path, const char __user *, name, const void __user *, value, size_t, size, int, flags);
+trace_event_syscall_exit(setxattr);
+#define ENTERCASEsetxattr create_syscall_enter(5, setxattr, const char __user *, const char __user *, const void __user *, size_t, int);
+#define EXITCASEsetxattr create_syscall_exit(setxattr);
+#else
+#define ENTERCASEsetxattr
+#define EXITCASEsetxattr
+#endif
+
+#ifdef __NR_lsetxattr
+trace_event_syscall_enter(5, lsetxattr, const char __user *, path, const char __user *, name, const void __user *, value, size_t, size, int, flags);
+trace_event_syscall_exit(lsetxattr);
+#define ENTERCASElsetxattr create_syscall_enter(5, lsetxattr, const char __user *, const char __user *, const void __user *, size_t, int);
+#define EXITCASElsetxattr create_syscall_exit(lsetxattr);
+#else
+#define ENTERCASElsetxattr
+#define EXITCASElsetxattr
+#endif
+
+#ifdef __NR_fsetxattr
+trace_event_syscall_enter(5, fsetxattr, int, fd, const char __user *, name, const void __user *, value, size_t, size, int, flags);
+trace_event_syscall_exit(fsetxattr);
+#define ENTERCASEfsetxattr create_syscall_enter(5, fsetxattr, int, const char __user *, const void __user *, size_t, int);
+#define EXITCASEfsetxattr create_syscall_exit(fsetxattr);
+#else
+#define ENTERCASEfsetxattr
+#define EXITCASEfsetxattr
+#endif
+
+#ifdef __NR_getxattr
+trace_event_syscall_enter(4, getxattr, const char __user *, path, const char __user *, name, void __user *, value, size_t, size);
+trace_event_syscall_exit(getxattr);
+#define ENTERCASEgetxattr create_syscall_enter(4, getxattr, const char __user *, const char __user *, void __user *, size_t);
+#define EXITCASEgetxattr create_syscall_exit(getxattr);
+#else
+#define ENTERCASEgetxattr
+#define EXITCASEgetxattr
+#endif
+
+#ifdef __NR_lgetxattr
+trace_event_syscall_enter(4, lgetxattr, const char __user *, path, const char __user *, name, void __user *, value, size_t, size);
+trace_event_syscall_exit(lgetxattr);
+#define ENTERCASElgetxattr create_syscall_enter(4, lgetxattr, const char __user *, const char __user *, void __user *, size_t);
+#define EXITCASElgetxattr create_syscall_exit(lgetxattr);
+#else
+#define ENTERCASElgetxattr
+#define EXITCASElgetxattr
+#endif
+
+#ifdef __NR_fgetxattr
+trace_event_syscall_enter(4, fgetxattr, int, fd, const char __user *, name, void __user *, value, size_t, size);
+trace_event_syscall_exit(fgetxattr);
+#define ENTERCASEfgetxattr create_syscall_enter(4, fgetxattr, int, const char __user *, void __user *, size_t);
+#define EXITCASEfgetxattr create_syscall_exit(fgetxattr);
+#else
+#define ENTERCASEfgetxattr
+#define EXITCASEfgetxattr
+#endif
+
+#ifdef _NR_listxattr
+trace_event_syscall_enter(3, listxattr, const char __user *, path, char __user *, list, size_t, size);
+trace_event_syscall_exit(listxattr);
+#define ENTERCASElistxattr create_syscall_enter(3, listxattr, const char __user *, char __user *, size_t);
+#define EXITCASElistxattr create_syscall_exit(listxattr);
+#else
+#define ENTERCASElistxattr
+#define EXITCASElistxattr
+#endif
+
+#ifdef __NR_llistxattr
+trace_event_syscall_enter(3, llistxattr, const char __user *, path, char __user *, list, size_t, size);
+trace_event_syscall_exit(llistxattr);
+#define ENTERCASEllistxattr create_syscall_enter(3, llistxattr, const char __user *, char __user *, size_t);
+#define EXITCASEllistxattr create_syscall_exit(llistxattr);
+#else
+#define ENTERCASEllistxattr
+#define EXITCASEllistxattr
+#endif
+
+#ifdef __NR_flistxattr
+trace_event_syscall_enter(3, flistxattr, int, fd, char __user *, list, size_t, size);
+trace_event_syscall_exit(flistxattr);
+#define ENTERCASEflistxattr create_syscall_enter(3, flistxattr, int, char __user *, size_t);
+#define EXITCASEflistxattr create_syscall_exit(flistxattr);
+#else
+#define ENTERCASEflistxattr
+#define EXITCASEflistxattr
+#endif
+
+#ifdef __NR_removexattr
+trace_event_syscall_enter(2, removexattr, const char __user *, path, const char __user *, name);
+trace_event_syscall_exit(removexattr);
+#define ENTERCASEremovexattr create_syscall_enter(2, removexattr, const char __user *, const char __user *);
+#define EXITCASEremovexattr create_syscall_exit(removexattr);
+#else
+#define ENTERCASEremovexattr
+#define EXITCASEremovexattr
+#endif
+
+#ifdef __NR_lremovexattr
+trace_event_syscall_enter(2, lremovexattr, const char __user *, path, const char __user *, name);
+trace_event_syscall_exit(lremovexattr);
+#define ENTERCASElremovexattr create_syscall_enter(2, lremovexattr, const char __user *, const char __user *);
+#define EXITCASElremovexattr create_syscall_exit(lremovexattr);
+#else
+#define ENTERCASElremovexattr
+#define EXITCASElremovexattr
+#endif
+
+#ifdef __NR_fremovexattr
+trace_event_syscall_enter(2, fremovexattr, int, fd, const char __user *, name);
+trace_event_syscall_exit(fremovexattr);
+#define ENTERCASEfremovexattr create_syscall_enter(2, fremovexattr, int, const char __user *);
+#define EXITCASEfremovexattr create_syscall_exit(fremovexattr);
+#else
+#define ENTERCASEfremovexattr
+#define EXITCASEfremovexattr
+#endif
+
+#ifdef __NR_brk
+trace_event_syscall_enter(1, brk, unsigned long, brk);
+trace_event_syscall_exit(brk);
+#define ENTERCASEbrk create_syscall_enter(1, brk, unsigned long);
+#define EXITCASEbrk create_syscall_exit(brk);
+#else
+#define ENTERCASEbrk
+#define EXITCASEbrk
+#endif
+
+#ifdef __NR_mprotect
+trace_event_syscall_enter(3, mprotect, unsigned long, start, size_t, len, unsigned long, prot);
+trace_event_syscall_exit(mprotect);
+#define ENTERCASEmprotect create_syscall_enter(3, mprotect, unsigned long, size_t, unsigned long);
+#define EXITCASEmprotect create_syscall_exit(mprotect);
+#else
+#define ENTERCASEmprotect
+#define EXITCASEmprotect
+#endif
+
+#ifdef __NR_mremap
+trace_event_syscall_enter(5, mremap, unsigned long, addr, unsigned long, old_len, unsigned long, new_len, unsigned long, flags, unsigned long, new_addr);
+trace_event_syscall_exit(mremap);
+#define ENTERCASEmremap create_syscall_enter(5, mremap, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
+#define EXITCASEmremap create_syscall_exit(mremap);
+#else
+#define ENTERCASEmremap
+#define EXITCASEmremap
+#endif
+
+#ifdef __NR_remap_file_pages
+trace_event_syscall_enter(5, remap_file_pages, unsigned long, start, unsigned long, size, unsigned long, prot, unsigned long, pgoff, unsigned long, flags);
+trace_event_syscall_exit(remap_file_pages);
+#define ENTERCASEremap_file_pages create_syscall_enter(5, remap_file_pages, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
+#define EXITCASEremap_file_pages create_syscall_exit(remap_file_pages);
+#else
+#define ENTERCASEremap_file_pages
+#define EXITCASEremap_file_pages
+#endif
+
+#ifdef __NR_msync
+trace_event_syscall_enter(3, msync, unsigned long, start, size_t, len, int, flags);
+trace_event_syscall_exit(msync);
+#define ENTERCASEmsync create_syscall_enter(3, msync, unsigned long, size_t, int);
+#define EXITCASEmsync create_syscall_exit(msync);
+#else
+#define ENTERCASEmsync
+#define EXITCASEmsync
+#endif
+
+#ifdef __NR_fadvise64
+trace_event_syscall_enter(4, fadvise64, int, fd, loff_t, offset, size_t, len, int, advice);
+trace_event_syscall_exit(fadvise64);
+#define ENTERCASEfadvise64 create_syscall_enter(4, fadvise64, int, loff_t, size_t, int);
+#define EXITCASEfadvise64 create_syscall_exit(fadvise64);
+#else
+#define ENTERCASEfadvise64
+#define EXITCASEfadvise64
+#endif
+
+#ifdef __NR_fadvise64_64
+trace_event_syscall_enter(4, fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice);
+trace_event_syscall_exit(fadvise64_64);
+#define ENTERCASEfadvise64_64 create_syscall_enter(4, fadvise64_64, int, loff_t, loff_t, int);
+#define EXITCASEfadvise64_64 create_syscall_exit(fadvise64_64);
+#else
+#define ENTERCASEfadvise64_64
+#define EXITCASEfadvise64_64
+#endif
+
+#ifdef __NR_munmap
+trace_event_syscall_enter(2, munmap, unsigned long, addr, size_t, len);
+trace_event_syscall_exit(munmap);
+#define ENTERCASEmunmap create_syscall_enter(2, munmap, unsigned long, size_t);
+#define EXITCASEmunmap create_syscall_exit(munmap);
+#else
+#define ENTERCASEmunmap
+#define EXITCASEmunmap
+#endif
+
+#ifdef __NR_mlock
+trace_event_syscall_enter(2, mlock, unsigned long, start, size_t, len);
+trace_event_syscall_exit(mlock);
+#define ENTERCASEmlock create_syscall_enter(2, mlock, unsigned long, size_t);
+#define EXITCASEmlock create_syscall_exit(mlock);
+#else
+#define ENTERCASEmlock
+#define EXITCASEmlock
+#endif
+
+#ifdef __NR_munlock
+trace_event_syscall_enter(2, munlock, unsigned long, start, size_t, len);
+trace_event_syscall_exit(munlock);
+#define ENTERCASEmunlock create_syscall_enter(2, munlock, unsigned long, size_t);
+#define EXITCASEmunlock create_syscall_exit(munlock);
+#else
+#define ENTERCASEmunlock
+#define EXITCASEmunlock
+#endif
+
+#ifdef __NR_mlockall
+trace_event_syscall_enter(1, mlockall, int, flags);
+trace_event_syscall_exit(mlockall);
+#define ENTERCASEmlockall create_syscall_enter(1, mlockall, int);
+#define EXITCASEmlockall create_syscall_exit(mlockall);
+#else
+#define ENTERCASEmlockall
+#define EXITCASEmlockall
+#endif
+
+#ifdef __NR_munlockall
+trace_event_syscall_enter(0, munlockall);
+trace_event_syscall_exit(munlockall);
+#define ENTERCASEmunlockall create_syscall_enter(0, munlockall);
+#define EXITCASEmunlockall create_syscall_exit(munlockall);
+#else
+#define ENTERCASEmunlockall
+#define EXITCASEmunlockall
+#endif
+
+#ifdef __NR_madvise
+trace_event_syscall_enter(3, madvise, unsigned long, start, size_t, len, int, behavior);
+trace_event_syscall_exit(madvise);
+#define ENTERCASEmadvise create_syscall_enter(3, madvise, unsigned long, size_t, int);
+#define EXITCASEmadvise create_syscall_exit(madvise);
+#else
+#define ENTERCASEmadvise
+#define EXITCASEmadvise
+#endif
+
+#ifdef __NR_mincore
+trace_event_syscall_enter(3, mincore, unsigned long, start, size_t, len, unsigned char __user *, vec);
+trace_event_syscall_exit(mincore);
+#define ENTERCASEmincore create_syscall_enter(3, mincore, unsigned long, size_t, unsigned char __user *);
+#define EXITCASEmincore create_syscall_exit(mincore);
+#else
+#define ENTERCASEmincore
+#define EXITCASEmincore
+#endif
+
+#ifdef __NR_pivot_root
+trace_event_syscall_enter(2, pivot_root, const char __user *, new_root, const char __user *, put_old);
+trace_event_syscall_exit(pivot_root);
+#define ENTERCASEpivot_root create_syscall_enter(2, pivot_root, const char __user *, const char __user *);
+#define EXITCASEpivot_root create_syscall_exit(pivot_root);
+#else
+#define ENTERCASEpivot_root
+#define EXITCASEpivot_root
+#endif
+
+#ifdef __NR_chroot
+trace_event_syscall_enter(1, chroot, const char __user *, filename);
+trace_event_syscall_exit(chroot);
+#define ENTERCASEchroot create_syscall_enter(1, chroot, const char __user *);
+#define EXITCASEchroot create_syscall_exit(chroot);
+#else
+#define ENTERCASEchroot
+#define EXITCASEchroot
+#endif
+
+#ifdef __NR_mknod
+trace_event_syscall_enter(3, mknod, const char __user *, filename, int, mode, unsigned, dev);
+trace_event_syscall_exit(mknod);
+#define ENTERCASEmknod create_syscall_enter(3, mknod, const char __user *, int, unsigned);
+#define EXITCASEmknod create_syscall_exit(mknod);
+#else
+#define ENTERCASEmknod
+#define EXITCASEmknod
+#endif
+
+#ifdef __NR_link
+trace_event_syscall_enter(2, link, const char __user *, oldname, const char __user *, newname);
+trace_event_syscall_exit(link);
+#define ENTERCASElink create_syscall_enter(2, link, const char __user *, const char __user *);
+#define EXITCASElink create_syscall_exit(link);
+#else
+#define ENTERCASElink
+#define EXITCASElink
+#endif
+
+#ifdef __NR_symlink
+trace_event_syscall_enter(2, symlink, const char __user *, old, const char __user *, new);
+trace_event_syscall_exit(symlink);
+#define ENTERCASEsymlink create_syscall_enter(2, symlink, const char __user *, const char __user *);
+#define EXITCASEsymlink create_syscall_exit(symlink);
+#else
+#define ENTERCASEsymlink
+#define EXITCASEsymlink
+#endif
+
+#ifdef __NR_unlink
+trace_event_syscall_enter(1, unlink, const char __user *, pathname);
+trace_event_syscall_exit(unlink);
+#define ENTERCASEunlink create_syscall_enter(1, unlink, const char __user *);
+#define EXITCASEunlink create_syscall_exit(unlink);
+#else
+#define ENTERCASEunlink
+#define EXITCASEunlink
+#endif
+
+#ifdef __NR_rename
+trace_event_syscall_enter(2, rename, const char __user *, oldname, const char __user *, newname);
+trace_event_syscall_exit(rename);
+#define ENTERCASErename create_syscall_enter(2, rename, const char __user *, const char __user *);
+#define EXITCASErename create_syscall_exit(rename);
+#else
+#define ENTERCASErename
+#define EXITCASErename
+#endif
+
+#ifdef __NR_chmod
+trace_event_syscall_enter(2, chmod, const char __user *, filename, mode_t, mode);
+trace_event_syscall_exit(chmod);
+#define ENTERCASEchmod create_syscall_enter(2, chmod, const char __user *, mode_t);
+#define EXITCASEchmod create_syscall_exit(chmod);
+#else
+#define ENTERCASEchmod
+#define EXITCASEchmod
+#endif
+
+#ifdef __NR_fchmod
+trace_event_syscall_enter(2, fchmod, unsigned int, fd, mode_t, mode);
+trace_event_syscall_exit(fchmod);
+#define ENTERCASEfchmod create_syscall_enter(2, fchmod, unsigned int, mode_t);
+#define EXITCASEfchmod create_syscall_exit(fchmod);
+#else
+#define ENTERCASEfchmod
+#define EXITCASEfchmod
+#endif
+
+#ifdef __NR_fcntl
+trace_event_syscall_enter(3, fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg);
+trace_event_syscall_exit(fcntl);
+#define ENTERCASEfcntl create_syscall_enter(3, fcntl, unsigned int, unsigned int, unsigned long);
+#define EXITCASEfcntl create_syscall_exit(fcntl);
+#else
+#define ENTERCASEfcntl
+#define EXITCASEfcntl
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__NR_fcntl64)
+trace_event_syscall_enter(3, fcntl64, unsigned int, fd, unsigned int, cmd, unsigned long, arg);
+trace_event_syscall_exit(fcntl64);
+#define ENTERCASEfcntl64 create_syscall_enter(3, fcntl64, unsigned int, unsigned int, unsigned long);
+#define EXITCASEfcntl64 create_syscall_exit(fcntl64);
+#else
+#define ENTERCASEfcntl64
+#define EXITCASEfcntl64
+#endif
+
+#ifdef __NR_dup
+trace_event_syscall_enter(1, dup, unsigned int, fildes);
+trace_event_syscall_exit(dup);
+#define ENTERCASEdup create_syscall_enter(1, dup, unsigned int);
+#define EXITCASEdup create_syscall_exit(dup);
+#else
+#define ENTERCASEdup
+#define EXITCASEdup
+#endif
+
+#ifdef __NR_dup2
+trace_event_syscall_enter(2, dup2, unsigned int, oldfd, unsigned int, newfd);
+trace_event_syscall_exit(dup2);
+#define ENTERCASEdup2 create_syscall_enter(2, dup2, unsigned int, unsigned int);
+#define EXITCASEdup2 create_syscall_exit(dup2);
+#else
+#define ENTERCASEdup2
+#define EXITCASEdup2
+#endif
+
+#ifdef __NR_dup3
+trace_event_syscall_enter(3, dup3, unsigned int, oldfd, unsigned int, newfd, int, flags);
+trace_event_syscall_exit(dup3);
+#define ENTERCASEdup3 create_syscall_enter(3, dup3, unsigned int, unsigned int, int);
+#define EXITCASEdup3 create_syscall_exit(dup3);
+#else
+#define ENTERCASEdup3
+#define EXITCASEdup3
+#endif
+
+#ifdef __NR_ioperm
+trace_event_syscall_enter(3, ioperm, unsigned long, from, unsigned long, num, int, on);
+trace_event_syscall_exit(ioperm);
+#define ENTERCASEioperm create_syscall_enter(3, ioperm, unsigned long, unsigned long, int);
+#define EXITCASEioperm create_syscall_exit(ioperm);
+#else
+#define ENTERCASEioperm
+#define EXITCASEioperm
+#endif
+
+#ifdef __NR_ioctl
+trace_event_syscall_enter(3, ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg);
+trace_event_syscall_exit(ioctl);
+#define ENTERCASEioctl create_syscall_enter(3, ioctl, unsigned int, unsigned int, unsigned long);
+#define EXITCASEioctl create_syscall_exit(ioctl);
+#else
+#define ENTERCASEioctl
+#define EXITCASEioctl
+#endif
+
+#ifdef __NR_flock
+trace_event_syscall_enter(2, flock, unsigned int, fd, unsigned int, cmd);
+trace_event_syscall_exit(flock);
+#define ENTERCASEflock create_syscall_enter(2, flock, unsigned int, unsigned int);
+#define EXITCASEflock create_syscall_exit(flock);
+#else
+#define ENTERCASEflock
+#define EXITCASEflock
+#endif
+
+#ifdef __NR_io_setup
+trace_event_syscall_enter(2, io_setup, unsigned, nr_reqs, aio_context_t __user *, ctx);
+trace_event_syscall_exit(io_setup);
+#define ENTERCASEio_setup create_syscall_enter(2, io_setup, unsigned, aio_context_t __user *);
+#define EXITCASEio_setup create_syscall_exit(io_setup);
+#else
+#define ENTERCASEio_setup
+#define EXITCASEio_setup
+#endif
+
+#ifdef __NR_io_destroy
+trace_event_syscall_enter(1, io_destroy, aio_context_t, ctx);
+trace_event_syscall_exit(io_destroy);
+#define ENTERCASEio_destroy create_syscall_enter(1, io_destroy, aio_context_t);
+#define EXITCASEio_destroy create_syscall_exit(io_destroy);
+#else
+#define ENTERCASEio_destroy
+#define EXITCASEio_destroy
+#endif
+
+#ifdef __NR_io_getevents
+trace_event_syscall_enter(5, io_getevents, aio_context_t, ctx_id, long, min_nr, long, nr, struct io_event __user *, events, struct timespec __user *, timeout);
+trace_event_syscall_exit(io_getevents);
+#define ENTERCASEio_getevents create_syscall_enter(5, io_getevents, aio_context_t, long, long, struct io_event __user *, struct timespec __user *);
+#define EXITCASEio_getevents create_syscall_exit(io_getevents);
+#else
+#define ENTERCASEio_getevents
+#define EXITCASEio_getevents
+#endif
+
+#ifdef __NR_io_submit
+trace_event_syscall_enter(3, io_submit, aio_context_t, ctx, long, nr, struct iocb __user * __user *, iocb);
+trace_event_syscall_exit(io_submit);
+#define ENTERCASEio_submit create_syscall_enter(3, io_submit, aio_context_t, long, struct iocb __user * __user *);
+#define EXITCASEio_submit create_syscall_exit(io_submit);
+#else
+#define ENTERCASEio_submit
+#define EXITCASEio_submit
+#endif
+
+#ifdef __NR_io_cancel
+trace_event_syscall_enter(3, io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb, struct io_event __user *, result);
+trace_event_syscall_exit(io_cancel);
+#define ENTERCASEio_cancel create_syscall_enter(3, io_cancel, aio_context_t, struct iocb __user *, struct io_event __user *);
+#define EXITCASEio_cancel create_syscall_exit(io_cancel);
+#else
+#define ENTERCASEio_cancel
+#define EXITCASEio_cancel
+#endif
+
+#ifdef __NR_sendfile
+trace_event_syscall_enter(4, sendfile, int, out_fd, int, in_fd, off_t __user *, offset, size_t, count);
+trace_event_syscall_exit(sendfile);
+#define ENTERCASEsendfile create_syscall_enter(4, sendfile, int, int, off_t __user *, size_t);
+#define EXITCASEsendfile create_syscall_exit(sendfile);
+#else
+#define ENTERCASEsendfile
+#define EXITCASEsendfile
+#endif
+
+#ifdef __NR_sendfile64
+trace_event_syscall_enter(4, sendfile64, int, out_fd, int, in_fd, loff_t __user *, offset, size_t, count);
+trace_event_syscall_exit(sendfile64);
+#define ENTERCASEsendfile64 create_syscall_enter(4, sendfile64, int, int, loff_t __user *, size_t);
+#define EXITCASEsendfile64 create_syscall_exit(sendfile64);
+#else
+#define ENTERCASEsendfile64
+#define EXITCASEsendfile64
+#endif
+
+#ifdef __NR_readlink
+trace_event_syscall_enter(3, readlink, const char __user *, path, char __user *, buf, int, bufsiz);
+trace_event_syscall_exit(readlink);
+#define ENTERCASEreadlink create_syscall_enter(3, readlink, const char __user *, char __user *, int);
+#define EXITCASEreadlink create_syscall_exit(readlink);
+#else
+#define ENTERCASEreadlink
+#define EXITCASEreadlink
+#endif
+
+#ifdef __NR_creat
+trace_event_syscall_enter(2, creat, const char __user *, pathname, int, mode);
+trace_event_syscall_exit(creat);
+#define ENTERCASEcreat create_syscall_enter(2, creat, const char __user *, int);
+#define EXITCASEcreat create_syscall_exit(creat);
+#else
+#define ENTERCASEcreat
+#define EXITCASEcreat
+#endif
+
+#ifdef __NR_open
+trace_event_syscall_enter(3, open, const char __user *, filename, int, flags, int, mode);
+trace_event_syscall_exit(open);
+#define ENTERCASEopen create_syscall_enter(3, open, const char __user *, int, int);
+#define EXITCASEopen create_syscall_exit(open);
+#else
+#define ENTERCASEopen
+#define EXITCASEopen
+#endif
+
+#ifdef __NR_close
+trace_event_syscall_enter(1, close, unsigned int, fd);
+trace_event_syscall_exit(close);
+#define ENTERCASEclose create_syscall_enter(1, close, unsigned int);
+#define EXITCASEclose create_syscall_exit(close);
+#else
+#define ENTERCASEclose
+#define EXITCASEclose
+#endif
+
+#ifdef __NR_access
+trace_event_syscall_enter(2, access, const char __user *, filename, int, mode);
+trace_event_syscall_exit(access);
+#define ENTERCASEaccess create_syscall_enter(2, access, const char __user *, int);
+#define EXITCASEaccess create_syscall_exit(access);
+#else
+#define ENTERCASEaccess
+#define EXITCASEaccess
+#endif
+
+#ifdef __NR_vhangup
+trace_event_syscall_enter(0, vhangup);
+trace_event_syscall_exit(vhangup);
+#define ENTERCASEvhangup create_syscall_enter(0, vhangup);
+#define EXITCASEvhangup create_syscall_exit(vhangup);
+#else
+#define ENTERCASEvhangup
+#define EXITCASEvhangup
+#endif
+
+#ifdef __NR_chown
+trace_event_syscall_enter(3, chown, const char __user *, filename, uid_t, user, gid_t, group);
+trace_event_syscall_exit(chown);
+#define ENTERCASEchown create_syscall_enter(3, chown, const char __user *, uid_t, gid_t);
+#define EXITCASEchown create_syscall_exit(chown);
+#else
+#define ENTERCASEchown
+#define EXITCASEchown
+#endif
+
+#ifdef __NR_lchown
+trace_event_syscall_enter(3, lchown, const char __user *, filename, uid_t, user, gid_t, group);
+trace_event_syscall_exit(lchown);
+#define ENTERCASElchown create_syscall_enter(3, lchown, const char __user *, uid_t, gid_t);
+#define EXITCASElchown create_syscall_exit(lchown);
+#else
+#define ENTERCASElchown
+#define EXITCASElchown
+#endif
+
+#ifdef __NR_fchown
+trace_event_syscall_enter(3, fchown, unsigned int, fd, uid_t, user, gid_t, group);
+trace_event_syscall_exit(fchown);
+#define ENTERCASEfchown create_syscall_enter(3, fchown, unsigned int, uid_t, gid_t);
+#define EXITCASEfchown create_syscall_exit(fchown);
+#else
+#define ENTERCASEfchown
+#define EXITCASEfchown
+#endif
+
+#if defined( __NR_chown16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(3, chown16, const char __user *, filename, old_uid_t, user, old_gid_t, group);
+trace_event_syscall_exit(chown16);
+#define ENTERCASEchown16 create_syscall_enter(3, chown16, const char __user *, old_uid_t, old_gid_t);
+#define EXITCASEchown16 create_syscall_exit(chown16);
+#else
+#define ENTERCASEchown16
+#define EXITCASEchown16
+#endif
+
+#if defined(__NR_lchown16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(3, lchown16, const char __user *, filename, old_uid_t, user, old_gid_t, group);
+trace_event_syscall_exit(lchown16);
+#define ENTERCASElchown16 create_syscall_enter(3, lchown16, const char __user *, old_uid_t, old_gid_t);
+#define EXITCASElchown16 create_syscall_exit(lchown16);
+#else
+#define ENTERCASElchown16
+#define EXITCASElchown16
+#endif
+
+#if defined(__NR_fchown16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(3, fchown16, unsigned int, fd, old_uid_t, user, old_gid_t, group);
+trace_event_syscall_exit(fchown16);
+#define ENTERCASEfchown16 create_syscall_enter(3, fchown16, unsigned int, old_uid_t, old_gid_t);
+#define EXITCASEfchown16 create_syscall_exit(fchown16);
+#else
+#define ENTERCASEfchown16
+#define EXITCASEfchown16
+#endif
+
+#if defined(__NR_setregid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(2, setregid16, old_gid_t, rgid, old_gid_t, egid);
+trace_event_syscall_exit(setregid16);
+#define ENTERCASEsetregid16 create_syscall_enter(2, setregid16, old_gid_t, old_gid_t);
+#define EXITCASEsetregid16 create_syscall_exit(setregid16);
+#else
+#define ENTERCASEsetregid16
+#define EXITCASEsetregid16
+#endif
+
+#if defined(__NR_setgid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(1, setgid16, old_gid_t, gid);
+trace_event_syscall_exit(setgid16);
+#define ENTERCASEsetgid16 create_syscall_enter(1, setgid16, old_gid_t);
+#define EXITCASEsetgid16 create_syscall_exit(setgid16);
+#else
+#define ENTERCASEsetgid16
+#define EXITCASEsetgid16
+#endif
+
+#if defined(__NR_setreuid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(2, setreuid16, old_uid_t, ruid, old_uid_t, euid);
+trace_event_syscall_exit(setreuid16);
+#define ENTERCASEsetreuid16 create_syscall_enter(2, setreuid16, old_uid_t, old_uid_t);
+#define EXITCASEsetreuid16 create_syscall_exit(setreuid16);
+#else
+#define ENTERCASEsetreuid16
+#define EXITCASEsetreuid16
+#endif
+
+#if defined(__NR_setuid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(1, setuid16, old_uid_t, uid);
+trace_event_syscall_exit(setuid16);
+#define ENTERCASEsetuid16 create_syscall_enter(1, setuid16, old_uid_t);
+#define EXITCASEsetuid16 create_syscall_exit(setuid16);
+#else
+#define ENTERCASEsetuid16
+#define EXITCASEsetuid16
+#endif
+
+#if defined(__NR_setresuid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(3, setresuid16, old_uid_t, ruid, old_uid_t, euid, old_uid_t, suid);
+trace_event_syscall_exit(setresuid16);
+#define ENTERCASEsetresuid16 create_syscall_enter(3, setresuid16, old_uid_t, old_uid_t, old_uid_t);
+#define EXITCASEsetresuid16 create_syscall_exit(setresuid16);
+#else
+#define ENTERCASEsetresuid16
+#define EXITCASEsetresuid16
+#endif
+
+#if defined(__NR_getresuid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(3, getresuid16, old_uid_t __user *, ruid, old_uid_t __user *, euid, old_uid_t __user *, suid);
+trace_event_syscall_exit(getresuid16);
+#define ENTERCASEgetresuid16 create_syscall_enter(3, getresuid16, old_uid_t __user *, old_uid_t __user *, old_uid_t __user *);
+#define EXITCASEgetresuid16 create_syscall_exit(getresuid16);
+#else
+#define ENTERCASEgetresuid16
+#define EXITCASEgetresuid16
+#endif
+
+#if defined(_NR_setresgid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(3, setresgid16, old_gid_t, rgid, old_gid_t, egid, old_gid_t, sgid);
+trace_event_syscall_exit(setresgid16);
+#define ENTERCASEsetresgid16 create_syscall_enter(3, setresgid16, old_gid_t, old_gid_t, old_gid_t);
+#define EXITCASEsetresgid16 create_syscall_exit(setresgid16);
+#else
+#define ENTERCASEsetresgid16
+#define EXITCASEsetresgid16
+#endif
+
+#if defined(__NR_getresgid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(3, getresgid16, old_gid_t __user *, rgid, old_gid_t __user *, egid, old_gid_t __user *, sgid);
+trace_event_syscall_exit(getresgid16);
+#define ENTERCASEgetresgid16 create_syscall_enter(3, getresgid16, old_gid_t __user *, old_gid_t __user *, old_gid_t __user *);
+#define EXITCASEgetresgid16 create_syscall_exit(getresgid16);
+#else
+#define ENTERCASEgetresgid16
+#define EXITCASEgetresgid16
+#endif
+
+#if defined(__NR_setfsuid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(1, setfsuid16, old_uid_t, uid);
+trace_event_syscall_exit(setfsuid16);
+#define ENTERCASEsetfsuid16 create_syscall_enter(1, setfsuid16, old_uid_t);
+#define EXITCASEsetfsuid16 create_syscall_exit(setfsuid16);
+#else
+#define ENTERCASEsetfsuid16
+#define EXITCASEsetfsuid16
+#endif
+
+#if defined(__NR_setfsgid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(setfsgid16, 1, old_gid_t, gid);
+trace_event_syscall_exit(setfsgid16);
+#define ENTERCASEsetfsgid16 create_syscall_enter(1, setfsgid16, old_gid_t);
+#define EXITCASEsetfsgid16 create_syscall_exit(setfsgid16);
+#else
+#define ENTERCASEsetfsgid16
+#define EXITCASEsetfsgid16
+#endif
+
+#if defined(__NR_getgroups16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(2, getgroups16, int, gidsetsize, old_gid_t __user *, grouplist);
+trace_event_syscall_exit(getgroups16);
+#define ENTERCASEgetgroups16 create_syscall_enter(2, getgroups16, int, old_gid_t __user *);
+#define EXITCASEgetgroups16 create_syscall_exit(getgroups16);
+#else
+#define ENTERCASEgetgroups16
+#define EXITCASEgetgroups16
+#endif
+
+#if defined(__NR_setgroups16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(2, setgroups16, int, gidsetsize, old_gid_t __user *, grouplist);
+trace_event_syscall_exit(setgroups16);
+#define ENTERCASEsetgroups16 create_syscall_enter(2, setgroups16, int, old_gid_t __user *);
+#define EXITCASEsetgroups16 create_syscall_exit(setgroups16);
+#else
+#define ENTERCASEsetgroups16
+#define EXITCASEsetgroups16
+#endif
+
+#if defined(__NR_getuid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(0, getuid16);
+trace_event_syscall_exit(getuid16);
+#define ENTERCASEgetuid16 create_syscall_enter(0, getuid16);
+#define EXITCASEgetuid16 create_syscall_exit(getuid16);
+#else
+#define ENTERCASEgetuid16
+#define EXITCASEgetuid16
+#endif
+
+#if defined(__NR_geteuid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(0, geteuid16);
+trace_event_syscall_exit(geteuid16);
+#define ENTERCASEgeteuid16 create_syscall_enter(geteuid16);
+#define EXITCASEgeteuid16 create_syscall_exit(geteuid16);
+#else
+#define ENTERCASEgeteuid16
+#define EXITCASEgeteuid16
+#endif
+
+#if defined(__NR_getgid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(0, getgid16);
+trace_event_syscall_exit(getgid16);
+#define ENTERCASEgetgid16 create_syscall_enter(0, getgid16);
+#define EXITCASEgetgid16 create_syscall_exit(getgid16);
+#else
+#define ENTERCASEgetgid16
+#define EXITCASEgetgid16
+#endif
+
+#if defined(__NR_getegid16) && defined(CONFIG_UID16)
+trace_event_syscall_enter(0, getegid16);
+trace_event_syscall_exit(getegid16);
+#define ENTERCASEgetegid16 create_syscall_exit(0, getegid16);
+#define EXITCASEgetegid16 create_syscall_exit(getegid16);
+#else
+#define ENTERCASEgetegid16
+#define EXITCASEgetegid16
+#endif
+
+#ifdef __NR_utime
+trace_event_syscall_enter(2, utime, char __user *, filename, struct utimbuf __user *, times);
+trace_event_syscall_exit(utime);
+#define ENTERCASEutime create_syscall_enter(2, utime, char __user *, struct utimbuf __user *);
+#define EXITCASEutime create_syscall_exit(utime);
+#else
+#define ENTERCASEutime
+#define EXITCASEutime
+#endif
+
+#ifdef __NR_utimes
+trace_event_syscall_enter(2, utimes, char __user *, filename, struct timeval __user *, utimes);
+trace_event_syscall_exit(utimes);
+#define ENTERCASEutimes create_syscall_enter(2, utimes, char __user *, struct timeval __user *);
+#define EXITCASEutimes create_syscall_exit(utimes);
+#else
+#define ENTERCASEutimes
+#define EXITCASEutimes
+#endif
+
+#ifdef __NR_lseek
+trace_event_syscall_enter(3, lseek, unsigned int, fd, off_t, offset, unsigned int, origin);
+trace_event_syscall_exit(lseek);
+#define ENTERCASElseek create_syscall_enter(3, lseek, unsigned int, off_t, unsigned int);
+#define EXITCASElseek create_syscall_exit(lseek);
+#else
+#define ENTERCASElseek
+#define EXITCASElseek
+#endif
+
+#ifdef __NR_llseek
+trace_event_syscall_enter(5, llseek, unsigned int, fd, unsigned long, offset_high, unsigned long, offset_low, loff_t __user *, result, unsigned int, origin);
+trace_event_syscall_exit(llseek);
+#define ENTERCASEllseek create_syscall_enter(5, llseek, unsigned int, unsigned long, unsigned long, loff_t __user *, unsigned int);
+#define EXITCASEllseek create_syscall_exit(llseek);
+#else
+#define ENTERCASEllseek
+#define EXITCASEllseek
+#endif
+
+#ifdef __NR_read
+trace_event_syscall_enter(3, read, unsigned int, fd, char __user *, buf, size_t, count);
+trace_event_syscall_exit(read);
+#define ENTERCASEread create_syscall_enter(3, read, unsigned int, char __user *, size_t);
+#define EXITCASEread create_syscall_exit(read);
+#else
+#define ENTERCASEread
+#define EXITCASEread
+#endif
+
+#ifdef __NR_readahead
+trace_event_syscall_enter(3, readahead, int, fd, loff_t, offset, size_t, count);
+trace_event_syscall_exit(readahead);
+#define ENTERCASEreadahead create_syscall_enter(3, readahead, int, loff_t, size_t);
+#define EXITCASEreadahead create_syscall_exit(readahead);
+#else
+#define ENTERCASEreadahead
+#define EXITCASEreadahead
+#endif
+
+#ifdef __NR_readv
+trace_event_syscall_enter(3, readv, unsigned long, fd, const struct iovec __user *, vec, unsigned long, vlen);
+trace_event_syscall_exit(readv);
+#define ENTERCASEreadv create_syscall_enter(3, readv, unsigned long, const struct iovec __user *, unsigned long);
+#define EXITCASEreadv create_syscall_exit(readv);
+#else
+#define ENTERCASEreadv
+#define EXITCASEreadv
+#endif
+
+#ifdef __NR_write
+trace_event_syscall_enter(3, write, unsigned int, fd, const char __user *, buf, size_t, count);
+trace_event_syscall_exit(write);
+#define ENTERCASEwrite create_syscall_enter(3, write, unsigned int, const char __user *, size_t);
+#define EXITCASEwrite create_syscall_exit(write);
+#else
+#define ENTERCASEwrite
+#define EXITCASEwrite
+#endif
+
+#ifdef __NR_writev
+trace_event_syscall_enter(3, writev, unsigned long, fd, const struct iovec __user *, vec, unsigned long, vlen);
+trace_event_syscall_exit(writev);
+#define ENTERCASEwritev create_syscall_enter(3, writev, unsigned long, const struct iovec __user *, unsigned long);
+#define EXITCASEwritev create_syscall_exit(writev);
+#else
+#define ENTERCASEwritev
+#define EXITCASEwritev
+#endif
+
+#ifdef __NR_pread64
+trace_event_syscall_enter(4, pread64, unsigned int, fd, char __user *, buf, size_t, count, loff_t, pos);
+trace_event_syscall_exit(pread64);
+#define ENTERCASEpread64 create_syscall_enter(4, pread64, unsigned int, char __user *, size_t, loff_t);
+#define EXITCASEpread64 create_syscall_exit(pread64);
+#else
+#define ENTERCASEpread64
+#define EXITCASEpread64
+#endif
+
+#ifdef __NR_pwrite64
+trace_event_syscall_enter(4, pwrite64, unsigned int, fd, const char __user *, buf, size_t, count, loff_t, pos);
+trace_event_syscall_exit(pwrite64);
+#define ENTERCASEpwrite64 create_syscall_enter(4, pwrite64, unsigned int, const char __user *, size_t, loff_t);
+#define EXITCASEpwrite64 create_syscall_exit(pwrite64);
+#else
+#define ENTERCASEpwrite64
+#define EXITCASEpwrite64
+#endif
+
+#ifdef __NR_preadv
+trace_event_syscall_enter(5, preadv, unsigned long, fd, const struct iovec __user *, vec, unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h);
+trace_event_syscall_exit(preadv);
+#define ENTERCASEpreadv create_syscall_enter(5, preadv, unsigned long, const struct iovec __user *, unsigned long, unsigned long, unsigned long);
+#define EXITCASEpreadv create_syscall_exit(preadv);
+#else
+#define ENTERCASEpreadv
+#define EXITCASEpreadv
+#endif
+
+#ifdef __NR_pwritev
+trace_event_syscall_enter(5, pwritev, unsigned long, fd, const struct iovec __user *, vec, unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h);
+trace_event_syscall_exit(pwritev);
+#define ENTERCASEpwritev create_syscall_enter(5, pwritev, unsigned long, const struct iovec __user *, unsigned long, unsigned long, unsigned long);
+#define EXITCASEpwritev create_syscall_exit(pwritev);
+#else
+#define ENTERCASEpwritev
+#define EXITCASEpwritev
+#endif
+
+#ifdef __NR_getcwd
+trace_event_syscall_enter(2, getcwd, char __user *, buf, unsigned long, size);
+trace_event_syscall_exit(getcwd);
+#define ENTERCASEgetcwd create_syscall_enter(2, getcwd, char __user *, unsigned long);
+#define EXITCASEgetcwd create_syscall_exit(getcwd);
+#else
+#define ENTERCASEgetcwd
+#define EXITCASEgetcwd
+#endif
+
+#ifdef __NR_mkdir
+trace_event_syscall_enter(2, mkdir, const char __user *, pathname, int, mode);
+trace_event_syscall_exit(mkdir);
+#define ENTERCASEmkdir create_syscall_enter(2, mkdir, const char __user *, int);
+#define EXITCASEmkdir create_syscall_exit(mkdir);
+#else
+#define ENTERCASEmkdir
+#define EXITCASEmkdir
+#endif
+
+#ifdef __NR_chdir
+trace_event_syscall_enter(1, chdir, const char __user *, filename);
+trace_event_syscall_exit(chdir);
+#define ENTERCASEchdir create_syscall_enter(1, chdir, const char __user *);
+#define EXITCASEchdir create_syscall_exit(chdir);
+#else
+#define ENTERCASEchdir
+#define EXITCASEchdir
+#endif
+
+#ifdef __NR_fchdir
+trace_event_syscall_enter(1, fchdir, unsigned int, fd);
+trace_event_syscall_exit(fchdir);
+#define ENTERCASEfchdir create_syscall_enter(1, fchdir, unsigned int);
+#define EXITCASEfchdir create_syscall_exit(fchdir);
+#else
+#define ENTERCASEfchdir
+#define EXITCASEfchdir
+#endif
+
+#ifdef __NR_rmdir
+trace_event_syscall_enter(1, rmdir, const char __user *, pathname);
+trace_event_syscall_exit(rmdir);
+#define ENTERCASErmdir create_syscall_enter(1, rmdir, const char __user *);
+#define EXITCASErmdir create_syscall_exit(rmdir);
+#else
+#define ENTERCASErmdir
+#define EXITCASErmdir
+#endif
+
+#ifdef __NR_lookup_dcookie
+trace_event_syscall_enter(3, lookup_dcookie, u64, cookie64, char __user *, buf, size_t, len);
+trace_event_syscall_exit(lookup_dcookie);
+#define ENTERCASElookup_dcookie create_syscall_enter(3, lookup_dcookie, u64, char __user *, size_t);
+#define EXITCASElookup_dcookie create_syscall_exit(lookup_dcookie);
+#else
+#define ENTERCASElookup_dcookie
+#define EXITCASElookup_dcookie
+#endif
+
+#ifdef __NR_quotactl
+trace_event_syscall_enter(4, quotactl, unsigned int, cmd, const char __user *, special, qid_t, id, void __user *, addr);
+trace_event_syscall_exit(quotactl);
+#define ENTERCASEquotactl create_syscall_enter(4, quotactl, unsigned int, const char __user *, qid_t, void __user *);
+#define EXITCASEquotactl create_syscall_exit(quotactl);
+#else
+#define ENTERCASEquotactl
+#define EXITCASEquotactl
+#endif
+
+#ifdef __NR_getdents
+trace_event_syscall_enter(3, getdents, unsigned int, fd, struct linux_dirent __user *, dirent, unsigned int, count);
+trace_event_syscall_exit(getdents);
+#define ENTERCASEgetdents create_syscall_enter(3, getdents, unsigned int, struct linux_dirent __user *, unsigned int);
+#define EXITCASEgetdents create_syscall_exit(getdents);
+#else
+#define ENTERCASEgetdents
+#define EXITCASEgetdents
+#endif
+
+#ifdef __NR_getdents64
+trace_event_syscall_enter(3, getdents64, unsigned int, fd, struct linux_dirent64 __user *, dirent, unsigned int, count);
+trace_event_syscall_exit(getdents64);
+#define ENTERCASEgetdents64 create_syscall_enter(3, getdents64, unsigned int, struct linux_dirent64 __user *, unsigned int);
+#define EXITCASEgetdents64 create_syscall_exit(getdents64);
+#else
+#define ENTERCASEgetdents64
+#define EXITCASEgetdents64
+#endif
+
+#ifdef __NR_setsockopt
+trace_event_syscall_enter(5, setsockopt, int, fd, int, level, int, optname, char __user *, optval, int, optlen);
+trace_event_syscall_exit(setsockopt);
+#define ENTERCASEsetsockopt create_syscall_enter(5, setsockopt, int, int, int, char __user *, int);
+#define EXITCASEsetsockopt create_syscall_exit(setsockopt);
+#else
+#define ENTERCASEsetsockopt
+#define EXITCASEsetsockopt
+#endif
+
+#ifdef __NR_getsockopt
+trace_event_syscall_enter(5, getsockopt, int, fd, int, level, int, optname, char __user *, optval, int __user *, optlen);
+trace_event_syscall_exit(getsockopt);
+#define ENTERCASEgetsockopt create_syscall_enter(5, getsockopt, int, int, int, char __user *, int __user *);
+#define EXITCASEgetsockopt create_syscall_exit(getsockopt);
+#else
+#define ENTERCASEgetsockopt
+#define EXITCASEgetsockopt
+#endif
+
+#ifdef __NR_bind
+trace_event_syscall_enter(3, bind, int, a, struct sockaddr __user *, usr, int, b);
+trace_event_syscall_exit(bind);
+#define ENTERCASEbind create_syscall_enter(3, bind, int, struct sockaddr __user *, int);
+#define EXITCASEbind create_syscall_exit(bind);
+#else
+#define ENTERCASEbind
+#define EXITCASEbind
+#endif
+
+#ifdef __NR_connect
+trace_event_syscall_enter(3, connect, int, a, struct sockaddr __user *, saddr, int, b);
+trace_event_syscall_exit(connect);
+#define ENTERCASEconnect create_syscall_enter(3, connect, int, struct sockaddr __user *, int);
+#define EXITCASEconnect create_syscall_exit(connect);
+#else
+#define ENTERCASEconnect
+#define EXITCASEconnect
+#endif
+
+#ifdef __NR_accept
+trace_event_syscall_enter(3, accept, int, a, struct sockaddr __user *, saddr, int __user *, ptr);
+trace_event_syscall_exit(accept);
+#define ENTERCASEaccept create_syscall_enter(3, accept, int, struct sockaddr __user *, int __user *);
+#define EXITCASEaccept create_syscall_exit(accept);
+#else
+#define ENTERCASEaccept
+#define EXITCASEaccept
+#endif
+
+#ifdef __NR_accept4
+trace_event_syscall_enter(4, accept4, int, a, struct sockaddr __user *, saddr, int __user *, ptr, int, b);
+trace_event_syscall_exit(accept4);
+#define ENTERCASEaccept4 create_syscall_enter(4, accept4, int, struct sockaddr __user *, int __user *, int);
+#define EXITCASEaccept4 create_syscall_exit(accept4);
+#else
+#define ENTERCASEaccept4
+#define EXITCASEaccept4
+#endif
+
+#ifdef __NR_getsockname
+trace_event_syscall_enter(3, getsockname, int, a, struct sockaddr __user *, saddr, int __user *, ptr);
+trace_event_syscall_exit(getsockname);
+#define ENTERCASEgetsockname create_syscall_enter(3, getsockname, int, struct sockaddr __user *, int __user *);
+#define EXITCASEgetsockname create_syscall_exit(getsockname);
+#else
+#define ENTERCASEgetsockname
+#define EXITCASEgetsockname
+#endif
+
+#ifdef __NR_getpeername
+trace_event_syscall_enter(3, getpeername, int, a, struct sockaddr __user *, saddr, int __user *, ptr);
+trace_event_syscall_exit(getpeername);
+#define ENTERCASEgetpeername create_syscall_enter(3, getpeername, int, struct sockaddr __user *, int __user *);
+#define EXITCASEgetpeername create_syscall_exit(getpeername);
+#else
+#define ENTERCASEgetpeername
+#define EXITCASEgetpeername
+#endif
+
+#ifdef __NR_send
+trace_event_syscall_enter(4, send, int, a, void __user *, ptr, size_t, size, unsigned, b);
+trace_event_syscall_exit(send);
+#define ENTERCASEsend create_syscall_enter(4, send, int, void __user *, size_t, unsigned);
+#define EXITCASEsend create_syscall_exit(send);
+#else
+#define ENTERCASEsend
+#define EXITCASEsend
+#endif
+
+#ifdef __NR_sendto
+trace_event_syscall_enter(6, sendto, int, a, void __user *, ptr, size_t, size, unsigned, b, struct sockaddr __user *, saddr, int, c);
+trace_event_syscall_exit(sendto);
+#define ENTERCASEsendto create_syscall_enter(6, sendto, int, void __user *, size_t, unsigned, struct sockaddr __user *, int);
+#define EXITCASEsendto create_syscall_exit(sendto);
+#else
+#define ENTERCASEsendto
+#define EXITCASEsendto
+#endif
+
+#ifdef __NR_sendmsg
+trace_event_syscall_enter(3, sendmsg, int, fd, struct msghdr __user *, msg, unsigned, flags);
+trace_event_syscall_exit(sendmsg);
+#define ENTERCASEsendmsg create_syscall_enter(3, sendmsg, int, struct msghdr __user *, unsigned);
+#define EXITCASEsendmsg create_syscall_exit(sendmsg);
+#else
+#define ENTERCASEsendmsg
+#define EXITCASEsendmsg
+#endif
+
+#ifdef __NR_recv
+trace_event_syscall_enter(4, recv, int, a, void __user *, ptr, size_t, size, unsigned, b);
+trace_event_syscall_exit(recv);
+#define ENTERCASErecv create_syscall_enter(4, recv, int, void __user *, size_t, unsigned);
+#define EXITCASErecv create_syscall_exit(recv);
+#else
+#define ENTERCASErecv
+#define EXITCASErecv
+#endif
+
+#ifdef __NR_recvfrom
+trace_event_syscall_enter(6, recvfrom, int, a, void __user *, ptr, size_t, size, unsigned, b, struct sockaddr __user *, saddr, int __user *, uptr);
+trace_event_syscall_exit(recvfrom);
+#define ENTERCASErecvfrom create_syscall_enter(6, recvfrom, int, void __user *, size_t, unsigned, struct sockaddr __user *, int __user *);
+#define EXITCASErecvfrom create_syscall_exit(recvfrom);
+#else
+#define ENTERCASErecvfrom
+#define EXITCASErecvfrom
+#endif
+
+#ifdef __NR_recvmsg
+trace_event_syscall_enter(3, recvmsg, int, fd, struct msghdr __user *, msg, unsigned, flags);
+trace_event_syscall_exit(recvmsg);
+#define ENTERCASErecvmsg create_syscall_enter(3, recvmsg, int, struct msghdr __user *, unsigned);
+#define EXITCASErecvmsg create_syscall_exit(recvmsg);
+#else
+#define ENTERCASErecvmsg
+#define EXITCASErecvmsg
+#endif
+
+#ifdef __NR_socket
+trace_event_syscall_enter(3, socket, int, a, int, b, int, c);
+trace_event_syscall_exit(socket);
+#define ENTERCASEsocket create_syscall_enter(3, socket, int, int, int);
+#define EXITCASEsocket create_syscall_exit(socket);
+#else
+#define ENTERCASEsocket
+#define EXITCASEsocket
+#endif
+
+#ifdef __NR_socketpair
+trace_event_syscall_enter(4, socketpair, int, a, int, b, int, c, int __user *, ptr);
+trace_event_syscall_exit(socketpair);
+#define ENTERCASEsocketpair create_syscall_enter(4, socketpair, int, int, int, int __user *);
+#define EXITCASEsocketpair create_syscall_exit(socketpair);
+#else
+#define ENTERCASEsocketpair
+#define EXITCASEsocketpair
+#endif
+
+#ifdef __NR_socketcall
+trace_event_syscall_enter(2, socketcall, int, call, unsigned long __user *, args);
+trace_event_syscall_exit(socketcall);
+#define ENTERCASEsocketcall create_syscall_enter(2, socketcall, int, unsigned long __user *);
+#define EXITCASEsocketcall create_syscall_exit(socketcall);
+#else
+#define ENTERCASEsocketcall
+#define EXITCASEsocketcall
+#endif
+
+#ifdef __NR_listen
+trace_event_syscall_enter(2, listen, int, a, int, b);
+trace_event_syscall_exit(listen);
+#define ENTERCASElisten create_syscall_enter(2, listen, int, int);
+#define EXITCASElisten create_syscall_exit(listen);
+#else
+#define ENTERCASElisten
+#define EXITCASElisten
+#endif
+
+#ifdef __NR_poll
+trace_event_syscall_enter(3, poll, struct pollfd __user *, ufds, unsigned int, nfds, long, timeout);
+trace_event_syscall_exit(poll);
+#define ENTERCASEpoll create_syscall_enter(3, poll, struct pollfd __user *, unsigned int, long);
+#define EXITCASEpoll create_syscall_exit(poll);
+#else
+#define ENTERCASEpoll
+#define EXITCASEpoll
+#endif
+
+#ifdef __NR_select
+trace_event_syscall_enter(5, select, int, n, fd_set __user *, inp, fd_set __user *, outp,  fd_set __user *, exp, struct timeval __user *, tvp);
+trace_event_syscall_exit(select);
+#define ENTERCASEselect create_syscall_enter(5, select, int, fd_set __user *, fd_set __user *,  fd_set __user *, struct timeval __user *);
+#define EXITCASEselect create_syscall_exit(select);
+#else
+#define ENTERCASEselect
+#define EXITCASEselect
+#endif
+
+#ifdef __NR_epoll_create
+trace_event_syscall_enter(1, epoll_create, int, size);
+trace_event_syscall_exit(epoll_create);
+#define ENTERCASEepoll_create create_syscall_enter(1, epoll_create, int);
+#define EXITCASEepoll_create create_syscall_exit(epoll_create);
+#else
+#define ENTERCASEepoll_create
+#define EXITCASEepoll_create
+#endif
+
+#ifdef __NR_epoll_create1
+trace_event_syscall_enter(1, epoll_create1, int, flags);
+trace_event_syscall_exit(epoll_create1);
+#define ENTERCASEepoll_create1 create_syscall_enter(1, epoll_create1, int);
+#define EXITCASEepoll_create1 create_syscall_exit(epoll_create1);
+#else
+#define ENTERCASEepoll_create1
+#define EXITCASEepoll_create1
+#endif
+
+#ifdef __NR_epoll_ctl
+trace_event_syscall_enter(4, epoll_ctl, int, epfd, int, op, int, fd, struct epoll_event __user *, eve);
+trace_event_syscall_exit(epoll_ctl);
+#define ENTERCASEepoll_ctl create_syscall_enter(4, epoll_ctl, int, int, int, struct epoll_event __user *);
+#define EXITCASEepoll_ctl create_syscall_exit(epoll_ctl);
+#else
+#define ENTERCASEepoll_ctl
+#define EXITCASEepoll_ctl
+#endif
+
+#ifdef __NR_epoll_wait
+trace_event_syscall_enter(4, epoll_wait, int, epfd, struct epoll_event __user *, events, int, maxevents, int, timeout);
+trace_event_syscall_exit(epoll_wait);
+#define ENTERCASEepoll_wait create_syscall_enter(4, epoll_wait, int, struct epoll_event __user *, int, int);
+#define EXITCASEepoll_wait create_syscall_exit(epoll_wait);
+#else
+#define ENTERCASEepoll_wait
+#define EXITCASEepoll_wait
+#endif
+
+#ifdef __NR_epoll_pwait
+trace_event_syscall_enter(6, epoll_pwait, int, epfd, struct epoll_event __user *, events, int, maxevents, int, timeout, const sigset_t __user *, sigmask, size_t, sigsetsize);
+trace_event_syscall_exit(epoll_pwait);
+#define ENTERCASEepoll_pwait create_syscall_enter(6, epoll_pwait, int, struct epoll_event __user *, int, int, const sigset_t __user *, size_t);
+#define EXITCASEepoll_pwait create_syscall_exit(epoll_pwait);
+#else
+#define ENTERCASEepoll_pwait
+#define EXITCASEepoll_pwait
+#endif
+
+#ifdef __NR_gethostname
+trace_event_syscall_enter(2, gethostname, char __user *, name, int, len);
+trace_event_syscall_exit(gethostname);
+#define ENTERCASEgethostname create_syscall_enter(2, gethostname, char __user *, int);
+#define EXITCASEgethostname create_syscall_exit(gethostname);
+#else
+#define ENTERCASEgethostname
+#define EXITCASEgethostname
+#endif
+
+#ifdef __NR_sethostname
+trace_event_syscall_enter(2, sethostname, char __user *, name, int, len);
+trace_event_syscall_exit(sethostname);
+#define ENTERCASEsethostname create_syscall_enter(2, sethostname, char __user *, int);
+#define EXITCASEsethostname create_syscall_exit(sethostname);
+#else
+#define ENTERCASEsethostname
+#define EXITCASEsethostname
+#endif
+
+#ifdef __NR_setdomainname
+trace_event_syscall_enter(2, setdomainname, char __user *, name, int, len);
+trace_event_syscall_exit(setdomainname);
+#define ENTERCASEsetdomainname create_syscall_enter(2, setdomainname, char __user *, int);
+#define EXITCASEsetdomainname create_syscall_exit(setdomainname);
+#else
+#define ENTERCASEsetdomainname
+#define EXITCASEsetdomainname
+#endif
+
+#ifdef __NR_newuname
+trace_event_syscall_enter(1, newuname, struct new_utsname __user *, name);
+trace_event_syscall_exit(newuname);
+#define ENTERCASEnewuname create_syscall_enter(1, newuname, struct new_utsname __user *);
+#define EXITCASEnewuname create_syscall_exit(newuname);
+#else
+#define ENTERCASEnewuname
+#define EXITCASEnewuname
+#endif
+
+#ifdef __NR_getrlimit
+trace_event_syscall_enter(2, getrlimit, unsigned int, resource, struct rlimit __user *, rlim );
+trace_event_syscall_exit(getrlimit);
+#define ENTERCASEgetrlimit create_syscall_enter(2, getrlimit, unsigned int, struct rlimit __user *);
+#define EXITCASEgetrlimit create_syscall_exit(getrlimit);
+#else
+#define ENTERCASEgetrlimit
+#define EXITCASEgetrlimit
+#endif
+
+#if (defined(COMPAT_RLIM_OLD_INFINITY) || !(defined(CONFIG_IA64))) && defined(__NR_old_getrlimit)
+trace_event_syscall_enter(2, old_getrlimit, unsigned int, resource, struct rlimit __user *, rlim);
+trace_event_syscall_exit(old_getrlimit);
+#define ENTERCASEold_getrlimit create_syscall_enter(2, old_getrlimit, unsigned int, struct rlimit __user * );
+#define EXITCASEold_getrlimit create_syscall_exit(old_getrlimit);
+#else
+#define ENTERCASEold_getrlimit
+#define EXITCASEold_getrlimit
+#endif
+
+#ifdef __NR_setrlimit
+trace_event_syscall_enter(2, setrlimit, unsigned int, resource, struct rlimit __user *, rlim);
+trace_event_syscall_exit(setrlimit);
+#define ENTERCASEsetrlimit create_syscall_enter(2, setrlimit, unsigned int, struct rlimit __user *);
+#define EXITCASEsetrlimit create_syscall_exit(setrlimit);
+#else
+#define ENTERCASEsetrlimit
+#define EXITCASEsetrlimit
+#endif
+
+#ifdef __NR_getrusage
+trace_event_syscall_enter(2, getrusage, int, who, struct rusage __user *, ru);
+trace_event_syscall_exit(getrusage);
+#define ENTERCASEgetrusage create_syscall_enter(2, getrusage, int, struct rusage __user *);
+#define EXITCASEgetrusage create_syscall_exit(getrusage);
+#else
+#define ENTERCASEgetrusage
+#define EXITCASEgetrusage
+#endif
+
+#ifdef __NR_umask
+trace_event_syscall_enter(1, umask, int, mask);
+trace_event_syscall_exit(umask);
+#define ENTERCASEumask create_syscall_enter(1, umask, int);
+#define EXITCASEumask create_syscall_exit(umask);
+#else
+#define ENTERCASEumask
+#define EXITCASEumask
+#endif
+
+#ifdef __NR_msgget
+trace_event_syscall_enter(2, msgget, key_t, key, int, msgflg);
+trace_event_syscall_exit(msgget);
+#define ENTERCASEmsgget create_syscall_enter(2, msgget, key_t, int);
+#define EXITCASEmsgget create_syscall_exit(msgget);
+#else
+#define ENTERCASEmsgget
+#define EXITCASEmsgget
+#endif
+
+#ifdef __NR_msgsnd
+trace_event_syscall_enter(4, msgsnd, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz, int, msgflg);
+trace_event_syscall_exit(msgsnd);
+#define ENTERCASEmsgsnd create_syscall_enter(4, msgsnd, int, struct msgbuf __user *, size_t, int);
+#define EXITCASEmsgsnd create_syscall_exit(msgsnd);
+#else
+#define ENTERCASEmsgsnd
+#define EXITCASEmsgsnd
+#endif
+
+#ifdef __NR_msgrcv
+trace_event_syscall_enter(5, msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz, long, msgtyp, int, msgflg);
+trace_event_syscall_exit(msgrcv);
+#define ENTERCASEmsgrcv create_syscall_enter(5, msgrcv, int, struct msgbuf __user *, size_t, long, int);
+#define EXITCASEmsgrcv create_syscall_exit(msgrcv);
+#else
+#define ENTERCASEmsgrcv
+#define EXITCASEmsgrcv
+#endif
+
+#ifdef __NR_msgctl
+trace_event_syscall_enter(3, msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf);
+trace_event_syscall_exit(msgctl);
+#define ENTERCASEmsgctl create_syscall_enter(3, msgctl, int, int, struct msqid_ds __user *);
+#define EXITCASEmsgctl create_syscall_exit(msgctl);
+#else
+#define ENTERCASEmsgctl
+#define EXITCASEmsgctl
+#endif
+
+#ifdef __NR_semget
+trace_event_syscall_enter(3, semget, key_t, key, int, nsems, int, semflg);
+trace_event_syscall_exit(semget);
+#define ENTERCASEsemget create_syscall_enter(3, semget, key_t, int, int);
+#define EXITCASEsemget create_syscall_exit(semget);
+#else
+#define ENTERCASEsemget
+#define EXITCASEsemget
+#endif
+
+#ifdef __NR_semop
+trace_event_syscall_enter(3, semop, int, semid, struct sembuf __user *, sops, unsigned, nsops);
+trace_event_syscall_exit(semop);
+#define ENTERCASEsemop create_syscall_enter(3, semop, int, struct sembuf __user *, unsigned);
+#define EXITCASEsemop create_syscall_exit(semop);
+#else
+#define ENTERCASEsemop
+#define EXITCASEsemop
+#endif
+
+#ifdef __NR_semctl
+trace_event_syscall_enter(4, semctl, int, semid, int, semnum, int, cmd, int, arg);
+trace_event_syscall_exit(semctl);
+#define ENTERCASEsemctl create_syscall_enter(4, semctl, int, int, int, int);
+#define EXITCASEsemctl create_syscall_exit(semctl);
+#else
+#define ENTERCASEsemctl
+#define EXITCASEsemctl
+#endif
+
+#ifdef __NR_semtimedop
+trace_event_syscall_enter(4, semtimedop, int, semid, struct sembuf __user *, sops, unsigned, nsops, const struct timespec __user *, timeout);
+trace_event_syscall_exit(semtimedop);
+#define ENTERCASEsemtimedop create_syscall_enter(4, semtimedop, int, struct sembuf __user *, unsigned, const struct timespec __user *);
+#define EXITCASEsemtimedop create_syscall_exit(semtimedop);
+#else
+#define ENTERCASEsemtimedop
+#define EXITCASEsemtimedop
+#endif
+
+#ifdef __NR_shmat
+trace_event_syscall_enter(3, shmat, int, shmid, char __user *, shmaddr, int, shmflg);
+trace_event_syscall_exit(shmat);
+#define ENTERCASEshmat create_syscall_enter(3, shmat, int, char __user *, int);
+#define EXITCASEshmat create_syscall_exit(shmat);
+#else
+#define ENTERCASEshmat
+#define EXITCASEshmat
+#endif
+
+#ifdef __NR_shmget
+trace_event_syscall_enter(3, shmget, key_t, key, size_t, size, int, flag);
+trace_event_syscall_exit(shmget);
+#define ENTERCASEshmget create_syscall_enter(3, shmget, key_t, size_t, int);
+#define EXITCASEshmget create_syscall_exit(shmget);
+#else
+#define ENTERCASEshmget
+#define EXITCASEshmget
+#endif
+
+#ifdef __NR_shmdt
+trace_event_syscall_enter(1, shmdt, char __user *, shmaddr);
+trace_event_syscall_exit(shmdt);
+#define ENTERCASEshmdt create_syscall_enter(1, shmdt, char __user *);
+#define EXITCASEshmdt create_syscall_exit(shmdt);
+#else
+#define ENTERCASEshmdt
+#define EXITCASEshmdt
+#endif
+
+#ifdef __NR_shmctl
+trace_event_syscall_enter(3, shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf);
+trace_event_syscall_exit(shmctl);
+#define ENTERCASEshmctl create_syscall_enter(3, shmctl, int, int, struct shmid_ds __user *);
+#define EXITCASEshmctl create_syscall_exit(shmctl);
+#else
+#define ENTERCASEshmctl
+#define EXITCASEshmctl
+#endif
+
+#ifdef __NR_mq_open
+trace_event_syscall_enter(4, mq_open, const char __user *, name, int, oflag, mode_t, mode, struct mq_attr __user *, attr);
+trace_event_syscall_exit(mq_open);
+#define ENTERCASEmq_open create_syscall_enter(4, mq_open, const char __user *, int, mode_t, struct mq_attr __user *);
+#define EXITCASEmq_open create_syscall_exit(mq_open);
+#else
+#define ENTERCASEmq_open
+#define EXITCASEmq_open
+#endif
+
+#ifdef __NR_mq_unlink
+trace_event_syscall_enter(1, mq_unlink, const char __user *, name);
+trace_event_syscall_exit(mq_unlink);
+#define ENTERCASEmq_unlink create_syscall_enter(1, mq_unlink, const char __user *);
+#define EXITCASEmq_unlink create_syscall_exit(mq_unlink);
+#else
+#define ENTERCASEmq_unlink
+#define EXITCASEmq_unlink
+#endif
+
+#ifdef __NR_mq_timedsend
+trace_event_syscall_enter(5, mq_timedsend, mqd_t, mqdes, const char __user *, msg_ptr, size_t, msg_len, unsigned int, msg_prio, const struct timespec __user *, abs_timeout);
+trace_event_syscall_exit(mq_timedsend);
+#define ENTERCASEmq_timedsend create_syscall_enter(5, mq_timedsend, mqd_t, const char __user *, size_t, unsigned int, const struct timespec __user *);
+#define EXITCASEmq_timedsend create_syscall_exit(mq_timedsend);
+#else
+#define ENTERCASEmq_timedsend
+#define EXITCASEmq_timedsend
+#endif
+
+#ifdef __NR_mq_timedreceive
+trace_event_syscall_enter(5, mq_timedreceive, mqd_t, mqdes, char __user *, msg_ptr, size_t, msg_len, unsigned int __user *, msg_prio, const struct timespec __user *, abs_timeout);
+trace_event_syscall_exit(mq_timedreceive);
+#define ENTERCASEmq_timedreceive create_syscall_enter(5, mq_timedreceive, mqd_t, char __user *, size_t, unsigned int __user *, const struct timespec __user *);
+#define EXITCASEmq_timedreceive create_syscall_exit(mq_timedreceive);
+#else
+#define ENTERCASEmq_timedreceive
+#define EXITCASEmq_timedreceive
+#endif
+
+#ifdef __NR_mq_notify
+trace_event_syscall_enter(2, mq_notify, mqd_t, mqdes, const struct sigevent __user *, notification);
+trace_event_syscall_exit(mq_notify);
+#define ENTERCASEmq_notify create_syscall_enter(2, mq_notify, mqd_t, const struct sigevent __user *);
+#define EXITCASEmq_notify create_syscall_exit(mq_notify);
+#else
+#define ENTERCASEmq_notify
+#define EXITCASEmq_notify
+#endif
+
+#ifdef __NR_mq_getsetattr
+trace_event_syscall_enter(3, mq_getsetattr, mqd_t, mqdes, const struct mq_attr __user *, mqstat, struct mq_attr __user *, omqstat);
+trace_event_syscall_exit(mq_getsetattr);
+#define ENTERCASEmq_getsetattr create_syscall_enter(3, mq_getsetattr, mqd_t, const struct mq_attr __user *, struct mq_attr __user *);
+#define EXITCASEmq_getsetattr create_syscall_exit(mq_getsetattr);
+#else
+#define ENTERCASEmq_getsetattr
+#define EXITCASEmq_getsetattr
+#endif
+
+#ifdef __NR_pciconfig_iobase
+trace_event_syscall_enter(3, pciconfig_iobase, long, which, unsigned long, bus, unsigned long, devfn);
+trace_event_syscall_exit(pciconfig_iobase);
+#define ENTERCASEpciconfig_iobase create_syscall_enter(3, pciconfig_iobase, long, unsigned long, unsigned long);
+#define EXITCASEpciconfig_iobase create_syscall_exit(pciconfig_iobase);
+#else
+#define ENTERCASEpciconfig_iobase
+#define EXITCASEpciconfig_iobase
+#endif
+
+#ifdef __NR_pciconfig_read
+trace_event_syscall_enter(5, pciconfig_read, unsigned long bus, unsigned long dfn, unsigned long off, unsigned long len, void __user *buf);
+trace_event_syscall_exit(pciconfig_read);
+#define ENTERCASEpciconfig_read create_syscall_enter(5, pciconfig_read, unsigned long, unsigned long, unsigned long, unsigned long, void __user *);
+#define EXITCASEpciconfig_read create_syscall_exit(pciconfig_read);
+#else
+#define ENTERCASEpciconfig_read
+#define EXITCASEpciconfig_read
+#endif
+
+#ifdef __NR_pciconfig_write
+trace_event_syscall_enter(5, pciconfig_write, unsigned long, bus, unsigned long, dfn, unsigned long, off, unsigned long, len, void __user *, buf);
+trace_event_syscall_exit(pciconfig_write);
+#define ENTERCASEpciconfig_write create_syscall_enter(5, pciconfig_write, unsigned long, unsigned long, unsigned long, unsigned long, void __user *);
+#define EXITCASEpciconfig_write create_syscall_exit(pciconfig_write);
+#else
+#define ENTERCASEpciconfig_write
+#define EXITCASEpciconfig_write
+#endif
+
+#ifdef __NR_prctl
+trace_event_syscall_enter(5, prctl, int, option, unsigned long, arg2, unsigned long, arg3, unsigned long, arg4, unsigned long, arg5);
+trace_event_syscall_exit(prctl);
+#define ENTERCASEprctl create_syscall_enter(5, prctl, int, unsigned long, unsigned long, unsigned long, unsigned long);
+#define EXITCASEprctl create_syscall_exit(prctl);
+#else
+#define ENTERCASEprctl
+#define EXITCASEprctl
+#endif
+
+#ifdef __NR_swapon
+trace_event_syscall_enter(2, swapon, const char __user *, specialfile, int, swap_flags);
+trace_event_syscall_exit(swapon);
+#define ENTERCASEswapon create_syscall_enter(2, swapon, const char __user *, int);
+#define EXITCASEswapon create_syscall_exit(swapon);
+#else
+#define ENTERCASEswapon
+#define EXITCASEswapon
+#endif
+
+#ifdef __NR_swapoff
+trace_event_syscall_enter(1, swapoff, const char __user *, specialfile);
+trace_event_syscall_exit(swapoff);
+#define ENTERCASEswapoff create_syscall_enter(1, swapoff, const char __user *);
+#define EXITCASEswapoff create_syscall_exit(swapoff);
+#else
+#define ENTERCASEswapoff
+#define EXITCASEswapoff
+#endif
+
+#ifdef __NR_sysctl
+trace_event_syscall_enter(1, sysctl, struct __sysctl_args __user *, args);
+trace_event_syscall_exit(sysctl);
+#define ENTERCASEsysctl create_syscall_enter(1, sysctl, struct __sysctl_args __user *);
+#define EXITCASEsysctl create_syscall_exit(sysctl);
+#else
+#define ENTERCASEsysctl
+#define EXITCASEsysctl
+#endif
+
+#ifdef __NR_sysinfo
+trace_event_syscall_enter(1, sysinfo, struct sysinfo __user *, info);
+trace_event_syscall_exit(sysinfo);
+#define ENTERCASEsysinfo create_syscall_enter(1, sysinfo, struct sysinfo __user *);
+#define EXITCASEsysinfo create_syscall_exit(sysinfo);
+#else
+#define ENTERCASEsysinfo
+#define EXITCASEsysinfo
+#endif
+
+#ifdef __NR_sysfs
+trace_event_syscall_enter(3, sysfs, int, option, unsigned long, arg1, unsigned long, arg2);
+trace_event_syscall_exit(sysfs);
+#define ENTERCASEsysfs create_syscall_enter(3, sysfs, int, unsigned long, unsigned long);
+#define EXITCASEsysfs create_syscall_exit(sysfs);
+#else
+#define ENTERCASEsysfs
+#define EXITCASEsysfs
+#endif
+
+#ifdef __NR_nfsservctl
+trace_event_syscall_enter(3, nfsservctl, int, cmd, struct nfsctl_arg __user *, arg, void __user *, res);
+trace_event_syscall_exit(nfsservctl);
+#define ENTERCASEnfsservctl create_syscall_enter(3, nfsservctl, int, struct nfsctl_arg __user *, void __user *);
+#define EXITCASEnfsservctl create_syscall_exit(nfsservctl);
+#else
+#define ENTERCASEnfsservctl
+#define EXITCASEnfsservctl
+#endif
+
+#ifdef __NR_syslog
+trace_event_syscall_enter(3, syslog, int, type, char __user *, buf, int, len);
+trace_event_syscall_exit(syslog);
+#define ENTERCASEsyslog create_syscall_enter(3, syslog, int, char __user *, int);
+#define EXITCASEsyslog create_syscall_exit(syslog);
+#else
+#define ENTERCASEsyslog
+#define EXITCASEsyslog
+#endif
+
+#ifdef __NR_uselib
+trace_event_syscall_enter(1, uselib, const char __user *, library);
+trace_event_syscall_exit(uselib);
+#define ENTERCASEuselib create_syscall_enter(1, uselib, const char __user *);
+#define EXITCASEuselib create_syscall_exit(uselib);
+#else
+#define ENTERCASEuselib
+#define EXITCASEuselib
+#endif
+
+#ifdef __NR_ni_syscall
+trace_event_syscall_enter(0, ni_syscall);
+trace_event_syscall_exit(ni_syscall);
+#define ENTERCASEni_syscall create_syscall_enter(0, ni_syscall);
+#define EXITCASEni_syscall create_syscall_exit(ni_syscall);
+#else
+#define ENTERCASEni_syscall
+#define EXITCASEni_syscall
+#endif
+
+#ifdef __NR_ptrace
+trace_event_syscall_enter(4, ptrace, long, request, long, pid, long, addr, long, data);
+trace_event_syscall_exit(ptrace);
+#define ENTERCASEptrace create_syscall_enter(4, ptrace, long, long, long, long);
+#define EXITCASEptrace create_syscall_exit(ptrace);
+#else
+#define ENTERCASEptrace
+#define EXITCASEptrace
+#endif
+
+#ifdef __NR_add_key
+trace_event_syscall_enter(5, add_key, const char __user *, _type, const char __user *, _description, const void __user *, _payload, size_t, plen, key_serial_t, destringid);
+trace_event_syscall_exit(add_key);
+#define ENTERCASEadd_key create_syscall_enter(5, add_key, const char __user *, const char __user *, const void __user *, size_t, key_serial_t);
+#define EXITCASEadd_key create_syscall_exit(add_key);
+#else
+#define ENTERCASEadd_key
+#define EXITCASEadd_key
+#endif
+
+#ifdef __NR_request_key
+trace_event_syscall_enter(4, request_key, const char __user *, _type, const char __user *, _description, const char __user *, _callout_info, key_serial_t, destringid);
+trace_event_syscall_exit(request_key);
+#define ENTERCASErequest_key create_syscall_enter(4, request_key, const char __user *, const char __user *, const char __user *, key_serial_t);
+#define EXITCASErequest_key create_syscall_exit(request_key);
+#else
+#define ENTERCASErequest_key
+#define EXITCASErequest_key
+#endif
+
+#ifdef __NR_keyctl
+trace_event_syscall_enter(5, keyctl, int, cmd, unsigned long, arg2, unsigned long, arg3, unsigned long, arg4, unsigned long, arg5);
+trace_event_syscall_exit(keyctl);
+#define ENTERCASEkeyctl create_syscall_enter(5, keyctl, int, unsigned long, unsigned long, unsigned long, unsigned long);
+#define EXITCASEkeyctl create_syscall_exit(keyctl);
+#else
+#define ENTERCASEkeyctl
+#define EXITCASEkeyctl
+#endif
+
+#ifdef __NR_ioprio_set
+trace_event_syscall_enter(3, ioprio_set, int, which, int, who, int, ioprio);
+trace_event_syscall_exit(ioprio_set);
+#define ENTERCASEioprio_set create_syscall_enter(3, ioprio_set, int, int, int);
+#define EXITCASEioprio_set create_syscall_exit(ioprio_set);
+#else
+#define ENTERCASEioprio_set
+#define EXITCASEioprio_set
+#endif
+
+#ifdef __NR_ioprio_get
+trace_event_syscall_enter(2, ioprio_get, int, which, int, who);
+trace_event_syscall_exit(ioprio_get);
+#define ENTERCASEioprio_get create_syscall_enter(2, ioprio_get, int, int);
+#define EXITCASEioprio_get create_syscall_exit(ioprio_get);
+#else
+#define ENTERCASEioprio_get
+#define EXITCASEioprio_get
+#endif
+
+#ifdef __NR_set_mempolicy
+trace_event_syscall_enter(3, set_mempolicy, int, mode, unsigned long __user *, nmask, unsigned long, maxnode);
+trace_event_syscall_exit(set_mempolicy);
+#define ENTERCASEset_mempolicy create_syscall_enter(3, set_mempolicy, int, unsigned long __user *, unsigned long);
+#define EXITCASEset_mempolicy create_syscall_exit(set_mempolicy);
+#else
+#define ENTERCASEset_mempolicy
+#define EXITCASEset_mempolicy
+#endif
+
+#ifdef __NR_migrate_pages
+trace_event_syscall_enter(4, migrate_pages, pid_t, pid, unsigned long, maxnode, const unsigned long __user *, from, const unsigned long __user *, to);
+trace_event_syscall_exit(migrate_pages);
+#define ENTERCASEmigrate_pages create_syscall_enter(4, migrate_pages, pid_t, unsigned long, const unsigned long __user *, const unsigned long __user *);
+#define EXITCASEmigrate_pages create_syscall_exit(migrate_pages);
+#else
+#define ENTERCASEmigrate_pages
+#define EXITCASEmigrate_pages
+#endif
+
+#ifdef __NR_move_pages
+trace_event_syscall_enter(6, move_pages, pid_t, pid, unsigned long, nr_pages, const void __user * __user *, pages, const int __user *, nodes, int __user *, status, int, flags);
+trace_event_syscall_exit(move_pages);
+#define ENTERCASEmove_pages create_syscall_enter(6, move_pages, pid_t, unsigned long, const void __user * __user *, const int __user *, int __user *, int);
+#define EXITCASEmove_pages create_syscall_exit(move_pages);
+#else
+#define ENTERCASEmove_pages
+#define EXITCASEmove_pages
+#endif
+
+#ifdef __NR_mbind
+trace_event_syscall_enter(6, mbind, unsigned long, start, unsigned long, len, unsigned long, mode, unsigned long __user *, nmask, unsigned long, maxnode, unsigned, flags);
+trace_event_syscall_exit(mbind);
+#define ENTERCASEmbind create_syscall_enter(6, mbind, unsigned long, unsigned long, unsigned long, unsigned long __user *, unsigned long, unsigned);
+#define EXITCASEmbind create_syscall_exit(mbind);
+#else
+#define ENTERCASEmbind
+#define EXITCASEmbind
+#endif
+
+#ifdef __NR_get_mempolicy
+trace_event_syscall_enter(5, get_mempolicy, int __user *, policy, unsigned long __user *, nmask, unsigned long, maxnode, unsigned long, addr, unsigned long, flags);
+trace_event_syscall_exit(get_mempolicy);
+#define ENTERCASEget_mempolicy create_syscall_enter(5, get_mempolicy, int __user *, unsigned long __user *, unsigned long, unsigned long, unsigned long);
+#define EXITCASEget_mempolicy create_syscall_exit(get_mempolicy);
+#else
+#define ENTERCASEget_mempolicy
+#define EXITCASEget_mempolicy
+#endif
+
+#ifdef __NR_inotify_init
+trace_event_syscall_enter(0, inotify_init);
+trace_event_syscall_exit(inotify_init);
+#define ENTERCASEinotify_init create_syscall_enter(0, inotify_init);
+#define EXITCASEinotify_init create_syscall_exit(inotify_init);
+#else
+#define ENTERCASEinotify_init
+#define EXITCASEinotify_init
+#endif
+
+#ifdef __NR_inotify_init1
+trace_event_syscall_enter(1, inotify_init1, int, flags);
+trace_event_syscall_exit(inotify_init1);
+#define ENTERCASEinotify_init1 create_syscall_enter(1, inotify_init1, int);
+#define EXITCASEinotify_init1 create_syscall_exit(inotify_init1);
+#else
+#define ENTERCASEinotify_init1
+#define EXITCASEinotify_init1
+#endif
+
+#ifdef __NR_inotify_add_watch
+trace_event_syscall_enter(3, inotify_add_watch, int, fd, const char __user *, path, u32, mask);
+trace_event_syscall_exit(inotify_add_watch);
+#define ENTERCASEinotify_add_watch create_syscall_enter(3, inotify_add_watch, int, const char __user *, u32);
+#define EXITCASEinotify_add_watch create_syscall_exit(inotify_add_watch);
+#else
+#define ENTERCASEinotify_add_watch
+#define EXITCASEinotify_add_watch
+#endif
+
+#ifdef __NR_inotify_rm_watch
+trace_event_syscall_enter(2, inotify_rm_watch, int, fd, __s32, wd);
+trace_event_syscall_exit(inotify_rm_watch);
+#define ENTERCASEinotify_rm_watch create_syscall_enter(2, inotify_rm_watch, int, __s32);
+#define EXITCASEinotify_rm_watch create_syscall_exit(inotify_rm_watch);
+#else
+#define ENTERCASEinotify_rm_watch
+#define EXITCASEinotify_rm_watch
+#endif
+
+#ifdef __NR_spu_run
+trace_event_syscall_enter(3, spu_run, int, fd, __u32 __user *, unpc, __u32 __user *, ustatus);
+trace_event_syscall_exit(spu_run);
+#define ENTERCASEspu_run create_syscall_enter(3, spu_run, int, __u32 __user *, __u32 __user *);
+#define EXITCASEspu_run create_syscall_exit(spu_run);
+#else
+#define ENTERCASEspu_run
+#define EXITCASEspu_run
+#endif
+
+#ifdef __NR_spu_create
+trace_event_syscall_enter(4, spu_create, const char __user *, name, unsigned int, flags, mode_t, mode, int, fd);
+trace_event_syscall_exit(spu_create);
+#define ENTERCASEspu_create create_syscall_enter(4, spu_create, const char __user *, unsigned int, mode_t, int);
+#define EXITCASEspu_create create_syscall_exit(spu_create);
+#else
+#define ENTERCASEspu_create
+#define EXITCASEspu_create
+#endif
+
+#ifdef __NR_mknodat
+trace_event_syscall_enter(4, mknodat, int, dfd, const char __user *, filename, int, mode, unsigned, dev);
+trace_event_syscall_exit(mknodat);
+#define ENTERCASEmknodat create_syscall_enter(4, mknodat, int, const char __user *, int, unsigned);
+#define EXITCASEmknodat create_syscall_exit(mknodat);
+#else
+#define ENTERCASEmknodat
+#define EXITCASEmknodat
+#endif
+
+#ifdef __NR_mkdirat
+trace_event_syscall_enter(3, mkdirat, int, dfd, const char __user *, pathname, int, mode);
+trace_event_syscall_exit(mkdirat);
+#define ENTERCASEmkdirat create_syscall_enter(3, mkdirat, int, const char __user *, int);
+#define EXITCASEmkdirat create_syscall_exit(mkdirat);
+#else
+#define ENTERCASEmkdirat
+#define EXITCASEmkdirat
+#endif
+
+#ifdef __NR_unlinkat
+trace_event_syscall_enter(3, unlinkat, int, dfd, const char __user *, pathname, int, flag);
+trace_event_syscall_exit(unlinkat);
+#define ENTERCASEunlinkat create_syscall_enter(3, unlinkat, int, const char __user *, int);
+#define EXITCASEunlinkat create_syscall_exit(unlinkat);
+#else
+#define ENTERCASEunlinkat
+#define EXITCASEunlinkat
+#endif
+
+#ifdef __NR_symlinkat
+trace_event_syscall_enter(3, symlinkat, const char __user *, oldname, int, newdfd, const char __user *, newname);
+trace_event_syscall_exit(symlinkat);
+#define ENTERCASEsymlinkat create_syscall_enter(3, symlinkat, const char __user *, int, const char __user *);
+#define EXITCASEsymlinkat create_syscall_exit(symlinkat);
+#else
+#define ENTERCASEsymlinkat
+#define EXITCASEsymlinkat
+#endif
+
+#ifdef __NR_linkat
+trace_event_syscall_enter(5, linkat, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname, int, flags);
+trace_event_syscall_exit(linkat);
+#define ENTERCASElinkat create_syscall_enter(5, linkat, int, const char __user *, int, const char __user *, int);
+#define EXITCASElinkat create_syscall_exit(linkat);
+#else
+#define ENTERCASElinkat
+#define EXITCASElinkat
+#endif
+
+#ifdef __NR_renameat
+trace_event_syscall_enter(4, renameat, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname);
+trace_event_syscall_exit(renameat);
+#define ENTERCASErenameat create_syscall_enter(4, renameat, int, const char __user *, int, const char __user *);
+#define EXITCASErenameat create_syscall_exit(renameat);
+#else
+#define ENTERCASErenameat
+#define EXITCASErenameat
+#endif
+
+#ifdef __NR_futimesat
+trace_event_syscall_enter(3, futimesat, int, dfd, char __user *, filename, struct timeval __user *, utimes);
+trace_event_syscall_exit(futimesat);
+#define ENTERCASEfutimesat create_syscall_enter(3, futimesat, int, char __user *, struct timeval __user *);
+#define EXITCASEfutimesat create_syscall_exit(futimesat);
+#else
+#define ENTERCASEfutimesat
+#define EXITCASEfutimesat
+#endif
+
+#ifdef __NR_faccessat
+trace_event_syscall_enter(3, faccessat, int, dfd, const char __user *, filename, int, mode);
+trace_event_syscall_exit(faccessat);
+#define ENTERCASEfaccessat create_syscall_enter(3, faccessat, int, const char __user *, int);
+#define EXITCASEfaccessat create_syscall_exit(faccessat);
+#else
+#define ENTERCASEfaccessat
+#define EXITCASEfaccessat
+#endif
+
+#ifdef __NR_fchmodat
+trace_event_syscall_enter(3, fchmodat, int, dfd, const char __user *, filename, mode_t, mode);
+trace_event_syscall_exit(fchmodat);
+#define ENTERCASEfchmodat create_syscall_enter(3, fchmodat, int, const char __user *, mode_t);
+#define EXITCASEfchmodat create_syscall_exit(fchmodat);
+#else
+#define ENTERCASEfchmodat
+#define EXITCASEfchmodat
+#endif
+
+#ifdef __NR_fchownat
+trace_event_syscall_enter(5, fchownat, int, dfd, const char __user *, filename, uid_t, user, gid_t, group, int, flag);
+trace_event_syscall_exit(fchownat);
+#define ENTERCASEfchownat create_syscall_enter(5, fchownat, int, const char __user *, uid_t, gid_t, int);
+#define EXITCASEfchownat create_syscall_exit(fchownat);
+#else
+#define ENTERCASEfchownat
+#define EXITCASEfchownat
+#endif
+
+#ifdef __NR_openat
+trace_event_syscall_enter(4, openat, int, dfd, const char __user *, filename, int, flags, int, mode);
+trace_event_syscall_exit(openat);
+#define ENTERCASEopenat create_syscall_enter(4, openat, int, const char __user *, int, int);
+#define EXITCASEopenat create_syscall_exit(openat);
+#else
+#define ENTERCASEopenat
+#define EXITCASEopenat
+#endif
+
+#ifdef __NR_newfstatat
+trace_event_syscall_enter(4, newfstatat, int, dfd, char __user *, filename, struct stat __user *, statbuf, int, flag);
+trace_event_syscall_exit(newfstatat);
+#define ENTERCASEnewfstatat create_syscall_enter(4, newfstatat, int, char __user *, struct stat __user *, int);
+#define EXITCASEnewfstatat create_syscall_exit(newfstatat);
+#else
+#define ENTERCASEnewfstatat
+#define EXITCASEnewfstatat
+#endif
+
+#ifdef __NR_fstatat64
+trace_event_syscall_enter(4, fstatat64, int dfd, char __user *filename, struct stat64 __user *statbuf, int, flag);
+trace_event_syscall_exit(fstatat64);
+#define ENTERCASEfstatat64 create_syscall_enter(4, fstatat64, int, dfd, char __user *, filename, struct stat64 __user *, statbuf, int, flag);
+#define EXITCASEfstatat64 create_syscall_exit(fstatat64);
+#else
+#define ENTERCASEfstatat64
+#define EXITCASEfstatat64
+#endif
+
+#ifdef __NR_readlinkat
+trace_event_syscall_enter(4, readlinkat, int, dfd, const char __user *, path, char __user *, buf, int, bufsiz);
+trace_event_syscall_exit(readlinkat);
+#define ENTERCASEreadlinkat create_syscall_enter(4, readlinkat, int, const char __user *, char __user *, int);
+#define EXITCASEreadlinkat create_syscall_exit(readlinkat);
+#else
+#define ENTERCASEreadlinkat
+#define EXITCASEreadlinkat
+#endif
+
+#ifdef __NR_utimensat
+trace_event_syscall_enter(4, utimensat, int, dfd, char __user *, filename, struct timespec __user *, utimes, int, flags);
+trace_event_syscall_exit(utimensat);
+#define ENTERCASEutimensat create_syscall_enter(4, utimensat, int, char __user *, struct timespec __user *, int);
+#define EXITCASEutimensat create_syscall_exit(utimensat);
+#else
+#define ENTERCASEutimensat
+#define EXITCASEutimensat
+#endif
+
+#ifdef __NR_unshare
+trace_event_syscall_enter(1, unshare, unsigned long, unshare_flags);
+trace_event_syscall_exit(unshare);
+#define ENTERCASEunshare create_syscall_enter(1, unshare, unsigned long);
+#define EXITCASEunshare create_syscall_exit(unshare);
+#else
+#define ENTERCASEunshare
+#define EXITCASEunshare
+#endif
+
+#ifdef __NR_splice
+trace_event_syscall_enter(6, splice, int, fd_in, loff_t __user *, off_in, int, fd_out, loff_t __user *, off_out, size_t, len, unsigned int, flags);
+trace_event_syscall_exit(splice);
+#define ENTERCASEsplice create_syscall_enter(6, splice, int, loff_t __user *, int, loff_t __user *, size_t, unsigned int);
+#define EXITCASEsplice create_syscall_exit(splice);
+#else
+#define ENTERCASEsplice
+#define EXITCASEsplice
+#endif
+
+#ifdef __NR_vmsplice
+trace_event_syscall_enter(4, vmsplice, int, fd, const struct iovec __user *, iov, unsigned long, nr_segs, unsigned int, flags);
+trace_event_syscall_exit(vmsplice);
+#define ENTERCASEvmsplice create_syscall_enter(4, vmsplice, int, const struct iovec __user *, unsigned long, unsigned int);
+#define EXITCASEvmsplice create_syscall_exit(vmsplice);
+#else
+#define ENTERCASEvmsplice
+#define EXITCASEvmsplice
+#endif
+
+#ifdef __NR_tee
+trace_event_syscall_enter(4, tee, int, fdin, int, fdout, size_t, len, unsigned int, flags);
+trace_event_syscall_exit(tee);
+#define ENTERCASEtee create_syscall_enter(4, tee, int, int, size_t, unsigned int);
+#define EXITCASEtee create_syscall_exit(tee);
+#else
+#define ENTERCASEtee
+#define EXITCASEtee
+#endif
+
+#ifdef __NR_sync_file_range
+trace_event_syscall_enter(4, sync_file_range, int, fd, loff_t, offset, loff_t, nbytes, unsigned int, flags);
+trace_event_syscall_exit(sync_file_range);
+#define ENTERCASEsync_file_range create_syscall_enter(4, sync_file_range, int, loff_t, loff_t, unsigned int);
+#define EXITCASEsync_file_range create_syscall_exit(sync_file_range);
+#else
+#define ENTERCASEsync_file_range
+#define EXITCASEsync_file_range
+#endif
+
+#ifdef __NR_sync_file_range2
+trace_event_syscall_enter(4, sync_file_range2, int, fd, unsigned int, flags, loff_t, offset, loff_t, nbytes);
+trace_event_syscall_exit(sync_file_range2);
+#define ENTERCASEsync_file_range2 create_syscall_enter(4, sync_file_range2, int, unsigned int, loff_t, loff_t);
+#define EXITCASEsync_file_range2 create_syscall_exit(sync_file_range2);
+#else
+#define ENTERCASEsync_file_range2
+#define EXITCASEsync_file_range2
+#endif
+
+#ifdef __NR_get_robust_list
+trace_event_syscall_enter(3, get_robust_list, int, pid, struct robust_list_head __user * __user *, head_ptr, size_t __user *, len_ptr);
+trace_event_syscall_exit(get_robust_list);
+#define ENTERCASEget_robust_list create_syscall_enter(3, get_robust_list, int, struct robust_list_head __user * __user *, size_t __user *);
+#define EXITCASEget_robust_list create_syscall_exit(get_robust_list);
+#else
+#define ENTERCASEget_robust_list
+#define EXITCASEget_robust_list
+#endif
+
+#ifdef __NR_set_robust_list
+trace_event_syscall_enter(2, set_robust_list, struct robust_list_head __user *, head, size_t, len);
+trace_event_syscall_exit(set_robust_list);
+#define ENTERCASEset_robust_list create_syscall_enter(2, set_robust_list, struct robust_list_head __user *, size_t);
+#define EXITCASEset_robust_list create_syscall_exit(set_robust_list);
+#else
+#define ENTERCASEset_robust_list
+#define EXITCASEset_robust_list
+#endif
+
+#ifdef __NR_getcpu
+trace_event_syscall_enter(3, getcpu, unsigned __user *, cpu, unsigned __user *, node, struct getcpu_cache __user *, cache);
+trace_event_syscall_exit(getcpu);
+#define ENTERCASEgetcpu create_syscall_enter(3, getcpu, unsigned __user *, unsigned __user *, struct getcpu_cache __user *);
+#define EXITCASEgetcpu create_syscall_exit(getcpu);
+#else
+#define ENTERCASEgetcpu
+#define EXITCASEgetcpu
+#endif
+
+#ifdef __NR_signalfd
+trace_event_syscall_enter(3, signalfd, int, ufd, sigset_t __user *, user_mask, size_t, sizemask);
+trace_event_syscall_exit(signalfd);
+#define ENTERCASEsignalfd create_syscall_enter(3, signalfd, int, sigset_t __user *, size_t);
+#define EXITCASEsignalfd create_syscall_exit(signalfd);
+#else
+#define ENTERCASEsignalfd
+#define EXITCASEsignalfd
+#endif
+
+#ifdef __NR_signalfd4
+trace_event_syscall_enter(4, signalfd4, int, ufd, sigset_t __user *, user_mask, size_t, sizemask, int, flags);
+trace_event_syscall_exit(signalfd4);
+#define ENTERCASEsignalfd4 create_syscall_enter(4, signalfd4, int, sigset_t __user *, size_t, int);
+#define EXITCASEsignalfd4 create_syscall_exit(signalfd4);
+#else
+#define ENTERCASEsignalfd4
+#define EXITCASEsignalfd4
+#endif
+
+#ifdef __NR_timerfd_create
+trace_event_syscall_enter(2, timerfd_create, int, clockid, int, flags);
+trace_event_syscall_exit(timerfd_create);
+#define ENTERCASEtimerfd_create create_syscall_enter(2, timerfd_create, int, int);
+#define EXITCASEtimerfd_create create_syscall_exit(timerfd_create);
+#else
+#define ENTERCASEtimerfd_create
+#define EXITCASEtimerfd_create
+#endif
+
+#ifdef __NR_timerfd_settime
+trace_event_syscall_enter(4, timerfd_settime, int, ufd, int, flags, const struct itimerspec __user *, utmr, struct itimerspec __user *, otmr);
+trace_event_syscall_exit(timerfd_settime);
+#define ENTERCASEtimerfd_settime create_syscall_enter(4, timerfd_settime, int, int, const struct itimerspec __user *, struct itimerspec __user *);
+#define EXITCASEtimerfd_settime create_syscall_exit(timerfd_settime);
+#else
+#define ENTERCASEtimerfd_settime
+#define EXITCASEtimerfd_settime
+#endif
+
+#ifdef __NR_timerfd_gettime
+trace_event_syscall_enter(2, timerfd_gettime, int, ufd, struct itimerspec __user *, otmr);
+trace_event_syscall_exit(timerfd_gettime);
+#define ENTERCASEtimerfd_gettime create_syscall_enter(2, timerfd_gettime, int, struct itimerspec __user *);
+#define EXITCASEtimerfd_gettime create_syscall_exit(timerfd_gettime);
+#else
+#define ENTERCASEtimerfd_gettime
+#define EXITCASEtimerfd_gettime
+#endif
+
+#ifdef __NR_eventfd
+trace_event_syscall_enter(1, eventfd, unsigned int, count);
+trace_event_syscall_exit(eventfd);
+#define ENTERCASEeventfd create_syscall_enter(1, eventfd, unsigned int);
+#define EXITCASEeventfd create_syscall_exit(eventfd);
+#else
+#define ENTERCASEeventfd
+#define EXITCASEeventfd
+#endif
+
+#ifdef __NR_eventfd2
+trace_event_syscall_enter(2, eventfd2, unsigned int, count, int, flags);
+trace_event_syscall_exit(eventfd2);
+#define ENTERCASEeventfd2 create_syscall_enter(2, eventfd2, unsigned int, int);
+#define EXITCASEeventfd2 create_syscall_exit(eventfd2);
+#else
+#define ENTERCASEeventfd2
+#define EXITCASEeventfd2
+#endif
+
+#ifdef __NR_fallocate
+trace_event_syscall_enter(4, fallocate, int, fd, int, mode, loff_t, offset, loff_t, len);
+trace_event_syscall_exit(fallocate);
+#define ENTERCASEfallocate create_syscall_enter(4, fallocate, int, int, loff_t, loff_t);
+#define EXITCASEfallocate create_syscall_exit(fallocate);
+#else
+#define ENTERCASEfallocate
+#define EXITCASEfallocate
+#endif
+
+#ifdef __NR_old_readdir
+trace_event_syscall_enter(3, old_readdir, unsigned int, a, struct old_linux_dirent __user *, uptr, unsigned int, b);
+trace_event_syscall_exit(old_readdir);
+#define ENTERCASEold_readdir create_syscall_enter(3, old_readdir, unsigned int, struct old_linux_dirent __user *, unsigned int);
+#define EXITCASEold_readdir create_syscall_exit(old_readdir);
+#else
+#define ENTERCASEold_readdir
+#define EXITCASEold_readdir
+#endif
+
+#ifdef __NR_pselect6
+trace_event_syscall_enter(6, pselect6, int, a, fd_set __user *, b, fd_set __user *, c, fd_set __user *, d, struct timespec __user *, e, void __user *, f);
+trace_event_syscall_exit(pselect6);
+#define ENTERCASEpselect6 create_syscall_enter(6, pselect6, int, fd_set __user *, fd_set __user *, fd_set __user *, struct timespec __user *, void __user *);
+#define EXITCASEpselect6 create_syscall_exit(pselect6);
+#else
+#define ENTERCASEpselect6
+#define EXITCASEpselect6
+#endif
+
+#ifdef __NR_ppoll
+trace_event_syscall_enter(5, ppoll, struct pollfd __user *, a, unsigned int, b, struct timespec __user *, c, const sigset_t __user *, d, size_t, e);
+trace_event_syscall_exit(ppoll);
+#define ENTERCASEppoll create_syscall_enter(5, ppoll, struct pollfd __user *, unsigned int, struct timespec __user *, const sigset_t __user *, size_t);
+#define EXITCASEppoll create_syscall_exit(ppoll);
+#else
+#define ENTERCASEppoll
+#define EXITCASEppoll
+#endif
+
+#ifdef __NR_pipe2
+trace_event_syscall_enter(2, pipe2, int __user *, uptr, int, a);
+trace_event_syscall_exit(pipe2);
+#define ENTERCASEpipe2 create_syscall_enter(2, pipe2, int __user *, int);
+#define EXITCASEpipe2 create_syscall_exit(pipe2);
+#else
+#define ENTERCASEpipe2
+#define EXITCASEpipe2
+#endif
+
+#ifdef __NR_pipe
+trace_event_syscall_enter(1, pipe, int __user *, uptr);
+trace_event_syscall_exit(pipe);
+#define ENTERCASEpipe create_syscall_enter(1, pipe, int __user *);
+#define EXITCASEpipe create_syscall_exit(pipe);
+#else
+#define ENTERCASEpipe
+#define EXITCASEpipe
+#endif
+
+#ifdef __NR_perf_counter_open
+trace_event_syscall_enter(5, perf_counter_open, const struct perf_counter_hw_event __user *, hw_event_uptr, pid_t, pid, int, cpu, int, group_fd, unsigned long, flags);
+trace_event_syscall_exit(perf_counter_open);
+#define ENTERCASEperf_counter_open create_syscall_enter(5, perf_counter_open, const struct perf_counter_hw_event __user *, pid_t, int, int, unsigned long);
+#define EXITCASEperf_counter_open create_syscall_exit(perf_counter_open);
+#else
+#define ENTERCASEperf_counter_open
+#define EXITCASEperf_counter_open
+#endif
+
+#endif /* _TRACE_SYSCALLS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
+
+#ifndef SYSCALL_WRAPPER
+#define SYSCALL_WRAPPER
+
+static inline void __syscall_tracepoints_enter(struct pt_regs *regs)
+{
+	int syscall_nr;
+	long sys_args[MAX_SYS_ARGS];
+
+	syscall_nr = syscall_get_nr(current, regs);
+	switch (syscall_nr) {
+		ENTERCASEtime
+		ENTERCASEstime
+		ENTERCASEgettimeofday
+		ENTERCASEsettimeofday
+		ENTERCASEadjtimex
+		ENTERCASEtimes
+		ENTERCASEgettid
+		ENTERCASEnanosleep
+		ENTERCASEalarm
+		ENTERCASEgetpid
+		ENTERCASEgetppid
+		ENTERCASEgetuid
+		ENTERCASEgeteuid
+		ENTERCASEgetgid
+		ENTERCASEgetegid
+		ENTERCASEgetresuid
+		ENTERCASEgetresgid
+		ENTERCASEgetpgid
+		ENTERCASEgetpgrp
+		ENTERCASEgetsid
+		ENTERCASEgetgroups
+		ENTERCASEsetregid
+		ENTERCASEsetgid
+		ENTERCASEsetreuid
+		ENTERCASEsetuid
+		ENTERCASEsetresuid
+		ENTERCASEsetresgid
+		ENTERCASEsetfsuid
+		ENTERCASEsetfsgid
+		ENTERCASEsetpgid
+		ENTERCASEsetsid
+		ENTERCASEsetgroups
+		ENTERCASEacct
+		ENTERCASEcapget
+		ENTERCASEcapset
+		ENTERCASEpersonality
+		ENTERCASEsigpending
+		ENTERCASEsigprocmask
+		ENTERCASEgetitimer
+		ENTERCASEsetitimer
+		ENTERCASEtimer_create
+		ENTERCASEtimer_gettime
+		ENTERCASEtimer_getoverrun
+		ENTERCASEtimer_settime
+		ENTERCASEtimer_delete
+		ENTERCASEclock_settime
+		ENTERCASEclock_gettime
+		ENTERCASEclock_getres
+		ENTERCASEclock_nanosleep
+		ENTERCASEnice
+		ENTERCASEsched_setscheduler
+		ENTERCASEsched_setparam
+		ENTERCASEsched_getscheduler
+		ENTERCASEsched_getparam
+		ENTERCASEsched_setaffinity
+		ENTERCASEsched_getaffinity
+		ENTERCASEsched_yield
+		ENTERCASEsched_get_priority_max
+		ENTERCASEsched_get_priority_min
+		ENTERCASEsched_rr_get_interval
+		ENTERCASEsetpriority
+		ENTERCASEgetpriority
+		ENTERCASEshutdown
+		ENTERCASEreboot
+		ENTERCASErestart_syscall
+		ENTERCASEkexec_load
+		ENTERCASEexit
+		ENTERCASEexit_group
+		ENTERCASEwait4
+		ENTERCASEwaitid
+		ENTERCASEwaitpid
+		ENTERCASEset_tid_address
+		ENTERCASEfutex
+		ENTERCASEinit_module
+		ENTERCASEdelete_module
+		ENTERCASErt_sigprocmask
+		ENTERCASErt_sigpending
+		ENTERCASErt_sigtimedwait
+		ENTERCASEkill
+		ENTERCASEtgkill
+		ENTERCASEtkill
+		ENTERCASErt_sigqueueinfo
+		ENTERCASEsgetmask
+		ENTERCASEssetmask
+		ENTERCASEsignal
+		ENTERCASEpause
+		ENTERCASEsync
+		ENTERCASEfsync
+		ENTERCASEfdatasync
+		ENTERCASEbdflush
+		ENTERCASEmount
+		ENTERCASEumount
+		ENTERCASEoldumount
+		ENTERCASEtruncate
+		ENTERCASEftruncate
+		ENTERCASEstat
+		ENTERCASEstatfs
+		ENTERCASEstatfs64
+		ENTERCASEfstatfs
+		ENTERCASEfstatfs64
+		ENTERCASElstat
+		ENTERCASEfstat
+		ENTERCASEnewstat
+		ENTERCASEnewlstat
+		ENTERCASEnewfstat
+		ENTERCASEustat
+		ENTERCASEstat64
+		ENTERCASEfstat64
+		ENTERCASElstat64
+		ENTERCASEtruncate64
+		ENTERCASEftruncate64
+		ENTERCASEsetxattr
+		ENTERCASElsetxattr
+		ENTERCASEfsetxattr
+		ENTERCASEgetxattr
+		ENTERCASElgetxattr
+		ENTERCASEfgetxattr
+		ENTERCASElistxattr
+		ENTERCASEllistxattr
+		ENTERCASEflistxattr
+		ENTERCASEremovexattr
+		ENTERCASElremovexattr
+		ENTERCASEfremovexattr
+		ENTERCASEbrk
+		ENTERCASEmprotect
+		ENTERCASEmremap
+		ENTERCASEremap_file_pages
+		ENTERCASEmsync
+		ENTERCASEfadvise64
+		ENTERCASEfadvise64_64
+		ENTERCASEmunmap
+		ENTERCASEmlock
+		ENTERCASEmunlock
+		ENTERCASEmlockall
+		ENTERCASEmunlockall
+		ENTERCASEmadvise
+		ENTERCASEmincore
+		ENTERCASEpivot_root
+		ENTERCASEchroot
+		ENTERCASEmknod
+		ENTERCASElink
+		ENTERCASEsymlink
+		ENTERCASEunlink
+		ENTERCASErename
+		ENTERCASEchmod
+		ENTERCASEfchmod
+		ENTERCASEfcntl
+		ENTERCASEfcntl64
+		ENTERCASEdup
+		ENTERCASEdup2
+		ENTERCASEdup3
+		ENTERCASEioperm
+		ENTERCASEioctl
+		ENTERCASEflock
+		ENTERCASEio_setup
+		ENTERCASEio_destroy
+		ENTERCASEio_getevents
+		ENTERCASEio_submit
+		ENTERCASEio_cancel
+		ENTERCASEsendfile
+		ENTERCASEsendfile64
+		ENTERCASEreadlink
+		ENTERCASEcreat
+		ENTERCASEopen
+		ENTERCASEclose
+		ENTERCASEaccess
+		ENTERCASEvhangup
+		ENTERCASEchown
+		ENTERCASElchown
+		ENTERCASEfchown
+		ENTERCASEchown16
+		ENTERCASElchown16
+		ENTERCASEfchown16
+		ENTERCASEsetregid16
+		ENTERCASEsetgid16
+		ENTERCASEsetreuid16
+		ENTERCASEsetuid16
+		ENTERCASEsetresuid16
+		ENTERCASEgetresuid16
+		ENTERCASEsetresgid16
+		ENTERCASEgetresgid16
+		ENTERCASEsetfsuid16
+		ENTERCASEsetfsgid16
+		ENTERCASEgetgroups16
+		ENTERCASEsetgroups16
+		ENTERCASEgetuid16
+		ENTERCASEgeteuid16
+		ENTERCASEgetgid16
+		ENTERCASEgetegid16
+		ENTERCASEutime
+		ENTERCASEutimes
+		ENTERCASElseek
+		ENTERCASEllseek
+		ENTERCASEread
+		ENTERCASEreadahead
+		ENTERCASEreadv
+		ENTERCASEwrite
+		ENTERCASEwritev
+		ENTERCASEpread64
+		ENTERCASEpwrite64
+		ENTERCASEpreadv
+		ENTERCASEpwritev
+		ENTERCASEgetcwd
+		ENTERCASEmkdir
+		ENTERCASEchdir
+		ENTERCASEfchdir
+		ENTERCASErmdir
+		ENTERCASElookup_dcookie
+		ENTERCASEquotactl
+		ENTERCASEgetdents
+		ENTERCASEgetdents64
+		ENTERCASEsetsockopt
+		ENTERCASEgetsockopt
+		ENTERCASEbind
+		ENTERCASEconnect
+		ENTERCASEaccept
+		ENTERCASEaccept4
+		ENTERCASEgetsockname
+		ENTERCASEgetpeername
+		ENTERCASEsend
+		ENTERCASEsendto
+		ENTERCASEsendmsg
+		ENTERCASErecv
+		ENTERCASErecvfrom
+		ENTERCASErecvmsg
+		ENTERCASEsocket
+		ENTERCASEsocketpair
+		ENTERCASEsocketcall
+		ENTERCASElisten
+		ENTERCASEpoll
+		ENTERCASEselect
+		ENTERCASEepoll_create
+		ENTERCASEepoll_create1
+		ENTERCASEepoll_ctl
+		ENTERCASEepoll_wait
+		ENTERCASEepoll_pwait
+		ENTERCASEgethostname
+		ENTERCASEsethostname
+		ENTERCASEsetdomainname
+		ENTERCASEnewuname
+		ENTERCASEgetrlimit
+		ENTERCASEold_getrlimit
+		ENTERCASEsetrlimit
+		ENTERCASEgetrusage
+		ENTERCASEumask
+		ENTERCASEmsgget
+		ENTERCASEmsgsnd
+		ENTERCASEmsgrcv
+		ENTERCASEmsgctl
+		ENTERCASEsemget
+		ENTERCASEsemop
+		ENTERCASEsemctl
+		ENTERCASEsemtimedop
+		ENTERCASEshmat
+		ENTERCASEshmget
+		ENTERCASEshmdt
+		ENTERCASEshmctl
+		ENTERCASEmq_open
+		ENTERCASEmq_unlink
+		ENTERCASEmq_timedsend
+		ENTERCASEmq_timedreceive
+		ENTERCASEmq_notify
+		ENTERCASEmq_getsetattr
+		ENTERCASEpciconfig_iobase
+		ENTERCASEpciconfig_read
+		ENTERCASEpciconfig_write
+		ENTERCASEprctl
+		ENTERCASEswapon
+		ENTERCASEswapoff
+		ENTERCASEsysctl
+		ENTERCASEsysinfo
+		ENTERCASEsysfs
+		ENTERCASEnfsservctl
+		ENTERCASEsyslog
+		ENTERCASEuselib
+		ENTERCASEni_syscall
+		ENTERCASEptrace
+		ENTERCASEadd_key
+		ENTERCASErequest_key
+		ENTERCASEkeyctl
+		ENTERCASEioprio_set
+		ENTERCASEioprio_get
+		ENTERCASEset_mempolicy
+		ENTERCASEmigrate_pages
+		ENTERCASEmove_pages
+		ENTERCASEmbind
+		ENTERCASEget_mempolicy
+		ENTERCASEinotify_init
+		ENTERCASEinotify_init1
+		ENTERCASEinotify_add_watch
+		ENTERCASEinotify_rm_watch
+		ENTERCASEspu_run
+		ENTERCASEspu_create
+		ENTERCASEmknodat
+		ENTERCASEmkdirat
+		ENTERCASEunlinkat
+		ENTERCASEsymlinkat
+		ENTERCASElinkat
+		ENTERCASErenameat
+		ENTERCASEfutimesat
+		ENTERCASEfaccessat
+		ENTERCASEfchmodat
+		ENTERCASEfchownat
+		ENTERCASEopenat
+		ENTERCASEnewfstatat
+		ENTERCASEfstatat64
+		ENTERCASEreadlinkat
+		ENTERCASEutimensat
+		ENTERCASEunshare
+		ENTERCASEsplice
+		ENTERCASEvmsplice
+		ENTERCASEtee
+		ENTERCASEsync_file_range
+		ENTERCASEsync_file_range2
+		ENTERCASEget_robust_list
+		ENTERCASEset_robust_list
+		ENTERCASEgetcpu
+		ENTERCASEsignalfd
+		ENTERCASEsignalfd4
+		ENTERCASEtimerfd_create
+		ENTERCASEtimerfd_settime
+		ENTERCASEtimerfd_gettime
+		ENTERCASEeventfd
+		ENTERCASEeventfd2
+		ENTERCASEfallocate
+		ENTERCASEold_readdir
+		ENTERCASEpselect6
+		ENTERCASEppoll
+		ENTERCASEpipe2
+		ENTERCASEpipe
+		ENTERCASEperf_counter_open
+	}							
+}
+
+static inline void __syscall_tracepoints_exit(struct pt_regs * regs)
+{								
+	int syscall_nr;						
+	long ret;						
+								
+	syscall_nr = syscall_get_nr(current, regs);		
+	ret = syscall_get_return_value(current, regs);		
+	switch (syscall_nr) {					
+		EXITCASEtime
+		EXITCASEstime
+		EXITCASEgettimeofday
+		EXITCASEsettimeofday
+		EXITCASEadjtimex
+		EXITCASEtimes
+		EXITCASEgettid
+		EXITCASEnanosleep
+		EXITCASEalarm
+		EXITCASEgetpid
+		EXITCASEgetppid
+		EXITCASEgetuid
+		EXITCASEgeteuid
+		EXITCASEgetgid
+		EXITCASEgetegid
+		EXITCASEgetresuid
+		EXITCASEgetresgid
+		EXITCASEgetpgid
+		EXITCASEgetpgrp
+		EXITCASEgetsid
+		EXITCASEgetgroups
+		EXITCASEsetregid
+		EXITCASEsetgid
+		EXITCASEsetreuid
+		EXITCASEsetuid
+		EXITCASEsetresuid
+		EXITCASEsetresgid
+		EXITCASEsetfsuid
+		EXITCASEsetfsgid
+		EXITCASEsetpgid
+		EXITCASEsetsid
+		EXITCASEsetgroups
+		EXITCASEacct
+		EXITCASEcapget
+		EXITCASEcapset
+		EXITCASEpersonality
+		EXITCASEsigpending
+		EXITCASEsigprocmask
+		EXITCASEgetitimer
+		EXITCASEsetitimer
+		EXITCASEtimer_create
+		EXITCASEtimer_gettime
+		EXITCASEtimer_getoverrun
+		EXITCASEtimer_settime
+		EXITCASEtimer_delete
+		EXITCASEclock_settime
+		EXITCASEclock_gettime
+		EXITCASEclock_getres
+		EXITCASEclock_nanosleep
+		EXITCASEnice
+		EXITCASEsched_setscheduler
+		EXITCASEsched_setparam
+		EXITCASEsched_getscheduler
+		EXITCASEsched_getparam
+		EXITCASEsched_setaffinity
+		EXITCASEsched_getaffinity
+		EXITCASEsched_yield
+		EXITCASEsched_get_priority_max
+		EXITCASEsched_get_priority_min
+		EXITCASEsched_rr_get_interval
+		EXITCASEsetpriority
+		EXITCASEgetpriority
+		EXITCASEshutdown
+		EXITCASEreboot
+		EXITCASErestart_syscall
+		EXITCASEkexec_load
+		EXITCASEexit
+		EXITCASEexit_group
+		EXITCASEwait4
+		EXITCASEwaitid
+		EXITCASEwaitpid
+		EXITCASEset_tid_address
+		EXITCASEfutex
+		EXITCASEinit_module
+		EXITCASEdelete_module
+		EXITCASErt_sigprocmask
+		EXITCASErt_sigpending
+		EXITCASErt_sigtimedwait
+		EXITCASEkill
+		EXITCASEtgkill
+		EXITCASEtkill
+		EXITCASErt_sigqueueinfo
+		EXITCASEsgetmask
+		EXITCASEssetmask
+		EXITCASEsignal
+		EXITCASEpause
+		EXITCASEsync
+		EXITCASEfsync
+		EXITCASEfdatasync
+		EXITCASEbdflush
+		EXITCASEmount
+		EXITCASEumount
+		EXITCASEoldumount
+		EXITCASEtruncate
+		EXITCASEftruncate
+		EXITCASEstat
+		EXITCASEstatfs
+		EXITCASEstatfs64
+		EXITCASEfstatfs
+		EXITCASEfstatfs64
+		EXITCASElstat
+		EXITCASEfstat
+		EXITCASEnewstat
+		EXITCASEnewlstat
+		EXITCASEnewfstat
+		EXITCASEustat
+		EXITCASEstat64
+		EXITCASEfstat64
+		EXITCASElstat64
+		EXITCASEtruncate64
+		EXITCASEftruncate64
+		EXITCASEsetxattr
+		EXITCASElsetxattr
+		EXITCASEfsetxattr
+		EXITCASEgetxattr
+		EXITCASElgetxattr
+		EXITCASEfgetxattr
+		EXITCASElistxattr
+		EXITCASEllistxattr
+		EXITCASEflistxattr
+		EXITCASEremovexattr
+		EXITCASElremovexattr
+		EXITCASEfremovexattr
+		EXITCASEbrk
+		EXITCASEmprotect
+		EXITCASEmremap
+		EXITCASEremap_file_pages
+		EXITCASEmsync
+		EXITCASEfadvise64
+		EXITCASEfadvise64_64
+		EXITCASEmunmap
+		EXITCASEmlock
+		EXITCASEmunlock
+		EXITCASEmlockall
+		EXITCASEmunlockall
+		EXITCASEmadvise
+		EXITCASEmincore
+		EXITCASEpivot_root
+		EXITCASEchroot
+		EXITCASEmknod
+		EXITCASElink
+		EXITCASEsymlink
+		EXITCASEunlink
+		EXITCASErename
+		EXITCASEchmod
+		EXITCASEfchmod
+		EXITCASEfcntl
+		EXITCASEfcntl64
+		EXITCASEdup
+		EXITCASEdup2
+		EXITCASEdup3
+		EXITCASEioperm
+		EXITCASEioctl
+		EXITCASEflock
+		EXITCASEio_setup
+		EXITCASEio_destroy
+		EXITCASEio_getevents
+		EXITCASEio_submit
+		EXITCASEio_cancel
+		EXITCASEsendfile
+		EXITCASEsendfile64
+		EXITCASEreadlink
+		EXITCASEcreat
+		EXITCASEopen
+		EXITCASEclose
+		EXITCASEaccess
+		EXITCASEvhangup
+		EXITCASEchown
+		EXITCASElchown
+		EXITCASEfchown
+		EXITCASEchown16
+		EXITCASElchown16
+		EXITCASEfchown16
+		EXITCASEsetregid16
+		EXITCASEsetgid16
+		EXITCASEsetreuid16
+		EXITCASEsetuid16
+		EXITCASEsetresuid16
+		EXITCASEgetresuid16
+		EXITCASEsetresgid16
+		EXITCASEgetresgid16
+		EXITCASEsetfsuid16
+		EXITCASEsetfsgid16
+		EXITCASEgetgroups16
+		EXITCASEsetgroups16
+		EXITCASEgetuid16
+		EXITCASEgeteuid16
+		EXITCASEgetgid16
+		EXITCASEgetegid16
+		EXITCASEutime
+		EXITCASEutimes
+		EXITCASElseek
+		EXITCASEllseek
+		EXITCASEread
+		EXITCASEreadahead
+		EXITCASEreadv
+		EXITCASEwrite
+		EXITCASEwritev
+		EXITCASEpread64
+		EXITCASEpwrite64
+		EXITCASEpreadv
+		EXITCASEpwritev
+		EXITCASEgetcwd
+		EXITCASEmkdir
+		EXITCASEchdir
+		EXITCASEfchdir
+		EXITCASErmdir
+		EXITCASElookup_dcookie
+		EXITCASEquotactl
+		EXITCASEgetdents
+		EXITCASEgetdents64
+		EXITCASEsetsockopt
+		EXITCASEgetsockopt
+		EXITCASEbind
+		EXITCASEconnect
+		EXITCASEaccept
+		EXITCASEaccept4
+		EXITCASEgetsockname
+		EXITCASEgetpeername
+		EXITCASEsend
+		EXITCASEsendto
+		EXITCASEsendmsg
+		EXITCASErecv
+		EXITCASErecvfrom
+		EXITCASErecvmsg
+		EXITCASEsocket
+		EXITCASEsocketpair
+		EXITCASEsocketcall
+		EXITCASElisten
+		EXITCASEpoll
+		EXITCASEselect
+		EXITCASEepoll_create
+		EXITCASEepoll_create1
+		EXITCASEepoll_ctl
+		EXITCASEepoll_wait
+		EXITCASEepoll_pwait
+		EXITCASEgethostname
+		EXITCASEsethostname
+		EXITCASEsetdomainname
+		EXITCASEnewuname
+		EXITCASEgetrlimit
+		EXITCASEold_getrlimit
+		EXITCASEsetrlimit
+		EXITCASEgetrusage
+		EXITCASEumask
+		EXITCASEmsgget
+		EXITCASEmsgsnd
+		EXITCASEmsgrcv
+		EXITCASEmsgctl
+		EXITCASEsemget
+		EXITCASEsemop
+		EXITCASEsemctl
+		EXITCASEsemtimedop
+		EXITCASEshmat
+		EXITCASEshmget
+		EXITCASEshmdt
+		EXITCASEshmctl
+		EXITCASEmq_open
+		EXITCASEmq_unlink
+		EXITCASEmq_timedsend
+		EXITCASEmq_timedreceive
+		EXITCASEmq_notify
+		EXITCASEmq_getsetattr
+		EXITCASEpciconfig_iobase
+		EXITCASEpciconfig_read
+		EXITCASEpciconfig_write
+		EXITCASEprctl
+		EXITCASEswapon
+		EXITCASEswapoff
+		EXITCASEsysctl
+		EXITCASEsysinfo
+		EXITCASEsysfs
+		EXITCASEnfsservctl
+		EXITCASEsyslog
+		EXITCASEuselib
+		EXITCASEni_syscall
+		EXITCASEptrace
+		EXITCASEadd_key
+		EXITCASErequest_key
+		EXITCASEkeyctl
+		EXITCASEioprio_set
+		EXITCASEioprio_get
+		EXITCASEset_mempolicy
+		EXITCASEmigrate_pages
+		EXITCASEmove_pages
+		EXITCASEmbind
+		EXITCASEget_mempolicy
+		EXITCASEinotify_init
+		EXITCASEinotify_init1
+		EXITCASEinotify_add_watch
+		EXITCASEinotify_rm_watch
+		EXITCASEspu_run
+		EXITCASEspu_create
+		EXITCASEmknodat
+		EXITCASEmkdirat
+		EXITCASEunlinkat
+		EXITCASEsymlinkat
+		EXITCASElinkat
+		EXITCASErenameat
+		EXITCASEfutimesat
+		EXITCASEfaccessat
+		EXITCASEfchmodat
+		EXITCASEfchownat
+		EXITCASEopenat
+		EXITCASEnewfstatat
+		EXITCASEfstatat64
+		EXITCASEreadlinkat
+		EXITCASEutimensat
+		EXITCASEunshare
+		EXITCASEsplice
+		EXITCASEvmsplice
+		EXITCASEtee
+		EXITCASEsync_file_range
+		EXITCASEsync_file_range2
+		EXITCASEget_robust_list
+		EXITCASEset_robust_list
+		EXITCASEgetcpu
+		EXITCASEsignalfd
+		EXITCASEsignalfd4
+		EXITCASEtimerfd_create
+		EXITCASEtimerfd_settime
+		EXITCASEtimerfd_gettime
+		EXITCASEeventfd
+		EXITCASEeventfd2
+		EXITCASEfallocate
+		EXITCASEold_readdir
+		EXITCASEpselect6
+		EXITCASEppoll
+		EXITCASEpipe2
+		EXITCASEpipe
+		EXITCASEperf_counter_open
+	}	
+}
+
+#endif	/* SYSCALL_WRAPPER */
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 8cfe515..7ebd7c1 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -25,11 +25,17 @@ extern void start_ftrace_syscalls(void);
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
index 665a915..e708f76 100644
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
@@ -3312,6 +3314,101 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
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
+        unsigned long flags;
+        struct task_struct *g, *t;
+
+        mutex_lock(&syscall_trace_lock);
+        /* Don't enable the flag on the tasks twice */
+        if (sys_enabled)
+                goto unlock;
+        arch_init_ftrace_syscalls();
+        read_lock_irqsave(&tasklist_lock, flags);
+        do_each_thread(g, t) {
+                set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+        } while_each_thread(g, t);
+        read_unlock_irqrestore(&tasklist_lock, flags);
+        sys_enabled = true;
+
+unlock:
+        mutex_unlock(&syscall_trace_lock);
+}
+
+void stop_ftrace_syscalls(void)
+{
+        unsigned long flags;
+        struct task_struct *g, *t;
+
+        mutex_lock(&syscall_trace_lock);
+        read_lock_irqsave(&tasklist_lock, flags);
+        do_each_thread(g, t) {
+                clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+        } while_each_thread(g, t);
+        read_unlock_irqrestore(&tasklist_lock, flags);
+        sys_enabled = false;
+        mutex_unlock(&syscall_trace_lock);
+}
+
+static ssize_t write_tracesys(struct file *file, const char __user *user_buf,
+                                                size_t count, loff_t *ppos)
+{
+        char buf[32];
+        int buf_size;
+
+        buf_size = min(count, (sizeof(buf)-1));
+        if (copy_from_user(buf, user_buf, buf_size))
+                return -EFAULT;
+
+        switch (buf[0]) {
+        case '1':
+                start_ftrace_syscalls();
+                break;
+        case '0':
+                stop_ftrace_syscalls();
+                break;
+        }
+
+        return count;
+}
+
+static ssize_t read_tracesys(struct file *file,
+               char __user *user_buf, size_t count, loff_t *ppos)
+{
+        char buf[3];
+
+        if (sys_enabled)
+                buf[0] = '1';
+        else
+                buf[0] = '0';
+        buf[1] = '\n';
+        buf[2] = 0x00;
+        return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
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
@@ -4095,6 +4192,10 @@ static __init int tracer_init_debugfs(void)
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

