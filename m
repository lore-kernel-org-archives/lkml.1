Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXDLRwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXDLRwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030628AbXDLRwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:52:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28734 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030622AbXDLRwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:52:09 -0400
X-IronPort-AV: i="4.14,403,1170662400"; 
   d="scan'208"; a="135101800:sNHT45156555"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Jeff Garzik <jeff@garzik.org>
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Apr 2007 10:52:08 -0700
Message-ID: <adaabxdh453.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2007 17:52:08.0690 (UTC) FILETIME=[4A4BDD20:01C77D2B]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will fix up some problems with drivers/infiniband/hw/cxgb3 caused
by a change to drivers/net/cxgb3 that you just pulled.

Steve Wise (1):
      RDMA/cxgb3: Add set_tcb_rpl_handler

 drivers/infiniband/hw/cxgb3/iwch_cm.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index d0ed1d3..2d2de9b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -2026,6 +2026,17 @@ static int sched(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	return 0;
 }
 
+static int set_tcb_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
+{
+	struct cpl_set_tcb_rpl *rpl = cplhdr(skb);
+
+	if (rpl->status != CPL_ERR_NONE) {
+		printk(KERN_ERR MOD "Unexpected SET_TCB_RPL status %u "
+		       "for tid %u\n", rpl->status, GET_TID(rpl));
+	}
+	return CPL_RET_BUF_DONE;
+}
+
 int __init iwch_cm_init(void)
 {
 	skb_queue_head_init(&rxq);
@@ -2053,6 +2064,7 @@ int __init iwch_cm_init(void)
 	t3c_handlers[CPL_ABORT_REQ_RSS] = sched;
 	t3c_handlers[CPL_RDMA_TERMINATE] = sched;
 	t3c_handlers[CPL_RDMA_EC_STATUS] = sched;
+	t3c_handlers[CPL_SET_TCB_RPL] = set_tcb_rpl;
 
 	/*
 	 * These are the real handlers that are called from a
