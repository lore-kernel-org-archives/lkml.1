Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbXGEHvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbXGEHvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 03:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbXGEHvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 03:51:24 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:14261 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbXGEHvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 03:51:23 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 1/2] eHEA: Capability flag for DLPAR support
Date: Thu, 5 Jul 2007 09:26:25 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707050926.26087.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a capability flag that is used by the DLPAR userspace
tool to check which DLPAR features are supported by the eHEA driver.

Missing goto has been included.

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
---
 drivers/net/ehea/ehea.h      |    8 +++++++-
 drivers/net/ehea/ehea_main.c |   23 ++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ehea/ehea.h b/drivers/net/ehea/ehea.h
index abaf3ac..f03f070 100644
--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -39,7 +39,13 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0065"
+#define DRV_VERSION	"EHEA_0067"
+
+/* EHEA capability flags */
+#define DLPAR_PORT_ADD_REM 1
+#define DLPAR_MEM_ADD 2
+#define DLPAR_MEM_REM 4
+#define EHEA_CAPABILITIES (DLPAR_PORT_ADD_REM)
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index bdb5241..383144d 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -2923,6 +2923,15 @@ static int check_module_parm(void)
 	return ret;
 }
 
+static ssize_t ehea_show_capabilities(struct device_driver *drv,
+				      char *buf)
+{
+	return sprintf(buf, "%d", EHEA_CAPABILITIES);
+}
+
+static DRIVER_ATTR(capabilities, S_IRUSR | S_IRGRP | S_IROTH,
+		   ehea_show_capabilities, NULL);
+
 int __init ehea_module_init(void)
 {
 	int ret;
@@ -2934,8 +2943,19 @@ int __init ehea_module_init(void)
 	if (ret)
 		goto out;
 	ret = ibmebus_register_driver(&ehea_driver);
-	if (ret)
+	if (ret) {
 		ehea_error("failed registering eHEA device driver on ebus");
+		goto out;
+	}
+
+	ret = driver_create_file(&ehea_driver.driver,
+				 &driver_attr_capabilities);
+	if (ret) {
+		ehea_error("failed to register capabilities attribute, ret=%d",
+			   ret);
+		ibmebus_unregister_driver(&ehea_driver);
+		goto out;
+	}
 
 out:
 	return ret;
@@ -2943,6 +2963,7 @@ out:
 
 static void __exit ehea_module_exit(void)
 {
+	driver_remove_file(&ehea_driver.driver, &driver_attr_capabilities);
 	ibmebus_unregister_driver(&ehea_driver);
 }
 
-- 
1.5.2

