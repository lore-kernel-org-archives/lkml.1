Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYHHA5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYHHA5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbYHHA46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:56:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46779 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755881AbYHHA45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:56:57 -0400
Message-Id: <20080808005652.543469000@polaris-admin.engr.sgi.com>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 17:56:42 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/6] x86_64 UV: Use blinking LED for heartbeat display
Content-Disposition: inline; filename=uv_led_display_hb_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Add a function to blink the "heartbeat" LED indicating
    that the CPU is responding to timer interrupts.

  * Introduces a callback for "heartbeat" display in the
    clocksource_watchdog function, which in turn requires
    CONFIG_CLOCKSOURCE_WATCHDOG to be set.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/genx2apic_uv_x.c |   29 +++++++++++++++++++++++++++++
 include/asm-x86/uv/uv_hub.h      |    1 +
 include/linux/clocksource.h      |    5 +++++
 kernel/time/clocksource.c        |   10 +++++++++-
 4 files changed, 44 insertions(+), 1 deletion(-)

--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/threads.h>
+#include <linux/clocksource.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
@@ -360,6 +361,25 @@ static __init void uv_rtc_init(void)
 		sn_rtc_cycles_per_second = ticks_per_sec;
 }
 
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+static void uv_display_heartbeat(void)
+{
+	int cpu;
+
+	uv_hub_info->led_heartbeat_count = nr_cpu_ids;
+
+	for_each_online_cpu(cpu) {
+		struct uv_hub_info_s *hub = uv_cpu_hub_info(cpu);
+
+		if (hub->led_heartbeat_count > 0) {
+			uv_set_led_bits_on(cpu, LED_CPU_BLINK,
+						LED_CPU_HEARTBEAT);
+			--hub->led_heartbeat_count;
+		}
+	}
+}
+#endif
+
 static __init void uv_system_init(void)
 {
 	union uvh_si_addr_map_config_u m_n_config;
@@ -438,6 +458,7 @@ static __init void uv_system_init(void)
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
 		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + lcpu;
 		uv_cpu_hub_info(cpu)->led_state = 0;
+		uv_cpu_hub_info(cpu)->led_heartbeat_count = nr_cpu_ids;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
@@ -455,6 +476,14 @@ static __init void uv_system_init(void)
 
 	/* enable post-smp_cpus_done processing */
 	smp_cpus_done_system = uv_start_system;
+
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+	/* enable heartbeat display callback */
+	display_heartbeat = uv_display_heartbeat;
+#else
+	printk(KERN_NOTICE "UV: CLOCKSOURCE_WATCHDOG not configured, "
+			   "LED Heartbeat NOT enabled\n");
+#endif
 }
 
 /*
--- linux-2.6.tip.orig/include/asm-x86/uv/uv_hub.h
+++ linux-2.6.tip/include/asm-x86/uv/uv_hub.h
@@ -124,6 +124,7 @@ struct uv_hub_info_s {
 	unsigned long	lowmem_remap_top;
 	unsigned long	lowmem_remap_base;
 	unsigned long	led_offset;
+	unsigned int	led_heartbeat_count;
 	unsigned short	pnode;
 	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
--- linux-2.6.tip.orig/include/linux/clocksource.h
+++ linux-2.6.tip/include/linux/clocksource.h
@@ -236,4 +236,9 @@ static inline void update_vsyscall_tz(vo
 }
 #endif
 
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+/* typically blinks "heartbeat" LED */
+extern void (*display_heartbeat)(void);
+#endif
+
 #endif /* _LINUX_CLOCKSOURCE_H */
--- linux-2.6.tip.orig/kernel/time/clocksource.c
+++ linux-2.6.tip/kernel/time/clocksource.c
@@ -76,6 +76,9 @@ static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 static unsigned long watchdog_resumed;
 
+/* arch specific heartbeat display */
+void (*display_heartbeat)(void);
+
 /*
  * Interval: 0.5sec Threshold: 0.0625s
  */
@@ -140,12 +143,17 @@ static void clocksource_watchdog(unsigne
 		}
 	}
 
+	/* If arch has a heartbeat display, then poke it */
+	if (display_heartbeat)
+		display_heartbeat();
+
 	if (!list_empty(&watchdog_list)) {
 		/*
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu_nr(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = next_cpu_nr(raw_smp_processor_id(),
+					   cpu_online_map);
 
 		if (next_cpu >= nr_cpu_ids)
 			next_cpu = first_cpu(cpu_online_map);

-- 
