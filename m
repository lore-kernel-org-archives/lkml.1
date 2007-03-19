Return-Path: <linux-kernel-owner+w=401wt.eu-S965839AbXCSJpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839AbXCSJpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965856AbXCSJpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:45:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:13203 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965839AbXCSJpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:45:38 -0400
Date: Mon, 19 Mar 2007 11:46:19 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, openib-general@openib.org
Subject: Re: [ofa-general] drivers/infiniband/ulp/ipoib/ipoib_main.c:
	use-after-free
Message-ID: <20070319094619.GE8386@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070319092310.GJ752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319092310.GJ752@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Adrian Bunk <bunk@stusta.de>:
> Subject: [ofa-general] drivers/infiniband/ulp/ipoib/ipoib_main.c: use-after-free
> 
> The Coverity checker spotted the following code introduced by
> commit 839fcaba355abaffb7b44f0f4504093acb0b11cf:
> 
> <--  snip  -->
> 
> ...
> static void path_rec_completion(int status,
>                                 struct ib_sa_path_rec *pathrec,
>                                 void *path_ptr)
> {
> ...
>                 list_for_each_entry(neigh, &path->neigh_list, list) {
>                         kref_get(&path->ah->ref);
>                         neigh->ah = path->ah;
>                         memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
>                                sizeof(union ib_gid));
> 
>                         if (ipoib_cm_enabled(dev, neigh->neighbour)) {
>                                 if (!ipoib_cm_get(neigh))
>                                         ipoib_cm_set(neigh, ipoib_cm_create_tx(dev,
>                                                                                path,
>                                                                                neigh));
>                                 if (!ipoib_cm_get(neigh)) {
>                                         list_del(&neigh->list);
>                                         if (neigh->ah)
>                                                 ipoib_put_ah(neigh->ah);
>                                         ipoib_neigh_free(dev, neigh);
>                                         continue;
>                                 }
>                         }
> 
>                         while ((skb = __skb_dequeue(&neigh->queue)))
>                                 __skb_queue_tail(&skqueue, skb);
>                 }
> ...
> 
> <--  snip  -->
> 
> Notice that before the continue "neigh" gets freed, but the 
> list_for_each_entry() for() loop uses it.

Something like this then? Untested.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 12b528b..706eb88 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -380,7 +380,7 @@ static void path_rec_completion(int status,
 	struct net_device *dev = path->dev;
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_ah *ah = NULL;
-	struct ipoib_neigh *neigh;
+	struct ipoib_neigh *neigh, *t;
 	struct sk_buff_head skqueue;
 	struct sk_buff *skb;
 	unsigned long flags;
@@ -418,7 +418,7 @@ static void path_rec_completion(int status,
 		while ((skb = __skb_dequeue(&path->queue)))
 			__skb_queue_tail(&skqueue, skb);
 
-		list_for_each_entry(neigh, &path->neigh_list, list) {
+		list_for_each_entry_safe(neigh, t, &path->neigh_list, list) {
 			kref_get(&path->ah->ref);
 			neigh->ah = path->ah;
 			memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,

-- 
MST
