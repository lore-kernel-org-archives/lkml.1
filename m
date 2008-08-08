Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYHHA6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYHHA6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbYHHA5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:57:01 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42035 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756215AbYHHA47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:56:59 -0400
Message-Id: <20080808005658.554514000@polaris-admin.engr.sgi.com>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 17:56:43 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4/6] ia64 UV: Provide a LED driver for UV Systems
Content-Disposition: inline; filename=uv_led_driver_ia64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Add base functionality for writing to the LED's on
    the ia64 UV architecture.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/uv/kernel/setup.c  |    2 +
 include/asm-ia64/uv/uv_hub.h |   61 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 1 deletion(-)

--- linux-2.6.tip.orig/arch/ia64/uv/kernel/setup.c
+++ linux-2.6.tip/arch/ia64/uv/kernel/setup.c
@@ -104,6 +104,8 @@ void __init uv_setup(char **cmdline_p)
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
+		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + lcpu;
+		uv_cpu_hub_info(cpu)->led_state = 0;
 		printk(KERN_DEBUG "UV cpu %d, nid %d\n", cpu, nid);
 	}
 }
--- linux-2.6.tip.orig/include/asm-ia64/uv/uv_hub.h
+++ linux-2.6.tip/include/asm-ia64/uv/uv_hub.h
@@ -99,6 +99,7 @@ struct uv_hub_info_s {
 	unsigned long	gnode_upper;
 	unsigned long	lowmem_remap_top;
 	unsigned long	lowmem_remap_base;
+	unsigned long	led_offset;
 	unsigned short	pnode;
 	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
@@ -106,6 +107,7 @@ struct uv_hub_info_s {
 	unsigned char	blade_processor_id;
 	unsigned char	m_val;
 	unsigned char	n_val;
+	unsigned char	led_state;
 };
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define uv_hub_info 		(&__get_cpu_var(__uv_hub_info))
@@ -134,6 +136,20 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
 	((unsigned long)(p) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
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
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.
@@ -240,6 +256,16 @@ static inline void uv_write_local_mmr(un
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
@@ -305,5 +331,38 @@ static inline int uv_num_possible_blades
 	return 1;
 }
 
-#endif /* __ASM_IA64_UV_HUB__ */
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
+#endif /* __ASM_IA64_UV_HUB__ */

-- 
