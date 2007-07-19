Return-Path: <linux-kernel-owner+w=401wt.eu-S936572AbXGSFln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936572AbXGSFln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 01:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXGSFle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 01:41:34 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:40086 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbXGSFld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 01:41:33 -0400
Date: Wed, 18 Jul 2007 22:41:21 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, shai@scalex86.org, mingo@elte.hu
Subject: Re: [patch] Change softlockup trigger limit using a kernel parameter
Message-ID: <20070719054121.GA15074@localdomain>
References: <20070716222650.GA5947@localdomain> <20070718160858.75865461.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718160858.75865461.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 04:08:58PM -0700, Andrew Morton wrote:
> On Mon, 16 Jul 2007 15:26:50 -0700
> Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
> > Kernel warns of softlockups if the softlockup thread is not able to run
> > on a CPU for 10s.  It is useful to lower the softlockup warning
> > threshold in testing environments to catch potential lockups early.
> > Following patch adds a kernel parameter 'softlockup_lim' to control
> > the softlockup threshold.
> >
>
> Why not make it tunable at runtime?

Sure! Like a sysctl?

Here's a patch that does that (On top of Ingo's
softlockup-improve-debug-output.patch)

>
> >
> > Control the trigger limit for softlockup warnings.  This is useful for
> > debugging softlockups, by lowering the softlockup_lim to identify
> > possible softlockups earlier.
>
> Please check your patches with scripts/checkpatch.pl.

Yep will-do.
(checkpatch emitted one warning for the patch below, but that was because
of a 'stylo' that already exists in include/linux/sysctl.h -- which probably
needs a style change patch by itself)

---

Control the trigger limit for softlockup warnings.  This is useful for
debugging softlockups, by lowering the softlockup_thresh sysctl,
to identify possible softlockups earlier.

Patch also changes the softlockup printk to print the cpu softlockup time.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>

Index: linux-2.6.22/kernel/softlockup.c
===================================================================
--- linux-2.6.22.orig/kernel/softlockup.c	2007-07-18 11:15:18.506614500 -0700
+++ linux-2.6.22/kernel/softlockup.c	2007-07-18 21:39:20.498592750 -0700
@@ -23,6 +23,7 @@ static DEFINE_PER_CPU(unsigned long, pri
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int did_panic;
+int softlockup_thresh = 10;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -101,7 +102,7 @@ void softlockup_tick(void)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (now <= (touch_timestamp + 10))
+	if (now <= (touch_timestamp + softlockup_thresh))
 		return;
 
 	regs = get_irq_regs();
@@ -109,8 +110,9 @@ void softlockup_tick(void)
 	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
 	spin_lock(&print_lock);
-	printk(KERN_ERR "BUG: soft lockup detected on CPU#%d! [%s:%d]\n",
-			this_cpu, current->comm, current->pid);
+	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
+			this_cpu, now - touch_timestamp,
+				current->comm, current->pid);
 	if (regs)
 		show_regs(regs);
 	else
Index: linux-2.6.22/kernel/sysctl.c
===================================================================
--- linux-2.6.22.orig/kernel/sysctl.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/kernel/sysctl.c	2007-07-18 21:05:57.877436750 -0700
@@ -78,6 +78,7 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
 extern int sysctl_stat_interval;
+extern int softlockup_thresh;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -206,6 +207,10 @@ static ctl_table root_table[] = {
 	{ .ctl_name = 0 }
 };
 
+/* Constants for kernel table minimum and  maximum */
+static int one = 1;
+static int ten = 10;
+
 static ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_PANIC,
@@ -615,6 +620,19 @@ static ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+	{
+		.ctl_name	= KERN_SOFTLOCKUP_THRESHOLD,
+		.procname	= "softlockup_thresh",
+		.data		= &softlockup_thresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &ten,
+	},
+#endif
 
 	{ .ctl_name = 0 }
 };
Index: linux-2.6.22/include/linux/sysctl.h
===================================================================
--- linux-2.6.22.orig/include/linux/sysctl.h	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/include/linux/sysctl.h	2007-07-18 21:41:56.584347500 -0700
@@ -165,6 +165,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_SOFTLOCKUP_THRESHOLD=77, /* int: softlockup tolerance threshold */
 };
 
 
Index: linux-2.6.22/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.22.orig/Documentation/sysctl/kernel.txt	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/Documentation/sysctl/kernel.txt	2007-07-18 22:07:29.460146250 -0700
@@ -320,6 +320,14 @@ kernel.  This value defaults to SHMMAX.
 
 ==============================================================
 
+softlockup_thresh:
+
+This value can be used to lower the softlockup tolerance
+threshold. The default threshold is 10s.  If a cpu is locked up
+for 10s, the kernel complains.  Valid values are 1-10s.
+
+==============================================================
+
 tainted: 
 
 Non-zero if the kernel has been tainted.  Numeric values, which
