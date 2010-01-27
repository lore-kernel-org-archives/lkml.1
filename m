Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710Ab0A0RCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0A0RCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691Ab0A0RCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:02:01 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:37968 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0A0RB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:01:59 -0500
Date: Wed, 27 Jan 2010 18:01:56 +0100
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, Linux RDMA <linux-rdma@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
       David Wilder <wilder@us.ibm.com>
Subject: [PATCH 1/2] ib/ehca: Do not turn off irqs in tasklet context
Message-ID: <20100127180156.795056a5@alex-laptop>
In-Reply-To: <20100127180035.779b24d1@alex-laptop>
References: <20100127180035.779b24d1@alex-laptop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq_spinlock is only taken in tasklet context, so it is safe not to
disable hardware interrupts.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_irq.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -548,11 +548,10 @@ void ehca_process_eq(struct ehca_shca *s
 	struct ehca_eq *eq = &shca->eq;
 	struct ehca_eqe_cache_entry *eqe_cache = eq->eqe_cache;
 	u64 eqe_value, ret;
-	unsigned long flags;
 	int eqe_cnt, i;
 	int eq_empty = 0;
 
-	spin_lock_irqsave(&eq->irq_spinlock, flags);
+	spin_lock(&eq->irq_spinlock);
 	if (is_irq) {
 		const int max_query_cnt = 100;
 		int query_cnt = 0;
@@ -643,7 +642,7 @@ void ehca_process_eq(struct ehca_shca *s
 	} while (1);
 
 unlock_irq_spinlock:
-	spin_unlock_irqrestore(&eq->irq_spinlock, flags);
+	spin_unlock(&eq->irq_spinlock);
 }
 
 void ehca_tasklet_eq(unsigned long data)
