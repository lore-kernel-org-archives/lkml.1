Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZHDOUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZHDOUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZHDOUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:20:30 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:60308 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbZHDOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:20:29 -0400
From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Subject: [PATCH 2.6.31] ehea: Fix napi list corruption on ifconfig down
Date: Tue, 4 Aug 2009 16:20:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.26-2-amd64; KDE/4.2.2; x86_64; ; )
Organization: IBM
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041620.16542.hannes.hering@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the napi list handling when an ehea interface is shut down to
avoid corruption of the napi list.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>

---

diff -Nurp -X dontdiff linux-2.6.31-rc5/drivers/net/ehea/ehea.h patched_kernel/drivers/net/ehea/ehea.h
--- linux-2.6.31-rc5/drivers/net/ehea/ehea.h	2009-08-01 02:40:45.000000000 +0200
+++ patched_kernel/drivers/net/ehea/ehea.h	2009-08-03 17:59:26.696079433 +0200
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0101"
+#define DRV_VERSION	"EHEA_0102"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
diff -Nurp -X dontdiff linux-2.6.31-rc5/drivers/net/ehea/ehea_main.c patched_kernel/drivers/net/ehea/ehea_main.c
--- linux-2.6.31-rc5/drivers/net/ehea/ehea_main.c	2009-08-01 02:40:45.000000000 +0200
+++ patched_kernel/drivers/net/ehea/ehea_main.c	2009-08-03 17:59:26.696079433 +0200
@@ -1545,6 +1545,9 @@ static int ehea_clean_portres(struct ehe
 {
 	int ret, i;
 
+	if (pr->qp)
+		netif_napi_del(&pr->napi);
+
 	ret = ehea_destroy_qp(pr->qp);
 
 	if (!ret) {
