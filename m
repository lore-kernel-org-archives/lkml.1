Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZHLBeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZHLBeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 21:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZHLBeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 21:34:31 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35038 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZHLBea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 21:34:30 -0400
Date: Tue, 11 Aug 2009 18:34:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
Message-ID: <20090812013422.GA23187@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090808235634.GB6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908090414320.18096@sister.anvils> <20090809053308.GD6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908091209150.23855@sister.anvils> <Pine.LNX.4.64.0908091346450.27358@sister.anvils> <20090809185753.GG6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908092139090.3194@sister.anvils> <20090809211629.GJ6866@linux.vnet.ibm.com> <20090810033907.GA1530@linux.vnet.ibm.com> <20090810224345.GA17730@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810224345.GA17730@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 03:43:45PM -0700, Paul E. McKenney wrote:
> On Sun, Aug 09, 2009 at 08:39:07PM -0700, Paul E. McKenney wrote:
> > On Sun, Aug 09, 2009 at 02:16:29PM -0700, Paul E. McKenney wrote:
> > > On Sun, Aug 09, 2009 at 09:53:53PM +0100, Hugh Dickins wrote:

[ . . . ]

> > > > That builds and works for me, with or without CONFIG_HOTPLUG_CPU.
> > > > 
> > > > But I didn't get what you're achieving with the MODULE part of it;
> > > > and (I'm not a notifier buff at all) it does seems rather baroque to
> > > > me - a single callsite, why not stick with register_cpu_notifier()?
> > > > 
> > > > Ah, perhaps it's your ambition to move others over to this
> > > > (or perhaps it's your ambition to leave that to someone else ;-)
> > > 
> > > Actually, nothing quite that clearly thought out.  I was just following
> > > the pattern set for register_cpu_notifier().  My guess at the reasoning
> > > is that when !HOTPLUG_CPU, modules cannot be loaded until all the CPUs
> > > are online, so there is no point in letting a module set itself up for
> > > notification.
> > > 
> > > But whatever their reasoning, mine was that there is no point in
> > > creating a struct notifier_block that wasn't going to be used.  ;-)
> > 
> > And the above patch fails for !CONFIG_SMP.  Here is an update, testing
> > in progress.  Still not fully tested, but results are encouraging.
> > In particular, this one is more likely to compile.
> 
> And this handled !CONFIG_SMP, but fails two of fifteen test cases.
> So better, but still far from perfect.
> 
> Chasing the failures down.

And I believe I have a patch that works for all of my test cases, but
am rerunning the full set to double-check.  Patch against tip/core/rcu
below for your collective amusement.

Should these tests pass...

Unless someone tells me otherwise, I will make a patch series intended
to replace tip/core/rcu commits 7fe616c5d ("Simplify RCU CPU-hotplug
notification"), 04b06256c ("Fix RCU & CPU hotplug hang"), and 7256cf0e83b
("Add diagnostic check for a possible CPU-hotplug race"), re-run all tests
on that patchset, and submit the series.  I expect the resulting patch
set to have three patches, one to split out boot-time initialization
for RCU_TREE, a second to create the cpu_notifier() API, and the third
to make RCU use it.

I guess the lesson to me is that although I should send a patch quickly
in response to bug reports, I need to nevertheless run my full set of RCU
torture tests on it -- and verify that the specified kernel configuration
parameters actually were in effect for those tests.  :-/

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..4753619 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -48,6 +48,15 @@ struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
+#if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
+#define cpu_notifier(fn, pri) {					\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
+		{ .notifier_call = fn, .priority = pri };	\
+	register_cpu_notifier(&fn##_nb);			\
+}
+#else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
+#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
@@ -74,6 +83,8 @@ extern void cpu_maps_update_done(void);
 
 #else	/* CONFIG_SMP */
 
+#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
@@ -99,11 +110,7 @@ extern struct sysdev_class cpu_sysdev_class;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
-#define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb __cpuinitdata =	\
-		{ .notifier_call = fn, .priority = pri };	\
-	register_cpu_notifier(&fn##_nb);			\
-}
+#define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 9f0584e..8df1156 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -238,7 +238,7 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
 		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
 		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
-	} else if (action == CPU_DEAD) {
+	} else if (action == CPU_POST_DEAD) {
 		/* rcu_migrate_head is protected by cpu_add_remove_lock */
 		wait_migrated_callbacks();
 	}
@@ -251,7 +251,7 @@ void __init rcu_init(void)
 	int i;
 
 	__rcu_init();
-	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
