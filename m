Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbXBNQpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbXBNQpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbXBNQpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:45:06 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:42558 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbXBNQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:45:04 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org
Subject: [PATCH 2.6.21-rc1 4/5] ehca: replace yield() by wait_for_completion()
Date: Wed, 14 Feb 2007 17:41:35 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, h.carstens@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141741.35444.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this patch removes yield() and uses wait_for_completion() in order
to wait for running completion handlers finished before destroying
associated completion queue.
Thanks
Nam


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_classes.h |    3 +++
 ehca_cq.c      |    3 ++-
 ehca_irq.c     |    6 +++++-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h   2007-02-14 13:52:49.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h   2007-02-14 13:52:06.000000000 +0100
@@ -52,6 +52,8 @@ struct ehca_mw;
 struct ehca_pd;
 struct ehca_av;

+#include <linux/completion.h>
+
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>

@@ -154,6 +156,7 @@ struct ehca_cq {
        struct hlist_head qp_hashtab[QP_HASHTAB_LEN];
        struct list_head entry;
        u32 nr_callbacks;
+       struct completion zero_callbacks;
        spinlock_t task_lock;
        u32 ownpid;
        /* mmap counter for resources mapped into user space */
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_cq.c infiniband_work/drivers/infiniband/hw/ehca/ehca_cq.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_cq.c        2007-02-14 13:52:49.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_cq.c        2007-02-14 13:52:06.000000000 +0100
@@ -147,6 +147,7 @@ struct ib_cq *ehca_create_cq(struct ib_d
        spin_lock_init(&my_cq->spinlock);
        spin_lock_init(&my_cq->cb_lock);
        spin_lock_init(&my_cq->task_lock);
+       init_completion(&my_cq->zero_callbacks);
        my_cq->ownpid = current->tgid;

        cq = &my_cq->ib_cq;
@@ -332,7 +333,7 @@ int ehca_destroy_cq(struct ib_cq *cq)
        spin_lock_irqsave(&ehca_cq_idr_lock, flags);
        while (my_cq->nr_callbacks) {
                spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-               yield();
+               wait_for_completion(&my_cq->zero_callbacks);
                spin_lock_irqsave(&ehca_cq_idr_lock, flags);
        }

diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.c infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.c       2007-02-14 13:52:49.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.c       2007-02-14 13:52:06.000000000 +0100
@@ -605,6 +605,7 @@ static void run_comp_task(struct ehca_cp
        spin_lock_irqsave(&cct->task_lock, flags);

        while (!list_empty(&cct->cq_list)) {
+               int is_complete = 0;
                cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
                spin_unlock_irqrestore(&cct->task_lock, flags);
                comp_event_callback(cq);
@@ -612,11 +613,14 @@ static void run_comp_task(struct ehca_cp

                spin_lock(&cq->task_lock);
                cq->nr_callbacks--;
-               if (cq->nr_callbacks == 0) {
+               is_complete = (cq->nr_callbacks == 0);
+               if (is_complete) {
                        list_del_init(cct->cq_list.next);
                        cct->cq_jobs--;
                }
                spin_unlock(&cq->task_lock);
+               if (is_complete) /* wake up waiting destroy_cq() */
+                       complete(&cq->zero_callbacks);
        }

        spin_unlock_irqrestore(&cct->task_lock, flags);
