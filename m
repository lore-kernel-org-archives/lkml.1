Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbXFLL2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbXFLL2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXFLL2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:28:15 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:55981 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753888AbXFLL2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:28:14 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Andrew Victor <andrew@sanpeople.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] atmel_lcdfb: Fix wrong line_length calculation
Date: Tue, 12 Jun 2007 13:27:57 +0200
Message-Id: <1181647677482-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1179511541.3811.16.camel@bender>
References: <1179511541.3811.16.camel@bender>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As Jan Altenberg pointed out, line_length will always be 0 if
bits_per_pixel < 8. Fix this and also make sure that we round up to
the nearest byte.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
I haven't tested this with any real program that uses the frame buffer,
but fbset seems to report sane values for line_length:

-sh-3.2# fbset -i

mode "320x240-68"
    # D: 6.891 MHz, H: 17.852 kHz, V: 68.400 Hz
    geometry 320 240 320 240 4
    timings 145116 17 33 10 10 16 1
    rgba 4/0,4/0,4/0,0/0
endmode

Frame buffer device information:
    Name        :
    Address     : 0x102c0000
    Size        : 230400
    Type        : PACKED PIXELS
    Visual      : PSEUDOCOLOR
    XPanStep    : 0
    YPanStep    : 0
    YWrapStep   : 0
    LineLength  : 160
    MMIO Address: 0xff000000
    MMIO Size   : 4096
    Accelerator : No

The XPanStep and YPanStep values are wrong though. Nicolas, I suspect
YPanStep should be 1 on AT91 as well since the only thing required is
the ability to change the DMA base address. The DMA2D stuff is only
required for X panning if I understand it correctly.

 drivers/video/atmel_lcdfb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index e1d5bd0..695d520 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -230,6 +230,7 @@ static int atmel_lcdfb_set_par(struct fb_info *info)
 	struct atmel_lcdfb_info *sinfo = info->par;
 	unsigned long value;
 	unsigned long clk_value_khz;
+	unsigned long bits_per_line;
 
 	dev_dbg(info->device, "%s:\n", __func__);
 	dev_dbg(info->device, "  * resolution: %ux%u (%ux%u virtual)\n",
@@ -246,7 +247,8 @@ static int atmel_lcdfb_set_par(struct fb_info *info)
 	else
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
 
-	info->fix.line_length = info->var.xres_virtual * (info->var.bits_per_pixel / 8);
+	bits_per_line = info->var.xres_virtual * info->var.bits_per_pixel;
+	info->fix.line_length = DIV_ROUND_UP(bits_per_line, 8);
 
 	/* Re-initialize the DMA engine... */
 	dev_dbg(info->device, "  * update DMA engine\n");
-- 
1.4.4.4

