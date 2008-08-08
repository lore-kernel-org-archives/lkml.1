Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbYHHA6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbYHHA6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYHHA5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:57:04 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42042 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756472AbYHHA5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:57:02 -0400
Message-Id: <20080808005701.163533000@polaris-admin.engr.sgi.com>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 17:56:44 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5/6] ia64 UV: Use LED to indicate CPU is active
Content-Disposition: inline; filename=uv_led_display_idle_ia64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Add an idle callback to turn on/off a LED indicating that
    the CPU is "active" (ON) or "idle" (OFF).

  * Introduces a callback for "post-smp_cpus_done" processing
    to setup callback.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/uv/kernel/setup.c  |   19 +++++++++++++++++--
 include/asm-ia64/uv/uv_hub.h |    3 +++
 2 files changed, 20 insertions(+), 2 deletions(-)

--- linux-2.6.tip.orig/arch/ia64/uv/kernel/setup.c
+++ linux-2.6.tip/arch/ia64/uv/kernel/setup.c
@@ -52,6 +52,19 @@ static __init void get_lowmem_redirect(u
 	BUG();
 }
 
+/*
+ * Illuminate "activity" LED when CPU is going "active",
+ * extinguish when going "idle".
+ */
+static void uv_idle(int state)
+{
+	if (state)
+		uv_set_led_bits(0, LED_CPU_ACTIVITY);
+
+	else
+		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
+}
+
 void __init uv_setup(char **cmdline_p)
 {
 	union uvh_si_addr_map_config_u m_n_config;
@@ -104,9 +117,11 @@ void __init uv_setup(char **cmdline_p)
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
-		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + lcpu;
+		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + cpu;
 		uv_cpu_hub_info(cpu)->led_state = 0;
 		printk(KERN_DEBUG "UV cpu %d, nid %d\n", cpu, nid);
 	}
-}
 
+	/* enable idle callback */
+	ia64_mark_idle = &uv_idle;
+}
--- linux-2.6.tip.orig/include/asm-ia64/uv/uv_hub.h
+++ linux-2.6.tip/include/asm-ia64/uv/uv_hub.h
@@ -150,6 +150,9 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define LED_CPU_BLINK		0xffff	/* blink led */
 #define LED_CPU_HB_INTERVAL	(HZ/2)	/* blink once per second */
 
+/* idle callback */
+extern void (*ia64_mark_idle) (int);
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.

-- 
