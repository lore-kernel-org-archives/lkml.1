Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYF2Ts1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYF2Ts1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYF2TsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:48:15 -0400
Received: from khc.piap.pl ([195.187.100.11]:60621 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYF2TsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:48:15 -0400
To: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add missing skb->dev assignment in Frame Relay RX code
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 29 Jun 2008 21:48:11 +0200
Message-ID: <m3wsk8aupw.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit 4c13eb6657fe9ef7b4dc8f1a405c902e9e5234e0 ([ETH]: Make
eth_type_trans set skb->dev like the other *_type_trans) removed
skb->dev assignment from hdlc_fr.c:fr_rx(). Unfortunately it was also
needed for cases other than eth_type_trans().

Adding it back.

It's quite serious and may be a security risk as it causes a wrong
input interface indication (the physical hdlcX instead of logical
pvcX). Probably -stable class fix.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index c4ab032..3a86e64 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1008,6 +1008,7 @@ static int fr_rx(struct sk_buff *skb)
 		stats->rx_bytes += skb->len;
 		if (pvc->state.becn)
 			stats->rx_compressed++;
+		skb->dev = dev;
 		netif_rx(skb);
 		return NET_RX_SUCCESS;
 	} else {
