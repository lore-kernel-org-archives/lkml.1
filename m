Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab0BDRZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:25:44 -0500
Received: from kroah.org ([198.145.64.141]:34959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372Ab0BDRW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:29 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:26 2010
Message-Id: <20100204171525.997483817@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [67/74] mx3fb: some debug and initialisation fixes
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alberto Panizzo <maramaopercheseimorto@gmail.com>

commit b3cb53721890879d7bde31f5f9eefd4edf41ab64 upstream.

Fix the kernel oops when dev_dbg is called with mx3_fbi->txd == NULL

Fix the late initialisation of mx3fb->backlight_level.  If not, in the
chain of function started by init_fb_chan(), in __blank() call
sdc_set_brightness(mx3fb, mx3fb->backlight_level) that will shut down the
CONTRAST PWM output.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/mx3fb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -324,8 +324,11 @@ static void sdc_enable_channel(struct mx
 	unsigned long flags;
 	dma_cookie_t cookie;
 
-	dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mx3_fbi,
-		to_tx_desc(mx3_fbi->txd), to_tx_desc(mx3_fbi->txd)->sg);
+	if (mx3_fbi->txd)
+		dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mx3_fbi,
+			to_tx_desc(mx3_fbi->txd), to_tx_desc(mx3_fbi->txd)->sg);
+	else
+		dev_dbg(mx3fb->dev, "mx3fbi %p, txd = NULL\n", mx3_fbi);
 
 	/* This enables the channel */
 	if (mx3_fbi->cookie < 0) {
@@ -646,6 +649,7 @@ static int sdc_set_global_alpha(struct m
 
 static void sdc_set_brightness(struct mx3fb_data *mx3fb, uint8_t value)
 {
+	dev_dbg(mx3fb->dev, "%s: value = %d\n", __func__, value);
 	/* This might be board-specific */
 	mx3fb_write_reg(mx3fb, 0x03000000UL | value << 16, SDC_PWM_CTRL);
 	return;
@@ -1486,12 +1490,12 @@ static int mx3fb_probe(struct platform_d
 		goto ersdc0;
 	}
 
+	mx3fb->backlight_level = 255;
+
 	ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
 	if (ret < 0)
 		goto eisdc0;
 
-	mx3fb->backlight_level = 255;
-
 	return 0;
 
 eisdc0:


