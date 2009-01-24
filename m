Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbZAXTfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbZAXTfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 14:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbZAXTfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 14:35:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58359 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbZAXTfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 14:35:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 20:35:38 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/4] firewire: core: optimize card shutdown
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
Message-ID: <tkrat.f7644fb5a12a1640@s5r6.in-berlin.de>
References: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression by "firewire: keep highlevel drivers attached
during brief connection loss":  There were 2 seconds unnecessary waiting
added to the shutdown procedure of each controller.

We use card->link as status flag to signal the device handler that there
is no use to wait for a come-back.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c   |    2 +-
 drivers/firewire/fw-device.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -495,7 +495,7 @@ void fw_core_remove_card(struct fw_card 
 	fw_core_initiate_bus_reset(card, 1);
 
 	mutex_lock(&card_mutex);
-	list_del(&card->link);
+	list_del_init(&card->link);
 	mutex_unlock(&card_mutex);
 
 	/* Set up the dummy driver. */
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -636,7 +636,8 @@ static void fw_device_shutdown(struct wo
 		container_of(work, struct fw_device, work.work);
 	int minor = MINOR(device->device.devt);
 
-	if (time_is_after_jiffies(device->card->reset_jiffies + SHUTDOWN_DELAY)) {
+	if (time_is_after_jiffies(device->card->reset_jiffies + SHUTDOWN_DELAY)
+	    && !list_empty(&device->card->link)) {
 		schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
 		return;
 	}
@@ -1073,7 +1074,8 @@ void fw_node_event(struct fw_card *card,
 		if (atomic_xchg(&device->state,
 				FW_DEVICE_GONE) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-			schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
+			schedule_delayed_work(&device->work,
+				list_empty(&card->link) ? 0 : SHUTDOWN_DELAY);
 		}
 		break;
 	}

-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

