Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbXCSJfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbXCSJfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965847AbXCSJfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:35:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:63977 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965848AbXCSJfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:35:51 -0400
Date: Mon, 19 Mar 2007 11:36:32 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>, David Miller <davem@davemloft.net>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070319093632.GB8386@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
	<20070318195355.GB11078@mellanox.co.il>
	<20070318201826.GB27004@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318201826.GB27004@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Any simpler ideas?
> 
> Well, if inifiniband destructor really needs to take that lock... no.
> Right now I do not see.

OK, this is actually not hard to fix - for infiniband, we can just look at
neighbour->dev->type or compare neighbour->dev and
neighbour->parms->dev - if they are different, device is being unregistered,
so we do not need to do anything in the destructor.

I'll send a patch to openfabrics, shortly.

However, after implementing this fix, I hit what could be use after
free at module unloading. Dave, Alexey, Roland, could you take a look at
the following please?

Works fine for me (survived a couple of hours of crazy device
loading/unloading/up/down/hotplug + link data and state activity)
and seems to fix the issue.

---------

If a device driver sets neigh_destructor in neigh_params, this could
get called after the device has been unregistered and the driver module
removed.

This is an old bug, but apparently, started to get triggered more infiniband
after recent multicast and connected mode changes.

Fix this by delaying dev_put until the neigh_params object is removed.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 3183142..cb34f1a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1313,8 +1313,6 @@ void neigh_parms_release(struct neigh_table *tbl, struct neigh_parms *parms)
 			*p = parms->next;
 			parms->dead = 1;
 			write_unlock_bh(&tbl->lock);
-			if (parms->dev)
-				dev_put(parms->dev);
 			call_rcu(&parms->rcu_head, neigh_rcu_free_parms);
 			return;
 		}
@@ -1325,6 +1323,8 @@ void neigh_parms_release(struct neigh_table *tbl, struct neigh_parms *parms)
 
 void neigh_parms_destroy(struct neigh_parms *parms)
 {
+	if (parms->dev)
+		dev_put(parms->dev);
 	kfree(parms);
 }
 

-- 
MST
