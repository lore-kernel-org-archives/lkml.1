Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbXEKLJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbXEKLJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbXEKLJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:09:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbXEKLJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:09:03 -0400
Date: Fri, 11 May 2007 13:07:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [patch] CFS scheduler, -v11
Message-ID: <20070511110754.GA13985@elte.hu>
References: <20070508150431.GA26977@elte.hu> <1178725597.10077.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178725597.10077.1.camel@localhost>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ remailing this on-list too, with some more explanations, i suspect 
  others might be affected by this 3D performance problem as well. ]

* Kasper Sandberg <lkml@metanurb.dk> wrote:

> [...] but under harder load such as pressing a link in a browser while 
> 3d(at nice 0), or spamasassin at nice 0 still makes it go stutterish 
> instead of smooth. But overall it does seem better.

ok, i think i have finally managed to track this one down.

certain 3D drivers grew a subtle performance dependency on a 
sys_sched_yield() implementation/behavioral bug/misbehavior of the 
upstream kernel, which implementation SD does too, but CFS fixes it by 
always yielding efficiently. The result of this bug/dependency is 
extremely low FPS during any CPU-intense workload.

you are using an Nvidia 6600 card so i dont know for sure whether you 
are affected by this problem (Radeon cards are affected and i can now 
reproduce that) - but the symptoms i've reproduced seem to be matching 
your system's symptoms.

I've added a workaround for this to CFS, do you have some time to try 
it? I've attached the sched-cfs-v12-rc4.patch (delta patch ontop of a 
CFS -v11 tree), and once you have booted it you can activate the 
workaround via:

     echo 1 > /proc/sys/kernel/sched_yield_bug_workaround

does this make any difference to the drastic 3D smoothness problems you 
are experiencing?

	Ingo

---
 Makefile                     |    2 +-
 drivers/char/drm/radeon_cp.c |    5 +++++
 include/linux/sched.h        |    2 +-
 kernel/sched_fair.c          |   23 +++++++++++++++++++----
 kernel/sysctl.c              |   12 ++++++------
 5 files changed, 32 insertions(+), 12 deletions(-)

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 21
-EXTRAVERSION = -cfs-v11
+EXTRAVERSION = -cfs-v12
 NAME = Nocturnal Monster Puppy
 
 # *DOCUMENTATION*
Index: linux/drivers/char/drm/radeon_cp.c
===================================================================
--- linux.orig/drivers/char/drm/radeon_cp.c
+++ linux/drivers/char/drm/radeon_cp.c
@@ -2210,6 +2210,11 @@ int radeon_driver_load(struct drm_device
 
 	DRM_DEBUG("%s card detected\n",
 		  ((dev_priv->flags & RADEON_IS_AGP) ? "AGP" : (((dev_priv->flags & RADEON_IS_PCIE) ? "PCIE" : "PCI"))));
+	if (sysctl_sched_yield_bug_workaround == -1) {
+		sysctl_sched_yield_bug_workaround = 1;
+		printk(KERN_WARNING "quirk installed: turning on "
+			"sys_sched_yield() workaround for Radeon DRM.\n");
+	}
 	return ret;
 }
 
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1253,9 +1253,9 @@ extern char * sched_print_task_state(str
 
 extern unsigned int sysctl_sched_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
-extern unsigned int sysctl_sched_sleep_history_max;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_load_smoothing;
+extern int sysctl_sched_yield_bug_workaround;
 
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -18,10 +18,6 @@
  */
 unsigned int sysctl_sched_granularity __read_mostly = 2000000;
 
-unsigned int sysctl_sched_sleep_history_max __read_mostly = 2000000000;
-
-unsigned int sysctl_sched_load_smoothing = 0 | 0 | 0 | 8;
-
 /*
  * Wake-up granularity.
  * (default: 1 msec, units: nanoseconds)
@@ -32,6 +28,19 @@ unsigned int sysctl_sched_load_smoothing
  */
 unsigned int sysctl_sched_wakeup_granularity __read_mostly = 0;
 
+unsigned int sysctl_sched_load_smoothing __read_mostly = 0 | 0 | 0 | 8;
+
+/*
+ * sys_sched_yield unfairness bug workaround switch.
+ * (default: -1:auto-detect+disabled. Other values: 0:disabled, 1:enabled)
+ *
+ * This option switches the unfair yield implementation of the
+ * old scheduler back on. Needed for good performance of certain
+ * apps like 3D games on Radeon cards.
+ */
+int sysctl_sched_yield_bug_workaround __read_mostly = -1;
+
+EXPORT_SYMBOL_GPL(sysctl_sched_yield_bug_workaround);
 
 extern struct sched_class fair_sched_class;
 
@@ -462,6 +471,12 @@ yield_task_fair(struct rq *rq, struct ta
 	u64 now;
 
 	/*
+	 * Bug workaround for 3D apps running on the radeon 3D driver:
+	 */
+	if (unlikely(sysctl_sched_yield_bug_workaround > 0))
+		return;
+
+	/*
 	 * yield-to support: if we are on the same runqueue then
 	 * give half of our wait_runtime (if it's positive) to the other task:
 	 */
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -223,24 +223,24 @@ static ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_sleep_history_max_ns",
-		.data		= &sysctl_sched_sleep_history_max,
+		.procname	= "sched_child_runs_first",
+		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_child_runs_first",
-		.data		= &sysctl_sched_child_runs_first,
+		.procname	= "sched_load_smoothing",
+		.data		= &sysctl_sched_load_smoothing,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_load_smoothing",
-		.data		= &sysctl_sched_load_smoothing,
+		.procname	= "sched_yield_bug_workaround",
+		.data		= &sysctl_sched_yield_bug_workaround,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
