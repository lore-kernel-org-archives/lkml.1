Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbZKESwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbZKESwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbZKESwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:52:43 -0500
Received: from d1.icnet.pl ([212.160.220.21]:37310 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758260AbZKESwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:52:42 -0500
To: linux-omap@vger.kernel.org
Subject: [PATCH v3] OMAP: DMA: Fix omapfb/lcdc on OMAP1510 broken when PM set
Cc: Tony Lindgren <tony@atomide.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
Date: Thu, 5 Nov 2009 19:51:28 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911051951.32020.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_PM=y, the omapfb/lcdc device on Amstrad Delta, after initially
starting correctly, breaks with the following error messages:

omapfb omapfb: resetting (status 0xffffff96,reset count 1)
...
omapfb omapfb: resetting (status 0xffffff96,reset count 100)
omapfb omapfb: too many reset attempts, giving up.

Looking closer at this I have found that it had been broken almost 2 years ago
with commit 2418996e3b100114edb2ae110d5d4acb928909d2, PM fixes for OMAP1.

The definite reason for broken omapfb/lcdc behavoiur in PM mode
appeared to be ARM_IDLECT1:IDLIF_ARM (bit 6) put into idle regardless of LCD
DMA possibly running. The bit were set based on return value of the
omap_dma_running() function that did not check for dedicated LCD DMA
channel status. The patch below fixes this.

Created against linux-2.6.32-rc6

Tested on Amstrad Delta

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

---
Tuesday 03 November 2009 21:10:48 Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [091103 12:05]:
> > Sorry, I've not checked for new mail before posting this one and missed
> > your acceptance for my idea of fixing all omap1510, not only ams_delta.
> > If there are no more comments, I'll submit v3 with cpu_is_omap1510()
> > replacing machine_is_ams_delta().
>
> Sounds good to me.
>
> Tony

--- linux-2.6.32-rc6/arch/arm/plat-omap/dma.c.orig	2009-11-03 20:37:49.000000000 +0100
+++ linux-2.6.32-rc6/arch/arm/plat-omap/dma.c	2009-11-05 19:30:39.000000000 +0100
@@ -1108,6 +1108,14 @@ int omap_dma_running(void)
 {
 	int lch;
 
+	/*
+	 * On OMAP1510, internal LCD controller will start the transfer
+	 * when it gets enabled, so assume DMA running if LCD enabled.
+	 */
+	if (cpu_is_omap1510())
+		if (omap_readw(0xfffec000 + 0x00) & (1 << 0))
+			return 1;
+
 	/* Check if LCD DMA is running */
 	if (cpu_is_omap16xx())
 		if (omap_readw(OMAP1610_DMA_LCD_CCR) & OMAP_DMA_CCR_EN)
