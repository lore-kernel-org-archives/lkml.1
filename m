Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXFURZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXFURZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXFURZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:25:19 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54926 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbXFURZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:25:17 -0400
Date: Thu, 21 Jun 2007 20:25:14 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: mach64 breakage in 2.6.22
Message-ID: <20070621172514.GA11766@sci.fi>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070614082528.GA10284@aepfle.de> <20070614173623.GA7950@sci.fi> <20070618144534.GA18150@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618144534.GA18150@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 04:45:34PM +0200, Olaf Hering wrote:
> On Thu, Jun 14, Ville Syrjälä wrote:
> 
> > On Thu, Jun 14, 2007 at 10:25:28AM +0200, Olaf Hering wrote:
> > > On Sat, May 05, Andrew Morton wrote:
> > > 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > > 
> > > > +atyfb-reorganize-clock-init.patch
> > > 
> > > This change breaks the display on an ibook1 with 800x600 lcd.
> > 
> > Are you sure?
> 
> Yes.

Strange. Either patch alone should not cause any change in the clock
frequencies. Combined the two and it should lead to exactly the dmesg
you posted.
> 
> > Please try this patch:
> 
> >  	if (machine_is_compatible("PowerBook2,1")) {
> >  		par->pll_limits.mclk = 70;
> > -		par->pll_limits.xclk = 53;
> > +		par->pll_limits.xclk = 106;
> 
> This oneliner fixes it for me.

Here's a slightly safer version, just in case there are iBooks with
non-mobility chips or using the 64bit memory interface.


atyfb: Fix XCLK frequency on Apple iBook1

Fix a regression on Apple iBook1. Changes in the clock init code
caused an incorrect XCLK frequency to be used leading to a corrupted
display.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
---
 drivers/video/aty/atyfb_base.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6.22-rc2/drivers/video/aty/atyfb_base.c
===================================================================
--- linux-2.6.22-rc2.orig/drivers/video/aty/atyfb_base.c
+++ linux-2.6.22-rc2/drivers/video/aty/atyfb_base.c
@@ -2290,15 +2290,6 @@ static int __devinit aty_init(struct fb_
 	init_waitqueue_head(&par->vblank.wait);
 	spin_lock_init(&par->int_lock);
 
-#ifdef CONFIG_PPC_PMAC
-	/* The Apple iBook1 uses non-standard memory frequencies. We detect it
-	 * and set the frequency manually. */
-	if (machine_is_compatible("PowerBook2,1")) {
-		par->pll_limits.mclk = 70;
-		par->pll_limits.xclk = 53;
-	}
-#endif
-
 #ifdef CONFIG_FB_ATY_GX
 	if (!M64_HAS(INTEGRATED)) {
 		u32 stat0;
@@ -2383,6 +2374,14 @@ static int __devinit aty_init(struct fb_
 			par->pll_limits.xclk = (par->pll_limits.xclk + 1) >> 1;
 	}
 #endif
+#ifdef CONFIG_PPC_PMAC
+	/* The Apple iBook1 uses non-standard memory frequencies. We detect it
+	 * and set the frequency manually. */
+	if (machine_is_compatible("PowerBook2,1")) {
+		par->pll_limits.mclk = 70;
+		par->pll_limits.xclk = 53;
+	}
+#endif
 
 	/* Allow command line to override clocks. */
 	if (pll)
-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
