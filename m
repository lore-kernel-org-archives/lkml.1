Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZDWVrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZDWVrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZDWVrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:47:41 -0400
Received: from smtp4.welho.com ([213.243.153.38]:37909 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbZDWVrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:47:40 -0400
Date: Fri, 24 Apr 2009 00:47:38 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] fbcmap: non working tests on unsigned
	cmap->start
Message-ID: <20090423214738.GF7134@sci.fi>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Roel Kluin <roel.kluin@gmail.com>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, adaplas@gmail.com
References: <49EDD799.8060607@gmail.com> <20090423134110.51ea8df2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090423134110.51ea8df2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 01:41:10PM -0700, Andrew Morton wrote:
> On Tue, 21 Apr 2009 16:26:33 +0200
> Roel Kluin <roel.kluin@gmail.com> wrote:
> 
> > vi include/linux/fb.h +478
> > 
> > Note that struct fb_cmap_user cmap->start in fb_set_user_cmap() is unsigned.
> > Should there maybe be a test:
> > 
> > if (cmap->start > MAX || ...)
> > 
> > (and what should MAX be then?)
> > 
> > Otherwise you may want to apply the cleanup patch below
> > 
> > Roel
> > ------------------------------>8-------------8<---------------------------------
> > Remove redundant tests on unsigned
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
> > ---
> > diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> > index f53b9f1..958bf4e 100644
> > --- a/drivers/video/fbcmap.c
> > +++ b/drivers/video/fbcmap.c
> > @@ -266,8 +266,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
> >  		rc = -ENODEV;
> >  		goto out;
> >  	}
> > -	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> > -				!info->fbops->fb_setcmap)) {
> > +	if (!info->fbops->fb_setcolreg && !info->fbops->fb_setcmap) {
> >  		rc = -EINVAL;
> >  		goto out1;
> >  	}
> 
> argh.
> 
> - Perhaps userspace can kill the kernel by sending a "negative"
>   `start'.  Removing the test will make it even less likely that we'll
>   fix this bug.

Shouldn't happen. 'start' is used as the starting index for the hardware
palette, 'start+len-1' is the last index. All drivers should already check
the passed values since the maximum index depends on the display mode.
And I suppose the worst thing that could happen if the driver fails to
check the values would be incorrect colors.

> - If this bug doesn't exist, and there _is_ userspace which is
>   legitimately sending in "negative" values of `start' (unlikely?) then
>   we will break userspace if we fix this comparison.

The comparison will always be false since 'start' is unsigned so how
would anything break?

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
