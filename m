Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0BQWOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:14:41 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:54454 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0BQWOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:14:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kM+sn59bAbHshP6Lo3NFLZgfTMW8n71QmpqVfMb7LjTS2ZHUeK7F6xlw1QmaU/ToBG
         oU91QBWCwV/BbKit3SmuORtn4hLZ6zRPT/cBD1V82CS4UcteXiwqD9A+F7sOUbBRipRo
         NRvMqXQvV9sKQTTH0AXa5emp64w4bXw8xNPbQ=
Date: Thu, 18 Feb 2010 01:14:33 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC perf,x86] P4 PMU early draft
Message-ID: <20100217221433.GA19061@lenovo>
References: <20100208184504.GB5130@lenovo> <20100215201102.GN13205@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215201102.GN13205@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 09:11:02PM +0100, Robert Richter wrote:
> On 08.02.10 21:45:04, Cyrill Gorcunov wrote:
> > Hi all,
> > 
> > first of all the patches are NOT for any kind of inclusion. It's not
> > ready yet. More likely I'm asking for glance review, ideas, criticism.
> > 
> > The main problem in implementing P4 PMU is that it has much more
> > restrictions for event to MSR mapping. So to fit into current
> > perf_events model I made the following:
> > 
> > 1) Event representation. P4 uses a tuple of ESCR+CCCR+COUNTER
> >    as an "event". Since every CCCR register mapped directly to
> >    counter itself and ESCR and CCCR uses only 32bits of their
> >    appropriate MSRs, I decided to use "packed" config in
> >    in hw_perf_event::config. So that upper 31 bits are ESCR
> >    and lower 32 bits are CCCR values. The bit 64 is for HT flag.
> > 
> >    So the base idea here is to pack into 64bit hw_perf_event::config
> >    as much info as possible.
> > 
> >    Due to difference in bitfields I needed to implement
> >    hw_perf_event::config helper which unbind hw_perf_event::config field
> >    from processor specifics and allow to use it in P4 PMU.
> 
> If we introduce model specific configuration, we should put more model
> specific code in here and then remove
> 
>   u64             (*raw_event)(u64);
> 
> in struct x86_pmu.
> 
Hi Robert,

On the other hand -- perhaps you're right, though this is become unclear
what to do if user wanna put some specific bit into configuration. perf
tool may use same opcodes as we do here but slighly modified (for
some particular purpose).

> > 3) I've started unbinding x86_schedule_events into per x86_pmu::schedule_events
> >    and there I hit hardness in binding HT bit. Have to think...
> 
> Instead of implemting x86_pmu.schedule_events() you should rather
> abstract x86_pmu_enable(). This will be much more flexible to
> implement other model spcific features.

Actually I starting to think that maybe completely separate PMU is
needed for P4, just to not bring mess into perf_event.c file.

> 
> -Robert
> 

Anyway, I put updated version of P4 PMU here. The only difference
with previous -- cpu parameter get eliminated from function arguments
(schedule function).

Any ideas and (especially) complains are appreciated. Completely
not tested, since I don;t have such a box, so I'm just curious
will it work at all :) I put both patches here just in case if
soneone would like (for some reason) to try them :)

	-- Cyrill
---
perf,x86: Introduce hw_config helper into x86_pmu

In case if a particular processor (say Netburst) has
a completely different way of configuration we may
use the separate hw_config helper to unbind processor
specifics from __hw_perf_event_init.

Note that the test of BTS support has been changed for
attr->exclude_kernel for the very same reason.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event.c |   42 ++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -139,6 +139,7 @@ struct x86_pmu {
 	int		apic;
 	u64		max_period;
 	u64		intel_ctrl;
+	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
 
@@ -923,6 +924,25 @@ static void release_pmc_hardware(void)
 #endif
 }
 
+static int intel_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
+{
+	/*
+	 * Generate PMC IRQs:
+	 * (keep 'enabled' bit clear for now)
+	 */
+	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
+
+	/*
+	 * Count user and OS events unless requested not to
+	 */
+	if (!attr->exclude_user)
+		hwc->config |= ARCH_PERFMON_EVENTSEL_USR;
+	if (!attr->exclude_kernel)
+		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
+
+	return 0;
+}
+
 static inline bool bts_available(void)
 {
 	return x86_pmu.enable_bts != NULL;
@@ -1136,23 +1156,13 @@ static int __hw_perf_event_init(struct p
 
 	event->destroy = hw_perf_event_destroy;
 
-	/*
-	 * Generate PMC IRQs:
-	 * (keep 'enabled' bit clear for now)
-	 */
-	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
-
 	hwc->idx = -1;
 	hwc->last_cpu = -1;
 	hwc->last_tag = ~0ULL;
 
-	/*
-	 * Count user and OS events unless requested not to.
-	 */
-	if (!attr->exclude_user)
-		hwc->config |= ARCH_PERFMON_EVENTSEL_USR;
-	if (!attr->exclude_kernel)
-		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
+	/* Processor specifics */
+	if (x86_pmu.hw_config(attr, hwc))
+		return -EOPNOTSUPP;
 
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
@@ -1204,7 +1214,7 @@ static int __hw_perf_event_init(struct p
 			return -EOPNOTSUPP;
 
 		/* BTS is currently only allowed for user-mode. */
-		if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
+		if (!attr->exclude_kernel)
 			return -EOPNOTSUPP;
 	}
 
@@ -2371,6 +2381,7 @@ static __initconst struct x86_pmu p6_pmu
 	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
 	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
+	.hw_config		= intel_hw_config,
 	.version		= 0,
 	.num_events		= 2,
 	/*
@@ -2405,6 +2416,7 @@ static __initconst struct x86_pmu core_p
 	 * the generic event period:
 	 */
 	.max_period		= (1ULL << 31) - 1,
+	.hw_config		= intel_hw_config,
 	.get_event_constraints	= intel_get_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
 };
@@ -2428,6 +2440,7 @@ static __initconst struct x86_pmu intel_
 	 * the generic event period:
 	 */
 	.max_period		= (1ULL << 31) - 1,
+	.hw_config		= intel_hw_config,
 	.enable_bts		= intel_pmu_enable_bts,
 	.disable_bts		= intel_pmu_disable_bts,
 	.get_event_constraints	= intel_get_event_constraints
@@ -2451,6 +2464,7 @@ static __initconst struct x86_pmu amd_pm
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
+	.hw_config		= intel_hw_config,
 	.get_event_constraints	= amd_get_event_constraints
 };
---
[RFC] perf,x86: Introduce minimal Netburst PMU driver v2

Netburst PMU is a way differ from "architectural perfomance
monitoring" specfication. P4 uses a tuple of ESCR+CCCR+COUNTER
MSR registers to handle perfomance monitoring events.

A few implementation details:

1) hw_perf_event::config consists of packed ESCR+CCCR value.
   It's allowed since in real both registers use only a half
   of their size. Of course before make a real write into a
   particular MSR we need to unpack value and extend it to
   a proper size.

2) The tuple of packed ESCR+CCCR in hw_perf_event::config
   doesn't describe the memory address of ESCR MSR register
   so that we need to keep a mapping between this tuples
   used and available ESCR (various P4 events may use same
   ESCRs but not simultaneously), for this sake every active
   event has per-cpu map of hw_perf_event::idx <--> ESCR address.

Restrictions:

 - No cascaded counters support
 - No dependant events support (so PERF_COUNT_HW_INSTRUCTIONS
   is turned off for now)
 - PERF_COUNT_HW_CACHE_REFERENCES on thread 1 issue warning
   and may not trigger IRQ, need to rearrange counter indexes
   that way so either no usage of counter 1 at all or with minimal
   intersection

Todo:

 - Implement dependant events
 - Need proper hashing for event opcodes (no linear search please)
 - Some events counted during a clock cycle -- need to set threshold
   for them and count every clock cycle just to get summary statistics
   (ie to behave the same as other pmu do)
 - Consider using event_constraints
 - Perhaps need a completely separate PMU, since there is too much
   difference between architectural spec and netburst events

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/perf_p4.h   |  678 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.c |  548 +++++++++++++++++++++++++++++++
 2 files changed, 1218 insertions(+), 8 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_p4.h
=====================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/include/asm/perf_p4.h
@@ -0,0 +1,678 @@
+/*
+ * Performance events for P4, old Xeon (Netburst)
+ */
+
+#ifndef PERF_P4_H
+#define PERF_P4_H
+
+#include <linux/cpu.h>
+#include <linux/bitops.h>
+
+/*
+ * NetBurst has perfomance MSRs shared between
+ * threads if HT is turned on (ie for both logical
+ * processors) though Atom with HT support do
+ * not
+ */
+#define ARCH_P4_TOTAL_ESCR		(46)
+#define ARCH_P4_RESERVED_ESCR		(2) /* IQ_ESCR(0,1) not always present */
+#define ARCH_P4_MAX_ESCR		(ARCH_P4_TOTAL_ESCR - ARCH_P4_RESERVED_ESCR)
+#define ARCH_P4_MAX_CCCR		(18)
+#define ARCH_P4_MAX_COUNTER		(ARCH_P4_MAX_CCCR / 2)
+
+#define P4_EVNTSEL_EVENT_MASK		0x7e000000U
+#define P4_EVNTSEL_EVENT_SHIFT		25
+#define P4_EVNTSEL_EVENTMASK_MASK	0x01fffe00U
+#define P4_EVNTSEL_EVENTMASK_SHIFT	9
+#define P4_EVNTSEL_TAG_MASK		0x000001e0U
+#define P4_EVNTSEL_TAG_SHIFT		5
+#define P4_EVNTSEL_TAG_ENABLE_MASK	0x00000010U
+#define P4_EVNTSEL_T1_USR		0x00000001U
+#define P4_EVNTSEL_T1_OS		0x00000002U
+#define P4_EVNTSEL_T0_USR		0x00000004U
+#define P4_EVNTSEL_T0_OS		0x00000008U
+
+#define P4_EVNTSEL_MASK				\
+	(P4_EVNTSEL_EVENT_MASK		|	\
+	P4_EVNTSEL_EVENTMASK_MASK	|	\
+	P4_EVNTSEL_TAG_MASK		|	\
+	P4_EVNTSEL_TAG_ENABLE_MASK	|	\
+	P4_EVNTSEL_T0_OS		|	\
+	P4_EVNTSEL_T0_USR)
+
+#define P4_CCCR_OVF			0x80000000U
+#define P4_CCCR_CASCADE			0x40000000U
+#define P4_CCCR_OVF_PMI_T0		0x04000000U
+#define P4_CCCR_OVF_PMI_T1		0x04000000U
+#define P4_CCCR_FORCE_OVF		0x02000000U
+#define P4_CCCR_EDGE			0x01000000U
+#define P4_CCCR_THRESHOLD_MASK		0x00f00000U
+#define P4_CCCR_COMPLEMENT		0x00080000U
+#define P4_CCCR_COMPARE			0x00040000U
+#define P4_CCCR_ESCR_SELECT_MASK	0x0000e000U
+#define P4_CCCR_ESCR_SELECT_SHIFT	13
+#define P4_CCCR_ENABLE			0x00001000U
+#define P4_CCCR_THREAD_SINGLE		0x00010000U
+#define P4_CCCR_THREAD_BOTH		0x00020000U
+#define P4_CCCR_THREAD_ANY		0x00030000U
+
+#define P4_CCCR_MASK				\
+	(P4_CCCR_OVF			|	\
+	P4_CCCR_CASCADE			|	\
+	P4_CCCR_OVF_PMI_T0		|	\
+	P4_CCCR_FORCE_OVF		|	\
+	P4_CCCR_EDGE			|	\
+	P4_CCCR_THRESHOLD_MASK		|	\
+	P4_CCCR_COMPLEMENT		|	\
+	P4_CCCR_COMPARE			|	\
+	P4_CCCR_ESCR_SELECT_MASK	|	\
+	P4_CCCR_ENABLE)
+
+/*
+ * format is 32 bit: ee ss aa aa
+ * where
+ *	ee - 8 bit event
+ *	ss - 8 bit selector
+ *	aa aa - 16 bits reserved for tags
+ */
+#define P4_EVENT_PACK(event, selector)		(((event) << 24) | ((selector) << 16))
+#define P4_EVENT_UNPACK_EVENT(packed)		(((packed) >> 24) & 0xff)
+#define P4_EVENT_UNPACK_SELECTOR(packed)	(((packed) >> 16) & 0xff)
+#define P4_EVENT_PACK_ATTR(attr)		((attr))
+#define P4_EVENT_UNPACK_ATTR(packed)		((packed) & 0xffff)
+#define P4_MAKE_EVENT_ATTR(class, name, bit)	class##_##name = (1 << bit)
+#define P4_EVENT_ATTR(class, name)		class##_##name
+#define P4_EVENT_ATTR_STR(class, name)		__stringify(class##_##name)
+
+/*
+ * config field is 64bit width and consists of
+ * HT << 63 | ESCR << 31 | CCCR
+ * where HT is HyperThreading bit (since ESCR
+ * has it reserved we may use it for own purpose)
+ *
+ * note that this is NOT the addresses of respective
+ * ESCR and CCCR but rather an only packed value should
+ * be unpacked and written to a proper addresses
+ *
+ * the base idea is to pack as much info as
+ * possible
+ */
+#define p4_config_pack_escr(v)		(((u64)(v)) << 31)
+#define p4_config_pack_cccr(v)		(((u64)(v)) & 0xffffffffULL)
+#define p4_config_unpack_escr(v)	(((u64)(v)) >> 31)
+#define p4_config_unpack_cccr(v)	(((u64)(v)) & 0xffffffffULL)
+
+#define P4_CONFIG_HT_SHIFT		63
+#define P4_CONFIG_HT			(1ULL < P4_CONFIG_HT_SHIFT)
+
+static inline u32 p4_config_unpack_opcode(u64 config)
+{
+	u32 e, s;
+
+	e = (p4_config_unpack_escr(config) & P4_EVNTSEL_EVENT_MASK) >> P4_EVNTSEL_EVENT_SHIFT;
+	s = (p4_config_unpack_cccr(config) & P4_CCCR_ESCR_SELECT_MASK) >> P4_CCCR_ESCR_SELECT_SHIFT;
+
+	return P4_EVENT_PACK(e, s);
+}
+
+static inline bool p4_is_event_cascaded(u64 config)
+{
+	return !!((P4_EVENT_UNPACK_SELECTOR(config)) & P4_CCCR_CASCADE);
+}
+
+static inline int p4_is_ht_slave(u64 config)
+{
+	return !!(config & P4_CONFIG_HT);
+}
+
+static inline u64 p4_set_ht_bit(u64 config)
+{
+	return config | P4_CONFIG_HT;
+}
+
+static inline u64 p4_clear_ht_bit(u64 config)
+{
+	return config & ~P4_CONFIG_HT;
+}
+
+static inline int p4_ht_active(void)
+{
+#ifdef CONFIG_SMP
+	return smp_num_siblings > 1;
+#endif
+	return 0;
+}
+
+static inline int p4_ht_thread(int cpu)
+{
+#ifdef CONFIG_SMP
+	if (smp_num_siblings == 2)
+		return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+#endif
+	return 0;
+}
+
+static inline int p4_should_swap_ts(u64 config, int cpu)
+{
+	return (p4_is_ht_slave(config) ^ p4_ht_thread(cpu));
+}
+
+static inline u32 p4_default_cccr_conf(int cpu)
+{
+	u32 cccr;
+
+	if (!p4_ht_active())
+		cccr = P4_CCCR_THREAD_ANY;
+	else
+		cccr = P4_CCCR_THREAD_SINGLE;
+
+	if (!p4_ht_thread(cpu))
+		cccr |= P4_CCCR_OVF_PMI_T0;
+	else
+		cccr |= P4_CCCR_OVF_PMI_T1;
+
+	return cccr;
+}
+
+static inline u32 p4_default_escr_conf(int cpu, int exclude_os, int exclude_usr)
+{
+	u32 escr = 0;
+
+	if (!p4_ht_thread(cpu)) {
+		if (!exclude_os)
+			escr |= P4_EVNTSEL_T0_OS;
+		if (!exclude_usr)
+			escr |= P4_EVNTSEL_T0_USR;
+	} else {
+		if (!exclude_os)
+			escr |= P4_EVNTSEL_T1_OS;
+		if (!exclude_usr)
+			escr |= P4_EVNTSEL_T1_USR;
+	}
+
+	return escr;
+}
+
+/*
+ * Comments below the event represent ESCR restriction
+ * for this event and counter index per ESCR
+ *
+ * MSR_P4_IQ_ESCR0 and MSR_P4_IQ_ESCR1 are available only on early
+ * processor builds (family 0FH, models 01H-02H). These MSRs
+ * are not available on later versions, so that we don't use
+ * them completely
+ *
+ * Also note that CCCR1 do not have P4_CCCR_ENABLE bit properly
+ * working so that we should not use this CCCR and respective
+ * counter as result
+ */
+#define P4_TC_DELIVER_MODE		P4_EVENT_PACK(0x01, 0x01)
+	/*
+	 * MSR_P4_TC_ESCR0:	4, 5
+	 * MSR_P4_TC_ESCR1:	6, 7
+	 */
+
+#define P4_BPU_FETCH_REQUEST		P4_EVENT_PACK(0x03, 0x00)
+	/*
+	 * MSR_P4_BPU_ESCR0:	0, 1
+	 * MSR_P4_BPU_ESCR1:	2, 3
+	 */
+
+#define P4_ITLB_REFERENCE		P4_EVENT_PACK(0x18, 0x03)
+	/*
+	 * MSR_P4_ITLB_ESCR0:	0, 1
+	 * MSR_P4_ITLB_ESCR1:	2, 3
+	 */
+
+#define P4_MEMORY_CANCEL		P4_EVENT_PACK(0x02, 0x05)
+	/*
+	 * MSR_P4_DAC_ESCR0:	8, 9
+	 * MSR_P4_DAC_ESCR1:	10, 11
+	 */
+
+#define P4_MEMORY_COMPLETE		P4_EVENT_PACK(0x08, 0x02)
+	/*
+	 * MSR_P4_SAAT_ESCR0:	8, 9
+	 * MSR_P4_SAAT_ESCR1:	10, 11
+	 */
+
+#define P4_LOAD_PORT_REPLAY		P4_EVENT_PACK(0x04, 0x02)
+	/*
+	 * MSR_P4_SAAT_ESCR0:	8, 9
+	 * MSR_P4_SAAT_ESCR1:	10, 11
+	 */
+
+#define P4_STORE_PORT_REPLAY		P4_EVENT_PACK(0x05, 0x02)
+	/*
+	 * MSR_P4_SAAT_ESCR0:	8, 9
+	 * MSR_P4_SAAT_ESCR1:	10, 11
+	 */
+
+#define P4_MOB_LOAD_REPLAY		P4_EVENT_PACK(0x03, 0x02)
+	/*
+	 * MSR_P4_MOB_ESCR0:	0, 1
+	 * MSR_P4_MOB_ESCR1:	2, 3
+	 */
+
+#define P4_PAGE_WALK_TYPE		P4_EVENT_PACK(0x01, 0x04)
+	/*
+	 * MSR_P4_PMH_ESCR0:	0, 1
+	 * MSR_P4_PMH_ESCR1:	2, 3
+	 */
+
+#define P4_BSQ_CACHE_REFERENCE		P4_EVENT_PACK(0x0c, 0x07)
+	/*
+	 * MSR_P4_BSU_ESCR0:	0, 1
+	 * MSR_P4_BSU_ESCR1:	2, 3
+	 */
+
+#define P4_IOQ_ALLOCATION		P4_EVENT_PACK(0x03, 0x06)
+	/*
+	 * MSR_P4_FSB_ESCR0:	0, 1
+	 * MSR_P4_FSB_ESCR1:	2, 3
+	 */
+
+#define P4_IOQ_ACTIVE_ENTRIES		P4_EVENT_PACK(0x1a, 0x06)
+	/*
+	 * MSR_P4_FSB_ESCR1:	2, 3
+	 */
+
+#define P4_FSB_DATA_ACTIVITY		P4_EVENT_PACK(0x17, 0x06)
+	/*
+	 * MSR_P4_FSB_ESCR0:	0, 1
+	 * MSR_P4_FSB_ESCR1:	2, 3
+	 */
+
+#define P4_BSQ_ALLOCATION		P4_EVENT_PACK(0x05, 0x07)
+	/*
+	 * MSR_P4_BSU_ESCR0:	0, 1
+	 */
+
+#define P4_BSQ_ACTIVE_ENTRIES		P4_EVENT_PACK(0x06, 0x07)
+	/*
+	 * MSR_P4_BSU_ESCR1:	2, 3
+	 */
+
+#define P4_SSE_INPUT_ASSIST		P4_EVENT_PACK(0x34, 0x01)
+	/*
+	 * MSR_P4_FIRM_ESCR:	8, 9
+	 * MSR_P4_FIRM_ESCR:	10, 11
+	 */
+
+#define P4_PACKED_SP_UOP		P4_EVENT_PACK(0x08, 0x01)
+	/*
+	 * MSR_P4_FIRM_ESCR0:	8, 9
+	 * MSR_P4_FIRM_ESCR1:	10, 11
+	 */
+
+#define P4_PACKED_DP_UOP		P4_EVENT_PACK(0x0c, 0x01)
+	/*
+	 * MSR_P4_FIRM_ESCR0:	8, 9
+	 * MSR_P4_FIRM_ESCR1:	10, 11
+	 */
+
+#define P4_SCALAR_SP_UOP		P4_EVENT_PACK(0x0a, 0x01)
+	/*
+	 * MSR_P4_FIRM_ESCR0:	8, 9
+	 * MSR_P4_FIRM_ESCR1:	10, 11
+	 */
+
+#define P4_SCALAR_DP_UOP		P4_EVENT_PACK(0x0e, 0x01)
+	/*
+	 * MSR_P4_FIRM_ESCR0:	8, 9
+	 * MSR_P4_FIRM_ESCR1:	10, 11
+	 */
+
+#define P4_64BIT_MMX_UOP		P4_EVENT_PACK(0x02, 0x01)
+	/*
+	 * MSR_P4_FIRM_ESCR0:	8, 9
+	 * MSR_P4_FIRM_ESCR1:	10, 11
+	 */
+
+#define P4_128BIT_MMX_UOP		P4_EVENT_PACK(0x1a, 0x01)
+	/*
+	 * MSR_P4_FIRM_ESCR0:	8, 9
+	 * MSR_P4_FIRM_ESCR1:	10, 11
+	 */
+
+#define P4_X87_FP_UOP			P4_EVENT_PACK(0x04, 0x01)
+	/*
+	 * MSR_P4_FIRM_ESCR0:	8, 9
+	 * MSR_P4_FIRM_ESCR1:	10, 11
+	 */
+
+#define P4_TC_MISC			P4_EVENT_PACK(0x06, 0x01)
+	/*
+	 * MSR_P4_TC_ESCR0:	4, 5
+	 * MSR_P4_TC_ESCR1:	6, 7
+	 */
+
+#define P4_GLOBAL_POWER_EVENTS		P4_EVENT_PACK(0x13, 0x06)
+	/*
+	 * MSR_P4_FSB_ESCR0:	0, 1
+	 * MSR_P4_FSB_ESCR1:	2, 3
+	 */
+
+#define P4_TC_MS_XFER			P4_EVENT_PACK(0x05, 0x00)
+	/*
+	 * MSR_P4_MS_ESCR0:	4, 5
+	 * MSR_P4_MS_ESCR1:	6, 7
+	 */
+
+#define P4_UOP_QUEUE_WRITES		P4_EVENT_PACK(0x09, 0x00)
+	/*
+	 * MSR_P4_MS_ESCR0:	4, 5
+	 * MSR_P4_MS_ESCR1:	6, 7
+	 */
+
+#define P4_RETIRED_MISPRED_BRANCH_TYPE	P4_EVENT_PACK(0x05, 0x02)
+	/*
+	 * MSR_P4_TBPU_ESCR0:	4, 5
+	 * MSR_P4_TBPU_ESCR0:	6, 7
+	 */
+
+#define P4_RETIRED_BRANCH_TYPE		P4_EVENT_PACK(0x04, 0x02)
+	/*
+	 * MSR_P4_TBPU_ESCR0:	4, 5
+	 * MSR_P4_TBPU_ESCR0:	6, 7
+	 */
+
+#define P4_RESOURCE_STALL		P4_EVENT_PACK(0x01, 0x01)
+	/*
+	 * MSR_P4_ALF_ESCR0:	12, 13, 16
+	 * MSR_P4_ALF_ESCR1:	14, 15, 17
+	 */
+
+#define P4_WC_BUFFER			P4_EVENT_PACK(0x05, 0x05)
+	/*
+	 * MSR_P4_DAC_ESCR0:	8, 9
+	 * MSR_P4_DAC_ESCR1:	10, 11
+	 */
+
+#define P4_B2B_CYCLES			P4_EVENT_PACK(0x16, 0x03)
+	/*
+	 * MSR_P4_FSB_ESCR0:	0, 1
+	 * MSR_P4_FSB_ESCR1:	2, 3
+	 */
+
+#define P4_BNR				P4_EVENT_PACK(0x08, 0x03)
+	/*
+	 * MSR_P4_FSB_ESCR0:	0, 1
+	 * MSR_P4_FSB_ESCR1:	2, 3
+	 */
+
+#define P4_SNOOP			P4_EVENT_PACK(0x06, 0x03)
+	/*
+	 * MSR_P4_FSB_ESCR0:	0, 1
+	 * MSR_P4_FSB_ESCR1:	2, 3
+	 */
+
+#define P4_RESPONSE			P4_EVENT_PACK(0x04, 0x03)
+	/*
+	 * MSR_P4_FSB_ESCR0:	0, 1
+	 * MSR_P4_FSB_ESCR1:	2, 3
+	 */
+
+#define P4_FRONT_END_EVENT		P4_EVENT_PACK(0x08, 0x05)
+	/*
+	 * MSR_P4_CRU_ESCR2:	12, 13, 16
+	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 */
+
+#define P4_EXECUTION_EVENT		P4_EVENT_PACK(0x0c, 0x05)
+	/*
+	 * MSR_P4_CRU_ESCR2:	12, 13, 16
+	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 */
+
+#define P4_REPLAY_EVENT			P4_EVENT_PACK(0x09, 0x05)
+	/*
+	 * MSR_P4_CRU_ESCR2:	12, 13, 16
+	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 */
+
+#define P4_INSTR_RETIRED		P4_EVENT_PACK(0x02, 0x04)
+	/*
+	 * MSR_P4_CRU_ESCR2:	12, 13, 16
+	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 */
+
+#define P4_UOPS_RETIRED			P4_EVENT_PACK(0x01, 0x04)
+	/*
+	 * MSR_P4_CRU_ESCR2:	12, 13, 16
+	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 */
+
+#define P4_UOP_TYPE			P4_EVENT_PACK(0x02, 0x02)
+	/*
+	 * MSR_P4_RAT_ESCR0:	12, 13, 16
+	 * MSR_P4_RAT_ESCR1:	14, 15, 17
+	 */
+
+#define P4_BRANCH_RETIRED		P4_EVENT_PACK(0x06, 0x05)
+	/*
+	 * MSR_P4_CRU_ESCR2:	12, 13, 16
+	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 */
+
+#define P4_MISPRED_BRANCH_RETIRED	P4_EVENT_PACK(0x03, 0x04)
+	/*
+	 * MSR_P4_CRU_ESCR0:	12, 13, 16
+	 * MSR_P4_CRU_ESCR1:	14, 15, 17
+	 */
+
+#define P4_X87_ASSIST			P4_EVENT_PACK(0x03, 0x05)
+	/*
+	 * MSR_P4_CRU_ESCR2:	12, 13, 16
+	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 */
+
+#define P4_MACHINE_CLEAR		P4_EVENT_PACK(0x02, 0x05)
+	/*
+	 * MSR_P4_CRU_ESCR2:	12, 13, 16
+	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 */
+
+#define P4_INSTR_COMPLETED		P4_EVENT_PACK(0x07, 0x04)
+	/*
+	 * MSR_P4_CRU_ESCR0:	12, 13, 16
+	 * MSR_P4_CRU_ESCR1:	14, 15, 17
+	 */
+
+/*
+ * a caller should use P4_EVENT_ATTR helper to
+ * pick the attribute needed, for example
+ *
+ *	P4_EVENT_ATTR(P4_TC_DELIVER_MODE, DD)
+ */
+enum P4_EVENTS_ATTR {
+	P4_MAKE_EVENT_ATTR(P4_TC_DELIVER_MODE, DD, 0),
+	P4_MAKE_EVENT_ATTR(P4_TC_DELIVER_MODE, DB, 1),
+	P4_MAKE_EVENT_ATTR(P4_TC_DELIVER_MODE, DI, 2),
+	P4_MAKE_EVENT_ATTR(P4_TC_DELIVER_MODE, BD, 3),
+	P4_MAKE_EVENT_ATTR(P4_TC_DELIVER_MODE, BB, 4),
+	P4_MAKE_EVENT_ATTR(P4_TC_DELIVER_MODE, BI, 5),
+	P4_MAKE_EVENT_ATTR(P4_TC_DELIVER_MODE, ID, 6),
+
+	P4_MAKE_EVENT_ATTR(P4_BPU_FETCH_REQUEST, TCMISS, 0),
+
+	P4_MAKE_EVENT_ATTR(P4_ITLB_REFERENCE, HIT, 0),
+	P4_MAKE_EVENT_ATTR(P4_ITLB_REFERENCE, MISS, 1),
+	P4_MAKE_EVENT_ATTR(P4_ITLB_REFERENCE, HIT_UK, 2),
+
+	P4_MAKE_EVENT_ATTR(P4_MEMORY_CANCEL, ST_RB_FULL, 2),
+	P4_MAKE_EVENT_ATTR(P4_MEMORY_CANCEL, 64K_CONF, 3),
+
+	P4_MAKE_EVENT_ATTR(P4_MEMORY_COMPLETE, LSC, 0),
+	P4_MAKE_EVENT_ATTR(P4_MEMORY_COMPLETE, SSC, 1),
+
+	P4_MAKE_EVENT_ATTR(P4_LOAD_PORT_REPLAY, SPLIT_LD, 1),
+
+	P4_MAKE_EVENT_ATTR(P4_STORE_PORT_REPLAY, SPLIT_ST, 1),
+
+	P4_MAKE_EVENT_ATTR(P4_MOB_LOAD_REPLAY, NO_STA, 1),
+	P4_MAKE_EVENT_ATTR(P4_MOB_LOAD_REPLAY, NO_STD, 3),
+	P4_MAKE_EVENT_ATTR(P4_MOB_LOAD_REPLAY, PARTIAL_DATA, 4),
+	P4_MAKE_EVENT_ATTR(P4_MOB_LOAD_REPLAY, UNALGN_ADDR, 5),
+
+	P4_MAKE_EVENT_ATTR(P4_PAGE_WALK_TYPE, DTMISS, 0),
+	P4_MAKE_EVENT_ATTR(P4_PAGE_WALK_TYPE, ITMISS, 1),
+
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_HITS, 0),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_HITE, 1),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_HITM, 2),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_HITS, 3),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_HITE, 4),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_HITM, 5),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_MISS, 8),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_MISS, 9),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, WR_2ndL_MISS, 10),
+
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, DEFAULT, 0),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, ALL_READ, 5),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, ALL_WRITE, 6),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, MEM_UC, 7),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, MEM_WC, 8),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, MEM_WT, 9),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, MEM_WP, 10),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, MEM_WB, 11),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, OWN, 13),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, OTHER, 14),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ALLOCATION, PREFETCH, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, DEFAULT, 0),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, ALL_READ, 5),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, ALL_WRITE, 6),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, MEM_UC, 7),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, MEM_WC, 8),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, MEM_WT, 9),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, MEM_WP, 10),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, MEM_WB, 11),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, OWN, 13),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, OTHER, 14),
+	P4_MAKE_EVENT_ATTR(P4_IOQ_ACTIVE_ENTRIES, PREFETCH, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DRDY_DRV, 0),
+	P4_MAKE_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DRDY_OWN, 1),
+	P4_MAKE_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DRDY_OTHER, 2),
+	P4_MAKE_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DBSY_DRV, 3),
+	P4_MAKE_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DBSY_OWN, 4),
+	P4_MAKE_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DBSY_OTHER, 5),
+
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_TYPE0, 0),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_TYPE1, 1),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_LEN0, 2),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_LEN1, 3),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_IO_TYPE, 5),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_LOCK_TYPE, 6),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_CACHE_TYPE, 7),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_SPLIT_TYPE, 8),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_DEM_TYPE, 9),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, REQ_ORD_TYPE, 10),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, MEM_TYPE0, 11),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, MEM_TYPE1, 12),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ALLOCATION, MEM_TYPE2, 13),
+
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_TYPE0, 0),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_TYPE1, 1),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_LEN0, 2),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_LEN1, 3),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_IO_TYPE, 5),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_LOCK_TYPE, 6),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_CACHE_TYPE, 7),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_SPLIT_TYPE, 8),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_DEM_TYPE, 9),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, REQ_ORD_TYPE, 10),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, MEM_TYPE0, 11),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, MEM_TYPE1, 12),
+	P4_MAKE_EVENT_ATTR(P4_BSQ_ACTIVE_ENTRIES, MEM_TYPE2, 13),
+
+	P4_MAKE_EVENT_ATTR(P4_SSE_INPUT_ASSIST, ALL, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_PACKED_SP_UOP, ALL, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_PACKED_DP_UOP, ALL, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_SCALAR_SP_UOP, ALL, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_SCALAR_DP_UOP, ALL, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_64BIT_MMX_UOP, ALL, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_128BIT_MMX_UOP, ALL, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_X87_FP_UOP, ALL, 15),
+
+	P4_MAKE_EVENT_ATTR(P4_TC_MISC, FLUSH, 4),
+
+	P4_MAKE_EVENT_ATTR(P4_GLOBAL_POWER_EVENTS, RUNNING, 0),
+
+	P4_MAKE_EVENT_ATTR(P4_TC_MS_XFER, CISC, 0),
+
+	P4_MAKE_EVENT_ATTR(P4_UOP_QUEUE_WRITES, FROM_TC_BUILD, 0),
+	P4_MAKE_EVENT_ATTR(P4_UOP_QUEUE_WRITES, FROM_TC_DELIVER, 1),
+	P4_MAKE_EVENT_ATTR(P4_UOP_QUEUE_WRITES, FROM_ROM, 2),
+
+	P4_MAKE_EVENT_ATTR(P4_RETIRED_MISPRED_BRANCH_TYPE, CONDITIONAL, 1),
+	P4_MAKE_EVENT_ATTR(P4_RETIRED_MISPRED_BRANCH_TYPE, CALL, 2),
+	P4_MAKE_EVENT_ATTR(P4_RETIRED_MISPRED_BRANCH_TYPE, RETURN, 3),
+	P4_MAKE_EVENT_ATTR(P4_RETIRED_MISPRED_BRANCH_TYPE, INDIRECT, 4),
+
+	P4_MAKE_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, CONDITIONAL, 1),
+	P4_MAKE_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, CALL, 2),
+	P4_MAKE_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, RETURN, 3),
+	P4_MAKE_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, INDIRECT, 4),
+
+	P4_MAKE_EVENT_ATTR(P4_RESOURCE_STALL, SBFULL, 5),
+
+	P4_MAKE_EVENT_ATTR(P4_WC_BUFFER, WCB_EVICTS, 0),
+	P4_MAKE_EVENT_ATTR(P4_WC_BUFFER, WCB_FULL_EVICTS, 1),
+
+	P4_MAKE_EVENT_ATTR(P4_FRONT_END_EVENT, NBOGUS, 0),
+	P4_MAKE_EVENT_ATTR(P4_FRONT_END_EVENT, BOGUS, 1),
+
+	P4_MAKE_EVENT_ATTR(P4_EXECUTION_EVENT, NBOGUS0, 0),
+	P4_MAKE_EVENT_ATTR(P4_EXECUTION_EVENT, NBOGUS1, 1),
+	P4_MAKE_EVENT_ATTR(P4_EXECUTION_EVENT, NBOGUS2, 2),
+	P4_MAKE_EVENT_ATTR(P4_EXECUTION_EVENT, NBOGUS3, 3),
+	P4_MAKE_EVENT_ATTR(P4_EXECUTION_EVENT, BOGUS0, 4),
+	P4_MAKE_EVENT_ATTR(P4_EXECUTION_EVENT, BOGUS1, 5),
+	P4_MAKE_EVENT_ATTR(P4_EXECUTION_EVENT, BOGUS2, 6),
+	P4_MAKE_EVENT_ATTR(P4_EXECUTION_EVENT, BOGUS3, 7),
+
+	P4_MAKE_EVENT_ATTR(P4_REPLAY_EVENT, NBOGUS, 0),
+	P4_MAKE_EVENT_ATTR(P4_REPLAY_EVENT, BOGUS, 1),
+
+	P4_MAKE_EVENT_ATTR(P4_INSTR_RETIRED, NBOGUSNTAG, 0),
+	P4_MAKE_EVENT_ATTR(P4_INSTR_RETIRED, NBOGUSTAG, 1),
+	P4_MAKE_EVENT_ATTR(P4_INSTR_RETIRED, BOGUSNTAG, 2),
+	P4_MAKE_EVENT_ATTR(P4_INSTR_RETIRED, BOGUSTAG, 3),
+
+	P4_MAKE_EVENT_ATTR(P4_UOPS_RETIRED, NBOGUS, 0),
+	P4_MAKE_EVENT_ATTR(P4_UOPS_RETIRED, BOGUS, 1),
+
+	P4_MAKE_EVENT_ATTR(P4_UOP_TYPE, TAGLOADS, 1),
+	P4_MAKE_EVENT_ATTR(P4_UOP_TYPE, TAGSTORES, 2),
+
+	P4_MAKE_EVENT_ATTR(P4_BRANCH_RETIRED, MMNP, 0),
+	P4_MAKE_EVENT_ATTR(P4_BRANCH_RETIRED, MMNM, 1),
+	P4_MAKE_EVENT_ATTR(P4_BRANCH_RETIRED, MMTP, 2),
+	P4_MAKE_EVENT_ATTR(P4_BRANCH_RETIRED, MMTM, 3),
+
+	P4_MAKE_EVENT_ATTR(P4_MISPRED_BRANCH_RETIRED, NBOGUS, 0),
+
+	P4_MAKE_EVENT_ATTR(P4_X87_ASSIST, FPSU, 0),
+	P4_MAKE_EVENT_ATTR(P4_X87_ASSIST, FPSO, 1),
+	P4_MAKE_EVENT_ATTR(P4_X87_ASSIST, POAO, 2),
+	P4_MAKE_EVENT_ATTR(P4_X87_ASSIST, POAU, 3),
+	P4_MAKE_EVENT_ATTR(P4_X87_ASSIST, PREA, 4),
+
+	P4_MAKE_EVENT_ATTR(P4_MACHINE_CLEAR, CLEAR, 0),
+	P4_MAKE_EVENT_ATTR(P4_MACHINE_CLEAR, MOCLEAR, 1),
+	P4_MAKE_EVENT_ATTR(P4_MACHINE_CLEAR, SMCLEAR, 2),
+
+	P4_MAKE_EVENT_ATTR(P4_INSTR_COMPLETED, NBOGUS, 0),
+	P4_MAKE_EVENT_ATTR(P4_INSTR_COMPLETED, BOGUS, 1),
+};
+
+#endif /* PERF_P4_H */
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -26,6 +26,7 @@
 #include <linux/bitops.h>
 
 #include <asm/apic.h>
+#include <asm/perf_p4.h>
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
 
@@ -140,6 +141,7 @@ struct x86_pmu {
 	u64		max_period;
 	u64		intel_ctrl;
 	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
+	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
 
@@ -1233,6 +1235,513 @@ static void p6_pmu_disable_all(void)
 	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
+/*
+ * offset: 0,1 - HT threads
+ * used in HT enabled cpu
+ */
+struct p4_event_template {
+	u32 opcode;			/* ESCR event + CCCR selector */
+	unsigned int emask;		/* ESCR EventMask */
+	unsigned int escr_msr[2];	/* ESCR MSR for this event */
+	int cntr[2];			/* counter index */
+};
+
+struct p4_pmu_res { /* ~144 bytes per-cpu */
+	/* maps hw_conf::idx into template for ESCR sake */
+	struct p4_event_template *tpl[ARCH_P4_MAX_CCCR];
+};
+
+DEFINE_PER_CPU(struct p4_pmu_res, p4_pmu_config);
+
+/*
+ * CCCR1 doesn't have a working enable bit so do not use it ever
+ *
+ * Also as only we start to support raw events we will need to
+ * append _all_ P4_EVENT_PACK'ed events here
+ */
+struct p4_event_template p4_templates[] =
+{
+	[0] = {
+		P4_UOP_TYPE,
+			P4_EVENT_ATTR(P4_UOP_TYPE, TAGLOADS)	|
+			P4_EVENT_ATTR(P4_UOP_TYPE, TAGSTORES),
+			{ MSR_P4_RAT_ESCR0, MSR_P4_RAT_ESCR1},
+			{ 16, 17 },
+	},
+	[1] = {
+		P4_GLOBAL_POWER_EVENTS,
+			P4_EVENT_ATTR(P4_GLOBAL_POWER_EVENTS, RUNNING),
+			{ MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
+			{ 0, 2 },
+	},
+	[2] = {
+		P4_INSTR_RETIRED,
+			P4_EVENT_ATTR(P4_INSTR_RETIRED, NBOGUSNTAG)	|
+			P4_EVENT_ATTR(P4_INSTR_RETIRED, NBOGUSTAG)	|
+			P4_EVENT_ATTR(P4_INSTR_RETIRED, BOGUSNTAG)	|
+			P4_EVENT_ATTR(P4_INSTR_RETIRED, BOGUSTAG),
+			{ MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
+			{ 12, 14 },
+	},
+	[3] = {
+		P4_BSQ_CACHE_REFERENCE,
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_HITS)	|
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_HITE)	|
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_HITM)	|
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_HITS)	|
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_HITE)	|
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_HITM),
+			{ MSR_P4_BSU_ESCR0, MSR_P4_BSU_ESCR1 },
+			{ 0, 1 },
+	},
+	[4] = {
+		P4_BSQ_CACHE_REFERENCE,
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_MISS)	|
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_MISS)	|
+			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, WR_2ndL_MISS),
+			{ MSR_P4_BSU_ESCR0, MSR_P4_BSU_ESCR1 },
+			{ 2, 3 },
+	},
+	[5] = {
+		P4_RETIRED_BRANCH_TYPE,
+			P4_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, CONDITIONAL)	|
+			P4_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, CALL)		|
+			P4_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, RETURN)		|
+			P4_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, INDIRECT),
+			{ MSR_P4_TBPU_ESCR0, MSR_P4_TBPU_ESCR0 },
+			{ 4, 6 },
+	},
+	[6] = {
+		P4_MISPRED_BRANCH_RETIRED,
+			P4_EVENT_ATTR(P4_RETIRED_MISPRED_BRANCH_TYPE, CONDITIONAL)	|
+			P4_EVENT_ATTR(P4_RETIRED_MISPRED_BRANCH_TYPE, CALL)		|
+			P4_EVENT_ATTR(P4_RETIRED_MISPRED_BRANCH_TYPE, RETURN)		|
+			P4_EVENT_ATTR(P4_RETIRED_MISPRED_BRANCH_TYPE, INDIRECT),
+			{ MSR_P4_TBPU_ESCR0, MSR_P4_CRU_ESCR1 },
+			{ 12, 14 },
+	},
+	[7] = {
+		P4_FSB_DATA_ACTIVITY,
+			P4_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DRDY_DRV)	|
+			P4_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DRDY_OWN),
+			{ MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1},
+			{ 0, 2 },
+	},
+};
+
+static struct p4_event_template *p4_event_map[PERF_COUNT_HW_MAX] =
+{
+	/* non-halted CPU clocks */
+	[PERF_COUNT_HW_CPU_CYCLES]		= &p4_templates[1],
+
+#if 0
+	/* FIXME: retired instructions: dep on tagging FSB */
+	[PERF_COUNT_HW_INSTRUCTIONS]		= &p4_templates[2],
+#endif
+
+	/* cache hits */
+	[PERF_COUNT_HW_CACHE_REFERENCES]	= &p4_templates[3],
+
+	/* cache misses */
+	[PERF_COUNT_HW_CACHE_MISSES]		= &p4_templates[4],
+
+	/* branch instructions retired */
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= &p4_templates[5],
+
+	/* mispredicted branches retired */
+	[PERF_COUNT_HW_BRANCH_MISSES]		= &p4_templates[6],
+
+	/* bus ready clocks (cpu is driving #DRDY_DRV\#DRDY_OWN):  */
+	[PERF_COUNT_HW_BUS_CYCLES]		= &p4_templates[7],
+};
+
+static u64 p4_pmu_event_map(int hw_event)
+{
+	struct p4_event_template *tpl = p4_event_map[hw_event];
+	u64 config;
+
+	config  = p4_config_pack_escr(P4_EVENT_UNPACK_EVENT(tpl->opcode) << P4_EVNTSEL_EVENT_SHIFT);
+	config |= p4_config_pack_escr(tpl->emask << P4_EVNTSEL_EVENTMASK_SHIFT);
+	config |= p4_config_pack_cccr(P4_EVENT_UNPACK_SELECTOR(tpl->opcode) << P4_CCCR_ESCR_SELECT_SHIFT);
+
+	/* on HT machine we need a special bit */
+	if (p4_ht_active() && p4_ht_thread(smp_processor_id()))
+		config = p4_set_ht_bit(config);
+
+	return config;
+}
+
+/*
+ * this routine could be a bottleneck and we may need some hash
+ * structure based on "packed" event CRC, even if we use almost ideal hashing
+ * we would still have 5 intersected opcodes
+ */
+static struct p4_event_template *p4_pmu_template_lookup(u64 config)
+{
+	u32 opcode = p4_config_unpack_opcode(config);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(p4_templates); i++) {
+		if (opcode == p4_templates[i].opcode)
+			return &p4_templates[i];
+	}
+
+	return NULL;
+}
+
+/*
+ * We don't control raw events so it's up to the caller
+ * to pass sane values (and we don't count thread number
+ * on HT machine as well here)
+ */
+static u64 p4_pmu_raw_event(u64 hw_event)
+{
+	return hw_event &
+		(p4_config_pack_escr(P4_EVNTSEL_MASK) |
+		 p4_config_pack_cccr(P4_CCCR_MASK));
+}
+
+static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
+{
+	int cpu = smp_processor_id();
+
+	/*
+	 * the reason we use cpu that early is that: if we get scheduled
+	 * first time on the same cpu -- we will not need swap thread
+	 * specific flags in config (and will save some cpu cycles)
+	 */
+
+	/* CCCR by default */
+	hwc->config = p4_config_pack_cccr(p4_default_cccr_conf(cpu));
+
+	/* Count user and OS events unless requested not to */
+	hwc->config |= p4_config_pack_escr(p4_default_escr_conf(cpu, attr->exclude_kernel,
+								attr->exclude_user));
+	return 0;
+}
+
+static inline void p4_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+{
+	/*
+	 * If event gets disabled while counter is in overflowed
+	 * state we need to clear P4_CCCR_OVF otherwise interrupt get
+	 * asserted again right after this event is enabled
+	 */
+	(void)checking_wrmsrl(hwc->config_base + idx,
+		(u64)(p4_config_unpack_cccr(hwc->config)) & ~P4_CCCR_ENABLE & ~P4_CCCR_OVF);
+}
+
+static void p4_pmu_disable_all(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+		struct perf_event *event = cpuc->events[idx];
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
+		p4_pmu_disable_event(&event->hw, idx);
+	}
+}
+
+static void p4_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+{
+	int thread = p4_ht_thread(hwc->config);
+	u64 escr_conf = p4_config_unpack_escr(hwc->config);
+	u64 escr_base;
+	struct p4_event_template *tpl;
+	struct p4_pmu_res *c;
+
+	/*
+	 * some preparation work from per-cpu private fields
+	 * since we need to find out which ESCR to use
+	 */
+	c = &__get_cpu_var(p4_pmu_config);
+	tpl = c->tpl[idx];
+	escr_base = (u64)tpl->escr_msr[thread];
+
+	/*
+	 * - we dont support cascaded counters yet
+	 * - and counter 1 is broken (erratum)
+	 */
+	WARN_ON_ONCE(p4_is_event_cascaded(hwc->config));
+	WARN_ON_ONCE(idx == 1);
+
+	(void)checking_wrmsrl(escr_base, p4_clear_ht_bit(escr_conf));
+	(void)checking_wrmsrl(hwc->config_base + idx,
+		(u64)(p4_config_unpack_cccr(hwc->config)) | P4_CCCR_ENABLE);
+}
+
+static void p4_pmu_enable_all(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+		struct perf_event *event = cpuc->events[idx];
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
+		p4_pmu_enable_event(&event->hw, idx);
+	}
+}
+
+static int p4_pmu_handle_irq(struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct cpu_hw_events *cpuc;
+	struct perf_event *event;
+	struct hw_perf_event *hwc;
+	int idx, handled = 0;
+	u64 val;
+
+	data.addr = 0;
+	data.raw = NULL;
+
+	cpuc = &__get_cpu_var(cpu_hw_events);
+
+	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
+
+		event = cpuc->events[idx];
+		hwc = &event->hw;
+
+		val = x86_perf_event_update(event, hwc, idx);
+		if (val & (1ULL << (x86_pmu.event_bits - 1)))
+			continue;
+
+		/*
+		 * event overflow
+		 */
+		handled		= 1;
+		data.period	= event->hw.last_period;
+
+		if (!x86_perf_event_set_period(event, hwc, idx))
+			continue;
+		if (perf_event_overflow(event, 1, &data, regs))
+			p4_pmu_disable_event(hwc, idx);
+	}
+
+	if (handled) {
+		/* p4 quirk: unmask it again */
+		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+		inc_irq_stat(apic_perf_irqs);
+	}
+
+	return handled;
+}
+
+/*
+ * swap thread specific fields according to a thread
+ * we are going to run on
+ */
+static void p4_pmu_swap_config_ts(struct hw_perf_event *hwc, int cpu)
+{
+	u32 escr, cccr;
+
+	/*
+	 * we either lucky or no HT support
+	 */
+	if (!p4_should_swap_ts(hwc->config, cpu))
+		return;
+
+	/*
+	 * the event is migrated from an another logical
+	 * cpu, so we need to swap thread specific flags
+	 */
+
+	escr = p4_config_unpack_escr(hwc->config);
+	cccr = p4_config_unpack_cccr(hwc->config);
+
+	if (p4_ht_thread(cpu)) {
+		cccr &= ~P4_CCCR_OVF_PMI_T0;
+		cccr |= P4_CCCR_OVF_PMI_T1;
+		if (escr & P4_EVNTSEL_T0_OS) {
+			escr &= ~P4_EVNTSEL_T0_OS;
+			escr |= P4_EVNTSEL_T1_OS;
+		}
+		if (escr & P4_EVNTSEL_T0_USR) {
+			escr &= ~P4_EVNTSEL_T0_USR;
+			escr |= P4_EVNTSEL_T1_USR;
+		}
+		hwc->config  = p4_config_pack_escr(escr);
+		hwc->config |= p4_config_pack_cccr(cccr);
+		hwc->config |= P4_CONFIG_HT;
+	} else {
+		cccr &= ~P4_CCCR_OVF_PMI_T1;
+		cccr |= P4_CCCR_OVF_PMI_T0;
+		if (escr & P4_EVNTSEL_T1_OS) {
+			escr &= ~P4_EVNTSEL_T1_OS;
+			escr |= P4_EVNTSEL_T0_OS;
+		}
+		if (escr & P4_EVNTSEL_T1_USR) {
+			escr &= ~P4_EVNTSEL_T1_USR;
+			escr |= P4_EVNTSEL_T0_USR;
+		}
+		hwc->config  = p4_config_pack_escr(escr);
+		hwc->config |= p4_config_pack_cccr(cccr);
+		hwc->config &= ~P4_CONFIG_HT;
+	}
+}
+
+/* ESCRs are not sequential in memory so we need a map */
+static unsigned int p4_escr_map[ARCH_P4_TOTAL_ESCR] =
+{
+	MSR_P4_ALF_ESCR0,	/*  0 */
+	MSR_P4_ALF_ESCR1,	/*  1 */
+	MSR_P4_BPU_ESCR0,	/*  2 */
+	MSR_P4_BPU_ESCR1,	/*  3 */
+	MSR_P4_BSU_ESCR0,	/*  4 */
+	MSR_P4_BSU_ESCR1,	/*  5 */
+	MSR_P4_CRU_ESCR0,	/*  6 */
+	MSR_P4_CRU_ESCR1,	/*  7 */
+	MSR_P4_CRU_ESCR2,	/*  8 */
+	MSR_P4_CRU_ESCR3,	/*  9 */
+	MSR_P4_CRU_ESCR4,	/* 10 */
+	MSR_P4_CRU_ESCR5,	/* 11 */
+	MSR_P4_DAC_ESCR0,	/* 12 */
+	MSR_P4_DAC_ESCR1,	/* 13 */
+	MSR_P4_FIRM_ESCR0,	/* 14 */
+	MSR_P4_FIRM_ESCR1,	/* 15 */
+	MSR_P4_FLAME_ESCR0,	/* 16 */
+	MSR_P4_FLAME_ESCR1,	/* 17 */
+	MSR_P4_FSB_ESCR0,	/* 18 */
+	MSR_P4_FSB_ESCR1,	/* 19 */
+	MSR_P4_IQ_ESCR0,	/* 20 */
+	MSR_P4_IQ_ESCR1,	/* 21 */
+	MSR_P4_IS_ESCR0,	/* 22 */
+	MSR_P4_IS_ESCR1,	/* 23 */
+	MSR_P4_ITLB_ESCR0,	/* 24 */
+	MSR_P4_ITLB_ESCR1,	/* 25 */
+	MSR_P4_IX_ESCR0,	/* 26 */
+	MSR_P4_IX_ESCR1,	/* 27 */
+	MSR_P4_MOB_ESCR0,	/* 28 */
+	MSR_P4_MOB_ESCR1,	/* 29 */
+	MSR_P4_MS_ESCR0,	/* 30 */
+	MSR_P4_MS_ESCR1,	/* 31 */
+	MSR_P4_PMH_ESCR0,	/* 32 */
+	MSR_P4_PMH_ESCR1,	/* 33 */
+	MSR_P4_RAT_ESCR0,	/* 34 */
+	MSR_P4_RAT_ESCR1,	/* 35 */
+	MSR_P4_SAAT_ESCR0,	/* 36 */
+	MSR_P4_SAAT_ESCR1,	/* 37 */
+	MSR_P4_SSU_ESCR0,	/* 38 */
+	MSR_P4_SSU_ESCR1,	/* 39 */
+	MSR_P4_TBPU_ESCR0,	/* 40 */
+	MSR_P4_TBPU_ESCR1,	/* 41 */
+	MSR_P4_TC_ESCR0,	/* 42 */
+	MSR_P4_TC_ESCR1,	/* 43 */
+	MSR_P4_U2L_ESCR0,	/* 44 */
+	MSR_P4_U2L_ESCR1,	/* 45 */
+};
+
+static int p4_get_escr_idx(unsigned int addr)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(p4_escr_map); i++) {
+		if (addr == p4_escr_map[i])
+			return i;
+	}
+	panic("Wrong ESCR address passed!\n");
+	return -1;
+}
+
+static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
+{
+	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
+	struct p4_event_template *tpl_buf[ARCH_P4_MAX_CCCR];
+	struct hw_perf_event *hwc;
+	struct p4_event_template *tpl;
+	struct p4_pmu_res *c;
+	int cpu = smp_processor_id();
+	unsigned int escr_idx, escr_dep_idx;
+	int thread, i, num;
+
+	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
+	bitmap_zero(escr_mask, ARCH_P4_TOTAL_ESCR);
+
+	/*
+	 * Firstly find out which resource events are going
+	 * to use, if ESCR+CCCR tuple is already borrowed
+	 * get out of here (that is why we have to use
+	 * a big buffer for event templates, we don't change
+	 * anything until we're sure in success)
+	 */
+	for (i = 0, num = n; i < n; i++, num--) {
+		hwc = &cpuc->event_list[i]->hw;
+		tpl = p4_pmu_template_lookup(hwc->config);
+		if (!tpl)
+			goto done;
+		thread = p4_ht_thread(cpu);
+		escr_idx = p4_get_escr_idx(tpl->escr_msr[thread]);
+		if (hwc->idx && !p4_should_swap_ts(hwc->config, cpu)) {
+			/*
+			 * ok, event just remains on same cpu as it
+			 * was running before
+			 */
+			set_bit(tpl->cntr[thread], used_mask);
+			set_bit(escr_idx, escr_mask);
+			continue;
+		}
+		if (test_bit(tpl->cntr[thread], used_mask) ||
+			test_bit(escr_idx, escr_mask))
+			goto done;
+		set_bit(tpl->cntr[thread], used_mask);
+		set_bit(escr_idx, escr_mask);
+		if (assign) {
+			assign[i] = tpl->cntr[thread];
+			tpl_buf[i] = tpl;
+		}
+	}
+
+	/*
+	 * ok, ESCR+CCCR+COUNTERs are available lets swap
+	 * thread specific bits, push bits assigned
+	 * back and save event index mapping to per-cpu
+	 * area, which will allow to find out the ESCR
+	 * to be used at moment of "enable event via real MSR"
+	 */
+	c = &per_cpu(p4_pmu_config, cpu);
+	for (i = 0; i < n; i++) {
+		hwc = &cpuc->event_list[i]->hw;
+		p4_pmu_swap_config_ts(hwc, cpu);
+		if (assign)
+			c->tpl[i] = tpl_buf[i];
+	}
+
+done:
+	return num ? -ENOSPC : 0;
+}
+
+static __initconst struct x86_pmu p4_pmu = {
+	.name			= "Netburst P4/Xeon",
+	.handle_irq		= p4_pmu_handle_irq,
+	.disable_all		= p4_pmu_disable_all,
+	.enable_all		= p4_pmu_enable_all,
+	.enable			= p4_pmu_enable_event,
+	.disable		= p4_pmu_disable_event,
+	.eventsel		= MSR_P4_BPU_CCCR0,
+	.perfctr		= MSR_P4_BPU_PERFCTR0,
+	.event_map		= p4_pmu_event_map,
+	.raw_event		= p4_pmu_raw_event,
+	.max_events		= ARRAY_SIZE(p4_event_map),
+	/*
+	 * IF HT disabled we may need to use all
+	 * ARCH_P4_MAX_CCCR counters simulaneously
+	 * though leave it restricted at moment assuming
+	 * HT is on
+	 */
+	.num_events		= ARCH_P4_MAX_COUNTER,
+	.apic			= 1,
+	.event_bits		= 40,
+	.event_mask		= (1ULL << 40) - 1,
+	.max_period		= (1ULL << 39) - 1,
+	.hw_config		= p4_hw_config,
+	.schedule_events	= p4_pmu_schedule_events,
+};
+
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1796,7 +2305,7 @@ static int x86_pmu_enable(struct perf_ev
 	if (n < 0)
 		return n;
 
-	ret = x86_schedule_events(cpuc, n, assign);
+	ret = x86_pmu.schedule_events(cpuc, n, assign);
 	if (ret)
 		return ret;
 	/*
@@ -2313,7 +2822,7 @@ int hw_perf_group_sched_in(struct perf_e
 	if (n0 < 0)
 		return n0;
 
-	ret = x86_schedule_events(cpuc, n0, assign);
+	ret = x86_pmu.schedule_events(cpuc, n0, assign);
 	if (ret)
 		return ret;
 
@@ -2382,6 +2891,7 @@ static __initconst struct x86_pmu p6_pmu
 	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
 	.hw_config		= intel_hw_config,
+	.schedule_events	= x86_schedule_events,
 	.version		= 0,
 	.num_events		= 2,
 	/*
@@ -2417,6 +2927,7 @@ static __initconst struct x86_pmu core_p
 	 */
 	.max_period		= (1ULL << 31) - 1,
 	.hw_config		= intel_hw_config,
+	.schedule_events	= x86_schedule_events,
 	.get_event_constraints	= intel_get_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
 };
@@ -2441,6 +2952,7 @@ static __initconst struct x86_pmu intel_
 	 */
 	.max_period		= (1ULL << 31) - 1,
 	.hw_config		= intel_hw_config,
+	.schedule_events	= x86_schedule_events,
 	.enable_bts		= intel_pmu_enable_bts,
 	.disable_bts		= intel_pmu_disable_bts,
 	.get_event_constraints	= intel_get_event_constraints
@@ -2465,6 +2977,7 @@ static __initconst struct x86_pmu amd_pm
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
 	.hw_config		= intel_hw_config,
+	.schedule_events	= x86_schedule_events,
 	.get_event_constraints	= amd_get_event_constraints
 };
 
@@ -2493,6 +3006,24 @@ static __init int p6_pmu_init(void)
 	return 0;
 }
 
+static __init int p4_pmu_init(void)
+{
+	unsigned int low, high;
+
+	rdmsr(MSR_IA32_MISC_ENABLE, low, high);
+	if (!(low & (1 << 7))) {
+		pr_cont("unsupported Netburst CPU model %d ",
+			boot_cpu_data.x86_model);
+		return -ENODEV;
+	}
+
+	pr_cont("Netburst events, ");
+
+	x86_pmu = p4_pmu;
+
+	return 0;
+}
+
 static __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -2502,12 +3033,13 @@ static __init int intel_pmu_init(void)
 	int version;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
-		/* check for P6 processor family */
-	   if (boot_cpu_data.x86 == 6) {
-		return p6_pmu_init();
-	   } else {
+		switch (boot_cpu_data.x86) {
+		case 0x6:
+			return p6_pmu_init();
+		case 0xf:
+			return p4_pmu_init();
+		}
 		return -ENODEV;
-	   }
 	}
 
 	/*
@@ -2725,7 +3257,7 @@ static int validate_group(struct perf_ev
 
 	fake_cpuc->n_events = n;
 
-	ret = x86_schedule_events(fake_cpuc, n, NULL);
+	ret = x86_pmu.schedule_events(fake_cpuc, n, NULL);
 
 out_free:
 	kfree(fake_cpuc);
