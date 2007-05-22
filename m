Return-Path: <linux-kernel-owner+w=401wt.eu-S1760906AbXEVNUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906AbXEVNUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 09:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbXEVNUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 09:20:05 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:23091 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755931AbXEVNUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 09:20:01 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: <linuxppc-dev@ozlabs.org>
From: Maxim Uvarov <muvarov@ru.mvista.com>
Subject: [PATCH] Performance Stats: Kernel patch
Date: Tue, 22 May 2007 17:19:52 +0000
Message-ID: <20070522171950.23728.95735.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

Sorry for bothering you. I know you are very busy but could 
you please tell me what is situation of this patch? You wrote 
me you'll discuss  it with someone about it and say can it be 
accepted or not and in which form.  As I understand the 
situation all problems now are in syscall counter.  What 
about other counters?

I changed headers and re-resent patch as you asked. Are there any new?

If it could be accepted I can do fast syscalls  counting  too.


Thank you very much,
Maxim.

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

Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>
                                                      
---

 Documentation/accounting/getdelays.c          |   20 ++++++++++++++++++--
 Documentation/accounting/taskstats-struct.txt |    7 +++++++
 arch/i386/kernel/asm-offsets.c                |    1 +
 arch/i386/kernel/entry.S                      |    3 +++
 arch/powerpc/kernel/asm-offsets.c             |    2 ++
 arch/powerpc/kernel/entry_32.S                |    5 +++++
 arch/powerpc/kernel/entry_64.S                |    5 +++++
 arch/x86_64/kernel/asm-offsets.c              |    1 +
 arch/x86_64/kernel/entry.S                    |    3 +++
 fs/proc/array.c                               |   14 ++++++++++++++
 include/asm-i386/thread_info.h                |    1 +
 include/asm-powerpc/thread_info.h             |    1 +
 include/asm-x86_64/thread_info.h              |    1 +
 include/linux/taskstats.h                     |    6 +++++-
 kernel/fork.c                                 |    3 +++
 kernel/taskstats.c                            |    6 ++++++
 16 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index e9126e7..1be7d65 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -49,6 +49,7 @@ char name[100];
 int dbg;
 int print_delays;
 int print_io_accounting;
+int print_task_stats;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -187,7 +188,7 @@ void print_delayacct(struct taskstats *t)
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n\n",
+	       "      %15llu%15llu\n"
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
@@ -196,6 +197,15 @@ void print_delayacct(struct taskstats *t)
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
diff --git a/Documentation/accounting/taskstats-struct.txt b/Documentation/accounting/taskstats-struct.txt
index 661c797..606aef6 100644
--- a/Documentation/accounting/taskstats-struct.txt
+++ b/Documentation/accounting/taskstats-struct.txt
@@ -22,6 +22,8 @@ There are three different groups of fields in the struct taskstats:
     /* Extended accounting fields end */
     Their values are collected if CONFIG_TASK_XACCT is set.
 
+4) Per-task and per-thread statistics
+
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
 
@@ -158,4 +160,9 @@ struct taskstats {
 
 	/* Extended accounting fields end */
 
+4) Per-task and per-thread statiscits
+	__u64	syscall_counter;	/* Syscall counter */
+	__u64	nvcsw;			/* Context voluntary switch counter */
+	__u64	nivcsw;			/* Context involuntary switch counter */
+
 }
diff --git a/arch/i386/kernel/asm-offsets.c b/arch/i386/kernel/asm-offsets.c
index 1b2f3cd..4ad49d2 100644
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
@@ -56,6 +56,7 @@ void foo(void)
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
 	OFFSET(TI_restart_block, thread_info, restart_block);
 	OFFSET(TI_sysenter_return, thread_info, sysenter_return);
+	OFFSET(TI_syscall_count, thread_info, syscall_count);
 	BLANK();
 
 	OFFSET(GDS_size, Xgt_desc_struct, size);
diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
index 5e47683..836961f 100644
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -332,6 +332,9 @@ sysenter_past_esp:
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
 
+#ifdef CONFIG_TASKSTATS
+	incl	TI_syscall_count(%ebp)	# Increment syscalls counter
+#endif
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
 	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
 	jnz syscall_trace_entry
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 030d300..b640039 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -94,6 +94,8 @@ int main(void)
 	DEFINE(TI_LOCAL_FLAGS, offsetof(struct thread_info, local_flags));
 	DEFINE(TI_PREEMPT, offsetof(struct thread_info, preempt_count));
 	DEFINE(TI_TASK, offsetof(struct thread_info, task));
+	DEFINE(TI_SYSCALL_COUNT, offsetof(struct thread_info, syscall_count));
+
 #ifdef CONFIG_PPC32
 	DEFINE(TI_EXECDOMAIN, offsetof(struct thread_info, exec_domain));
 	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index c03e829..5d919e4 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -202,6 +202,11 @@ _GLOBAL(DoSyscall)
 	bl	do_show_syscall
 #endif /* SHOW_SYSCALLS */
 	rlwinm	r10,r1,0,0,(31-THREAD_SHIFT)	/* current_thread_info() */
+#ifdef CONFIG_TASKSTATS 
+	lwz r11,TI_SYSC_CNT(r10)
+	addi r11,r11,1
+	stw r11,TI_SYSC_CNT(r10)
+#endif
 	lwz	r11,TI_FLAGS(r10)
 	andi.	r11,r11,_TIF_SYSCALL_T_OR_A
 	bne-	syscall_dotrace
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 2551c08..5907f76 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -115,6 +115,11 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_ISERIES)
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
diff --git a/arch/x86_64/kernel/asm-offsets.c b/arch/x86_64/kernel/asm-offsets.c
index 96687e2..da57356 100644
--- a/arch/x86_64/kernel/asm-offsets.c
+++ b/arch/x86_64/kernel/asm-offsets.c
@@ -35,6 +35,7 @@ int main(void)
 	ENTRY(addr_limit);
 	ENTRY(preempt_count);
 	ENTRY(status);
+	ENTRY(syscall_count);
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
diff --git a/arch/x86_64/kernel/entry.S b/arch/x86_64/kernel/entry.S
index 9f5dac6..af40ead 100644
--- a/arch/x86_64/kernel/entry.S
+++ b/arch/x86_64/kernel/entry.S
@@ -229,6 +229,9 @@ ENTRY(system_call)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
+#ifdef CONFIG_TASKSTATS
+	addq $1, threadinfo_syscall_count(%rcx)   # Increment syscalls counter
+#endif
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 70e4fab..c805c08 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -290,6 +290,19 @@ static inline char *task_cap(struct task_struct *p, char *buffer)
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
+	return buffer + sprintf(buffer, "voluntary_ctxt_switches:\t%lu\n"
+			    "nonvoluntary_ctxt_switches:\t%lu\n",
+			    p->nvcsw,
+			    p->nivcsw);
+}
 
 int proc_pid_status(struct task_struct *task, char * buffer)
 {
@@ -309,6 +322,7 @@ int proc_pid_status(struct task_struct *task, char * buffer)
 #if defined(CONFIG_S390)
 	buffer = task_show_regs(task, buffer);
 #endif
+	buffer = task_perf(task, buffer);
 	return buffer - orig;
 }
 
diff --git a/include/asm-i386/thread_info.h b/include/asm-i386/thread_info.h
index 4b187bb..bccfd6a 100644
--- a/include/asm-i386/thread_info.h
+++ b/include/asm-i386/thread_info.h
@@ -33,6 +33,7 @@ struct thread_info {
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
 
 
+	unsigned long		syscall_count;	/* Syscall counter */
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread
diff --git a/include/asm-powerpc/thread_info.h b/include/asm-powerpc/thread_info.h
index 3f32ca8..5306ac2 100644
--- a/include/asm-powerpc/thread_info.h
+++ b/include/asm-powerpc/thread_info.h
@@ -35,6 +35,7 @@ struct thread_info {
 	int		cpu;			/* cpu we're on */
 	int		preempt_count;		/* 0 => preemptable,
 						   <0 => BUG */
+	unsigned long	syscall_count;		/* Syscall counter */
 	struct restart_block restart_block;
 	unsigned long	local_flags;		/* private flags for thread */
 
diff --git a/include/asm-x86_64/thread_info.h b/include/asm-x86_64/thread_info.h
index 74a6c74..e53022d 100644
--- a/include/asm-x86_64/thread_info.h
+++ b/include/asm-x86_64/thread_info.h
@@ -31,6 +31,7 @@ struct thread_info {
 	__u32			cpu;		/* current CPU */
 	int 			preempt_count;	/* 0 => preemptable, <0 => BUG */
 
+	unsigned long		syscall_count;	/* Syscall counter */
 	mm_segment_t		addr_limit;	
 	struct restart_block    restart_block;
 };
diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 3fced47..98dfde7 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -31,7 +31,7 @@
  */
 
 
-#define TASKSTATS_VERSION	3
+#define TASKSTATS_VERSION	4
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -141,6 +141,10 @@ struct taskstats {
 	__u64	write_syscalls;		/* write syscalls */
 	/* Extended accounting fields end */
 
+	__u64  syscall_counter;		/* Syscall counter */
+	__u64  nvcsw;
+	__u64  nivcsw;
+
 #define TASKSTATS_HAS_IO_ACCOUNTING
 	/* Per-task storage I/O accounting starts */
 	__u64	read_bytes;		/* bytes of read I/O */
diff --git a/kernel/fork.c b/kernel/fork.c
index fc723e5..5213738 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1042,6 +1042,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->wchar = 0;		/* I/O counter: bytes written */
 	p->syscr = 0;		/* I/O counter: read syscalls */
 	p->syscw = 0;		/* I/O counter: write syscalls */
+#ifdef CONFIG_TASKSTATS
+	p->thread_info->syscall_count = 0; /* Syscall counter: total numbers of syscalls */
+#endif
 	task_io_accounting_init(p);
 	acct_clear_integrals(p);
 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 4c3476f..d7bf33f 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -196,6 +196,9 @@ static int fill_pid(pid_t pid, struct task_struct *tsk,
 
 	/* fill in basic acct fields */
 	stats->version = TASKSTATS_VERSION;
+	stats->syscall_counter = tsk->thread_info->syscall_count;
+	stats->nvcsw = tsk->nvcsw;
+	stats->nivcsw = tsk->nivcsw;
 	bacct_add_tsk(stats, tsk);
 
 	/* fill in extended acct fields */
@@ -242,6 +245,9 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 		 */
 		delayacct_add_tsk(stats, tsk);
 
+		stats->syscall_counter += tsk->thread_info->syscall_count;
+		stats->nvcsw += tsk->nvcsw;
+		stats->nivcsw += tsk->nivcsw;
 	} while_each_thread(first, tsk);
 
 	unlock_task_sighand(first, &flags);

