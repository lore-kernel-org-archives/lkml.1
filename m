Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344Ab0ADJJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0ADJJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 04:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320Ab0ADJJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 04:09:19 -0500
Received: from mailgw.kvados.cz ([194.213.53.146]:29410 "EHLO mailgw.kvados.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab0ADJJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 04:09:06 -0500
From: Milan Dadok <milan@dadok.name>
To: <kaber@trash.net>, <uaca@alumni.uv.es>, <johann.baudy@gnu-log.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: 
In-Reply-To: 
Subject: RE: [PATCH] 1/1 net: packet: Keep 802.1Q VLAN tag in packet on SOCK_DGRAM socket - resend
Date: Mon, 4 Jan 2010 10:09:05 +0100
Message-ID: <001801ca8d1d$90c68de0$b253a9a0$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcqHyukDHcnH4PKNRxOAB5G+QnAFoAFUVZUA
Content-Language: cs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep 802.1Q VLAN tag on non HW vlan accelerated network card received to SOCK_DGRAM socket.

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
-                       /* Special case: outgoing packets have ll header at head */
-                       skb_pull(skb, skb_network_offset(skb));
+                       /* Special case: outgoing packets have ll header at head
+                        * but we must leave 802.1Q encapsulation etc. (only for non HW vlan accelerated)
+                        * encasulation len = actual header_len minus hard_header_len
+                        * packet outgoing from vlan1@eth0 on eth0 have skb_network_offset=18, hard_header_len=14
+                        */
+                       int hard_header_len;
+                       struct net_device *pdev;
+                       hard_header_len = dev->hard_header_len;
+                       pdev = dev;
+                       /* if dev is vlan device, hard_header_len contains 802.1Q encap, subtract it, recursively
+                        * ie. vlan3@vlan2@vlan1@eth0
+                        */
+                       while (is_vlan_dev(pdev)) {
+                               struct net_device *real_dev = vlan_dev_info(pdev)->real_dev;
+                               hard_header_len -= pdev->hard_header_len - real_dev->hard_header_len;
+                               pdev = real_dev;
+                       }
+
+                       skb_pull(skb, skb_network_offset(skb) -
+                            (skb_network_offset(skb) - hard_header_len>0 ? skb_network_offset(skb) - hard_header_len : 0));
                }
        }

