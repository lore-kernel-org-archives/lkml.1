Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbXF0Px3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbXF0Px3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbXF0Pvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:51:51 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:39367 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756024AbXF0Pvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:51:50 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 6/6] iw_cxgb3: Don't abort after failures sending the mpa reply.
Date: Wed, 27 Jun 2007 10:51:50 -0500
To: rdreier@cisco.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, divy@chelsio.com
Message-Id: <20070627155150.24944.36124.stgit@dell3.ogc.int>
In-Reply-To: <20070627155119.24944.44172.stgit@dell3.ogc.int>
References: <20070627155119.24944.44172.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


iw_cxgb3: Don't abort after failures sending the mpa reply.

This bug results in an abort request being sent down _after_ the tid
has been released.  If the tid happens to have been reused, then the
subsequent generation of the tid gets incorrectly aborted.

The thread running iwch_accecpt_cr() must not abort a connection if an
error is returned after being awakened.  If any errors did occur while
iwch_accept_cr() is blocked, then the connection has already been aborted
on the thread processing the error.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 228721f..3b41dc0 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1781,7 +1781,6 @@ err:
 	ep->com.cm_id = NULL;
 	ep->com.qp = NULL;
 	cm_id->rem_ref(cm_id);
-	abort_connection(ep, NULL, GFP_KERNEL);
 	put_ep(&ep->com);
 	return err;
 }
