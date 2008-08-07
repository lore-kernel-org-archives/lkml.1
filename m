Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYHGPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYHGPQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYHGPQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:16:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56541 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbYHGPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:16:03 -0400
From: Julien Brunel <brunel@diku.dk>
To: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/infiniband/core: Use an IS_ERR test rather than a NULL test
Date: Thu, 7 Aug 2008 17:15:53 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071715.54004.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>

In case of error, the function ib_create_send_mad returns an ERR pointer,
but never returns a NULL pointer. So after a call to this function,
a NULL test should be replaced by an IS_ERR test.

A simplified version of the semantic patch that makes this change is
as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@correct_null_test@
expression x,E;
statement S1, S2;
@@
x = ib_create_send_mad(...)
<... when != x = E
if (
(
- x@p2 != NULL
+ ! IS_ERR ( x )
|
- x@p2 == NULL
+ IS_ERR( x )
)
 )
S1
else S2
...>
? x = E;
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/core/mad_rmpp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/infiniband/core/mad_rmpp.c 
b/drivers/infiniband/core/mad_rmpp.c
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -133,7 +133,7 @@ static void ack_recv(struct mad_rmpp_rec
 	msg = ib_create_send_mad(&rmpp_recv->agent->agent, recv_wc->wc->src_qp,
 				 recv_wc->wc->pkey_index, 1, hdr_len,
 				 0, GFP_KERNEL);
-	if (!msg)
+	if (IS_ERR(msg))
 		return;
 
 	format_ack(msg, (struct ib_rmpp_mad *) recv_wc->recv_buf.mad, rmpp_recv);
