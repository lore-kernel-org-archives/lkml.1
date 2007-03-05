Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXCEKPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXCEKPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbXCEKPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:15:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45672 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbXCEKP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:15:28 -0500
Date: Mon, 5 Mar 2007 11:05:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] KVM: T60 resume fix
Message-ID: <20070305100537.GA9175@elte.hu>
References: <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <45E93012.4000100@qumranet.com> <20070305082251.GA23366@elte.hu> <45EBD9BC.4030801@qumranet.com> <20070305084449.GA1706@elte.hu> <20070305085718.GA2513@elte.hu> <45EBE288.8010101@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EBE288.8010101@qumranet.com>
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

* Avi Kivity <avi@qumranet.com> wrote:

> > suspend/resume works fine now and there are no warning messages 
> > whatsoever (with suspend simulation). Thanks Avi!
> 
> Where do I find this suspend simulation?  Sounds like a great suspend 
> debugging tool.

it's just the simple hack below.

	Ingo

------------------------>
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
+extern int acpi_simulate_suspend_to_ram;
 
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
