Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbXFWSF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbXFWSF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXFWSFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:05:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754902AbXFWSFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:05:07 -0400
Date: Sat, 23 Jun 2007 11:04:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: spock@gentoo.org
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fbdev: make fb_find_mode look for a mode with the
 highest refresh rate
Message-Id: <20070623110424.9a68d82d.akpm@linux-foundation.org>
In-Reply-To: <20070623105046.GB12623@spock.one.pl>
References: <20070623105046.GB12623@spock.one.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 12:50:46 +0200 Michal Januszewski <spock@gentoo.org> wrote:

> If the refresh rate hasn't been explicitly specified, fd_find_mode
> currently returns the first mode with the requested resolution. Change
> it so that it returns a mode with the requested resolution and the
> highest refresh rate.
> 
> Also export fb_destroy_modelist, which is used in uvesafb.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> ---
> drivers/video/modedb.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
> index 3741ad7..98ee77b 100644
> --- a/drivers/video/modedb.c
> +++ b/drivers/video/modedb.c
> @@ -606,16 +606,18 @@ done:
>  	DPRINTK("Trying specified video mode%s %ix%i\n",
>  	    refresh_specified ? "" : " (ignoring refresh rate)", xres, yres);
>  
> +	if (!refresh_specified)
> +		refresh = 200;
>  	diff = refresh;
>  	best = -1;
>  	for (i = 0; i < dbsize; i++) {
>  		if (name_matches(db[i], name, namelen) ||
>  		    (res_specified && res_matches(db[i], xres, yres))) {
>  			if(!fb_try_mode(var, info, &db[i], bpp)) {
> -				if(!refresh_specified || db[i].refresh == refresh)
> +				if (refresh_specified && db[i].refresh == refresh)
>  					return 1;
>  				else {
> -					if(diff > abs(db[i].refresh - refresh)) {
> +					if (diff > abs(db[i].refresh - refresh)) {
>  						diff = abs(db[i].refresh - refresh);
>  						best = i;
>  					}
> @@ -938,6 +940,7 @@ void fb_destroy_modelist(struct list_head *head)
>  		kfree(pos);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(fb_destroy_modelist);
>  

fbdev ignoramus asks: isn't this pretty risky?  People who were previously
relying upon (or at least using) the kernel's default resolution will find
their displays coming up in a quite different resolution.

This change seems to be quite unrelated to the uvesafb stuff and should be
in a separate patch from the export, which _is_ uvesafb-related.  I think. 
If that's wrong then the changelog could do with some attention.

