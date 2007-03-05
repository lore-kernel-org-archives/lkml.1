Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbXCEKjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbXCEKjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbXCEKjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:39:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbXCEKjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:39:47 -0500
Date: Mon, 5 Mar 2007 11:31:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Message-ID: <20070305103141.GA18404@elte.hu>
References: <1173018209.24738.135.camel@localhost.localdomain> <6bffcb0e0703040636q5a4ed3ekf5a0461052e8e018@mail.gmail.com> <1173022668.24738.141.camel@localhost.localdomain> <6bffcb0e0703040828j46a339c2ofabf7c0e20f6ae09@mail.gmail.com> <1173026442.24738.143.camel@localhost.localdomain> <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com> <1173027823.24738.156.camel@localhost.localdomain> <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com> <20070305080824.GA20583@elte.hu> <1173090869.24738.198.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173090869.24738.198.camel@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > shouldnt that be 'R' instead of the question mark?
> 
> ? are dead ones,  

ok.

> The interesting part is here:
> 
> 1 lock held by udevd/918:
>  #0:  (&mm->mmap_sem){----}, at: [<c161135b>] do_page_fault+0x150/0x50d
> 
> But udevd/918 is nowhere in the sysrq-t output.

also below is a softlockup-debug patch that might be useful, which adds 
a tick/tock output so it spams the console once per second but can show 
the dynamics of lockups (and other delays).

	Ingo

------------------->
Subject: [patch] softlockup: add /proc/sys/kernel/softlockup_print_tick
From: Ingo Molnar <mingo@elte.hu>

/proc/sys/kernel/softlockup_print_tick tunable:

 0: off
 1: print tick/tock messages in softlockup irq and task.
 2: also print stack dump

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    5 +++++
 include/linux/sched.h               |    2 ++
 kernel/softlockup.c                 |   13 ++++++++++++-
 kernel/sysctl.c                     |   10 ++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -1659,6 +1659,11 @@ and is between 256 and 4096 characters. 
 
 	snd-ymfpci=	[HW,ALSA]
 
+	softlockup_print_tick
+			[KNL] Print softlockup tick in the irq and in the
+			watchdog task. If value 2 then print stackdump too.
+			Format: <0/1/2>
+
 	sonycd535=	[HW,CD]
 			Format: <io>[,<irq>]
 
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -223,6 +223,8 @@ extern void update_process_times(int use
 extern void scheduler_tick(void);
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
+extern int softlockup_print_tick;
+
 extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -21,6 +21,7 @@ static DEFINE_PER_CPU(unsigned long, pri
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int did_panic = 0;
+int softlockup_print_tick = 2;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -62,8 +63,15 @@ void softlockup_tick(void)
 	}
 
 	/* Wake up the high-prio watchdog task every second: */
-	if (time_after(jiffies, touch_timestamp + HZ))
+	if (time_after(jiffies, touch_timestamp + HZ)) {
+		if (softlockup_print_tick) {
+			printk("softlockup tick on CPU#%d, %s:%d\n",
+				this_cpu, current->comm, current->pid);
+			if (softlockup_print_tick == 2)
+				dump_stack();
+		}
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
+	}
 
 	/* Warn about unreasonable 10+ seconds delays: */
 	if (time_after(jiffies, touch_timestamp + 10*HZ)) {
@@ -83,6 +91,7 @@ void softlockup_tick(void)
 static int watchdog(void * __bind_cpu)
 {
 	struct sched_param param = { .sched_priority = 99 };
+	int this_cpu = (int)(long)__bind_cpu;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
@@ -96,6 +105,8 @@ static int watchdog(void * __bind_cpu)
 		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
 		schedule();
+		if (softlockup_print_tick)
+			printk("softlockup tock on CPU#%d\n", this_cpu);
 	}
 
 	return 0;
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -231,6 +231,16 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "softlockup_print_tick",
+		.data		= &softlockup_print_tick,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.ctl_name	= KERN_TAINTED,
