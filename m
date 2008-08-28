Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYH1Nos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYH1Nos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYH1Noj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:44:39 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44899 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbYH1Noi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:44:38 -0400
From: Julien Brunel <brunel@diku.dk>
To: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/infiniband/core: Use a NULL test rather than an IS_ERR test
Date: Thu, 28 Aug 2008 15:31:07 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281531.07942.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>

In case of error, the function ucma_alloc_multicast returns a NULL
pointer, but never returns an ERR pointer. So after a call to this
function, an IS_ERR test should be replaced by a NULL test.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match bad_is_err_test@
expression x, E;
@@

x = ucma_alloc_multicast(...)
... when != x = E
IS_ERR(x)
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/core/ucma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -904,8 +904,8 @@ static ssize_t ucma_join_multicast(struc
 
 	mutex_lock(&file->mut);
 	mc = ucma_alloc_multicast(ctx);
-	if (IS_ERR(mc)) {
-		ret = PTR_ERR(mc);
+	if (mc == NULL) {
+		ret = -ENOMEM;
 		goto err1;
 	}
 
