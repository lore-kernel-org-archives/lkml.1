Return-Path: <linux-kernel-owner+w=401wt.eu-S1765159AbYEFQes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765159AbYEFQes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbYEFQek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:34:40 -0400
Received: from mail.atmel.fr ([81.80.104.162]:41988 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbYEFQej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:34:39 -0400
Message-ID: <48209708.3020807@atmel.com>
Date: Tue, 06 May 2008 19:36:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Icedove 1.5.0.14pre (X11/20080208)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com
CC: Per Hedblom <per.hedblom@abem.se>, Roel Kluin <12o3l@tiscali.nl>,
       Jan Weber <jw022609@uni-greifswald.de>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] atmel_lcdfb: fix pixclok divider calculation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix divider calculation and allow CLKVAL = 0 (divisor 2)

It was not possible to get the clock value 0 (divisor 2) because 
the test "<=0" force the BYPASS bit to be activated instead.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Thanks a lot to Jan, Per, Roel and Haavard for sending me
similar patches.

 drivers/video/atmel_lcdfb.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -441,13 +441,12 @@ static int atmel_lcdfb_set_par(struct fb_info *info)
 
 	value = DIV_ROUND_UP(clk_value_khz, PICOS2KHZ(info->var.pixclock));
 
-	value = (value / 2) - 1;
-	dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
-
-	if (value <= 0) {
+	if (value < 2) {
 		dev_notice(info->device, "Bypassing pixel clock divider\n");
 		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, ATMEL_LCDC_BYPASS);
 	} else {
+		value = (value / 2) - 1;
+		dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
 		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, value << ATMEL_LCDC_CLKVAL_OFFSET);
 		info->var.pixclock = KHZ2PICOS(clk_value_khz / (2 * (value + 1)));
 		dev_dbg(info->device, "  updated pixclk:     %lu KHz\n",

