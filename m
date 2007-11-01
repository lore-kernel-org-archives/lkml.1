Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbXKABtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbXKABtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbXKABtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:49:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58781 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXKABtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:49:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 1 Nov 2007 02:49:26 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-core: enforce write order when updating
 fw_device.generation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fw_device.node_id and fw_device.generation are accessed without mutexes.
We have to ensure that all readers will get to see node_id updates
before generation updates.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c   |    6 ++++++
 drivers/firewire/fw-topology.c |    1 +
 2 files changed, 7 insertions(+)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -808,6 +813,7 @@ void fw_node_event(struct fw_card *card,
 
 		device = node->data;
 		device->node_id = node->node_id;
+		wmb();
 		device->generation = card->generation;
 		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -518,6 +518,7 @@ fw_core_handle_bus_reset(struct fw_card 
 		card->bm_retries = 0;
 
 	card->node_id = node_id;
+	wmb();
 	card->generation = generation;
 	card->reset_jiffies = jiffies;
 	schedule_delayed_work(&card->work, 0);

-- 
Stefan Richter
-=====-=-=== =-== ----=
http://arcgraph.de/sr/

