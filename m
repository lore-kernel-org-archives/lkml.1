Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbXGVX1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbXGVX1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXGVX0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:26:55 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41470 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbXGVX0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:26:54 -0400
Date: Mon, 23 Jul 2007 01:26:18 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Jeff Garzik <jeff@garzik.org>
Cc: xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: drivers/net/xen-netfront.c: bogus code
Message-ID: <20070722232618.GO26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following bogus code
in drivers/net/xen-netfront.c:

<--  snip  -->

...
static void xennet_alloc_rx_buffers(struct net_device *dev)
{
...
        for (nr_flips = i = 0; ; i++) {
                skb = __skb_dequeue(&np->rx_batch);
                if (skb == NULL)
                        break;

                skb->dev = dev;

                id = xennet_rxidx(req_prod + i);

                BUG_ON(np->rx_skbs[id]);
                np->rx_skbs[id] = skb;

                ref = gnttab_claim_grant_reference(&np->gref_rx_head);
                BUG_ON((signed short)ref < 0);
                np->grant_rx_ref[id] = ref;

                pfn = page_to_pfn(skb_shinfo(skb)->frags[0].page);
                vaddr = page_address(skb_shinfo(skb)->frags[0].page);

                req = RING_GET_REQUEST(&np->rx, req_prod + i);
                gnttab_grant_foreign_access_ref(ref,
                                                np->xbdev->otherend_id,
                                                pfn_to_mfn(pfn),
                                                0);

                req->id = id;
                req->gref = ref;
        }

        if (nr_flips != 0) {
...

<--  snip  -->

Note that "nr_flips" is always 0 in the last line.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

