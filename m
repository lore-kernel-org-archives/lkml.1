Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYHHA5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYHHA5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYHHA4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:56:50 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42025 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753457AbYHHA4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:56:49 -0400
Message-Id: <20080808005647.333128000@polaris-admin.engr.sgi.com>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 17:56:40 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/6] x86_64 UV: Provide a LED driver for UV Systems
Content-Disposition: inline; filename=uv_led_driver_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Add base functionality for writing to the LED's on
    the x86_64 UV architecture.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/genx2apic_uv_x.c |    2 +
 include/asm-x86/uv/uv_hub.h      |   60 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletion(-)

--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -433,6 +433,8 @@ static __init void uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
+		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + lcpu;
+		uv_cpu_hub_info(cpu)->led_state = 0;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
--- linux-2.6.tip.orig/include/asm-x86/uv/uv_hub.h
+++ linux-2.6.tip/include/asm-x86/uv/uv_hub.h
@@ -123,6 +123,7 @@ struct uv_hub_info_s {
 	unsigned long	gnode_upper;
 	unsigned long	lowmem_remap_top;
 	unsigned long	lowmem_remap_base;
+	unsigned long	led_offset;
 	unsigned short	pnode;
 	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
@@ -130,6 +131,7 @@ struct uv_hub_info_s {
 	unsigned char	blade_processor_id;
 	unsigned char	m_val;
 	unsigned char	n_val;
+	unsigned char	led_state;
 };
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define uv_hub_info 		(&__get_cpu_var(__uv_hub_info))
@@ -161,6 +163,19 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 	((unsigned long)(p) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
 #define UV_APIC_PNODE_SHIFT	6
+/* Local Bus from cpu's perspective */
+#define LOCAL_BUS_BASE		0x1c00000
+#define LOCAL_BUS_SIZE		(4 * 1024 * 1024)
+
+/* LED windows - located at top of ACPI MMR space */
+#define LED_WINDOW_COUNT	64
+#define LED_LOCAL_MMR_BASE	(LOCAL_BUS_BASE + LOCAL_BUS_SIZE - \
+							LED_WINDOW_COUNT)
+
+#define LED_CPU_HEARTBEAT	0x01	/* timer interrupt */
+#define LED_CPU_ACTIVITY	0x02	/* not idle */
+#define LED_CPU_BLINK		0xffff	/* blink led */
+#define LED_CPU_HB_INTERVAL	(HZ/2)	/* blink once per second */
 
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
@@ -276,6 +291,16 @@ static inline void uv_write_local_mmr(un
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
@@ -350,5 +375,38 @@ static inline int uv_num_possible_blades
 	return uv_possible_blades;
 }
 
-#endif /* ASM_X86__UV__UV_HUB_H */
+/* Light up the leds */
+static inline void uv_set_led_bits(unsigned short value, unsigned char mask)
+{
+	unsigned char state = uv_hub_info->led_state;
+
+	if (value == LED_CPU_BLINK)
+		state ^= mask;
+	else
+		state = (state & ~mask) | (value & mask);
 
+	if (uv_hub_info->led_state != state) {
+		uv_hub_info->led_state = state;
+		uv_write_local_mmr8(uv_hub_info->led_offset, state);
+	}
+}
+
+/* Light up the leds */
+static inline void uv_set_led_bits_on(int cpu, unsigned short value,
+					       unsigned char mask)
+
+{
+	unsigned char state = uv_cpu_hub_info(cpu)->led_state;
+
+	if (value == LED_CPU_BLINK)
+		state ^= mask;
+	else
+		state = (state & ~mask) | (value & mask);
+
+	if (uv_cpu_hub_info(cpu)->led_state != state) {
+		uv_cpu_hub_info(cpu)->led_state = state;
+		uv_write_local_mmr8(uv_cpu_hub_info(cpu)->led_offset, state);
+	}
+}
+
+#endif /* ASM_X86__UV__UV_HUB_H */

-- 
