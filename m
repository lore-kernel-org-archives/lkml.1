Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYDKH47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYDKH47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbYDKH4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:56:50 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63128 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006AbYDKH4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:56:48 -0400
Message-ID: <47FF1915.6030102@ah.jp.nec.com>
Date: Fri, 11 Apr 2008 16:53:57 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
CC: kdb@oss.sgi.com, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, nickpiggin@yahoo.com.au,
       Randy Dunlap <rdunlap@xenotime.net>, greg@kroah.com
Subject: [PATCH 2/2] implement new notifier function to panic_notifier_list
 ,take3
References: <47FF0EA5.8090804@ah.jp.nec.com>
In-Reply-To: <47FF0EA5.8090804@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements new notifier function to panic_notifier_list. We can
change the list of order by debugfs.

Thanks,

---

Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>

---
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/alpha/kernel/setup.c linux-2.6.25-rc8-mm1/arch/alpha/kernel/setup.c
--- linux-2.6.25-rc8-mm1.orig/arch/alpha/kernel/setup.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/alpha/kernel/setup.c	2008-04-10 21:30:16.143555075 +0900
@@ -44,14 +44,18 @@
 #include <asm/io.h>
 #include <linux/log2.h>
 
-extern struct atomic_notifier_head panic_notifier_list;
+extern struct tunable_atomic_notifier_head panic_notifier_list;
 static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
-static struct notifier_block alpha_panic_block = {
+static struct notifier_block alpha_panic_block_base = {
 	alpha_panic_event,
         NULL,
         INT_MAX /* try to do it first */
 };
 
+static struct tunable_atomic_notifier_block alpha_panic_block = {
+	.nb = &alpha_panic_block_base
+};
+
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -521,8 +525,8 @@ setup_arch(char **cmdline_p)
 	}
 
 	/* Register a call for panic conditions. */
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&alpha_panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+				&alpha_panic_block, "alpha_panic", NULL);
 
 #ifdef CONFIG_ALPHA_GENERIC
 	/* Assume that we've booted from SRM if we haven't booted from MILO.
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/arm/mach-omap1/board-voiceblue.c linux-2.6.25-rc8-mm1/arch/arm/mach-omap1/board-voiceblue.c
--- linux-2.6.25-rc8-mm1.orig/arch/arm/mach-omap1/board-voiceblue.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/arm/mach-omap1/board-voiceblue.c	2008-04-10 22:01:58.275482847 +0900
@@ -226,14 +226,19 @@ static int panic_event(struct notifier_b
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call	= panic_event,
 };
 
+static struct tunable_atomic_notifier_block panic_block = {
+	.nb             = &panic_block_base
+};
+
 static int __init voiceblue_setup(void)
 {
 	/* Setup panic notifier */
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					&panic_block, "VoiceBlue", NULL);
 
 	return 0;
 }
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/mips/lasat/setup.c linux-2.6.25-rc8-mm1/arch/mips/lasat/setup.c
--- linux-2.6.25-rc8-mm1.orig/arch/mips/lasat/setup.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/mips/lasat/setup.c	2008-04-10 21:10:23.147126270 +0900
@@ -106,7 +106,7 @@ static int lasat_panic_prom_monitor(stru
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block lasat_panic_block[] =
+static struct notifier_block lasat_panic_block_base[] =
 {
 	{
 		.notifier_call	= lasat_panic_display,
@@ -117,6 +117,18 @@ static struct notifier_block lasat_panic
 	}
 };
 
+static struct tunable_atomic_notifier_block lasat_panic_block[] = {
+	{
+		.nb		= &lasat_panic_block_base[0]
+	}, {
+		.nb		= &lasat_panic_block_base[1]
+	}
+};
+
+static char* notifier_name[] = {
+	"lasat_panic_display", "lasat_panic_prom_monitor"
+};
+
 void __init plat_time_init(void)
 {
 	mips_hpt_frequency = lasat_board_info.li_cpu_hz / 2;
@@ -134,8 +146,8 @@ void __init plat_mem_setup(void)
 
 	/* Set up panic notifier */
 	for (i = 0; i < ARRAY_SIZE(lasat_panic_block); i++)
-		atomic_notifier_chain_register(&panic_notifier_list,
-				&lasat_panic_block[i]);
+		tunable_notifier_chain_register(&panic_notifier_list,
+				&lasat_panic_block[i], notifier_name[i], NULL);
 
 	lasat_reboot_setup();
 
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/mips/sgi-ip22/ip22-reset.c linux-2.6.25-rc8-mm1/arch/mips/sgi-ip22/ip22-reset.c
--- linux-2.6.25-rc8-mm1.orig/arch/mips/sgi-ip22/ip22-reset.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/mips/sgi-ip22/ip22-reset.c	2008-04-10 22:04:16.570605171 +0900
@@ -226,10 +226,14 @@ static int panic_event(struct notifier_b
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call	= panic_event,
 };
 
+static struct tunable_atomic_notifier_block panic_block = {
+	.nb		= &panic_block_base
+};
+
 static int __init reboot_setup(void)
 {
 	int res;
@@ -246,7 +250,8 @@ static int __init reboot_setup(void)
 
 	init_timer(&blink_timer);
 	blink_timer.function = blink_timeout;
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					       &panic_block, "sgi-ip22", NULL);
 
 	return 0;
 }
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/mips/sgi-ip32/ip32-reset.c linux-2.6.25-rc8-mm1/arch/mips/sgi-ip32/ip32-reset.c
--- linux-2.6.25-rc8-mm1.orig/arch/mips/sgi-ip32/ip32-reset.c	2008-04-08 16:37:19.068000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/mips/sgi-ip32/ip32-reset.c	2008-04-10 22:04:37.830470059 +0900
@@ -175,10 +175,14 @@ static int panic_event(struct notifier_b
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call = panic_event,
 };
 
+static struct tunable_atomic_notifier_block panic_block = {
+	.nb		= &panic_block_base
+};
+
 static __init int ip32_reboot_setup(void)
 {
 	/* turn on the green led only */
@@ -193,7 +197,8 @@ static __init int ip32_reboot_setup(void
 
 	init_timer(&blink_timer);
 	blink_timer.function = blink_timeout;
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					       &panic_block, "sgi-ip32", NULL);
 
 	if (request_irq(MACEISA_RTC_IRQ, ip32_rtc_int, 0, "rtc", NULL))
 		panic("Can't allocate MACEISA RTC IRQ");
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/parisc/kernel/pdc_chassis.c linux-2.6.25-rc8-mm1/arch/parisc/kernel/pdc_chassis.c
--- linux-2.6.25-rc8-mm1.orig/arch/parisc/kernel/pdc_chassis.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/parisc/kernel/pdc_chassis.c	2008-04-10 21:28:22.068278645 +0900
@@ -101,11 +101,14 @@ static int pdc_chassis_panic_event(struc
 }   
 
 
-static struct notifier_block pdc_chassis_panic_block = {
+static struct notifier_block pdc_chassis_panic_block_base = {
 	.notifier_call = pdc_chassis_panic_event,
 	.priority = INT_MAX,
 };
 
+static struct tunable_atomic_notifier_block pdc_chassis_panic_block = {
+	.nb		= &pdc_chassis_panic_block_base
+};
 
 /**
  * parisc_reboot_event() - Called by the reboot handler.
@@ -144,8 +147,8 @@ void __init parisc_pdc_chassis_init(void
 				PDC_CHASSIS_VER);
 
 		/* initialize panic notifier chain */
-		atomic_notifier_chain_register(&panic_notifier_list,
-				&pdc_chassis_panic_block);
+		tunable_atomic_notifier_chain_register(&panic_notifier_list,
+				&pdc_chassis_panic_block, "pdc_chassis", NULL);
 
 		/* initialize reboot notifier chain */
 		register_reboot_notifier(&pdc_chassis_reboot_block);
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/powerpc/kernel/setup-common.c linux-2.6.25-rc8-mm1/arch/powerpc/kernel/setup-common.c
--- linux-2.6.25-rc8-mm1.orig/arch/powerpc/kernel/setup-common.c	2008-04-08 16:37:20.204000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/powerpc/kernel/setup-common.c	2008-04-08 16:32:35.232000000 +0900
@@ -609,14 +609,19 @@ static int ppc_panic_event(struct notifi
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block ppc_panic_block = {
+static struct notifier_block ppc_panic_block_base = {
 	.notifier_call = ppc_panic_event,
 	.priority = INT_MIN /* may not return; must be done last */
 };
 
+static struct tunable_atomic_notifier_block ppc_panic_block = {
+	.nb		= &ppc_panic_block_base
+};
+
 void __init setup_panic(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &ppc_panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					&ppc_panic_block, "powerpc", NULL);
 }
 
 #ifdef CONFIG_CHECK_CACHE_COHERENCY
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/ppc/platforms/prep_setup.c linux-2.6.25-rc8-mm1/arch/ppc/platforms/prep_setup.c
--- linux-2.6.25-rc8-mm1.orig/arch/ppc/platforms/prep_setup.c	2008-04-08 16:37:23.060000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/ppc/platforms/prep_setup.c	2008-04-10 21:31:42.807004709 +0900
@@ -634,12 +634,16 @@ ibm_statusled_panic(struct notifier_bloc
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block ibm_statusled_block = {
+static struct notifier_block ibm_statusled_block_base = {
 	ibm_statusled_panic,
 	NULL,
 	INT_MAX /* try to do it first */
 };
 
+static struct tunable_atomic_notifier_block ibm_statusled_block = {
+	.nb = &ibm_statusled_block_base
+};
+
 static void
 ibm_statusled_progress(char *s, unsigned short hex)
 {
@@ -654,8 +658,9 @@ ibm_statusled_progress(char *s, unsigned
 		hex = 0xfff;
 		if (!notifier_installed) {
 			++notifier_installed;
-			atomic_notifier_chain_register(&panic_notifier_list,
-						&ibm_statusled_block);
+			tunable_atomic_notifier_chain_register(
+				&panic_notifier_list, &ibm_statusled_block,
+				"IBM_statusLED", NULL);
 		}
 	}
 	else
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/s390/kernel/ipl.c linux-2.6.25-rc8-mm1/arch/s390/kernel/ipl.c
--- linux-2.6.25-rc8-mm1.orig/arch/s390/kernel/ipl.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/s390/kernel/ipl.c	2008-04-08 16:32:35.232000000 +0900
@@ -1372,11 +1372,15 @@ static int on_panic_notify(struct notifi
 	return NOTIFY_OK;
 }
 
-static struct notifier_block on_panic_nb = {
+static struct notifier_block on_panic_nb_base = {
 	.notifier_call = on_panic_notify,
 	.priority = 0,
 };
 
+static struct tunable_atomic_notifier_block on_panic_nb = {
+	.nb = &on_panic_nb_base
+};
+
 void __init setup_ipl(void)
 {
 	ipl_info.type = get_ipl_type();
@@ -1402,7 +1406,8 @@ void __init setup_ipl(void)
 		/* We have no info to copy */
 		break;
 	}
-	atomic_notifier_chain_register(&panic_notifier_list, &on_panic_nb);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+						&on_panic_nb, "s390_ipl", NULL);
 }
 
 void __init ipl_save_parameters(void)
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/sparc64/kernel/sstate.c linux-2.6.25-rc8-mm1/arch/sparc64/kernel/sstate.c
--- linux-2.6.25-rc8-mm1.orig/arch/sparc64/kernel/sstate.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/sparc64/kernel/sstate.c	2008-04-10 21:32:20.798763557 +0900
@@ -82,11 +82,15 @@ static int sstate_panic_event(struct not
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block sstate_panic_block = {
+static struct notifier_block sstate_panic_block_base = {
 	.notifier_call	=	sstate_panic_event,
 	.priority	=	INT_MAX,
 };
 
+static struct tunable_atomic_notifier_block sstate_panic_block = {
+	.nb		=	&sstate_panic_block_base
+};
+
 void __init sun4v_sstate_init(void)
 {
 	unsigned long major, minor;
@@ -99,6 +103,6 @@ void __init sun4v_sstate_init(void)
 	hv_supports_soft_state = 1;
 
 	prom_sun4v_guest_soft_state();
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &sstate_panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					&sstate_panic_block, "sstate" ,NULL);
 }
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/um/drivers/mconsole_kern.c linux-2.6.25-rc8-mm1/arch/um/drivers/mconsole_kern.c
--- linux-2.6.25-rc8-mm1.orig/arch/um/drivers/mconsole_kern.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/um/drivers/mconsole_kern.c	2008-04-08 16:32:35.236000000 +0900
@@ -920,16 +920,20 @@ static int notify_panic(struct notifier_
 	return 0;
 }
 
-static struct notifier_block panic_exit_notifier = {
+static struct notifier_block panic_exit_notifier_base = {
 	.notifier_call 		= notify_panic,
 	.next 			= NULL,
 	.priority 		= 1
 };
 
+static struct tunable_atomic_notifier_block panic_exit_notifier = {
+	.nb			= &panic_exit_notifier_base
+};
+
 static int add_notifier(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&panic_exit_notifier);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					&panic_exit_notifier, "mconsole", NULL);
 	return 0;
 }
 
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/um/kernel/um_arch.c linux-2.6.25-rc8-mm1/arch/um/kernel/um_arch.c
--- linux-2.6.25-rc8-mm1.orig/arch/um/kernel/um_arch.c	2008-04-08 16:37:25.004000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/um/kernel/um_arch.c	2008-04-08 16:32:35.236000000 +0900
@@ -234,12 +234,16 @@ static int panic_exit(struct notifier_bl
 	return 0;
 }
 
-static struct notifier_block panic_exit_notifier = {
+static struct notifier_block panic_exit_notifier_base = {
 	.notifier_call 		= panic_exit,
 	.next 			= NULL,
 	.priority 		= 0
 };
 
+static struct tunable_atomic_notifier_block panic_exit_notifier = {
+	.nb			= &panic_exit_notifier_base
+};
+
 /* Set during early boot */
 unsigned long task_size;
 EXPORT_SYMBOL(task_size);
@@ -357,8 +361,8 @@ int __init linux_main(int argc, char **a
 		printf("Kernel virtual memory size shrunk to %lu bytes\n",
 		       virtmem_size);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &panic_exit_notifier);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+				       &panic_exit_notifier, "um", NULL);
 
 	uml_postsetup();
 
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/x86/lguest/boot.c linux-2.6.25-rc8-mm1/arch/x86/lguest/boot.c
--- linux-2.6.25-rc8-mm1.orig/arch/x86/lguest/boot.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/x86/lguest/boot.c	2008-04-08 16:32:35.236000000 +0900
@@ -820,17 +820,22 @@ static int lguest_panic(struct notifier_
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block paniced = {
+static struct notifier_block paniced_base = {
 	.notifier_call = lguest_panic
 };
 
+static struct tunable_atomic_notifier_block paniced = {
+	.nb = = &paniced_base
+};
+
 /* Setting up memory is fairly easy. */
 static __init char *lguest_memory_setup(void)
 {
 	/* We do this here and not earlier because lockcheck used to barf if we
 	 * did it before start_kernel().  I think we fixed that, so it'd be
 	 * nice to move it back to lguest_init.  Patch welcome... */
-	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list, &paniced,
+							"lguest", NULL);
 
 	/* The Linux bootloader header contains an "e820" memory map: the
 	 * Launcher populated the first entry with our memory limit. */
diff -uprN linux-2.6.25-rc8-mm1.orig/arch/xtensa/platforms/iss/setup.c linux-2.6.25-rc8-mm1/arch/xtensa/platforms/iss/setup.c
--- linux-2.6.25-rc8-mm1.orig/arch/xtensa/platforms/iss/setup.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/arch/xtensa/platforms/iss/setup.c	2008-04-10 21:33:24.422359602 +0900
@@ -98,13 +98,18 @@ iss_panic_event(struct notifier_block *t
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block iss_panic_block = {
+static struct notifier_block iss_panic_block_base = {
 	iss_panic_event,
 	NULL,
 	0
 };
 
+static struct tunable_atomic_notifier_block iss_panic_block = {
+	.nb = &iss_panic_block_base
+};
+
 void __init platform_setup(char **p_cmdline)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &iss_panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					&iss_panic_block, "iss_panic", NULL);
 }
diff -uprN linux-2.6.25-rc8-mm1.orig/drivers/char/ipmi/ipmi_msghandler.c linux-2.6.25-rc8-mm1/drivers/char/ipmi/ipmi_msghandler.c
--- linux-2.6.25-rc8-mm1.orig/drivers/char/ipmi/ipmi_msghandler.c	2008-04-08 16:37:33.228000000 +0900
+++ linux-2.6.25-rc8-mm1/drivers/char/ipmi/ipmi_msghandler.c	2008-04-08 16:32:35.240000000 +0900
@@ -4235,12 +4235,16 @@ static int panic_event(struct notifier_b
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call	= panic_event,
 	.next		= NULL,
 	.priority	= 200	/* priority: INT_MAX >= x >= 0 */
 };
 
+static struct tunable_atomic_notifier_block panic_block = {
+	.nb		= &panic_block_base
+};
+
 static int ipmi_init_msghandler(void)
 {
 	int rv;
@@ -4270,7 +4274,8 @@ static int ipmi_init_msghandler(void)
 	setup_timer(&ipmi_timer, ipmi_timeout, 0);
 	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
 
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					&panic_block, "ipmi_msghandler", NULL);
 
 	initialized = 1;
 
@@ -4290,7 +4295,8 @@ static __exit void cleanup_ipmi(void)
 	if (!initialized)
 		return;
 
-	atomic_notifier_chain_unregister(&panic_notifier_list, &panic_block);
+	tunable_atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &panic_block);
 
 	/*
 	 * This can't be called if any interfaces exist, so no worry
diff -uprN linux-2.6.25-rc8-mm1.orig/drivers/char/ipmi/ipmi_watchdog.c linux-2.6.25-rc8-mm1/drivers/char/ipmi/ipmi_watchdog.c
--- linux-2.6.25-rc8-mm1.orig/drivers/char/ipmi/ipmi_watchdog.c	2008-04-08 16:37:33.240000000 +0900
+++ linux-2.6.25-rc8-mm1/drivers/char/ipmi/ipmi_watchdog.c	2008-04-08 16:32:35.240000000 +0900
@@ -1157,12 +1157,15 @@ static int wdog_panic_handler(struct not
 	return NOTIFY_OK;
 }
 
-static struct notifier_block wdog_panic_notifier = {
+static struct notifier_block wdog_panic_notifier_base = {
 	.notifier_call	= wdog_panic_handler,
 	.next		= NULL,
 	.priority	= 150	/* priority: INT_MAX >= x >= 0 */
 };
 
+static struct tunable_atomic_notifier_block wdog_panic_notifier = {
+	.nb		= &wdog_panic_notifier_base
+};
 
 static void ipmi_new_smi(int if_num, struct device *device)
 {
@@ -1302,8 +1305,8 @@ static int __init ipmi_wdog_init(void)
 	check_parms();
 
 	register_reboot_notifier(&wdog_reboot_notifier);
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&wdog_panic_notifier);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+				&wdog_panic_notifier, "ipmi_wdog", NULL);
 
 	rv = ipmi_smi_watcher_register(&smi_watcher);
 	if (rv) {
@@ -1311,8 +1314,8 @@ static int __init ipmi_wdog_init(void)
 		if (nmi_handler_registered)
 			unregister_die_notifier(&ipmi_nmi_handler);
 #endif
-		atomic_notifier_chain_unregister(&panic_notifier_list,
-						 &wdog_panic_notifier);
+		tunable_atomic_notifier_chain_unregister(&panic_notifier_list,
+						 	 &wdog_panic_notifier);
 		unregister_reboot_notifier(&wdog_reboot_notifier);
 		printk(KERN_WARNING PFX "can't register smi watcher\n");
 		return rv;
@@ -1333,8 +1336,8 @@ static void __exit ipmi_wdog_exit(void)
 		unregister_die_notifier(&ipmi_nmi_handler);
 #endif
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &wdog_panic_notifier);
+	tunable_atomic_notifier_chain_unregister(&panic_notifier_list,
+					 	 &wdog_panic_notifier);
 	unregister_reboot_notifier(&wdog_reboot_notifier);
 }
 module_exit(ipmi_wdog_exit);
diff -uprN linux-2.6.25-rc8-mm1.orig/drivers/misc/ibmasm/heartbeat.c linux-2.6.25-rc8-mm1/drivers/misc/ibmasm/heartbeat.c
--- linux-2.6.25-rc8-mm1.orig/drivers/misc/ibmasm/heartbeat.c	2008-04-08 16:37:35.952000000 +0900
+++ linux-2.6.25-rc8-mm1/drivers/misc/ibmasm/heartbeat.c	2008-04-10 21:34:19.254011678 +0900
@@ -48,17 +48,22 @@ static int panic_happened(struct notifie
 	return 0;
 }
 
-static struct notifier_block panic_notifier = { panic_happened, NULL, 1 };
+static struct notifier_block panic_notifier_base = { panic_happened, NULL, 1 };
+
+static struct tunable_atomic_notifier_block panic_notifier = { 
+	.nb = &panic_notifier_base
+};
 
 void ibmasm_register_panic_notifier(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_notifier);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					       &panic_notifier, "ibmasm", NULL);
 }
 
 void ibmasm_unregister_panic_notifier(void)
 {
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-			&panic_notifier);
+	tunable_atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &panic_notifier);
 }
 
 
diff -uprN linux-2.6.25-rc8-mm1.orig/drivers/parisc/power.c linux-2.6.25-rc8-mm1/drivers/parisc/power.c
--- linux-2.6.25-rc8-mm1.orig/drivers/parisc/power.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/drivers/parisc/power.c	2008-04-10 21:34:44.089854095 +0900
@@ -189,11 +189,14 @@ static int parisc_panic_event(struct not
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block parisc_panic_block = {
+static struct notifier_block parisc_panic_block_base = {
 	.notifier_call	= parisc_panic_event,
 	.priority	= INT_MAX,
 };
 
+static struct tunable_atomic_notifier_block parisc_panic_block = {
+	.nb		= &parisc_panic_block_base
+};
 
 static int __init power_init(void)
 {
@@ -231,8 +234,8 @@ static int __init power_init(void)
 	}
 
 	/* Register a call for panic conditions. */
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&parisc_panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+				&parisc_panic_block, "parisc_panic", NULL);
 
 	return 0;
 }
@@ -241,8 +244,8 @@ static void __exit power_exit(void)
 {
 	kthread_stop(power_task);
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-			&parisc_panic_block);
+	tunable_atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &parisc_panic_block);
 
 	pdc_soft_power_button(0);
 }
diff -uprN linux-2.6.25-rc8-mm1.orig/include/linux/kernel.h linux-2.6.25-rc8-mm1/include/linux/kernel.h
--- linux-2.6.25-rc8-mm1.orig/include/linux/kernel.h	2008-04-08 16:37:43.508000000 +0900
+++ linux-2.6.25-rc8-mm1/include/linux/kernel.h	2008-04-08 16:32:35.244000000 +0900
@@ -129,7 +129,7 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-extern struct atomic_notifier_head panic_notifier_list;
+extern struct tunable_atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
diff -uprN linux-2.6.25-rc8-mm1.orig/kernel/panic.c linux-2.6.25-rc8-mm1/kernel/panic.c
--- linux-2.6.25-rc8-mm1.orig/kernel/panic.c	2008-04-08 16:37:44.916000000 +0900
+++ linux-2.6.25-rc8-mm1/kernel/panic.c	2008-04-08 16:32:35.248000000 +0900
@@ -30,7 +30,7 @@ static DEFINE_SPINLOCK(pause_on_oops_loc
 
 int panic_timeout;
 
-ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
+TUNABLE_ATOMIC_NOTIFIER_HEAD(panic_notifier_list, "panic_notifier_list");
 
 EXPORT_SYMBOL(panic_notifier_list);
 
@@ -98,7 +98,7 @@ NORET_TYPE void panic(const char * fmt, 
 	smp_send_stop();
 #endif
 
-	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
+	tunable_atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
 	if (!panic_blink)
 		panic_blink = no_blink;
diff -uprN linux-2.6.25-rc8-mm1.orig/kernel/softlockup.c linux-2.6.25-rc8-mm1/kernel/softlockup.c
--- linux-2.6.25-rc8-mm1.orig/kernel/softlockup.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/kernel/softlockup.c	2008-04-08 16:32:35.248000000 +0900
@@ -35,8 +35,12 @@ softlock_panic(struct notifier_block *th
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block panic_block = {
-	.notifier_call = softlock_panic,
+static struct notifier_block panic_block_base = {
+	.notifier_call = softlock_panic
+};
+
+static struct tunable_atomic_notifier_block panic_block = {
+	.nb		= &panic_block_base
 };
 
 /*
@@ -310,5 +314,6 @@ __init void spawn_softlockup_task(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_atomic_notifier_chain_register(&panic_notifier_list,
+					&panic_block, "softlockup", NULL);
 }

