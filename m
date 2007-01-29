Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbXA2RoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbXA2RoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXA2RoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:44:06 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:1789 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbXA2RoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:44:04 -0500
From: Thomas Klein <osstklei@de.ibm.com>
Subject: [PATCH 2.6.20-rc6 1/2] ehea: Fixed wrong jumbo frames status query
Date: Mon, 29 Jan 2007 18:44:01 +0100
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2979
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <ossthema@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200701291844.01887.osstklei@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the wrong query and logging of the per interface jumbo frames
enabled/disabled status.


Signed-off-by: Thomas Klein <tklein@de.ibm.com>
---


 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |   30 +++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)


diff -Nurp -X dontdiff linux-2.6.20-rc6/drivers/net/ehea/ehea.h patched_kernel/drivers/net/ehea/ehea.h
--- linux-2.6.20-rc6/drivers/net/ehea/ehea.h	2007-01-25 03:19:28.000000000 +0100
+++ patched_kernel/drivers/net/ehea/ehea.h	2007-01-29 18:32:02.000000000 +0100
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0044"
+#define DRV_VERSION	"EHEA_0045"
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
diff -Nurp -X dontdiff linux-2.6.20-rc6/drivers/net/ehea/ehea_main.c patched_kernel/drivers/net/ehea/ehea_main.c
--- linux-2.6.20-rc6/drivers/net/ehea/ehea_main.c	2007-01-25 03:19:28.000000000 +0100
+++ patched_kernel/drivers/net/ehea/ehea_main.c	2007-01-29 18:32:02.000000000 +0100
@@ -2316,6 +2316,7 @@ static int ehea_setup_single_port(struct
 	struct ehea_adapter *adapter = port->adapter;
 	struct hcp_ehea_port_cb4 *cb4;
 	u32 *dn_log_port_id;
+	int jumbo = 0;
 
 	sema_init(&port->port_lock, 1);
 	port->state = EHEA_PORT_DOWN;
@@ -2357,13 +2358,25 @@ static int ehea_setup_single_port(struct
 	if (!cb4) {
 		ehea_error("no mem for cb4");
 	} else {
-		cb4->jumbo_frame = 1;
-		hret = ehea_h_modify_ehea_port(adapter->handle,
-					       port->logical_port_id,
-					       H_PORT_CB4, H_PORT_CB4_JUMBO,
-					       cb4);
-		if (hret != H_SUCCESS) {
-			ehea_info("Jumbo frames not activated");
+		hret = ehea_h_query_ehea_port(adapter->handle,
+					      port->logical_port_id,
+					      H_PORT_CB4,
+					      H_PORT_CB4_JUMBO, cb4);
+
+		if (hret == H_SUCCESS) {
+			if (cb4->jumbo_frame)
+				jumbo = 1;
+			else {
+				cb4->jumbo_frame = 1;
+				hret = ehea_h_modify_ehea_port(adapter->handle,
+							       port->
+							        logical_port_id,
+							       H_PORT_CB4,
+							       H_PORT_CB4_JUMBO,
+							       cb4);
+				if (hret == H_SUCCESS)
+					jumbo = 1;
+			}
 		}
 		kfree(cb4);
 	}
@@ -2402,6 +2415,9 @@ static int ehea_setup_single_port(struct
 		goto out_free;
 	}
 
+	ehea_info("%s: Jumbo frames are %sabled", dev->name,
+		  jumbo == 1 ? "en" : "dis");
+
 	port->netdev = dev;
 	ret = 0;
 	goto out;


