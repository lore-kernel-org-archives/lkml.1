Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbZD0MWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbZD0MWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZD0MVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:21:51 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37229 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZD0MVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iT6eUkHCwrP65b9jJc4i3oGUQC3ktfr/xypDuPO7w+BPma5FAeqCPNSIQsMIJkt9TR
         feFGjvnH+ZaFMW8TQlEB4SU0NA+dl+AdO6CmP43iGzdg0UMhIjV4VW9I+LaSUaojU7JD
         5MlriqjWRpgmdJUydpZe1Ot+D0Bxt/q9PzGNg=
MIME-Version: 1.0
In-Reply-To: <49F59DD9.6010903@gmail.com>
References: <49EDD799.8060607@gmail.com>
	 <20090423134110.51ea8df2.akpm@linux-foundation.org>
	 <20090423214738.GF7134@sci.fi> <49F4519F.4090003@gmail.com>
	 <20090426131505.GG7134@sci.fi> <49F59DD9.6010903@gmail.com>
Date: Mon, 27 Apr 2009 14:21:47 +0200
X-Google-Sender-Auth: 1069d9aca05c3abb
Message-ID: <10f740e80904270521n48b687c5y5b7e2e7bddbad027@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] fbcmap: non working tests on unsigned 
	cmap->start
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 13:58, Roel Kluin <roel.kluin@gmail.com> wrote:
> Ville Syrjälä wrote:
>> On Sun, Apr 26, 2009 at 02:20:47PM +0200, Roel Kluin wrote:
>>> cmap->start is unsigned,
>
>>>> On Thu, Apr 23, 2009 at 01:41:10PM -0700, Andrew Morton wrote:
>>>>> argh.
>>>>>
>>>>> - Perhaps userspace can kill the kernel by sending a "negative"
>>>>>   `start'.  Removing the test will make it even less likely that we'll
>>>>>   fix this bug.
>>>> Shouldn't happen. 'start' is used as the starting index for the hardware
>>>> palette, 'start+len-1' is the last index. All drivers should already check
>>>> the passed values since the maximum index depends on the display mode.
>>>> And I suppose the worst thing that could happen if the driver fails to
>>>> check the values would be incorrect colors.
>
>> You would rather need something like
>> 'if (start+len > 1 << max(red.len, green.len, blue.len, transp.len))'
>
> what do you mean with `red.len'? is that `info->var.red.length'?

That's correct.

>> and a check to make sure that start+len doesn't overflow.
>>
>> Oh and I guess it should also check that the visual is pseudocolor or
>> directcolor.
>
> I am fairly new so please review carefully.
>
> Not yet signed off-by: Roel Kluin <roel.kluin@gmail.com>

Looks OK, thx!

> ---
> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index f53b9f1..b34e74e 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -249,6 +249,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>  {
>        int rc, size = cmap->len * sizeof(u16);
>        struct fb_cmap umap;
> +       __u32 rgba_max = 0;
>
>        memset(&umap, 0, sizeof(struct fb_cmap));
>        rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
> @@ -261,13 +262,27 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>                rc = -EFAULT;
>                goto out;
>        }
> +
> +       if (cmap->start + cmap->len < cmap->start) {
> +               rc = -EINVAL;
> +               goto out;
> +       }
> +
>        umap.start = cmap->start;
>        if (!lock_fb_info(info)) {
>                rc = -ENODEV;
>                goto out;
>        }
> -       if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> -                               !info->fbops->fb_setcmap)) {
> +
> +       rgba_max = max(info->var.red.length, info->var.green.length);
> +       rgba_max = max(rgba_max, info->var.blue.length);
> +       rgba_max = max(rgba_max, info->var.transp.length);
> +
> +       if (cmap->start + cmap->len > 1 << rgba_max ||
> +                       !(info->fbops->fb_setcolreg ||
> +                               info->fbops->fb_setcmap) ||
> +                       !(info->fix.visual == FB_VISUAL_PSEUDOCOLOR ||
> +                               info->fix.visual == FB_VISUAL_TRUECOLOR)) {
>                rc = -EINVAL;
>                goto out1;
>        }
>
> ------------------------------------------------------------------------------
> Crystal Reports &#45; New Free Runtime and 30 Day Trial
> Check out the new simplified licensign option that enables unlimited
> royalty&#45;free distribution of the report engine for externally facing
> server and web deployment.
> http://p.sf.net/sfu/businessobjects
> _______________________________________________
> Linux-fbdev-devel mailing list
> Linux-fbdev-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-fbdev-devel
>



-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
