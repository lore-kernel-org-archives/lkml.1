Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZAFWZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZAFWZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbZAFWNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:53 -0500
Received: from kroah.org ([198.145.64.141]:51272 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756002AbZAFWNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/60] pnp: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:53 -0800
Message-Id: <1231279939-32728-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pnp/card.c   |    7 +++----
 drivers/pnp/core.c   |    5 ++---
 drivers/pnp/system.c |    2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
index e75b060..efea128 100644
--- a/drivers/pnp/card.c
+++ b/drivers/pnp/card.c
@@ -165,8 +165,7 @@ struct pnp_card *pnp_alloc_card(struct pnp_protocol *protocol, int id, char *pnp
 	card->number = id;
 
 	card->dev.parent = &card->protocol->dev;
-	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number,
-		card->number);
+	dev_set_name(&card->dev, "%02x:%02x", card->protocol->number, card->number);
 
 	card->dev.coherent_dma_mask = DMA_24BIT_MASK;
 	card->dev.dma_mask = &card->dev.coherent_dma_mask;
@@ -295,8 +294,8 @@ int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev)
 {
 	dev->dev.parent = &card->dev;
 	dev->card_link = NULL;
-	snprintf(dev->dev.bus_id, BUS_ID_SIZE, "%02x:%02x.%02x",
-		 dev->protocol->number, card->number, dev->number);
+	dev_set_name(&dev->dev, "%02x:%02x.%02x",
+		     dev->protocol->number, card->number, dev->number);
 	spin_lock(&pnp_lock);
 	dev->card = card;
 	list_add_tail(&dev->card_list, &card->devices);
diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index 16c01c6..14814f2 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -70,7 +70,7 @@ int pnp_register_protocol(struct pnp_protocol *protocol)
 	spin_unlock(&pnp_lock);
 
 	protocol->number = nodenum;
-	sprintf(protocol->dev.bus_id, "pnp%d", nodenum);
+	dev_set_name(&protocol->dev, "pnp%d", nodenum);
 	return device_register(&protocol->dev);
 }
 
@@ -145,8 +145,7 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *protocol, int id, char *pnpid
 	dev->dev.coherent_dma_mask = dev->dma_mask;
 	dev->dev.release = &pnp_release_device;
 
-	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
-		dev->number);
+	dev_set_name(&dev->dev, "%02x:%02x", dev->protocol->number, dev->number);
 
 	dev_id = pnp_add_id(dev, pnpid);
 	if (!dev_id) {
diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
index 764f3a3..59b9092 100644
--- a/drivers/pnp/system.c
+++ b/drivers/pnp/system.c
@@ -26,7 +26,7 @@ static void reserve_range(struct pnp_dev *dev, resource_size_t start,
 			  resource_size_t end, int port)
 {
 	char *regionid;
-	const char *pnpid = dev->dev.bus_id;
+	const char *pnpid = dev_name(&dev->dev);
 	struct resource *res;
 
 	regionid = kmalloc(16, GFP_KERNEL);
-- 
1.6.0.4

