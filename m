Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYLMF6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYLMF6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYLMF5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:57:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:30078 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYLMF5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:57:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ls6bwz93eB9gGXwT0E8ybQ0Zd5Fbx6IDgnQPC5xFAE8ftfVeEDmceWmceB9WKxcYGe
         NRZuij+Nvxn86uSRizRqF7C6f1ks50+fTeXUrx6WvZTIH4L4VXeH3HLVKk/fMm1JXh/J
         A6iXZMzHrvLgr2+rlm9yENxESrjxLaUZHFZ64=
Subject: [PATCH] ieee1394: consolidate uses of IEEE1934_BUSID_MAGIC
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 21:57:50 -0800
Message-Id: <1229147871.11257.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition out of nodemgr.h and use it in csr.c/pcilynx.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ieee1394/csr.c      |    4 ++--
 drivers/ieee1394/ieee1394.h |    3 +++
 drivers/ieee1394/nodemgr.h  |    3 ---
 drivers/ieee1394/pcilynx.c  |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ieee1394/csr.c b/drivers/ieee1394/csr.c
index 9029b68..31400c8 100644
--- a/drivers/ieee1394/csr.c
+++ b/drivers/ieee1394/csr.c
@@ -217,7 +217,7 @@ static void add_host(struct hpsb_host *host)
 
 	host->csr.generation = 2;
 
-	bus_info[1] = __constant_cpu_to_be32(0x31333934);
+	bus_info[1] = IEEE1394_BUSID_MAGIC;
 	bus_info[2] = cpu_to_be32((hpsb_disable_irm ? 0 : 1 << CSR_IRMC_SHIFT) |
 				  (1 << CSR_CMC_SHIFT) |
 				  (1 << CSR_ISC_SHIFT) |
@@ -250,7 +250,7 @@ static void remove_host(struct hpsb_host *host)
 {
 	quadlet_t bus_info[CSR_BUS_INFO_SIZE];
 
-	bus_info[1] = __constant_cpu_to_be32(0x31333934);
+	bus_info[1] = IEEE1394_BUSID_MAGIC;
 	bus_info[2] = cpu_to_be32((0 << CSR_IRMC_SHIFT) |
 				  (0 << CSR_CMC_SHIFT) |
 				  (0 << CSR_ISC_SHIFT) |
diff --git a/drivers/ieee1394/ieee1394.h b/drivers/ieee1394/ieee1394.h
index 4049207..976d1a8 100644
--- a/drivers/ieee1394/ieee1394.h
+++ b/drivers/ieee1394/ieee1394.h
@@ -121,6 +121,9 @@ extern const char *hpsb_speedto_str[];
 
 #include <asm/byteorder.h>
 
+/* '1' '3' '9' '4' in ASCII */
+#define IEEE1394_BUSID_MAGIC	cpu_to_be32(0x31333934)
+
 #ifdef __BIG_ENDIAN_BITFIELD
 
 struct selfid {
diff --git a/drivers/ieee1394/nodemgr.h b/drivers/ieee1394/nodemgr.h
index d9391ef..ee5acdb 100644
--- a/drivers/ieee1394/nodemgr.h
+++ b/drivers/ieee1394/nodemgr.h
@@ -33,9 +33,6 @@ struct csr1212_keyval;
 struct hpsb_host;
 struct ieee1394_device_id;
 
-/* '1' '3' '9' '4' in ASCII */
-#define IEEE1394_BUSID_MAGIC	__constant_cpu_to_be32(0x31333934)
-
 /* This is the start of a Node entry structure. It should be a stable API
  * for which to gather info from the Node Manager about devices attached
  * to the bus.  */
diff --git a/drivers/ieee1394/pcilynx.c b/drivers/ieee1394/pcilynx.c
index 7aee1ac..dc15cad 100644
--- a/drivers/ieee1394/pcilynx.c
+++ b/drivers/ieee1394/pcilynx.c
@@ -1463,7 +1463,7 @@ static int __devinit add_card(struct pci_dev *dev,
 
                                 /* info_length, crc_length and 1394 magic number to check, if it is really a bus info block */
 				if (((be32_to_cpu(lynx->bus_info_block[0]) & 0xffff0000) == 0x04040000) &&
-				    (lynx->bus_info_block[1] == __constant_cpu_to_be32(0x31333934)))
+				    (lynx->bus_info_block[1] == IEEE1394_BUSID_MAGIC))
                                 {
                                         PRINT(KERN_DEBUG, lynx->id, "read a valid bus info block from");
                                 } else {
-- 
1.6.1.rc2.306.ge5d5e



