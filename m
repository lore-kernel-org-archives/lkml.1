Return-Path: <linux-kernel-owner+w=401wt.eu-S965589AbXAWXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbXAWXOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965590AbXAWXOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:14:18 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:36207 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965589AbXAWXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:14:17 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, hch@infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, openfabrics-ewg@openib.org
Subject: [PATCH 2.6.21 1/4] ehca: fix improper use of yield with spinlock held
Date: Wed, 24 Jan 2007 00:10:36 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701240010.37540.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch for ehca_cq.c that fixes improper use of yield
with spinlock held.
Thanks
Nam


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_cq.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)


diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_cq.c infiniband_work/drivers/infiniband/hw/ehca/ehca_cq.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_cq.c	2007-01-19 19:40:32.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_cq.c	2007-01-20 00:15:34.000000000 +0100
@@ -344,8 +344,11 @@ int ehca_destroy_cq(struct ib_cq *cq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-	while (my_cq->nr_callbacks)
+	while (my_cq->nr_callbacks) {
+		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 		yield();
+		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+	}
 
 	idr_remove(&ehca_cq_idr, my_cq->token);
 	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
