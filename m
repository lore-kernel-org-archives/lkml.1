Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0CKCtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:49:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:61973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab0CKCtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:49:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,617,1262592000"; 
   d="scan'208";a="603280142"
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100310183102.GC8070@lenovo>
References: <20100310183102.GC8070@lenovo>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:32:55 +0800
Message-Id: <1268274775.4996.16.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 02:31 +0800, Cyrill Gorcunov wrote:
> +static __initconst struct x86_pmu p4_pmu = {
> +       .name                   = "Netburst P4/Xeon",
> +       .handle_irq             = p4_pmu_handle_irq,
> +       .disable_all            = p4_pmu_disable_all,
> +       .enable_all             = p4_pmu_enable_all,
> +       .enable                 = p4_pmu_enable_event,
> +       .disable                = p4_pmu_disable_event,
> +       .eventsel               = MSR_P4_BPU_CCCR0,
> +       .perfctr                = MSR_P4_BPU_PERFCTR0,
> +       .event_map              = p4_pmu_event_map,
> +       .raw_event              = p4_pmu_raw_event,
> +       .max_events             = ARRAY_SIZE(p4_event_map),
> +       /*
> +        * IF HT disabled we may need to use all
> +        * ARCH_P4_MAX_CCCR counters simulaneously
> +        * though leave it restricted at moment assuming
> +        * HT is on
> +        */
> +       .num_events             = ARCH_P4_MAX_CCCR,
> +       .apic                   = 1,
> +       .event_bits             = 40,
> +       .event_mask             = (1ULL << 40) - 1,
> +       .max_period             = (1ULL << 39) - 1,
> +       .hw_config              = p4_hw_config,
> +       .schedule_events        = p4_pmu_schedule_events,
> +};

commit ca03770(perf, x86: Add PEBS infrastructure) introduces a new
function validate_event that calls x86_pmu.get_event_constraints.

static int validate_event(struct perf_event *event)
{
	...
	c = x86_pmu.get_event_constraints(fake_cpuc, event);
	...
}

So we need to add .get_event_constraints to p4_pmu.

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 4eb79b1..99a2a7c 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -586,6 +586,7 @@ static __initconst struct x86_pmu p4_pmu = {
 	.max_period		= (1ULL << 39) - 1,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
+	.get_event_constraints  = x86_get_event_constraints,
 };
 
 static __init int p4_pmu_init(void)

---
Lin Ming


