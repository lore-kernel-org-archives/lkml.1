Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZBCQzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZBCQzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZBCQz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:55:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57231 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbZBCQz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:55:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 3 Feb 2009 17:55:19 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: normalize a variable name
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.95a4ed13fc19ac55@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize on	if (err)
			handle_error;
           and	if (ret < 0)
			handle_error;

Don't call a variable err if we store values in it which mean success.
Also, offset some return statements by a blank line since this how we do
it in drivers/firewire.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c   |    9 +++++----
 drivers/firewire/fw-device.c |    6 +++---
 drivers/firewire/fw-iso.c    |   10 ++++++----
 drivers/firewire/fw-ohci.c   |    3 ++-
 4 files changed, 16 insertions(+), 12 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -404,7 +404,7 @@ int fw_card_add(struct fw_card *card,
 {
 	u32 *config_rom;
 	size_t length;
-	int err;
+	int ret;
 
 	card->max_receive = max_receive;
 	card->link_speed = link_speed;
@@ -415,13 +415,14 @@ int fw_card_add(struct fw_card *card,
 	list_add_tail(&card->link, &card_list);
 	mutex_unlock(&card_mutex);
 
-	err = card->driver->enable(card, config_rom, length);
-	if (err < 0) {
+	ret = card->driver->enable(card, config_rom, length);
+	if (ret < 0) {
 		mutex_lock(&card_mutex);
 		list_del(&card->link);
 		mutex_unlock(&card_mutex);
 	}
-	return err;
+
+	return ret;
 }
 EXPORT_SYMBOL(fw_card_add);
 
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -761,7 +761,7 @@ static void fw_device_init(struct work_s
 	struct fw_device *device =
 		container_of(work, struct fw_device, work.work);
 	struct device *revived_dev;
-	int minor, err;
+	int minor, ret;
 
 	/*
 	 * All failure paths here set node->data to NULL, so that we
@@ -797,12 +797,12 @@ static void fw_device_init(struct work_s
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	err = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
+	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
 	      idr_get_new(&fw_device_idr, device, &minor) :
 	      -ENOMEM;
 	up_write(&fw_device_rwsem);
 
-	if (err < 0)
+	if (ret < 0)
 		goto error;
 
 	device->device.bus = &fw_bus_type;
Index: linux/drivers/firewire/fw-iso.c
===================================================================
--- linux.orig/drivers/firewire/fw-iso.c
+++ linux/drivers/firewire/fw-iso.c
@@ -75,19 +75,21 @@ int fw_iso_buffer_init(struct fw_iso_buf
 	kfree(buffer->pages);
  out:
 	buffer->pages = NULL;
+
 	return -ENOMEM;
 }
 
 int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma)
 {
 	unsigned long uaddr;
-	int i, ret;
+	int i, err;
 
 	uaddr = vma->vm_start;
 	for (i = 0; i < buffer->page_count; i++) {
-		ret = vm_insert_page(vma, uaddr, buffer->pages[i]);
-		if (ret)
-			return ret;
+		err = vm_insert_page(vma, uaddr, buffer->pages[i]);
+		if (err)
+			return err;
+
 		uaddr += PAGE_SIZE;
 	}
 
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -2459,11 +2459,12 @@ static int __devinit pci_probe(struct pc
 		reg_read(ohci, OHCI1394_GUIDLo);
 
 	err = fw_card_add(&ohci->card, max_receive, link_speed, guid);
-	if (err < 0)
+	if (err)
 		goto fail_self_id;
 
 	fw_notify("Added fw-ohci device %s, OHCI version %x.%x\n",
 		  dev_name(&dev->dev), version >> 16, version & 0xff);
+
 	return 0;
 
  fail_self_id:

-- 
Stefan Richter
-=====-==--= --=- ---==
http://arcgraph.de/sr/

