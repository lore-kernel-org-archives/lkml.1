Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0BSUAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:00:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48918 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab0BSUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:00:44 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 19 Feb 2010 21:00:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: rename an internal function
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6a1e3df293205a1b@s5r6.in-berlin.de>
Message-ID: <tkrat.02617c95036e2918@s5r6.in-berlin.de>
References: <tkrat.206fe651745e1dd7@s5r6.in-berlin.de>
 <tkrat.040d1f77b4f1ddb4@s5r6.in-berlin.de>
 <tkrat.41cd283579a10140@s5r6.in-berlin.de>
 <tkrat.6a1e3df293205a1b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

according to what it really does.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -492,29 +492,29 @@ static int read_rom(struct fw_device *de
 	return rcode;
 }
 
-#define READ_BIB_ROM_SIZE	256
+#define MAX_CONFIG_ROM_SIZE 256
 
 /*
  * Read the bus info block, perform a speed probe, and read all of the rest of
  * the config ROM.  We do all this with a cached bus generation.  If the bus
- * generation changes under us, read_bus_info_block will fail and get retried.
+ * generation changes under us, read_config_rom will fail and get retried.
  * It's better to start all over in this case because the node from which we
  * are reading the ROM may have changed the ROM during the reset.
  */
-static int read_bus_info_block(struct fw_device *device, int generation)
+static int read_config_rom(struct fw_device *device, int generation)
 {
 	const u32 *old_rom, *new_rom;
 	u32 *rom, *stack;
 	u32 sp, key;
 	int i, end, length, ret = -1;
 
-	rom = kmalloc(sizeof(*rom) * READ_BIB_ROM_SIZE +
-		      sizeof(*stack) * READ_BIB_ROM_SIZE, GFP_KERNEL);
+	rom = kmalloc(sizeof(*rom) * MAX_CONFIG_ROM_SIZE +
+		      sizeof(*stack) * MAX_CONFIG_ROM_SIZE, GFP_KERNEL);
 	if (rom == NULL)
 		return -ENOMEM;
 
-	stack = &rom[READ_BIB_ROM_SIZE];
-	memset(rom, 0, sizeof(*rom) * READ_BIB_ROM_SIZE);
+	stack = &rom[MAX_CONFIG_ROM_SIZE];
+	memset(rom, 0, sizeof(*rom) * MAX_CONFIG_ROM_SIZE);
 
 	device->max_speed = SCODE_100;
 
@@ -581,14 +581,14 @@ static int read_bus_info_block(struct fw
 		 */
 		key = stack[--sp];
 		i = key & 0xffffff;
-		if (WARN_ON(i >= READ_BIB_ROM_SIZE))
+		if (WARN_ON(i >= MAX_CONFIG_ROM_SIZE))
 			goto out;
 
 		/* Read header quadlet for the block to get the length. */
 		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
 			goto out;
 		end = i + (rom[i] >> 16) + 1;
-		if (end > READ_BIB_ROM_SIZE) {
+		if (end > MAX_CONFIG_ROM_SIZE) {
 			/*
 			 * This block extends outside the config ROM which is
 			 * a firmware bug.  Ignore this whole block, i.e.
@@ -621,7 +621,7 @@ static int read_bus_info_block(struct fw
 			 * fake immediate entry so that later iterators over
 			 * the ROM don't have to check offsets all the time.
 			 */
-			if (i + (rom[i] & 0xffffff) >= READ_BIB_ROM_SIZE) {
+			if (i + (rom[i] & 0xffffff) >= MAX_CONFIG_ROM_SIZE) {
 				fw_error("skipped unsupported ROM entry %x at %llx\n",
 					 rom[i],
 					 i * 4 | CSR_REGISTER_BASE | CSR_CONFIG_ROM);
@@ -971,7 +971,7 @@ static void fw_device_init(struct work_s
 	 * device.
 	 */
 
-	if (read_bus_info_block(device, device->generation) < 0) {
+	if (read_config_rom(device, device->generation) < 0) {
 		if (device->config_rom_retries < MAX_RETRIES &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
@@ -1088,7 +1088,7 @@ enum {
 };
 
 /* Reread and compare bus info block and header of root directory */
-static int reread_bus_info_block(struct fw_device *device, int generation)
+static int reread_config_rom(struct fw_device *device, int generation)
 {
 	u32 q;
 	int i;
@@ -1114,7 +1114,7 @@ static void fw_device_refresh(struct wor
 	struct fw_card *card = device->card;
 	int node_id = device->node_id;
 
-	switch (reread_bus_info_block(device, device->generation)) {
+	switch (reread_config_rom(device, device->generation)) {
 	case REREAD_BIB_ERROR:
 		if (device->config_rom_retries < MAX_RETRIES / 2 &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
@@ -1148,7 +1148,7 @@ static void fw_device_refresh(struct wor
 	 */
 	device_for_each_child(&device->device, NULL, shutdown_unit);
 
-	if (read_bus_info_block(device, device->generation) < 0) {
+	if (read_config_rom(device, device->generation) < 0) {
 		if (device->config_rom_retries < MAX_RETRIES &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;

-- 
Stefan Richter
-=====-==-=- --=- =--==
http://arcgraph.de/sr/

