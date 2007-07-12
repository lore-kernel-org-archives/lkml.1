Return-Path: <linux-kernel-owner+w=401wt.eu-S1762878AbXGLIfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878AbXGLIfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbXGLIfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:35:10 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:7881 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbXGLIfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CZZjEbnLxADJoCN2nxjIxHmkwfB1fd4UikSqrIllgk3MLBZ5QMRY+ivBsZWmi+cXo9TNAciSvxq1a4f/9MVEUrfTd5bJbnd6YY2sPoDODa+4xbHDj9FKupTssDKQwpEM4VPVf7h7PvIiL5Ek6Te5MK8kCmg0qwNhqgCJXESvRHc=
Subject: Re: [Linux-fbdev-devel] [PATCH 1/4] fbdev: make fb_find_mode look
	for a mode with the highest refresh rate
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: spock@gentoo.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070623110424.9a68d82d.akpm@linux-foundation.org>
References: <20070623105046.GB12623@spock.one.pl>
	 <20070623110424.9a68d82d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 16:34:53 +0800
Message-Id: <1184229293.4504.33.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 11:04 -0700, Andrew Morton wrote:
> On Sat, 23 Jun 2007 12:50:46 +0200 Michal Januszewski <spock@gentoo.org> wrote:
> 
> > If the refresh rate hasn't been explicitly specified, fd_find_mode
> > currently returns the first mode with the requested resolution. Change
> > it so that it returns a mode with the requested resolution and the
> > highest refresh rate.
> > 
> > Also export fb_destroy_modelist, which is used in uvesafb.
> > 
> > Signed-off-by: Michal Januszewski <spock@gentoo.org>
> > ---
> > drivers/video/modedb.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
> > index 3741ad7..98ee77b 100644
> > --- a/drivers/video/modedb.c
> > +++ b/drivers/video/modedb.c
> > @@ -606,16 +606,18 @@ done:
> >  	DPRINTK("Trying specified video mode%s %ix%i\n",
> >  	    refresh_specified ? "" : " (ignoring refresh rate)", xres, yres);
> >  
> > +	if (!refresh_specified)
> > +		refresh = 200;
> >  	diff = refresh;
> >  	best = -1;
> >  	for (i = 0; i < dbsize; i++) {
> >  		if (name_matches(db[i], name, namelen) ||
> >  		    (res_specified && res_matches(db[i], xres, yres))) {
> >  			if(!fb_try_mode(var, info, &db[i], bpp)) {
> > -				if(!refresh_specified || db[i].refresh == refresh)
> > +				if (refresh_specified && db[i].refresh == refresh)
> >  					return 1;
> >  				else {
> > -					if(diff > abs(db[i].refresh - refresh)) {
> > +					if (diff > abs(db[i].refresh - refresh)) {
> >  						diff = abs(db[i].refresh - refresh);
> >  						best = i;
> >  					}
> > @@ -938,6 +940,7 @@ void fb_destroy_modelist(struct list_head *head)
> >  		kfree(pos);
> >  	}
> >  }
> > +EXPORT_SYMBOL_GPL(fb_destroy_modelist);
> >  
> 
> fbdev ignoramus asks: isn't this pretty risky?  People who were previously
> relying upon (or at least using) the kernel's default resolution will find
> their displays coming up in a quite different resolution.

It's only the refresh rate that will change.  The current behavior is
that a user can get near random results in terms of the vertical refresh
rates.  At least with this patch, we know what we get.

> 
> This change seems to be quite unrelated to the uvesafb stuff and should be
> in a separate patch from the export, which _is_ uvesafb-related.  I think. 
> If that's wrong then the changelog could do with some attention.
> 

Tony

