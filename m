Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0BOPg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:36:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0BOPg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:36:56 -0500
Message-ID: <4B796A03.5060909@redhat.com>
Date: Mon, 15 Feb 2010 10:36:35 -0500
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0b2pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@redhat.com>, Huang Ying <ying.huang@intel.com>,
       linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alex Zhavnerchik <alex.vizor@gmail.com>
Subject: Re: [PATCH] efifb: fix framebuffer handoff
References: <20100213104148.GB2880@joi.lan>
In-Reply-To: <20100213104148.GB2880@joi.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 05:41 AM, Marcin Slusarz wrote:
> Commit 4410f3910947dcea8672280b3adecd53cec4e85e
> (fbdev: add support for handoff from firmware to hw framebuffers)
> didn't add fb_destroy operation to efifb. Fix it and change
> aperture_size to match size passed to request_mem_region.
> 
> See: http://bugzilla.kernel.org/show_bug.cgi?id=15151
> 
> Reported-by: Alex Zhavnerchik <alex.vizor@gmail.com>
> Tested-by: Alex Zhavnerchik <alex.vizor@gmail.com>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: linux-fbdev@vger.kernel.org
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>

Looks good.

Acked by: Peter Jones <pjones@redhat.com>

> ---
>  drivers/video/efifb.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index eb12182..d25df51 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -161,8 +161,17 @@ static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
>  	return 0;
>  }
>  
> +static void efifb_destroy(struct fb_info *info)
> +{
> +	if (info->screen_base)
> +		iounmap(info->screen_base);
> +	release_mem_region(info->aperture_base, info->aperture_size);
> +	framebuffer_release(info);
> +}
> +
>  static struct fb_ops efifb_ops = {
>  	.owner		= THIS_MODULE,
> +	.fb_destroy	= efifb_destroy,
>  	.fb_setcolreg	= efifb_setcolreg,
>  	.fb_fillrect	= cfb_fillrect,
>  	.fb_copyarea	= cfb_copyarea,
> @@ -281,7 +290,7 @@ static int __init efifb_probe(struct platform_device *dev)
>  	info->par = NULL;
>  
>  	info->aperture_base = efifb_fix.smem_start;
> -	info->aperture_size = size_total;
> +	info->aperture_size = size_remap;
>  
>  	info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
>  	if (!info->screen_base) {


-- 
        Peter

Computer games don't affect kids; I mean if Pac-Man affected us as
kids, we'd all be running around in darkened rooms, munching magic
pills and listening to repetitive electronic music.
		-- Not actually Kristian Wilson, Nintendo, Inc, 1989
