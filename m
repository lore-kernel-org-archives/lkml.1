Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZJ1W3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZJ1W3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZJ1W3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:29:00 -0400
Received: from mailgw.kvados.cz ([194.213.53.146]:41507 "EHLO mailgw.kvados.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbZJ1W27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:28:59 -0400
From: Milan Dadok <milan@dadok.name>
To: "'Greg Kroah-Hartman'" <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, "'Hank Janssen'" <hjanssen@microsoft.com>,
       "'Haiyang Zhang'" <haiyangz@microsoft.com>
Subject: [PATCH] 2/3 staging: hv: fix oops in vmbus - netvsc list_head
Date: Wed, 28 Oct 2009 23:23:37 +0100
Message-ID: <001501ca581d$4c201fb0$e4605f10$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcpYHUsWpndeDo9YTDGqhyDth2lMgA==
Content-Language: cs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove incorrect list_head usage. Variable of type list_head was used in
some function's arguments as list item.

Signed-off-by: Milan Dadok <milan@dadok.name>

---
diff -uprN -X /usr/src/linux/Documentation/dontdiff
/usr/src/linux-2.6.32-rc5/drivers/staging/hv/NetVsc.c
/usr/src/linux/drivers/staging/hv/NetVsc.c
--- /usr/src/linux-2.6.32-rc5/drivers/staging/hv/NetVsc.c       2009-10-28
18:13:04.000000000 +0100
+++ /usr/src/linux/drivers/staging/hv/NetVsc.c  2009-10-28
17:49:40.000000000 +0100
@@ -1052,7 +1052,7 @@ static void NetVscOnReceive(struct hv_de
         */
        spin_lock_irqsave(&netDevice->receive_packet_list_lock, flags);
        while (!list_empty(&netDevice->ReceivePacketList)) {
-               list_move_tail(&netDevice->ReceivePacketList, &listHead);
+               list_move_tail(netDevice->ReceivePacketList.next,
&listHead);
                if (++count == vmxferpagePacket->RangeCount + 1)
                        break;
        }
@@ -1071,7 +1071,7 @@ static void NetVscOnReceive(struct hv_de
                /* Return it to the freelist */
                spin_lock_irqsave(&netDevice->receive_packet_list_lock,
flags);
                for (i = count; i != 0; i--) {
-                       list_move_tail(&listHead,
+                       list_move_tail(listHead.next,
                                       &netDevice->ReceivePacketList);
                }
                spin_unlock_irqrestore(&netDevice->receive_packet_list_lock,
@@ -1085,8 +1085,7 @@ static void NetVscOnReceive(struct hv_de
        }

        /* Remove the 1st packet to represent the xfer page packet itself */
-       xferpagePacket = list_entry(&listHead, struct xferpage_packet,
-                                   ListEntry);
+       xferpagePacket = (struct xferpage_packet*)listHead.next;
        list_del(&xferpagePacket->ListEntry);

        /* This is how much we can satisfy */
@@ -1102,8 +1101,7 @@ static void NetVscOnReceive(struct hv_de

        /* Each range represents 1 RNDIS pkt that contains 1 ethernet frame
*/
        for (i = 0; i < (count - 1); i++) {
-               netvscPacket = list_entry(&listHead, struct
hv_netvsc_packet,
-                                         ListEntry);
+               netvscPacket = (struct hv_netvsc_packet*)listHead.next;
                list_del(&netvscPacket->ListEntry);

                /* Initialize the netvsc packet */
---


