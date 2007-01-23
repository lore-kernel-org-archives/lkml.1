Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbXAWPKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbXAWPKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXAWPKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:10:10 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47392 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbXAWPKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:10:08 -0500
X-IronPort-AV: i="4.13,226,1167638400"; 
   d="scan'208"; a="104553381:sNHT46464624"
To: torvalds@osdl.org
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 23 Jan 2007 07:10:07 -0800
Message-ID: <ada3b61g4og.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jan 2007 15:10:07.0532 (UTC) FILETIME=[91669EC0:01C73F00]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will pick up three small fixes:

Hoang-Nam Nguyen (2):
      IB/ehca: Fix improper use of yield() with spinlock held
      IB/ehca: Fix mismatched spin_unlock in irq handler

Ishai Rabinovitz (1):
      IB/srp: Check match_strdup() return

 drivers/infiniband/hw/ehca/ehca_cq.c  |    5 ++++-
 drivers/infiniband/hw/ehca/ehca_irq.c |    3 ++-
 drivers/infiniband/ulp/srp/ib_srp.c   |   20 ++++++++++++++++++++
 3 files changed, 26 insertions(+), 2 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 93995b6..6074c89 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
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
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index e7209af..c069be8 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -440,7 +440,8 @@ void ehca_tasklet_eq(unsigned long data)
 					cq = idr_find(&ehca_cq_idr, token);
 
 					if (cq == NULL) {
-						spin_unlock(&ehca_cq_idr_lock);
+						spin_unlock_irqrestore(&ehca_cq_idr_lock,
+								       flags);
 						break;
 					}
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cdecbf5..72611fd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1621,18 +1621,30 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 		switch (token) {
 		case SRP_OPT_ID_EXT:
 			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			target->id_ext = cpu_to_be64(simple_strtoull(p, NULL, 16));
 			kfree(p);
 			break;
 
 		case SRP_OPT_IOC_GUID:
 			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			target->ioc_guid = cpu_to_be64(simple_strtoull(p, NULL, 16));
 			kfree(p);
 			break;
 
 		case SRP_OPT_DGID:
 			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			if (strlen(p) != 32) {
 				printk(KERN_WARNING PFX "bad dest GID parameter '%s'\n", p);
 				kfree(p);
@@ -1656,6 +1668,10 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_SERVICE_ID:
 			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			target->service_id = cpu_to_be64(simple_strtoull(p, NULL, 16));
 			kfree(p);
 			break;
@@ -1693,6 +1709,10 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_INITIATOR_EXT:
 			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			target->initiator_ext = cpu_to_be64(simple_strtoull(p, NULL, 16));
 			kfree(p);
 			break;
