Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZCTLEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZCTLEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZCTLEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:04:37 -0400
Received: from mail.atmel.fr ([81.80.104.162]:38009 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZCTLEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:04:35 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 07:04:29 EDT
Message-ID: <49C37677.8090508@atmel.com>
Date: Fri, 20 Mar 2009 11:56:55 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Victor <linux@maxim.org.za>, David Brownell <david-b@pacbell.net>
CC: Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] AT91: manage clock by functionality instead of CPUs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In clock.c file the clock management is grouped by cpu 
with cpu_is_xxx() function. This lead to some kind of 
difficulties to read this file and maintainability issues
as the number of AT91 cpus & PLLs/clocks is growing.

In this patch, I try to group clock functionality 
together and match cpus with this functionality set.
This patch is a preview extracted from our 2.6.27-exp
patch available at linux4sam.org (applies on top of Andrew's one).

I would like to have some feedback from you about this 
before I rebase it on current kernel for submission.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -45,6 +45,25 @@
 #define clk_is_sys(x)		((x)->type & CLK_TYPE_SYSTEM)
 
 
+/*
+ * Chips have some kind of clocks : group them by functionality
+ */
+#define cpu_has_utmi()		(  cpu_is_at91cap9() \
+				|| cpu_is_at91sam9rl())
+
+#define cpu_has_800M_plla()	(cpu_is_at91sam9g20())
+
+#define cpu_has_pllb()		(!(cpu_is_at91sam9rl()))
+
+#define cpu_has_upll()		(0)
+
+/* USB host HS & FS */
+#define cpu_has_uhp()		(!cpu_is_at91sam9rl())
+
+/* USB device FS only */
+#define cpu_has_udpfs()		(!(cpu_is_at91sam9rl()))
+
+
 static LIST_HEAD(clocks);
 static DEFINE_SPINLOCK(clk_lock);
 
@@ -142,7 +161,7 @@ static struct clk utmi_clk = {
 };
 static struct clk uhpck = {
 	.name		= "uhpck",
-	.parent		= &pllb,
+	/*.parent		= ... we choose parent at runtime */
 	.mode		= pmc_sys_mode,
 };
 
@@ -175,7 +194,12 @@ static struct clk __init *at91_css_to_cl
 		case AT91_PMC_CSS_PLLA:
 			return &plla;
 		case AT91_PMC_CSS_PLLB:
-			return &pllb;
+			if (cpu_has_upll())
+				/* CSS_PLLB == CSS_UPLL */
+				return &utmi_clk;
+			else
+				if (cpu_has_pllb())
+					return &pllb;
 	}
 
 	return NULL;
@@ -341,7 +365,7 @@ int clk_set_rate(struct clk *clk, unsign
 			u32	pckr;
 
 			pckr = at91_sys_read(AT91_PMC_PCKR(clk->id));
-			pckr &= AT91_PMC_CSS_PLLB;	/* clock selection */
+			pckr &= AT91_PMC_CSS;	/* clock selection */
 			pckr |= prescale << 2;
 			at91_sys_write(AT91_PMC_PCKR(clk->id), pckr);
 			clk->rate_hz = actual;
@@ -369,6 +393,10 @@ int clk_set_parent(struct clk *clk, stru
 		return -EBUSY;
 	if (!clk_is_primary(parent) || !clk_is_programmable(clk))
 		return -EINVAL;
+
+	if (cpu_is_at91sam9rl() && parent->id == AT91_PMC_CSS_PLLB)
+		return -EINVAL;
+
 	spin_lock_irqsave(&clk_lock, flags);
 
 	clk->rate_hz = parent->rate_hz;
@@ -380,7 +408,7 @@ int clk_set_parent(struct clk *clk, stru
 }
 EXPORT_SYMBOL(clk_set_parent);
 
-/* establish PCK0..PCK3 parentage and rate */
+/* establish PCK0..PCKN parentage and rate */
 static void __init init_programmable_clock(struct clk *clk)
 {
 	struct clk	*parent;
@@ -408,11 +436,13 @@ static int at91_clk_show(struct seq_file
 	seq_printf(s, "MOR  = %8x\n", at91_sys_read(AT91_CKGR_MOR));
 	seq_printf(s, "MCFR = %8x\n", at91_sys_read(AT91_CKGR_MCFR));
 	seq_printf(s, "PLLA = %8x\n", at91_sys_read(AT91_CKGR_PLLAR));
-	if (!cpu_is_at91sam9rl())
+	if (cpu_has_pllb())
 		seq_printf(s, "PLLB = %8x\n", at91_sys_read(AT91_CKGR_PLLBR));
-	if (cpu_is_at91cap9() || cpu_is_at91sam9rl())
+	if (cpu_has_utmi())
 		seq_printf(s, "UCKR = %8x\n", uckr = at91_sys_read(AT91_CKGR_UCKR));
 	seq_printf(s, "MCKR = %8x\n", at91_sys_read(AT91_PMC_MCKR));
+	if (cpu_has_upll())
+		seq_printf(s, "USB  = %8x\n", at91_sys_read(AT91_PMC_USB));
 	seq_printf(s, "SR   = %8x\n", sr = at91_sys_read(AT91_PMC_SR));
 
 	seq_printf(s, "\n");
@@ -573,16 +603,60 @@ static struct clk *const standard_pmc_cl
 	&clk32k,
 	&main_clk,
 	&plla,
-	&pllb,
-
-	/* PLLB children (USB) */
-	&udpck,
-	&uhpck,
 
 	/* MCK */
 	&mck
 };
 
+/* PLLB generated USB full speed clock init */
+static void __init at91_pllb_usbfs_clock_init(unsigned long main_clock)
+{
+	/*
+	 * USB clock init:  choose 48 MHz PLLB value,
+	 * disable 48MHz clock during usb peripheral suspend.
+	 *
+	 * REVISIT:  assumes MCK doesn't derive from PLLB!
+	 */
+	uhpck.parent = &pllb;
+
+	at91_pllb_usb_init = at91_pll_calc(main_clock, 48000000 * 2) | AT91_PMC_USB96M;
+	pllb.rate_hz = at91_pll_rate(&pllb, main_clock, at91_pllb_usb_init);
+	if (cpu_is_at91rm9200()) {
+		uhpck.pmc_mask = AT91RM9200_PMC_UHP;
+		udpck.pmc_mask = AT91RM9200_PMC_UDP;
+		at91_sys_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
+	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
+		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
+		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
+	} else if (cpu_is_at91cap9()) {
+		uhpck.pmc_mask = AT91CAP9_PMC_UHP;
+	}
+	at91_sys_write(AT91_CKGR_PLLBR, 0);
+
+	udpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
+	uhpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
+}
+
+/* UPLL generated USB full speed clock init */
+static void __init at91_upll_usbfs_clock_init(unsigned long main_clock)
+{
+	/*
+	 * USB clock init: choose 480 MHz from UPLL,
+	 */
+	unsigned int usbr = AT91_PMC_USBS_UPLL;
+
+	/* Setup divider by 10 to reach 48 MHz */
+	usbr |= ((10 - 1) << 8) & AT91_PMC_OHCIUSBDIV;
+
+	at91_sys_write(AT91_PMC_USB, usbr);
+
+	/* Now set uhpck values */
+	uhpck.parent = &utmi_clk;
+	uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
+	uhpck.rate_hz = utmi_clk.parent->rate_hz;
+	uhpck.rate_hz /= 1 + ((at91_sys_read(AT91_PMC_USB) & AT91_PMC_OHCIUSBDIV) >> 8);
+}
+
 int __init at91_clock_init(unsigned long main_clock)
 {
 	unsigned tmp, freq, mckr;
@@ -604,43 +678,37 @@ int __init at91_clock_init(unsigned long
 
 	/* report if PLLA is more than mildly overclocked */
 	plla.rate_hz = at91_pll_rate(&plla, main_clock, at91_sys_read(AT91_CKGR_PLLAR));
-	if ((!cpu_is_at91sam9g20() && plla.rate_hz > 209000000)
-	   || (cpu_is_at91sam9g20() && plla.rate_hz > 800000000))
+	if ((!cpu_has_800M_plla() && plla.rate_hz > 209000000)
+	   || (cpu_has_800M_plla() && plla.rate_hz > 800000000))
 		pr_info("Clocks: PLLA overclocked, %ld MHz\n", plla.rate_hz / 1000000);
 
-	/*
-	 * USB clock init:  choose 48 MHz PLLB value,
-	 * disable 48MHz clock during usb peripheral suspend.
-	 *
-	 * REVISIT:  assumes MCK doesn't derive from PLLB!
-	 */
-	at91_pllb_usb_init = at91_pll_calc(main_clock, 48000000 * 2) | AT91_PMC_USB96M;
-	pllb.rate_hz = at91_pll_rate(&pllb, main_clock, at91_pllb_usb_init);
-	if (cpu_is_at91rm9200()) {
-		uhpck.pmc_mask = AT91RM9200_PMC_UHP;
-		udpck.pmc_mask = AT91RM9200_PMC_UDP;
-		at91_sys_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
-	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
-		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
-		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
-	} else if (cpu_is_at91cap9()) {
-		uhpck.pmc_mask = AT91CAP9_PMC_UHP;
+
+	if (!cpu_has_pllb() && cpu_has_upll()) {
+		/* setup UTMI clock as the fourth primary clock
+		 * (instead of pllb) */
+		utmi_clk.type |= CLK_TYPE_PRIMARY;
+		utmi_clk.id = 3;
 	}
-	at91_sys_write(AT91_CKGR_PLLBR, 0);
 
-	udpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
-	uhpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
 
 	/*
 	 * USB HS clock init
 	 */
-	if (cpu_is_at91cap9() || cpu_is_at91sam9rl()) {
+	if (cpu_has_utmi())
 		/*
 		 * multiplier is hard-wired to 40
 		 * (obtain the USB High Speed 480 MHz when input is 12 MHz)
 		 */
 		utmi_clk.rate_hz = 40 * utmi_clk.parent->rate_hz;
-	}
+
+	/*
+	 * USB FS clock init
+	 */
+	if (cpu_has_pllb())
+		at91_pllb_usbfs_clock_init(main_clock);
+	if (cpu_has_upll())
+		/* assumes that we choose UPLL for USB and not PLLA */
+		at91_upll_usbfs_clock_init(main_clock);
 
 	/*
 	 * MCK and CPU derive from one of those primary clocks.
@@ -650,21 +718,31 @@ int __init at91_clock_init(unsigned long
 	mck.parent = at91_css_to_clk(mckr & AT91_PMC_CSS);
 	freq = mck.parent->rate_hz;
 	freq /= (1 << ((mckr & AT91_PMC_PRES) >> 2));				/* prescale */
-	if (cpu_is_at91rm9200())
+	if (cpu_is_at91rm9200()) {
 		mck.rate_hz = freq / (1 + ((mckr & AT91_PMC_MDIV) >> 8));	/* mdiv */
-	else if (cpu_is_at91sam9g20()) {
+	} else if (cpu_is_at91sam9g20()) {
 		mck.rate_hz = (mckr & AT91_PMC_MDIV) ?
 			freq / ((mckr & AT91_PMC_MDIV) >> 7) : freq;	/* mdiv ; (x >> 7) = ((x >> 8) * 2) */
 		if (mckr & AT91_PMC_PDIV)
 			freq /= 2;		/* processor clock division */
-	} else
-		mck.rate_hz = freq / (1 << ((mckr & AT91_PMC_MDIV) >> 8));	/* mdiv */
+	} else {
+		mck.rate_hz = freq / (1 << ((mckr & AT91_PMC_MDIV) >> 8));      /* mdiv */
+	}
 
 	/* Register the PMC's standard clocks */
 	for (i = 0; i < ARRAY_SIZE(standard_pmc_clocks); i++)
 		list_add_tail(&standard_pmc_clocks[i]->node, &clocks);
 
-	if (cpu_is_at91cap9() || cpu_is_at91sam9rl())
+	if (cpu_has_pllb())
+		list_add_tail(&pllb.node, &clocks);
+
+	if (cpu_has_uhp())
+		list_add_tail(&uhpck.node, &clocks);
+
+	if (cpu_has_udpfs())
+		list_add_tail(&udpck.node, &clocks);
+
+	if (cpu_has_utmi())
 		list_add_tail(&utmi_clk.node, &clocks);
 
 	/* MCK and CPU clock are "always on" */


