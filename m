Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXKABwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXKABwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbXKABwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:52:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58856 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXKABwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:52:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 1 Nov 2007 02:51:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: enforce read order of device generation
 and node ID
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
In-Reply-To: <tkrat.005a632d2530a3f9@s5r6.in-berlin.de>
Message-ID: <tkrat.391ef30a1853832e@s5r6.in-berlin.de>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
 <tkrat.005a632d2530a3f9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes:
  - There was a small window where a login or reconnect job could use an
    already updated card generation with an outdated node ID.  We better
    use the fw_device.generation here, not the fw_card.generation.
  - Insert a memory barrier to ensure that the device generation is read
    before the node ID.  This is to guarantee that the generation is not
    newer than the node ID.

A small optimization:
  - The target's and initiator's node IDs can be obtained from fw_device
    and fw_card.  Dereferencing their underlying topology objects is not
    necessary.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -643,9 +643,10 @@ static void sbp2_login(struct work_struc
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
-	generation    = device->card->generation;
-	node_id       = device->node->node_id;
-	local_node_id = device->card->local_node->node_id;
+	generation    = device->generation;
+	rmb();
+	node_id       = device->node_id;
+	local_node_id = device->card->node_id;
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
@@ -900,9 +901,10 @@ static void sbp2_reconnect(struct work_s
 	struct fw_device *device = fw_device(unit->device.parent);
 	int generation, node_id, local_node_id;
 
-	generation    = device->card->generation;
-	node_id       = device->node->node_id;
-	local_node_id = device->card->local_node->node_id;
+	generation    = device->generation;
+	rmb();
+	node_id       = device->node_id;
+	local_node_id = device->card->node_id;
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				     SBP2_RECONNECT_REQUEST,

-- 
Stefan Richter
-=====-=-=== =-== ----=
http://arcgraph.de/sr/

