Return-Path: <linux-kernel-owner+w=401wt.eu-S1761498AbYBFXHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498AbYBFXHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762882AbYBFXFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:05:33 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:13730 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763485AbYBFXF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OAUh0CUWiw2O6/6V7g0sqA7IYsJMscLWO3yn1Fd7M8KypPfELvapuH4FnzOrueki1+9eTSo8v3Slwesny9dAKMXDu4hFzfXID5SiaX6PRRcYgm+UmdOQHLy1RzXdAEtb6jVKxBlAUfKyod1K3KRw8thAt2ZKHUBrPLL9Cs3j7EU=
Message-ID: <6101e8c40802061505o1ce85087uf80f76a040dfd4eb@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:05:25 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {11/17} - via-velocity-dont-oops-on-mtu-change-2 - series for stable kernel #2
In-Reply-To: <6101e8c40802011734m192c8df3pff12d784fc175465@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011734m192c8df3pff12d784fc175465@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 28 Nov 2007 22:20:16 +0000 (-0800)
Subject: via-velocity: don't oops on MTU change (resend)
Patch-mainline: v2.6.24-rc4
References: 341537

via-velocity: don't oops on MTU change (resend)

The VIA veloicty driver needs the following to allow changing MTU when down.
The buffer size needs to be computed when device is brought up, not when
device is initialized.  This also fixes a bug where the buffer size was
computed differently on change_mtu versus initial setting.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
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


On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: 48f6b053613b62fed7a2fe3255e5568260a8d615
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
