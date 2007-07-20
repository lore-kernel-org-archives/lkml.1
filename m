Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbXGTF1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbXGTF1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXGTF1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:27:33 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:40227 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXGTF1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:27:32 -0400
Date: Thu, 19 Jul 2007 22:27:23 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, shai@scalex86.org, mingo@elte.hu
Subject: Re: [patch] Change softlockup trigger limit using a kernel parameter
Message-ID: <20070720052723.GA7737@localdomain>
References: <20070716222650.GA5947@localdomain> <20070718160858.75865461.akpm@linux-foundation.org> <20070719054121.GA15074@localdomain> <20070718230907.741ae56c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718230907.741ae56c.akpm@linux-foundation.org>
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

On Wed, Jul 18, 2007 at 11:09:07PM -0700, Andrew Morton wrote:
>On Wed, 18 Jul 2007 22:41:21 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> On Wed, Jul 18, 2007 at 04:08:58PM -0700, Andrew Morton wrote:
>> > On Mon, 16 Jul 2007 15:26:50 -0700
>> > Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>> >
>> > > Kernel warns of softlockups if the softlockup thread is not able to run
>> > > on a CPU for 10s.  It is useful to lower the softlockup warning
>> > > threshold in testing environments to catch potential lockups early.
>> > > Following patch adds a kernel parameter 'softlockup_lim' to control
>> > > the softlockup threshold.
>> > >
>> >
>> > Why not make it tunable at runtime?
>> 
>> Sure! Like a sysctl?
>> 

Hi Andrew,
Here's another take, incorporating all of your comments.

Thanks,
Kiran


Control the trigger limit for softlockup warnings.  This is useful for
debugging softlockups, by lowering the softlockup_thresh to identify
possible softlockups earlier.

This patch:
1. Adds a sysctl softlockup_thresh with valid values of 1-60s
   (Higher value to disable false positives)
2. Changes the softlockup printk to print the cpu softlockup time

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>

---
Patch applies on top of Ingo's softlockup patches

 Documentation/sysctl/kernel.txt |    8 ++++++++
 include/linux/sched.h           |    1 +
 kernel/softlockup.c             |    8 +++++---
 kernel/sysctl.c                 |   25 +++++++++++++++++++------
 4 files changed, 33 insertions(+), 9 deletions(-)

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
+++ linux-2.6.22/kernel/sysctl.c	2007-07-19 13:42:50.275478000 -0700
@@ -79,6 +79,12 @@ extern int compat_log;
 extern int maps_protect;
 extern int sysctl_stat_interval;
 
+/* Constants used for minimum and  maximum */
+static int one = 1;
+static int zero;
+static int sixty = 60;
+static int one_hundred = 100;
+
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
 static int minolduid;
@@ -615,16 +621,23 @@ static ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "softlockup_thresh",
+		.data		= &softlockup_thresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &sixty,
+	},
+#endif
 
 	{ .ctl_name = 0 }
 };
 
-/* Constants for minimum and maximum testing in vm_table.
-   We use these as one-element integer vectors. */
-static int zero;
-static int one_hundred = 100;
-
-
 static ctl_table vm_table[] = {
 	{
 		.ctl_name	= VM_OVERCOMMIT_MEMORY,
Index: linux-2.6.22/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.22.orig/Documentation/sysctl/kernel.txt	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/Documentation/sysctl/kernel.txt	2007-07-19 13:42:09.748945250 -0700
@@ -320,6 +320,14 @@ kernel.  This value defaults to SHMMAX.
 
 ==============================================================
 
+softlockup_thresh:
+
+This value can be used to lower the softlockup tolerance
+threshold. The default threshold is 10s.  If a cpu is locked up
+for 10s, the kernel complains.  Valid values are 1-60s.
+
+==============================================================
+
 tainted: 
 
 Non-zero if the kernel has been tainted.  Numeric values, which
Index: linux-2.6.22/include/linux/sched.h
===================================================================
--- linux-2.6.22.orig/include/linux/sched.h	2007-07-19 13:35:08.610625750 -0700
+++ linux-2.6.22/include/linux/sched.h	2007-07-19 13:38:57.816950250 -0700
@@ -236,6 +236,7 @@ extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
+extern int softlockup_thresh;
 #else
 static inline void softlockup_tick(void)
 {
