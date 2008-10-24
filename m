Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbYJXWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbYJXWXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbYJXWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:23:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54283 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbYJXWXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:23:30 -0400
Message-ID: <49024B1D.1050407@sgi.com>
Date: Fri, 24 Oct 2008 15:24:29 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator driver
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz>	<20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com>
In-Reply-To: <490249CF.2080308@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: SGI X86 UV: Provide a System Activity Indicator driver

The SGI UV system has no LEDS but uses one of the system controller
regs to indicate the online internal state of the cpu.  There is a
heartbeat bit indicating that the cpu is responding to interrupts,
and an idle bit indicating whether the cpu is idle when the heartbeat
interrupt occurs.  The current period is one second.

When a cpu panics, an error code is written by BIOS to this same reg.

This patchset provides the following:

  * x86_64: Add base functionality for writing to the specific SCIR's
    for each cpu.

  * heartbeat: Invert "heartbeat" bit to indicate the cpu is
    "interruptible".  If the current thread is the idle thread,
    then indicate system is "idle".

  * if hotplug enabled, all bits are set (0xff) when the cpu is disabled.

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/uv/uv_hub.h |   63 +++++++++++++++++++++++-
 arch/x86/kernel/genx2apic_uv_x.c |  102 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+), 1 deletion(-)

--- test-tip-latest.orig/arch/x86/include/asm/uv/uv_hub.h
+++ test-tip-latest/arch/x86/include/asm/uv/uv_hub.h
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
+ * There are 64 regs per node.  With Nahelem cpus (2 cores per node,
+ * 8 cpus per core, 2 threads per cpu) there are 32 cpu threads on
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
@@ -350,5 +396,20 @@ static inline int uv_num_possible_blades
 	return uv_possible_blades;
 }
 
-#endif /* _ASM_X86_UV_UV_HUB_H */
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
 
+#endif /* _ASM_X86_UV_UV_HUB_H */
--- test-tip-latest.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ test-tip-latest/arch/x86/kernel/genx2apic_uv_x.c
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
+#include <asm/current.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
@@ -358,6 +361,103 @@ static __init void uv_rtc_init(void)
 }
 
 /*
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
+	/* are we the idle thread? */
+	if (current->pid == 0)
+		bits &= ~SCIR_CPU_ACTIVITY;
+	else
+		bits |= SCIR_CPU_ACTIVITY;
+
+	/* update system controller interface reg */
+	uv_set_scir_bits(bits);
+
+	/* enable next timer period */
+	mod_timer(timer, jiffies + SCIR_CPU_HB_INTERVAL);
+}
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
+}
+
+#else /* !CONFIG_HOTPLUG_CPU */
+
+static __init void uv_scir_register_cpu_notifier(void)
+{
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
+/*
  * Called on each cpu to initialize the per_cpu UV data area.
  * 	ZZZ hotplug not supported yet
  */
@@ -453,6 +553,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = sn_coherency_id;
+		uv_cpu_hub_info(cpu)->scir.offset = SCIR_LOCAL_MMR_BASE + lcpu;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
@@ -469,4 +570,5 @@ void __init uv_system_init(void)
 	map_mmioh_high(max_pnode);
 
 	uv_cpu_init();
+	uv_scir_register_cpu_notifier();
 }

