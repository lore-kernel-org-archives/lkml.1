Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbXBNQpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbXBNQpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbXBNQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:45:09 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:65411 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbXBNQot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:44:49 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org
Subject: [PATCH 2.6.21-rc1 3/5] ehca: allow en/disabling scaling code via module parameter
Date: Wed, 14 Feb 2007 17:41:21 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, h.carstens@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141741.21722.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
here is a patch for ehca that allows users to en/disable scaling code
when loading ib_ehca module.
Thanks
Nam


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 Kconfig        |    8 --------
 ehca_classes.h |    1 +
 ehca_irq.c     |   47 +++++++++++++++++++++--------------------------
 ehca_main.c    |    4 ++++
 4 files changed, 26 insertions(+), 34 deletions(-)


diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/Kconfig infiniband_work/drivers/infiniband/hw/ehca/Kconfig
--- infiniband_orig/drivers/infiniband/hw/ehca/Kconfig  2007-02-14 14:18:16.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/Kconfig  2007-02-14 14:20:52.000000000 +0100
@@ -7,11 +7,3 @@ config INFINIBAND_EHCA
        To compile the driver as a module, choose M here. The module
        will be called ib_ehca.

-config INFINIBAND_EHCA_SCALING
-       bool "Scaling support (EXPERIMENTAL)"
-       depends on IBMEBUS && INFINIBAND_EHCA && HOTPLUG_CPU && EXPERIMENTAL
-       default y
-       ---help---
-       eHCA scaling support schedules the CQ callbacks to different CPUs.
-
-       To enable this feature choose Y here.
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h   2007-02-14 14:18:16.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h   2007-02-14 14:20:17.000000000 +0100
@@ -277,6 +277,7 @@ extern struct idr ehca_cq_idr;
 extern int ehca_static_rate;
 extern int ehca_port_act_time;
 extern int ehca_use_hp_mr;
+extern int ehca_scaling_code;

 struct ipzu_queue_resp {
        u32 qe_size;      /* queue entry size */
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.c infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.c       2007-02-14 14:18:16.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.c       2007-02-14 14:20:17.000000000 +0100
@@ -63,15 +63,11 @@
 #define ERROR_DATA_LENGTH      EHCA_BMASK_IBM(52,63)
 #define ERROR_DATA_TYPE        EHCA_BMASK_IBM(0,7)

-#ifdef CONFIG_INFINIBAND_EHCA_SCALING
-
 static void queue_comp_task(struct ehca_cq *__cq);

 static struct ehca_comp_pool* pool;
 static struct notifier_block comp_pool_callback_nb;

-#endif
-
 static inline void comp_event_callback(struct ehca_cq *cq)
 {
        if (!cq->ib_cq.comp_handler)
@@ -423,13 +419,13 @@ static inline void process_eqe(struct eh
                        return;
                }
                reset_eq_pending(cq);
-#ifdef CONFIG_INFINIBAND_EHCA_SCALING
-               queue_comp_task(cq);
-               spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-#else
-               spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-               comp_event_callback(cq);
-#endif
+               if (ehca_scaling_code) {
+                       queue_comp_task(cq);
+                       spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+               } else {
+                       spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+                       comp_event_callback(cq);
+               }
        } else {
                ehca_dbg(&shca->ib_device,
                         "Got non completion event");
@@ -508,13 +504,12 @@ void ehca_process_eq(struct ehca_shca *s
        /* call completion handler for cached eqes */
        for (i = 0; i < eqe_cnt; i++)
                if (eq->eqe_cache[i].cq) {
-#ifdef CONFIG_INFINIBAND_EHCA_SCALING
-                       spin_lock(&ehca_cq_idr_lock);
-                       queue_comp_task(eq->eqe_cache[i].cq);
-                       spin_unlock(&ehca_cq_idr_lock);
-#else
-                       comp_event_callback(eq->eqe_cache[i].cq);
-#endif
+                       if (ehca_scaling_code) {
+                               spin_lock(&ehca_cq_idr_lock);
+                               queue_comp_task(eq->eqe_cache[i].cq);
+                               spin_unlock(&ehca_cq_idr_lock);
+                       } else
+                               comp_event_callback(eq->eqe_cache[i].cq);
                } else {
                        ehca_dbg(&shca->ib_device, "Got non completion event");
                        parse_identifier(shca, eq->eqe_cache[i].eqe->entry);
@@ -540,8 +535,6 @@ void ehca_tasklet_eq(unsigned long data)
        ehca_process_eq((struct ehca_shca*)data, 1);
 }

-#ifdef CONFIG_INFINIBAND_EHCA_SCALING
-
 static inline int find_next_online_cpu(struct ehca_comp_pool* pool)
 {
        int cpu;
@@ -764,14 +757,14 @@ static int comp_pool_callback(struct not
        return NOTIFY_OK;
 }

-#endif
-
 int ehca_create_comp_pool(void)
 {
-#ifdef CONFIG_INFINIBAND_EHCA_SCALING
        int cpu;
        struct task_struct *task;

+       if (!ehca_scaling_code)
+               return 0;
+
        pool = kzalloc(sizeof(struct ehca_comp_pool), GFP_KERNEL);
        if (pool == NULL)
                return -ENOMEM;
@@ -796,16 +789,19 @@ int ehca_create_comp_pool(void)
        comp_pool_callback_nb.notifier_call = comp_pool_callback;
        comp_pool_callback_nb.priority =0;
        register_cpu_notifier(&comp_pool_callback_nb);
-#endif
+
+       printk(KERN_INFO "eHCA scaling code enabled\n");

        return 0;
 }

 void ehca_destroy_comp_pool(void)
 {
-#ifdef CONFIG_INFINIBAND_EHCA_SCALING
        int i;

+       if (!ehca_scaling_code)
+               return;
+
        unregister_cpu_notifier(&comp_pool_callback_nb);

        for (i = 0; i < NR_CPUS; i++) {
@@ -814,5 +810,4 @@ void ehca_destroy_comp_pool(void)
        }
        free_percpu(pool->cpu_comp_tasks);
        kfree(pool);
-#endif
 }
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_main.c infiniband_work/drivers/infiniband/hw/ehca/ehca_main.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_main.c      2007-02-14 14:18:16.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_main.c      2007-02-14 14:20:17.000000000 +0100
@@ -62,6 +62,7 @@ int ehca_use_hp_mr     = 0;
 int ehca_port_act_time = 30;
 int ehca_poll_all_eqs  = 1;
 int ehca_static_rate   = -1;
+int ehca_scaling_code  = 1;

 module_param_named(open_aqp1,     ehca_open_aqp1,     int, 0);
 module_param_named(debug_level,   ehca_debug_level,   int, 0);
@@ -71,6 +72,7 @@ module_param_named(use_hp_mr,     ehca_u
 module_param_named(port_act_time, ehca_port_act_time, int, 0);
 module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  int, 0);
 module_param_named(static_rate,   ehca_static_rate,   int, 0);
+module_param_named(scaling_code,   ehca_scaling_code,   int, 0);

 MODULE_PARM_DESC(open_aqp1,
                 "AQP1 on startup (0: no (default), 1: yes)");
@@ -91,6 +93,8 @@ MODULE_PARM_DESC(poll_all_eqs,
                 " (0: no, 1: yes (default))");
 MODULE_PARM_DESC(static_rate,
                 "set permanent static rate (default: disabled)");
+MODULE_PARM_DESC(scaling_code,
+                "set scaling code (0: disabled, 1: enabled/default)");

 spinlock_t ehca_qp_idr_lock;
 spinlock_t ehca_cq_idr_lock;
