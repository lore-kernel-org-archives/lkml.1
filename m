Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbZHIS5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbZHIS5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 14:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZHIS5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 14:57:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38988 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZHIS5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 14:57:52 -0400
Date: Sun, 9 Aug 2009 11:57:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
Message-ID: <20090809185753.GG6866@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0908081956580.12300@sister.anvils> <20090808235634.GB6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908090414320.18096@sister.anvils> <20090809053308.GD6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908091209150.23855@sister.anvils> <Pine.LNX.4.64.0908091346450.27358@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908091346450.27358@sister.anvils>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 02:06:05PM +0100, Hugh Dickins wrote:
> On Sun, 9 Aug 2009, Hugh Dickins wrote:
> > 
> > filp 13343 objects:
> > 
> > CPU last cur F M
> >   0    1   0 0 0
> >   1    0   0 0 0
> >   2   -1   0 0 0
> >   3    0   0 0 0
> > ggp = 35124, state = waitzero
> 
> Interesting that rcu_try_flip_waitzero() doesn't see 1 + 0 + -1 + 0 == 0.

Indeed!!!  You nailed it!!!

> That's because rcu_cpu_online_map is 0x1 instead of the 0xf it should be.
> 
> Which is because I don't have CONFIG_HOTPLUG_CPU=y on that PPC machine
> (unlike the x86s), and I think you've made some recent mods which
> accidentally made the rcu cpu initialization dependent on hotplug
> cpu notifiers?  CONFIG_HOTPLUG_CPU=y and it works properly again.

Back to the drawing board at this end...

> And TREE_RCU doesn't use an rcu_cpu_online_map (though it does expect
> some per-cpu initialization, but seems to get away without it).

Only by pure luck.  The kind of luck that gets you into serious trouble
later on.

> So I think that's the mystery solved - I'll let you decide the right fix!

Thank you -very- much for tracking this down, Hugh!!!

I introduced the problem in commit 7fe616c5dd50a50f334edec1ea0580b90b7af0d9
by changing from register_cpu_notifier() to hotcpu_notifier().  The former
lets you know when CPUs come on line unconditionally, the latter only
when CONFIG_HOTPLUG_CPU is in effect.

But hotcpu_notifier() is much nicer to use, so I propose introducing
a cpu_notifier() that is invoked like hotcpu_notifier() is, but is
unconditional in the same way that register_cpu_notifier().

Something like the following (untested, probably does not compile):

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..d5dfc1f 100644
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
@@ -99,11 +108,7 @@ extern struct sysdev_class cpu_sysdev_class;
 
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
index 9f0584e..c1bbfd5 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -251,7 +251,7 @@ void __init rcu_init(void)
 	int i;
 
 	__rcu_init();
-	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because

With this in place:

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 9f0584e..c1bbfd5 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -251,7 +251,7 @@ void __init rcu_init(void)
 	int i;
 
 	__rcu_init();
-	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because

Thoughts?

							Thanx, Paul
