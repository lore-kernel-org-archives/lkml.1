Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbZCZOqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbZCZOqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbZCZOpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:45:54 -0400
Received: from mail.atmel.fr ([81.80.104.162]:52292 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbZCZOpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:45:53 -0400
Message-ID: <49CB9507.3020705@atmel.com>
Date: Thu, 26 Mar 2009 15:45:27 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <avictor.za@gmail.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>
Subject: [PATCH] AT91: manage clock by functionality instead of CPUs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In clock.c file the clock management is grouped by cpu with cpu_is_xxx()
function. This lead to some kind of difficulties to read this file and
maintainability issues as the number of AT91 cpus & PLLs/clocks is growing.

In this patch, I try to group clock functionality together and match cpus with
this functionality set.
An update to at91_pmc.h is needed to cover some new PMC possibilities (and
some update in comments).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c                 |  151 ++++++++++++++++++++-------
 arch/arm/mach-at91/include/mach/at91_pmc.h |   26 ++++-
 2 files changed, 132 insertions(+), 45 deletions(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index e434510..bac578f 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -43,6 +43,25 @@
 #define clk_is_sys(x)		((x)->type & CLK_TYPE_SYSTEM)
 
 
+/*
+ * Chips have some kind of clocks : group them by functionality
+ */
+#define cpu_has_utmi()		(  cpu_is_at91cap9() \
+				|| cpu_is_at91sam9rl())
+
+#define cpu_has_800M_plla()	(cpu_is_at91sam9g20())
+
+#define cpu_has_pllb()		(!cpu_is_at91sam9rl())
+
+#define cpu_has_upll()		(0)
+
+/* USB host HS & FS */
+#define cpu_has_uhp()		(!cpu_is_at91sam9rl())
+
+/* USB device FS only */
+#define cpu_has_udpfs()		(!cpu_is_at91sam9rl())
+
+
 static LIST_HEAD(clocks);
 static DEFINE_SPINLOCK(clk_lock);
 
@@ -140,7 +159,7 @@ static struct clk utmi_clk = {
 };
 static struct clk uhpck = {
 	.name		= "uhpck",
-	.parent		= &pllb,
+	/*.parent		= ... we choose parent at runtime */
 	.mode		= pmc_sys_mode,
 };
 
@@ -173,7 +192,11 @@ static struct clk __init *at91_css_to_clk(unsigned long css)
 		case AT91_PMC_CSS_PLLA:
 			return &plla;
 		case AT91_PMC_CSS_PLLB:
-			return &pllb;
+			if (cpu_has_upll())
+				/* CSS_PLLB == CSS_UPLL */
+				return &utmi_clk;
+			else if (cpu_has_pllb())
+				return &pllb;
 	}
 
 	return NULL;
@@ -322,7 +345,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 			u32	pckr;
 
 			pckr = at91_sys_read(AT91_PMC_PCKR(clk->id));
-			pckr &= AT91_PMC_CSS_PLLB;	/* clock selection */
+			pckr &= AT91_PMC_CSS;	/* clock selection */
 			pckr |= prescale << 2;
 			at91_sys_write(AT91_PMC_PCKR(clk->id), pckr);
 			clk->rate_hz = actual;
@@ -361,7 +384,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 }
 EXPORT_SYMBOL(clk_set_parent);
 
-/* establish PCK0..PCK3 parentage and rate */
+/* establish PCK0..PCKN parentage and rate */
 static void __init init_programmable_clock(struct clk *clk)
 {
 	struct clk	*parent;
@@ -389,11 +412,13 @@ static int at91_clk_show(struct seq_file *s, void *unused)
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
@@ -554,16 +579,60 @@ static struct clk *const standard_pmc_clocks[] __initdata = {
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
@@ -585,43 +654,37 @@ int __init at91_clock_init(unsigned long main_clock)
 
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
+	if (cpu_has_upll() && !cpu_has_pllb()) {
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
@@ -631,21 +694,31 @@ int __init at91_clock_init(unsigned long main_clock)
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
+	} else {
 		mck.rate_hz = freq / (1 << ((mckr & AT91_PMC_MDIV) >> 8));      /* mdiv */
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
diff --git a/arch/arm/mach-at91/include/mach/at91_pmc.h b/arch/arm/mach-at91/include/mach/at91_pmc.h
index 9561e33..64589ea 100644
--- a/arch/arm/mach-at91/include/mach/at91_pmc.h
+++ b/arch/arm/mach-at91/include/mach/at91_pmc.h
@@ -23,7 +23,7 @@
 #define		AT91_PMC_PCK		(1 <<  0)		/* Processor Clock */
 #define		AT91RM9200_PMC_UDP	(1 <<  1)		/* USB Devcice Port Clock [AT91RM9200 only] */
 #define		AT91RM9200_PMC_MCKUDP	(1 <<  2)		/* USB Device Port Master Clock Automatic Disable on Suspend [AT91RM9200 only] */
-#define		AT91CAP9_PMC_DDR	(1 <<  2)		/* DDR Clock [AT91CAP9 revC only] */
+#define		AT91CAP9_PMC_DDR	(1 <<  2)		/* DDR Clock [CAP9 revC & some SAM9 only] */
 #define		AT91RM9200_PMC_UHP	(1 <<  4)		/* USB Host Port Clock [AT91RM9200 only] */
 #define		AT91SAM926x_PMC_UHP	(1 <<  6)		/* USB Host Port Clock [AT91SAM926x only] */
 #define		AT91CAP9_PMC_UHP	(1 <<  6)		/* USB Host Port Clock [AT91CAP9 only] */
@@ -39,11 +39,11 @@
 #define	AT91_PMC_PCDR		(AT91_PMC + 0x14)	/* Peripheral Clock Disable Register */
 #define	AT91_PMC_PCSR		(AT91_PMC + 0x18)	/* Peripheral Clock Status Register */
 
-#define	AT91_CKGR_UCKR		(AT91_PMC + 0x1C)	/* UTMI Clock Register [SAM9RL, CAP9] */
+#define	AT91_CKGR_UCKR		(AT91_PMC + 0x1C)	/* UTMI Clock Register [some SAM9, CAP9] */
 #define		AT91_PMC_UPLLEN		(1   << 16)		/* UTMI PLL Enable */
 #define		AT91_PMC_UPLLCOUNT	(0xf << 20)		/* UTMI PLL Start-up Time */
 #define		AT91_PMC_BIASEN		(1   << 24)		/* UTMI BIAS Enable */
-#define		AT91_PMC_BIASCOUNT	(0xf << 28)		/* UTMI PLL Start-up Time */
+#define		AT91_PMC_BIASCOUNT	(0xf << 28)		/* UTMI BIAS Start-up Time */
 
 #define	AT91_CKGR_MOR		(AT91_PMC + 0x20)	/* Main Oscillator Register [not on SAM9RL] */
 #define		AT91_PMC_MOSCEN		(1    << 0)		/* Main Oscillator Enable */
@@ -72,6 +72,7 @@
 #define			AT91_PMC_CSS_MAIN		(1 << 0)
 #define			AT91_PMC_CSS_PLLA		(2 << 0)
 #define			AT91_PMC_CSS_PLLB		(3 << 0)
+#define			AT91_PMC_CSS_UPLL		(3 << 0)	/* [some SAM9 only] */
 #define		AT91_PMC_PRES		(7 <<  2)		/* Master Clock Prescaler */
 #define			AT91_PMC_PRES_1			(0 << 2)
 #define			AT91_PMC_PRES_2			(1 << 2)
@@ -88,12 +89,25 @@
 #define			AT91SAM9_PMC_MDIV_1		(0 << 8)	/* [SAM9,CAP9 only] */
 #define			AT91SAM9_PMC_MDIV_2		(1 << 8)
 #define			AT91SAM9_PMC_MDIV_4		(2 << 8)
-#define			AT91SAM9_PMC_MDIV_6		(3 << 8)
+#define			AT91SAM9_PMC_MDIV_6		(3 << 8)	/* [some SAM9 only] */
+#define			AT91SAM9_PMC_MDIV_3		(3 << 8)	/* [some SAM9 only] */
 #define		AT91_PMC_PDIV		(1 << 12)		/* Processor Clock Division [some SAM9 only] */
 #define			AT91_PMC_PDIV_1			(0 << 12)
 #define			AT91_PMC_PDIV_2			(1 << 12)
+#define		AT91_PMC_PLLADIV2	(1 << 12)		/* PLLA divisor by 2 [some SAM9 only] */
+#define			AT91_PMC_PLLADIV2_OFF		(0 << 12)
+#define			AT91_PMC_PLLADIV2_ON		(1 << 12)
 
-#define	AT91_PMC_PCKR(n)	(AT91_PMC + 0x40 + ((n) * 4))	/* Programmable Clock 0-3 Registers */
+#define	AT91_PMC_USB		(AT91_PMC + 0x38)	/* USB Clock Register [some SAM9 only] */
+#define		AT91_PMC_USBS		(0x1 <<  0)		/* USB OHCI Input clock selection */
+#define			AT91_PMC_USBS_PLLA		(0 << 0)
+#define			AT91_PMC_USBS_UPLL		(1 << 0)
+#define		AT91_PMC_OHCIUSBDIV	(0xF <<  8)		/* Divider for USB OHCI Clock */
+
+#define	AT91_PMC_PCKR(n)	(AT91_PMC + 0x40 + ((n) * 4))	/* Programmable Clock 0-N Registers */
+#define		AT91_PMC_CSSMCK		(0x1 <<  8)		/* CSS or Master Clock Selection */
+#define			AT91_PMC_CSSMCK_CSS		(0 << 8)
+#define			AT91_PMC_CSSMCK_MCK		(1 << 8)
 
 #define	AT91_PMC_IER		(AT91_PMC + 0x60)	/* Interrupt Enable Register */
 #define	AT91_PMC_IDR		(AT91_PMC + 0x64)	/* Interrupt Disable Register */
@@ -102,7 +116,7 @@
 #define		AT91_PMC_LOCKA		(1 <<  1)		/* PLLA Lock */
 #define		AT91_PMC_LOCKB		(1 <<  2)		/* PLLB Lock */
 #define		AT91_PMC_MCKRDY		(1 <<  3)		/* Master Clock */
-#define		AT91_PMC_LOCKU		(1 <<  6)		/* UPLL Lock [AT91CAP9 only] */
+#define		AT91_PMC_LOCKU		(1 <<  6)		/* UPLL Lock [some SAM9, AT91CAP9 only] */
 #define		AT91_PMC_OSCSEL		(1 <<  7)		/* Slow Clock Oscillator [AT91CAP9 revC only] */
 #define		AT91_PMC_PCK0RDY	(1 <<  8)		/* Programmable Clock 0 */
 #define		AT91_PMC_PCK1RDY	(1 <<  9)		/* Programmable Clock 1 */
-- 
1.5.3.7



