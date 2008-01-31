Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbYAaCLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbYAaCLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYAaCLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:11:12 -0500
Received: from fmailhost06.isp.att.net ([207.115.11.56]:57324 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYAaCLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:11:11 -0500
X-Originating-IP: [70.157.3.17]
Date: Wed, 30 Jan 2008 20:11:08 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: greg@kroah.com, chrisw@sous-sol.org
Cc: csnook@redhat.com, stable@kernel.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, david.harris@cpni-inc.com
Subject: [2.6.23.y][PATCH] atl1: fix frame length bug
Message-ID: <20080130201108.75878288@osprey.hogchain.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From de0e1eddb6a4dd7673f84c472812b062aaea2f39 Mon Sep 17 00:00:00 2001
From: Jay Cliburn <jacliburn@bellsouth.net>
Date: Wed, 30 Jan 2008 19:21:10 -0600
Subject: [PATCH] atl1: fix frame length bug

Upstream commit: 2a49128f0a6edee337174ea341c1d6d7565be350

The driver sets up the hardware to accept a frame with max length
equal to MTU + Ethernet header + FCS + VLAN tag, but we neglect to
add the VLAN tag size to the ingress buffer.  When a VLAN-tagged
frame arrives, the hardware passes it, but bad things happen
because the buffer is too small.  This patch fixes that.

Thanks to David Harris for reporting the bug and testing the fix.

Tested-by: David Harris <david.harris@cpni-inc.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/net/atl1/atl1_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index f23e13c..d2d4730 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -121,7 +121,7 @@ static int __devinit atl1_sw_init(struct atl1_adapter *adapter)
 	struct atl1_hw *hw = &adapter->hw;
 	struct net_device *netdev = adapter->netdev;
 
-	hw->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
+	hw->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 	hw->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	adapter->wol = 0;
@@ -689,7 +689,7 @@ static int atl1_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	int old_mtu = netdev->mtu;
-	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
+	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 
 	if ((max_frame < ETH_ZLEN + ETH_FCS_LEN) ||
 	    (max_frame > MAX_JUMBO_FRAME_SIZE)) {
@@ -854,8 +854,8 @@ static u32 atl1_configure(struct atl1_adapter *adapter)
 	/* set Interrupt Clear Timer */
 	iowrite16(adapter->ict, hw->hw_addr + REG_CMBDISDMA_TIMER);
 
-	/* set MTU, 4 : VLAN */
-	iowrite32(hw->max_frame_size + 4, hw->hw_addr + REG_MTU);
+	/* set max frame size hw will accept */
+	iowrite32(hw->max_frame_size, hw->hw_addr + REG_MTU);
 
 	/* jumbo size & rrd retirement timer */
 	value = (((u32) hw->rx_jumbo_th & RXQ_JMBOSZ_TH_MASK)
-- 
1.5.3.7

