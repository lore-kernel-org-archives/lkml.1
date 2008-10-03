Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYJCPWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYJCPWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbYJCPVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:21:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56067 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbYJCPVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:21:47 -0400
Date: Fri, 03 Oct 2008 11:19:31 -0400 (EDT)
Message-Id: <20081003.111931.39152902.k-ueda@ct.jp.nec.com>
To: agk@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, mbroz@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 7/8] dm core: reject I/O violating new queue limits
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch detects requests violating the queue limitations
and rejects them.

The same limitation checks are done when requests are submitted
to the queue by blk_insert_cloned_request().
However, such violation can happen if a table is swapped and
the queue limitations are shrunk while some requests are
in the queue.

Since struct request is a reliable one in the block layer and
device drivers, dispatching such requests is pretty dangerous.
(e.g. it may cause kernel panic easily.)
So avoid to dispatch such problematic requests in request-based dm.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+)

Index: 2.6.27-rc8/drivers/md/dm.c
===================================================================
--- 2.6.27-rc8.orig/drivers/md/dm.c
+++ 2.6.27-rc8/drivers/md/dm.c
@@ -1472,6 +1472,30 @@ static void map_request(struct dm_target
 
 	tio->ti = ti;
 	atomic_inc(&md->pending);
+
+	/*
+	 * Although submitted requests to the md->queue are checked against
+	 * the table/queue limitations at the submission time, the limitations
+	 * may be changed by a table swapping while those already checked
+	 * requests are in the md->queue.
+	 * If the limitations have been shrunk in such situations, we may be
+	 * dispatching requests violating the current limitations here.
+	 * Since struct request is a reliable one in the block-layer
+	 * and device drivers, dispatching such requests is dangerous.
+	 * (e.g. it may cause kernel panic easily.)
+	 * Avoid to dispatch such problematic requests in request-based dm.
+	 *
+	 * Since dm_kill_request() decrements the md->pending, this have to
+	 * be done after incrementing the md->pending.
+	 */
+	r = blk_rq_check_limits(rq->q, rq);
+	if (unlikely(r)) {
+		DMWARN("violating the queue limitation. the limitation may be"
+		       " shrunk while there are some requests in the queue.");
+		dm_kill_request(clone, r);
+		return;
+	}
+
 	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
