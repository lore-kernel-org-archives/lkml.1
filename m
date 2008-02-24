Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbYBXSAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbYBXSAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYBXSAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:00:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45595 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYBXSAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:00:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Feb 2008 18:59:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/5] firewire: remove superfluous reference counting
To: linux1394-devel@lists.sourceforge.net
cc: Kristian Hoegsberg <krh@bitplanet.net>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
Message-ID: <tkrat.9641f26cb7948075@s5r6.in-berlin.de>
References: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The card->kref became obsolete since patch "firewire: fix crash in
automatic module unloading" added another counter of card users.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c        |   38 ------------------------------
 drivers/firewire/fw-ohci.c        |    8 +++---
 drivers/firewire/fw-transaction.h |    4 ---
 3 files changed, 4 insertions(+), 46 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -398,7 +398,6 @@ fw_card_initialize(struct fw_card *card,
 {
 	static atomic_t index = ATOMIC_INIT(-1);
 
-	kref_init(&card->kref);
 	atomic_set(&card->device_count, 0);
 	card->index = atomic_inc_return(&index);
 	card->driver = driver;
@@ -429,12 +428,6 @@ fw_card_add(struct fw_card *card,
 	card->link_speed = link_speed;
 	card->guid = guid;
 
-	/*
-	 * The subsystem grabs a reference when the card is added and
-	 * drops it when the driver calls fw_core_remove_card.
-	 */
-	fw_card_get(card);
-
 	mutex_lock(&card_mutex);
 	config_rom = generate_config_rom(card, &length);
 	list_add_tail(&card->link, &card_list);
@@ -540,40 +533,9 @@ fw_core_remove_card(struct fw_card *card
 	cancel_delayed_work_sync(&card->work);
 	fw_flush_transactions(card);
 	del_timer_sync(&card->flush_timer);
-
-	fw_card_put(card);
 }
 EXPORT_SYMBOL(fw_core_remove_card);
 
-struct fw_card *
-fw_card_get(struct fw_card *card)
-{
-	kref_get(&card->kref);
-
-	return card;
-}
-EXPORT_SYMBOL(fw_card_get);
-
-static void
-release_card(struct kref *kref)
-{
-	struct fw_card *card = container_of(kref, struct fw_card, kref);
-
-	kfree(card);
-}
-
-/*
- * An assumption for fw_card_put() is that the card driver allocates
- * the fw_card struct with kalloc and that it has been shut down
- * before the last ref is dropped.
- */
-void
-fw_card_put(struct fw_card *card)
-{
-	kref_put(&card->kref, release_card);
-}
-EXPORT_SYMBOL(fw_card_put);
-
 int
 fw_core_initiate_bus_reset(struct fw_card *card, int short_reset)
 {
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -2059,7 +2059,7 @@ pci_probe(struct pci_dev *dev, const str
 	err = pci_enable_device(dev);
 	if (err) {
 		fw_error("Failed to enable OHCI hardware.\n");
-		goto fail_put_card;
+		goto fail_free;
 	}
 
 	pci_set_master(dev);
@@ -2151,8 +2151,8 @@ pci_probe(struct pci_dev *dev, const str
 	pci_release_region(dev, 0);
  fail_disable:
 	pci_disable_device(dev);
- fail_put_card:
-	fw_card_put(&ohci->card);
+ fail_free:
+	kfree(&ohci->card);
 
 	return err;
 }
@@ -2180,7 +2180,7 @@ static void pci_remove(struct pci_dev *d
 	pci_iounmap(dev, ohci->registers);
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
-	fw_card_put(&ohci->card);
+	kfree(&ohci->card);
 
 	fw_notify("Removed fw-ohci device.\n");
 }
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -221,7 +221,6 @@ struct fw_card {
 	const struct fw_card_driver *driver;
 	struct device *device;
 	atomic_t device_count;
-	struct kref kref;
 
 	int node_id;
 	int generation;
@@ -263,9 +262,6 @@ struct fw_card {
 	int bm_generation;
 };
 
-struct fw_card *fw_card_get(struct fw_card *card);
-void fw_card_put(struct fw_card *card);
-
 /*
  * The iso packet format allows for an immediate header/payload part
  * stored in 'header' immediately after the packet info plus an

-- 
Stefan Richter
-=====-==--- --=- ==---
http://arcgraph.de/sr/

