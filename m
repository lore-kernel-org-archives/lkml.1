Return-Path: <linux-kernel-owner+w=401wt.eu-S934273AbXHVXPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273AbXHVXPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763660AbXHVXPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:15:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53691 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763601AbXHVXPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:15:41 -0400
Date: Thu, 23 Aug 2007 04:58:30 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Roland Dreier <rolandd@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ehca_irq: Misc cpuinit section annotations and #ifdef
 cleanups
Message-ID: <alpine.LFD.0.999.0708230456100.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Replace {un}register_cpu_notifier with {un}register_hotcpu_notifier
  thereby losing a couple of #ifdef HOTPLUG_CPU pairs.
* Move comp_pool_callback_nb declaration to below that of callback
  function so that initialization of .notifier_call and .priority can
  occur at build time itself and not runtime.
* Mark the notifier_block (and callback function, and another static
  function used by it) as __cpuinit{data} for the sake of consistency
  and remove enclosing #ifdef. (This may increase size for modular
  build of this module, however, because these are no longer dropped
  unconditionally now.)

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/infiniband/hw/ehca/ehca_irq.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index ee06d8b..8137de6 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -69,9 +69,6 @@
 static void queue_comp_task(struct ehca_cq *__cq);
 
 static struct ehca_comp_pool *pool;
-#ifdef CONFIG_HOTPLUG_CPU
-static struct notifier_block comp_pool_callback_nb;
-#endif
 
 static inline void comp_event_callback(struct ehca_cq *cq)
 {
@@ -746,9 +743,7 @@ static void destroy_comp_task(struct ehca_comp_pool *pool,
 		kthread_stop(task);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static void take_over_work(struct ehca_comp_pool *pool,
-			   int cpu)
+static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
 {
 	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 	LIST_HEAD(list);
@@ -771,9 +766,9 @@ static void take_over_work(struct ehca_comp_pool *pool,
 
 }
 
-static int comp_pool_callback(struct notifier_block *nfb,
-			      unsigned long action,
-			      void *hcpu)
+static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
+					unsigned long action,
+					void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct ehca_cpu_comp_task *cct;
@@ -819,7 +814,11 @@ static int comp_pool_callback(struct notifier_block *nfb,
 
 	return NOTIFY_OK;
 }
-#endif
+
+static struct notifier_block comp_pool_callback_nb __cpuinitdata = {
+	.notifier_call	= comp_pool_callback,
+	.priority	= 0,
+};
 
 int ehca_create_comp_pool(void)
 {
@@ -850,11 +849,7 @@ int ehca_create_comp_pool(void)
 		}
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
-	comp_pool_callback_nb.notifier_call = comp_pool_callback;
-	comp_pool_callback_nb.priority = 0;
-	register_cpu_notifier(&comp_pool_callback_nb);
-#endif
+	register_hotcpu_notifier(&comp_pool_callback_nb);
 
 	printk(KERN_INFO "eHCA scaling code enabled\n");
 
@@ -868,9 +863,7 @@ void ehca_destroy_comp_pool(void)
 	if (!ehca_scaling_code)
 		return;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	unregister_cpu_notifier(&comp_pool_callback_nb);
-#endif
+	unregister_hotcpu_notifier(&comp_pool_callback_nb);
 
 	for (i = 0; i < NR_CPUS; i++) {
 		if (cpu_online(i))
