Return-Path: <linux-kernel-owner+w=401wt.eu-S1761755AbZC3WDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbZC3WDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZC3WC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:02:56 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:61311 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbZC3WCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=qV8EYS5Jyb/JN7hxCzTjCGbHT0CQSBeePZaTusB9TdYXLutK0ilbXQbxsV1Uw6aSro
         botSnZNNnU3UHaByTmeAyHQIphAlCJ02maRaYx5wdexDPjp+dp9yJjo1EVgKYLaDodg2
         RmYlwUv9xTnUmCLR4ZX4oRqiDInlJNOBpQfd0=
Date: Tue, 31 Mar 2009 00:02:46 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Ville =?utf-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>,
       Geert Uytterhoeven <geert.uytterhoeven@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] uvesafb: fix color component length for pseudocolor modes
Message-ID: <20090330220246.GA6894@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uvesafb incorrectly sets the length of the color fields to 6 bits
for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
Fix this by setting the length to 8.

The switch of the DAC width from the default 6 bits to 8 bits is
retained and tracked internally in the driver, but never exposed
to userspace.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Ville Syrjälä <syrjala@sci.fi>
Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 74ae758..5b59198 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -55,6 +55,7 @@ static u16 maxvf	__devinitdata; /* maximum vertical frequency */
 static u16 maxhf	__devinitdata; /* maximum horizontal frequency */
 static u16 vbemode	__devinitdata; /* force use of a specific VBE mode */
 static char *mode_option __devinitdata;
+static u8  dac_width	= 6;
 
 static struct uvesafb_ktask *uvfb_tasks[UVESAFB_TASKS_MAX];
 static DEFINE_MUTEX(uvfb_lock);
@@ -303,22 +304,10 @@ static void uvesafb_setup_var(struct fb_var_screeninfo *var,
 		var->blue.offset   = 0;
 		var->transp.offset = 0;
 
-		/*
-		 * We're assuming that we can switch the DAC to 8 bits. If
-		 * this proves to be incorrect, we'll update the fields
-		 * later in set_par().
-		 */
-		if (par->vbe_ib.capabilities & VBE_CAP_CAN_SWITCH_DAC) {
-			var->red.length    = 8;
-			var->green.length  = 8;
-			var->blue.length   = 8;
-			var->transp.length = 0;
-		} else {
-			var->red.length    = 6;
-			var->green.length  = 6;
-			var->blue.length   = 6;
-			var->transp.length = 0;
-		}
+		var->red.length    = 8;
+		var->green.length  = 8;
+		var->blue.length   = 8;
+		var->transp.length = 0;
 	}
 }
 
@@ -1001,7 +990,7 @@ static int uvesafb_setcolreg(unsigned regno, unsigned red, unsigned green,
 		struct fb_info *info)
 {
 	struct uvesafb_pal_entry entry;
-	int shift = 16 - info->var.green.length;
+	int shift = 16 - dac_width;
 	int err = 0;
 
 	if (regno >= info->cmap.len)
@@ -1050,7 +1039,7 @@ static int uvesafb_setcolreg(unsigned regno, unsigned red, unsigned green,
 static int uvesafb_setcmap(struct fb_cmap *cmap, struct fb_info *info)
 {
 	struct uvesafb_pal_entry *entries;
-	int shift = 16 - info->var.green.length;
+	int shift = 16 - dac_width;
 	int i, err = 0;
 
 	if (info->var.bits_per_pixel == 8) {
@@ -1312,13 +1301,9 @@ setmode:
 		err = uvesafb_exec(task);
 		if (err || (task->t.regs.eax & 0xffff) != 0x004f ||
 		    ((task->t.regs.ebx & 0xff00) >> 8) != 8) {
-			/*
-			 * We've failed to set the DAC palette format -
-			 * time to correct var.
-			 */
-			info->var.red.length    = 6;
-			info->var.green.length  = 6;
-			info->var.blue.length   = 6;
+			dac_width = 6;
+		} else {
+			dac_width = 8;
 		}
 	}
 

