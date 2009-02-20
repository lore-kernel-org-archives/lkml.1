Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZBTW3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZBTW3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZBTW3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:29:20 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:15045
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754110AbZBTW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:29:17 -0500
X-BigFish: VPS-2(zz10e3Mzzzzz32i6bh34h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KFDYGB-01-IJ5-01
Date: Fri, 20 Feb 2009 23:28:47 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090220222847.GJ4834@alberich.amd.com>
References: <20090220115357.GE4834@alberich.amd.com> <499ECF87.2070204@cfl.rr.com> <20090220160843.GF4834@alberich.amd.com> <20090220163844.GG4834@alberich.amd.com> <499EE3BA.7070105@cfl.rr.com> <499EEB0F.8010201@cfl.rr.com> <20090220182212.GH4834@alberich.amd.com> <499EF662.7010001@cfl.rr.com> <499F0A67.0@cfl.rr.com> <499F122E.1080601@cfl.rr.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
In-Reply-To: <499F122E.1080601@cfl.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 22:29:08.0507 (UTC) FILETIME=[A560AEB0:01C993AA]
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Mark,

Here we go ...

Attached is a compound version against v2.6.28.4 of some
hpet patches that I'd like to submit asap.

Can you please apply this patch and test it on your machine.

By chance I've found a machine wich also hangs with HZ_1000.
And this patch fixes the problem on this machine.


Regards,
Andreas

PS: Please boot with "hpet=3Dverbose" to show the HPET registers
(no additional debug parameter needed this time).

--=20
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. M=FCnchen, Germa=
ny
 Research | Gesch=E4ftsf=FChrer: Jochen Polster, Thomas M. McCoy, Giulian=
o Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis M=FCnchen
  (OSRC)  | Registergericht M=FCnchen, HRB Nr. 43632

--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="hpet-cmpound-patch.diff"

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c9115c1..a6a4134 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -485,10 +485,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Default: 64
 
 	hpet=		[X86-32,HPET] option to control HPET usage
-			Format: { enable (default) | disable | force }
+			Format: { enable (default) | disable | force |
+				verbose }
 			disable: disable HPET and use PIT instead
 			force: allow force enabled of undocumented chips (ICH4,
 			VIA, nVidia)
+			verbose: show contents of HPET registers during setup
 
 	com20020=	[HW,NET] ARCnet - COM20020 chipset
 			Format:
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 067d8de..85366b2 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -78,6 +78,7 @@ static inline void hpet_clear_mapping(void)
  */
 static int boot_hpet_disable;
 int hpet_force_user;
+static int hpet_verbose;
 
 static int __init hpet_setup(char *str)
 {
@@ -86,6 +87,8 @@ static int __init hpet_setup(char *str)
 			boot_hpet_disable = 1;
 		if (!strncmp("force", str, 5))
 			hpet_force_user = 1;
+		if (!strncmp("verbose", str, 7))
+			hpet_verbose = 1;
 	}
 	return 1;
 }
@@ -117,6 +120,43 @@ int is_hpet_enabled(void)
 }
 EXPORT_SYMBOL_GPL(is_hpet_enabled);
 
+static void _hpet_print_config(const char *function, int line)
+{
+	u32 i, timers, l, h;
+	printk(KERN_INFO "hpet: %s(%d):\n", function, line);
+	l = hpet_readl(HPET_ID);
+	h = hpet_readl(HPET_PERIOD);
+	timers = ((l & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
+	printk(KERN_INFO "hpet: ID: 0x%x, PERIOD: 0x%x\n", l, h);
+	l = hpet_readl(HPET_CFG);
+	h = hpet_readl(HPET_STATUS);
+	printk(KERN_INFO "hpet: CFG: 0x%x, STATUS: 0x%x\n", l, h);
+	l = hpet_readl(HPET_COUNTER);
+	h = hpet_readl(HPET_COUNTER+4);
+	printk(KERN_INFO "hpet: COUNTER_l: 0x%x, COUNTER_h: 0x%x\n", l, h);
+
+	for (i = 0; i < timers; i++) {
+		l = hpet_readl(HPET_Tn_CFG(i));
+		h = hpet_readl(HPET_Tn_CFG(i)+4);
+		printk(KERN_INFO "hpet: T%d: CFG_l: 0x%x, CFG_h: 0x%x\n",
+		       i, l, h);
+		l = hpet_readl(HPET_Tn_CMP(i));
+		h = hpet_readl(HPET_Tn_CMP(i)+4);
+		printk(KERN_INFO "hpet: T%d: CMP_l: 0x%x, CMP_h: 0x%x\n",
+		       i, l, h);
+		l = hpet_readl(HPET_Tn_ROUTE(i));
+		h = hpet_readl(HPET_Tn_ROUTE(i)+4);
+		printk(KERN_INFO "hpet: T%d ROUTE_l: 0x%x, ROUTE_h: 0x%x\n",
+		       i, l, h);
+	}
+}	
+
+#define hpet_print_config()					\
+do {								\
+	if (hpet_verbose)					\
+		_hpet_print_config(__FUNCTION__, __LINE__);	\
+} while (0)
+
 /*
  * When the hpet driver (/dev/hpet) is enabled, we need to reserve
  * timer 0 and timer 1 in case of RTC emulation.
@@ -189,27 +229,37 @@ static struct clock_event_device hpet_clockevent = {
 	.rating		= 50,
 };
 
-static void hpet_start_counter(void)
+static void hpet_stop_counter(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
-
 	cfg &= ~HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 	hpet_writel(0, HPET_COUNTER);
 	hpet_writel(0, HPET_COUNTER + 4);
+}
+
+static void hpet_start_counter(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
 	cfg |= HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 }
 
+static void hpet_restart_counter(void)
+{
+	hpet_stop_counter();
+	hpet_start_counter();
+}
+
 static void hpet_resume_device(void)
 {
 	force_hpet_resume();
 }
 
-static void hpet_restart_counter(void)
+static void hpet_resume_counter(void)
 {
 	hpet_resume_device();
-	hpet_start_counter();
+	hpet_restart_counter();
 }
 
 static void hpet_enable_legacy_int(void)
@@ -257,27 +307,21 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg, cmp, now;
+	unsigned long cfg;
 	uint64_t delta;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
+		hpet_stop_counter();
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
-		now = hpet_readl(HPET_COUNTER);
-		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
-		/*
-		 * The first write after writing TN_SETVAL to the
-		 * config register sets the counter value, the second
-		 * write sets the period.
-		 */
-		hpet_writel(cmp, HPET_Tn_CMP(timer));
-		udelay(1);
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_start_counter();
+		hpet_print_config();
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -304,6 +348,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 			irq_set_affinity(hdev->irq, cpumask_of_cpu(hdev->cpu));
 			enable_irq(hdev->irq);
 		}
+		hpet_print_config();
 		break;
 	}
 }
@@ -522,6 +567,7 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
 	num_timers++; /* Value read out starts from 0 */
+	hpet_print_config();
 
 	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
 	if (!hpet_devs)
@@ -690,7 +736,7 @@ static struct clocksource clocksource_hpet = {
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_restart_counter,
+	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
 	.vread		= vread_hpet,
 #endif
@@ -702,7 +748,7 @@ static int hpet_clocksource_register(void)
 	cycle_t t1;
 
 	/* Start the counter */
-	hpet_start_counter();
+	hpet_restart_counter();
 
 	/* Verify whether hpet counter works */
 	t1 = read_hpet();
@@ -788,6 +834,7 @@ int __init hpet_enable(void)
 	 * information and the number of channels
 	 */
 	id = hpet_readl(HPET_ID);
+	hpet_print_config();
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 	/*
@@ -839,6 +886,7 @@ static __init int hpet_late_init(void)
 	}
 
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
+	hpet_print_config();
 
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);

--DiL7RhKs8rK9YGuF--
