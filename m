Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZKLSFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZKLSFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZKLSFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:05:16 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:44665 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZKLSFN (ORCPT
	<rfc822;groupwise-PMullaney@novell.com;0:0>);
	Thu, 12 Nov 2009 13:05:13 -0500
From: Patrick Mullaney <pmullaney@novell.com>
Subject: [PATCH] netdevice: provide common routine for macvlan and vlan
	operstate management
To: kaber@trash.net
Cc: linux-kernel@vger.kernel.org, arnd@arnd.de, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.rog
Date: Thu, 12 Nov 2009 13:05:11 -0500
Message-ID: <20091112180137.10186.9386.stgit@mimic.site>
In-Reply-To: <4AFAD86A.9070506@trash.net>
References: <4AFAD86A.9070506@trash.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick,

This patch is intended to address your comment on moving the operstate
transition function. I decided to move it to netdevice.h, perhaps that
is a bad idea? It didn't seem to logically fall into dev.c or link_watch.c.
I am not against moving them to either one though. Your other comments
are addressed and I will send out a second series once this gets
reviewed and agreed on.

Thanks for your review/comments.
----------

Provide common routine for the transition of operational state for a leaf
device during a root device transition.

Signed-off-by: Patrick Mullaney <pmullaney@novell.com>
---

 include/linux/netdevice.h |   19 +++++++++++++++++++
 net/8021q/vlan.c          |   29 ++++-------------------------
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d4a4d98..a15920a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1999,6 +1999,25 @@ static inline u32 dev_ethtool_get_flags(struct net_device *dev)
 		return 0;
 	return dev->ethtool_ops->get_flags(dev);
 }
+
+static inline
+void netif_stacked_transfer_operstate(const struct net_device *rootdev,
+					struct net_device *dev)
+{
+        if (rootdev->operstate == IF_OPER_DORMANT)
+                netif_dormant_on(dev);
+        else
+                netif_dormant_off(dev);
+
+        if (netif_carrier_ok(rootdev)) {
+                if (!netif_carrier_ok(dev))
+                        netif_carrier_on(dev);
+        } else {
+                if (netif_carrier_ok(dev))
+                        netif_carrier_off(dev);
+        }
+}
+
 #endif /* __KERNEL__ */
 
 #endif	/* _LINUX_NETDEVICE_H */
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index fe64908..5d11c12 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -183,27 +183,6 @@ void unregister_vlan_dev(struct net_device *dev)
 	dev_put(real_dev);
 }
 
-static void vlan_transfer_operstate(const struct net_device *dev,
-				    struct net_device *vlandev)
-{
-	/* Have to respect userspace enforced dormant state
-	 * of real device, also must allow supplicant running
-	 * on VLAN device
-	 */
-	if (dev->operstate == IF_OPER_DORMANT)
-		netif_dormant_on(vlandev);
-	else
-		netif_dormant_off(vlandev);
-
-	if (netif_carrier_ok(dev)) {
-		if (!netif_carrier_ok(vlandev))
-			netif_carrier_on(vlandev);
-	} else {
-		if (netif_carrier_ok(vlandev))
-			netif_carrier_off(vlandev);
-	}
-}
-
 int vlan_check_real_dev(struct net_device *real_dev, u16 vlan_id)
 {
 	const char *name = real_dev->name;
@@ -267,7 +246,7 @@ int register_vlan_dev(struct net_device *dev)
 	/* Account for reference in struct vlan_dev_info */
 	dev_hold(real_dev);
 
-	vlan_transfer_operstate(real_dev, dev);
+	netif_stacked_transfer_operstate(real_dev, dev);
 	linkwatch_fire_event(dev); /* _MUST_ call rfc2863_policy() */
 
 	/* So, got the sucker initialized, now lets place
@@ -449,7 +428,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 			if (!vlandev)
 				continue;
 
-			vlan_transfer_operstate(dev, vlandev);
+			netif_stacked_transfer_operstate(dev, vlandev);
 		}
 		break;
 
@@ -492,7 +471,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 				continue;
 
 			dev_change_flags(vlandev, flgs & ~IFF_UP);
-			vlan_transfer_operstate(dev, vlandev);
+			netif_stacked_transfer_operstate(dev, vlandev);
 		}
 		break;
 
@@ -508,7 +487,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 				continue;
 
 			dev_change_flags(vlandev, flgs | IFF_UP);
-			vlan_transfer_operstate(dev, vlandev);
+			netif_stacked_transfer_operstate(dev, vlandev);
 		}
 		break;
 

