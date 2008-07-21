Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYGUH5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYGUH5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYGUH5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:57:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60056 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbYGUH5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:57:08 -0400
Date: Mon, 21 Jul 2008 09:57:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/7] drivers/infiniband: Release mutex in error handling code
Message-ID: <Pine.LNX.4.64.0807210956040.24625@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -163,6 +163,7 @@ static int alloc_small_queue_page(struct
 
 out:
 	ehca_err(pd->ib_pd.device, "failed to allocate small queue page");
+	mutex_unlock(&pd->lock);
 	return 0;
 }
 
