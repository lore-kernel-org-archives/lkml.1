Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbZFIV6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbZFIV6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758729AbZFIV6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:58:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60955 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbZFIV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:58:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 9 Jun 2009 23:56:55 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC patch] firewire: core: don't update Broadcast_Channel if RFC
 2734 conditions aren't met
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.32a3633a10aba874@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extra check will avoid Broadcast_Channel register related traffic
to many IIDC, SBP-2, and AV/C devices which aren't IRMC or have a
max_rec < 8 (i.e. support < 512 bytes async payload).  This avoids a
little bit of traffic after each bus reset and is even more careful
with devices which don't implement this CSR.

The assumption is that no other protocol than IP over 1394 uses the
broadcast channel for streams.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   18 +++++++++++++++++-
 include/linux/firewire.h       |    2 ++
 2 files changed, 19 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/core-device.c
===================================================================
--- linux.orig/drivers/firewire/core-device.c
+++ linux/drivers/firewire/core-device.c
@@ -580,7 +580,9 @@ static int read_bus_info_block(struct fw
 
 	kfree(old_rom);
 	ret = 0;
-	device->cmc = rom[2] >> 30 & 1;
+	device->max_rec	= rom[2] >> 12 & 0xf;
+	device->cmc	= rom[2] >> 30 & 1;
+	device->irmc	= rom[2] >> 31 & 1;
  out:
 	kfree(rom);
 
@@ -841,6 +843,20 @@ static void set_broadcast_channel(struct
 	if (!card->broadcast_channel_allocated)
 		return;
 
+	/*
+	 * The Broadcast_Channel Valid bit is required by nodes which want to
+	 * transmit on this channel.  Such transmissions are practically
+	 * exclusive to IP over 1394 (RFC 2734).  IP capable nodes are required
+	 * to be IRM capable and have a max_rec of 8 or more.  We use this fact
+	 * to narrow down to which nodes we send Broadcast_Channel updates.
+	 */
+	if (!device->irmc || device->max_rec < 8)
+		return;
+
+	/*
+	 * Some 1394-1995 nodes crash if this 1394a-2000 register is written.
+	 * Perform a read test first.
+	 */
 	if (device->bc_implemented == BC_UNKNOWN) {
 		rcode = fw_run_transaction(card, TCODE_READ_QUADLET_REQUEST,
 				device->node_id, generation, device->max_speed,
Index: linux/include/linux/firewire.h
===================================================================
--- linux.orig/include/linux/firewire.h
+++ linux/include/linux/firewire.h
@@ -196,7 +196,9 @@ struct fw_device {
 	size_t config_rom_length;
 	int config_rom_retries;
 	unsigned is_local:1;
+	unsigned max_rec:4;
 	unsigned cmc:1;
+	unsigned irmc:1;
 	unsigned bc_implemented:2;
 
 	struct delayed_work work;

-- 
Stefan Richter
-=====-==--= -==- -=--=
http://arcgraph.de/sr/

