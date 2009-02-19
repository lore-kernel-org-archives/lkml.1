Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZBSLcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZBSLcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZBSLcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:32:20 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:34966 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZBSLcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:32:19 -0500
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] ehea: Fix memory hotplug handling
From: Thomas Klein <tklein@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, Hannes Hering <hering2@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>
Date: Thu, 19 Feb 2009 12:32:11 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191232.12152.tklein@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing set_bit() to disable data transfer when a memchange notification is handled

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
---
diff -Nurp -X dontdiff linux-2.6.29-rc4/drivers/net/ehea/ehea.h patched_kernel/drivers/net/ehea/ehea.h
--- linux-2.6.29-rc4/drivers/net/ehea/ehea.h	2009-02-18 16:59:54.000000000 +0100
+++ patched_kernel/drivers/net/ehea/ehea.h	2009-02-18 17:01:12.000000000 +0100
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0098"
+#define DRV_VERSION	"EHEA_0099"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
diff -Nurp -X dontdiff linux-2.6.29-rc4/drivers/net/ehea/ehea_main.c patched_kernel/drivers/net/ehea/ehea_main.c
--- linux-2.6.29-rc4/drivers/net/ehea/ehea_main.c	2009-02-18 16:59:54.000000000 +0100
+++ patched_kernel/drivers/net/ehea/ehea_main.c	2009-02-18 17:01:12.000000000 +0100
@@ -3517,12 +3517,14 @@ static int ehea_mem_notifier(struct noti
 		/* Readd canceled memory block */
 	case MEM_ONLINE:
 		ehea_info("memory is going online");
+		set_bit(__EHEA_STOP_XFER, &ehea_driver_flags);
 		if (ehea_add_sect_bmap(arg->start_pfn, arg->nr_pages))
 			return NOTIFY_BAD;
 		ehea_rereg_mrs(NULL);
 		break;
 	case MEM_GOING_OFFLINE:
 		ehea_info("memory is going offline");
+		set_bit(__EHEA_STOP_XFER, &ehea_driver_flags);
 		if (ehea_rem_sect_bmap(arg->start_pfn, arg->nr_pages))
 			return NOTIFY_BAD;
 		ehea_rereg_mrs(NULL);
