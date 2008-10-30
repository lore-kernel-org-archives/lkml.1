Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYJ3Bdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYJ3Bdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYJ3Bdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:33:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:40550 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYJ3Bdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:33:36 -0400
Subject: memstick: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:33:37 +0100
Message-Id: <1225330417.5970.92.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: memstick: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Alex Dubov <oakad@yahoo.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index cea4690..a5b448e 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -385,8 +385,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 
 	if (card) {
 		card->host = host;
-		snprintf(card->dev.bus_id, sizeof(card->dev.bus_id),
-			 "%s", host->dev.bus_id);
+		dev_set_name(&card->dev, "%s", dev_name(&host->dev));
 		card->dev.parent = &host->dev;
 		card->dev.bus = &memstick_bus_type;
 		card->dev.release = memstick_free_card;
@@ -519,7 +518,7 @@ int memstick_add_host(struct memstick_host *host)
 	if (rc)
 		return rc;
 
-	snprintf(host->dev.bus_id, BUS_ID_SIZE, "memstick%u", host->id);
+	dev_set_name(&host->dev, "memstick%u", host->id);
 
 	rc = device_add(&host->dev);
 	if (rc) {
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 7911151..1f1e398 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -887,14 +887,14 @@ try_again:
 	if (rc) {
 		printk(KERN_WARNING
 		       "%s: could not switch to 4-bit mode, error %d\n",
-		       card->dev.bus_id, rc);
+		       dev_name(&card->dev), rc);
 		return 0;
 	}
 
 	msb->system = MEMSTICK_SYS_PAR4;
 	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PAR4);
 	printk(KERN_INFO "%s: switching to 4-bit parallel mode\n",
-	       card->dev.bus_id);
+	       dev_name(&card->dev));
 
 	if (msb->caps & MEMSTICK_CAP_PAR8) {
 		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR8);
@@ -905,11 +905,11 @@ try_again:
 					MEMSTICK_PAR8);
 			printk(KERN_INFO
 			       "%s: switching to 8-bit parallel mode\n",
-			       card->dev.bus_id);
+			       dev_name(&card->dev));
 		} else
 			printk(KERN_WARNING
 			       "%s: could not switch to 8-bit mode, error %d\n",
-			       card->dev.bus_id, rc);
+			       dev_name(&card->dev), rc);
 	}
 
 	card->next_request = h_mspro_block_req_init;
@@ -922,7 +922,7 @@ try_again:
 	if (rc) {
 		printk(KERN_WARNING
 		       "%s: interface error, trying to fall back to serial\n",
-		       card->dev.bus_id);
+		       dev_name(&card->dev));
 		msb->system = MEMSTICK_SYS_SERIAL;
 		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
 		msleep(10);
@@ -992,14 +992,14 @@ static int mspro_block_read_attributes(struct memstick_dev *card)
 
 	if (be16_to_cpu(attr->signature) != MSPRO_BLOCK_SIGNATURE) {
 		printk(KERN_ERR "%s: unrecognized device signature %x\n",
-		       card->dev.bus_id, be16_to_cpu(attr->signature));
+		       dev_name(&card->dev), be16_to_cpu(attr->signature));
 		rc = -ENODEV;
 		goto out_free_attr;
 	}
 
 	if (attr->count > MSPRO_BLOCK_MAX_ATTRIBUTES) {
 		printk(KERN_WARNING "%s: way too many attribute entries\n",
-		       card->dev.bus_id);
+		       dev_name(&card->dev));
 		attr_count = MSPRO_BLOCK_MAX_ATTRIBUTES;
 	} else
 		attr_count = attr->count;
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index d32d6ad..03f71a4 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -546,7 +546,7 @@ static void tifm_ms_abort(unsigned long data)
 	printk(KERN_ERR
 	       "%s : card failed to respond for a long period of time "
 	       "(%x, %x)\n",
-	       host->dev->dev.bus_id, host->req ? host->req->tpc : 0,
+	       dev_name(&host->dev->dev), host->req ? host->req->tpc : 0,
 	       host->cmd_flags);
 
 	tifm_eject(host->dev);
@@ -561,7 +561,7 @@ static int tifm_ms_probe(struct tifm_dev *sock)
 	if (!(TIFM_SOCK_STATE_OCCUPIED
 	      & readl(sock->addr + SOCK_PRESENT_STATE))) {
 		printk(KERN_WARNING "%s : card gone, unexpectedly\n",
-		       sock->dev.bus_id);
+		       dev_name(&sock->dev));
 		return rc;
 	}
 

