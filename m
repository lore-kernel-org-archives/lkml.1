Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbXKABut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbXKABut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbXKABul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:50:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58821 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbXKABuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:50:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 1 Nov 2007 02:50:30 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-core: react on bus resets while the config ROM
 is being fetched
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
In-Reply-To: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
Message-ID: <tkrat.005a632d2530a3f9@s5r6.in-berlin.de>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

read_rom() obtained a fresh new fw_device.generation for each read
transaction (unless the compiler performed very aggressive inlining in
read_bus_info_block).  It's unlikely but not impossible that we could
end up with a corrupt fetched ROM image if there was a generation change
during the ROM reading.

We now restart reading the ROM if the bus generation changed.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -391,7 +391,8 @@ complete_transaction(struct fw_card *car
 	complete(&callback_data->done);
 }
 
-static int read_rom(struct fw_device *device, int index, u32 * data)
+static int
+read_rom(struct fw_device *device, int generation, int index, u32 *data)
 {
 	struct read_quadlet_callback_data callback_data;
 	struct fw_transaction t;
@@ -401,7 +402,7 @@ static int read_rom(struct fw_device *de
 
 	offset = 0xfffff0000400ULL + index * 4;
 	fw_send_request(device->card, &t, TCODE_READ_QUADLET_REQUEST,
-			device->node_id, device->generation, device->max_speed,
+			device->node_id, generation, device->max_speed,
 			offset, NULL, 4, complete_transaction, &callback_data);
 
 	wait_for_completion(&callback_data.done);
@@ -411,7 +412,14 @@ static int read_rom(struct fw_device *de
 	return callback_data.rcode;
 }
 
-static int read_bus_info_block(struct fw_device *device)
+/*
+ * Read the bus info block, perform a speed probe, and read all of the rest of
+ * the config ROM.  We do all this with a cached bus generation.  If the bus
+ * generation changes under us, read_bus_info_block will fail and get retried.
+ * It's better to start all over in this case because the node from which we
+ * are reading the ROM may have changed the ROM during the reset.
+ */
+static int read_bus_info_block(struct fw_device *device, int generation)
 {
 	static u32 rom[256];
 	u32 stack[16], sp, key;
@@ -421,7 +429,7 @@ static int read_bus_info_block(struct fw
 
 	/* First read the bus info block. */
 	for (i = 0; i < 5; i++) {
-		if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
 			return -1;
 		/*
 		 * As per IEEE1212 7.2, during power-up, devices can
@@ -456,7 +464,8 @@ static int read_bus_info_block(struct fw
 			device->max_speed = device->card->link_speed;
 
 		while (device->max_speed > SCODE_100) {
-			if (read_rom(device, 0, &dummy) == RCODE_COMPLETE)
+			if (read_rom(device, generation, 0, &dummy) ==
+			    RCODE_COMPLETE)
 				break;
 			device->max_speed--;
 		}
@@ -489,7 +498,7 @@ static int read_bus_info_block(struct fw
 			return -1;
 
 		/* Read header quadlet for the block to get the length. */
-		if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
 			return -1;
 		end = i + (rom[i] >> 16) + 1;
 		i++;
@@ -508,7 +517,8 @@ static int read_bus_info_block(struct fw
 		 * it references another block, and push it in that case.
 		 */
 		while (i < end) {
-			if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+			if (read_rom(device, generation, i, &rom[i]) !=
+			    RCODE_COMPLETE)
 				return -1;
 			if ((key >> 30) == 3 && (rom[i] >> 30) > 1 &&
 			    sp < ARRAY_SIZE(stack))
@@ -655,7 +665,7 @@ static void fw_device_init(struct work_s
 	 * device.
 	 */
 
-	if (read_bus_info_block(device) < 0) {
+	if (read_bus_info_block(device, device->generation) < 0) {
 		if (device->config_rom_retries < MAX_RETRIES) {
 			device->config_rom_retries++;
 			schedule_delayed_work(&device->work, RETRY_DELAY);

-- 
Stefan Richter
-=====-=-=== =-== ----=
http://arcgraph.de/sr/

