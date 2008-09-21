Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYIUShX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYIUShX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 14:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYIUShK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 14:37:10 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:20574 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYIUShJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 14:37:09 -0400
Date: Sun, 21 Sep 2008 20:37:57 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] vgacon: optimize scrolling
Message-Id: <20080921203757.455ead71.krzysztof.h1@poczta.fm>
In-Reply-To: <1222012809-5783-2-git-send-email-marcin.slusarz@gmail.com>
References: <1222012809-5783-1-git-send-email-marcin.slusarz@gmail.com>
	<1222012809-5783-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: fae2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2008 18:00:08 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Join multiple scr_memcpyw into 1-3 calls (usually 2).
> (benchmarked average speedup: 1%)
> 

The scr_memcpyw is an inline function so there is no real call here.

However, have you tested the patch with scroll range > 2 *  vgacon_scrollback_size?

It seems that your patch only handles scrolling if it is not bigger than 2 * vgacon_scrollback_size.

Regards,
Krzysztof

> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Antonino Daplas <adaplas@gmail.com>
> Cc: linux-fbdev-devel@lists.sourceforge.net
> ---
>  drivers/video/console/vgacon.c |   28 ++++++++++++++++------------
>  1 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
> index bd1f57b..de4f66c 100644
> --- a/drivers/video/console/vgacon.c
> +++ b/drivers/video/console/vgacon.c
> @@ -292,23 +292,27 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
>  	d = (void *) c->vc_origin;
>  	s = (void *) c->vc_screenbuf;
>  
> -	while (count--) {
> -		scr_memcpyw(d, vgacon_scrollback + soff, c->vc_size_row);
> -		d += c->vc_size_row;
> -		soff += c->vc_size_row;
> -
> -		if (soff >= vgacon_scrollback_size)
> -			soff = 0;
> +	if (count) {
> +		int copysize;
> +		count *= c->vc_size_row;
> +		/* how much memory to end of buffer left? */
> +		copysize = min(count, vgacon_scrollback_size - soff);
> +		scr_memcpyw(d, vgacon_scrollback + soff, copysize);
> +		d += copysize;
> +		count -= copysize;
> +		
> +		if (count) {
> +			copysize = min(count, vgacon_scrollback_size);
> +			scr_memcpyw(d, vgacon_scrollback, copysize);
> +			d += copysize;
> +		}
>  	}
>  
>  	if (diff == c->vc_rows) {
>  		vgacon_cursor(c, CM_MOVE);
>  	} else {
> -		while (diff--) {
> -			scr_memcpyw(d, s, c->vc_size_row);
> -			d += c->vc_size_row;
> -			s += c->vc_size_row;
> -		}
> +		if (diff)
> +			scr_memcpyw(d, s, diff * c->vc_size_row);
>  	}
>  
>  	return 1;
> -- 
> 1.5.6.4
> 
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Linux-fbdev-devel mailing list
> Linux-fbdev-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-fbdev-devel
> 

----------------------------------------------------------------------
Kredyt Hipoteczny w Banku Millennium - zdobywca Zlotego Lauru Klienta!
Sprawdz >> http://link.interia.pl/f1f15

