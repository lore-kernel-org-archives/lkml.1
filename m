Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbXKKAvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbXKKAvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbXKKAvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:51:19 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:61912 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbXKKAvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:51:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index:message-id;
        b=sYut65KVYjFfvXtugP+4AQUXhmjEfCIHbfYGQd+RYPyMDW0n+g+AChURrBCJGTsuCu+izTygwjbPFz+0dZLblSx2tk71omA1+uFfSYbd4nFS9kjpB+vNXr57p8uApLKBxJlZ/4KNjNGgYWcdWdn8csBZfxhEu2z6G1pfQmzjXdw=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "'David Miller'" <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: "'Dave Johnson'" <djohnson+linux-kernel@sw.starentnetworks.com>,
       <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous mode
Date: Sun, 11 Nov 2007 09:51:20 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acgj/PSbazJSWk9CQZW6q+XEgEJHlg==
Message-ID: <47365200.0f10240a.0686.2173@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO even though netdevice is in the promiscuous mode, we should receive all of ingress packets.
This disable the vlan filtering feature when a vlan hw accel configured e1000 device goes into promiscuous mode.
This make packets visible to sniffers though it's not vlan id of itself.
Any check, comments will be appreciated.
Thanks.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/e1000/e1000_main.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c index 72deff0..cdd5c84 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -2424,7 +2424,7 @@ e1000_set_multi(struct net_device *netdev)
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	struct dev_mc_list *mc_ptr;
-	uint32_t rctl;
+	uint32_t rctl, ctrl;
 	uint32_t hash_value;
 	int i, rar_entries = E1000_RAR_ENTRIES;
 	int mta_reg_count = (hw->mac_type == e1000_ich8lan) ?
@@ -2441,14 +2441,25 @@ e1000_set_multi(struct net_device *netdev)
 	/* Check for Promiscuous and All Multicast modes */
 
 	rctl = E1000_READ_REG(hw, RCTL);
+	ctrl = E1000_READ_REG(&adapter->hw, CTRL);
 
 	if (netdev->flags & IFF_PROMISC) {
 		rctl |= (E1000_RCTL_UPE | E1000_RCTL_MPE);
-	} else if (netdev->flags & IFF_ALLMULTI) {
-		rctl |= E1000_RCTL_MPE;
-		rctl &= ~E1000_RCTL_UPE;
+		if (adapter->hw.mac_type != e1000_ich8lan) {
+			if (ctrl & E1000_CTRL_VME)
+				rctl &= ~E1000_RCTL_VFE;
+		}
 	} else {
-		rctl &= ~(E1000_RCTL_UPE | E1000_RCTL_MPE);
+		if (adapter->hw.mac_type != e1000_ich8lan) {
+			if (ctrl & E1000_CTRL_VME)
+				rctl |= E1000_RCTL_VFE;
+		}
+		if (netdev->flags & IFF_ALLMULTI) {
+			rctl |= E1000_RCTL_MPE;
+			rctl &= ~E1000_RCTL_UPE;
+		} else {
+			rctl &= ~(E1000_RCTL_UPE | E1000_RCTL_MPE);
+		}
 	}
 
 	E1000_WRITE_REG(hw, RCTL, rctl);
@@ -4952,7 +4963,10 @@ e1000_vlan_rx_register(struct net_device *netdev, struct vlan_group *grp)
 		if (adapter->hw.mac_type != e1000_ich8lan) {
 			/* enable VLAN receive filtering */
 			rctl = E1000_READ_REG(&adapter->hw, RCTL);
-			rctl |= E1000_RCTL_VFE;
+			if (netdev->flags & IFF_PROMISC)
+				rctl &= ~E1000_RCTL_VFE;
+			else
+				rctl |= E1000_RCTL_VFE;
 			rctl &= ~E1000_RCTL_CFIEN;
 			E1000_WRITE_REG(&adapter->hw, RCTL, rctl);
 			e1000_update_mng_vlan(adapter);
---

