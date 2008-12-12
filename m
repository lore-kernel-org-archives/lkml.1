Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYLLUuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYLLUuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYLLUt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:49:58 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:61834 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYLLUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:49:57 -0500
Message-ID: <4942CE40.5080905@inf.tu-dresden.de>
Date: Fri, 12 Dec 2008 21:49:04 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>, Richard Purdie <rpurdie@rpsys.net>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] video: mbp_nvidia_bl: Add a debug switch
References: <2e9ff482f36dc7e7694141df51ea977a52474089.1229087880.git.mario@snoopy.(none)>
In-Reply-To: <2e9ff482f36dc7e7694141df51ea977a52474089.1229087880.git.mario@snoopy.(none)>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a debug switch to enable (little) diagnostic
output, to help to trace down the remaining problems.

Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
---
 drivers/video/backlight/mbp_nvidia_bl.c |   37 +++++++++++++++++++++++++++++-
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 559daf0..f014399 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -33,6 +33,11 @@ struct dmi_match_data {
 	struct backlight_ops backlight_ops;
 };

+/* Module parameters. */
+static int debug;
+module_param_named(debug, debug, int, 0644);
+MODULE_PARM_DESC(debug, "Set to one to enable debugging messages.");
+
 /*
  * Implementation for MacBooks with Intel chipset.
  */
@@ -40,6 +45,10 @@ static int intel_chipset_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;

+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: setting brightness to %d\n",
+		       intensity);
+
 	outb(0x04 | (intensity << 4), 0xb3);
 	outb(0xbf, 0xb2);
 	return 0;
@@ -47,9 +56,17 @@ static int intel_chipset_send_intensity(struct backlight_device *bd)

 static int intel_chipset_get_intensity(struct backlight_device *bd)
 {
+	int intensity;
+
 	outb(0x03, 0xb3);
 	outb(0xbf, 0xb2);
-	return inb(0xb3) >> 4;
+	intensity = inb(0xb3) >> 4;
+
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: read brightness of %d\n",
+		       intensity);
+
+	return intensity;
 }

 static const struct dmi_match_data intel_chipset_data = {
@@ -72,6 +89,10 @@ static int nvidia_chipset_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;

+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: setting brightness to %d\n",
+		       intensity);
+
 	outb(0x04 | (intensity << 4), 0x52f);
 	outb(0xbf, 0x52e);
 	return 0;
@@ -79,9 +100,17 @@ static int nvidia_chipset_send_intensity(struct backlight_device *bd)

 static int nvidia_chipset_get_intensity(struct backlight_device *bd)
 {
+	int intensity;
+
 	outb(0x03, 0x52f);
 	outb(0xbf, 0x52e);
-	return inb(0x52f) >> 4;
+	intensity = inb(0x52f) >> 4;
+
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: read brightness of %d\n",
+		       intensity);
+
+	return intensity;
 }

 static const struct dmi_match_data nvidia_chipset_data = {
@@ -211,6 +240,10 @@ static int mbp_resume(struct platform_device *pdev)
 	 */
 	struct backlight_device *bd = platform_get_drvdata(pdev);

+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: resuming with"
+		       " brightness %d\n", bd->props.brightness);
+
 	backlight_update_status(bd);
 	return 0;
 }
-- 
1.5.6.3

