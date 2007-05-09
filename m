Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbXEILth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbXEILth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbXEILsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:48:36 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:6058 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbXEILsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:48:35 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 4/6] IB/ehca: remove _irqsave, move #ifdef
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Wed, 9 May 2007 13:48:20 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705091348.20808.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- In ehca_process_eq(), we're IRQ safe throughout the whole function, so we
  don't need another _irqsave in the middle of flight.

- take_over_work() is only called by comp_pool_callback(), so it can move
  into the same #ifdef block.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index f284be1..f172013 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -517,12 +517,11 @@ void ehca_process_eq(struct ehca_shca *s
 			else {
 				struct ehca_cq *cq = eq->eqe_cache[i].cq;
 				comp_event_callback(cq);
-				spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+				spin_lock(&ehca_cq_idr_lock);
 				cq->nr_events--;
 				if (!cq->nr_events)
 					wake_up(&cq->wait_completion);
-				spin_unlock_irqrestore(&ehca_cq_idr_lock,
-						       flags);
+				spin_unlock(&ehca_cq_idr_lock);
 			}
 		} else {
 			ehca_dbg(&shca->ib_device, "Got non completion event");
@@ -711,6 +710,7 @@ static void destroy_comp_task(struct ehc
 		kthread_stop(task);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 static void take_over_work(struct ehca_comp_pool *pool,
 			   int cpu)
 {
@@ -735,7 +735,6 @@ static void take_over_work(struct ehca_c
 
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int comp_pool_callback(struct notifier_block *nfb,
 			      unsigned long action,
 			      void *hcpu)
-- 
1.4.2.1


