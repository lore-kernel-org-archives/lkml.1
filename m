Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0BQRzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:55:21 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:26342 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0BQRzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:55:19 -0500
X-Spam-Processed: digidescorp.com, Wed, 17 Feb 2010 11:55:10 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1664b98752=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
From: "Steven J. Magnani" <steve@digidescorp.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] ll_temac: Fix MAC address configuration from userland
Date: Wed, 17 Feb 2010 11:55:07 -0600
Message-Id: <1266429307-11765-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A userland command to set the LLTEMAC MAC address,
i.e. "ifconfig eth0 hw addr xx:yy:zz:pp:dd:qq",
results in a device address of 00:01:xx:yy:zz:pp.
Correct this.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
--- a/drivers/net/ll_temac_main.c	2010-02-17 10:38:35.000000000 -0600
+++ b/drivers/net/ll_temac_main.c	2010-02-17 11:47:45.000000000 -0600
@@ -224,6 +224,13 @@ static int temac_set_mac_address(struct 
 	return 0;
 }
 
+static int netdev_set_mac_address(struct net_device *ndev, void *p)
+{
+	struct sockaddr *addr = p;
+
+	return temac_set_mac_address(ndev, addr->sa_data);
+}
+
 static void temac_set_multicast_list(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
@@ -768,7 +775,7 @@ static const struct net_device_ops temac
 	.ndo_open = temac_open,
 	.ndo_stop = temac_stop,
 	.ndo_start_xmit = temac_start_xmit,
-	.ndo_set_mac_address = temac_set_mac_address,
+	.ndo_set_mac_address = netdev_set_mac_address,
 	//.ndo_set_multicast_list = temac_set_multicast_list,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = temac_poll_controller,

