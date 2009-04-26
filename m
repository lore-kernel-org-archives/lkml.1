Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZDZNP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZDZNP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZDZNPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:15:10 -0400
Received: from smtp6.welho.com ([213.243.153.40]:39578 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZDZNPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:15:09 -0400
Date: Sun, 26 Apr 2009 16:15:05 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] fbcmap: non working tests on unsigned
	cmap->start
Message-ID: <20090426131505.GG7134@sci.fi>
Mail-Followup-To: Roel Kluin <roel.kluin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, adaplas@gmail.com
References: <49EDD799.8060607@gmail.com> <20090423134110.51ea8df2.akpm@linux-foundation.org> <20090423214738.GF7134@sci.fi> <49F4519F.4090003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49F4519F.4090003@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 02:20:47PM +0200, Roel Kluin wrote:
> cmap->start is unsigned, A negative start could result in incorrect
> colors. `start' is used as the starting index for the hardware palette,
> 'start+len-1' is the last index.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> >>> vi include/linux/fb.h +478
> >>>
> >>> Note that struct fb_cmap_user cmap->start in fb_set_user_cmap() is unsigned.
> >>> Should there maybe be a test:
> >>>
> >>> if (cmap->start > MAX || ...)
> >>>
> >>> (and what should MAX be then?)
> >>>
> 
> > On Thu, Apr 23, 2009 at 01:41:10PM -0700, Andrew Morton wrote:
> >> argh.
> >>
> >> - Perhaps userspace can kill the kernel by sending a "negative"
> >>   `start'.  Removing the test will make it even less likely that we'll
> >>   fix this bug.
> > 
> > Shouldn't happen. 'start' is used as the starting index for the hardware
> > palette, 'start+len-1' is the last index. All drivers should already check
> > the passed values since the maximum index depends on the display mode.
> > And I suppose the worst thing that could happen if the driver fails to
> > check the values would be incorrect colors.
> 
> Thanks for your explanation, I think this should fix it?
> 
> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index f53b9f1..ea62d87 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -266,7 +266,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>  		rc = -ENODEV;
>  		goto out;
>  	}
> -	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> +	if (cmap->start >= cmap->len || (!info->fbops->fb_setcolreg &&
>  				!info->fbops->fb_setcmap)) {
>  		rc = -EINVAL;
>  		goto out1;

That's not correct. There's nothing wrong with having 'start' >= 'len'.

You would rather need something like
'if (start+len > 1 << max(red.len, green.len, blue.len, transp.len))'
and a check to make sure that start+len doesn't overflow.

Oh and I guess it should also check that the visual is pseudocolor or
directcolor.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
