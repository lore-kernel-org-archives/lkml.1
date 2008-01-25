Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYAYQyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYAYQyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYAYQyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:54:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57824 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYAYQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:54:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 25 Jan 2008 17:53:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4 update] firewire: fw-core: react on bus resets while the
 config ROM is being fetched
To: Jarod Wilson <jwilson@redhat.com>
cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4798E664.2040405@redhat.com>
Message-ID: <tkrat.34be174a07a7f85e@s5r6.in-berlin.de>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
 <200711011453.35268.nickpiggin@yahoo.com.au>
 <4729A1BF.8010800@s5r6.in-berlin.de>
 <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
 <tkrat.9c7056f105b7d6a9@s5r6.in-berlin.de> <4798B8BA.9090203@redhat.com>
 <4798E664.2040405@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_rom() obtained a fresh new fw_device.generation for each read
transaction.  Hence it was able to continue reading in the middle of the
ROM even if a bus reset happened.  However the device may have modified
the ROM during the reset.  We would end up with a corrupt fetched ROM
image then.

Although all of this is quite unlikely, it is not impossible.
Therefore we now restart reading the ROM if the bus generation changed.

Note, the memory barrier in read_rom() is still necessary according to
tests by Jarod Wilson, despite of the ->generation access being moved up
in the call chain.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

First posted on 2007-11-01.  Update:  Barrier stays.

 drivers/firewire/fw-device.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

Index: linux-2.6.24/drivers/firewire/fw-device.c
===================================================================
--- linux-2.6.24.orig/drivers/firewire/fw-device.c
+++ linux-2.6.24/drivers/firewire/fw-device.c
@@ -389,12 +389,12 @@ complete_transaction(struct fw_card *car
 	complete(&callback_data->done);
 }
 
-static int read_rom(struct fw_device *device, int index, u32 * data)
+static int
+read_rom(struct fw_device *device, int generation, int index, u32 *data)
 {
 	struct read_quadlet_callback_data callback_data;
 	struct fw_transaction t;
 	u64 offset;
-	int generation = device->generation;
 
 	/* device->node_id, accessed below, must not be older than generation */
 	smp_rmb();
@@ -413,7 +413,14 @@ static int read_rom(struct fw_device *de
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
@@ -423,7 +430,7 @@ static int read_bus_info_block(struct fw
 
 	/* First read the bus info block. */
 	for (i = 0; i < 5; i++) {
-		if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
 			return -1;
 		/*
 		 * As per IEEE1212 7.2, during power-up, devices can
@@ -458,7 +465,8 @@ static int read_bus_info_block(struct fw
 			device->max_speed = device->card->link_speed;
 
 		while (device->max_speed > SCODE_100) {
-			if (read_rom(device, 0, &dummy) == RCODE_COMPLETE)
+			if (read_rom(device, generation, 0, &dummy) ==
+			    RCODE_COMPLETE)
 				break;
 			device->max_speed--;
 		}
@@ -491,7 +499,7 @@ static int read_bus_info_block(struct fw
 			return -1;
 
 		/* Read header quadlet for the block to get the length. */
-		if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
 			return -1;
 		end = i + (rom[i] >> 16) + 1;
 		i++;
@@ -510,7 +518,8 @@ static int read_bus_info_block(struct fw
 		 * it references another block, and push it in that case.
 		 */
 		while (i < end) {
-			if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+			if (read_rom(device, generation, i, &rom[i]) !=
+			    RCODE_COMPLETE)
 				return -1;
 			if ((key >> 30) == 3 && (rom[i] >> 30) > 1 &&
 			    sp < ARRAY_SIZE(stack))
@@ -657,7 +666,7 @@ static void fw_device_init(struct work_s
 	 * device.
 	 */
 
-	if (read_bus_info_block(device) < 0) {
+	if (read_bus_info_block(device, device->generation) < 0) {
 		if (device->config_rom_retries < MAX_RETRIES) {
 			device->config_rom_retries++;
 			schedule_delayed_work(&device->work, RETRY_DELAY);

-- 
Stefan Richter
-=====-==--- ---= ==--=
http://arcgraph.de/sr/

