Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbXJDLoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbXJDLoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761546AbXJDLla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:41:30 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35224 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761267AbXJDLl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:41:26 -0400
Message-ID: <4704D0CA.4080001@ah.jp.nec.com>
Date: Thu, 04 Oct 2007 20:38:50 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: vgoyal@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: [PATCH 2/2] implement new notifier function to panic_notifier_list
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements new notifier function to panic_notifier_list. We can
change the list of order by debugfs.

Thanks,

---

Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>

---
diff -uprN linux-2.6.23-rc9.orig/arch/alpha/kernel/setup.c
linux-2.6.23-rc9/arch/alpha/kernel/setup.c
--- linux-2.6.23-rc9.orig/arch/alpha/kernel/setup.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/alpha/kernel/setup.c	2007-10-04 09:49:34.440000000 +0900
@@ -45,14 +45,22 @@
 #include <asm/io.h>
 #include <linux/log2.h>

-extern struct atomic_notifier_head panic_notifier_list;
+extern struct tunable_notifier_head panic_notifier_list;
 static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
-static struct notifier_block alpha_panic_block = {
+static struct notifier_block alpha_panic_block_base = {
 	alpha_panic_event,
         NULL,
         INT_MAX /* try to do it first */
 };

+static struct tunable_notifier_block alpha_panic_block = {
+	&alpha_panic_block_base,
+	NULL,
+	NULL,
+	NULL,
+	NULL
+};
+
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -522,8 +530,8 @@ setup_arch(char **cmdline_p)
 	}

 	/* Register a call for panic conditions. */
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&alpha_panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list,
+			&alpha_panic_block, "alpha_panic", NULL);

 #ifdef CONFIG_ALPHA_GENERIC
 	/* Assume that we've booted from SRM if we haven't booted from MILO.
diff -uprN linux-2.6.23-rc9.orig/arch/arm/mach-omap1/board-voiceblue.c
linux-2.6.23-rc9/arch/arm/mach-omap1/board-voiceblue.c
--- linux-2.6.23-rc9.orig/arch/arm/mach-omap1/board-voiceblue.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/arm/mach-omap1/board-voiceblue.c	2007-10-04
09:53:17.008000000 +0900
@@ -228,14 +228,23 @@ static int panic_event(struct notifier_b
 	return NOTIFY_DONE;
 }

-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call	= panic_event,
 };

+static struct tunable_notifier_block panic_block = {
+	.nb		= &panic_block_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 static int __init voiceblue_setup(void)
 {
 	/* Setup panic notifier */
-	notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list, &panic_block,
+						"VoiceBlue", NULL);

 	return 0;
 }
diff -uprN linux-2.6.23-rc9.orig/arch/mips/sgi-ip22/ip22-reset.c
linux-2.6.23-rc9/arch/mips/sgi-ip22/ip22-reset.c
--- linux-2.6.23-rc9.orig/arch/mips/sgi-ip22/ip22-reset.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/mips/sgi-ip22/ip22-reset.c	2007-10-04
10:04:51.752000000 +0900
@@ -226,10 +226,18 @@ static int panic_event(struct notifier_b
 	return NOTIFY_DONE;
 }

-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call	= panic_event,
 };

+static struct tunable_notifier_block panic_block = {
+	.nb		= &panic_block_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 static int __init reboot_setup(void)
 {
 	_machine_restart = sgi_machine_restart;
@@ -239,7 +247,8 @@ static int __init reboot_setup(void)
 	request_irq(SGI_PANEL_IRQ, panel_int, 0, "Front Panel", NULL);
 	init_timer(&blink_timer);
 	blink_timer.function = blink_timeout;
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list, &panic_block,
+						"sgi-ip22", NULL);

 	return 0;
 }
diff -uprN linux-2.6.23-rc9.orig/arch/mips/sgi-ip32/ip32-reset.c
linux-2.6.23-rc9/arch/mips/sgi-ip32/ip32-reset.c
--- linux-2.6.23-rc9.orig/arch/mips/sgi-ip32/ip32-reset.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/mips/sgi-ip32/ip32-reset.c	2007-10-04
10:04:32.988000000 +0900
@@ -175,10 +175,18 @@ static int panic_event(struct notifier_b
 	return NOTIFY_DONE;
 }

-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call = panic_event,
 };

+static struct tunable_notifier_block panic_block = {
+	.nb		= &panic_block_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 static __init int ip32_reboot_setup(void)
 {
 	/* turn on the green led only */
@@ -193,7 +201,8 @@ static __init int ip32_reboot_setup(void

 	init_timer(&blink_timer);
 	blink_timer.function = blink_timeout;
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list, &panic_block,
+						"sgi-ip32", NULL);

 	if (request_irq(MACEISA_RTC_IRQ, ip32_rtc_int, 0, "rtc", NULL))
 		panic("Can't allocate MACEISA RTC IRQ");
diff -uprN linux-2.6.23-rc9.orig/arch/parisc/kernel/pdc_chassis.c
linux-2.6.23-rc9/arch/parisc/kernel/pdc_chassis.c
--- linux-2.6.23-rc9.orig/arch/parisc/kernel/pdc_chassis.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/parisc/kernel/pdc_chassis.c	2007-10-04
10:03:22.624000000 +0900
@@ -101,11 +101,18 @@ static int pdc_chassis_panic_event(struc
 }


-static struct notifier_block pdc_chassis_panic_block = {
+static struct notifier_block pdc_chassis_panic_block_base = {
 	.notifier_call = pdc_chassis_panic_event,
 	.priority = INT_MAX,
 };

+static struct tunable_notifier_block pdc_chassis_panic_block = {
+	.nb		= &pdc_chassis_panic_block_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};

 /**
  * parisc_reboot_event() - Called by the reboot handler.
@@ -144,8 +151,8 @@ void __init parisc_pdc_chassis_init(void
 				PDC_CHASSIS_VER);

 		/* initialize panic notifier chain */
-		atomic_notifier_chain_register(&panic_notifier_list,
-				&pdc_chassis_panic_block);
+		tunable_notifier_chain_register(&panic_notifier_list,
+				&pdc_chassis_panic_block, "pdc_chassis", NULL);

 		/* initialize reboot notifier chain */
 		register_reboot_notifier(&pdc_chassis_reboot_block);
diff -uprN linux-2.6.23-rc9.orig/arch/powerpc/kernel/setup-common.c
linux-2.6.23-rc9/arch/powerpc/kernel/setup-common.c
--- linux-2.6.23-rc9.orig/arch/powerpc/kernel/setup-common.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/powerpc/kernel/setup-common.c	2007-10-04
10:12:59.352000000 +0900
@@ -534,14 +534,23 @@ static int ppc_panic_event(struct notifi
 	return NOTIFY_DONE;
 }

-static struct notifier_block ppc_panic_block = {
+static struct notifier_block ppc_panic_block_base = {
 	.notifier_call = ppc_panic_event,
 	.priority = INT_MIN /* may not return; must be done last */
 };

+static struct tunable_notifier_block ppc_panic_block = {
+	.nb		= &ppc_panic_block_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 void __init setup_panic(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &ppc_panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list, &ppc_panic_block,
+						"powerpc", NULL);
 }

 #ifdef CONFIG_CHECK_CACHE_COHERENCY
diff -uprN linux-2.6.23-rc9.orig/arch/ppc/platforms/prep_setup.c
linux-2.6.23-rc9/arch/ppc/platforms/prep_setup.c
--- linux-2.6.23-rc9.orig/arch/ppc/platforms/prep_setup.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/ppc/platforms/prep_setup.c	2007-10-04
13:33:55.108000000 +0900
@@ -712,12 +712,20 @@ ibm_statusled_panic(struct notifier_bloc
 	return NOTIFY_DONE;
 }

-static struct notifier_block ibm_statusled_block = {
+static struct notifier_block ibm_statusled_block_base = {
 	ibm_statusled_panic,
 	NULL,
 	INT_MAX /* try to do it first */
 };

+static struct tunable_notifier_block ibm_statusled_block = {
+	&ibm_statusled_block_base,
+	NULL,
+	NULL,
+	NULL,
+	NULL
+};
+
 static void
 ibm_statusled_progress(char *s, unsigned short hex)
 {
@@ -732,8 +740,8 @@ ibm_statusled_progress(char *s, unsigned
 		hex = 0xfff;
 		if (!notifier_installed) {
 			++notifier_installed;
-			atomic_notifier_chain_register(&panic_notifier_list,
-						&ibm_statusled_block);
+			tunable_notifier_chain_register(&panic_notifier_list,
+				&ibm_statusled_block, "IBM_statusLED", NULL);
 		}
 	}
 	else
diff -uprN linux-2.6.23-rc9.orig/arch/s390/kernel/ipl.c
linux-2.6.23-rc9/arch/s390/kernel/ipl.c
--- linux-2.6.23-rc9.orig/arch/s390/kernel/ipl.c	2007-10-02 12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/s390/kernel/ipl.c	2007-10-04 13:33:45.216000000 +0900
@@ -1036,11 +1036,19 @@ static int shutdown_on_panic_notify(stru
 	return NOTIFY_OK;
 }

-static struct notifier_block shutdown_on_panic_nb = {
+static struct notifier_block shutdown_on_panic_nb_base = {
 	.notifier_call = shutdown_on_panic_notify,
 	.priority = SHUTDOWN_ON_PANIC_PRIO
 };

+static struct tunable_notifier_block shutdown_on_panic_nb = {
+	.nb		= &shutdown_on_panic_nb_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 static int __init dump_init(void)
 {
 	int rc;
@@ -1075,8 +1083,8 @@ static int __init shutdown_actions_init(
 		firmware_unregister(&shutdown_actions_subsys);
 		return rc;
 	}
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &shutdown_on_panic_nb);
+	tunable_notifier_chain_register(&panic_notifier_list,
+				       &shutdown_on_panic_nb, "s390_ipl", NULL);
 	return 0;
 }

diff -uprN linux-2.6.23-rc9.orig/arch/s390/kernel/setup.c
linux-2.6.23-rc9/arch/s390/kernel/setup.c
--- linux-2.6.23-rc9.orig/arch/s390/kernel/setup.c	2007-10-02 12:24:52.000000000
+0900
+++ linux-2.6.23-rc9/arch/s390/kernel/setup.c	2007-10-04 13:36:51.792000000 +0900
@@ -173,11 +173,19 @@ static int vmpanic_notify(struct notifie

 #define PANIC_PRI_VMPANIC	0

-static struct notifier_block vmpanic_nb = {
+static struct notifier_block vmpanic_nb_base = {
 	.notifier_call = vmpanic_notify,
 	.priority = PANIC_PRI_VMPANIC
 };

+static struct tunable_notifier_block  vmpanic_nb = {
+	.nb		= &vmpanic_nb_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 static int __init vmpanic_setup(char *str)
 {
 	static int register_done __initdata = 0;
@@ -186,8 +194,8 @@ static int __init vmpanic_setup(char *st
 	vmpanic_cmd[127] = 0;
 	if (!register_done) {
 		register_done = 1;
-		atomic_notifier_chain_register(&panic_notifier_list,
-					       &vmpanic_nb);
+		tunable_notifier_chain_register(&panic_notifier_list,
+					&vmpanic_nb, "s390_panic", NULL);
 	}
 	return 1;
 }
diff -uprN linux-2.6.23-rc9.orig/arch/sparc64/kernel/sstate.c
linux-2.6.23-rc9/arch/sparc64/kernel/sstate.c
--- linux-2.6.23-rc9.orig/arch/sparc64/kernel/sstate.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/sparc64/kernel/sstate.c	2007-10-04 13:39:06.692000000
+0900
@@ -82,11 +82,19 @@ static int sstate_panic_event(struct not
 	return NOTIFY_DONE;
 }

-static struct notifier_block sstate_panic_block = {
+static struct notifier_block sstate_panic_block_base = {
 	.notifier_call	=	sstate_panic_event,
 	.priority	=	INT_MAX,
 };

+static struct tunable_notifier_block sstate_panic_block = {
+	.nb		=	&sstate_panic_block_base,
+	.head		=	NULL,
+	.dir		=	NULL,
+	.pri_dentry	=	NULL,
+	.desc_dentry	=	NULL
+};
+
 void __init sun4v_sstate_init(void)
 {
 	unsigned long major, minor;
@@ -99,6 +107,6 @@ void __init sun4v_sstate_init(void)
 	hv_supports_soft_state = 1;

 	prom_sun4v_guest_soft_state();
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &sstate_panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list,
+				&sstate_panic_block, "sstate" ,NULL);
 }
diff -uprN linux-2.6.23-rc9.orig/arch/um/drivers/mconsole_kern.c
linux-2.6.23-rc9/arch/um/drivers/mconsole_kern.c
--- linux-2.6.23-rc9.orig/arch/um/drivers/mconsole_kern.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/um/drivers/mconsole_kern.c	2007-10-04
15:30:04.784000000 +0900
@@ -928,16 +928,24 @@ static int notify_panic(struct notifier_
 	return(0);
 }

-static struct notifier_block panic_exit_notifier = {
+static struct notifier_block panic_exit_notifier_base = {
 	.notifier_call 		= notify_panic,
 	.next 			= NULL,
 	.priority 		= 1
 };

+static struct tunable_notifier_block panic_exit_notifier = {
+	.nb			= &panic_exit_notifier_base,
+	.head			= NULL,
+	.dir			= NULL,
+	.pri_dentry		= NULL,
+	.desc_dentry		= NULL
+};
+
 static int add_notifier(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&panic_exit_notifier);
+	tunable_notifier_chain_register(&panic_notifier_list,
+			&panic_exit_notifier, "mconsole", NULL);
 	return(0);
 }

diff -uprN linux-2.6.23-rc9.orig/arch/um/kernel/um_arch.c
linux-2.6.23-rc9/arch/um/kernel/um_arch.c
--- linux-2.6.23-rc9.orig/arch/um/kernel/um_arch.c	2007-10-02 12:24:52.000000000
+0900
+++ linux-2.6.23-rc9/arch/um/kernel/um_arch.c	2007-10-04 13:42:53.880000000 +0900
@@ -478,16 +478,24 @@ static int panic_exit(struct notifier_bl
 	return 0;
 }

-static struct notifier_block panic_exit_notifier = {
+static struct notifier_block panic_exit_notifier_base = {
 	.notifier_call 		= panic_exit,
 	.next 			= NULL,
 	.priority 		= 0
 };

+static struct tunable_notifier_block panic_exit_notifier = {
+	.nb			= &panic_exit_notifier_base,
+	.head			= NULL,
+	.dir			= NULL,
+	.pri_dentry		= NULL,
+	.desc_dentry		= NULL
+};
+
 void __init setup_arch(char **cmdline_p)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&panic_exit_notifier);
+	tunable_notifier_chain_register(&panic_notifier_list,
+			&panic_exit_notifier, "um", NULL);
 	paging_init();
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
diff -uprN linux-2.6.23-rc9.orig/arch/xtensa/platform-iss/setup.c
linux-2.6.23-rc9/arch/xtensa/platform-iss/setup.c
--- linux-2.6.23-rc9.orig/arch/xtensa/platform-iss/setup.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/arch/xtensa/platform-iss/setup.c	2007-10-04
13:44:52.032000000 +0900
@@ -98,13 +98,22 @@ iss_panic_event(struct notifier_block *t
 	return NOTIFY_DONE;
 }

-static struct notifier_block iss_panic_block = {
+static struct notifier_block iss_panic_block_base = {
 	iss_panic_event,
 	NULL,
 	0
 };

+static struct tunable_notifier_block iss_panic_block = {
+	&iss_panic_block_base,
+	NULL,
+	NULL,
+	NULL,
+	NULL
+};
+
 void __init platform_setup(char **p_cmdline)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &iss_panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list, &iss_panic_block,
+						"iss_panic", NULL);
 }
diff -uprN linux-2.6.23-rc9.orig/drivers/char/ipmi/ipmi_msghandler.c
linux-2.6.23-rc9/drivers/char/ipmi/ipmi_msghandler.c
--- linux-2.6.23-rc9.orig/drivers/char/ipmi/ipmi_msghandler.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/drivers/char/ipmi/ipmi_msghandler.c	2007-10-04
09:46:25.780000000 +0900
@@ -4070,12 +4070,20 @@ static int panic_event(struct notifier_b
 	return NOTIFY_DONE;
 }

-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call	= panic_event,
 	.next		= NULL,
 	.priority	= 200	/* priority: INT_MAX >= x >= 0 */
 };

+static struct tunable_notifier_block panic_block = {
+	.nb		= &panic_block_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 static int ipmi_init_msghandler(void)
 {
 	int rv;
@@ -4105,7 +4113,8 @@ static int ipmi_init_msghandler(void)
 	setup_timer(&ipmi_timer, ipmi_timeout, 0);
 	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);

-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list, &panic_block,
+					"ipmi_msghandler", NULL);

 	initialized = 1;

@@ -4125,7 +4134,7 @@ static __exit void cleanup_ipmi(void)
 	if (!initialized)
 		return;

-	atomic_notifier_chain_unregister(&panic_notifier_list, &panic_block);
+	tunable_notifier_chain_unregister(&panic_notifier_list, &panic_block);

 	/* This can't be called if any interfaces exist, so no worry about
 	   shutting down the interfaces. */
diff -uprN linux-2.6.23-rc9.orig/drivers/char/ipmi/ipmi_watchdog.c
linux-2.6.23-rc9/drivers/char/ipmi/ipmi_watchdog.c
--- linux-2.6.23-rc9.orig/drivers/char/ipmi/ipmi_watchdog.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/drivers/char/ipmi/ipmi_watchdog.c	2007-10-04
09:46:25.780000000 +0900
@@ -1055,12 +1055,19 @@ static int wdog_panic_handler(struct not
 	return NOTIFY_OK;
 }

-static struct notifier_block wdog_panic_notifier = {
+static struct notifier_block wdog_panic_notifier_base = {
 	.notifier_call	= wdog_panic_handler,
 	.next		= NULL,
 	.priority	= 150	/* priority: INT_MAX >= x >= 0 */
 };

+static struct tunable_notifier_block wdog_panic_notifier = {
+	.nb		= &wdog_panic_notifier_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};

 static void ipmi_new_smi(int if_num, struct device *device)
 {
@@ -1212,8 +1219,8 @@ static int __init ipmi_wdog_init(void)
 	check_parms();

 	register_reboot_notifier(&wdog_reboot_notifier);
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&wdog_panic_notifier);
+	tunable_notifier_chain_register(&panic_notifier_list,
+			&wdog_panic_notifier, "ipmi_wdog", NULL);

 	rv = ipmi_smi_watcher_register(&smi_watcher);
 	if (rv) {
@@ -1221,7 +1228,7 @@ static int __init ipmi_wdog_init(void)
 		if (preaction_val == WDOG_PRETIMEOUT_NMI)
 			release_nmi(&ipmi_nmi_handler);
 #endif
-		atomic_notifier_chain_unregister(&panic_notifier_list,
+		tunable_notifier_chain_unregister(&panic_notifier_list,
 						 &wdog_panic_notifier);
 		unregister_reboot_notifier(&wdog_reboot_notifier);
 		printk(KERN_WARNING PFX "can't register smi watcher\n");
@@ -1243,7 +1250,7 @@ static void __exit ipmi_wdog_exit(void)
 		release_nmi(&ipmi_nmi_handler);
 #endif

-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	tunable_notifier_chain_unregister(&panic_notifier_list,
 					 &wdog_panic_notifier);
 	unregister_reboot_notifier(&wdog_reboot_notifier);
 }
diff -uprN linux-2.6.23-rc9.orig/drivers/lguest/lguest.c
linux-2.6.23-rc9/drivers/lguest/lguest.c
--- linux-2.6.23-rc9.orig/drivers/lguest/lguest.c	2007-10-02 12:24:52.000000000
+0900
+++ linux-2.6.23-rc9/drivers/lguest/lguest.c	2007-10-04 15:32:39.408000000 +0900
@@ -880,16 +880,25 @@ static int lguest_panic(struct notifier_
 	return NOTIFY_DONE;
 }

-static struct notifier_block paniced = {
+static struct notifier_block paniced_base = {
 	.notifier_call = lguest_panic
 };

+static struct tunable_notifier_block paniced = {
+	.nb		= &paniced_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 /* Setting up memory is fairly easy. */
 static __init char *lguest_memory_setup(void)
 {
 	/* We do this here and not earlier because lockcheck barfs if we do it
 	 * before start_kernel() */
-	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
+	tunable_notifier_chain_register(&panic_notifier_list, &paniced,
+						"lguest", NULL);

 	/* The Linux bootloader header contains an "e820" memory map: the
 	 * Launcher populated the first entry with our memory limit. */
diff -uprN linux-2.6.23-rc9.orig/drivers/misc/ibmasm/heartbeat.c
linux-2.6.23-rc9/drivers/misc/ibmasm/heartbeat.c
--- linux-2.6.23-rc9.orig/drivers/misc/ibmasm/heartbeat.c	2007-10-02
12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/drivers/misc/ibmasm/heartbeat.c	2007-10-04
09:46:25.780000000 +0900
@@ -48,16 +48,20 @@ static int panic_happened(struct notifie
 	return 0;
 }

-static struct notifier_block panic_notifier = { panic_happened, NULL, 1 };
+static struct notifier_block panic_notifier_base = { panic_happened, NULL, 1 };
+
+static struct tunable_notifier_block panic_notifier = { &panic_notifier_base,
+					NULL, NULL, NULL, NULL};

 void ibmasm_register_panic_notifier(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_notifier);
+	tunable_notifier_chain_register(&panic_notifier_list, &panic_notifier,
+					"ibmasm", NULL);
 }

 void ibmasm_unregister_panic_notifier(void)
 {
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	tunable_notifier_chain_unregister(&panic_notifier_list,
 			&panic_notifier);
 }

diff -uprN linux-2.6.23-rc9.orig/drivers/parisc/power.c
linux-2.6.23-rc9/drivers/parisc/power.c
--- linux-2.6.23-rc9.orig/drivers/parisc/power.c	2007-10-02 12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/drivers/parisc/power.c	2007-10-04 09:46:25.780000000 +0900
@@ -189,11 +189,18 @@ static int parisc_panic_event(struct not
 	return NOTIFY_DONE;
 }

-static struct notifier_block parisc_panic_block = {
+static struct notifier_block parisc_panic_block_base = {
 	.notifier_call	= parisc_panic_event,
 	.priority	= INT_MAX,
 };

+static struct tunable_notifier_block parisc_panic_block = {
+	.nb		= &parisc_panic_block_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};

 static int __init power_init(void)
 {
@@ -231,8 +238,8 @@ static int __init power_init(void)
 	}

 	/* Register a call for panic conditions. */
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&parisc_panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list,
+			&parisc_panic_block, "parisc_panic", NULL);

 	return 0;
 }
@@ -241,7 +248,7 @@ static void __exit power_exit(void)
 {
 	kthread_stop(power_task);

-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	tunable_notifier_chain_unregister(&panic_notifier_list,
 			&parisc_panic_block);

 	pdc_soft_power_button(0);
diff -uprN linux-2.6.23-rc9.orig/include/linux/kernel.h
linux-2.6.23-rc9/include/linux/kernel.h
--- linux-2.6.23-rc9.orig/include/linux/kernel.h	2007-10-02 12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/include/linux/kernel.h	2007-10-04 09:46:25.784000000 +0900
@@ -104,7 +104,7 @@ extern int cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})

-extern struct atomic_notifier_head panic_notifier_list;
+extern struct tunable_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
diff -uprN linux-2.6.23-rc9.orig/kernel/panic.c linux-2.6.23-rc9/kernel/panic.c
--- linux-2.6.23-rc9.orig/kernel/panic.c	2007-10-02 12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/kernel/panic.c	2007-10-04 09:46:25.784000000 +0900
@@ -28,7 +28,7 @@ static DEFINE_SPINLOCK(pause_on_oops_loc

 int panic_timeout;

-ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
+TUNABLE_NOTIFIER_HEAD(panic_notifier_list, "panic_notifier_list");

 EXPORT_SYMBOL(panic_notifier_list);

@@ -96,7 +96,7 @@ NORET_TYPE void panic(const char * fmt,
 	smp_send_stop();
 #endif

-	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
+	tunable_notifier_call_chain(&panic_notifier_list, 0, buf);

 	if (!panic_blink)
 		panic_blink = no_blink;
diff -uprN linux-2.6.23-rc9.orig/kernel/softlockup.c
linux-2.6.23-rc9/kernel/softlockup.c
--- linux-2.6.23-rc9.orig/kernel/softlockup.c	2007-10-02 12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/kernel/softlockup.c	2007-10-04 09:46:25.784000000 +0900
@@ -31,10 +31,18 @@ softlock_panic(struct notifier_block *th
 	return NOTIFY_DONE;
 }

-static struct notifier_block panic_block = {
+static struct notifier_block panic_block_base = {
 	.notifier_call = softlock_panic,
 };

+static struct tunable_notifier_block panic_block = {
+	.nb		= &panic_block_base,
+	.head		= NULL,
+	.dir		= NULL,
+	.pri_dentry	= NULL,
+	.desc_dentry	= NULL
+};
+
 /*
  * Returns seconds, approximately.  We don't need nanosecond
  * resolution, and we don't need to waste time with a big divide when
@@ -193,5 +201,6 @@ __init void spawn_softlockup_task(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);

-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	tunable_notifier_chain_register(&panic_notifier_list, &panic_block,
+						"softlookup", NULL);
 }

