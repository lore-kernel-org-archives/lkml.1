Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab0BHV40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:56:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:20684 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0BHV4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:56:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lO4JFnNdHO7i7KyMPxxoBWpTF9AKvfN56O3hdoniVZqNSSCbR7rx8c5AZ3pI/uV1MN
         mqZ0btYScwxi/Pq5cOtiVAwSckIOj/yyfdW7IdXdIule8ZkEyxH8ti2Cdi0NsZPORx3t
         7NwFGBIvU8UmBP66yrTZa7hTsnMr7VRB2o/wE=
Date: Tue, 9 Feb 2010 00:56:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Don Zickus <dzickus@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC perf,x86] P4 PMU early draft
Message-ID: <20100208215614.GC5130@lenovo>
References: <20100208184504.GB5130@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208184504.GB5130@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 09:45:04PM +0300, Cyrill Gorcunov wrote:
> Hi all,
> 
...
> All in one -- If you have some spare minutes, please take a glance. I can't
> say I like this code -- it's overcomplicated and I fear hard to understand.
> and still a bit buggy. Complains are welcome!
> 
...

Just updated some snippets, here is an interdiff on top of previous post
(just to not post too much). The key moment is to use cpu in new
x86_pmu.schedule_events routine. This will allow to find if hw_perf_event::config
has been migrated to a different logical cpu if HT is turned on. On non-HT
machine it will have no effect. As result we should swap the ESCR+CCCR thread
specific flags I think.

	-- Cyrill
---

diff -u linux-2.6.git/arch/x86/include/asm/perf_p4.h linux-2.6.git/arch/x86/include/asm/perf_p4.h
--- linux-2.6.git/arch/x86/include/asm/perf_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_p4.h
@@ -120,7 +120,7 @@
 	return !!((P4_EVENT_UNPACK_SELECTOR(config)) & P4_CCCR_CASCADE);
 }
 
-static inline bool p4_is_ht_slave(u64 config)
+static inline int p4_is_ht_slave(u64 config)
 {
 	return !!(config & P4_CONFIG_HT);
 }
@@ -146,7 +146,8 @@
 static inline int p4_ht_thread(int cpu)
 {
 #ifdef CONFIG_SMP
-	return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+	if (smp_num_siblings == 2)
+		return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
 #endif
 	return 0;
 }
diff -u linux-2.6.git/arch/x86/kernel/cpu/perf_event.c linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
--- linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -141,7 +141,7 @@
 	u64		max_period;
 	u64		intel_ctrl;
 	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
-	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
+	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign, int cpu);
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
 
@@ -1236,7 +1236,7 @@
 }
 
 /*
- * offset: 0 - BSP thread, 1 - secondary thread
+ * offset: 0,1 - HT threads
  * used in HT enabled cpu
  */
 struct p4_event_template {
@@ -1254,19 +1254,6 @@
 } p4_pmu_config;
 
 /*
- * Netburst is heavily constrained :(
- */
-#if 0
-#define P4_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, (P4_EVNTSEL_MASK | P4_CCCR_MASK))
-
-static struct event_constraint p4_event_constraints[] =
-{
-	EVENT_CONSTRAINT_END
-};
-#endif
-
-/*
  * CCCR1 doesn't have a working enable bit so do not use it ever
  *
  * Also as only we start to support raw events we will need to
@@ -1382,6 +1369,11 @@
 	return config;
 }
 
+/*
+ * note-to-self: this could be a bottleneck and we may need some hash structure
+ * based on "packed" event CRC, currently even if we may almost ideal
+ * hashing we will still have 5 intersected opcodes, introduce kind of salt?
+ */
 static struct p4_event_template *p4_pmu_template_lookup(u64 config)
 {
 	u32 opcode = p4_config_unpack_opcode(config);
@@ -1411,6 +1403,12 @@
 {
 	int cpu = smp_processor_id();
 
+	/*
+	 * the reason we use cpu that early is that if we get scheduled
+	 * first time on the same cpu -- we will not need swap thread
+	 * specific flags in config which will save some cycles
+	 */
+
 	/* CCCR by default */
 	hwc->config = p4_config_pack_cccr(p4_default_cccr_conf(cpu));
 
@@ -1522,15 +1520,26 @@
 	return handled;
 }
 
+/* swap some thread specific flags in cofing */
+static u64 p4_pmu_swap_config_ts(struct hw_perf_event *hwc, int cpu)
+{
+	u64 conf = hwc->config;
+
+	if ((p4_is_ht_slave(hwc->config) ^ p4_ht_thread(cpu))) {
+		/* FIXME: swap them here */
+	}
+
+	return conf;
+}
+
 /*
  * Netburst has a quite constrained architecture
  */
-static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
+static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign, int cpu)
 {
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	struct p4_event_template *tpl;
 	struct hw_perf_event *hwc;
-	int cpu = smp_processor_id();
 	int thread;
 	int i, j, num = 0;
 
@@ -1678,7 +1687,8 @@
 	return event->pmu == &pmu;
 }
 
-static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
+/* we don't use cpu argument here at all */
+static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign, int cpu)
 {
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -2143,7 +2153,7 @@
 	if (n < 0)
 		return n;
 
-	ret = x86_schedule_events(cpuc, n, assign);
+	ret = x86_pmu.schedule_events(cpuc, n, assign, 0);
 	if (ret)
 		return ret;
 	/*
@@ -2660,7 +2670,7 @@
 	if (n0 < 0)
 		return n0;
 
-	ret = x86_pmu.schedule_events(cpuc, n0, assign);
+	ret = x86_pmu.schedule_events(cpuc, n0, assign, cpu);
 	if (ret)
 		return ret;
 
@@ -3070,6 +3080,7 @@
 {
 	struct perf_event *leader = event->group_leader;
 	struct cpu_hw_events *fake_cpuc;
+	int cpu = smp_processor_id();
 	int ret, n;
 
 	ret = -ENOMEM;
@@ -3095,7 +3106,7 @@
 
 	fake_cpuc->n_events = n;
 
-	ret = x86_pmu.schedule_events(fake_cpuc, n, NULL);
+	ret = x86_pmu.schedule_events(fake_cpuc, n, NULL, cpu);
 
 out_free:
 	kfree(fake_cpuc);
