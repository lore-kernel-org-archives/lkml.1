Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0CDVUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:20:38 -0500
Received: from relay3.sgi.com ([192.48.152.1]:46770 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756378Ab0CDVUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:20:36 -0500
Date: Thu, 4 Mar 2010 15:20:34 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] improve stop_machine performance
Message-ID: <20100304212034.GA3171@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with large cpu counts, we've been seeing long bootup times
associated with stop_machine operations.  I've noticed that by simply
removing the creation of the workqueue and associated percpu variables
in subsequent stop_machine calls, we can reduce boot times on a
1024 processor SGI UV system from 25-30 (or more) minutes down to 12
minutes.

The attached patch does this in a simple way by removing the
stop_machine_destroy interface, thereby by leaving the workqueues and
percpu variables for later use once they are created.

If people are against having these areas around after boot, maybe there
are some alternatives that will still allow for this optimization:

 - Set a timer to go off after a configurable number of minutes, at
   which point the workqueue areas will be deleted.

 - Keep the stop_machine_destroy function, but somehow run it at the tail
   end of boot (after modules have loaded), rather than running it at
   every stop_machine call.


Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 drivers/xen/manage.c         |    1 -
 include/linux/stop_machine.h |    9 ---------
 kernel/cpu.c                 |    2 --
 kernel/module.c              |    1 -
 kernel/stop_machine.c        |   25 +++++--------------------
 5 files changed, 5 insertions(+), 33 deletions(-)

Index: linux/kernel/stop_machine.c
===================================================================
--- linux.orig/kernel/stop_machine.c
+++ linux/kernel/stop_machine.c
@@ -38,10 +38,8 @@ struct stop_machine_data {
 static unsigned int num_threads;
 static atomic_t thread_ack;
 static DEFINE_MUTEX(lock);
-/* setup_lock protects refcount, stop_machine_wq and stop_machine_work. */
+/* setup_lock protects stop_machine_wq and stop_machine_work. */
 static DEFINE_MUTEX(setup_lock);
-/* Users of stop_machine. */
-static int refcount;
 static struct workqueue_struct *stop_machine_wq;
 static struct stop_machine_data active, idle;
 static const struct cpumask *active_cpus;
@@ -115,7 +113,7 @@ static int chill(void *unused)
 int stop_machine_create(void)
 {
 	mutex_lock(&setup_lock);
-	if (refcount)
+	if (stop_machine_wq)
 		goto done;
 	stop_machine_wq = create_rt_workqueue("kstop");
 	if (!stop_machine_wq)
@@ -124,31 +122,19 @@ int stop_machine_create(void)
 	if (!stop_machine_work)
 		goto err_out;
 done:
-	refcount++;
 	mutex_unlock(&setup_lock);
 	return 0;
 
 err_out:
-	if (stop_machine_wq)
+	if (stop_machine_wq) {
 		destroy_workqueue(stop_machine_wq);
+		stop_machine_wq = NULL;
+	}
 	mutex_unlock(&setup_lock);
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(stop_machine_create);
 
-void stop_machine_destroy(void)
-{
-	mutex_lock(&setup_lock);
-	refcount--;
-	if (refcount)
-		goto done;
-	destroy_workqueue(stop_machine_wq);
-	free_percpu(stop_machine_work);
-done:
-	mutex_unlock(&setup_lock);
-}
-EXPORT_SYMBOL_GPL(stop_machine_destroy);
-
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	struct work_struct *sm_work;
@@ -193,7 +179,6 @@ int stop_machine(int (*fn)(void *), void
 	get_online_cpus();
 	ret = __stop_machine(fn, data, cpus);
 	put_online_cpus();
-	stop_machine_destroy();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
Index: linux/drivers/xen/manage.c
===================================================================
--- linux.orig/drivers/xen/manage.c
+++ linux/drivers/xen/manage.c
@@ -138,7 +138,6 @@ out_thaw:
 
 out_destroy_sm:
 #endif
-	stop_machine_destroy();
 
 out:
 	shutting_down = SHUTDOWN_INVALID;
Index: linux/include/linux/stop_machine.h
===================================================================
--- linux.orig/include/linux/stop_machine.h
+++ linux/include/linux/stop_machine.h
@@ -45,14 +45,6 @@ int __stop_machine(int (*fn)(void *), vo
  */
 int stop_machine_create(void);
 
-/**
- * stop_machine_destroy: destroy all stop_machine threads
- *
- * Description: This causes all stop_machine threads which were created with
- * stop_machine_create to be destroyed again.
- */
-void stop_machine_destroy(void);
-
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -66,7 +58,6 @@ static inline int stop_machine(int (*fn)
 }
 
 static inline int stop_machine_create(void) { return 0; }
-static inline void stop_machine_destroy(void) { }
 
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c
+++ linux/kernel/cpu.c
@@ -285,7 +285,6 @@ int __ref cpu_down(unsigned int cpu)
 
 out:
 	cpu_maps_update_done();
-	stop_machine_destroy();
 	return err;
 }
 EXPORT_SYMBOL(cpu_down);
@@ -399,7 +398,6 @@ int disable_nonboot_cpus(void)
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
 	cpu_maps_update_done();
-	stop_machine_destroy();
 	return error;
 }
 
Index: linux/kernel/module.c
===================================================================
--- linux.orig/kernel/module.c
+++ linux/kernel/module.c
@@ -731,7 +731,6 @@ SYSCALL_DEFINE2(delete_module, const cha
  out:
 	mutex_unlock(&module_mutex);
 out_stop:
-	stop_machine_destroy();
 	return ret;
 }
 
