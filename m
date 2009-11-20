Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbZKTJcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbZKTJcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZKTJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:32:14 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:40757 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZKTJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:32:12 -0500
Date: Fri, 20 Nov 2009 10:32:13 +0100
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, Linux RDMA <linux-rdma@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: [PATCH resend] ib/ehca: rework destroy_eq()
Message-ID: <20091120103213.13b7ba81@alex-laptop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ibmebus_free_irq() function, which might sleep, was called with
interrupts disabled. To ship around this, make sure that no interrupts
are running by killing the interrupt tasklet. Also lock the shca_list_lock to
protect against the poll_eqs_timer running concurrently.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
Hi Roland,

seems like I used your old mail address and I forgot to add the linux-rdma
list.

Please apply this for your "next" tree, thanks.

 drivers/infiniband/hw/ehca/ehca_classes.h |    1 +
 drivers/infiniband/hw/ehca/ehca_eq.c      |    9 ++++++---
 drivers/infiniband/hw/ehca/ehca_main.c    |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_eq.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -169,12 +169,15 @@ int ehca_destroy_eq(struct ehca_shca *sh
 	unsigned long flags;
 	u64 h_ret;

-	spin_lock_irqsave(&eq->spinlock, flags);
 	ibmebus_free_irq(eq->ist, (void *)shca);

-	h_ret = hipz_h_destroy_eq(shca->ipz_hca_handle, eq);
+	spin_lock_irqsave(&shca_list_lock, flags);
+	eq->is_initialized = 0;
+	spin_unlock_irqrestore(&shca_list_lock, flags);
+
+	tasklet_kill(&eq->interrupt_task);

-	spin_unlock_irqrestore(&eq->spinlock, flags);
+	h_ret = hipz_h_destroy_eq(shca->ipz_hca_handle, eq);

 	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "Can't free EQ resources.");
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_classes.h
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -375,6 +375,7 @@ extern rwlock_t ehca_qp_idr_lock;
 extern rwlock_t ehca_cq_idr_lock;
 extern struct idr ehca_qp_idr;
 extern struct idr ehca_cq_idr;
+extern spinlock_t shca_list_lock;

 extern int ehca_static_rate;
 extern int ehca_port_act_time;
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_main.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_main.c
@@ -123,7 +123,7 @@ DEFINE_IDR(ehca_qp_idr);
 DEFINE_IDR(ehca_cq_idr);

 static LIST_HEAD(shca_list); /* list of all registered ehcas */
-static DEFINE_SPINLOCK(shca_list_lock);
+DEFINE_SPINLOCK(shca_list_lock);

 static struct timer_list poll_eqs_timer;
