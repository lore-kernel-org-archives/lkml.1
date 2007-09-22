Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbXIVWV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbXIVWV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbXIVWVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:21:52 -0400
Received: from khc.piap.pl ([195.187.100.11]:59572 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbXIVWVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:21:51 -0400
To: adaplas@gmail.com, sylvain.meyer@worldonline.fr, akpm@linux-foundation.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] Intel FB: force even line count in interlaced mode
References: <m33ax65ot6.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <m33ax65ot6.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Sun, 23 Sep 2007 00:16:05 +0200")
Date: Sun, 23 Sep 2007 00:21:50 +0200
Message-ID: <m3sl5649z5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel FB: the chip adds two halflines automatically in interlaced mode,
force even line count for the right timings.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

--- a/drivers/video/intelfb/intelfbhw.c
+++ b/drivers/video/intelfb/intelfbhw.c
@@ -317,6 +317,14 @@ int intelfbhw_validate_mode(struct intelfb_info *dinfo,
 			var->yres, VACTIVE_MASK + 1);
 		return 1;
 	}
+	if (var->xres < 4) {
+		WRN_MSG("X resolution too small (%d vs 4).\n", var->xres);
+		return 1;
+	}
+	if (var->yres < 4) {
+		WRN_MSG("Y resolution too small (%d vs 4).\n", var->yres);
+		return 1;
+	}
 
 	/* Check for doublescan modes. */
 	if (var->vmode & FB_VMODE_DOUBLE) {
@@ -324,6 +332,11 @@ int intelfbhw_validate_mode(struct intelfb_info *dinfo,
 		return 1;
 	}
 
+	if ((var->vmode & FB_VMODE_INTERLACED) && (var->yres & 1)) {
+		WRN_MSG("Odd number of lines in interlaced mode\n");
+		return 1;
+	}
+
 	/* Check if clock is OK. */
 	tmp = 1000000000 / var->pixclock;
 	if (tmp < MIN_CLOCK) {
@@ -1127,6 +1140,8 @@ int intelfbhw_mode_to_hw(struct intelfb_info *dinfo,
 		hblank_end);
 
 	vactive = var->yres;
+	if (var->vmode & FB_VMODE_INTERLACED)
+		vactive--; /* the chip adds 2 halflines automatically */
 	vsync_start = vactive + var->lower_margin;
 	vsync_end = vsync_start + var->vsync_len;
 	vtotal = vsync_end + var->upper_margin;
