Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYCXSKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYCXSKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbYCXSJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:09:55 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41789 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430AbYCXSJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:09:54 -0400
Date: Mon, 24 Mar 2008 19:09:41 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] drivers/infiniband: test for IS_ERR rather than 0
Message-ID: <Pine.LNX.4.64.0803241909170.32740@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function rdma_create_id always returns either a valid pointer or a
value made with ERR_PTR, so its result should be tested with IS_ERR, not
with a test for 0.


The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@a@
expression E, E1;
statement S,S1;
position p;
@@

E = rdma_create_id(...)
... when != E = E1
if@p (E) S else S1

@n@
position a.p;
expression E,E1;
statement S,S1;
@@

E = NULL
... when != E = E1
if@p (E) S else S1

@depends on !n@
expression E;
statement S,S1;
position a.p;
@@

* if@p (E)
  S else S1
//</smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/infiniband/core/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
--- a/drivers/infiniband/core/cma.c	2008-03-12 14:13:13.000000000 +0100
+++ b/drivers/infiniband/core/cma.c	2008-03-24 16:10:01.000000000 +0100
@@ -1289,7 +1289,7 @@ static int iw_conn_req_handler(struct iw
 	new_cm_id = rdma_create_id(listen_id->id.event_handler,
 				   listen_id->id.context,
 				   RDMA_PS_TCP);
-	if (!new_cm_id) {
+	if (IS_ERR(new_cm_id)) {
 		ret = -ENOMEM;
 		goto out;
 	}
