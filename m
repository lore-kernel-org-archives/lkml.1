Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbYBSW74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbYBSW74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbYBSW7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:59:31 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38527 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbYBSW73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:59:29 -0500
Date: Wed, 20 Feb 2008 00:58:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6.25 patch] fix broken error handling in
	ieee80211_sta_process_addba_request()
Message-ID: <20080219225852.GQ31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted this buggy error handling added by
commit 07db218396650933abff3c5c1ad1e2a6e0cfedeb.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6003e3d899a8fd6425ff509363b776f8807df25d diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2019b4f..094565e 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1116,9 +1116,10 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
 		kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
-	if ((!tid_agg_rx->reorder_buf) && net_ratelimit()) {
-		printk(KERN_ERR "can not allocate reordering buffer "
-						"to tid %d\n", tid);
+	if (!tid_agg_rx->reorder_buf) {
+		if (net_ratelimit())
+			printk(KERN_ERR "can not allocate reordering buffer "
+							"to tid %d\n", tid);
 		goto end;
 	}
 	memset(tid_agg_rx->reorder_buf, 0,

