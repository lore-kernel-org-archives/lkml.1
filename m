Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYKFHxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYKFHxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYKFHxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:53:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:41939 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbYKFHx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:53:29 -0500
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Collins <paul@burly.ondioline.org>
Cc: James Cloos <cloos@jhcloos.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <87k5bhs8a7.fsf@burly.wgtn.ondioline.org>
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	 <1225152347.8004.49.camel@pasglop> <m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	 <1225662539.8004.237.camel@pasglop>
	 <871vxtthr3.fsf@burly.wgtn.ondioline.org>
	 <1225697689.8004.245.camel@pasglop>
	 <87wsfkrnn1.fsf@burly.wgtn.ondioline.org>
	 <1225834394.8004.273.camel@pasglop>
	 <87k5bhs8a7.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 18:52:41 +1100
Message-Id: <1225957961.13603.48.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 19:00 +1300, Paul Collins wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> > Heh, it would have been easier to do
> >
> > 	width = (image->width | 0x1f) + 1; 
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> > Oh and you also need to change the src_bytes calculation 
> 
> With the slightly less embarrassing patch below applied and using the
> default 8x16 font, the machine boots successfully with the expected
> gibberish console display.  I can then setfont one of the large fonts
> and it does not lock up.  The gibberish changes and if I do dmesg I even
> get a few chunks of legible output: http://ondioline.org/~paul/corruption.png

Ok. Well, that's both good and bad news. Good news is, we have a handle
on what the bug can be, ie, the comment in X might refer to an actual HW
limitation/bug, though I find it strange that it works fine in some
cases and not others.

The bad news is, I yet to figure out if we have a proper way out of it
using the clipping etc... that doesn't involve making the acceleration
totally worthless in the first place since it's already not very
interesting on a few platforms.

I'll dig but I'm afraid chances are that I'll disable the acceleration
by default unless some special command line arg is passed so that David
can still get his faster console on sparc.

Maybe using a completely different approach such as caching pre-expanded
glyphs would lead to better results... though I think it's harder to
implement with fbcon.

Cheers,
Ben.

> 
> diff --git a/drivers/video/aty/radeon_accel.c b/drivers/video/aty/radeon_accel.c
> index 8718f73..6dbd24a 100644
> --- a/drivers/video/aty/radeon_accel.c
> +++ b/drivers/video/aty/radeon_accel.c
> @@ -176,6 +176,7 @@ static void radeonfb_prim_imageblit(struct radeonfb_info *rinfo,
>  {
>  	unsigned int src_bytes, dwords;
>  	u32 *bits;
> +	int width;
>  
>  	radeonfb_set_creg(rinfo, DP_GUI_MASTER_CNTL, &rinfo->dp_gui_mc_cache,
>  			  rinfo->dp_gui_mc_base |
> @@ -208,9 +209,11 @@ static void radeonfb_prim_imageblit(struct radeonfb_info *rinfo,
>  	 * work ok for me without that and the doco doesn't seem to imply
>  	 * there is such a restriction.
>  	 */
> -	OUTREG(DST_WIDTH_HEIGHT, (image->width << 16) | image->height);
> +	/* Let us pad. */
> +	width = (image->width | 0x1f) + 1;
> +	OUTREG(DST_WIDTH_HEIGHT, (width << 16) | image->height);
>  
> -	src_bytes = (((image->width * image->depth) + 7) / 8) * image->height;
> +	src_bytes = (((width * image->depth) + 7) / 8) * image->height;
>  	dwords = (src_bytes + 3) / 4;
>  	bits = (u32*)(image->data);
> 

