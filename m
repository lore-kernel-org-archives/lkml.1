Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZHCFPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZHCFPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZHCFPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:15:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33317 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZHCFPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:15:13 -0400
Date: Sun, 2 Aug 2009 22:15:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org, ego@in.ibm.com
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090803051517.GA11735@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802221324.GP6854@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 03:13:24PM -0700, Paul E. McKenney wrote:
> On Sun, Aug 02, 2009 at 10:27:20PM +0200, Ingo Molnar wrote:
> > 
> > * tip-bot for Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Commit-ID:  7256cf0e83bf018be8a81806593aaef7f2437f0b
> > > Gitweb:     http://git.kernel.org/tip/7256cf0e83bf018be8a81806593aaef7f2437f0b
> > > Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > AuthorDate: Sun, 2 Aug 2009 10:21:10 -0700
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Sun, 2 Aug 2009 21:31:28 +0200
> > > 
> > > rcu: Add diagnostic check for a possible CPU-hotplug race
> > > 
> > > Complain if the RCU softirq code ever runs on a CPU that has
> > > not yet been announced to RCU as being online.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > LKML-Reference: <new-submission>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > FYI, the new warning triggered in -tip testing:
> 
> Yow!!!  I never was able to get this to trigger...  Of course, I never
> was able to reproduce the original problem, either.
> 
> Just so you know, one of the reasons it took me so long to come up with
> the fix is that this just isn't supposed to happen.  Where I grew up, CPUs
> were supposed to come online -before- starting to handle softirqs.  ;-)
> 
> Here is my reasoning:
> 
> o	rcu_init(), which is invoked before a second CPU can possibly
> 	come online, calls hotplug_notifier(), which causes
> 	rcu_barrier_cpu_hotplug() to be invoked in response to any
> 	CPU-hotplug event.
> 
> o	We know rcu_init() really was called, because otherwise
> 	open_softirq(RCU_SOFTIRQ) never gets called, so the softirq would
> 	never have happened.  In addition, there should be a "Hierarchical
> 	RCU implementation" message in your bootlog.  (Is there?)
> 
> o	rcu_barrier_cpu_hotplug() unconditionally invokes
> 	rcu_cpu_notify() on every CPU-hotplug event.
> 
> o	rcu_cpu_notify() invokes rcu_online_cpu() in response to
> 	any CPU_UP_PREPARE or CPU_UP_PREPARE_FROZEN CPU-hotplug
> 	event.
> 
> o	The CPU_UP_PREPARE and CPU_UP_PREPARE_FROZEN CPU-hotplug events
> 	happen before the CPU in question is capable of running any code.
> 
> o	This looks to be the first onlining of this CPU during boot
> 	(right?).  So we cannot possibly have some strange situation
> 	where the end of the prior CPU-offline event overlaps with
> 	the current CPU-online event.  (Yes, this isn't supposed to
> 	happen courtesy of CPU-hotplug locking, but impossibility
> 	is clearly no reason to dismiss possible scenarios for -this-
> 	particular bug.)
> 
> o	Therefore the WARN_ON_ONCE() cannot possibly trigger.
> 
> This would be a convincing argument, aside from the fact that you
> really did make it trigger.  So first, anything I am missing in
> the above?  If not, could you please help me with the following,
> at least if the answers are readily available?
> 
> o	Is rcu_init()'s "Hierarchical RCU implementation" log message
> 	in your bootlog?
> 
> o	Is _cpu_up() really being called, and, if so, is it really
> 	invoking __raw_notifier_call_chain() with CPU_UP_PREPARE?
> 
> o	Is this really during initial boot, or am I misreading your
> 	bootlog?  (The other reason I believe that this happened on
> 	the first CPU-online for this CPU is that ->beenonline, once
> 	set, is never cleared.)
> 
> Gautham, any thoughts on what might be happening here?

And on the off-chance that someone is stomping on the notifier chain...
Untested, probably does not compile.  Diagnostic only, not for inclusion.
If this doesn't trigger the WARN_ON_ONCE() added to rcu_init(), the
idea would be to move the WARN_ON_ONCE() to rcu_process_callbacks().
If it does trigger there, then my guess would be that either someone is
unregistering the RCU CPU-hotplug notifier or directly corrupting the
notifier chain.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/cpu.h |    3 +++
 kernel/cpu.c        |    5 +++++
 kernel/notifier.c   |   15 +++++++++++++++
 kernel/rcupdate.c   |    3 ++-
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..c8a8323 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -51,6 +51,9 @@ struct notifier_block;
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+extern int cpu_notified(int (*fn)(struct notifier_block *, unsigned long, void *));
+extern int notifier_chain_is_registered(struct notifier_block *nl,
+		int (*fn)(struct notifier_block *, unsigned long, void *));
 #else
 
 #ifndef MODULE
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8ce1004..1b98862 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -133,6 +133,11 @@ int __ref register_cpu_notifier(struct notifier_block *nb)
 	return ret;
 }
 
+int cpu_notified(int (*fn)(struct notifier_block *, unsigned long, void *))
+{
+	return notifier_chain_is_registered(&cpu_chain, fn);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 EXPORT_SYMBOL(register_cpu_notifier);
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 61d5aa5..069e3d0 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -59,6 +59,21 @@ static int notifier_chain_unregister(struct notifier_block **nl,
 	return -ENOENT;
 }
 
+int notifier_chain_is_registered(struct notifier_block *nl,
+		int (*fn)(struct notifier_block *, unsigned long, void *))
+{
+	rcu_read_lock();
+	while (nl != NULL) {
+		if (rcu_dereference(nl)->notifier_call == fn) {
+			rcu_read_unlock();
+			return 0;
+		}
+		nl = &(rcu_dereference(nl)->next);
+	}
+	rcu_read_unlock();
+	return -ENOENT;
+}
+
 /**
  * notifier_call_chain - Informs the registered notifiers about an event.
  *	@nl:		Pointer to head of the blocking notifier chain
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 3fea910..30c3af7 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -220,7 +220,7 @@ static void rcu_migrate_callback(struct rcu_head *notused)
 extern int rcu_cpu_notify(struct notifier_block *self,
 			  unsigned long action, void *hcpu);
 
-static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
+int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		unsigned long action, void *hcpu)
 {
 	rcu_cpu_notify(self, action, hcpu);
@@ -249,6 +249,7 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 void __init rcu_init(void)
 {
 	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	WARN_ON_ONCE(!cpu_notified(rcu_barrier_cpu_hotplug));
 	__rcu_init();
 }
 
