Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYLWNQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYLWNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 08:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYLWNQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 08:16:46 -0500
Received: from phoenix.clifford.at ([88.198.7.52]:52720 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYLWNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 08:16:45 -0500
Date: Tue, 23 Dec 2008 13:57:55 +0100
From: Clifford Wolf <clifford@clifford.at>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Added MII ioctl handler to gianfar driver
Message-ID: <20081223125755.GA1994@clifford.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added MII ioctl handler to gianfar driver

This is the same kind of wrapper that can also be found in many
other network device drivers.

Tested with a freescale MPC8349E host CPU:
Toggled the interface LEDs on a DP83865 PHY.

Signed-off-by: Clifford Wolf <clifford@clifford.at>

--- drivers/net/gianfar.c	(revision 2193)
+++ drivers/net/gianfar.c	(revision 2194)
@@ -159,6 +159,20 @@
 	return (priv->vlan_enable || priv->rx_csum_enable);
 }
 
+/* Ioctl MII Interface */
+static int gfar_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (!priv->phydev)
+		return -ENODEV;
+
+	return phy_mii_ioctl(priv->phydev, if_mii(rq), cmd);
+}
+
 /* Set up the ethernet device structure, private data,
  * and anything else we need before we start */
 static int gfar_probe(struct platform_device *pdev)
@@ -272,6 +286,7 @@
 	dev->set_multicast_list = gfar_set_multi;
 
 	dev->ethtool_ops = &gfar_ethtool_ops;
+	dev->do_ioctl = gfar_ioctl;
 
 	if (priv->einfo->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
 		priv->rx_csum_enable = 1;
