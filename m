Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZBTXL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZBTXL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZBTXLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:11:18 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20014 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753733AbZBTXLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:11:17 -0500
X-BigFish: VPS-1(zz1402Jzzzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KFE0E9-01-JWW-01
Date: Sat, 21 Feb 2009 00:09:47 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Mark Hounschell <markh@compro.net>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/3] x86: hpet: print HPET registers during setup (if
	hpet=verbose is used)
Message-ID: <20090220230947.GI6298@alberich.amd.com>
References: <20090220230729.GK4834@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090220230729.GK4834@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 23:10:08.0257 (UTC) FILETIME=[5F80BF10:01C993B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: provide verbose HPET information

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 Documentation/kernel-parameters.txt |    4 ++-
 arch/x86/kernel/hpet.c              |   45 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b182626..01379a8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -492,10 +492,12 @@ and is between 256 and 4096 characters. It is defined in the file
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
index a00545f..84450b1 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -80,6 +80,7 @@ static inline void hpet_clear_mapping(void)
  */
 static int boot_hpet_disable;
 int hpet_force_user;
+static int hpet_verbose;
 
 static int __init hpet_setup(char *str)
 {
@@ -88,6 +89,8 @@ static int __init hpet_setup(char *str)
 			boot_hpet_disable = 1;
 		if (!strncmp("force", str, 5))
 			hpet_force_user = 1;
+		if (!strncmp("verbose", str, 7))
+			hpet_verbose = 1;
 	}
 	return 1;
 }
@@ -119,6 +122,43 @@ int is_hpet_enabled(void)
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
@@ -282,6 +322,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		hpet_writel(cmp, HPET_Tn_CMP(timer));
 		udelay(1);
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_print_config();
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -308,6 +349,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 			irq_set_affinity(hdev->irq, cpumask_of(hdev->cpu));
 			enable_irq(hdev->irq);
 		}
+		hpet_print_config();
 		break;
 	}
 }
@@ -526,6 +568,7 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
 	num_timers++; /* Value read out starts from 0 */
+	hpet_print_config();
 
 	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
 	if (!hpet_devs)
@@ -793,6 +836,7 @@ int __init hpet_enable(void)
 	 * information and the number of channels
 	 */
 	id = hpet_readl(HPET_ID);
+	hpet_print_config();
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 	/*
@@ -845,6 +889,7 @@ static __init int hpet_late_init(void)
 		return -ENODEV;
 
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
+	hpet_print_config();
 
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
-- 
1.6.1.3



