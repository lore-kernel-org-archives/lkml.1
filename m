Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZHUT6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZHUT6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbZHUT6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:58:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:43787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334AbZHUT6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:58:17 -0400
Date: Fri, 21 Aug 2009 19:57:38 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, shaohua.li@intel.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, shaohua.li@intel.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A8BC9780200007800010832@vpn.id2.novell.com>
References: <4A8BC9780200007800010832@vpn.id2.novell.com>
Subject: [tip:timers/hpet] x86, hpet: Simplify the HPET code
Message-ID: <tip-5946fa3d5cdeb846a647a1900026af9f8b08c8b5@git.kernel.org>
Git-Commit-ID: 5946fa3d5cdeb846a647a1900026af9f8b08c8b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 19:57:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5946fa3d5cdeb846a647a1900026af9f8b08c8b5
Gitweb:     http://git.kernel.org/tip/5946fa3d5cdeb846a647a1900026af9f8b08c8b5
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 19 Aug 2009 08:44:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 21:55:25 +0200

x86, hpet: Simplify the HPET code

On 64-bits, using unsigned long when unsigned int suffices
needlessly creates larger code (due to the need for REX
prefixes), and most of the logic in hpet.c really doesn't need
64-bit operations.

At once this avoids the need for a couple of type casts.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <4A8BC9780200007800010832@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/hpet.h |    2 +-
 arch/x86/kernel/hpet.c      |   45 ++++++++++++++++++++++---------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 1c22cb0..65847c5 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -69,7 +69,7 @@ extern int hpet_force_user;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
-extern unsigned long hpet_readl(unsigned long a);
+extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
 extern void hpet_msi_unmask(unsigned int irq);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 5969e10..ba575f0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
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
@@ -205,7 +205,7 @@ static void hpet_reserve_platform_timers(unsigned long id)
 
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
@@ -314,7 +314,7 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg, cmp, now;
+	unsigned int cfg, cmp, now;
 	uint64_t delta;
 
 	switch (mode) {
@@ -323,7 +323,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
 		now = hpet_readl(HPET_COUNTER);
-		cmp = now + (unsigned long) delta;
+		cmp = now + (unsigned int) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
@@ -339,7 +339,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		 * (See AMD-8111 HyperTransport I/O Hub Data Sheet,
 		 * Publication # 24674)
 		 */
-		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_writel((unsigned int) delta, HPET_Tn_CMP(timer));
 		hpet_start_counter();
 		hpet_print_config();
 		break;
@@ -387,9 +387,9 @@ static int hpet_next_event(unsigned long delta,
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
@@ -600,7 +600,7 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 
 	for (i = start_timer; i < num_timers - RESERVE_TIMERS; i++) {
 		struct hpet_dev *hdev = &hpet_devs[num_timers_used];
-		unsigned long cfg = hpet_readl(HPET_Tn_CFG(i));
+		unsigned int cfg = hpet_readl(HPET_Tn_CFG(i));
 
 		/* Only consider HPET timer with MSI support */
 		if (!(cfg & HPET_TN_FSB_CAP))
@@ -815,7 +815,7 @@ static int hpet_clocksource_register(void)
  */
 int __init hpet_enable(void)
 {
-	unsigned long id;
+	unsigned int id;
 	int i;
 
 	if (!is_hpet_capable())
@@ -933,7 +933,7 @@ fs_initcall(hpet_late_init);
 void hpet_disable(void)
 {
 	if (is_hpet_capable()) {
-		unsigned long cfg = hpet_readl(HPET_CFG);
+		unsigned int cfg = hpet_readl(HPET_CFG);
 
 		if (hpet_legacy_int_enabled) {
 			cfg &= ~HPET_CFG_LEGACY;
@@ -973,8 +973,8 @@ static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
 static u32 hpet_t1_cmp;
-static unsigned long hpet_default_delta;
-static unsigned long hpet_pie_delta;
+static u32 hpet_default_delta;
+static u32 hpet_pie_delta;
 static unsigned long hpet_pie_limit;
 
 static rtc_irq_handler irq_handler;
@@ -1025,7 +1025,8 @@ EXPORT_SYMBOL_GPL(hpet_unregister_irq_handler);
  */
 int hpet_rtc_timer_init(void)
 {
-	unsigned long cfg, cnt, delta, flags;
+	unsigned int cfg, cnt, delta;
+	unsigned long flags;
 
 	if (!is_hpet_enabled())
 		return 0;
@@ -1035,7 +1036,7 @@ int hpet_rtc_timer_init(void)
 
 		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
 		clc >>= hpet_clockevent.shift + DEFAULT_RTC_SHIFT;
-		hpet_default_delta = (unsigned long) clc;
+		hpet_default_delta = clc;
 	}
 
 	if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
@@ -1121,7 +1122,7 @@ int hpet_set_periodic_freq(unsigned long freq)
 		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
 		do_div(clc, freq);
 		clc >>= hpet_clockevent.shift;
-		hpet_pie_delta = (unsigned long) clc;
+		hpet_pie_delta = clc;
 	}
 	return 1;
 }
@@ -1135,7 +1136,7 @@ EXPORT_SYMBOL_GPL(hpet_rtc_dropped_irq);
 
 static void hpet_rtc_timer_reinit(void)
 {
-	unsigned long cfg, delta;
+	unsigned int cfg, delta;
 	int lost_ints = -1;
 
 	if (unlikely(!hpet_rtc_flags)) {
