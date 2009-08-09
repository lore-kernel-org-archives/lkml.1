Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZHIKzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZHIKzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 06:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZHIKzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 06:55:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:44290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZHIKzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 06:55:15 -0400
Date: Sun, 9 Aug 2009 10:54:33 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090806012645.GA24800@linux.vnet.ibm.com>
References: <20090806012645.GA24800@linux.vnet.ibm.com>
Subject: [tip:core/rcu] rcu: Add second diagnostic check for a possible CPU-hotplug race
Message-ID: <tip-86f044729ee3e4d8885c17371ce5a76f6f321dc7@git.kernel.org>
Git-Commit-ID: 86f044729ee3e4d8885c17371ce5a76f6f321dc7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 10:54:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86f044729ee3e4d8885c17371ce5a76f6f321dc7
Gitweb:     http://git.kernel.org/tip/86f044729ee3e4d8885c17371ce5a76f6f321dc7
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 5 Aug 2009 18:26:45 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 12:42:48 +0200

rcu: Add second diagnostic check for a possible CPU-hotplug race

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

-v2: fix build error

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: ego@in.ibm.com
LKML-Reference: <20090806012645.GA24800@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/cpu.h      |    3 +++
 include/linux/rcupdate.h |    1 +
 kernel/cpu.c             |    5 +++++
 kernel/notifier.c        |   23 +++++++++++++++++++++++
 kernel/rcupdate.c        |    9 ++++++++-
 kernel/rcutree.c         |    1 +
 6 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..1b1c30c 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -45,12 +45,15 @@ extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 extern void unregister_cpu(struct cpu *cpu);
 #endif
 struct notifier_block;
+extern int cpu_notified(int (*fn)(struct notifier_block *, unsigned long, void *));
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
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
