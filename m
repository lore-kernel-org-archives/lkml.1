Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYC1R22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYC1R22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYC1R2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:28:20 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:2697 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYC1R2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:28:19 -0400
X-IronPort-AV: E=Sophos;i="4.25,571,1199692800"; 
   d="scan'208";a="18946263"
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.25] RDMA/cxgb3: Program hardware IRD with correct value
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 28 Mar 2008 10:28:17 -0700
Message-ID: <adaiqz6kbbi.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Mar 2008 17:28:18.0020 (UTC) FILETIME=[1C8B3240:01C890F9]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of a typo in iwch_accept_cr(), the cxgb3 connection handling
code programs the hardware IRD (incoming RDMA read queue depth) with
the value that is passed in for the ORD (outgoing RDMA read queue
depth).  In particular this means that if an application passes in IRD
> 0 and ORD = 0 (which is a completely sane and valid thing to do for
an app that expects only incoming RDMA read requests), then the
hardware will end up programmed with IRD = 0 and the app will fail in
a mysterious way.

Fix this by using "ep->ird" instead of "ep->ord" in the intended place.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Steve Wise <swise@opengridcomputing.com>
---
Linus, please add this for 2.6.25 if possible -- it's a trivial,
"obviously correct" fix that is very low risk and fixes real apps.

Thanks,
  Roland

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 320f2b6..99f2f2a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1745,7 +1745,7 @@ int iwch_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	/* bind QP to EP and move to RTS */
 	attrs.mpa_attr = ep->mpa_attr;
-	attrs.max_ird = ep->ord;
+	attrs.max_ird = ep->ird;
 	attrs.max_ord = ep->ord;
 	attrs.llp_stream_handle = ep;
 	attrs.next_state = IWCH_QP_STATE_RTS;
