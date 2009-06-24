Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbZFXQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbZFXQvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZFXQvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:51:17 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:44991 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZFXQvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:51:16 -0400
Date: Wed, 24 Jun 2009 18:51:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20090624185100.6ca7e82a@skybase>
In-Reply-To: <20090622154030.GA19076@elte.hu>
References: <20090603152223.083010123@de.ibm.com>
	<alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
	<20090622162631.4b4dcee4@skybase>
	<20090622144110.GA9771@elte.hu>
	<20090622165936.0bb776e1@skybase>
	<20090622150553.GA14363@elte.hu>
	<20090622171834.0df64aea@skybase>
	<20090622152937.GA17512@elte.hu>
	<20090622173611.3b583c95@skybase>
	<20090622154030.GA19076@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 17:40:30 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > On Mon, 22 Jun 2009 17:29:37 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > > 
> > > > [...] And if we really want to keep things separate there will be 
> > > > two sets of per-cpu hrtimer, one for the old style profiler and 
> > > > one for oprofile. Any preference for the user space interface to 
> > > > set the sample rate? A sysctl?
> > > 
> > > I dont think we want to keep things separate. Regarding old-style 
> > > profiler, does anyone still use it? There's now a superior in-tree 
> > > replacement for it, so we could phase it out.
> > 
> > Well, for my part I won't miss it. But to be able to remove the 
> > profile_tick() calls from the architectures I either have to rip 
> > out the old profiler now, or adapt it to use hrtimer as well.
> 
> Do we _have to_ touch it so widely right now? We could start with a 
> deprecation warning in this cycle. Once it's deprecated we can 
> remove all those calls.

First version of the hrtimer patch for oprofile. I did not add the
sysctl yet, if the sysctl is added in oprofile_timer_init it would not
be available if some better profiling source is available. If it is
added unconditionally it would only have an effect if the timer
fallback is used. Both cases are not exactly nice for a user space
interface.

---
Subject: [PATCH] convert oprofile from timer_hook to hrtimer

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Oprofile is currently broken on systems running with NOHZ enabled.
A maximum of 1 tick is accounted via the timer_hook if a cpu sleeps
for a longer period of time. This does bad things to the percentages
in the profiler output. To solve this problem convert oprofile to
use a restarting hrtimer instead of the timer_hook.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/oprofile/oprof.c     |   12 ++++--
 drivers/oprofile/oprof.h     |    3 +
 drivers/oprofile/timer_int.c |   77 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 78 insertions(+), 14 deletions(-)

diff -urpN linux-2.6/drivers/oprofile/oprof.c linux-2.6-patched/drivers/oprofile/oprof.c
--- linux-2.6/drivers/oprofile/oprof.c	2009-06-24 17:21:12.000000000 +0200
+++ linux-2.6-patched/drivers/oprofile/oprof.c	2009-06-24 17:18:28.000000000 +0200
@@ -184,22 +184,26 @@ static int __init oprofile_init(void)
 	int err;
 
 	err = oprofile_arch_init(&oprofile_ops);
-
 	if (err < 0 || timer) {
 		printk(KERN_INFO "oprofile: using timer interrupt.\n");
-		oprofile_timer_init(&oprofile_ops);
+		err = oprofile_timer_init(&oprofile_ops);
+		if (err)
+			goto out_arch;
 	}
-
 	err = oprofilefs_register();
 	if (err)
-		oprofile_arch_exit();
+		goto out_arch;
+	return 0;
 
+out_arch:
+	oprofile_arch_exit();
 	return err;
 }
 
 
 static void __exit oprofile_exit(void)
 {
+	oprofile_timer_exit();
 	oprofilefs_unregister();
 	oprofile_arch_exit();
 }
diff -urpN linux-2.6/drivers/oprofile/oprof.h linux-2.6-patched/drivers/oprofile/oprof.h
--- linux-2.6/drivers/oprofile/oprof.h	2009-06-24 17:21:12.000000000 +0200
+++ linux-2.6-patched/drivers/oprofile/oprof.h	2009-06-24 17:19:11.000000000 +0200
@@ -32,7 +32,8 @@ struct super_block;
 struct dentry;
 
 void oprofile_create_files(struct super_block *sb, struct dentry *root);
-void oprofile_timer_init(struct oprofile_operations *ops);
+int oprofile_timer_init(struct oprofile_operations *ops);
+void oprofile_timer_exit(void);
 
 int oprofile_set_backtrace(unsigned long depth);
 
diff -urpN linux-2.6/drivers/oprofile/timer_int.c linux-2.6-patched/drivers/oprofile/timer_int.c
--- linux-2.6/drivers/oprofile/timer_int.c	2009-06-24 17:21:12.000000000 +0200
+++ linux-2.6-patched/drivers/oprofile/timer_int.c	2009-06-24 17:18:44.000000000 +0200
@@ -13,34 +13,93 @@
 #include <linux/oprofile.h>
 #include <linux/profile.h>
 #include <linux/init.h>
+#include <linux/cpu.h>
+#include <linux/hrtimer.h>
+#include <asm/irq_regs.h>
 #include <asm/ptrace.h>
 
 #include "oprof.h"
 
-static int timer_notify(struct pt_regs *regs)
+static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
+
+static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
+{
+	oprofile_add_sample(get_irq_regs(), 0);
+	hrtimer_forward_now(hrtimer, ns_to_ktime(TICK_NSEC));
+	return HRTIMER_RESTART;
+}
+
+static void __oprofile_hrtimer_start(void *unused)
+{
+	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
+
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = oprofile_hrtimer_notify;
+
+	hrtimer_start(hrtimer, ns_to_ktime(TICK_NSEC),
+		      HRTIMER_MODE_REL_PINNED);
+}
+
+static int oprofile_hrtimer_start(void)
 {
-	oprofile_add_sample(regs, 0);
+	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
 	return 0;
 }
 
-static int timer_start(void)
+static void __oprofile_hrtimer_stop(int cpu)
 {
-	return register_timer_hook(timer_notify);
+	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
+
+	hrtimer_cancel(hrtimer);
 }
 
+static void oprofile_hrtimer_stop(void)
+{
+	int cpu;
+	for_each_online_cpu(cpu)
+		__oprofile_hrtimer_stop(cpu);
+}
 
-static void timer_stop(void)
+static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
+					 unsigned long action, void *hcpu)
 {
-	unregister_timer_hook(timer_notify);
+	long cpu = (long) hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		smp_call_function_single(cpu, __oprofile_hrtimer_start,
+					 NULL, 1);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		__oprofile_hrtimer_stop(cpu);
+		break;
+	}
+	return NOTIFY_OK;
 }
 
+static struct notifier_block __refdata oprofile_cpu_notifier = {
+	.notifier_call = oprofile_cpu_notify,
+};
 
-void __init oprofile_timer_init(struct oprofile_operations *ops)
+int __init oprofile_timer_init(struct oprofile_operations *ops)
 {
+	int rc;
+
+        rc = register_hotcpu_notifier(&oprofile_cpu_notifier);
+        if (rc)
+		return rc;
 	ops->create_files = NULL;
 	ops->setup = NULL;
 	ops->shutdown = NULL;
-	ops->start = timer_start;
-	ops->stop = timer_stop;
+	ops->start = oprofile_hrtimer_start;
+	ops->stop = oprofile_hrtimer_stop;
 	ops->cpu_type = "timer";
+	return 0;
+}
+
+void __exit oprofile_timer_exit(void)
+{
+	unregister_hotcpu_notifier(&oprofile_cpu_notifier);
 }

---

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

