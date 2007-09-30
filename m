Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbXI3W6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbXI3W6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbXI3W5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:57:49 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50548 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbXI3W5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:57:48 -0400
Date: Sun, 30 Sep 2007 16:57:21 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 4/6] Sysace: minor rework and cleanup changes
In-reply-to: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
Message-id: <20070930225720.2476.45305.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Miscellanious rework to the sysace driver; Not critical, but makes the
subsequent addition of the of_platform bus binding a wee bit cleaner

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/block/xsysace.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 555939b..10bb4e5 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -158,6 +158,9 @@ MODULE_LICENSE("GPL");
 #define ACE_FIFO_SIZE (32)
 #define ACE_BUF_PER_SECTOR (ACE_SECTOR_SIZE / ACE_FIFO_SIZE)
 
+#define ACE_BUS_WIDTH_8  0
+#define ACE_BUS_WIDTH_16 1
+
 struct ace_reg_ops;
 
 struct ace_device {
@@ -931,9 +934,11 @@ static int __devinit ace_setup(struct ace_device *ace)
 {
 	u16 version;
 	u16 val;
-
 	int rc;
 
+	dev_dbg(ace->dev, "ace_setup(ace=0x%p)\n", ace);
+	dev_dbg(ace->dev, "physaddr=0x%lx irq=%i\n", ace->physaddr, ace->irq);
+
 	spin_lock_init(&ace->lock);
 	init_completion(&ace->id_completion);
 
@@ -982,7 +987,7 @@ static int __devinit ace_setup(struct ace_device *ace)
 	snprintf(ace->gd->disk_name, 32, "xs%c", ace->id + 'a');
 
 	/* set bus width */
-	if (ace->bus_width == 1) {
+	if (ace->bus_width == ACE_BUS_WIDTH_16) {
 		/* 0x0101 should work regardless of endianess */
 		ace_out_le16(ace, ACE_BUSMODE, 0x0101);
 
@@ -1117,7 +1122,7 @@ static void __devexit ace_free(struct device *dev)
 static int __devinit ace_probe(struct platform_device *dev)
 {
 	unsigned long physaddr = 0;
-	int bus_width = 1; /* FIXME: should not be hard coded */
+	int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard coded */
 	int id = dev->id;
 	int irq = NO_IRQ;
 	int i;
@@ -1166,6 +1171,7 @@ static int __init ace_init(void)
 		goto err_blk;
 	}
 
+	pr_debug("xsysace: registering platform binding\n");
 	if ((rc = platform_driver_register(&ace_platform_driver)) != 0)
 		goto err_plat;
 

