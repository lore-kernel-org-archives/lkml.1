Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbZDQQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbZDQQdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZDQQd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:33:29 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:8354 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZDQQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:33:28 -0400
Date: Fri, 17 Apr 2009 18:36:17 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: spock@gentoo.org
Cc: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: fix fillrect for 24bpp modes
Message-Id: <20090417183617.ed7553cd.krzysztof.h1@poczta.fm>
In-Reply-To: <20090413170954.GA8403@tria>
References: <20090413170954.GA8403@tria>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: f8e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 19:09:54 +0200
Michal Januszewski <spock@gentoo.org> wrote:

> The software fillrect routines do not work properly when the number of
> pixels per machine word is not an integer.  To see that, run the following
> command on a fbdev console with a 24bpp video mode, using a non-accelerated
> driver such as (u)vesafb:
> 
>   reset ; echo -e '\e[41mtest\e[K'
> 
> The expected result is 'test' displayed on a line with red background.
> Instead of that, 'test' has a red background, but the rest of the line
> (rendered using fillrect()) contains a distored colorful pattern.
> 
> This patch fixes the problem by correctly computing rotation shifts.
> It has been tested in a 24bpp mode on 32- and 64-bit little-endian
> machines.
> 

I can confirm the patch fixes the issue it describes if the line is not padded
or padded in a special way. See my comments below.

> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> ---
> diff --git a/drivers/video/cfbfillrect.c b/drivers/video/cfbfillrect.c
> index 64b3576..396e676 100644
> --- a/drivers/video/cfbfillrect.c
> +++ b/drivers/video/cfbfillrect.c
> @@ -9,10 +9,6 @@
>   *
>   * NOTES:
>   *
> - *  The code for depths like 24 that don't have integer number of pixels per
> - *  long is broken and needs to be fixed. For now I turned these types of
> - *  mode off.
> - *
>   *  Also need to add code to deal with cards endians that are different than
>   *  the native cpu endians. I also need to deal with MSB position in the word.
>   *
> @@ -139,7 +135,7 @@ bitfill_unaligned(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
>  
>  		// Trailing bits
>  		if (last)
> -			FB_WRITEL(comp(pat, FB_READL(dst), first), dst);
> +			FB_WRITEL(comp(pat, FB_READL(dst), last), dst);
>  	}
>  }
>  
> @@ -297,7 +293,7 @@ void cfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
>  	else
>  		fg = rect->color;
>  
> -	pat = pixel_to_pat( bpp, fg);
> +	pat = pixel_to_pat(bpp, fg);
>  
>  	dst = (unsigned long __iomem *)((unsigned long)p->screen_base & ~(bytes-1));
>  	dst_idx = ((unsigned long)p->screen_base & (bytes - 1))*8;
> @@ -333,17 +329,20 @@ void cfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
>  			dst_idx += p->fix.line_length*8;
>  		}
>  	} else {
> -		int right;
> -		int r;
> -		int rot = (left-dst_idx) % bpp;
> +		int right, r;
>  		void (*fill_op)(struct fb_info *p, unsigned long __iomem *dst,
>  				int dst_idx, unsigned long pat, int left,
>  				int right, unsigned n, int bits) = NULL;
> -
> +#ifdef __LITTLE_ENDIAN
> +		right = left;
> +		left = bpp - right;
> +#else
> +		right = bpp - left;
> +#endif
>  		/* rotate pattern to correct start position */
> -		pat = pat << rot | pat >> (bpp-rot);
> +		r = dst_idx >> (ffs(bits) - 1);

The r is simply dst_idx / bits. Most compilers will optimize it away into 
a simple shift because the bits has only one bit set (it is number of bits in a long variable, ie. 32 or 64).

> +		pat = pat << ((left*r) % bpp) | pat >> ((right*r) % bpp);
>  

If the r = (dst_idx / bits) it is number of long words. The shift by ((left*r) % bpp) does
not make much sense (try left = 3 and r = 24 words - it is always zero but should be 3). 
It is even worse if a line is padded so line's length modulo bpp is not 
zero it does not work. A colorful pattern is produced  after the "mtest" text.

A dst_idx offset is not taken into account (it could be non-zero only for depths < 8 bits).

Kind regards,
Krzysztof


----------------------------------------------------------------------
Najlepsze dzwonki MP3 na telefon komorkowy!
Sprawdz >> http://link.interia.pl/f2128  

