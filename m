Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbZKCW70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbZKCW70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZKCW7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:59:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbZKCW7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:59:25 -0500
Date: Tue, 3 Nov 2009 14:59:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: Wrong test on unsigned in fb_set_user_cmap()?
Message-Id: <20091103145914.84094e8e.akpm@linux-foundation.org>
In-Reply-To: <4ADE0FDE.5070101@gmail.com>
References: <4ADE0FDE.5070101@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 21:30:38 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> struct fb_cmap_user member start is unsigned.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this required?
> 
> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index f53b9f1..f46f05f 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -266,7 +266,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>  		rc = -ENODEV;
>  		goto out;
>  	}
> -	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> +	if ((int)cmap->start < 0 || (!info->fbops->fb_setcolreg &&
>  				!info->fbops->fb_setcmap)) {
>  		rc = -EINVAL;
>  		goto out1;

I think the test _is_ needed, as `start' is passed in direct from
userspace, via do_fb_ioctl():FBIOPUTCMAP.

However fb_set_user_cmap() calls fb_set_cmap() which also checks
`start', only this time it does it correctly.

So overall the code is OK and the check which you've identified
is unneeded.

In fact, all of

	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
				!info->fbops->fb_setcmap)) {
		rc = -EINVAL;
		goto out1;
	}

can be removed.
