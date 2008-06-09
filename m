Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYFIPpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYFIPpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYFIPpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:45:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57432 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYFIPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:45:42 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       general@lists.openfabrics.org, LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>
Subject: [PATCH 2/2] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
Date: Mon, 9 Jun 2008 17:45:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: hnguyen@de.ibm.com, fenkes@de.ibm.com, raisch@de.ibm.com,
       TKLEIN@de.ibm.com, THEMANN@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091745.19147.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 +
 drivers/infiniband/hw/ehca/ehca_eq.c      |    6 ++++--
 drivers/infiniband/hw/ehca/ehca_main.c    |   12 ++++++++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 1e9e99a..4de363d 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -86,6 +86,7 @@ struct ehca_eq {
 	u32 ist;
 	spinlock_t irq_spinlock;
 	struct ehca_eqe_cache_entry eqe_cache[EHCA_EQE_CACHE_SIZE];
+	int irq_number;
 };
 
 struct ehca_sma_attr {
diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index 5bc494f..b70e5e5 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -122,7 +122,8 @@ int ehca_create_eq(struct ehca_shca *shca,
 
 	/* register interrupt handlers and initialize work queues */
 	if (type == EHCA_EQ) {
-		ret = ibmebus_request_irq(eq->ist, NULL, ehca_interrupt_eq,
+		ret = ibmebus_request_irq(eq->ist, &eq->irq_number,
+					  ehca_interrupt_eq,
 					  IRQF_DISABLED, "ehca_eq",
 					  (void *)shca);
 		if (ret < 0)
@@ -130,7 +131,8 @@ int ehca_create_eq(struct ehca_shca *shca,
 
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 	} else if (type == EHCA_NEQ) {
-		ret = ibmebus_request_irq(eq->ist, NULL, ehca_interrupt_neq,
+		ret = ibmebus_request_irq(eq->ist, &eq->irq_number,
+					  ehca_interrupt_neq,
 					  IRQF_DISABLED, "ehca_neq",
 					  (void *)shca);
 		if (ret < 0)
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 482103e..d713317 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -44,6 +44,7 @@
 #include <linux/slab.h>
 #endif
 
+#include <linux/irq.h>
 #include "ehca_classes.h"
 #include "ehca_iverbs.h"
 #include "ehca_mrmw.h"
@@ -937,6 +938,8 @@ static struct of_platform_driver ehca_driver = {
 void ehca_poll_eqs(unsigned long data)
 {
 	struct ehca_shca *shca;
+	int irq;
+	irq_desc_t *desc;
 
 	spin_lock(&shca_list_lock);
 	list_for_each_entry(shca, &shca_list, shca_list) {
@@ -955,8 +958,13 @@ void ehca_poll_eqs(unsigned long data)
 				spin_unlock_irqrestore(&eq->spinlock, flags);
 				max--;
 			} while (q_ofs == q_ofs2 && max > 0);
-			if (q_ofs == q_ofs2)
-				ehca_process_eq(shca, 0);
+			if (q_ofs == q_ofs2) {
+				irq =  shca->eq.irq_number;
+				desc = get_irq_desc(irq);
+				if (desc->chip && desc->chip->eoi)
+					desc->chip->eoi(irq);
+				tasklet_hi_schedule(&shca->eq.interrupt_task);
+			}
 		}
 	}
 	mod_timer(&poll_eqs_timer, round_jiffies(jiffies + HZ));
-- 
1.5.5

