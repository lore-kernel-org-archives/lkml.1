Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbXBUVo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbXBUVo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626AbXBUVo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:44:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56758 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbXBUVo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:44:26 -0500
Date: Wed, 21 Feb 2007 21:44:20 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Andrew Morton <akpm@osdl.org>
cc: Ville Syrjala <syrjala@sci.fi>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-users] atyfb - system hangs at bootup prior to
 enabling framebuffer console -- linux 2.6.18 (fwd)
Message-ID: <Pine.LNX.4.64.0702212143180.20620@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1831524198-554861201-1172094242=:20620"
Content-ID: <Pine.LNX.4.64.0702212144170.20620@pentafluge.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1831524198-554861201-1172094242=:20620
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0702212144171.20620@pentafluge.infradead.org>


Andrew please apply.

Acked-By: James Simmons <jsimmons@infradead.org>

---------- Forwarded message ----------
Date: Sat, 17 Feb 2007 15:19:12 +0200
From: Ville Syrjälä <syrjala@sci.fi>
Reply-To: linux-fbdev-users@lists.sourceforge.net
To: linux-fbdev-users@lists.sourceforge.net
Subject: Re: [Linux-fbdev-users] atyfb - system hangs at bootup prior to
    enabling framebuffer console -- linux 2.6.18

On Fri, Feb 16, 2007 at 06:37:31PM -0500, cga2000 wrote:
> More than 50% of the time my laptop hangs when booting with 
> 
> ... video=atyfb:1400x1050.
> 
> I have seen similar occurrences reported here and there with recent 2.6
> kernels but nothing very clear as to whether this is a known problem or
> whether a patch or workaround has already been provided.

I was just able to reproduce the problem by switching from drivers/ide 
to libata. In my case the laptop would hang on every boot. Apparently 
using libata changed the timing enough to trigger the bug.

Try this patch:

---
 drivers/video/aty/mach64_ct.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6.20/drivers/video/aty/mach64_ct.c
===================================================================
--- linux-2.6.20.orig/drivers/video/aty/mach64_ct.c
+++ linux-2.6.20/drivers/video/aty/mach64_ct.c
@@ -598,7 +598,6 @@ static void aty_resume_pll_ct(const stru
 	struct atyfb_par *par = info->par;
 
 	if (par->mclk_per != par->xclk_per) {
-		int i;
 		/*
 		* This disables the sclk, crashes the computer as reported:
 		* aty_st_pll_ct(SPLL_CNTL2, 3, info);
@@ -609,12 +608,10 @@ static void aty_resume_pll_ct(const stru
 		aty_st_pll_ct(SCLK_FB_DIV, pll->ct.sclk_fb_div, par);
 		aty_st_pll_ct(SPLL_CNTL2, pll->ct.spll_cntl2, par);
 		/*
-		 * The sclk has been started. However, I believe the first clock
-		 * ticks it generates are not very stable. Hope this primitive loop
-		 * helps for Rage Mobilities that sometimes crash when
-		 * we switch to sclk. (Daniel Mantione, 13-05-2003)
+		 * The sclk has been started. Wait for the PLL to lock. 5 ms
+		 * should be enough according to mach64 programmers guide.
 		 */
-		for (i=0;i<=0x1ffff;i++);
+		mdelay(5);
 	}
 
 	aty_st_pll_ct(PLL_REF_DIV, pll->ct.pll_ref_div, par);
-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Linux-fbdev-users mailing list
Linux-fbdev-users@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-fbdev-users
---1831524198-554861201-1172094242=:20620--
