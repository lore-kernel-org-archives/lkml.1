Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYBZISS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYBZISS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYBZISH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:18:07 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:60846 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbYBZISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:18:06 -0500
Date: Tue, 26 Feb 2008 09:18:03 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: [PATCH] fbcon: replace mono_col macro with static inline
In-Reply-To: <1203963237.5582.4.camel@brick>
Message-ID: <Pine.LNX.4.64.0802260917410.5158@anakin>
References: <1203963237.5582.4.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Harvey Harrison wrote:
> Use __u32 for max_len to match the declaration of length in the
> struct fb_bitfield.
> 
> Suppresses sparse shadowed variable warnings from the nested max()
> macros:
> drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
> drivers/video/console/fbcon.h:130:8: originally declared here
> drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
> drivers/video/console/fbcon.h:130:8: originally declared here
> drivers/video/console/fbcon.h:130:8: warning: symbol '_y' shadows an earlier one
> drivers/video/console/fbcon.h:130:8: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/video/console/fbcon.h |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
> index 3706307..51a6bf4 100644
> --- a/drivers/video/console/fbcon.h
> +++ b/drivers/video/console/fbcon.h
> @@ -104,10 +104,14 @@ struct fbcon_ops {
>  #define attr_blink(s) \
>  	((s) & 0x8000)
>  	
> -#define mono_col(info)							\
> -	(~(0xfff << (max((info)->var.green.length,			\
> -			 max((info)->var.red.length,			\
> -			     (info)->var.blue.length)))) & 0xff)
> +
> +static inline int mono_col(struct fb_info *info)
                              ^^^^^^^^^^^^^^^^^^^^
const struct fb_info *info?

> +{
> +	__u32 max_len;
> +	max_len = max(info->var.green.length, info->var.red.length);
> +	max_len = max(info->var.blue.length, max_len);
> +	return ~(0xfff << (max_len & 0xff));
> +}
>  
>  static inline int attr_col_ec(int shift, struct vc_data *vc,
>  			      struct fb_info *info, int is_fg)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
