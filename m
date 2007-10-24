Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbXJXJyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbXJXJyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbXJXJyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:54:18 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:46337 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXJXJyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:54:17 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH] ehea: fix port_napi_disable/enable
Date: Wed, 24 Oct 2007 11:53:34 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200710241153.34992.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

napi_disable / napi_enable must be applied on all ehea queues.

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

---
 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ehea/ehea.h b/drivers/net/ehea/ehea.h
index b557bb4..4b4b74e 100644
--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0078"
+#define DRV_VERSION	"EHEA_0079"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index fe5ffac..a8b05d2 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -2329,7 +2329,7 @@ static void port_napi_disable(struct ehea_port *port)
 {
 	int i;
 
-	for (i = 0; i < port->num_def_qps; i++)
+	for (i = 0; i < port->num_def_qps + port->num_add_tx_qps; i++)
 		napi_disable(&port->port_res[i].napi);
 }
 
@@ -2337,7 +2337,7 @@ static void port_napi_enable(struct ehea_port *port)
 {
 	int i;
 
-	for (i = 0; i < port->num_def_qps; i++)
+	for (i = 0; i < port->num_def_qps + port->num_add_tx_qps; i++)
 		napi_enable(&port->port_res[i].napi);
 }
 
@@ -2373,8 +2373,6 @@ static int ehea_down(struct net_device *dev)
 	ehea_drop_multicast_list(dev);
 	ehea_free_interrupts(dev);
 
-	port_napi_disable(port);
-
 	port->state = EHEA_PORT_DOWN;
 
 	ret = ehea_clean_all_portres(port);
@@ -2396,6 +2394,7 @@ static int ehea_stop(struct net_device *dev)
 	flush_scheduled_work();
 	down(&port->port_lock);
 	netif_stop_queue(dev);
+	port_napi_disable(port);
 	ret = ehea_down(dev);
 	up(&port->port_lock);
 	return ret;
-- 
1.5.2

