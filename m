Return-Path: <linux-kernel-owner+w=401wt.eu-S933249AbYBGUHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbYBGUHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761547AbYBGUDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:42666 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080AbYBGUDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gS/lPA2Ttez1o68W2jKs5ADnbm18GfcB6PmxKN5PX5l8/u9OFmszAShHkU7ilDeaPsX6vOgprTydlhhM4xayj6tMrFPTdmzB53bcEcbI3ajoXxj1LbvKE+npJSNWt/kaVO8Z6sBKVX8d7L3A1sXymerLezPxS+CyUlKU0ISRvjo=
Message-ID: <6101e8c40802071203kee22a19rc24c0f8657160d46@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:38 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {09/14} - via-velocity: don't oops on MTU change (resend) - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: via-velocity-dont-oops-on-mtu-change-2.patch

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 28 Nov 2007 22:20:16 +0000 (-0800)
Subject: via-velocity: don't oops on MTU change (resend)
Patch-mainline: v2.6.24-rc4
References: 341537

via-velocity: don't oops on MTU change (resend)

mainline: 48f6b053613b62fed7a2fe3255e5568260a8d615

The VIA veloicty driver needs the following to allow changing MTU when down.
The buffer size needs to be computed when device is brought up, not when
device is initialized.  This also fixes a bug where the buffer size was
computed differently on change_mtu versus initial setting.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
---
 drivers/net/via-velocity.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/net/via-velocity.c	2008-01-03 15:18:50.000000000 -0500
+++ b/drivers/net/via-velocity.c	2008-01-03 15:22:18.000000000 -0500
@@ -1075,6 +1075,9 @@ static int velocity_init_rd_ring(struct
 	int ret = -ENOMEM;
 	unsigned int rsize = sizeof(struct velocity_rd_info) *
 					vptr->options.numrx;
+	int mtu = vptr->dev->mtu;
+
+	vptr->rx_buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;

 	vptr->rd_info = kmalloc(rsize, GFP_KERNEL);
 	if(vptr->rd_info == NULL)
@@ -1733,8 +1736,6 @@ static int velocity_open(struct net_devi
 	struct velocity_info *vptr = netdev_priv(dev);
 	int ret;

-	vptr->rx_buf_sz = (dev->mtu <= 1504 ? PKT_BUF_SZ : dev->mtu + 32);
-
 	ret = velocity_init_rings(vptr);
 	if (ret < 0)
 		goto out;
@@ -1813,12 +1814,6 @@ static int velocity_change_mtu(struct ne
 		velocity_free_rd_ring(vptr);

 		dev->mtu = new_mtu;
-		if (new_mtu > 8192)
-			vptr->rx_buf_sz = 9 * 1024;
-		else if (new_mtu > 4096)
-			vptr->rx_buf_sz = 8192;
-		else
-			vptr->rx_buf_sz = 4 * 1024;

 		ret = velocity_init_rd_ring(vptr);
 		if (ret < 0)


-- 
Thanks,
Oliver
