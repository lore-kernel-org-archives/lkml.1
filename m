Return-Path: <linux-kernel-owner+w=401wt.eu-S936601AbZLQEeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936601AbZLQEeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935645AbZLQEeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:34:01 -0500
Received: from kroah.org ([198.145.64.141]:55584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935604AbZLQEE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:51 2009
Message-Id: <20091217035651.439580867@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Javier Cardona <javier@cozybit.com>,
       Andrey Yurovsky <andrey@cozybit.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [066/151] mac80211: Revert Use correct sign for mesh active path refresh
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit 7b324d28a94dac5a451e8cba66e8d324601e5b9a upstream.

The patch ("mac80211: Use correct sign for mesh active path
refresh.") was actually a bug.  Reverted it and improved the
explanation of how mesh path refresh works.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mesh.h      |    5 +++--
 net/mac80211/mesh_hwmp.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -186,8 +186,9 @@ struct mesh_rmc {
  */
 #define MESH_PREQ_MIN_INT	10
 #define MESH_DIAM_TRAVERSAL_TIME 50
-/* Paths will be refreshed if they are closer than PATH_REFRESH_TIME to their
- * expiration
+/* A path will be refreshed if it is used PATH_REFRESH_TIME milliseconds before
+ * timing out.  This way it will remain ACTIVE and no data frames will be
+ * unnecesarily held in the pending queue.
  */
 #define MESH_PATH_REFRESH_TIME			1000
 #define MESH_MIN_DISCOVERY_TIMEOUT (2 * MESH_DIAM_TRAVERSAL_TIME)
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -813,7 +813,7 @@ int mesh_nexthop_lookup(struct sk_buff *
 	}
 
 	if (mpath->flags & MESH_PATH_ACTIVE) {
-		if (time_after(jiffies, mpath->exp_time +
+		if (time_after(jiffies, mpath->exp_time -
 			msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time))
 				&& !memcmp(sdata->dev->dev_addr, hdr->addr4,
 					   ETH_ALEN)


