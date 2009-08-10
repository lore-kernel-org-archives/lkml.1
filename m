Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbZHJDjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbZHJDjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 23:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZHJDjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 23:39:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44993 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbZHJDjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 23:39:10 -0400
Date: Sun, 9 Aug 2009 20:39:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
Message-ID: <20090810033907.GA1530@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0908081956580.12300@sister.anvils> <20090808235634.GB6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908090414320.18096@sister.anvils> <20090809053308.GD6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908091209150.23855@sister.anvils> <Pine.LNX.4.64.0908091346450.27358@sister.anvils> <20090809185753.GG6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908092139090.3194@sister.anvils> <20090809211629.GJ6866@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090809211629.GJ6866@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 02:16:29PM -0700, Paul E. McKenney wrote:
> On Sun, Aug 09, 2009 at 09:53:53PM +0100, Hugh Dickins wrote:
> > On Sun, 9 Aug 2009, Paul E. McKenney wrote:
> > > 
> > > I introduced the problem in commit 7fe616c5dd50a50f334edec1ea0580b90b7af0d9
> > > by changing from register_cpu_notifier() to hotcpu_notifier().  The former
> > > lets you know when CPUs come on line unconditionally, the latter only
> > > when CONFIG_HOTPLUG_CPU is in effect.
> > > 
> > > But hotcpu_notifier() is much nicer to use, so I propose introducing
> > > a cpu_notifier() that is invoked like hotcpu_notifier() is, but is
> > > unconditional in the same way that register_cpu_notifier().
> > > 
> > > Something like the following (untested, probably does not compile):
> > > 
> > > diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> > > index 4d668e0..d5dfc1f 100644
> > > --- a/include/linux/cpu.h
> > > +++ b/include/linux/cpu.h
> > > @@ -48,6 +48,15 @@ struct notifier_block;
> > >  
> > >  #ifdef CONFIG_SMP
> > >  /* Need to know about CPUs going up/down? */
> > > +#if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
> > > +#define cpu_notifier(fn, pri) {					\
> > > +	static struct notifier_block fn##_nb __cpuinitdata =	\
> > > +		{ .notifier_call = fn, .priority = pri };	\
> > > +	register_cpu_notifier(&fn##_nb);			\
> > > +}
> > > +#else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
> > > +#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
> > > +#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
> > >  #ifdef CONFIG_HOTPLUG_CPU
> > >  extern int register_cpu_notifier(struct notifier_block *nb);
> > >  extern void unregister_cpu_notifier(struct notifier_block *nb);
> > > @@ -99,11 +108,7 @@ extern struct sysdev_class cpu_sysdev_class;
> > >  
> > >  extern void get_online_cpus(void);
> > >  extern void put_online_cpus(void);
> > > -#define hotcpu_notifier(fn, pri) {				\
> > > -	static struct notifier_block fn##_nb __cpuinitdata =	\
> > > -		{ .notifier_call = fn, .priority = pri };	\
> > > -	register_cpu_notifier(&fn##_nb);			\
> > > -}
> > > +#define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
> > >  #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
> > >  #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
> > >  int cpu_down(unsigned int cpu);
> > > diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> > > index 9f0584e..c1bbfd5 100644
> > > --- a/kernel/rcupdate.c
> > > +++ b/kernel/rcupdate.c
> > > @@ -251,7 +251,7 @@ void __init rcu_init(void)
> > >  	int i;
> > >  
> > >  	__rcu_init();
> > > -	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
> > > +	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
> > >  
> > >  	/*
> > >  	 * We don't need protection against CPU-hotplug here because
> > > 
> > [ removed repeat of rcupdate.c patch ]
> > > 
> > > Thoughts?
> > 
> > That builds and works for me, with or without CONFIG_HOTPLUG_CPU.
> > 
> > But I didn't get what you're achieving with the MODULE part of it;
> > and (I'm not a notifier buff at all) it does seems rather baroque to
> > me - a single callsite, why not stick with register_cpu_notifier()?
> > 
> > Ah, perhaps it's your ambition to move others over to this
> > (or perhaps it's your ambition to leave that to someone else ;-)
> 
> Actually, nothing quite that clearly thought out.  I was just following
> the pattern set for register_cpu_notifier().  My guess at the reasoning
> is that when !HOTPLUG_CPU, modules cannot be loaded until all the CPUs
> are online, so there is no point in letting a module set itself up for
> notification.
> 
> But whatever their reasoning, mine was that there is no point in
> creating a struct notifier_block that wasn't going to be used.  ;-)

And the above patch fails for !CONFIG_SMP.  Here is an update, testing
in progress.  Still not fully tested, but results are encouraging.
In particular, this one is more likely to compile.

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
