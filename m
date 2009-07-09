Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbZGINZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbZGINZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbZGINY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:24:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbZGINY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:24:57 -0400
Subject: Re: [patch] perf_counter: Add p6 PMU
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1247091264.9777.311.camel@twins>
References: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
	 <1247051751.9777.49.camel@twins>
	 <Pine.LNX.4.64.0907081718450.2715@pianoman.cluster.toy>
	 <1247089529.16156.27.camel@laptop>  <1247091264.9777.311.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Jul 2009 15:24:46 +0200
Message-Id: <1247145886.8019.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 00:14 +0200, Peter Zijlstra wrote: 
> On Wed, 2009-07-08 at 23:45 +0200, Peter Zijlstra wrote:
> > On Wed, 2009-07-08 at 17:46 -0400, Vince Weaver wrote:
> > > On Wed, 8 Jul 2009, Peter Zijlstra wrote:
> > > 
> > > >   doesn't sound like the right kind of event.. but then, it doesn't
> > > >   have anything better either.
> > > 
> > > Is there a way to specify "invalid event"?  Just setting it to 0 doesn't 
> > > work, on the Pentium Pro event 0 returns what looks like essentially
> > > random numbers.
> > 
> > Hmm, bugger. I was assuming writing 0 to the evensel would disable the
> > counter. Apparently that only works for eventsel1, which would mean we
> > cannot run counter1 without counter0. That means we'd need to do a
> > counter swap at times... :/
> 
> Ooh, we can instead use a counter that's specified to not count anything
> for 'disabling' the counter, like event 0x2E with unit mask 0.

The below seems to work..

--- 
arch/x86/kernel/cpu/perf_counter.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -84,6 +84,14 @@ static u64 p6_pmu_event_map(int event)
 	return p6_perfmon_event_map[event];
 }
 
+/*
+ * Counter setting that is specified not to count anything.
+ * We use this to effectively disable a counter.
+ *
+ * L2_RQSTS with 0 MESI unit mask.
+ */
+#define P6_NOP_COUNTER			0x0000002EULL
+
 static u64 p6_pmu_raw_event(u64 event)
 {
 #define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -704,6 +712,7 @@ static int __hw_perf_counter_init(struct
 {
 	struct perf_counter_attr *attr = &counter->attr;
 	struct hw_perf_counter *hwc = &counter->hw;
+	u64 config;
 	int err;
 
 	if (!x86_pmu_initialized())
@@ -756,10 +765,19 @@ static int __hw_perf_counter_init(struct
 
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
+
 	/*
 	 * The generic map:
 	 */
-	hwc->config |= x86_pmu.event_map(attr->config);
+	config = x86_pmu.event_map(attr->config);
+
+	if (config == 0)
+		return -ENOENT;
+
+	if (config == -1LL)
+		return -EINVAL;
+
+	hwc->config |= config;
 
 	return 0;
 }
@@ -767,7 +785,7 @@ static int __hw_perf_counter_init(struct
 static void p6_pmu_disable_all(void)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
-	unsigned long val;
+	u64 val;
 
 	if (!cpuc->enabled)
 		return;
@@ -917,10 +935,10 @@ static inline void
 p6_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
-	unsigned long val = ARCH_PERFMON_EVENTSEL0_ENABLE;
+	u64 val = P6_NOP_COUNTER;
 
-	if (!cpuc->enabled)
-		val = 0;
+	if (cpuc->enabled)
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 
 	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }

