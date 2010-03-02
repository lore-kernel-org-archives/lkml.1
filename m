Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0CBGH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:07:56 -0500
Received: from smtp-out.google.com ([216.239.44.51]:4351 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0CBGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:07:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=E+MHePGTsCqHxge/YXtlNdShlwiNIw+an66PnoAiNyrKTiGs7dZ8UdTb6H3/u8KEs
	/AZrMtF6EsQ9Xw9pwGfbA==
From: eranian@google.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, robert.richter@amd.com, eranian@gmail.com
Subject: [PATCH] perf_events: add sampling period randomization support
Date: Mon,  1 Mar 2010 22:07:09 -0800
Message-Id: <1267510029-19750-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.6.6.2
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for randomizing the sampling period.
Randomization is very useful to mitigate the bias that exists
with sampling. The random number generator does not need to
be sophisticated. This patch uses the builtin random32()
generator.

The user activates randomization by setting the perf_event_attr.random
field to 1 and by passing a bitmask to control the range of variation
above the base period. Period will vary from period to period & mask.
Note that randomization is not available when a target interrupt rate
(freq) is enabled.

The last used period can be collected using the PERF_SAMPLE_PERIOD flag
in sample_type.

The patch has been tested on X86. There is also code for PowerPC but
I could not test it.

	Signed-off-by: Stephane Eranian <eranian@google.com>

--
 arch/powerpc/kernel/perf_event.c       |    3 +++
 arch/x86/kernel/cpu/perf_event.c       |    2 ++
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++++
 include/linux/perf_event.h             |    7 +++++--
 kernel/perf_event.c                    |   24 ++++++++++++++++++++++++
 5 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index b6cf8f1..994df17 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1150,6 +1150,9 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	val = 0;
 	left = atomic64_read(&event->hw.period_left) - delta;
 	if (period) {
+		if (event->attr.random)
+			perf_randomize_event_period(event);
+
 		if (left <= 0) {
 			left += period;
 			if (left <= 0)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 641ccb9..159d951 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1110,6 +1110,8 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		if (val & (1ULL << (x86_pmu.event_bits - 1)))
 			continue;
 
+		if (event->attr.random)
+			perf_randomize_event_period(event);
 		/*
 		 * event overflow
 		 */
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index cf6590c..5c8d6ed 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -690,6 +690,10 @@ static int intel_pmu_save_and_restart(struct perf_event *event)
 	int ret;
 
 	x86_perf_event_update(event, hwc, idx);
+
+	if (event->attr.random)
+		perf_randomize_event_period(event);
+
 	ret = x86_perf_event_set_period(event, hwc, idx);
 
 	return ret;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 04f06b4..e91a759 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -203,8 +203,8 @@ struct perf_event_attr {
 				enable_on_exec :  1, /* next exec enables     */
 				task           :  1, /* trace fork/exit       */
 				watermark      :  1, /* wakeup_watermark      */
-
-				__reserved_1   : 49;
+				random	       :  1, /* period randomization  */
+				__reserved_1   : 48;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -214,6 +214,8 @@ struct perf_event_attr {
 	__u32			bp_type;
 	__u64			bp_addr;
 	__u64			bp_len;
+
+	__u64			random_mask;
 };
 
 /*
@@ -877,6 +879,7 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern void perf_randomize_event_period(struct perf_event *event);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a661e79..61ee8c6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -30,6 +30,7 @@
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/random.h>
 
 #include <asm/irq_regs.h>
 
@@ -3876,6 +3877,21 @@ int perf_event_overflow(struct perf_event *event, int nmi,
 	return __perf_event_overflow(event, nmi, 1, data, regs);
 }
 
+void perf_randomize_event_period(struct perf_event *event)
+{
+	u64 new_seed;
+	u64 mask = event->attr.random_mask;
+
+	event->hw.last_period = event->hw.sample_period;
+
+	new_seed = random32();
+
+	if (unlikely(mask >> 32))
+		new_seed |= (u64)random32() << 32;
+
+	event->hw.sample_period = event->attr.sample_period + (new_seed & mask);
+}
+
 /*
  * Generic software event infrastructure
  */
@@ -4190,6 +4206,9 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 				ret = HRTIMER_NORESTART;
 	}
 
+	if (event->attr.random)
+		perf_randomize_event_period(event);
+
 	period = max_t(u64, 10000, event->hw.sample_period);
 	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
 
@@ -4736,6 +4755,11 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->read_format & ~(PERF_FORMAT_MAX-1))
 		return -EINVAL;
 
+	if (attr->random && attr->freq)
+		return -EINVAL;
+
+	if (attr->random && !attr->random_mask)
+		return -EINVAL;
 out:
 	return ret;
 
