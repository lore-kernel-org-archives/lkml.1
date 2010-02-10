Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0BJL7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:59:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:50646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0BJL7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:59:46 -0500
Subject: Re: [PATCH]  perf_events: AMD event scheduling (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
References: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 12:59:26 +0100
Message-ID: <1265803166.11509.286.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 17:17 +0200, Stephane Eranian wrote:
>         This patch adds correct AMD Northbridge event scheduling.
>         It must be applied on top tip-x86 + hw_perf_enable() fix.
> 
>         NB events are events measuring L3 cache, Hypertransport
>         traffic. They are identified by an event code  >= 0xe0.
>         They measure events on the Northbride which is shared
>         by all cores on a package. NB events are counted on a
>         shared set of counters. When a NB event is programmed
>         in a counter, the data actually comes from a shared
>         counter. Thus, access to those counters needs to be
>         synchronized.
> 
>         We implement the synchronization such that no two cores
>         can be measuring NB events using the same counters. Thus,
>         we maintain a per-NB * allocation table. The available slot
>         is propagated using the event_constraint structure.
> 
>         The 2nd version takes into account the changes on how
>         constraints are stored by the scheduling code.
> 
>         The 3rd version fixes formatting issues, code readability
>         and one bug in amd_put_event_constraints().
> 
>         Signed-off-by: Stephane Eranian <eranian@google.com>

OK, took this with the below merged in.

---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -81,7 +81,7 @@ struct event_constraint {
 };
 
 struct amd_nb {
-	int nb_id;  /* Northbridge id */
+	int nb_id;  /* NorthBridge id */
 	int refcnt; /* reference count */
 	struct perf_event *owners[X86_PMC_IDX_MAX];
 	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
@@ -2268,7 +2268,7 @@ static inline int amd_is_nb_event(struct
 	u64 val = hwc->config & K7_EVNTSEL_EVENT_MASK;
 	/* event code : bits [35-32] | [7-0] */
 	val = (val >> 24) | (val & 0xff);
-	return val >= 0x0e0;
+	return val >= 0xe00;
 }
 
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
@@ -2301,28 +2301,29 @@ static void amd_put_event_constraints(st
 }
 
  /*
-  * AMD64 Northbridge events need special treatment because
+  * AMD64 NorthBridge events need special treatment because
   * counter access needs to be synchronized across all cores
   * of a package. Refer to BKDG section 3.12
   *
   * NB events are events measuring L3 cache, Hypertransport
-  * traffic. They are identified by an event code  >= 0xe0.
-  * They measure events on the Northbride which is shared
+  * traffic. They are identified by an event code >= 0xe00.
+  * They measure events on the NorthBride which is shared
   * by all cores on a package. NB events are counted on a
   * shared set of counters. When a NB event is programmed
   * in a counter, the data actually comes from a shared
   * counter. Thus, access to those counters needs to be
   * synchronized.
+  *
   * We implement the synchronization such that no two cores
   * can be measuring NB events using the same counters. Thus,
-  * we maintain a per-NB * allocation table. The available slot
+  * we maintain a per-NB allocation table. The available slot
   * is propagated using the event_constraint structure.
   *
   * We provide only one choice for each NB event based on
   * the fact that only NB events have restrictions. Consequently,
   * if a counter is available, there is a guarantee the NB event
   * will be assigned to it. If no slot is available, an empty
-  * constraint is returned and scheduling will evnetually fail
+  * constraint is returned and scheduling will eventually fail
   * for this event.
   *
   * Note that all cores attached the same NB compete for the same
@@ -2753,7 +2754,7 @@ static struct amd_nb *amd_alloc_nb(int c
 
 	/*
 	 * initialize all possible NB constraints
-   */
+	 */
 	for (i = 0; i < x86_pmu.num_events; i++) {
 		set_bit(i, nb->event_constraints[i].idxmsk);
 		nb->event_constraints[i].weight = 1;
@@ -2773,9 +2774,6 @@ static void amd_pmu_cpu_online(int cpu)
 	/*
 	 * function may be called too early in the
 	 * boot process, in which case nb_id is bogus
-	 *
-	 * for BSP, there is an explicit call from
-	 * amd_pmu_init()
 	 */
 	nb_id = amd_get_nb_id(cpu);
 	if (nb_id == BAD_APICID)
@@ -2839,7 +2837,10 @@ static __init int amd_pmu_init(void)
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
 	       sizeof(hw_cache_event_ids));
 
-	/* initialize BSP */
+	/* 
+	 * explicitly initialize the boot cpu, other cpus will get 
+	 * the cpu hotplug callbacks from smp_init()
+	 */
 	amd_pmu_cpu_online(smp_processor_id());
 	return 0;
 }


