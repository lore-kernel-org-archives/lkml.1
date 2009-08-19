Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbZHSHoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbZHSHoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZHSHoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:44:25 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15626 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZHSHoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:44:24 -0400
Message-Id: <4A8BC9780200007800010832@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 19 Aug 2009 08:44:24 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: simplify HPET code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64-bits, using unsigned long when unsigned int suffices needlessly
creates larger code (due to the need for REX prefixes), and most of the
logic in hpet.c really doesn't need 64-bit operations. At once this
avoids the need for a couple of type casts.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/hpet.h |    2 -
 arch/x86/kernel/hpet.c      |   45 ++++++++++++++++++++++----------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

--- linux-2.6.31-rc6/arch/x86/include/asm/hpet.h	2008-12-25 00:26:37.000000000 +0100
+++ 2.6.31-rc6-x86-hpet-simplify/arch/x86/include/asm/hpet.h	2009-07-29 12:36:03.000000000 +0200
@@ -69,7 +69,7 @@ extern int hpet_force_user;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
-extern unsigned long hpet_readl(unsigned long a);
+extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
 extern void hpet_msi_unmask(unsigned int irq);
--- linux-2.6.31-rc6/arch/x86/kernel/hpet.c	2009-08-18 15:31:16.000000000 +0200
+++ 2.6.31-rc6-x86-hpet-simplify/arch/x86/kernel/hpet.c	2009-07-29 12:36:03.000000000 +0200
@@ -47,12 +47,12 @@ struct hpet_dev {
 	char				name[10];
 };
 
-unsigned long hpet_readl(unsigned long a)
+inline unsigned int hpet_readl(unsigned int a)
 {
 	return readl(hpet_virt_address + a);
 }
 
-static inline void hpet_writel(unsigned long d, unsigned long a)
+static inline void hpet_writel(unsigned int d, unsigned int a)
 {
 	writel(d, hpet_virt_address + a);
 }
@@ -167,7 +167,7 @@ do {								\
 
 static void hpet_reserve_msi_timers(struct hpet_data *hd);
 
-static void hpet_reserve_platform_timers(unsigned long id)
+static void hpet_reserve_platform_timers(unsigned int id)
 {
 	struct hpet __iomem *hpet = hpet_virt_address;
 	struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
@@ -205,7 +205,7 @@ static void hpet_reserve_platform_timers
 
 }
 #else
-static void hpet_reserve_platform_timers(unsigned long id) { }
+static void hpet_reserve_platform_timers(unsigned int id) { }
 #endif
 
 /*
@@ -246,7 +246,7 @@ static void hpet_reset_counter(void)
 
 static void hpet_start_counter(void)
 {
-	unsigned long cfg = hpet_readl(HPET_CFG);
+	unsigned int cfg = hpet_readl(HPET_CFG);
 	cfg |= HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 }
@@ -271,7 +271,7 @@ static void hpet_resume_counter(void)
 
 static void hpet_enable_legacy_int(void)
 {
-	unsigned long cfg = hpet_readl(HPET_CFG);
+	unsigned int cfg = hpet_readl(HPET_CFG);
 
 	cfg |= HPET_CFG_LEGACY;
 	hpet_writel(cfg, HPET_CFG);
@@ -314,7 +314,7 @@ static int hpet_setup_msi_irq(unsigned i
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg, cmp, now;
+	unsigned int cfg, cmp, now;
 	uint64_t delta;
 
 	switch (mode) {
@@ -323,7 +323,7 @@ static void hpet_set_mode(enum clock_eve
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
 		now = hpet_readl(HPET_COUNTER);
-		cmp = now + (unsigned long) delta;
+		cmp = now + (unsigned int) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
@@ -339,7 +339,7 @@ static void hpet_set_mode(enum clock_eve
 		 * (See AMD-8111 HyperTransport I/O Hub Data Sheet,
 		 * Publication # 24674)
 		 */
-		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_writel((unsigned int) delta, HPET_Tn_CMP(timer));
 		hpet_start_counter();
 		hpet_print_config();
 		break;
@@ -387,9 +387,9 @@ static int hpet_next_event(unsigned long
 	 * what we wrote hit the chip before we compare it to the
 	 * counter.
 	 */
-	WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
+	WARN_ON_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt);
 
-	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
+	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
@@ -415,7 +415,7 @@ static struct hpet_dev	*hpet_devs;
 void hpet_msi_unmask(unsigned int irq)
 {
 	struct hpet_dev *hdev = get_irq_data(irq);
-	unsigned long cfg;
+	unsigned int cfg;
 
 	/* unmask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
@@ -425,7 +425,7 @@ void hpet_msi_unmask(unsigned int irq)
 
 void hpet_msi_mask(unsigned int irq)
 {
-	unsigned long cfg;
+	unsigned int cfg;
 	struct hpet_dev *hdev = get_irq_data(irq);
 
 	/* mask it */
@@ -598,7 +598,7 @@ static void hpet_msi_capability_lookup(u
 
 	for (i = start_timer; i < num_timers - RESERVE_TIMERS; i++) {
 		struct hpet_dev *hdev = &hpet_devs[num_timers_used];
-		unsigned long cfg = hpet_readl(HPET_Tn_CFG(i));
+		unsigned int cfg = hpet_readl(HPET_Tn_CFG(i));
 
 		/* Only consider HPET timer with MSI support */
 		if (!(cfg & HPET_TN_FSB_CAP))
@@ -813,7 +813,7 @@ static int hpet_clocksource_register(voi
  */
 int __init hpet_enable(void)
 {
-	unsigned long id;
+	unsigned int id;
 	int i;
 
 	if (!is_hpet_capable())
@@ -925,7 +925,7 @@ fs_initcall(hpet_late_init);
 void hpet_disable(void)
 {
 	if (is_hpet_capable()) {
-		unsigned long cfg = hpet_readl(HPET_CFG);
+		unsigned int cfg = hpet_readl(HPET_CFG);
 
 		if (hpet_legacy_int_enabled) {
 			cfg &= ~HPET_CFG_LEGACY;
@@ -965,8 +965,8 @@ static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
 static u32 hpet_t1_cmp;
-static unsigned long hpet_default_delta;
-static unsigned long hpet_pie_delta;
+static u32 hpet_default_delta;
+static u32 hpet_pie_delta;
 static unsigned long hpet_pie_limit;
 
 static rtc_irq_handler irq_handler;
@@ -1017,7 +1017,8 @@ EXPORT_SYMBOL_GPL(hpet_unregister_irq_ha
  */
 int hpet_rtc_timer_init(void)
 {
-	unsigned long cfg, cnt, delta, flags;
+	unsigned int cfg, cnt, delta;
+	unsigned long flags;
 
 	if (!is_hpet_enabled())
 		return 0;
@@ -1027,7 +1028,7 @@ int hpet_rtc_timer_init(void)
 
 		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
 		clc >>= hpet_clockevent.shift + DEFAULT_RTC_SHIFT;
-		hpet_default_delta = (unsigned long) clc;
+		hpet_default_delta = clc;
 	}
 
 	if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
@@ -1113,7 +1114,7 @@ int hpet_set_periodic_freq(unsigned long
 		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
 		do_div(clc, freq);
 		clc >>= hpet_clockevent.shift;
-		hpet_pie_delta = (unsigned long) clc;
+		hpet_pie_delta = clc;
 	}
 	return 1;
 }
@@ -1127,7 +1128,7 @@ EXPORT_SYMBOL_GPL(hpet_rtc_dropped_irq);
 
 static void hpet_rtc_timer_reinit(void)
 {
-	unsigned long cfg, delta;
+	unsigned int cfg, delta;
 	int lost_ints = -1;
 
 	if (unlikely(!hpet_rtc_flags)) {


