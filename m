Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXCRPyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXCRPyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 11:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXCRPyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 11:54:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41143 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbXCRPyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 11:54:52 -0400
Date: Sun, 18 Mar 2007 17:55:32 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: dst_ifdown breaks infiniband?
Message-ID: <20070318155532.GG7958@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey, Roland,
In debugging kernel lockup that occurs with IP over InfiniBand in 2.6.21-rc4:
( https://bugs.openfabrics.org/show_bug.cgi?id=402 )

I noticed the following code in dst_ifdown:

/* Dirty hack. We did it in 2.2 (in __dst_free),
 * we have _very_ good reasons not to repeat
 * this mistake in 2.3, but we have no choice
 * now. _It_ _is_ _explicit_ _deliberate_
 * _race_ _condition_.
 *
 * Commented and originally written by Alexey.
 */
static inline void dst_ifdown(struct dst_entry *dst, struct net_device *dev,
                              int unregister)
{
        if (dst->ops->ifdown)
                dst->ops->ifdown(dst, dev, unregister);

        if (dev != dst->dev)
                return;

        if (!unregister) {
                dst->input = dst_discard_in;
                dst->output = dst_discard_out;
        } else {
                dst->dev = &loopback_dev;
                dev_hold(&loopback_dev);
                dev_put(dev);
                if (dst->neighbour && dst->neighbour->dev == dev) {
                        dst->neighbour->dev = &loopback_dev;
                        dev_put(dev);
                        dev_hold(&loopback_dev);
                }
        }
}

The line dst->neighbour->dev = &loopback_dev breaks IP over InfiniBand,
simply because neighbour->parms still points to an entry that has
been set up with dev->neigh_setup call from IPoIB neighbour device.

So when neighbour->parms->neigh_destructor is called,
we get to ipoib_neigh_destructor in drivers/infiniband/ulp/ipoib/ipoib_main.c,
and that in turn crashes since it needs an infiniband device
in neighbour dev pointer.

This is not new code, and should have triggered long time ago,
so I am not sure how come we are triggering this only now,
but somehow this did not lead to crashes in 2.6.20, but does now in 2.6.21-rc4.

Ideas on how to fix this?

Why is neighbour->dev changed here?

Can dst->neighbour be changed to point to NULL instead, and the neighbour
released?

Thanks very much,
-- 
MST
