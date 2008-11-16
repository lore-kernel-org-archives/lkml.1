Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbYKPRET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbYKPRET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 12:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYKPREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 12:04:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:48922 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751966AbYKPREH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 12:04:07 -0500
Date: Sun, 16 Nov 2008 18:04:04 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [RFC] Use HPET timers in 64-bit mode
Message-ID: <20081116170404.GB29009@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the kernel uses the HPET timers in 32-bit mode for clock-events.
While 32 bits, with a wrap-around time of >4 minutes, is probably
good enough for the clock-event purposes, on some chipsets this
has a negative side-effect on the HPET main counter.

Unlike the original HPET specification 1.0 from 2004, which does not
mention any side-effects of setting TN_32MODE_CNF on the
individual timers, the ICH9 documentation, for example, says:

    NOTE: When this bit is set to ‘1’, the hardware counter will
    do a 32-bit operation on comparator match and rollovers, thus
    the upper 32-bit of the Timer 0 Comparator Value register is
    ignored. The upper 32-bit of the main counter is not involved
    in any rollover from lower 32-bit of the main counter and
    becomes all zeros.

(see http://www.intel.com/assets/pdf/datasheet/316972.pdf, page
819, section 21.1.5, Bit 8). I've seen this behaviour also on
ICH8. I have no idea what other chipsets are affected. But I have
seen AMD chipsets that Do The Right Thing.

This means, that when the kernel configures the Timer 0 to 32-bit
mode, on these chipsets it also cripples the 64-bit main counter
to 32 bits.

The HPET may be mmapped in userspace and the main counter
accessed directly by applications, expecting a 64-bit main
counter.

I see two fays this could be fixed:
1) do not use Timer 0 at all
2) do not configure 64-bit capable timers to 32-bit mode

The patch below is my attempt to do 2). I did not yet have a
chance to test it (!!) as I don't have the affected hardware
right here. I can do that next week. I did, however, test a
previous x86_64-only version of the patch and it fixed the
problem.

I would like to get your opinions. I am worried about some of the
32-bit parts:

1) setting the timer value in periodic mode. The documentation
says that the TN_SETVAL bit is automatically cleared when the
value is written. I assume that any write within the 64-bit will
reset the bit and we thus need to set it indivdually for the low
and high 32 bits?

2) setting the timer period. The documentation says:
	After the main counter equals the value in this register,
	the value in this register is increased	by the value last 
	written to the register.

I can only assume that writing the register in multiple writes
does not matter. But to be on the safe side, hpet_write64()
writes the (usually zero) high-order bits first.


diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 77017e8..bb3b661 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -57,8 +57,75 @@ static inline void hpet_writel(unsigned long d, unsigned long a)
 
 #ifdef CONFIG_X86_64
 #include <asm/pgtable.h>
+
+unsigned long hpet_readq(unsigned long a)
+{
+	return readq(hpet_virt_address + a);
+}
+
+static inline void hpet_writeq(unsigned long d, unsigned long a)
+{
+	writeq(d, hpet_virt_address + a);
+}
+
+#define hpet_read_counter64() hpet_readq(HPET_COUNTER)
+#define hpet_write64(d, a) hpet_writeq(d, a)
+
+#else
+
+/*
+ * reading the 64-bit counter value using 32-bit reads, special care must
+ * be taken to detect/correct overflows of the lower 32 bits during the reads
+ */
+static inline u64 hpet_read_counter64()
+{
+	u32 high, high2, low;
+	do {
+		high = hpet_readl(HPET_COUNTER + 4);
+		low   = hpet_readl(HPET_COUNTER);
+		high2 = hpet_readl(HPET_COUNTER + 4);
+	} while (high2 != high);
+
+	return ((u64)high << 32) + low;
+}
+
+static inline void hpet_write64(u64 d, unsigned long a)
+{
+	hpet_writel(d >> 32, a + 4);
+	hpet_writel(d & 0xffffffff, a);
+}
+
+#endif
+
+/*
+ * Set the value of a 64-bit HPET timer to a given value.
+ * The cfg parameter is supplied by the caller to save one read
+ * of the HPET_Tn_CFG(timer) register.
+ */
+static inline void hpet_timer_set_val64(int timer, u32 cfg, u64 value)
+{
+	u32 cfg_set = cfg | HPET_TN_SETVAL;
+
+	hpet_writel(cfg_set, HPET_Tn_CFG(timer));
+
+#ifdef CONFIG_X86_64
+	hpet_writeq(value, HPET_Tn_CMP(timer));
+	/* the SETVAL flag was automatically cleared by the write */
+#else
+
+	hpet_writel(value >> 32, HPET_Tn_CMP(timer));
+	/*
+	 * The documentation is not clear on the behaviour of the SETVAL flag
+	 * fith 32-bit writes. Make sure it is set for the high 32-bit write as
+	 * well and make sure it is clear after that.
+	 */
+	hpet_writel(cfg_set, HPET_Tn_CFG(timer));
+	hpet_writel(value & 0xffffffff, HPET_Tn_CMP(timer));
+	hpet_writel(cfg, HPET_Tn_CFG(timer));
 #endif
 
+}
+
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
@@ -195,8 +262,7 @@ static void hpet_start_counter(void)
 
 	cfg &= ~HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
-	hpet_writel(0, HPET_COUNTER);
-	hpet_writel(0, HPET_COUNTER + 4);
+	hpet_write64(0, HPET_COUNTER);
 	cfg |= HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 }
@@ -257,33 +323,50 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg, cmp, now;
+	u32 cfg;
+	u64 cmp, now;
 	uint64_t delta;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
-		now = hpet_readl(HPET_COUNTER);
-		cmp = now + (unsigned long) delta;
+
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
-		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
-		       HPET_TN_SETVAL | HPET_TN_32BIT;
-		hpet_writel(cfg, HPET_Tn_CFG(timer));
-		/*
-		 * The first write after writing TN_SETVAL to the
-		 * config register sets the counter value, the second
-		 * write sets the period.
-		 */
-		hpet_writel(cmp, HPET_Tn_CMP(timer));
-		udelay(1);
-		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+
+		if (cfg & HPET_TN_64BIT_CAP) {
+			/* configure a 64-bit timer */
+			now = hpet_read_counter64();
+			cmp = now + (unsigned long) delta;
+
+			cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC;
+
+			hpet_timer_set_val64(timer, cfg, cmp);
+			udelay(1);
+			hpet_write64((unsigned long) delta, HPET_Tn_CMP(timer));
+		}
+		else {
+			/* configure a 32-bit timer */
+			now = hpet_readl(HPET_COUNTER);
+			cmp = now + (unsigned long) delta;
+			cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
+				HPET_TN_SETVAL | HPET_TN_32BIT;
+			hpet_writel(cfg, HPET_Tn_CFG(timer));
+			/*
+			 * The first write after writing TN_SETVAL to the
+			 * config register sets the counter value, the second
+			 * write sets the period.
+			 */
+			hpet_writel(cmp, HPET_Tn_CMP(timer));
+			udelay(1);
+			hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		}
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg &= ~HPET_TN_PERIODIC;
-		cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
+		cfg |= HPET_TN_ENABLE | (cfg & HPET_TN_64BIT_CAP ? 0 : HPET_TN_32BIT);
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		break;
 
@@ -311,17 +394,29 @@ static void hpet_set_mode(enum clock_event_mode mode,
 static int hpet_next_event(unsigned long delta,
 			   struct clock_event_device *evt, int timer)
 {
-	u32 cnt;
-
-	cnt = hpet_readl(HPET_COUNTER);
-	cnt += (u32) delta;
-	hpet_writel(cnt, HPET_Tn_CMP(timer));
+	u64 cnt;
+
+	if (hpet_readl(HPET_Tn_CFG(timer) & HPET_TN_64BIT_CAP))
+	{
+		/* set a 64-bit timer */
+		cnt = hpet_read_counter64();
+		cnt += (u32) delta;
+		hpet_write64(cnt, HPET_Tn_CMP(timer));
+	}
+	else {
+		/* set a 32-bit timer */
+		cnt = hpet_readl(HPET_COUNTER);
+		cnt += (u32) delta;
+		hpet_writel(cnt & 0xffffffff, HPET_Tn_CMP(timer));
+	}
 
 	/*
 	 * We need to read back the CMP register to make sure that
 	 * what we wrote hit the chip before we compare it to the
 	 * counter.
 	 */
+
+	cnt &= 0xffffffff; /* whatever the below check means (FIXME), don't break it */
 	WARN_ON((u32)hpet_readl(HPET_T0_CMP) != cnt);
 
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;


Thanks for your thoughts, 


-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

