Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbXCEXcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbXCEXcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXCEXcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:32:48 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:60614 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbXCEXcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:32:47 -0500
Subject: [PATCH 2.6.21-rc2] iw_cxgb3: Start ep timer on a MPA reject.
From: Steve Wise <swise@opengridcomputing.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, General@lists.openfabrics.org
Content-Type: text/plain
Date: Mon, 05 Mar 2007 17:32:46 -0600
Message-Id: <1173137566.14159.95.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Start ep timer on a MPA reject.

If the consumer rejects the connection we end up under-referencing the
endpoint structure.  The fix is to call iwch_ep_disconnect() instead of
the low level disconnect functions so that the endpoint close timer is
started correctly.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index fd2f3ca..d0ed1d3 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1691,12 +1691,11 @@ int iwch_reject_cr(struct iw_cm_id *cm_i
 		return -ECONNRESET;
 	}
 	BUG_ON(state_read(&ep->com) != MPA_REQ_RCVD);
-	state_set(&ep->com, CLOSING);
 	if (mpa_rev == 0)
 		abort_connection(ep, NULL, GFP_KERNEL);
 	else {
 		err = send_mpa_reject(ep, pdata, pdata_len);
-		err = send_halfclose(ep, GFP_KERNEL);
+		err = iwch_ep_disconnect(ep, 0, GFP_KERNEL);
 	}
 	return 0;
 }

