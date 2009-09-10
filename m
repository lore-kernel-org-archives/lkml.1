Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZIJB77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZIJB77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZIJB76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:59:58 -0400
Received: from modry.cz ([217.11.254.86]:55101 "EHLO modry.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZIJB76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:59:58 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 21:59:57 EDT
Date: Thu, 10 Sep 2009 03:44:47 +0200 (CEST)
From: Martin Decky <martin@decky.cz>
To: j@w1.fi
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hostap: Revert a toxic part of the conversion to
 net_device_ops
Message-ID: <alpine.LFD.2.00.0909100333230.4334@hefaistos.decky.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Decky <martin@decky.cz>

As the hostap driver was converted to use net_device_ops, a mistake was 
made in hostap_main.c (commit 5ae4efbcd2611562a8b93596be034e63495706a5). 
Originally, the tx_queue_len was set to 0 for every other interface than 
HOSTAP_INTERFACE_MASTER, but the new fragment of code sets tx_queue_len to 
0 only for HOSTAP_INTERFACE_MASTER. The opposite of the previous 
behavior makes the driver to drop all packets in AP mode.

Change the way 0 is assigned to tx_queue_len according to the original 
logic.

Signed-off-by: Martin Decky <martin@decky.cz>
----
diff -Naurp linux-2.6.30.orig/drivers/net/wireless/hostap/hostap_main.c linux-2.6.30/drivers/net/wireless/hostap/hostap_main.c
--- linux-2.6.30.orig/drivers/net/wireless/hostap/hostap_main.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30/drivers/net/wireless/hostap/hostap_main.c	2009-09-08 11:11:23.892816045 +0200
@@ -875,15 +875,16 @@ void hostap_setup_dev(struct net_device 
 
 	switch(type) {
 	case HOSTAP_INTERFACE_AP:
+		dev->tx_queue_len = 0;	/* use main radio device queue */
 		dev->netdev_ops = &hostap_mgmt_netdev_ops;
 		dev->type = ARPHRD_IEEE80211;
 		dev->header_ops = &hostap_80211_ops;
 		break;
 	case HOSTAP_INTERFACE_MASTER:
-		dev->tx_queue_len = 0;	/* use main radio device queue */
 		dev->netdev_ops = &hostap_master_ops;
 		break;
 	default:
+		dev->tx_queue_len = 0;	/* use main radio device queue */
 		dev->netdev_ops = &hostap_netdev_ops;
 	}
 
