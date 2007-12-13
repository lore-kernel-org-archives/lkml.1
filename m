Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbXLMKTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbXLMKTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXLMKTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:19:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:26221 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbXLMKTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:in-reply-to:x-mimeole:thread-index;
        b=rFGiQn26HvbwGXRG+EmJ/7cRfLY9nz+eRtY9/rceWvE0ISFKZNglCgmJmdtybPtCLq9i36LvHWKqgHtufl4/ZOvLpKfrlE1Y68PxLNSKIOUi4DSYuZzSr0LRYUvi6UuccImZoujPXTQzgN/iZM67TLdP8/Orl/dbd+QF9bjHW64=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "'Kok, Auke'" <auke-jan.h.kok@intel.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jesse.brandeburg@intel.com>, <jgarzik@pobox.com>,
       <shemminger@linux-foundation.org>,
       "'David Miller'" <davem@davemloft.net>
References: 
Subject: RE: [PATCH 1/7] [NETDEV]: e1000 Fix possible causing oops of net_rx_action
Date: Thu, 13 Dec 2007 19:18:56 +0900
Message-ID: <000701c83d71$95536b10$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: 
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acg8c6LK9pQbqylDSJSBZ+1x9ejIPAA98/Vw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/12, Joonwoo Park <joonwpark81@gmail.com>:
> [NETDEV]: e1000 Fix possible causing oops of net_rx_action
> returning work_done == weight as true after calling netif_rx_complete will cause oops in net_rx_action.
> 

I tried two types of patches for oops and ifconfig down hang for e1000 first.
Just blowing netif_running up is not best solution I think, it makes ifconfig down hang at least for e1000.
I would like to listen to the others suggestions courteously, please enlighten me :-)

The first:
- if !netif_running, stop receiving process, up to 64 (e1000) packets in the queue would be dropped.
---
 drivers/net/e1000/e1000_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 4f37506..664312b 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -3938,12 +3938,12 @@ e1000_clean(struct napi_struct *napi, int budget)
 		spin_unlock(&adapter->tx_queue_lock);
 	}
 
-	adapter->clean_rx(adapter, &adapter->rx_ring[0],
-	                  &work_done, budget);
+	if (likely(netif_running(poll_dev)))
+		adapter->clean_rx(adapter, &adapter->rx_ring[0],
+	                  	&work_done, budget);
 
 	/* If no Tx and not enough Rx work done, exit the polling mode */
-	if ((!tx_cleaned && (work_done == 0)) ||
-	   !netif_running(poll_dev)) {
+	if ((!tx_cleaned && (work_done == 0))) {
 quit_polling:
 		if (likely(adapter->itr_setting & 3))
 			e1000_set_itr(adapter);
---

The second:
- if !netif_running, receive up to weight - 1 packets, one packets in the queue can be dropped.
---
 drivers/net/e1000/e1000_main.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 4f37506..8e53c5b 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -3919,7 +3919,7 @@ e1000_clean(struct napi_struct *napi, int budget)
 {
 	struct e1000_adapter *adapter = container_of(napi, struct e1000_adapter, napi);
 	struct net_device *poll_dev = adapter->netdev;
-	int tx_cleaned = 0, work_done = 0;
+	int tx_cleaned = 0, work_done = 0, running;
 
 	/* Must NOT use netdev_priv macro here. */
 	adapter = poll_dev->priv;
@@ -3938,12 +3938,13 @@ e1000_clean(struct napi_struct *napi, int budget)
 		spin_unlock(&adapter->tx_queue_lock);
 	}
 
+	running = netif_running(poll_dev);
+
 	adapter->clean_rx(adapter, &adapter->rx_ring[0],
-	                  &work_done, budget);
+	                  &work_done, budget - !running);
 
 	/* If no Tx and not enough Rx work done, exit the polling mode */
-	if ((!tx_cleaned && (work_done == 0)) ||
-	   !netif_running(poll_dev)) {
+	if ((!tx_cleaned && (work_done == 0)) || !running) {
 quit_polling:
 		if (likely(adapter->itr_setting & 3))
 			e1000_set_itr(adapter);
---


Thanks,
Joonwoo

