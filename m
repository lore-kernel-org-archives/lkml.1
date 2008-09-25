Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYIYW27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYIYW27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYIYW2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:28:14 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:60404 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbYIYW2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:28:11 -0400
X-IronPort-AV: E=Sophos;i="4.33,309,1220227200"; 
   d="scan'208";a="82934608"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [PATCH] IPoIB: Fix crash when path record fails after path flush
X-Message-Flag: Warning: May contain useful information
Date: Thu, 25 Sep 2008 15:28:08 -0700
Message-ID: <adaprmrzwqv.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Sep 2008 22:28:08.0724 (UTC) FILETIME=[FC9B8540:01C91F5D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rolandd@cisco.com>

Commit ee1e2c82 ("IPoIB: Refresh paths instead of flushing them on SM
change events") changed how paths are flushed on an SM event.  This
change introduces a problem if the path record query triggered by
fails, causing path->ah to become NULL.  A later successful path query
will then trigger WARN_ON() in path_rec_completion(), and crash
because path->ah has already been freed, so the ipoib_put_ah() inside
the lock in path_rec_completion() may actually drop the last reference
(contrary to the comment that claims this is safe).

Fix this by updating path->ah and freeing old_ah only when the path
record query is successful.  This prevents the neighbour AH and that
path AH from getting out of sync.

This fixes <https://bugs.openfabrics.org/show_bug.cgi?id=1194>

Reported-by: Rabah Salem <ravah@mellanox.com>
Debugged-by: Eli Cohen <eli@mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Hi Linus,

One more patch for 2.6.27.  This fixes a regression from 2.6.26 that
causes a panic with IP-over-InfiniBand on some network events.

Please apply.

Thanks,
  Roland

 drivers/infiniband/ulp/ipoib/ipoib_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1b1df5c..e9ca3cb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -404,7 +404,7 @@ static void path_rec_completion(int status,
 	struct net_device *dev = path->dev;
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_ah *ah = NULL;
-	struct ipoib_ah *old_ah;
+	struct ipoib_ah *old_ah = NULL;
 	struct ipoib_neigh *neigh, *tn;
 	struct sk_buff_head skqueue;
 	struct sk_buff *skb;
@@ -428,12 +428,12 @@ static void path_rec_completion(int status,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	old_ah   = path->ah;
-	path->ah = ah;
-
 	if (ah) {
 		path->pathrec = *pathrec;
 
+		old_ah   = path->ah;
+		path->ah = ah;
+
 		ipoib_dbg(priv, "created address handle %p for LID 0x%04x, SL %d\n",
 			  ah, be16_to_cpu(pathrec->dlid), pathrec->sl);
 
-- 
1.6.0.1

