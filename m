Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbXBNQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbXBNQo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbXBNQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:44:28 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:42520 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbXBNQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:44:16 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org
Subject: [PATCH 2.6.21-rc1 1/5] ehca: reworked irq handler to avoid/reduce missed irq events
Date: Wed, 14 Feb 2007 17:40:47 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, h.carstens@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141740.48286.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
here is a patch for ehca with the reworked irq handler.
Thanks
Nam


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_classes.h |   18 +++--
 ehca_eq.c      |    1 
 ehca_irq.c     |  200 ++++++++++++++++++++++++++++++++++++---------------------
 ehca_irq.h     |    1 
 ehca_main.c    |   24 +++++-
 ipz_pt_fn.h    |    9 ++
 6 files changed, 172 insertions(+), 81 deletions(-)


diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h   2007-02-11 21:31:06.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h   2007-02-14 12:53:41.000000000 +0100
@@ -42,8 +42,6 @@
 #ifndef __EHCA_CLASSES_H__
 #define __EHCA_CLASSES_H__

-#include "ehca_classes.h"
-#include "ipz_pt_fn.h"

 struct ehca_module;
 struct ehca_qp;
@@ -54,14 +52,22 @@ struct ehca_mw;
 struct ehca_pd;
 struct ehca_av;

+#include <rdma/ib_verbs.h>
+#include <rdma/ib_user_verbs.h>
+
 #ifdef CONFIG_PPC64
 #include "ehca_classes_pSeries.h"
 #endif
+#include "ipz_pt_fn.h"
+#include "ehca_qes.h"
+#include "ehca_irq.h"

-#include <rdma/ib_verbs.h>
-#include <rdma/ib_user_verbs.h>
+#define EHCA_EQE_CACHE_SIZE 20

-#include "ehca_irq.h"
+struct ehca_eqe_cache_entry {
+       struct ehca_eqe *eqe;
+       struct ehca_cq *cq;
+};

 struct ehca_eq {
        u32 length;
@@ -74,6 +80,8 @@ struct ehca_eq {
        spinlock_t spinlock;
        struct tasklet_struct interrupt_task;
        u32 ist;
+       spinlock_t irq_spinlock;
+       struct ehca_eqe_cache_entry eqe_cache[EHCA_EQE_CACHE_SIZE];
 };

 struct ehca_sport {
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_eq.c infiniband_work/drivers/infiniband/hw/ehca/ehca_eq.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_eq.c        2007-02-11 21:31:06.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_eq.c        2007-02-14 12:53:40.000000000 +0100
@@ -61,6 +61,7 @@ int ehca_create_eq(struct ehca_shca *shc
        struct ib_device *ib_dev = &shca->ib_device;

        spin_lock_init(&eq->spinlock);
+       spin_lock_init(&eq->irq_spinlock);
        eq->is_initialized = 0;

        if (type != EHCA_EQ && type != EHCA_NEQ) {
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.c infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.c       2007-02-11 21:36:12.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.c       2007-02-14 13:07:54.000000000 +0100
@@ -401,87 +400,143 @@ irqreturn_t ehca_interrupt_eq(int irq, v
        return IRQ_HANDLED;
 }

-void ehca_tasklet_eq(unsigned long data)
-{
-       struct ehca_shca *shca = (struct ehca_shca*)data;
-       struct ehca_eqe *eqe;
-       int int_state;
-       int query_cnt = 0;

-       do {
-               eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->eq);
+static inline void process_eqe(struct ehca_shca *shca, struct ehca_eqe *eqe)
+{
+       u64 eqe_value;
+       u32 token;
+       unsigned long flags;
+       struct ehca_cq *cq;
+       eqe_value = eqe->entry;
+       ehca_dbg(&shca->ib_device, "eqe_value=%lx", eqe_value);
+       if (EHCA_BMASK_GET(EQE_COMPLETION_EVENT, eqe_value)) {
+               ehca_dbg(&shca->ib_device, "... completion event");
+               token = EHCA_BMASK_GET(EQE_CQ_TOKEN, eqe_value);
+               spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+               cq = idr_find(&ehca_cq_idr, token);
+               if (cq == NULL) {
+                       spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+                       ehca_err(&shca->ib_device,
+                                "Invalid eqe for non-existing cq token=%x",
+                                token);
+                       return;
+               }
+               reset_eq_pending(cq);
+#ifdef CONFIG_INFINIBAND_EHCA_SCALING
+               queue_comp_task(cq);
+               spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+#else
+               spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+               comp_event_callback(cq);
+#endif
+       } else {
+               ehca_dbg(&shca->ib_device,
+                        "Got non completion event");
+               parse_identifier(shca, eqe_value);
+       }
+}

-               if ((shca->hw_level >= 2) && eqe)
-                       int_state = 1;
-               else
-                       int_state = 0;
+void ehca_process_eq(struct ehca_shca *shca, int is_irq)
+{
+       struct ehca_eq *eq = &shca->eq;
+       struct ehca_eqe_cache_entry *eqe_cache = eq->eqe_cache;
+       u64 eqe_value;
+       unsigned long flags;
+       int eqe_cnt, i;
+       int eq_empty = 0;

-               while ((int_state == 1) || eqe) {
-                       while (eqe) {
-                               u64 eqe_value = eqe->entry;
-
-                               ehca_dbg(&shca->ib_device,
-                                        "eqe_value=%lx", eqe_value);
-
-                               /* TODO: better structure */
-                               if (EHCA_BMASK_GET(EQE_COMPLETION_EVENT,
-                                                  eqe_value)) {
-                                       unsigned long flags;
-                                       u32 token;
-                                       struct ehca_cq *cq;
-
-                                       ehca_dbg(&shca->ib_device,
-                                                "... completion event");
-                                       token =
-                                               EHCA_BMASK_GET(EQE_CQ_TOKEN,
-                                                              eqe_value);
-                                       spin_lock_irqsave(&ehca_cq_idr_lock,
-                                                         flags);
-                                       cq = idr_find(&ehca_cq_idr, token);
-
-                                       if (cq == NULL) {
-                                               spin_unlock_irqrestore(&ehca_cq_idr_lock,
-                                                                      flags);
-                                               break;
-                                       }
+       spin_lock_irqsave(&eq->irq_spinlock, flags);
+       if (is_irq) {
+               const int max_query_cnt = 100;
+               int query_cnt = 0;
+               int int_state = 1;
+               do {
+                       int_state = hipz_h_query_int_state(
+                               shca->ipz_hca_handle, eq->ist);
+                       query_cnt++;
+                       iosync();
+               } while (int_state && query_cnt < max_query_cnt);
+               if (unlikely((query_cnt == max_query_cnt)))
+                       ehca_dbg(&shca->ib_device, "int_state=%x query_cnt=%x",
+                                int_state, query_cnt);
+       }

-                                       reset_eq_pending(cq);
+       /* read out all eqes */
+       eqe_cnt = 0;
+       do {
+               u32 token;
+               eqe_cache[eqe_cnt].eqe =
+                       (struct ehca_eqe *)ehca_poll_eq(shca, eq);
+               if (!eqe_cache[eqe_cnt].eqe)
+                       break;
+               eqe_value = eqe_cache[eqe_cnt].eqe->entry;
+               if (EHCA_BMASK_GET(EQE_COMPLETION_EVENT, eqe_value)) {
+                       token = EHCA_BMASK_GET(EQE_CQ_TOKEN, eqe_value);
+                       spin_lock(&ehca_cq_idr_lock);
+                       eqe_cache[eqe_cnt].cq = idr_find(&ehca_cq_idr, token);
+                       if (!eqe_cache[eqe_cnt].cq) {
+                               spin_unlock(&ehca_cq_idr_lock);
+                               ehca_err(&shca->ib_device,
+                                        "Invalid eqe for non-existing cq "
+                                        "token=%x", token);
+                               continue;
+                       }
+                       spin_unlock(&ehca_cq_idr_lock);
+               } else
+                       eqe_cache[eqe_cnt].cq = NULL;
+               eqe_cnt++;
+       } while (eqe_cnt < EHCA_EQE_CACHE_SIZE);
+       if (!eqe_cnt) {
+               if (is_irq)
+                       ehca_dbg(&shca->ib_device,
+                                "No eqe found for irq event");
+               goto unlock_irq_spinlock;
+       } else if (!is_irq)
+               ehca_dbg(&shca->ib_device, "deadman found %x eqe", eqe_cnt);
+       if (unlikely(eqe_cnt == EHCA_EQE_CACHE_SIZE))
+               ehca_dbg(&shca->ib_device, "too many eqes for one irq event");
+       /* enable irq for new packets */
+       for (i = 0; i < eqe_cnt; i++) {
+               if (eq->eqe_cache[i].cq)
+                       reset_eq_pending(eq->eqe_cache[i].cq);
+       }
+       /* check eq */
+       spin_lock(&eq->spinlock);
+       eq_empty = (!ipz_eqit_eq_peek_valid(&shca->eq.ipz_queue));
+       spin_unlock(&eq->spinlock);
+       /* call completion handler for cached eqes */
+       for (i = 0; i < eqe_cnt; i++)
+               if (eq->eqe_cache[i].cq) {
 #ifdef CONFIG_INFINIBAND_EHCA_SCALING
-                                       queue_comp_task(cq);
-                                       spin_unlock_irqrestore(&ehca_cq_idr_lock,
-                                                              flags);
+                       spin_lock(&ehca_cq_idr_lock);
+                       queue_comp_task(eq->eqe_cache[i].cq);
+                       spin_unlock(&ehca_cq_idr_lock);
 #else
-                                       spin_unlock_irqrestore(&ehca_cq_idr_lock,
-                                                              flags);
-                                       comp_event_callback(cq);
+                       comp_event_callback(eq->eqe_cache[i].cq);
 #endif
-                               } else {
-                                       ehca_dbg(&shca->ib_device,
-                                                "... non completion event");
-                                       parse_identifier(shca, eqe_value);
-                               }
-                               eqe =
-                                       (struct ehca_eqe *)ehca_poll_eq(shca,
-                                                                   &shca->eq);
-                       }
-
-
-                       if (shca->hw_level >= 2) {
-                               int_state =
-                                   hipz_h_query_int_state(shca->ipz_hca_handle,
-                                                          shca->eq.ist);
-                               query_cnt++;
-                               iosync();
-                               if (query_cnt >= 100) {
-                                       query_cnt = 0;
-                                       int_state = 0;
-                               }
-                       }
-                       eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->eq);
-
+               } else {
+                       ehca_dbg(&shca->ib_device, "Got non completion event");
+                       parse_identifier(shca, eq->eqe_cache[i].eqe->entry);
                }
-       } while (int_state != 0);
+       /* poll eq if not empty */
+       if (eq_empty)
+               goto unlock_irq_spinlock;
+       do {
+               struct ehca_eqe *eqe;
+               eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->eq);
+               if (!eqe)
+                       break;
+               process_eqe(shca, eqe);
+               eqe_cnt++;
+       } while (1);

-       return;
+ unlock_irq_spinlock:
+       spin_unlock_irqrestore(&eq->irq_spinlock, flags);
+}
+
+void ehca_tasklet_eq(unsigned long data)
+{
+       ehca_process_eq((struct ehca_shca*)data, 1);
 }

 #ifdef CONFIG_INFINIBAND_EHCA_SCALING
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.h infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.h
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.h       2007-02-11 21:31:06.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.h       2007-02-14 12:53:40.000000000 +0100
@@ -56,6 +56,7 @@ void ehca_tasklet_neq(unsigned long data

 irqreturn_t ehca_interrupt_eq(int irq, void *dev_id);
 void ehca_tasklet_eq(unsigned long data);
+void ehca_process_eq(struct ehca_shca *shca, int is_irq);

 struct ehca_cpu_comp_task {
        wait_queue_head_t wait_queue;
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_main.c infiniband_work/drivers/infiniband/hw/ehca/ehca_main.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_main.c      2007-02-11 21:31:06.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_main.c      2007-02-14 12:53:41.000000000 +0100
@@ -52,7 +52,7 @@
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
 MODULE_DESCRIPTION("IBM eServer HCA InfiniBand Device Driver");
-MODULE_VERSION("SVNEHCA_0020");
+MODULE_VERSION("SVNEHCA_0021");

 int ehca_open_aqp1     = 0;
 int ehca_debug_level   = 0;
@@ -778,8 +777,24 @@ void ehca_poll_eqs(unsigned long data)

        spin_lock(&shca_list_lock);
        list_for_each_entry(shca, &shca_list, shca_list) {
-               if (shca->eq.is_initialized)
-                       ehca_tasklet_eq((unsigned long)(void*)shca);
+               if (shca->eq.is_initialized) {
+                       /* call deadman proc only if eq ptr does not change */
+                       struct ehca_eq *eq = &shca->eq;
+                       int max = 3;
+                       volatile u64 q_ofs, q_ofs2;
+                       u64 flags;
+                       spin_lock_irqsave(&eq->spinlock, flags);
+                       q_ofs = eq->ipz_queue.current_q_offset;
+                       spin_unlock_irqrestore(&eq->spinlock, flags);
+                       do {
+                               spin_lock_irqsave(&eq->spinlock, flags);
+                               q_ofs2 = eq->ipz_queue.current_q_offset;
+                               spin_unlock_irqrestore(&eq->spinlock, flags);
+                               max--;
+                       } while (q_ofs == q_ofs2 && max > 0);
+                       if (q_ofs == q_ofs2)
+                               ehca_process_eq(shca, 0);
+               }
        }
        mod_timer(&poll_eqs_timer, jiffies + HZ);
        spin_unlock(&shca_list_lock);
@@ -790,7 +805,7 @@ int __init ehca_module_init(void)
        int ret;

        printk(KERN_INFO "eHCA Infiniband Device Driver "
-                        "(Rel.: SVNEHCA_0020)\n");
+                        "(Rel.: SVNEHCA_0021)\n");
        idr_init(&ehca_qp_idr);
        idr_init(&ehca_cq_idr);
        spin_lock_init(&ehca_qp_idr_lock);
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ipz_pt_fn.h infiniband_work/drivers/infiniband/hw/ehca/ipz_pt_fn.h
--- infiniband_orig/drivers/infiniband/hw/ehca/ipz_pt_fn.h      2007-02-11 21:31:06.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ipz_pt_fn.h      2007-02-14 12:53:40.000000000 +0100
@@ -247,6 +247,15 @@ static inline void *ipz_eqit_eq_get_inc_
        return ret;
 }

+static inline void *ipz_eqit_eq_peek_valid(struct ipz_queue *queue)
+{
+       void *ret = ipz_qeit_get(queue);
+       u32 qe = *(u8 *) ret;
+       if ((qe >> 7) != (queue->toggle_state & 1))
+               return NULL;
+       return ret;
+}
+
 /* returns address (GX) of first queue entry */
 static inline u64 ipz_qpt_get_firstpage(struct ipz_qpt *qpt)
 {
