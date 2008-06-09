Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbYFIPo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbYFIPo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYFIPos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:44:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40230 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbYFIPor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:44:47 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "OF-General" <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>
Subject: [PATCH 1/2] ibmebus: Change ibmebus_request_irq() to optionally return irq number
Date: Mon, 9 Jun 2008 17:44:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       THEMANN@de.ibm.com, TKLEIN@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091744.30930.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 arch/powerpc/kernel/ibmebus.c        |    5 ++++-
 drivers/infiniband/hw/ehca/ehca_eq.c |    4 ++--
 drivers/net/ehea/ehea_main.c         |    6 +++---
 include/asm-powerpc/ibmebus.h        |    2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 9971159..a002fdf 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -208,7 +208,7 @@ void ibmebus_unregister_driver(struct of_platform_driver *drv)
 }
 EXPORT_SYMBOL(ibmebus_unregister_driver);
 
-int ibmebus_request_irq(u32 ist, irq_handler_t handler,
+int ibmebus_request_irq(u32 ist, int *irq_number, irq_handler_t handler,
 			unsigned long irq_flags, const char *devname,
 			void *dev_id)
 {
@@ -217,6 +217,9 @@ int ibmebus_request_irq(u32 ist, irq_handler_t handler,
 	if (irq == NO_IRQ)
 		return -EINVAL;
 
+	if (irq_number)
+		*irq_number = irq;
+
 	return request_irq(irq, handler, irq_flags, devname, dev_id);
 }
 EXPORT_SYMBOL(ibmebus_request_irq);
diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index 49660df..5bc494f 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -122,7 +122,7 @@ int ehca_create_eq(struct ehca_shca *shca,
 
 	/* register interrupt handlers and initialize work queues */
 	if (type == EHCA_EQ) {
-		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
+		ret = ibmebus_request_irq(eq->ist, NULL, ehca_interrupt_eq,
 					  IRQF_DISABLED, "ehca_eq",
 					  (void *)shca);
 		if (ret < 0)
@@ -130,7 +130,7 @@ int ehca_create_eq(struct ehca_shca *shca,
 
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 	} else if (type == EHCA_NEQ) {
-		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
+		ret = ibmebus_request_irq(eq->ist, NULL, ehca_interrupt_neq,
 					  IRQF_DISABLED, "ehca_neq",
 					  (void *)shca);
 		if (ret < 0)
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 287a619..102ffeb 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -1216,7 +1216,7 @@ static int ehea_reg_interrupts(struct net_device *dev)
 	snprintf(port->int_aff_name, EHEA_IRQ_NAME_SIZE - 1, "%s-aff",
 		 dev->name);
 
-	ret = ibmebus_request_irq(port->qp_eq->attr.ist1,
+	ret = ibmebus_request_irq(port->qp_eq->attr.ist1, NULL,
 				  ehea_qp_aff_irq_handler,
 				  IRQF_DISABLED, port->int_aff_name, port);
 	if (ret) {
@@ -1234,7 +1234,7 @@ static int ehea_reg_interrupts(struct net_device *dev)
 		pr = &port->port_res[i];
 		snprintf(pr->int_send_name, EHEA_IRQ_NAME_SIZE - 1,
 			 "%s-queue%d", dev->name, i);
-		ret = ibmebus_request_irq(pr->eq->attr.ist1,
+		ret = ibmebus_request_irq(pr->eq->attr.ist1, NULL,
 					  ehea_recv_irq_handler,
 					  IRQF_DISABLED, pr->int_send_name,
 					  pr);
@@ -3414,7 +3414,7 @@ static int __devinit ehea_probe_adapter(struct of_device *dev,
 	tasklet_init(&adapter->neq_tasklet, ehea_neq_tasklet,
 		     (unsigned long)adapter);
 
-	ret = ibmebus_request_irq(adapter->neq->attr.ist1,
+	ret = ibmebus_request_irq(adapter->neq->attr.ist1, NULL,
 				  ehea_interrupt_neq, IRQF_DISABLED,
 				  "ehea_neq", adapter);
 	if (ret) {
diff --git a/include/asm-powerpc/ibmebus.h b/include/asm-powerpc/ibmebus.h
index 1a9d9ae..3a2618a 100644
--- a/include/asm-powerpc/ibmebus.h
+++ b/include/asm-powerpc/ibmebus.h
@@ -51,7 +51,7 @@ extern struct bus_type ibmebus_bus_type;
 int ibmebus_register_driver(struct of_platform_driver *drv);
 void ibmebus_unregister_driver(struct of_platform_driver *drv);
 
-int ibmebus_request_irq(u32 ist, irq_handler_t handler,
+int ibmebus_request_irq(u32 ist, int *irq_number, irq_handler_t handler,
 			unsigned long irq_flags, const char *devname,
 			void *dev_id);
 void ibmebus_free_irq(u32 ist, void *dev_id);
-- 
1.5.5

