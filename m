Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZGLG5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZGLG5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 02:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZGLG46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 02:56:58 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:61696 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZGLG45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 02:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fCJIQdod9CShQlmdCT4UwNqvT402ElkYW9FOyHOCx+P5CQyBQ8nNVL8lTuA0QyCSNG
         HbfZ8FvGb5v3je3vC1x//ZTrp8zQw1/ZWunoibqvrgwc6gGv6LON9wu07gX96KfLAShZ
         0GjxGZwT1AZ/vg2IaA9HFYPHz2ueu0b68vwjg=
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 14:56:56 +0800
Message-ID: <2674af740907112356s36caba0dw1c92728ff684b4b3@mail.gmail.com>
Subject: [PATCH] gianfar: keep vlan related state when reenabled
From: Yong Zhang <yong.zhang0@gmail.com>
To: galak@kernel.crashing.org
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If vlan has been enabled. ifdown followed by ifup will lost hardware
related state.

remove duplicated operation in gfar_vlan_rx_register().

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/net/gianfar.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 4ae1d25..9cc6dd3 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -942,6 +942,7 @@ int startup_gfar(struct net_device *dev)
 	struct gfar __iomem *regs = priv->regs;
 	int err = 0;
 	u32 rctrl = 0;
+	u32 tctrl = 0;
 	u32 attrs = 0;

 	gfar_write(&regs->imask, IMASK_INIT_CLEAR);
@@ -1117,11 +1118,19 @@ int startup_gfar(struct net_device *dev)
 		rctrl |= RCTRL_PADDING(priv->padding);
 	}

+	/* keep vlan related bits if it's enabled */
+	if (priv->vlgrp) {
+		rctrl |= RCTRL_VLEX | RCTRL_PRSDEP_INIT;
+		tctrl |= TCTRL_VLINS;
+	}
+
 	/* Init rctrl based on our settings */
 	gfar_write(&priv->regs->rctrl, rctrl);

 	if (dev->features & NETIF_F_IP_CSUM)
-		gfar_write(&priv->regs->tctrl, TCTRL_INIT_CSUM);
+		tctrl |= TCTRL_INIT_CSUM;
+
+	gfar_write(&priv->regs->tctrl, tctrl);

 	/* Set the extraction length and index */
 	attrs = ATTRELI_EL(priv->rx_stash_size) |
@@ -1456,7 +1465,6 @@ static void gfar_vlan_rx_register(struct net_device *dev,

 		/* Enable VLAN tag extraction */
 		tempval = gfar_read(&priv->regs->rctrl);
-		tempval |= RCTRL_VLEX;
 		tempval |= (RCTRL_VLEX | RCTRL_PRSDEP_INIT);
 		gfar_write(&priv->regs->rctrl, tempval);
 	} else {
-- 
1.6.0.4
