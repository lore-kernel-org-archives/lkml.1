Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbXGMAQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbXGMAQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXGMAQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:16:09 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:32004 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbXGMAQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VsZrgF+UYobmkdEIBVam56iBdpU/ZncVCjzRdufN2l5ZxczS4yeJ02CWFqWUUbafVTIVe3jmkH//D0jrvJKr2jw7kUhoGsn49NDfFpdFD5RsWv3IenxX8XCUBW5Ds48aQkCi2Iq75ihtVOHjf5tjjD4Kq04TYPrZMff9Bs3pVzY=
Subject: Re: [patch 2/4] fbdev: Add fb_append_extra_logo()
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <20070710123540.678435000@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
	 <20070710123540.678435000@pademelon.sonytel.be>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 08:15:57 +0800
Message-Id: <1184285757.4566.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 14:27 +0200, Geert Uytterhoeven wrote:
> plain text document attachment (spe-logo)
> Add fb_append_extra_logo(), to append extra lines of logos below the standard
> Linux logo.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> Acked-By: James Simmons <jsimmons@infradead.org>
> ---
>  drivers/video/fbmem.c      |   50 +++++++++++++++++++++++++++++++++++++++++----
>  include/linux/linux_logo.h |    8 +++++++
>  2 files changed, 54 insertions(+), 4 deletions(-)
> 
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -318,6 +318,13 @@ static struct logo_data {
>  	const struct linux_logo *logo;
>  } fb_logo __read_mostly;
>  
> +#define FB_LOGO_EX_NUM_MAX 10
> +static struct logo_data_extra {
> +	const struct linux_logo *logo;
> +	unsigned int n;
> +} fb_logo_ex[FB_LOGO_EX_NUM_MAX];
> +static unsigned int fb_logo_ex_num;
> +
>  static void fb_rotate_logo_ud(const u8 *in, u8 *out, u32 width, u32 height)
>  {
>  	u32 size = width * height, i;
> @@ -411,10 +418,22 @@ static void fb_do_show_logo(struct fb_in
>  	}
>  }
>  
> +#ifdef CONFIG_FB

The #ifdef is redundant.

> +void fb_append_extra_logo(const struct linux_logo *logo, unsigned int n)
> +{
> +	if (!n || fb_logo_ex_num == FB_LOGO_EX_NUM_MAX)
> +		return;
> +
> +	fb_logo_ex[fb_logo_ex_num].logo = logo;
> +	fb_logo_ex[fb_logo_ex_num].n = n;
> +	fb_logo_ex_num++;
> +}
> +#endif
> +
>  int fb_prepare_logo(struct fb_info *info, int rotate)
>  {
>  	int depth = fb_get_color_depth(&info->var, &info->fix);
> -	int yres;
> +	unsigned int yres, height, i;
>  
>  	memset(&fb_logo, 0, sizeof(struct logo_data));
>  
> @@ -474,7 +493,21 @@ int fb_prepare_logo(struct fb_info *info
>  		fb_logo.depth = 4;
>  	else
>  		fb_logo.depth = 1;		
> -	return fb_logo.logo->height;
> +
> +	/* FIXME: logo_ex supports only truecolor fb. */
> +	if (info->fix.visual != FB_VISUAL_TRUECOLOR)
> +		fb_logo_ex_num = 0;
> +
> +	height = fb_logo.logo->height;
> +	for (i = 0; i < fb_logo_ex_num; i++) {
> +		height += fb_logo_ex[i].logo->height;
> +		if (height > yres) {
> +			height -= fb_logo_ex[i].logo->height;
> +			fb_logo_ex_num = i;
> +			break;
> +		}
> +	}
> +	return height;
>  }
>  
>  static int fb_show_logo_line(struct fb_info *info, int rotate,
> @@ -547,8 +580,17 @@ static int fb_show_logo_line(struct fb_i
>  
>  int fb_show_logo(struct fb_info *info, int rotate)
>  {
> -	return fb_show_logo_line(info, rotate, fb_logo.logo, 0,
> -				 num_online_cpus());
> +	int y, i;
> +
> +	y = fb_show_logo_line(info, rotate, fb_logo.logo, 0,
> +			      num_online_cpus());
> +
> +	for (i = 0; i < fb_logo_ex_num; i++) {
> +		y += fb_show_logo_line(info, rotate,
> +				       fb_logo_ex[i].logo, y, fb_logo_ex[i].n);
> +	}
> +
> +	return y;
>  }
>  #else
>  int fb_prepare_logo(struct fb_info *info, int rotate) { return 0; }
> --- a/include/linux/linux_logo.h
> +++ b/include/linux/linux_logo.h
> @@ -33,5 +33,13 @@ struct linux_logo {
>  };
>  
>  extern const struct linux_logo *fb_find_logo(int depth);
> +#if defined(CONFIG_LOGO) && defined(CONFIG_FB)

The CONFIG_LOGO is also probably redundant, but that's arguable.

Tony


