Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZHFB0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZHFB0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZHFB0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:26:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34625 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZHFB0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:26:44 -0400
Date: Wed, 5 Aug 2009 18:26:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org, ego@in.ibm.com
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090806012645.GA24800@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com> <20090803070458.GA27581@elte.hu> <20090803125618.GV6854@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803125618.GV6854@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:56:18AM -0700, Paul E. McKenney wrote:
> On Mon, Aug 03, 2009 at 09:04:58AM +0200, Ingo Molnar wrote:
> > 
> > i've attached the full serial bootlog with the warning in it. This 
> > should address your question about what the order of initialization 
> > is, right?
> 
> It does, thank you!  This problem really is happening during boot.
> 
> > Let me know if you still would like me to run your diagnostic patch 
> > too.
> 
> Now that you mention it, you should probably let me test it a bit first.

And here is a tested and debugged version.  Diagnostic only, not for
inclusion, based on tip/core/rcu as of today (August 5th).

Gautham, have you been able to reproduce on your machines?  Still cannot
here.

							Thanx, Paul

------------------------------------------------------------------------

Create an rcu_cpu_notified() API that checks to see whether RCU's
CPU-hotplug notifier is registered.  This is used in three WARN_ON_ONCE()
calls, the first of which should trigger, and the second two of
which should not -- but I suspect that the WARN_ON_ONCE() located in
__rcu_process_callbacks() will in fact trigger on the machine suffering
from this bug.  ;-)

Any code path that executes after rcu_init() should have RCU CPU-hotplug
notifiers registered, so any triggering of the following WARN_ON_ONCE()
after rcu_init() is a bug:

	WARN_ON_ONCE(!rcu_cpu_notified());

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/cpu.h      |    3 +++
 include/linux/rcupdate.h |    1 +
 kernel/cpu.c             |    5 +++++
 kernel/notifier.c        |   23 +++++++++++++++++++++++
 kernel/rcupdate.c        |    9 ++++++++-
 kernel/rcutree.c         |    1 +
 6 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..d9b3c18 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -51,6 +51,9 @@ struct notifier_block;
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+extern int cpu_notified(int (*fn)(struct notifier_block *, unsigned long, void *));
+extern int raw_notifier_chain_is_registered(struct raw_notifier_head *nh,
+		int (*fn)(struct notifier_block *, unsigned long, void *));
 #else
 
 #ifndef MODULE
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3c89d6a..f790f3c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -65,6 +65,7 @@ extern void rcu_init(void);
 extern void rcu_scheduler_starting(void);
 extern int rcu_needs_cpu(int cpu);
 extern int rcu_scheduler_active;
+extern int rcu_cpu_notified(void);
 
 #if defined(CONFIG_TREE_RCU)
 #include <linux/rcutree.h>
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8ce1004..5aa736a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -133,6 +133,11 @@ int __ref register_cpu_notifier(struct notifier_block *nb)
 	return ret;
 }
 
+int cpu_notified(int (*fn)(struct notifier_block *, unsigned long, void *))
+{
+	return raw_notifier_chain_is_registered(&cpu_chain, fn);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 EXPORT_SYMBOL(register_cpu_notifier);
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 61d5aa5..d72c0b8 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -59,6 +59,29 @@ static int notifier_chain_unregister(struct notifier_block **nl,
 	return -ENOENT;
 }
 
+static int notifier_chain_is_registered(struct notifier_block *nl,
+		int (*fn)(struct notifier_block *, unsigned long, void *))
+{
+	rcu_read_lock();
+	/* printk(KERN_ALERT "notifier_chain_is_registered looking for: %pS\n", fn); */
+	while (nl != NULL) {
+		/* printk(KERN_ALERT "notifier_chain_is_registered: %pS\n", rcu_dereference(nl)->notifier_call); */
+		if (rcu_dereference(nl)->notifier_call == fn) {
+			rcu_read_unlock();
+			return 1;
+		}
+		nl = (rcu_dereference(nl)->next);
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
+int raw_notifier_chain_is_registered(struct raw_notifier_head *nh,
+		int (*fn)(struct notifier_block *, unsigned long, void *))
+{
+	return notifier_chain_is_registered(nh->head, fn);
+}
+
 /**
  * notifier_call_chain - Informs the registered notifiers about an event.
  *	@nl:		Pointer to head of the blocking notifier chain
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 9f0584e..57a4626 100644
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
@@ -246,12 +246,19 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
+int rcu_cpu_notified(void)
+{
+	return cpu_notified(rcu_barrier_cpu_hotplug);
+}
+
 void __init rcu_init(void)
 {
 	int i;
 
 	__rcu_init();
+	WARN_ON_ONCE(!rcu_cpu_notified()); /* this one expected to trigger. */
 	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	WARN_ON_ONCE(!rcu_cpu_notified());
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b9b1928..a0bfc93 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1133,6 +1133,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 	unsigned long flags;
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
+	WARN_ON_ONCE(!rcu_cpu_notified());
 
 	/*
 	 * If an RCU GP has gone long enough, go check for dyntick
