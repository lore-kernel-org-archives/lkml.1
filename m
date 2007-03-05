Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbXCEJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbXCEJfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 04:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbXCEJfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 04:35:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48942
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932536AbXCEJfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 04:35:37 -0500
Date: Mon, 05 Mar 2007 01:35:36 -0800 (PST)
Message-Id: <20070305.013536.115912904.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: [PATCH]: Fix driver bogus delay loop
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


CT based mach64 cards were reported to hang on sparc64 boxes when
compiled with gcc-4.1.x and later.

Looking at this piece of code, it's no surprise.  A critical
delay was implemented as an empty for() loop, and gcc 4.0.x
and previous did not optimize it away, so we did get a delay.

But gcc-4.1.x and later can optimize it away, and we get crashes.

Use a real udelay() to fix this.  Fix verified on SunBlade100.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/video/aty/mach64_ct.c b/drivers/video/aty/mach64_ct.c
index f3b487b..1fdcfdb 100644
--- a/drivers/video/aty/mach64_ct.c
+++ b/drivers/video/aty/mach64_ct.c
@@ -598,7 +598,6 @@ static void aty_resume_pll_ct(const struct fb_info *info,
 	struct atyfb_par *par = info->par;
 
 	if (par->mclk_per != par->xclk_per) {
-		int i;
 		/*
 		* This disables the sclk, crashes the computer as reported:
 		* aty_st_pll_ct(SPLL_CNTL2, 3, info);
@@ -614,7 +613,7 @@ static void aty_resume_pll_ct(const struct fb_info *info,
 		 * helps for Rage Mobilities that sometimes crash when
 		 * we switch to sclk. (Daniel Mantione, 13-05-2003)
 		 */
-		for (i=0;i<=0x1ffff;i++);
+		udelay(500);
 	}
 
 	aty_st_pll_ct(PLL_REF_DIV, pll->ct.pll_ref_div, par);
