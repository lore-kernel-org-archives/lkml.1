Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbZL1OkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbZL1OkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZL1OkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:40:18 -0500
Received: from mailgw.kvados.cz ([194.213.53.146]:19217 "EHLO mailgw.kvados.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbZL1OkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:40:16 -0500
From: Milan Dadok <milan@dadok.name>
To: <kaber@trash.net>, <uaca@i.hate.spam.alumni.uv.es>,
       <johann.baudy@gnu-log.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] 1/1 net: packet: Keep 802.1Q VLAN tag in packet on SOCK_DGRAM socket
Date: Mon, 28 Dec 2009 15:34:49 +0100
Message-ID: <004501ca87ca$e9815030$bc83f090$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcqHyukDHcnH4PKNRxOAB5G+QnAFoA==
Content-Language: cs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep 802.1Q VLAN tag on non HW vlan accelerated network card received to
SOCK_DGRAM socket.

Signed-off-by: Milan Dadok <milan@dadok.name>

---
diff -urN af_packet.c.orig af_packet.c
--- af_packet.c.orig    2009-12-26 12:34:15.000000000 +0100
+++ af_packet.c 2009-12-28 14:31:14.000000000 +0100
@@ -57,6 +57,8 @@
 #include <linux/inet.h>
 #include <linux/netdevice.h>
 #include <linux/if_packet.h>
+#include <linux/if_vlan.h>
+#include "../8021q/vlan.h"
 #include <linux/wireless.h>
 #include <linux/kernel.h>
 #include <linux/kmod.h>
@@ -680,8 +682,28 @@
                if (sk->sk_type != SOCK_DGRAM)
                        skb_push(skb, skb->data - skb_mac_header(skb));
                else if (skb->pkt_type == PACKET_OUTGOING) {
-                       /* Special case: outgoing packets have ll header at
head */
-                       skb_pull(skb, skb_network_offset(skb));
+                       /* Special case: outgoing packets have ll header at
head
+                        * but we must leave 802.1Q encapsulation etc. (only
for non HW vlan accelerated)
+                        * encasulation len = actual header_len minus
hard_header_len
+                        * packet outgoing from vlan1@eth0 on eth0 have
skb_network_offset=18, hard_header_len=14
+                        */
+                       int hard_header_len;
+                       struct net_device *pdev;
+                       hard_header_len = dev->hard_header_len;
+                       pdev = dev;
+                       /* if dev is vlan device, hard_header_len contains
802.1Q encap, subtract it, recursively
+                        * ie. vlan3@vlan2@vlan1@eth0
+                        */
+                       while (is_vlan_dev(pdev)) {
+                               struct net_device *real_dev =
vlan_dev_info(pdev)->real_dev;
+                               hard_header_len -= pdev->hard_header_len -
real_dev->hard_header_len;
+                               pdev = real_dev;
+                       }
+
+                       skb_pull(skb, skb_network_offset(skb) -
+                            (skb_network_offset(skb) - hard_header_len>0 ?
skb_network_offset(skb) - hard_header_len : 0));
                }
        }

