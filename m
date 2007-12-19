Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbXLSKQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbXLSKQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXLSKQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:16:43 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61290 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750966AbXLSKQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:16:42 -0500
Date: Wed, 19 Dec 2007 11:16:41 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] ps3fb: Update for firmware 2.10
In-Reply-To: <Pine.LNX.4.62.0712191105220.16918@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0712191115470.17591@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0712191105220.16918@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-495588799-1198059401=:17591"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-495588799-1198059401=:17591
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Update for firmware 2.10

As of PS3 firmware version 2.10, the GPU command buffer size must be at least 2
MiB large. Since we use only a small part of the GPU command buffer and don't
want to waste precious XDR memory, move the GPU command buffer back to the
start of the XDR memory reserved for ps3fb and let the unused part overlap with
the actual frame buffer.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/ps3fb.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -51,7 +51,8 @@
 #define L1GPU_DISPLAY_SYNC_HSYNC		1
 #define L1GPU_DISPLAY_SYNC_VSYNC		2
 
-#define GPU_CMD_BUF_SIZE			(64 * 1024)
+#define GPU_CMD_BUF_SIZE			(2 * 1024 * 1024)
+#define GPU_FB_START				(64 * 1024)
 #define GPU_IOIF				(0x0d000000UL)
 #define GPU_ALIGN_UP(x)				_ALIGN_UP((x), 64)
 #define GPU_MAX_LINE_LENGTH			(65536 - 64)
@@ -406,6 +407,7 @@ static void ps3fb_sync_image(struct devi
 	if (src_line_length != dst_line_length)
 		line_length |= (u64)src_line_length << 32;
 
+	src_offset += GPU_FB_START;
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT,
 					   dst_offset, GPU_IOIF + src_offset,
@@ -976,9 +978,8 @@ static int ps3fb_xdr_settings(u64 xdr_lp
 
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP,
-					   xdr_lpar + ps3fb.xdr_size,
-					   GPU_CMD_BUF_SIZE,
-					   GPU_IOIF + ps3fb.xdr_size, 0);
+					   xdr_lpar, GPU_CMD_BUF_SIZE,
+					   GPU_IOIF, 0);
 	if (status) {
 		dev_err(dev,
 			"%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
@@ -1061,6 +1062,11 @@ static int __devinit ps3fb_probe(struct 
 	struct task_struct *task;
 	unsigned long max_ps3fb_size;
 
+	if (ps3fb_videomemory.size < GPU_CMD_BUF_SIZE) {
+		dev_err(&dev->core, "%s: Not enough video memory\n", __func__);
+		return -ENOMEM;
+	}
+
 	status = ps3_open_hv_device(dev);
 	if (status) {
 		dev_err(&dev->core, "%s: ps3_open_hv_device failed\n",
@@ -1131,8 +1137,14 @@ static int __devinit ps3fb_probe(struct 
 	/* Clear memory to prevent kernel info leakage into userspace */
 	memset(ps3fb.xdr_ea, 0, ps3fb_videomemory.size);
 
-	/* The GPU command buffer is at the end of video memory */
-	ps3fb.xdr_size = ps3fb_videomemory.size - GPU_CMD_BUF_SIZE;
+	/*
+	 * The GPU command buffer is at the start of video memory
+	 * As we don't use the full command buffer, we can put the actual
+	 * frame buffer at offset GPU_FB_START and save some precious XDR
+	 * memory
+	 */
+	ps3fb.xdr_ea += GPU_FB_START;
+	ps3fb.xdr_size = ps3fb_videomemory.size - GPU_FB_START;
 
 	retval = ps3fb_xdr_settings(xdr_lpar, &dev->core);
 	if (retval)

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-495588799-1198059401=:17591--
