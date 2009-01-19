Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZASHz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZASHz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 02:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZASHzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 02:55:19 -0500
Received: from cmpxchg.org ([85.214.51.133]:41112 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZASHzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 02:55:18 -0500
Date: Mon, 19 Jan 2009 08:54:41 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbmem: fix copy_from/to_user() with mutex held
Message-ID: <20090119075440.GA1500@cmpxchg.org>
References: <20090117231925.GA28055@redhat.com> <20090118020038.GA17489@cmpxchg.org> <49738E4B.1030200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49738E4B.1030200@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 18, 2009 at 09:17:15PM +0100, Andrea Righi wrote:
> Avoid to call copy_from/to_user() with fb_info->lock mutex held in fbmem
> fb_ioctl().
> 
> NOTE: it doesn't push down the fb_info->lock in each driver's fb_ioctl().
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>

This should probably also include an explanation for WHY doing uaccess
under fb_info->lock is verboten.  Perhaps even a comment because I
don't think it is obvious from the code.

> ---
>  drivers/video/fbcmap.c |   21 +++++--
>  drivers/video/fbmem.c  |  158 ++++++++++++++++++++++++++++--------------------
>  include/linux/fb.h     |    5 +-
>  3 files changed, 112 insertions(+), 72 deletions(-)
> 
> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index 91b78e6..b19f12c 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -250,10 +250,6 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>  	int rc, size = cmap->len * sizeof(u16);
>  	struct fb_cmap umap;
>  
> -	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> -			        !info->fbops->fb_setcmap))
> -		return -EINVAL;
> -
>  	memset(&umap, 0, sizeof(struct fb_cmap));
>  	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
>  	if (rc)
> @@ -262,11 +258,24 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>  	    copy_from_user(umap.green, cmap->green, size) ||
>  	    copy_from_user(umap.blue, cmap->blue, size) ||
>  	    (cmap->transp && copy_from_user(umap.transp, cmap->transp, size))) {
> -		fb_dealloc_cmap(&umap);
> -		return -EFAULT;
> +		rc = -EFAULT;
> +		goto out;
>  	}
>  	umap.start = cmap->start;
> +	info = get_fb_info(info);
> +	if (!info) {
> +		rc = -ENODEV;
> +		goto out;
> +	}
> +	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> +				!info->fbops->fb_setcmap)) {
> +		rc = -EINVAL;
> +		goto out1;
> +	}
>  	rc = fb_set_cmap(&umap, info);
> +out1:
> +	put_fb_info(info);
> +out:
>  	fb_dealloc_cmap(&umap);
>  	return rc;
>  }
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 756efeb..e51e9ba 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1006,6 +1006,23 @@ fb_blank(struct fb_info *info, int blank)
>   	return ret;
>  }
>  
> +struct fb_info *get_fb_info(struct fb_info *info)
> +__acquires(&info->lock)
> +{
> +	mutex_lock(&info->lock);
> +	if (!info->fbops) {
> +		mutex_unlock(&info->lock);
> +		return NULL;
> +	}
> +	return info;
> +}
> +
> +void put_fb_info(struct fb_info *info)
> +__releases(&info->lock)
> +{
> +	mutex_unlock(&info->lock);
> +}
> +
>  static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>  			unsigned long arg)
>  {
> @@ -1013,25 +1030,28 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>  	struct fb_var_screeninfo var;
>  	struct fb_fix_screeninfo fix;
>  	struct fb_con2fbmap con2fb;
> +	struct fb_cmap cmap_from;
>  	struct fb_cmap_user cmap;
>  	struct fb_event event;
>  	void __user *argp = (void __user *)arg;
>  	long ret = 0;
>  
> -	fb = info->fbops;
> -	if (!fb)
> -		return -ENODEV;
> -
>  	switch (cmd) {
>  	case FBIOGET_VSCREENINFO:
> -		ret = copy_to_user(argp, &info->var,
> -				    sizeof(var)) ? -EFAULT : 0;
> +		info = get_fb_info(info);
> +		if (!info)
> +			return -ENODEV;
> +		memcpy(&var, &info->var, sizeof(var));

You don't need these memcpy()s:

		var = info->var

does the same much more readable.

Thanks,
	hannes
