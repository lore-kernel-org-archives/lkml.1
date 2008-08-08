Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYHHA5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYHHA5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYHHA4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:56:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46764 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753908AbYHHA4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:56:52 -0400
Message-Id: <20080808005649.986660000@polaris-admin.engr.sgi.com>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 17:56:41 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/6] x86_64 UV: Use LED to indicate CPU is active
Content-Disposition: inline; filename=uv_led_display_idle_x86
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
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/genx2apic_uv_x.c |   40 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c        |    6 +++++
 include/asm-x86/genapic_64.h     |    3 ++
 3 files changed, 49 insertions(+)

--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -18,6 +18,7 @@
 #include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
+#include <asm/idle.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
@@ -28,6 +29,8 @@
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
+static __init void uv_start_system(void);
+
 static enum uv_system_type uv_system_type;
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
@@ -449,6 +452,9 @@ static __init void uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
+
+	/* enable post-smp_cpus_done processing */
+	smp_cpus_done_system = uv_start_system;
 }
 
 /*
@@ -466,4 +472,38 @@ void __cpuinit uv_cpu_init(void)
 		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
 
+/*
+ * Illuminate "activity" LED when CPU is going "active",
+ * extinguish when going "idle".
+ */
+static int uv_idle(struct notifier_block *nfb, unsigned long action, void *junk)
+{
+	if (action == IDLE_START)
+		uv_set_led_bits(0, LED_CPU_ACTIVITY);
+
+	else if (action == IDLE_END)
+		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block uv_idle_notifier = {
+	.notifier_call = uv_idle,
+};
 
+/*
+ * Initialize idle led callback function
+ */
+static __init void uv_init_led_idle_display(void)
+{
+	/* initialize timer for activity monitor */
+	idle_notifier_register(&uv_idle_notifier);
+}
+
+/*
+ * Initialize subsystems that need to start after the system is up
+ */
+static __init void uv_start_system(void)
+{
+	uv_init_led_idle_display();
+}
--- linux-2.6.tip.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.tip/arch/x86/kernel/smpboot.c
@@ -1200,6 +1200,9 @@ void __init native_smp_prepare_boot_cpu(
 	per_cpu(cpu_state, me) = CPU_ONLINE;
 }
 
+/* post-smp_cpus_done processing */
+void (*smp_cpus_done_system)(void);
+
 void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	pr_debug("Boot done.\n");
@@ -1210,6 +1213,9 @@ void __init native_smp_cpus_done(unsigne
 	setup_ioapic_dest();
 #endif
 	check_nmi_watchdog();
+
+	if (smp_cpus_done_system)
+		smp_cpus_done_system();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
--- linux-2.6.tip.orig/include/asm-x86/genapic_64.h
+++ linux-2.6.tip/include/asm-x86/genapic_64.h
@@ -47,6 +47,9 @@ enum uv_system_type {UV_NONE, UV_LEGACY_
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 
+/* system tasks to run after smp_cpus_done */
+extern void (*smp_cpus_done_system)(void);
+
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 extern void uv_cpu_init(void);

-- 
