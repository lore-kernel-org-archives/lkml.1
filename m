Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXCSJXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXCSJXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXCSJXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:23:12 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34822 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753289AbXCSJXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:23:07 -0400
Date: Mon, 19 Mar 2007 10:23:10 +0100
From: Adrian Bunk <bunk@stusta.de>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Roland Dreier <rolandd@cisco.com>, mshefty@ichips.intel.com,
       halr@voltaire.com, openib-general@openib.org,
       linux-kernel@vger.kernel.org
Subject: drivers/infiniband/ulp/ipoib/ipoib_main.c: use-after-free
Message-ID: <20070319092310.GJ752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following code introduced by
commit 839fcaba355abaffb7b44f0f4504093acb0b11cf:

<--  snip  -->

...
static void path_rec_completion(int status,
                                struct ib_sa_path_rec *pathrec,
                                void *path_ptr)
{
...
                list_for_each_entry(neigh, &path->neigh_list, list) {
                        kref_get(&path->ah->ref);
                        neigh->ah = path->ah;
                        memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
                               sizeof(union ib_gid));

                        if (ipoib_cm_enabled(dev, neigh->neighbour)) {
                                if (!ipoib_cm_get(neigh))
                                        ipoib_cm_set(neigh, ipoib_cm_create_tx(dev,
                                                                               path,
                                                                               neigh));
                                if (!ipoib_cm_get(neigh)) {
                                        list_del(&neigh->list);
                                        if (neigh->ah)
                                                ipoib_put_ah(neigh->ah);
                                        ipoib_neigh_free(dev, neigh);
                                        continue;
                                }
                        }

                        while ((skb = __skb_dequeue(&neigh->queue)))
                                __skb_queue_tail(&skqueue, skb);
                }
...

<--  snip  -->

Notice that before the continue "neigh" gets freed, but the 
list_for_each_entry() for() loop uses it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

