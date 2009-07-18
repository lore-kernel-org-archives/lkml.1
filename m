Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZGRPZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZGRPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZGRPZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:25:57 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40072 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbZGRPZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:25:55 -0400
Date: Sat, 18 Jul 2009 17:25:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/6] fs/btrfs: convert nested spin_lock_irqsave to spin_lock
Message-ID: <Pine.LNX.4.64.0907181725320.26792@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If spin_lock_irqsave is called twice in a row with the same second
argument, the interrupt state at the point of the second call overwrites
the value saved by the first call.  Indeed, the second call does not need
to save the interrupt state, so it is changed to a simple spin_lock.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression lock1,lock2;
expression flags;
@@

*spin_lock_irqsave(lock1,flags)
... when != flags
*spin_lock_irqsave(lock2,flags)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/async-thread.c             |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 6e4f6c5..019e8af 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -424,11 +424,11 @@ int btrfs_requeue_work(struct btrfs_work *work)
 	 * list
 	 */
 	if (worker->idle) {
-		spin_lock_irqsave(&worker->workers->lock, flags);
+		spin_lock(&worker->workers->lock);
 		worker->idle = 0;
 		list_move_tail(&worker->worker_list,
 			       &worker->workers->worker_list);
-		spin_unlock_irqrestore(&worker->workers->lock, flags);
+		spin_unlock(&worker->workers->lock);
 	}
 	if (!worker->working) {
 		wake = 1;
