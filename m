Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYLVLpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYLVLpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYLVLpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:45:34 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:55611 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbYLVLpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:45:32 -0500
Message-Id: <20081222114529.601526881@de.ibm.com>
References: <20081222113629.080104676@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 22 Dec 2008 12:36:30 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 1/2] stop_machine: introduce stop_machine_create/destroy.
Content-Disposition: inline; filename=001_stop.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Introduce stop_machine_create/destroy. With this interface subsystems
that need a non-failing stop_machine environment can create the
stop_machine machine threads before actually calling stop_machine.
When the threads aren't needed anymore they can be killed with
stop_machine_destroy again.

When stop_machine gets called and the threads aren't present they
will be created and destroyed automatically. This restores the old
behaviour of stop_machine.

This patch also converts cpu hotplug to the new interface since it
is special: cpu_down calls __stop_machine instead of stop_machine.
However the kstop threads will only be created when stop_machine
gets called.

Changing the code so that the threads would be created automatically
on __stop_machine is currently not possible: when __stop_machine gets
called we hold cpu_add_remove_lock, which is the same lock that
create_rt_workqueue would take. So the workqueue needs to be created
before the cpu hotplug code locks cpu_add_remove_lock.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/stop_machine.h |   22 +++++++++++++++++
 kernel/cpu.c                 |    6 +++-
 kernel/stop_machine.c        |   55 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 72 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -38,7 +38,10 @@ struct stop_machine_data {
 static unsigned int num_threads;
 static atomic_t thread_ack;
 static DEFINE_MUTEX(lock);
-
+/* setup_lock protects refcount, stop_machine_wq and stop_machine_work. */
+static DEFINE_MUTEX(setup_lock);
+/* Users of stop_machine. */
+static int refcount;
 static struct workqueue_struct *stop_machine_wq;
 static struct stop_machine_data active, idle;
 static const cpumask_t *active_cpus;
@@ -109,6 +112,43 @@ static int chill(void *unused)
 	return 0;
 }
 
+int stop_machine_create(void)
+{
+	mutex_lock(&setup_lock);
+	if (refcount)
+		goto done;
+	stop_machine_wq = create_rt_workqueue("kstop");
+	if (!stop_machine_wq)
+		goto err_out;
+	stop_machine_work = alloc_percpu(struct work_struct);
+	if (!stop_machine_work)
+		goto err_out;
+done:
+	refcount++;
+	mutex_unlock(&setup_lock);
+	return 0;
+
+err_out:
+	if (stop_machine_wq)
+		destroy_workqueue(stop_machine_wq);
+	mutex_unlock(&setup_lock);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(stop_machine_create);
+
+void stop_machine_destroy(void)
+{
+	mutex_lock(&setup_lock);
+	refcount--;
+	if (refcount)
+		goto done;
+	destroy_workqueue(stop_machine_wq);
+	free_percpu(stop_machine_work);
+done:
+	mutex_unlock(&setup_lock);
+}
+EXPORT_SYMBOL_GPL(stop_machine_destroy);
+
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
 	struct work_struct *sm_work;
@@ -146,19 +186,14 @@ int stop_machine(int (*fn)(void *), void
 {
 	int ret;
 
+	ret = stop_machine_create();
+	if (ret)
+		return ret;
 	/* No CPUs can come up or down during this. */
 	get_online_cpus();
 	ret = __stop_machine(fn, data, cpus);
 	put_online_cpus();
-
+	stop_machine_destroy();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
-
-static int __init stop_machine_init(void)
-{
-	stop_machine_wq = create_rt_workqueue("kstop");
-	stop_machine_work = alloc_percpu(struct work_struct);
-	return 0;
-}
-core_initcall(stop_machine_init);
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -290,8 +290,11 @@ out_release:
 
 int __ref cpu_down(unsigned int cpu)
 {
-	int err = 0;
+	int err;
 
+	err = stop_machine_create();
+	if (err)
+		return err;
 	cpu_maps_update_begin();
 
 	if (cpu_hotplug_disabled) {
@@ -318,6 +321,7 @@ int __ref cpu_down(unsigned int cpu)
 
 out:
 	cpu_maps_update_done();
+	stop_machine_destroy();
 	return err;
 }
 EXPORT_SYMBOL(cpu_down);
Index: linux-2.6/include/linux/stop_machine.h
===================================================================
--- linux-2.6.orig/include/linux/stop_machine.h
+++ linux-2.6/include/linux/stop_machine.h
@@ -35,6 +35,24 @@ int stop_machine(int (*fn)(void *), void
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+
+/**
+ * stop_machine_create: create all stop_machine threads
+ *
+ * Description: This causes all stop_machine threads to be created before
+ * stop_machine actually gets called. This can be used by subsystems that
+ * need a non failing stop_machine infrastructure.
+ */
+int stop_machine_create(void);
+
+/**
+ * stop_machine_destroy: destroy all stop_machine threads
+ *
+ * Description: This causes all stop_machine threads which were created with
+ * stop_machine_create to be destroyed again.
+ */
+void stop_machine_destroy(void);
+
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -46,5 +64,9 @@ static inline int stop_machine(int (*fn)
 	local_irq_enable();
 	return ret;
 }
+
+static inline int stop_machine_create(void) { return 0; }
+static inline void stop_machine_destroy(void) { }
+
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */

-- 
