Return-Path: <linux-kernel-owner+w=401wt.eu-S2992690AbXDYK5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992690AbXDYK5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992687AbXDYK5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:57:54 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:44765 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161865AbXDYK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:57:51 -0400
Message-ID: <462F3483.2020602@ru.mvista.com>
Date: Wed, 25 Apr 2007 14:59:15 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] Performance Stats: Kernel patch
References: <4625FFCF.8040402@ru.mvista.com> <20070419213614.6416a2be.akpm@linux-foundation.org>
In-Reply-To: <20070419213614.6416a2be.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------090908080506080506030202"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090908080506080506030202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Andrew,

I've added taskstats interface to that. Patch is attached.
Please also see my answers bellow.

Andrew Morton wrote:

>(re-added lklml)
>
>  
>
>>Patch makes available to the user the following 
>>thread performance statistics:
>>   * Involuntary Context Switches (task_struct->nivcsw)
>>   * Voluntary Context Switches (task_struct->nvcsw)
>>    
>>
>
>I suppose they might be useful, but I'd be interested in hearing what
>the uses of this information are - why is it valuable?
>
>  
>
We have had a customer request this feature.  I'm not sure exactly why they
want this feature, but in a telecom system it is very common to monitor
statistical information about various parts of the system and watch for
anomalies and trends.  If one of these statistics has a sudden spike or 
has a
gradual trend, the operator knows they need to take action before a problem
occurs or can go back and analyze why a spike occurred.

>>   * Number of system calls (added new counter 
>>     thread_info->sysc_cnt)
>>    
>>
>
>eek.  syscall entry is a really hot hotpath, and, perhaps worse, it's the
>sort of thing which people often measure ;)
>
>I agree that this is a potentially interesting piece of instrumentation,
>but it would need to be _super_ interesting to justify just the single
>instruction overhead, and the cacheline touch.
>
>So, again, please provide justification for this additional overhead.
>
>  
>
Overhead is too small. And it is difficult to measure this difference.
I tried to measure syscall execution time with lat_syscall program
from lmbench package. I run each tests for 2-3 hours  with different
syscalls on qemu UP machine.

Test is:
./lat_syscall -N 1000 null
./lat_syscall -N 1000 read
./lat_syscall -N 1000 write
./lat_syscall -N 1000 stat
./lat_syscall -N 1000 fstat
./lat_syscall -N 1000 open

Result is  that  syscall patch is in the middle of  3 execution
without patch.

without patch:

Simple syscall: 1.0660 microseconds
Simple read: 3.5032 microseconds
Simple write: 2.6576 microseconds
Simple stat: 41.0829 microseconds
Simple fstat: 10.1343 microseconds
Simple open/close: 904.6792 microseconds

Simple syscall: 0.9961 microseconds
Simple read: 3.0027 microseconds
Simple write: 2.1600 microseconds
Simple stat: 47.7678 microseconds
Simple fstat: 10.8242 microseconds
Simple open/close: 905.9916 microseconds

Simple syscall: 1.0035 microseconds
Simple read: 3.0627 microseconds
Simple write: 2.1435 microseconds
Simple stat: 39.1947 microseconds
Simple fstat: 10.2982 microseconds
Simple open/close: 849.1624 microseconds


with patch:

Simple syscall: 1.0013 microseconds
Simple read: 3.6981 microseconds
Simple write: 2.6216 microseconds
Simple stat: 43.5101 microseconds
Simple fstat: 11.1318 microseconds
Simple open/close: 925.4793 microseconds

Because this measurement will be used with taskstats interface
I left it under ifdef CONFIG_TASKSTATS.

Best regards,
Maxim.


--------------090908080506080506030202
Content-Type: text/plain;
 name="perf_stat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf_stat.patch"

-------------------------------------------------------

Patch makes available to the user the following 
task and process performance statistics:
   * Involuntary Context Switches (task_struct->nivcsw)
   * Voluntary Context Switches (task_struct->nvcsw)
   * Number of system calls (added new counter 
     thread_info->sysall_count)

Statistics information is available from:
	1. taskstats interface (Documentation/accounting/)
	2. /proc/PID/status (task only).
   
This data is useful for detecting hyperactivity 
patterns between processes.

Signed-off-by: Maxim Uvarov muvarov@ru.mvista.com

 Documentation/accounting/getdelays.c          |   20 ++++++++++++++++++--
 Documentation/accounting/taskstats-struct.txt |    7 +++++++
 arch/i386/kernel/asm-offsets.c                |    1 +
 arch/i386/kernel/entry.S                      |    1 +
 arch/powerpc/kernel/asm-offsets.c             |    2 ++
 arch/powerpc/kernel/entry_32.S                |    5 +++++
 arch/powerpc/kernel/entry_64.S                |    5 +++++
 arch/x86_64/kernel/asm-offsets.c              |    1 +
 arch/x86_64/kernel/entry.S                    |    1 +
 fs/proc/array.c                               |   14 ++++++++++++++
 include/asm-i386/thread_info.h                |    1 +
 include/asm-powerpc/thread_info.h             |    1 +
 include/asm-x86_64/thread_info.h              |    1 +
 include/linux/taskstats.h                     |    6 +++++-
 kernel/fork.c                                 |    4 ++++
 kernel/taskstats.c                            |    6 ++++++
 16 files changed, 73 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc5/fs/proc/array.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/proc/array.c
+++ linux-2.6.21-rc5/fs/proc/array.c
@@ -290,6 +290,19 @@ static inline char *task_cap(struct task
 			    cap_t(p->cap_permitted),
 			    cap_t(p->cap_effective));
 }
+static inline char *task_perf(struct task_struct *p, char *buffer)
+{
+	/* Syscall counter adds 1 line overhead on each syscall execution
+	 * in entry.S, so probably it is the leave this stuff under ifdefs.
+	 */
+#ifdef CONFIG_TASKSTATS
+	buffer += sprintf(buffer, "Syscalls:\t%lu\n", p->thread_info->syscall_count);
+#endif
+	return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
+                           "Nivcsw:\t%lu\n",
+                           p->nvcsw,
+                           p->nivcsw);
+}
 
 int proc_pid_status(struct task_struct *task, char * buffer)
 {
@@ -309,6 +322,7 @@ int proc_pid_status(struct task_struct *
 #if defined(CONFIG_S390)
 	buffer = task_show_regs(task, buffer);
 #endif
+	buffer = task_perf(task, buffer);
 	return buffer - orig;
 }
 
Index: linux-2.6.21-rc5/kernel/fork.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/fork.c
+++ linux-2.6.21-rc5/kernel/fork.c
@@ -1044,6 +1044,10 @@ static struct task_struct *copy_process(
 	p->syscr = 0;		/* I/O counter: read syscalls */
 	p->syscw = 0;		/* I/O counter: write syscalls */
 #endif
+#ifdef	CONFIG_TASKSTATS
+        p->thread_info->syscall_count = 0;   /* Syscall counter: total numbers of syscalls */
+#endif
+
 	task_io_accounting_init(p);
 	acct_clear_integrals(p);
 
Index: linux-2.6.21-rc5/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/entry.S
+++ linux-2.6.21-rc5/arch/i386/kernel/entry.S
@@ -334,6 +334,7 @@ sysenter_past_esp:
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
+	incl	TI_syscall_count(%ebp)	# Increment syscalls counter
 
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
 	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
Index: linux-2.6.21-rc5/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/asm-offsets.c
+++ linux-2.6.21-rc5/arch/i386/kernel/asm-offsets.c
@@ -56,6 +56,7 @@ void foo(void)
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
 	OFFSET(TI_restart_block, thread_info, restart_block);
 	OFFSET(TI_sysenter_return, thread_info, sysenter_return);
+	OFFSET(TI_syscall_count, thread_info, syscall_count);
 	BLANK();
 
 	OFFSET(GDS_size, Xgt_desc_struct, size);
Index: linux-2.6.21-rc5/include/asm-i386/thread_info.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-i386/thread_info.h
+++ linux-2.6.21-rc5/include/asm-i386/thread_info.h
@@ -33,6 +33,7 @@ struct thread_info {
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
 
 
+	unsigned long		syscall_count;	/* Syscall counter */
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread
Index: linux-2.6.21-rc5/arch/powerpc/kernel/asm-offsets.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/asm-offsets.c
+++ linux-2.6.21-rc5/arch/powerpc/kernel/asm-offsets.c
@@ -94,6 +94,8 @@ int main(void)
 	DEFINE(TI_LOCAL_FLAGS, offsetof(struct thread_info, local_flags));
 	DEFINE(TI_PREEMPT, offsetof(struct thread_info, preempt_count));
 	DEFINE(TI_TASK, offsetof(struct thread_info, task));
+	DEFINE(TI_SYSCALL_COUNT, offsetof(struct thread_info, syscall_count));
+
 #ifdef CONFIG_PPC32
 	DEFINE(TI_EXECDOMAIN, offsetof(struct thread_info, exec_domain));
 	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
Index: linux-2.6.21-rc5/arch/powerpc/kernel/entry_32.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/entry_32.S
+++ linux-2.6.21-rc5/arch/powerpc/kernel/entry_32.S
@@ -202,6 +202,11 @@ _GLOBAL(DoSyscall)
 	bl	do_show_syscall
 #endif /* SHOW_SYSCALLS */
 	rlwinm	r10,r1,0,0,(31-THREAD_SHIFT)	/* current_thread_info() */
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	lwz r11,TI_SYSC_CNT(r10)
+	addi r11,r11,1
+	stw r11,TI_SYSC_CNT(r10)
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	lwz	r11,TI_FLAGS(r10)
 	andi.	r11,r11,_TIF_SYSCALL_T_OR_A
 	bne-	syscall_dotrace
Index: linux-2.6.21-rc5/arch/powerpc/kernel/entry_64.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/entry_64.S
+++ linux-2.6.21-rc5/arch/powerpc/kernel/entry_64.S
@@ -115,6 +115,11 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_ISER
 	addi	r9,r1,STACK_FRAME_OVERHEAD
 #endif
 	clrrdi	r11,r1,THREAD_SHIFT
+#ifdef CONFIG_TASKSTATS
+	ld r10,TI_SYSCALL_COUNT(r11)
+	addi r10,r10,1
+	std r10,TI_SYSCALL_COUNT(r11)
+#endif
 	ld	r10,TI_FLAGS(r11)
 	andi.	r11,r10,_TIF_SYSCALL_T_OR_A
 	bne-	syscall_dotrace
Index: linux-2.6.21-rc5/arch/x86_64/kernel/asm-offsets.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/asm-offsets.c
+++ linux-2.6.21-rc5/arch/x86_64/kernel/asm-offsets.c
@@ -35,6 +35,7 @@ int main(void)
 	ENTRY(addr_limit);
 	ENTRY(preempt_count);
 	ENTRY(status);
+	ENTRY(syscall_count);
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
Index: linux-2.6.21-rc5/arch/x86_64/kernel/entry.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/entry.S
+++ linux-2.6.21-rc5/arch/x86_64/kernel/entry.S
@@ -229,6 +229,7 @@ ENTRY(system_call)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
+	addq $1, threadinfo_syscall_count(%rcx)   # Increment syscalls counter
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
Index: linux-2.6.21-rc5/include/asm-powerpc/thread_info.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-powerpc/thread_info.h
+++ linux-2.6.21-rc5/include/asm-powerpc/thread_info.h
@@ -35,6 +35,7 @@ struct thread_info {
 	int		cpu;			/* cpu we're on */
 	int		preempt_count;		/* 0 => preemptable,
 						   <0 => BUG */
+	unsigned long	syscall_count;		/* Syscall counter */
 	struct restart_block restart_block;
 	unsigned long	local_flags;		/* private flags for thread */
 
Index: linux-2.6.21-rc5/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-x86_64/thread_info.h
+++ linux-2.6.21-rc5/include/asm-x86_64/thread_info.h
@@ -31,6 +31,7 @@ struct thread_info {
 	__u32			cpu;		/* current CPU */
 	int 			preempt_count;	/* 0 => preemptable, <0 => BUG */
 
+	unsigned long		syscall_count;	/* Syscall counter */
 	mm_segment_t		addr_limit;	
 	struct restart_block    restart_block;
 };
Index: linux-2.6.21-rc5/Documentation/accounting/getdelays.c
===================================================================
--- linux-2.6.21-rc5.orig/Documentation/accounting/getdelays.c
+++ linux-2.6.21-rc5/Documentation/accounting/getdelays.c
@@ -49,6 +49,7 @@ char name[100];
 int dbg;
 int print_delays;
 int print_io_accounting;
+int print_task_stats;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -187,7 +188,7 @@ void print_delayacct(struct taskstats *t
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n\n",
+	       "      %15llu%15llu\n"
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
@@ -196,6 +197,15 @@ void print_delayacct(struct taskstats *t
 	       "count", "delay total", t->swapin_count, t->swapin_delay_total);
 }
 
+void print_taskstats(struct taskstats *t)
+{
+	printf("\n\nTask  %15s%15s%15s\n"
+	       "      %15lu%15lu%15lu\n",
+	       "syscalls", "voluntary", "nonvoluntary",
+	       t->syscall_counter, t->nvcsw, t->nivcsw);
+
+}
+
 void print_ioacct(struct taskstats *t)
 {
 	printf("%s: read=%llu, write=%llu, cancelled_write=%llu\n",
@@ -227,7 +237,7 @@ int main(int argc, char *argv[])
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "diw:r:m:t:p:v:l");
+		c = getopt(argc, argv, "qdiw:r:m:t:p:v:l");
 		if (c < 0)
 			break;
 
@@ -240,6 +250,10 @@ int main(int argc, char *argv[])
 			printf("printing IO accounting\n");
 			print_io_accounting = 1;
 			break;
+		case 'q':
+			printf("printing task/process stasistics:\n");
+			print_task_stats = 1;
+			break;
 		case 'w':
 			strncpy(logfile, optarg, MAX_FILENAME);
 			printf("write to file %s\n", logfile);
@@ -381,6 +395,8 @@ int main(int argc, char *argv[])
 							print_delayacct((struct taskstats *) NLA_DATA(na));
 						if (print_io_accounting)
 							print_ioacct((struct taskstats *) NLA_DATA(na));
+						if (print_task_stats)
+							print_taskstats((struct taskstats *) NLA_DATA(na));
 						if (fd) {
 							if (write(fd, NLA_DATA(na), na->nla_len) < 0) {
 								err(1,"write error\n");
Index: linux-2.6.21-rc5/include/linux/taskstats.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/taskstats.h
+++ linux-2.6.21-rc5/include/linux/taskstats.h
@@ -31,7 +31,7 @@
  */
 
 
-#define TASKSTATS_VERSION	3
+#define TASKSTATS_VERSION	4
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -141,6 +141,10 @@ struct taskstats {
 	__u64	write_syscalls;		/* write syscalls */
 	/* Extended accounting fields end */
 
+	__u32  syscall_counter;   /* Syscall counter */
+	__u32  nvcsw;
+	__u32  nivcsw;
+
 #define TASKSTATS_HAS_IO_ACCOUNTING
 	/* Per-task storage I/O accounting starts */
 	__u64	read_bytes;		/* bytes of read I/O */
Index: linux-2.6.21-rc5/kernel/taskstats.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/taskstats.c
+++ linux-2.6.21-rc5/kernel/taskstats.c
@@ -196,6 +196,9 @@ static int fill_pid(pid_t pid, struct ta
 
 	/* fill in basic acct fields */
 	stats->version = TASKSTATS_VERSION;
+	stats->syscall_counter = tsk->thread_info->syscall_count;
+	stats->nvcsw = tsk->nvcsw;
+	stats->nivcsw = tsk->nivcsw;
 	bacct_add_tsk(stats, tsk);
 
 	/* fill in extended acct fields */
@@ -242,6 +245,9 @@ static int fill_tgid(pid_t tgid, struct 
 		 */
 		delayacct_add_tsk(stats, tsk);
 
+		stats->syscall_counter += tsk->thread_info->syscall_count;
+		stats->nvcsw += tsk->nvcsw;
+		stats->nivcsw += tsk->nivcsw;
 	} while_each_thread(first, tsk);
 
 	unlock_task_sighand(first, &flags);
Index: linux-2.6.21-rc5/Documentation/accounting/taskstats-struct.txt
===================================================================
--- linux-2.6.21-rc5.orig/Documentation/accounting/taskstats-struct.txt
+++ linux-2.6.21-rc5/Documentation/accounting/taskstats-struct.txt
@@ -22,6 +22,8 @@ There are three different groups of fiel
     /* Extended accounting fields end */
     Their values are collected if CONFIG_TASK_XACCT is set.
 
+4) Per-task and per-thread statistics
+
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
 
@@ -158,4 +160,9 @@ struct taskstats {
 
 	/* Extended accounting fields end */
 
+4) Per-task and per-thread statiscits
+	__u32	syscall_counter;	/* Syscall counter */
+	__u32	nvcsw;			/* Context voluntary switch counter */
+	__u32	nivcsw;			/* Context involuntary switch counter */
+
 }

--------------090908080506080506030202--
