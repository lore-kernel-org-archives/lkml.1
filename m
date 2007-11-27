Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXK0JCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXK0JCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXK0JBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:01:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:23926 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbXK0JBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:01:54 -0500
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: general@lists.openfabrics.org
Subject: Re: [ofa-general] [GIT PULL] please pull infiniband.git
Date: Tue, 27 Nov 2007 10:59:48 +0200
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <adahcj8qkd5.fsf@cisco.com>
In-Reply-To: <adahcj8qkd5.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271059.48891.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2007 08:21, Roland Dreier wrote:
> Linus, please pull from
> 
>     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
> 
> 
> Jack Morgenstein (1):
>       mlx4_core: Fix state check in mlx4_qp_modify()
> 
MUST also enter the patch I send yesterday:
[PATCH] ipoib: fix kernel Oops resulting from xmit when priv->broadcast is NULL.

(critical bug fix -- will get kernel Oopses whenever ports on the network go down!).
(patch given again below)

- Jack
======================================================================================================================
IPoIB: Fix kernel Oops resulting from xmit following dev_down.

If a port goes down, ipoib_ib_dev_down is invoked -- which flushed the mcasts (clearing
priv->broadcast) and clearing the path record cache. If ipoib_start_xmit is then invoked (before
the port is upped), a kernel Oops results from attempting to access priv->broadcast.

Returning NULL if priv->broadcast is NULL is a harmless way of bypassing the problem -- the
offending packet is simply discarded "without prejudice".

Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index a03a65e..c9f6077 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -460,6 +460,9 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_path *path;
 
+	if (!priv->broadcast)
+		return NULL;
+
 	path = kzalloc(sizeof *path, GFP_ATOMIC);
 	if (!path)
 		return NULL;
