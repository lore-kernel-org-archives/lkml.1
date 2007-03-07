Return-Path: <linux-kernel-owner+w=401wt.eu-S1422936AbXCGRVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422936AbXCGRVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXCGRV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:21:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422910AbXCGRSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:38 -0500
Message-Id: <20070307171700.892878854@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Antonino A. Daplas" <adaplas@pol.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 098/101] video/aty/mach64_ct.c: fix bogus delay loop
Content-Disposition: inline; filename=video-aty-mach64_ct.c-fix-bogus-delay-loop.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

[PATCH] video/aty/mach64_ct.c: fix bogus delay loop

CT based mach64 cards were reported to hang on sparc64 boxes when
compiled with gcc-4.1.x and later.

Looking at this piece of code, it's no surprise.  A critical
delay was implemented as an empty for() loop, and gcc 4.0.x
and previous did not optimize it away, so we did get a delay.

But gcc-4.1.x and later can optimize it away, and we get crashes.

Use a real udelay() to fix this.  Fix verified on SunBlade100.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 drivers/video/aty/mach64_ct.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.20.1.orig/drivers/video/aty/mach64_ct.c
+++ linux-2.6.20.1/drivers/video/aty/mach64_ct.c
@@ -598,7 +598,6 @@ static void aty_resume_pll_ct(const stru
 	struct atyfb_par *par = info->par;
 
 	if (par->mclk_per != par->xclk_per) {
-		int i;
 		/*
 		* This disables the sclk, crashes the computer as reported:
 		* aty_st_pll_ct(SPLL_CNTL2, 3, info);
@@ -614,7 +613,7 @@ static void aty_resume_pll_ct(const stru
 		 * helps for Rage Mobilities that sometimes crash when
 		 * we switch to sclk. (Daniel Mantione, 13-05-2003)
 		 */
-		for (i=0;i<=0x1ffff;i++);
+		udelay(500);
 	}
 
 	aty_st_pll_ct(PLL_REF_DIV, pll->ct.pll_ref_div, par);

--
