Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYFWLDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYFWLDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYFWLDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:03:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYFWLDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:03:38 -0400
Subject: [PATCH] cpia2: use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: steve.miller@st.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: jaswinder@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 23 Jun 2008 12:03:33 +0100
Message-Id: <1214219013.27974.17.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for Jaswinder Singh for converting the firmware blob itself to ihex.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/media/video/cpia2/Kconfig      |    8 +
 drivers/media/video/cpia2/cpia2_core.c |   46 +++++--
 drivers/media/video/cpia2/cpia2patch.h |  233 --------------------------------
 firmware/Makefile                      |    1 +
 firmware/WHENCE                        |   13 ++
 firmware/cpia2/stv0672_vp4.bin.ihex    |   73 ++++++++++
 6 files changed, 132 insertions(+), 242 deletions(-)
 delete mode 100644 drivers/media/video/cpia2/cpia2patch.h
 create mode 100644 firmware/cpia2/stv0672_vp4.bin.ihex

diff --git a/drivers/media/video/cpia2/Kconfig b/drivers/media/video/cpia2/Kconfig
index e39a961..64d9866 100644
--- a/drivers/media/video/cpia2/Kconfig
+++ b/drivers/media/video/cpia2/Kconfig
@@ -1,9 +1,17 @@
 config VIDEO_CPIA2
 	tristate "CPiA2 Video For Linux"
 	depends on VIDEO_DEV && USB && VIDEO_V4L1
+	select FW_LOADER
 	---help---
 	  This is the video4linux driver for cameras based on Vision's CPiA2
 	  (Colour Processor Interface ASIC), such as the Digital Blue QX5
 	  Microscope. If you have one of these cameras, say Y here
 
 	  This driver is also available as a module (cpia2).
+
+config VIDEO_CPIA2_FIRMWARE
+	bool "Compile CPiA2 VP4 firmware into the kernel"
+	depends on VIDEO_CPIA2
+	---help---
+	  This includes firmware for CPiA2 VP4 in the kernel image.
+	  Say 'N' and let it get loaded from userspace on demand.
diff --git a/drivers/media/video/cpia2/cpia2_core.c b/drivers/media/video/cpia2/cpia2_core.c
index c8b9fdb..71969d5 100644
--- a/drivers/media/video/cpia2/cpia2_core.c
+++ b/drivers/media/video/cpia2/cpia2_core.c
@@ -33,11 +33,10 @@
 
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/firmware.h>
 
 /* #define _CPIA2_DEBUG_ */
 
-#include "cpia2patch.h"
-
 #ifdef _CPIA2_DEBUG_
 
 static const char *block_name[] = {
@@ -893,24 +892,53 @@ int cpia2_set_low_power(struct camera_data *cam)
  *  apply_vp_patch
  *
  *****************************************************************************/
+static int cpia2_send_onebyte_command(struct camera_data *cam,
+				      struct cpia2_command *cmd,
+				      u8 start, u8 datum)
+{
+	cmd->buffer.block_data[0] = datum;
+	cmd->start = start;
+	cmd->reg_count = 1;
+	return cpia2_send_command(cam, cmd);
+}
+
 static int apply_vp_patch(struct camera_data *cam)
 {
-	int i, j;
+	const struct firmware *fw;
+	const char fw_name[] = "cpia2/stv0672_vp4.bin";
+	int i, ret;
 	struct cpia2_command cmd;
 
+	ret = request_firmware(&fw, fw_name, &cam->dev->dev);
+	if (ret) {
+		printk(KERN_ERR "cpia2: failed to load VP patch \"%s\"\n",
+		       fw_name);
+		return ret;
+	}
+
 	cmd.req_mode = CAMERAACCESS_TYPE_REPEAT | CAMERAACCESS_VP;
 	cmd.direction = TRANSFER_WRITE;
 
-	for (i = 0; i < PATCH_DATA_SIZE; i++) {
-		for (j = 0; j < patch_data[i].count; j++) {
-			cmd.buffer.block_data[j] = patch_data[i].data[j];
-		}
+	/* First send the start address... */
+	cpia2_send_onebyte_command(cam, &cmd, 0x0A, fw->data[0]); /* hi */
+	cpia2_send_onebyte_command(cam, &cmd, 0x0B, fw->data[1]); /* lo */
 
-		cmd.start = patch_data[i].reg;
-		cmd.reg_count = patch_data[i].count;
+	/* ... followed by the data payload */
+	for (i = 2; i < fw->size; i += 64) {
+		cmd.start = 0x0C; /* Data */
+		cmd.reg_count = min_t(int, 64, fw->size - i);
+		memcpy(cmd.buffer.block_data, &fw->data[i], cmd.reg_count);
 		cpia2_send_command(cam, &cmd);
 	}
 
+	/* Next send the start address... */
+	cpia2_send_onebyte_command(cam, &cmd, 0x0A, fw->data[0]); /* hi */
+	cpia2_send_onebyte_command(cam, &cmd, 0x0B, fw->data[1]); /* lo */
+
+	/* ... followed by the 'goto' command */
+	cpia2_send_onebyte_command(cam, &cmd, 0x0D, 1);
+	
+	release_firmware(fw);
 	return 0;
 }
 
diff --git a/drivers/media/video/cpia2/cpia2patch.h b/drivers/media/video/cpia2/cpia2patch.h
deleted file mode 100644
index 7f085fb..0000000
--- a/drivers/media/video/cpia2/cpia2patch.h
+++ /dev/null
@@ -1,233 +0,0 @@
-/****************************************************************************
- *
- *  Filename: cpia2patch.h
- *
- *  Copyright 2001, STMicrolectronics, Inc.
- *
- *  Contact:  steve.miller@st.com
- *
- *  Description:
- *     This file contains patch data for the CPiA2 (stv0672) VP4.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- ****************************************************************************/
-
-#ifndef CPIA2_PATCH_HEADER
-#define CPIA2_PATCH_HEADER
-
-typedef struct {
-	unsigned char reg;
-	unsigned char count;
-	const unsigned char *data;
-} cpia2_patch;
-
-static const unsigned char start_address_hi[1] = {
-	0x01
-};
-
-static const unsigned char start_address_lo[1] = {
-	0xBC
-};
-
-static const unsigned char patch_block0[64] = {
-	0xE3, 0x02, 0xE3, 0x03, 0xE3, 0x04, 0xE3, 0x05,
-	0xE3, 0x06, 0xE3, 0x07, 0x93, 0x44, 0x56, 0xD4,
-	0x93, 0x4E, 0x56, 0x51, 0x93, 0x4E, 0x51, 0xD6,
-	0x93, 0x4E, 0x4F, 0x54, 0x93, 0x4E, 0x92, 0x4F,
-	0x92, 0xA4, 0x93, 0x05, 0x92, 0xF4, 0x93, 0x1B,
-	0x92, 0x92, 0x91, 0xE6, 0x92, 0x36, 0x92, 0x74,
-	0x92, 0x4A, 0x92, 0x8C, 0x92, 0x8E, 0xC8, 0xD0,
-	0x0B, 0x42, 0x02, 0xA0, 0xCA, 0x92, 0x09, 0x02
-};
-
-static const unsigned char patch_block1[64] = {
-	0xC9, 0x10, 0x0A, 0x0A, 0x0A, 0x81, 0xE3, 0xB8,
-	0xE3, 0xB0, 0xE3, 0xA8, 0xE3, 0xA0, 0xE3, 0x98,
-	0xE3, 0x90, 0xE1, 0x00, 0xCF, 0xD7, 0x0A, 0x12,
-	0xCC, 0x95, 0x08, 0xB2, 0x0A, 0x18, 0xE1, 0x00,
-	0x01, 0xEE, 0x0C, 0x08, 0x4A, 0x12, 0xC8, 0x18,
-	0xF0, 0x9A, 0xC0, 0x22, 0xF3, 0x1C, 0x4A, 0x13,
-	0xF3, 0x14, 0xC8, 0xA0, 0xF2, 0x14, 0xF2, 0x1C,
-	0xEB, 0x13, 0xD3, 0xA2, 0x63, 0x16, 0x48, 0x9E
-};
-
-static const unsigned char patch_block2[64] = {
-	0xF0, 0x18, 0xA4, 0x03, 0xF3, 0x93, 0xC0, 0x58,
-	0xF7, 0x13, 0x51, 0x9C, 0xE9, 0x20, 0xCF, 0xEF,
-	0x63, 0xF9, 0x92, 0x2E, 0xD3, 0x5F, 0x63, 0xFA,
-	0x92, 0x2E, 0xD3, 0x67, 0x63, 0xFB, 0x92, 0x2E,
-	0xD3, 0x6F, 0xE9, 0x1A, 0x63, 0x16, 0x48, 0xA7,
-	0xF0, 0x20, 0xA4, 0x06, 0xF3, 0x94, 0xC0, 0x27,
-	0xF7, 0x14, 0xF5, 0x13, 0x51, 0x9D, 0xF6, 0x13,
-	0x63, 0x18, 0xC4, 0x20, 0xCB, 0xEF, 0x63, 0xFC
-};
-
-static const unsigned char patch_block3[64] = {
-	0x92, 0x2E, 0xD3, 0x77, 0x63, 0xFD, 0x92, 0x2E,
-	0xD3, 0x7F, 0x63, 0xFE, 0x92, 0x2E, 0xD3, 0x87,
-	0x63, 0xFF, 0x92, 0x2E, 0xD3, 0x8F, 0x64, 0x38,
-	0x92, 0x2E, 0xD3, 0x97, 0x64, 0x39, 0x92, 0x2E,
-	0xD3, 0x9F, 0xE1, 0x00, 0xF5, 0x3A, 0xF4, 0x3B,
-	0xF7, 0xBF, 0xF2, 0xBC, 0xF2, 0x3D, 0xE1, 0x00,
-	0x80, 0x87, 0x90, 0x80, 0x51, 0xD5, 0x02, 0x22,
-	0x02, 0x32, 0x4B, 0xD3, 0xF7, 0x11, 0x0B, 0xDA
-};
-
-static const unsigned char patch_block4[64] = {
-	0xE1, 0x00, 0x0E, 0x02, 0x02, 0x40, 0x0D, 0xB5,
-	0xE3, 0x02, 0x48, 0x55, 0xE5, 0x12, 0xA4, 0x01,
-	0xE8, 0x1B, 0xE3, 0x90, 0xF0, 0x18, 0xA4, 0x01,
-	0xE8, 0xBF, 0x8D, 0xB8, 0x4B, 0xD1, 0x4B, 0xD8,
-	0x0B, 0xCB, 0x0B, 0xC2, 0xE1, 0x00, 0xE3, 0x02,
-	0xE3, 0x03, 0x52, 0xD3, 0x60, 0x59, 0xE6, 0x93,
-	0x0D, 0x22, 0x52, 0xD4, 0xE6, 0x93, 0x0D, 0x2A,
-	0xE3, 0x98, 0xE3, 0x90, 0xE1, 0x00, 0x02, 0x5D
-};
-
-static const unsigned char patch_block5[64] = {
-	0x02, 0x63, 0xE3, 0x02, 0xC8, 0x12, 0x02, 0xCA,
-	0xC8, 0x52, 0x02, 0xC2, 0x82, 0x68, 0xE3, 0x02,
-	0xC8, 0x14, 0x02, 0xCA, 0xC8, 0x90, 0x02, 0xC2,
-	0x0A, 0xD0, 0xC9, 0x93, 0x0A, 0xDA, 0xCC, 0xD2,
-	0x0A, 0xE2, 0x63, 0x12, 0x02, 0xDA, 0x0A, 0x98,
-	0x0A, 0xA0, 0x0A, 0xA8, 0xE3, 0x90, 0xE1, 0x00,
-	0xE3, 0x02, 0x0A, 0xD0, 0xC9, 0x93, 0x0A, 0xDA,
-	0xCC, 0xD2, 0x0A, 0xE2, 0x63, 0x12, 0x02, 0xDA
-};
-
-static const unsigned char patch_block6[64] = {
-	0x0A, 0x98, 0x0A, 0xA0, 0x0A, 0xA8, 0x49, 0x91,
-	0xE5, 0x6A, 0xA4, 0x04, 0xC8, 0x12, 0x02, 0xCA,
-	0xC8, 0x52, 0x82, 0x89, 0xC8, 0x14, 0x02, 0xCA,
-	0xC8, 0x90, 0x02, 0xC2, 0xE3, 0x90, 0xE1, 0x00,
-	0x08, 0x60, 0xE1, 0x00, 0x48, 0x53, 0xE8, 0x97,
-	0x08, 0x5A, 0xE1, 0x00, 0xE3, 0x02, 0xE3, 0x03,
-	0x54, 0xD3, 0x60, 0x59, 0xE6, 0x93, 0x0D, 0x52,
-	0xE3, 0x98, 0xE3, 0x90, 0xE1, 0x00, 0x02, 0x9C
-};
-
-static const unsigned char patch_block7[64] = {
-	0xE3, 0x02, 0x55, 0x13, 0x93, 0x17, 0x55, 0x13,
-	0x93, 0x17, 0xE3, 0x90, 0xE1, 0x00, 0x75, 0x30,
-	0xE3, 0x02, 0xE3, 0x03, 0x55, 0x55, 0x60, 0x59,
-	0xE6, 0x93, 0x0D, 0xB2, 0xE3, 0x98, 0xE3, 0x90,
-	0xE1, 0x00, 0x02, 0xAE, 0xE7, 0x92, 0xE9, 0x18,
-	0xEA, 0x9A, 0xE8, 0x98, 0xE8, 0x10, 0xE8, 0x11,
-	0xE8, 0x51, 0xD2, 0xDA, 0xD2, 0xF3, 0xE8, 0x13,
-	0xD2, 0xFA, 0xE8, 0x50, 0xD2, 0xEA, 0xE8, 0xD0
-};
-
-static const unsigned char patch_block8[64] = {
-	0xE8, 0xD1, 0xD3, 0x0A, 0x03, 0x09, 0x48, 0x23,
-	0xE5, 0x2C, 0xA0, 0x03, 0x48, 0x24, 0xEA, 0x1C,
-	0x03, 0x08, 0xD2, 0xE3, 0xD3, 0x03, 0xD3, 0x13,
-	0xE1, 0x00, 0x02, 0xCB, 0x05, 0x93, 0x57, 0x93,
-	0xF0, 0x9A, 0xAC, 0x0B, 0xE3, 0x07, 0x92, 0xEA,
-	0xE2, 0x9F, 0xE5, 0x06, 0xE3, 0xB0, 0xA0, 0x02,
-	0xEB, 0x1E, 0x82, 0xD7, 0xEA, 0x1E, 0xE2, 0x3B,
-	0x85, 0x9B, 0xE9, 0x1E, 0xC8, 0x90, 0x85, 0x94
-};
-
-static const unsigned char patch_block9[64] = {
-	0x02, 0xDE, 0x05, 0x80, 0x57, 0x93, 0xF0, 0xBA,
-	0xAC, 0x06, 0x92, 0xEA, 0xE2, 0xBF, 0xE5, 0x06,
-	0xA0, 0x01, 0xEB, 0xBF, 0x85, 0x88, 0xE9, 0x3E,
-	0xC8, 0x90, 0x85, 0x81, 0xE9, 0x3E, 0xF0, 0xBA,
-	0xF3, 0x39, 0xF0, 0x3A, 0x60, 0x17, 0xF0, 0x3A,
-	0xC0, 0x90, 0xF0, 0xBA, 0xE1, 0x00, 0x00, 0x3F,
-	0xE3, 0x02, 0xE3, 0x03, 0x58, 0x10, 0x60, 0x59,
-	0xE6, 0x93, 0x0D, 0xA2, 0x58, 0x12, 0xE6, 0x93
-};
-
-static const unsigned char patch_block10[64] = {
-	0x0D, 0xAA, 0xE3, 0x98, 0xE3, 0x90, 0xE1, 0x00,
-	0x03, 0x01, 0xE1, 0x00, 0x03, 0x03, 0x9B, 0x7D,
-	0x8B, 0x8B, 0xE3, 0x02, 0xE3, 0x03, 0x58, 0x56,
-	0x60, 0x59, 0xE6, 0x93, 0x0D, 0xBA, 0xE3, 0x98,
-	0xE3, 0x90, 0xE1, 0x00, 0x03, 0x0F, 0x93, 0x11,
-	0xE1, 0x00, 0xE3, 0x02, 0x4A, 0x11, 0x0B, 0x42,
-	0x91, 0xAF, 0xE3, 0x90, 0xE1, 0x00, 0xF2, 0x91,
-	0xF0, 0x91, 0xA3, 0xFE, 0xE1, 0x00, 0x60, 0x92
-};
-
-static const unsigned char patch_block11[64] = {
-	0xC0, 0x5F, 0xF0, 0x13, 0xF0, 0x13, 0x59, 0x5B,
-	0xE2, 0x13, 0xF0, 0x11, 0x5A, 0x19, 0xE2, 0x13,
-	0xE1, 0x00, 0x00, 0x00, 0x03, 0x27, 0x68, 0x61,
-	0x76, 0x61, 0x6E, 0x61, 0x00, 0x06, 0x03, 0x2C,
-	0xE3, 0x02, 0xE3, 0x03, 0xE9, 0x38, 0x59, 0x15,
-	0x59, 0x5A, 0xF2, 0x9A, 0xBC, 0x0B, 0xA4, 0x0A,
-	0x59, 0x1E, 0xF3, 0x11, 0xF0, 0x1A, 0xE2, 0xBB,
-	0x59, 0x15, 0xF0, 0x11, 0x19, 0x2A, 0xE5, 0x02
-};
-
-static const unsigned char patch_block12[54] = {
-	0xA4, 0x01, 0xEB, 0xBF, 0xE3, 0x98, 0xE3, 0x90,
-	0xE1, 0x00, 0x03, 0x42, 0x19, 0x28, 0xE1, 0x00,
-	0xE9, 0x30, 0x60, 0x79, 0xE1, 0x00, 0xE3, 0x03,
-	0xE3, 0x07, 0x60, 0x79, 0x93, 0x4E, 0xE3, 0xB8,
-	0xE3, 0x98, 0xE1, 0x00, 0xE9, 0x1A, 0xF0, 0x1F,
-	0xE2, 0x33, 0xF0, 0x91, 0xE2, 0x92, 0xE0, 0x32,
-	0xF0, 0x31, 0xE1, 0x00, 0x00, 0x00
-};
-
-static const unsigned char do_call[1] = {
-	0x01
-};
-
-
-#define PATCH_DATA_SIZE 18
-
-static const cpia2_patch patch_data[PATCH_DATA_SIZE] = {
-	{0x0A, sizeof(start_address_hi), start_address_hi}
-	,			// 0
-	{0x0B, sizeof(start_address_lo), start_address_lo}
-	,			// 1
-	{0x0C, sizeof(patch_block0), patch_block0}
-	,			// 2
-	{0x0C, sizeof(patch_block1), patch_block1}
-	,			// 3
-	{0x0C, sizeof(patch_block2), patch_block2}
-	,			// 4
-	{0x0C, sizeof(patch_block3), patch_block3}
-	,			// 5
-	{0x0C, sizeof(patch_block4), patch_block4}
-	,			// 6
-	{0x0C, sizeof(patch_block5), patch_block5}
-	,			// 7
-	{0x0C, sizeof(patch_block6), patch_block6}
-	,			// 8
-	{0x0C, sizeof(patch_block7), patch_block7}
-	,			// 9
-	{0x0C, sizeof(patch_block8), patch_block8}
-	,			// 10
-	{0x0C, sizeof(patch_block9), patch_block9}
-	,			//11
-	{0x0C, sizeof(patch_block10), patch_block10}
-	,			// 12
-	{0x0C, sizeof(patch_block11), patch_block11}
-	,			// 13
-	{0x0C, sizeof(patch_block12), patch_block12}
-	,			// 14
-	{0x0A, sizeof(start_address_hi), start_address_hi}
-	,			// 15
-	{0x0B, sizeof(start_address_lo), start_address_lo}
-	,			// 16
-	{0x0D, sizeof(do_call), do_call}	//17
-};
-
-
-#endif
diff --git a/firmware/Makefile b/firmware/Makefile
index d0decbd..ec46a55 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -49,6 +49,7 @@ fw-shipped-$(CONFIG_USB_SERIAL_WHITEHEAT_FIRMWARE) += whiteheat_loader.fw \
 		whiteheat.fw # whiteheat_loader_debug.fw
 fw-shipped-$(CONFIG_ATM_AMBASSADOR_FIRMWARE) += atmsar11.fw
 fw-shipped-$(CONFIG_COMPUTONE_FIRMWARE) += intelliport2.bin
+fw-shipped-$(CONFIG_VIDEO_CPIA2_FIRMWARE) += cpia2/stv0672_vp4.bin
 
 firmware-y    := $(fw-external-y) $(fw-shipped-y)
 firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(firmware-y))))
diff --git a/firmware/WHENCE b/firmware/WHENCE
index 49ac8ba..235b47e 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -289,3 +289,16 @@ Licence: GPLv2 or later
 ARM assembly source code available at http://www.linuxtv.org/downloads/firmware/Boot.S
 
 --------------------------------------------------------------------------
+
+Driver: CPiA2 -- cameras based on Vision's CPiA2
+
+File: cpia2/stv0672_vp4.bin
+
+Licence: Allegedly GPLv2+, but no source visible. Marked:
+	Copyright (C) 2001 STMicroelectronics, Inc.
+	Contact:  steve.miller@st.com
+	Description: This file contains patch data for the CPiA2 (stv0672) VP4.
+
+Found in hex form in kernel source.
+
+--------------------------------------------------------------------------
diff --git a/firmware/cpia2/stv0672_vp4.bin.ihex b/firmware/cpia2/stv0672_vp4.bin.ihex
new file mode 100644
index 0000000..bd0b9cf
--- /dev/null
+++ b/firmware/cpia2/stv0672_vp4.bin.ihex
@@ -0,0 +1,73 @@
+:1000000001BCE302E303E304E305E306E3079344EF
+:1000100056D4934E5651934E51D6934E4F54934EC1
+:10002000924F92A4930592F4931B929291E692368A
+:100030009274924A928C928EC8D00B4202A0CA92BD
+:100040000902C9100A0A0A81E3B8E3B0E3A8E3A0F1
+:10005000E398E390E100CFD70A12CC9508B20A18D2
+:10006000E10001EE0C084A12C818F09AC022F31CF5
+:100070004A13F314C8A0F214F21CEB13D3A26316B4
+:10008000489EF018A403F393C058F713519CE9203D
+:10009000CFEF63F9922ED35F63FA922ED36763FB9F
+:1000A000922ED36FE91A631648A7F020A406F394A2
+:1000B000C027F714F513519DF6136318C420CBEF36
+:1000C00063FC922ED37763FD922ED37F63FE922E34
+:1000D000D38763FF922ED38F6438922ED3976439DF
+:1000E000922ED39FE100F53AF43BF7BFF2BCF23D0C
+:1000F000E1008087908051D5022202324BD3F71164
+:100100000BDAE1000E0202400DB5E3024855E5129C
+:10011000A401E81BE390F018A401E8BF8DB84BD10F
+:100120004BD80BCB0BC2E100E302E30352D360597F
+:10013000E6930D2252D4E6930D2AE398E390E10072
+:10014000025D0263E302C81202CAC85202C2826898
+:10015000E302C81402CAC89002C20AD0C9930ADADC
+:10016000CCD20AE2631202DA0A980AA00AA8E39043
+:10017000E100E3020AD0C9930ADACCD20AE26312A0
+:1001800002DA0A980AA00AA84991E56AA404C812EA
+:1001900002CAC8528289C81402CAC89002C2E39037
+:1001A000E1000860E1004853E897085AE100E302E3
+:1001B000E30354D36059E6930D52E398E390E100D2
+:1001C000029CE3025513931755139317E390E10034
+:1001D0007530E302E30355556059E6930DB2E39899
+:1001E000E390E10002AEE792E918EA9AE898E81095
+:1001F000E811E851D2DAD2F3E813D2FAE850D2EAA1
+:10020000E8D0E8D1D30A03094823E52CA003482409
+:10021000EA1C0308D2E3D303D313E10002CB059316
+:100220005793F09AAC0BE30792EAE29FE506E3B03E
+:10023000A002EB1E82D7EA1EE23B859BE91EC89016
+:10024000859402DE05805793F0BAAC0692EAE2BFCD
+:10025000E506A001EBBF8588E93EC8908581E93EAF
+:10026000F0BAF339F03A6017F03AC090F0BAE10012
+:10027000003FE302E30358106059E6930DA25812C1
+:10028000E6930DAAE398E390E1000301E100030384
+:100290009B7D8B8BE302E30358566059E6930DBABE
+:1002A000E398E390E100030F9311E100E3024A11A8
+:1002B0000B4291AFE390E100F291F091A3FEE100D7
+:1002C0006092C05FF013F013595BE213F0115A19FA
+:1002D000E213E10000000327686176616E610006A9
+:1002E000032CE302E303E9385915595AF29ABC0B7F
+:1002F000A40A591EF311F01AE2BB5915F011192A7C
+:10030000E502A401EBBFE398E390E1000342192862
+:10031000E100E9306079E100E303E3076079934E9F
+:10032000E3B8E398E100E91AF01FE233F091E292BA
+:08033000E032F031E1000000B1
+:00000001FF
+
+  Copyright 2001, STMicrolectronics, Inc.
+  Contact:  steve.miller@st.com
+
+  Description:
+     This file contains patch data for the CPiA2 (stv0672) VP4.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-- 
1.5.5.1


-- 
dwmw2

