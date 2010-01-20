Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358Ab0ATO5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0ATO5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835Ab0ATO5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:57:20 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:58235 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0ATO5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:57:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gPdNzXH4c/TLCl3NjMewDk5ClXaBSAWTilQ35cYv0qCPJ6KLtbeEU+12YbqkvggJoa
         aajnDNZ/mvqTUjiKo0cXw3SlDWclSYVxLHA0xQKjbSE2XVMA3tvUJkKykWiHu8+AJxMV
         W67sYGHQbd+Ws7jQbDAclAHp0UYzMGwGO6oIA=
Subject: [PATCH] mx3fb: some debug and initialisation fixes.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sascha linux-arm <s.hauer@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Dan Williams <dan.j.williams@intel.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 15:57:14 +0100
Message-ID: <1263999434.3083.44.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
I've already sent this patch to the linux-arm-kernel mailing list
but I've not cc'ed you.

http://thread.gmane.org/gmane.linux.ports.arm.kernel/71120

This patch apply to linus .33-rc4 tree, tell me if I have to rebase
it over other repository.

Thanks

patch below..
---------------------------------------------------------------------

Fix the kernel oops when dev_dbg is called with mx3_fbi->txd == NULL

Fix the late initialisation of mx3fb->backlight_level.
If not, in the chain of function started by init_fb_chan(), in __blank() call 
sdc_set_brightness(mx3fb, mx3fb->backlight_level) that will shut down
the CONTRAST PWM output. 

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski <at> gmx.de>
---
 drivers/video/mx3fb.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 054ef29..772ba3f 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -324,8 +324,11 @@ static void sdc_enable_channel(struct mx3fb_info *mx3_fbi)
        unsigned long flags;
        dma_cookie_t cookie;
 
-       dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mx3_fbi,
-               to_tx_desc(mx3_fbi->txd), to_tx_desc(mx3_fbi->txd)->sg);
+       if (mx3_fbi->txd)
+               dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mx3_fbi,
+                       to_tx_desc(mx3_fbi->txd), to_tx_desc(mx3_fbi->txd)->sg);
+       else
+               dev_dbg(mx3fb->dev, "mx3fbi %p, txd = NULL\n", mx3_fbi);
 
        /* This enables the channel */
        if (mx3_fbi->cookie < 0) {
@@ -646,6 +649,7 @@ static int sdc_set_global_alpha(struct mx3fb_data *mx3fb, bool enable, uint8_t a
 
 static void sdc_set_brightness(struct mx3fb_data *mx3fb, uint8_t value)
 {
+       dev_dbg(mx3fb->dev, "%s: value = %d\n", __func__, value);
        /* This might be board-specific */
        mx3fb_write_reg(mx3fb, 0x03000000UL | value << 16, SDC_PWM_CTRL);
        return;
@@ -1486,12 +1490,12 @@ static int mx3fb_probe(struct platform_device *pdev)
                goto ersdc0;
        }
 
+       mx3fb->backlight_level = 255;
+
        ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
        if (ret < 0)
                goto eisdc0;
 
-       mx3fb->backlight_level = 255;
-
        return 0;
 
 eisdc0:
-- 
1.6.3.3


