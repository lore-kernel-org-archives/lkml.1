Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbXERQwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbXERQwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbXERQwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:52:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbXERQwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:52:30 -0400
Message-ID: <464DD957.9040803@redhat.com>
Date: Sat, 19 May 2007 00:50:31 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org
Subject: [2.6 patch] drivers/net/wireless/libertas/rx.c: fix use-after-free
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

libertas_upload_rx_packet() calls netif_rx() before returning, and it always return 0.
Also within libertas_upload_rx_packet(), it will initialize skb->protocol anyways.

Spotted by the Coverity checker.

Signed-off-by: Eugene Teo <eteo@redhat.com>

diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index d17924f..1d8d5e4 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -269,15 +269,12 @@ int libertas_process_rxed_packet(wlan_private * priv, struct sk_buff *skb)
        wlan_compute_rssi(priv, p_rx_pd);

        lbs_pr_debug(1, "RX Data: size of actual packet = %d\n", skb->len);
-       if (libertas_upload_rx_packet(priv, skb)) {
-               lbs_pr_debug(1, "RX error: libertas_upload_rx_packet"
-                      " returns failure\n");
-               ret = -1;
-               goto done;
-       }
+
        priv->stats.rx_bytes += skb->len;
        priv->stats.rx_packets++;

+       libertas_upload_rx_packet(priv, skb);
+
        ret = 0;
 done:
        LEAVE();
@@ -439,21 +436,14 @@ static int process_rxed_802_11_packet(wlan_private * priv, struct
sk_buff *skb)

        lbs_pr_debug(1, "RX Data: size of actual packet = %d\n", skb->len);

-       if (libertas_upload_rx_packet(priv, skb)) {
-               lbs_pr_debug(1, "RX error: libertas_upload_rx_packet "
-                       "returns failure\n");
-               ret = -1;
-               goto done;
-       }
-
        priv->stats.rx_bytes += skb->len;
        priv->stats.rx_packets++;

+       libertas_upload_rx_packet(priv, skb);
+
        ret = 0;
 done:
        LEAVE();

-       skb->protocol = __constant_htons(0x0019);       /* ETH_P_80211_RAW */
-

