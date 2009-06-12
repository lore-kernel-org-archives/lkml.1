Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZFLSrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZFLSrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZFLSri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:47:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57127 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbZFLSrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:47:37 -0400
Date: Fri, 12 Jun 2009 20:47:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perfcounters fixes
Message-ID: <20090612184726.GA26563@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

Fixes plus make the syscall ABI easier to extend. (this feature is 
added in an ABI-compatible way)

 Thanks,

	Ingo

------------------>
Jaswinder Singh Rajput (1):
      powerpc, perf_counter: Fix performance counter event types

Mike Frysinger (1):
      perf_counter: Start documenting HAVE_PERF_COUNTERS requirements

Peter Zijlstra (4):
      perf_counter: PERF_TYPE_HW_CACHE is a hardware counter too
      perf_counter: Remove PERF_TYPE_RAW special casing
      perf record: Explicity program a default counter
      perf_counter: Add forward/backward attribute ABI compatibility

Yong Wang (2):
      perf_counter tools: Remove one L1-data alias
      perf_counter/x86: Add a quirk for Atom processors


 arch/powerpc/kernel/power7-pmu.c   |   12 ++--
 arch/x86/kernel/cpu/perf_counter.c |    7 +++
 include/linux/perf_counter.h       |   22 ++++++--
 include/linux/syscalls.h           |    2 +-
 init/Kconfig                       |    2 +
 kernel/perf_counter.c              |   95 +++++++++++++++++++++++++++++++++---
 tools/perf/builtin-record.c        |    7 ++-
 tools/perf/design.txt              |   15 ++++++
 tools/perf/perf.h                  |    5 +-
 tools/perf/util/parse-events.c     |    2 +-
 10 files changed, 144 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index b3f7d12..b72e7a1 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -294,12 +294,12 @@ static void power7_disable_pmc(unsigned int pmc, u64 mmcr[])
 }
 
 static int power7_generic_events[] = {
-	[PERF_COUNT_CPU_CYCLES] = 0x1e,
-	[PERF_COUNT_INSTRUCTIONS] = 2,
-	[PERF_COUNT_CACHE_REFERENCES] = 0xc880,		/* LD_REF_L1_LSU */
-	[PERF_COUNT_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1 */
-	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x10068,	/* BRU_FIN */
-	[PERF_COUNT_BRANCH_MISSES] = 0x400f6,		/* BR_MPRED */
+	[PERF_COUNT_HW_CPU_CYCLES] = 0x1e,
+	[PERF_COUNT_HW_INSTRUCTIONS] = 2,
+	[PERF_COUNT_HW_CACHE_REFERENCES] = 0xc880,	/* LD_REF_L1_LSU*/
+	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = 0x10068,	/* BRU_FIN	*/
+	[PERF_COUNT_HW_BRANCH_MISSES] = 0x400f6,	/* BR_MPRED	*/
 };
 
 #define C(x)	PERF_COUNT_HW_CACHE_##x
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 895c82e..275bc14 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -968,6 +968,13 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
+	/*
+	 * Quirk, IA32_FIXED_CTRs do not work on current Atom processors:
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+					boot_cpu_data.x86_model == 28)
+		return -1;
+
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6e13395..1b3118a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -120,6 +120,8 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_ID				= 1U << 6,
 	PERF_SAMPLE_CPU				= 1U << 7,
 	PERF_SAMPLE_PERIOD			= 1U << 8,
+
+	PERF_SAMPLE_MAX = 1U << 9,		/* non-ABI */
 };
 
 /*
@@ -131,17 +133,26 @@ enum perf_counter_read_format {
 	PERF_FORMAT_TOTAL_TIME_ENABLED		= 1U << 0,
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
+
+	PERF_FORMAT_MAX = 1U << 3, 		/* non-ABI */
 };
 
+#define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
+
 /*
  * Hardware event to monitor via a performance monitoring counter:
  */
 struct perf_counter_attr {
+
 	/*
 	 * Major type: hardware/software/tracepoint/etc.
 	 */
 	__u32			type;
-	__u32			__reserved_1;
+
+	/*
+	 * Size of the attr structure, for fwd/bwd compat.
+	 */
+	__u32			size;
 
 	/*
 	 * Type specific configuration information.
@@ -168,12 +179,12 @@ struct perf_counter_attr {
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 
-				__reserved_2   : 53;
+				__reserved_1   : 53;
 
 	__u32			wakeup_events;	/* wakeup every n events */
-	__u32			__reserved_3;
+	__u32			__reserved_2;
 
-	__u64			__reserved_4;
+	__u64			__reserved_3;
 };
 
 /*
@@ -621,7 +632,8 @@ extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
 static inline int is_software_counter(struct perf_counter *counter)
 {
 	return (counter->attr.type != PERF_TYPE_RAW) &&
-		(counter->attr.type != PERF_TYPE_HARDWARE);
+		(counter->attr.type != PERF_TYPE_HARDWARE) &&
+		(counter->attr.type != PERF_TYPE_HW_CACHE);
 }
 
 extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index c6c84ad..418d90f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -758,6 +758,6 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 
 asmlinkage long sys_perf_counter_open(
-		const struct perf_counter_attr __user *attr_uptr,
+		struct perf_counter_attr __user *attr_uptr,
 		pid_t pid, int cpu, int group_fd, unsigned long flags);
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index c649657..d3a5096 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -936,6 +936,8 @@ config AIO
 
 config HAVE_PERF_COUNTERS
 	bool
+	help
+	  See tools/perf/design.txt for details.
 
 menu "Performance Counters"
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ef5d8a5..29b685f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3570,12 +3570,8 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	if (attr->inherit && (attr->sample_type & PERF_SAMPLE_GROUP))
 		goto done;
 
-	if (attr->type == PERF_TYPE_RAW) {
-		pmu = hw_perf_counter_init(counter);
-		goto done;
-	}
-
 	switch (attr->type) {
+	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
 		pmu = hw_perf_counter_init(counter);
@@ -3588,6 +3584,9 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	case PERF_TYPE_TRACEPOINT:
 		pmu = tp_perf_counter_init(counter);
 		break;
+
+	default:
+		break;
 	}
 done:
 	err = 0;
@@ -3614,6 +3613,85 @@ done:
 	return counter;
 }
 
+static int perf_copy_attr(struct perf_counter_attr __user *uattr,
+			  struct perf_counter_attr *attr)
+{
+	int ret;
+	u32 size;
+
+	if (!access_ok(VERIFY_WRITE, uattr, PERF_ATTR_SIZE_VER0))
+		return -EFAULT;
+
+	/*
+	 * zero the full structure, so that a short copy will be nice.
+	 */
+	memset(attr, 0, sizeof(*attr));
+
+	ret = get_user(size, &uattr->size);
+	if (ret)
+		return ret;
+
+	if (size > PAGE_SIZE)	/* silly large */
+		goto err_size;
+
+	if (!size)		/* abi compat */
+		size = PERF_ATTR_SIZE_VER0;
+
+	if (size < PERF_ATTR_SIZE_VER0)
+		goto err_size;
+
+	/*
+	 * If we're handed a bigger struct than we know of,
+	 * ensure all the unknown bits are 0.
+	 */
+	if (size > sizeof(*attr)) {
+		unsigned long val;
+		unsigned long __user *addr;
+		unsigned long __user *end;
+
+		addr = PTR_ALIGN((void __user *)uattr + sizeof(*attr),
+				sizeof(unsigned long));
+		end  = PTR_ALIGN((void __user *)uattr + size,
+				sizeof(unsigned long));
+
+		for (; addr < end; addr += sizeof(unsigned long)) {
+			ret = get_user(val, addr);
+			if (ret)
+				return ret;
+			if (val)
+				goto err_size;
+		}
+	}
+
+	ret = copy_from_user(attr, uattr, size);
+	if (ret)
+		return -EFAULT;
+
+	/*
+	 * If the type exists, the corresponding creation will verify
+	 * the attr->config.
+	 */
+	if (attr->type >= PERF_TYPE_MAX)
+		return -EINVAL;
+
+	if (attr->__reserved_1 || attr->__reserved_2 || attr->__reserved_3)
+		return -EINVAL;
+
+	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
+		return -EINVAL;
+
+	if (attr->read_format & ~(PERF_FORMAT_MAX-1))
+		return -EINVAL;
+
+out:
+	return ret;
+
+err_size:
+	put_user(sizeof(*attr), &uattr->size);
+	ret = -E2BIG;
+	goto out;
+}
+
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
@@ -3623,7 +3701,7 @@ done:
  * @group_fd:		group leader counter fd
  */
 SYSCALL_DEFINE5(perf_counter_open,
-		const struct perf_counter_attr __user *, attr_uptr,
+		struct perf_counter_attr __user *, attr_uptr,
 		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
 {
 	struct perf_counter *counter, *group_leader;
@@ -3639,8 +3717,9 @@ SYSCALL_DEFINE5(perf_counter_open,
 	if (flags)
 		return -EINVAL;
 
-	if (copy_from_user(&attr, attr_uptr, sizeof(attr)) != 0)
-		return -EFAULT;
+	ret = perf_copy_attr(attr_uptr, &attr);
+	if (ret)
+		return ret;
 
 	if (!attr.exclude_kernel) {
 		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 29259e7..0f5771f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -568,8 +568,11 @@ int cmd_record(int argc, const char **argv, const char *prefix)
 	if (!argc && target_pid == -1 && !system_wide)
 		usage_with_options(record_usage, options);
 
-	if (!nr_counters)
-		nr_counters = 1;
+	if (!nr_counters) {
+		nr_counters	= 1;
+		attrs[0].type	= PERF_TYPE_HARDWARE;
+		attrs[0].config = PERF_COUNT_HW_CPU_CYCLES;
+	}
 
 	for (counter = 0; counter < nr_counters; counter++) {
 		if (attrs[counter].sample_period)
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 860e116..f71e0d2 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -440,3 +440,18 @@ by this process or by another, and doesn't affect any counters that
 this process has created on other processes.  It only enables or
 disables the group leaders, not any other members in the groups.
 
+
+Arch requirements
+-----------------
+
+If your architecture does not have hardware performance metrics, you can
+still use the generic software counters based on hrtimers for sampling.
+
+So to start with, in order to add HAVE_PERF_COUNTERS to your Kconfig, you
+will need at least this:
+	- asm/perf_counter.h - a basic stub will suffice at first
+	- support for atomic64 types (and associated helper functions)
+	- set_perf_counter_pending() implemented
+
+If your architecture does have hardware capabilities, you can override the
+weak stub hw_perf_counter_init() to register hardware counters.
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index af0a504..87a1aca 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -53,11 +53,12 @@ static inline unsigned long long rdclock(void)
 	_min1 < _min2 ? _min1 : _min2; })
 
 static inline int
-sys_perf_counter_open(struct perf_counter_attr *attr_uptr,
+sys_perf_counter_open(struct perf_counter_attr *attr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
-	return syscall(__NR_perf_counter_open, attr_uptr, pid, cpu,
+	attr->size = sizeof(*attr);
+	return syscall(__NR_perf_counter_open, attr, pid, cpu,
 		       group_fd, flags);
 }
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9d5f1ca..5a72586 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -75,7 +75,7 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache [][MAX_ALIASES] = {
-	{ "L1-data"		, "l1-d", "l1d", "l1"				},
+	{ "L1-data"		, "l1-d", "l1d"					},
 	{ "L1-instruction"	, "l1-i", "l1i"					},
 	{ "L2"			, "l2"						},
 	{ "Data-TLB"		, "dtlb", "d-tlb"				},
