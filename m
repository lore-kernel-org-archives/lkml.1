Return-Path: <linux-kernel-owner+w=401wt.eu-S1764982AbXHDQjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764982AbXHDQjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764116AbXHDQiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:38:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38469 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763580AbXHDQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:38:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 4 Aug 2007 18:38:32 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.22.y] firewire: fw-sbp2: set correct maximum payload
 (fixes CardBus adapters)
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.b27dd750915a9510@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I know, all CardBus FireWire 400 adapters have a maximum
payload of 1024 bytes which is less than the speed-dependent limit of
2048 bytes.  Fw-sbp2 has to take the host adapter's limit into account.

This apparently fixes Juju's incompatibility with my CardBus cards, a
NEC based card and a VIA based card.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Backport of commit 25659f7183376c6b37661da6141d5eaa21479061.

 drivers/firewire/fw-sbp2.c        |    5 ++++-
 drivers/firewire/fw-transaction.h |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.22/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.22.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.22/drivers/firewire/fw-sbp2.c
@@ -985,6 +985,7 @@ static int sbp2_scsi_queuecommand(struct
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_command_orb *orb;
+	unsigned max_payload;
 
 	/*
 	 * Bidirectional commands are not yet implemented, and unknown
@@ -1023,8 +1024,10 @@ static int sbp2_scsi_queuecommand(struct
 	 * specifies the max payload size as 2 ^ (max_payload + 2), so
 	 * if we set this to max_speed + 7, we get the right value.
 	 */
+	max_payload = device->node->max_speed + 7;
+	max_payload = min(max_payload, device->card->max_receive - 1);
 	orb->request.misc =
-		COMMAND_ORB_MAX_PAYLOAD(device->node->max_speed + 7) |
+		COMMAND_ORB_MAX_PAYLOAD(max_payload) |
 		COMMAND_ORB_SPEED(device->node->max_speed) |
 		COMMAND_ORB_NOTIFY;
 
Index: linux-2.6.22/drivers/firewire/fw-transaction.h
===================================================================
--- linux-2.6.22.orig/drivers/firewire/fw-transaction.h
+++ linux-2.6.22/drivers/firewire/fw-transaction.h
@@ -232,7 +232,7 @@ struct fw_card {
 	unsigned long reset_jiffies;
 
 	unsigned long long guid;
-	int max_receive;
+	unsigned max_receive;
 	int link_speed;
 	int config_rom_generation;
 

-- 
Stefan Richter
-=====-=-=== =--- --=--
http://arcgraph.de/sr/

