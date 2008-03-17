Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYCQIVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYCQIVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYCQIUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:20:55 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:33864 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYCQIUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:20:54 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: [PATCH] i810fb: Fix console switch regression
Date: Mon, 17 Mar 2008 09:20:32 +0100
User-Agent: KMail/1.9.5
References: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de> <Pine.LNX.4.64.0803162042460.7207@anakin>
In-Reply-To: <Pine.LNX.4.64.0803162042460.7207@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803170920.33626.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.4 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 652e4af5a5c207f483e6e71f7e96832f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 16. März 2008 20:48 schrieb Geert Uytterhoeven:
> On Sun, 16 Mar 2008, Stefan Bauer wrote:
> > --- linux-2.6/drivers/video/i810/i810_main.c.orig
> > +++ linux-2.6/drivers/video/i810/i810_main.c
> > @@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info
> > 	struct i810fb_par *par = info->par;
> > 	u8 __iomem *mmio = par->mmio_start_virtual;
> >
> > -	if (!(par->dev_flags & LOCKUP))
> > +	if (!par->dev_flags & LOCKUP)
> > 		return -ENXIO;
>
> However, the original expression didn't make sense, as LOCKUP is 8 and
> !par->dev_flags is either 0 or 1, so `!par->dev_flags & LOCKUP' is
> always 0.
>
> I took a quick look at the usage of the LOCKUP flag. Apparently when a
> lock-up is detected, this flag is set, and the driver will fall back to
> software operations instead of hardware accelerated operations.
>
> Is it possible the intended code was
>
> 	if (par->dev_flags & LOCKUP)
> 		return -ENXIO;
>
> ?

Yes, IMO you are right. 4c7ffe0 ("fbdev: prevent drivers that have hardware 
cursors from calling software cursor code") introduced the senseless code.

I'm going on testing today, but I think that's it.

Again, please CC me, thanks.

---
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>

Since 4c7ffe0b9f7f40bd818fe3af51342f64c483908e ("fbdev: prevent drivers that 
have hardware cursors from calling software cursor code") every call of 
i810fb_cursor fails with -ENXIO because of a incorrect "!".

This hasn't striked until eaa0ff15c30dc9799eb4d12660edb73aeb6d32c5 ("fix ! 
versus & precedence in various places") surrounded the expression with 
braces, so that the intended behavior was inverted. That caused 'pixel 
waste' - the same line of multi-colored pixels repeated over the whole 
screen - during console switch.

This switches back to the original pre-4c7ffe0 behavior.

Signed-off-by: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Antonino Daplas <adaplas@pol.net>

---
--- linux-2.6/drivers/video/i810/i810_main.c.orig
+++ linux-2.6/drivers/video/i810/i810_main.c
@@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info
        struct i810fb_par *par = info->par;
        u8 __iomem *mmio = par->mmio_start_virtual;

-       if (!(par->dev_flags & LOCKUP))
+       if (par->dev_flags & LOCKUP)
                return -ENXIO;

        if (cursor->image.width > 64 || cursor->image.height > 64)
