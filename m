Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYHHA64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYHHA64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbYHHA5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:57:06 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50650 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756567AbYHHA5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:57:05 -0400
Message-Id: <20080808005702.704046000@polaris-admin.engr.sgi.com>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 17:56:45 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6/6] ia64 UV: Use blinking LED for heartbeat display
Content-Disposition: inline; filename=uv_led_display_hb_ia64
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
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/uv/kernel/setup.c  |   28 ++++++++++++++++++++++++++++
 include/asm-ia64/uv/uv_hub.h |    4 ++++
 2 files changed, 32 insertions(+)

--- linux-2.6.tip.orig/arch/ia64/uv/kernel/setup.c
+++ linux-2.6.tip/arch/ia64/uv/kernel/setup.c
@@ -8,6 +8,7 @@
  * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
  */
 
+#include <linux/clocksource.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <asm/sn/simulator.h>
@@ -65,6 +66,25 @@ static void uv_idle(int state)
 		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
 }
 
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+static void uv_display_heartbeat(void)
+{
+	int cpu;
+
+	uv_hub_info->uv_heartbeat = nr_cpu_ids;
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
 void __init uv_setup(char **cmdline_p)
 {
 	union uvh_si_addr_map_config_u m_n_config;
@@ -124,4 +144,12 @@ void __init uv_setup(char **cmdline_p)
 
 	/* enable idle callback */
 	ia64_mark_idle = &uv_idle;
+
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+	/* enable heartbeat display callback */
+	display_heartbeat = uv_display_heartbeat;
+#else
+	printk(KERN_NOTICE "UV: CLOCKSOURCE_WATCHDOG not configured, "
+			   "LED Heartbeat NOT enabled\n");
+#endif
 }
--- linux-2.6.tip.orig/include/asm-ia64/uv/uv_hub.h
+++ linux-2.6.tip/include/asm-ia64/uv/uv_hub.h
@@ -100,6 +100,7 @@ struct uv_hub_info_s {
 	unsigned long	lowmem_remap_top;
 	unsigned long	lowmem_remap_base;
 	unsigned long	led_offset;
+	unsigned int	led_heartbeat_count;
 	unsigned short	pnode;
 	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
@@ -153,6 +154,9 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 /* idle callback */
 extern void (*ia64_mark_idle) (int);
 
+/* idle callback */
+extern void (*ia64_mark_idle) (int);
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.

-- 
