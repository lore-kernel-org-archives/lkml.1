Return-Path: <linux-kernel-owner+w=401wt.eu-S1764374AbYBZS2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764374AbYBZS2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYBZS14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:27:56 -0500
Received: from quasar.osc.edu ([192.148.249.15]:50043 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbYBZS1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:27:54 -0500
Date: Tue, 26 Feb 2008 13:27:53 -0500
From: Pete Wyckoff <pw@osc.edu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Olaf Kirch <olaf.kirch@oracle.com>, general@lists.openfabrics.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ib fmr pool: flush used clean entries
Message-ID: <20080226182753.GF7033@osc.edu>
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com> <20080226182655.GD7033@osc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226182655.GD7033@osc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a3cd7d9070be417a21905c997ee32d756d999b38 (IB/fmr_pool:
ib_fmr_pool_flush() should flush all dirty FMRs) caused a
regression for iSER and was reverted in
e5507736c6449b3253347eed6f8ea77a28cf688e.

This change attempts to redo the original patch so that all used
FMR entries are flushed when ib_flush_fmr_pool() is called,
and other FMR users are not affected.  Simply move used entries
from the clean list onto the dirty list before letting the
cleanup thread do its job.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/core/fmr_pool.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index 4044fdf..06d502c 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -398,8 +398,23 @@ EXPORT_SYMBOL(ib_destroy_fmr_pool);
  */
 int ib_flush_fmr_pool(struct ib_fmr_pool *pool)
 {
-	int serial = atomic_inc_return(&pool->req_ser);
+	int serial;
+	struct ib_pool_fmr *fmr, *next;
+
+	/*
+	 * The free_list holds FMRs that may have been used
+	 * but have not been remapped enough times to be dirty.
+	 * Put them on the dirty list now so that the cleanup
+	 * thread will reap them too.
+	 */
+	spin_lock_irq(&pool->pool_lock);
+	list_for_each_entry_safe(fmr, next, &pool->free_list, list) {
+		if (fmr->remap_count > 0)
+			list_move(&fmr->list, &pool->dirty_list);
+	}
+	spin_unlock_irq(&pool->pool_lock);
 
+	serial = atomic_inc_return(&pool->req_ser);
 	wake_up_process(pool->thread);
 
 	if (wait_event_interruptible(pool->force_wait,
-- 
1.5.4.1

