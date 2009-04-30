Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbZD3Ntq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbZD3Ntq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763464AbZD3Nsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:48:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55927 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763458AbZD3Nsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:48:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.30 2/2] mfd: Keep a cache of WM8350 volatile values
Date: Thu, 30 Apr 2009 14:48:36 +0100
Message-Id: <1241099316-17948-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241099316-17948-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1241099316-17948-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the way that the WM8350 audio driver handles CODEC_ENA many of
the WM8350 audio registers are marked as volatile when they aren't
actually so. Allow the audio driver to see a cache of these values for
inspection during interrupt context.

To do this we need to stop satisfying any bits from volatile registers
from cache - there's no real benefit from doing so anyway, we did the
read already.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index c2be308..fe24079 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -79,10 +79,6 @@ static int wm8350_phys_read(struct wm8350 *wm8350, u8 reg, int num_regs,
 		/* Cache is CPU endian */
 		dest[i - reg] = be16_to_cpu(dest[i - reg]);
 
-		/* Satisfy non-volatile bits from cache */
-		dest[i - reg] &= wm8350_reg_io_map[i].vol;
-		dest[i - reg] |= wm8350->reg_cache[i];
-
 		/* Mask out non-readable bits */
 		dest[i - reg] &= wm8350_reg_io_map[i].readable;
 	}
@@ -182,9 +178,6 @@ static int wm8350_write(struct wm8350 *wm8350, u8 reg, int num_regs, u16 *src)
 			(wm8350->reg_cache[i] & ~wm8350_reg_io_map[i].writable)
 			| src[i - reg];
 
-		/* Don't store volatile bits */
-		wm8350->reg_cache[i] &= ~wm8350_reg_io_map[i].vol;
-
 		src[i - reg] = cpu_to_be16(src[i - reg]);
 	}
 
@@ -1261,7 +1254,6 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int type, int mode)
 		    (i < WM8350_CLOCK_CONTROL_1 || i > WM8350_AIF_TEST)) {
 			value = be16_to_cpu(wm8350->reg_cache[i]);
 			value &= wm8350_reg_io_map[i].readable;
-			value &= ~wm8350_reg_io_map[i].vol;
 			wm8350->reg_cache[i] = value;
 		} else
 			wm8350->reg_cache[i] = reg_map[i];
-- 
1.6.2.4

