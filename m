Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYAXAyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYAXAyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYAXAxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:53:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45335 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYAXAxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:53:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 24 Jan 2008 01:53:19 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4] firewire: fw-sbp2: use device generation, not card
 generation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Jarod Wilson <jwilson@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
Message-ID: <tkrat.a4385a83e8dc9e8d@s5r6.in-berlin.de>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
 <200711011453.35268.nickpiggin@yahoo.com.au>
 <4729A1BF.8010800@s5r6.in-berlin.de>
 <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a small window where a login or reconnect job could use an
already updated card generation with an outdated node ID.  We have to
use the fw_device.generation here, not the fw_card.generation, because
the generation must never be newer than the node ID when we emit a
transaction.  This cannot be guaranteed with fw_card.generation.

Furthermore, the target's and initiator's node IDs can be obtained from
fw_device and fw_card.  Dereferencing their underlying topology objects
is not necessary.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Rework of patch "firewire: fw-sbp2: enforce read order of device
generation and node ID" from November 1 2007.

This code also needs barriers to work precisely as intended.  They will
be added by a subsequent patch which consistently updates readers and
writers of .generation and .node_id.

 drivers/firewire/fw-sbp2.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -671,9 +671,9 @@ static void sbp2_login(struct work_struc
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
-	generation    = device->card->generation;
-	node_id       = device->node->node_id;
-	local_node_id = device->card->local_node->node_id;
+	generation    = device->generation;
+	node_id       = device->node_id;
+	local_node_id = device->card->node_id;
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
@@ -921,9 +921,9 @@ static void sbp2_reconnect(struct work_s
 	struct fw_device *device = fw_device(unit->device.parent);
 	int generation, node_id, local_node_id;
 
-	generation    = device->card->generation;
-	node_id       = device->node->node_id;
-	local_node_id = device->card->local_node->node_id;
+	generation    = device->generation;
+	node_id       = device->node_id;
+	local_node_id = device->card->node_id;
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				     SBP2_RECONNECT_REQUEST,

-- 
Stefan Richter
-=====-==--- ---= ==---
http://arcgraph.de/sr/

