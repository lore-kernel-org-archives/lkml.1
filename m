Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYDQEbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYDQEbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYDQEbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:31:32 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:34057 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYDQEbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:31:31 -0400
Message-ID: <4806D2A0.3080207@tiscali.nl>
Date: Thu, 17 Apr 2008 06:31:28 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: hskinnemoen@atmel.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] atmel_lcdfb: fix negative check on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No signed negative values will get noticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index fc65c02..4b927da 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -422,13 +422,13 @@ static int atmel_lcdfb_set_par(struct fb_info *info)
 
 	value = DIV_ROUND_UP(clk_value_khz, PICOS2KHZ(info->var.pixclock));
 
-	value = (value / 2) - 1;
-	dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
-
-	if (value <= 0) {
+	if ((value / 2) <= 1) {
+		dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", (value/2)-1);
 		dev_notice(info->device, "Bypassing pixel clock divider\n");
 		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, ATMEL_LCDC_BYPASS);
 	} else {
+		value = (value / 2) - 1;
+		dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
 		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, value << ATMEL_LCDC_CLKVAL_OFFSET);
 		info->var.pixclock = KHZ2PICOS(clk_value_khz / (2 * (value + 1)));
 		dev_dbg(info->device, "  updated pixclk:     %lu KHz\n",
