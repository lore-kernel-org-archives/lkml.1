Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbXCEIWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbXCEIWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXCEIWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:22:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbXCEIWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:22:35 -0500
Date: Mon, 5 Mar 2007 09:14:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: macbook pro suspend to ram broken in linux-2.6.git HEAD
Message-ID: <20070305081432.GB19838@elte.hu>
References: <1173033049.4094.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173033049.4094.13.camel@localhost>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Soeren Sonnenburg <kernel@nn7.de> wrote:

> a rather long git bisect session between v2.6.20 and HEAD identified 
> the commit below this as the cause. please note that the machine does 
> not return from resume and although all PM debug was turned on there 
> is nothing in the logs. happens with a minimalistic setup (console 
> only no audio/network etc) without SMP and CONFIG_HPET_TIMER but 
> PREEMPT on

good. Could you apply the patch below, enable CONFIG_PM_DEBUG and 
CONFIG_PM_TRACE and CONFIG_DISABLE_CONSOLE_SUSPEND, boot into the new 
kernel and do:

	echo 1 > /proc/sys/kernel/acpi_simulate_suspend_to_ram
	echo mem > /sys/power/state

and if the system still works after this point, could you send us the 
resulting dmesg? Or if it crashes, hopefully the crash should be right 
on the screen - how does it look like?

the above sequence should generate a 'fake' suspend-to-ram: it will 
execute the overwhelming majority of code that is done during 
suspend/resume, but without actually suspending the box. Hopefully this 
still triggers the bug and if it triggers, the system produces some 
useful output.

	Ingo

--------------->
Subject: [patch] suspend debugging: simulate suspend-to-RAM
From: Ingo Molnar <mingo@elte.hu>

most resume bugs are due to the kernel hanging or crashing while trying 
to resume a specific device. It is extremely hard to debug such hangs 
because often when the hang happens there's no console available yet.

Make debugging such bugs easier by offering a resume mode that does not 
actually call into the BIOS to turn off the machine. This, in 
combination with earlyprintk=serial,ttyS0,115200,keep , 
CONFIG_PM_DEBUG=y, CONFIG_DISABLE_CONSOLE_SUSPEND=y and 
/sys/power/filter enables me to have a fully functional serial console 
during the full suspend/resume cycle.

I debugged two suspend bugs in the -rt kernel this way already, so it's 
pretty useful.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    4 ++++
 drivers/acpi/sleep/main.c           |   15 ++++++++++++++-
 include/linux/acpi.h                |    1 +
 kernel/sysctl.c                     |    8 ++++++++
 4 files changed, 27 insertions(+), 1 deletion(-)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -163,6 +163,10 @@ and is between 256 and 4096 characters. 
 
 	acpi_osi=	[HW,ACPI] empty param disables _OSI
 
+	acpi_simulate_suspend_to_ram
+			[KNL] Do not call into BIOS to do suspend-to-RAM
+			Format: <0/1>
+
 	acpi_serialize	[HW,ACPI] force serialization of AML methods
 
 	acpi_skip_timer_override [HW,ACPI]
Index: linux/drivers/acpi/sleep/main.c
===================================================================
--- linux.orig/drivers/acpi/sleep/main.c
+++ linux/drivers/acpi/sleep/main.c
@@ -35,6 +35,14 @@ static u32 acpi_suspend_states[] = {
 
 static int init_8259A_after_S1;
 
+/*
+ * simulate entry into the BIOS - this way the system will not
+ * be turned off for real, and the kernel's resume functionality
+ * can be debugged while still having some system capabilities
+ * left. This is especially useful in combination with /sys/power/filter.
+ */
+int acpi_simulate_suspend_to_ram;
+
 /**
  *	acpi_pm_prepare - Do preliminary suspend work.
  *	@pm_state:		suspend state we're entering.
@@ -91,7 +99,12 @@ static int acpi_pm_enter(suspend_state_t
 		break;
 
 	case PM_SUSPEND_MEM:
-		do_suspend_lowlevel();
+		if (unlikely(acpi_simulate_suspend_to_ram)) {
+			printk(KERN_INFO "ACPI: simulating suspend-to-RAM: "
+					 "not calling BIOS.\n");
+		} else {
+			do_suspend_lowlevel();
+		}
 		break;
 
 	case PM_SUSPEND_DISK:
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -123,6 +123,7 @@ extern int pci_mmcfg_config_num;
 
 extern int sbf_port;
 extern unsigned long acpi_video_flags;
+extern int acpi_simulate_suspend_to_ram = 1;
 
 #else	/* !CONFIG_ACPI */
 
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -581,6 +581,14 @@ static ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "acpi_simulate_suspend_to_ram",
+		.data		= &acpi_simulate_suspend_to_ram,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 #ifdef CONFIG_IA64
 	{
