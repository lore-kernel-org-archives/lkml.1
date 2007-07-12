Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbXGLIcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbXGLIcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763255AbXGLIbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:31:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:51234 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763210AbXGLIbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n9NZ/tmxhDp4CL/E4jm4oih8+optYT4NHiwHbxsUdyigzzreq0oaRBDO+VofnjsueTeVxtxNrev45RrVxPS6gd5x8mZG7sKgidhKTMp4HdZ5e2qwq0y31v0tJ2GQ21X9Lo/ZYam08liyZBLjredUsBvkRUe4+p7lENE+oGv+2Qs=
Subject: Re: [Linux-fbdev-devel] [PATCH 1/4] fbdev: make fb_find_mode look
	for a mode with the	highest refresh rate
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: spock@gentoo.org, linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070623105046.GB12623@spock.one.pl>
References: <20070623105046.GB12623@spock.one.pl>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 16:31:25 +0800
Message-Id: <1184229085.4504.29.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 12:50 +0200, Michal Januszewski wrote:
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

How about..?

	if (!refresh_specified)
		diff = 0;
	else
		diff = refresh;

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
then
					if (diff < db[i].refresh) {
						diff = db[i].refresh;
						best = i;
					}

Tony


