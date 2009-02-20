Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZBTLyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZBTLyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 06:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZBTLyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 06:54:35 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:51962 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZBTLye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:54:34 -0500
X-BigFish: VPS-32(zz1432R98dR148cM1805M936fKzzzzz32i6bh34h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,5,
X-WSS-ID: 0KFD52F-01-TRE-01
Date: Fri, 20 Feb 2009 12:53:57 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
	processor
Message-ID: <20090220115357.GE4834@alberich.amd.com>
References: <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <499D77D8.509@cfl.rr
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
In-Reply-To: <499D80AB.3090408@cfl.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 11:54:17.0519 (UTC) FILETIME=[F5612BF0:01C99351]
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 19, 2009 at 10:54:19AM -0500, Mark Hounschell wrote:
> Borislav Petkov wrote:
> > On Thu, Feb 19, 2009 at 10:16:40AM -0500, Mark Hounschell wrote:
> >> Andreas Herrmann wrote:
> >>> Hi Mark,
> >>>
> >>> Can you please provide us output of lspci -vvxxx.
> >>> (Please run this as root.)
> >>>
>=20
> Attached...
>=20
>=20
> >>> Furthermore you can try booting your 1000HZ kernel
> >>> with following kernel command lines:
> >>>

Thanks for trying this out.
But nothing suspicious found. I.e. timer/hpet interrupt is enabled
and its routing seems to be ok.

Here's one more check that's worth trying: In one of your logs I've
seen that HPET id reports 3 timers but later on 4 timers were detected
for HPET.

To check what's going on I'd like to see the HPET configuration in the
course of booting your system.  Please apply attached patch and boot
with hpet=3Ddebug -- both with 250HZ and with 1000HZ -- and provide dmesg
output.


Regards,

Andreas

--=20
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. M=FCnchen, Germa=
ny
 Research | Gesch=E4ftsf=FChrer: Jochen Polster, Thomas M. McCoy, Giulian=
o Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis M=FCnchen
  (OSRC)  | Registergericht M=FCnchen, HRB Nr. 43632

--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="hpet-debug.diff"

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 388254f..2a389d9 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -80,6 +80,7 @@ static inline void hpet_clear_mapping(void)
  */
 static int boot_hpet_disable;
 int hpet_force_user;
+static int hpet_debug;
 
 static int __init hpet_setup(char *str)
 {
@@ -88,6 +89,8 @@ static int __init hpet_setup(char *str)
 			boot_hpet_disable = 1;
 		if (!strncmp("force", str, 5))
 			hpet_force_user = 1;
+		if (!strncmp("debug", str, 5))
+			hpet_debug = 1;
 	}
 	return 1;
 }
@@ -119,6 +122,42 @@ int is_hpet_enabled(void)
 }
 EXPORT_SYMBOL_GPL(is_hpet_enabled);
 
+static void _hpet_print_config(const char *function, int line)
+{
+	u32 l, h;
+	printk(KERN_DEBUG "hpet: %s(%d):\n", function, line);
+	l = hpet_readl(HPET_ID); h = hpet_readl(HPET_PERIOD);
+	printk(KERN_DEBUG "hpet: ID: %x, PERIOD: %x\n", l, h);
+	l = hpet_readl(HPET_CFG); h = hpet_readl(HPET_STATUS);
+	printk(KERN_DEBUG "hpet: CFG: %x, STATUS: %x\n", l, h);
+	l = hpet_readl(HPET_COUNTER); h = hpet_readl(HPET_COUNTER+4);
+	printk(KERN_DEBUG "hpet: COUNTER_l: %x, COUNTER_h: %x\n", l, h);
+	l = hpet_readl(HPET_T0_CFG); h = hpet_readl(HPET_T0_CFG+4);
+	printk(KERN_DEBUG "hpet: T0_CFG_l: %x, T0_CFG_h: %x\n", l, h);
+	l = hpet_readl(HPET_T0_CMP); h = hpet_readl(HPET_T0_CMP+4);
+	printk(KERN_DEBUG "hpet: T0_CMP_l: %x, T0_CMP_h: %x\n", l, h);
+	l = hpet_readl(HPET_T0_ROUTE); h = hpet_readl(HPET_T0_ROUTE+4);
+	printk(KERN_DEBUG "hpet: T0_ROUTE_l: %x, T0_ROUTE_h: %x\n", l, h);
+	l = hpet_readl(HPET_T1_CFG); h = hpet_readl(HPET_T1_CFG+4);
+	printk(KERN_DEBUG "hpet: T1_CFG_l: %x, T1_CFG_h: %x\n", l, h);
+	l = hpet_readl(HPET_T1_CMP); h = hpet_readl(HPET_T1_CMP+4);
+	printk(KERN_DEBUG "hpet: T1_CMP_l: %x, T1_CMP_h: %x\n", l, h);
+	l = hpet_readl(HPET_T1_ROUTE); h = hpet_readl(HPET_T1_ROUTE+4);
+	printk(KERN_DEBUG "hpet: T1_ROUTE_l: %x, T1_ROUTE_h: %x\n", l, h);
+	l = hpet_readl(HPET_T2_CFG); h = hpet_readl(HPET_T2_CFG+4);
+	printk(KERN_DEBUG "hpet: T2_CFG_l: %x, T2_CFG_h: %x\n", l, h);
+	l = hpet_readl(HPET_T2_CMP); h = hpet_readl(HPET_T2_CMP+4);
+	printk(KERN_DEBUG "hpet: T2_CMP_l: %x, T2_CMP_h: %x\n", l, h);
+	l = hpet_readl(HPET_T2_ROUTE); h = hpet_readl(HPET_T2_ROUTE+4);
+	printk(KERN_DEBUG "hpet: T2_ROUTE_l: %x, T2_ROUTE_h: %x\n", l, h);
+}	
+
+#define hpet_print_config()					\
+do {								\
+	if (hpet_debug)						\
+		_hpet_print_config(__FUNCTION__, __LINE__);	\
+} while (0)
+
 /*
  * When the hpet driver (/dev/hpet) is enabled, we need to reserve
  * timer 0 and timer 1 in case of RTC emulation.
@@ -264,6 +303,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
+		hpet_print_config();
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
 		now = hpet_readl(HPET_COUNTER);
@@ -280,6 +320,8 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		hpet_writel(cmp, HPET_Tn_CMP(timer));
 		udelay(1);
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		WARN_ON(cmp <= hpet_readl(HPET_COUNTER));
+		hpet_print_config();
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -524,6 +566,7 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
 	num_timers++; /* Value read out starts from 0 */
+	hpet_print_config();
 
 	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
 	if (!hpet_devs)
@@ -791,6 +834,7 @@ int __init hpet_enable(void)
 	 * information and the number of channels
 	 */
 	id = hpet_readl(HPET_ID);
+	hpet_print_config();
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 	/*
@@ -843,6 +887,7 @@ static __init int hpet_late_init(void)
 		return -ENODEV;
 
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
+	hpet_print_config();
 
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);

--E/DnYTRukya0zdZ1--
