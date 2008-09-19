Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYISOhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYISOhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYISOhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:37:46 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53628 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751728AbYISOhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:37:45 -0400
Message-Id: <20080919143744.190005000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 19 Sep 2008 07:37:45 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator driver
References: <20080919143744.009764000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=uv_led_support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SGI UV system has no LEDS but uses one of the system controller
regs to indicate the online internal state of the cpu.  There is a
heartbeat bit indicating that the cpu is responding to interrupts,
and an idle bit indicating whether the cpu has been more or less than
50% idle each heartbeat period.  The current period is one second.

When a cpu panics, an error code is written by BIOS to this same reg.

So the reg has been renamed the "System Controller Interface Reg".

This patchset provides the following:

  * x86_64: Add base functionality for writing to the specific SCIR's
    for each cpu.

  * idle: Add an idle callback to measure the idle "on" and "off" times.

  * heartbeat: Invert "heartbeat" bit to indicate the cpu is "active".

  * if hotplug enabled, all bits are set (0xff) when the cpu is disabled.

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |  138 +++++++++++++++++++++++++++++++++++++++
 include/asm-x86/uv/uv_hub.h      |   62 +++++++++++++++++
 2 files changed, 200 insertions(+)

--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/threads.h>
+#include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
@@ -18,6 +19,8 @@
 #include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
+#include <linux/timer.h>
+#include <asm/idle.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
@@ -358,6 +361,139 @@ static __init void uv_rtc_init(void)
 		sn_rtc_cycles_per_second = ticks_per_sec;
 }
 
+/*
+ * percpu heartbeat timer
+ */
+static void uv_heartbeat(unsigned long ignored)
+{
+	struct timer_list *timer = &uv_hub_info->scir.timer;
+	unsigned char bits = uv_hub_info->scir.state;
+
+	/* flip heartbeat bit */
+	bits ^= SCIR_CPU_HEARTBEAT;
+
+	/* determine if we were mostly idle or not */
+	if (uv_hub_info->scir.idle_off && uv_hub_info->scir.idle_on) {
+		if (uv_hub_info->scir.idle_off > uv_hub_info->scir.idle_on)
+			bits |= SCIR_CPU_ACTIVITY;
+		else
+			bits &= ~SCIR_CPU_ACTIVITY;
+	}
+
+	/* reset idle counters */
+	uv_hub_info->scir.idle_on = 0;
+	uv_hub_info->scir.idle_off = 0;
+
+	/* update system controller interface reg */
+	uv_set_scir_bits(bits);
+
+	/* enable next timer period */
+	mod_timer(timer, jiffies + SCIR_CPU_HB_INTERVAL);
+}
+
+static int uv_idle(struct notifier_block *nfb, unsigned long action, void *junk)
+{
+	unsigned long elapsed = jiffies - uv_hub_info->scir.last;
+
+	/*
+	 * update activity to indicate current state,
+	 * measure time since last change
+	 */
+	if (action == IDLE_START) {
+
+		uv_hub_info->scir.state &= ~SCIR_CPU_ACTIVITY;
+		uv_hub_info->scir.idle_on += elapsed;
+		uv_hub_info->scir.last = jiffies;
+
+	} else if (action == IDLE_END) {
+
+		uv_hub_info->scir.state |= SCIR_CPU_ACTIVITY;
+		uv_hub_info->scir.idle_off += elapsed;
+		uv_hub_info->scir.last = jiffies;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block uv_idle_notifier = {
+	.notifier_call = uv_idle,
+};
+
+static void __cpuinit uv_heartbeat_enable(int cpu)
+{
+	if (!uv_cpu_hub_info(cpu)->scir.enabled) {
+		struct timer_list *timer = &uv_cpu_hub_info(cpu)->scir.timer;
+
+		uv_set_cpu_scir_bits(cpu, SCIR_CPU_HEARTBEAT|SCIR_CPU_ACTIVITY);
+		setup_timer(timer, uv_heartbeat, cpu);
+		timer->expires = jiffies + SCIR_CPU_HB_INTERVAL;
+		add_timer_on(timer, cpu);
+		uv_cpu_hub_info(cpu)->scir.enabled = 1;
+	}
+
+	/* check boot cpu */
+	if (!uv_cpu_hub_info(0)->scir.enabled)
+		uv_heartbeat_enable(0);
+}
+
+static void __cpuinit uv_heartbeat_disable(int cpu)
+{
+	if (uv_cpu_hub_info(cpu)->scir.enabled) {
+		uv_cpu_hub_info(cpu)->scir.enabled = 0;
+		del_timer(&uv_cpu_hub_info(cpu)->scir.timer);
+	}
+	uv_set_cpu_scir_bits(cpu, 0xff);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * cpu hotplug notifier
+ */
+static __cpuinit int uv_scir_cpu_notify(struct notifier_block *self,
+				       unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+		uv_heartbeat_enable(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+		uv_heartbeat_disable(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static __init void uv_scir_register_cpu_notifier(void)
+{
+	hotcpu_notifier(uv_scir_cpu_notify, 0);
+	idle_notifier_register(&uv_idle_notifier);
+}
+
+#else /* !CONFIG_HOTPLUG_CPU */
+
+static __init void uv_scir_register_cpu_notifier(void)
+{
+	idle_notifier_register(&uv_idle_notifier);
+}
+
+static __init int uv_init_heartbeat(void)
+{
+	int cpu;
+
+	if (is_uv_system())
+		for_each_online_cpu(cpu)
+			uv_heartbeat_enable(cpu);
+	return 0;
+}
+
+late_initcall(uv_init_heartbeat);
+
+#endif /* !CONFIG_HOTPLUG_CPU */
+
 static bool uv_system_inited;
 
 void __init uv_system_init(void)
@@ -436,6 +572,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
+		uv_cpu_hub_info(cpu)->scir.offset = SCIR_LOCAL_MMR_BASE + lcpu;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
@@ -450,6 +587,7 @@ void __init uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
+	uv_scir_register_cpu_notifier();
 	uv_system_inited = true;
 }
 
--- linux-2.6.tip.orig/include/asm-x86/uv/uv_hub.h
+++ linux-2.6.tip/include/asm-x86/uv/uv_hub.h
@@ -112,6 +112,16 @@
  */
 #define UV_MAX_NASID_VALUE	(UV_MAX_NUMALINK_NODES * 2)
 
+struct uv_scir_s {
+	struct timer_list timer;
+	unsigned long	offset;
+	unsigned long	last;
+	unsigned long	idle_on;
+	unsigned long	idle_off;
+	unsigned char	state;
+	unsigned char	enabled;
+};
+
 /*
  * The following defines attributes of the HUB chip. These attributes are
  * frequently referenced and are kept in the per-cpu data areas of each cpu.
@@ -130,7 +140,9 @@ struct uv_hub_info_s {
 	unsigned char	blade_processor_id;
 	unsigned char	m_val;
 	unsigned char	n_val;
+	struct uv_scir_s scir;
 };
+
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define uv_hub_info 		(&__get_cpu_var(__uv_hub_info))
 #define uv_cpu_hub_info(cpu)	(&per_cpu(__uv_hub_info, cpu))
@@ -162,6 +174,30 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 
 #define UV_APIC_PNODE_SHIFT	6
 
+/* Local Bus from cpu's perspective */
+#define LOCAL_BUS_BASE		0x1c00000
+#define LOCAL_BUS_SIZE		(4 * 1024 * 1024)
+
+/*
+ * System Controller Interface Reg
+ *
+ * Note there are NO leds on a UV system.  This register is only
+ * used by the system controller to monitor system-wide operation.
+ * There are 64 regs per node.  With Nahelem cpus (8 cpus per core,
+ * 2 threads per cpu, 2 cpus per node) there are 32 cpu threads on
+ * a node.
+ *
+ * The window is located at top of ACPI MMR space
+ */
+#define SCIR_WINDOW_COUNT	64
+#define SCIR_LOCAL_MMR_BASE	(LOCAL_BUS_BASE + \
+				 LOCAL_BUS_SIZE - \
+				 SCIR_WINDOW_COUNT)
+
+#define SCIR_CPU_HEARTBEAT	0x01	/* timer interrupt */
+#define SCIR_CPU_ACTIVITY	0x02	/* not idle */
+#define SCIR_CPU_HB_INTERVAL	(HZ)	/* once per second */
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.
@@ -276,6 +312,16 @@ static inline void uv_write_local_mmr(un
 	*uv_local_mmr_address(offset) = val;
 }
 
+static inline unsigned char uv_read_local_mmr8(unsigned long offset)
+{
+	return *((unsigned char *)uv_local_mmr_address(offset));
+}
+
+static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
+{
+	*((unsigned char *)uv_local_mmr_address(offset)) = val;
+}
+
 /*
  * Structures and definitions for converting between cpu, node, pnode, and blade
  * numbers.
@@ -350,5 +396,21 @@ static inline int uv_num_possible_blades
 	return uv_possible_blades;
 }
 
+/* Update SCIR state */
+static inline void uv_set_scir_bits(unsigned char value)
+{
+	if (uv_hub_info->scir.state != value) {
+		uv_hub_info->scir.state = value;
+		uv_write_local_mmr8(uv_hub_info->scir.offset, value);
+	}
+}
+static inline void uv_set_cpu_scir_bits(int cpu, unsigned char value)
+{
+	if (uv_cpu_hub_info(cpu)->scir.state != value) {
+		uv_cpu_hub_info(cpu)->scir.state = value;
+		uv_write_local_mmr8(uv_cpu_hub_info(cpu)->scir.offset, value);
+	}
+}
+
 #endif /* ASM_X86__UV__UV_HUB_H */
 

