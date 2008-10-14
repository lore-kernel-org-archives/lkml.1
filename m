Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYJNT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYJNT4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbYJNT4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:56:31 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:37890 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755087AbYJNT43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:56:29 -0400
X-Authority-Analysis: v=1.0 c=1 a=qYOhu5Qx6v8A:10 a=4toi1r5nGRgA:10
 a=quS4FCQqLwwIv9-0tLQA:9 a=Gs_dYvPeFjGB-PvaLTAA:7
 a=J9Mb2p4LohECD4ogVr3Htx_ap6EA:4 a=dGJ0OcVc7YAA:10 a=iYlkOlhu7C0A:10
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 6/6] DCB: setting pg will cause tx unit hangs
To: davem@davemloft.net, jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Date: Tue, 14 Oct 2008 12:56:05 -0700
Message-ID: <20081014195605.16879.38567.stgit@gitlost.lost>
In-Reply-To: <20081014195413.16879.25832.stgit@gitlost.lost>
References: <20081014195413.16879.25832.stgit@gitlost.lost>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

This patch fixes a hang in the ixgbe driver that occured when setting the Data Center Bridging (DCB) settings.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---

 drivers/net/ixgbe/ixgbe_dcb_nl.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_dcb_nl.c b/drivers/net/ixgbe/ixgbe_dcb_nl.c
index 51d162d..615c280 100644
--- a/drivers/net/ixgbe/ixgbe_dcb_nl.c
+++ b/drivers/net/ixgbe/ixgbe_dcb_nl.c
@@ -135,7 +135,7 @@ static void ixgbe_dcbnl_set_state(struct net_device *netdev, u8 state)
 		if (adapter->flags & IXGBE_FLAG_DCB_ENABLED) {
 			return;
 		} else {
-			if (netdev->flags & IFF_UP)
+			if (netif_running(netdev))
 				netdev->stop(netdev);
 			ixgbe_reset_interrupt_capability(adapter);
 			ixgbe_napi_del_all(adapter);
@@ -149,13 +149,13 @@ static void ixgbe_dcbnl_set_state(struct net_device *netdev, u8 state)
 			adapter->flags |= IXGBE_FLAG_DCB_ENABLED;
 			ixgbe_init_interrupt_scheme(adapter);
 			ixgbe_napi_add_all(adapter);
-			if (netdev->flags & IFF_UP)
+			if (netif_running(netdev))
 				netdev->open(netdev);
 		}
 	} else {
 		/* Turn off DCB */
 		if (adapter->flags & IXGBE_FLAG_DCB_ENABLED) {
-			if (netdev->flags & IFF_UP)
+			if (netif_running(netdev))
 				netdev->stop(netdev);
 			ixgbe_reset_interrupt_capability(adapter);
 			ixgbe_napi_del_all(adapter);
@@ -169,7 +169,7 @@ static void ixgbe_dcbnl_set_state(struct net_device *netdev, u8 state)
 			adapter->flags |= IXGBE_FLAG_RSS_ENABLED;
 			ixgbe_init_interrupt_scheme(adapter);
 			ixgbe_napi_add_all(adapter);
-			if (netdev->flags & IFF_UP)
+			if (netif_running(netdev))
 				netdev->open(netdev);
 		} else {
 			return;
@@ -338,6 +338,9 @@ static u8 ixgbe_dcbnl_set_all(struct net_device *netdev)
 	while (test_and_set_bit(__IXGBE_RESETTING, &adapter->state))
 		msleep(1);
 
+	if (netif_running(netdev))
+		ixgbe_down(adapter);
+
 	ret = ixgbe_copy_dcb_cfg(&adapter->temp_dcb_cfg, &adapter->dcb_cfg,
 				 adapter->ring_feature[RING_F_DCB].indices);
 	if (ret) {
@@ -345,8 +348,9 @@ static u8 ixgbe_dcbnl_set_all(struct net_device *netdev)
 		return ret;
 	}
 
-	ixgbe_down(adapter);
-	ixgbe_up(adapter);
+	if (netif_running(netdev))
+		ixgbe_up(adapter);
+
 	adapter->dcb_set_bitmap = 0x00;
 	clear_bit(__IXGBE_RESETTING, &adapter->state);
 	return ret;

