Return-Path: <linux-kernel-owner+w=401wt.eu-S935981AbZLQBa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935981AbZLQBa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763672AbZLQBUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:47 -0500
Received: from kroah.org ([198.145.64.141]:48049 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763655AbZLQBUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:05 2009
Message-Id: <20091217011605.286045484@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steve Glendinning <steve.glendinning@smsc.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [56/90] smsc9420: prevent BUG() if ethtool is called with interface down
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Steve Glendinning <steve.glendinning@smsc.com>

[ Upstream commit 6c53b1b15e222244358d3cbbefd2a13920faa352 ]

This patch fixes a null pointer dereference BUG() if ethtool is used on
an smsc9420 interface while it is down, because the phy_dev is only
allocated while the interface is up.

Signed-off-by: Steve Glendinning <steve.glendinning@smsc.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/smsc9420.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/smsc9420.c
+++ b/drivers/net/smsc9420.c
@@ -252,6 +252,9 @@ static int smsc9420_ethtool_get_settings
 {
 	struct smsc9420_pdata *pd = netdev_priv(dev);
 
+	if (!pd->phy_dev)
+		return -ENODEV;
+
 	cmd->maxtxpkt = 1;
 	cmd->maxrxpkt = 1;
 	return phy_ethtool_gset(pd->phy_dev, cmd);
@@ -262,6 +265,9 @@ static int smsc9420_ethtool_set_settings
 {
 	struct smsc9420_pdata *pd = netdev_priv(dev);
 
+	if (!pd->phy_dev)
+		return -ENODEV;
+
 	return phy_ethtool_sset(pd->phy_dev, cmd);
 }
 
@@ -290,6 +296,10 @@ static void smsc9420_ethtool_set_msgleve
 static int smsc9420_ethtool_nway_reset(struct net_device *netdev)
 {
 	struct smsc9420_pdata *pd = netdev_priv(netdev);
+
+	if (!pd->phy_dev)
+		return -ENODEV;
+
 	return phy_start_aneg(pd->phy_dev);
 }
 
@@ -312,6 +322,10 @@ smsc9420_ethtool_getregs(struct net_devi
 	for (i = 0; i < 0x100; i += (sizeof(u32)))
 		data[j++] = smsc9420_reg_read(pd, i);
 
+	// cannot read phy registers if the net device is down
+	if (!phy_dev)
+		return;
+
 	for (i = 0; i <= 31; i++)
 		data[j++] = smsc9420_mii_read(phy_dev->bus, phy_dev->addr, i);
 }


