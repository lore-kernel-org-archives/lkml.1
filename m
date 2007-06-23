Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbXFWV0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbXFWV0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 17:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXFWV0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 17:26:35 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:52705 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXFWV0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 17:26:34 -0400
Date: Sat, 23 Jun 2007 23:26:32 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fbdev: make fb_find_mode look for a mode with the
	highest refresh rate
Message-ID: <20070623212632.GA7148@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070623105046.GB12623@spock.one.pl> <20070623110424.9a68d82d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070623110424.9a68d82d.akpm@linux-foundation.org>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 11:04:24AM -0700, Andrew Morton wrote:
> On Sat, 23 Jun 2007 12:50:46 +0200 Michal Januszewski <spock@gentoo.org> wrote:
> 
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

The resolution will be unchanged (this part of the code is only executed
if either the name of the mode or the resolution are a match).

What can change is the refresh rate -- it can be set higher than what it
used to be before.  But since we're checking all modes with fb_try_mode(),
(which calls fb_check_var()), I think that this change should be safe.
 
To avoid any side effects we could also do the following:

	for (i = 0; i < dbsize; i++) {
		if (name_matches(db[i], name, namelen) ||
		    (res_specified && res_matches(db[i], xres, yres))) {
			if(!fb_try_mode(var, info, &db[i], bpp)) {
				if (refresh_specified && db[i].refresh == refresh)
					return 1;
				else {
					if (diff > abs(db[i].refresh - refresh)) {
						diff = abs(db[i].refresh - refresh);
						best = i;
					}
				}
			}
		}
	}

	if (best != -1) {
		fb_try_mode(var, info, &db[best], bpp);
-		return 2;
+ 		return (refresh_specified) ? 2 : 1;
	}

which would ensure that 1 is returned if the refresh rate is not
explicitly specified, just as it is done currently:

				if(!refresh_specified || db[i].refresh == refresh)
					return 1

I might be missing something here, so it would be nice if someone
involved in the fb development could comment on the proposed change.

> This change seems to be quite unrelated to the uvesafb stuff and should be
> in a separate patch from the export, which _is_ uvesafb-related.  I think. 
> If that's wrong then the changelog could do with some attention.

You're right, I'll split this into two patches in the next round.

Best regards,
Michal

