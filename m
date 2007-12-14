Return-Path: <linux-kernel-owner+w=401wt.eu-S1763997AbXLNJ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763997AbXLNJ2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXLNJ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:28:23 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:49632 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbXLNJ2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:28:20 -0500
Date: Fri, 14 Dec 2007 10:28:17 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: fpavlic@de.ibm.com, jgarzik@pobox.com, wangchen@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] s390/net/qeth_main.c: Fix use of skb after netif_rx
Message-ID: <Pine.LNX.4.64.0712141025470.29947@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Recently, Wang Chen submitted a patch
(d30f53aeb31d453a5230f526bea592af07944564) to move a call to netif_rx(skb)
after a subsequent reference to skb, because netif_rx may call kfree_skb on
its argument.  The same problem occurs in some other drivers as well.

This was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression skb, e,e1;
@@

(
 netif_rx(skb);
|
 netif_rx_ni(skb);
)
  ... when != skb = e
(
  skb = e1
|
* skb
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/s390/net/qeth_main.c b/drivers/s390/net/qeth_main.c
--- a/drivers/s390/net/qeth_main.c	2007-10-22 11:25:20.000000000 +0200
+++ b/drivers/s390/net/qeth_main.c	2007-12-14 10:20:06.000000000 +0100
@@ -2689,6 +2689,7 @@ qeth_process_inbound_buffer(struct qeth_
 	int offset;
 	int rxrc;
 	__u16 vlan_tag = 0;
+	unsigned int len;
 
 	/* get first element of current buffer */
 	element = (struct qdio_buffer_element *)&buf->buffer->element[0];
@@ -2717,6 +2718,7 @@ qeth_process_inbound_buffer(struct qeth_
 			dev_kfree_skb_any(skb);
 			continue;
 		}
+		len = skb->len;
 		if (card->info.type == QETH_CARD_TYPE_OSN)
 			rxrc = card->osn_info.data_cb(skb);
 		else
@@ -2733,7 +2735,7 @@ qeth_process_inbound_buffer(struct qeth_
 			rxrc = netif_rx(skb);
 		card->dev->last_rx = jiffies;
 		card->stats.rx_packets++;
-		card->stats.rx_bytes += skb->len;
+		card->stats.rx_bytes += len;
 	}
 }
 
