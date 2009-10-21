Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZJUSaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZJUSaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZJUSap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:30:45 -0400
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:11134 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbZJUSap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:30:45 -0400
Date: Wed, 21 Oct 2009 20:47:22 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: Wrong test on unsigned in
 fb_set_user_cmap()?
Message-Id: <20091021204722.20ccb7a9.krzysztof.h1@poczta.fm>
In-Reply-To: <4ADF2449.7090902@gmail.com>
References: <20091021065018.7625046CCF3@f46.poczta.interia.pl>
	<4ADF2449.7090902@gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: dae2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 17:10:01 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> struct fb_cmap_user member start is unsigned. The same condition
> is already checked in fb_set_cmap(), so this should be safe.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> >> Is this required?
> > 

> 
> > Anyway, the check of the cmap->start < 0 does
> > not make any sense as the start is u32 value (most userspace
> > addresses will be lower then 2GB on 32 bit system so the error cannot
> > be caught by the check). I vote for removing the (cmap->start < 0) in
> > the fb_set_cmap as well as most drivers check the start value already
> > in driver's fb_setcolreg() function.
> 
> In fb_set_cmap() this is not `cmap->start' but `start' which has type
> int. Therefore I think the test makes some sense there, so I left it.
> 

No, it does not. If one converts u32 value to int it must be over 2GB to be negative. 
The value is not in most cases as the user space is mapped below 3GB. On the other hand,
each driver receives unsigned value of the start (converted back to unsigned). It means that the
start here should be unsigned int.
Each driver should check the value it receives. I have checked and there are only 3 drivers 
which do not check properly the start value:
atafb
ep93xxfb
maxinefb

The fixes are very easy.

> > 
> > Best regards,
> > Krzysztof
> 
> Thanks, here:
> 
> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index f53b9f1..f46d617 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -266,11 +266,6 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>  		rc = -ENODEV;
>  		goto out;
>  	}
> -	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> -				!info->fbops->fb_setcmap)) {
> -		rc = -EINVAL;
> -		goto out1;
> -	}
>  	rc = fb_set_cmap(&umap, info);
>  out1:
>  	unlock_fb_info(info);


Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


----------------------------------------------------------------------
Zobacz najlepsze walki Adamka.
Ogladaj >>> http://link.interia.pl/f23e8

