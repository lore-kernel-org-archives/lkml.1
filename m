Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbZHAUWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbZHAUWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 16:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZHAUWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 16:22:08 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:39616 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZHAUWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 16:22:07 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 2/5] drivers/media/video/uvc: Use DIV_ROUND_CLOSEST
Date: Sat, 1 Aug 2009 22:23:51 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0908012148420.25693@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0908012148420.25693@ask.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908012223.52022.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 August 2009 21:49:04 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.
>
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @haskernel@
> @@
>
> #include <linux/kernel.h>
>
> @depends on haskernel@
> expression x,__divisor;
> @@
>
> - (((x) + ((__divisor) / 2)) / (__divisor))
> + DIV_ROUND_CLOSEST(x,__divisor)
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  drivers/media/video/uvc/uvc_v4l2.c  |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 87cb9cc..6edaaf6 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -95,7 +95,7 @@ static __u32 uvc_try_frame_interval(struct uvc_frame
> *frame, __u32 interval) const __u32 max = frame->dwFrameInterval[1];
>  		const __u32 step = frame->dwFrameInterval[2];
>
> -		interval = min + (interval - min + step/2) / step * step;
> +		interval = min + DIV_ROUND_CLOSEST(interval-min, step) * step;
>  		if (interval > max)
>  			interval = max;
>  	}

The purpose of the above code is to clamp the interval value to the [min, max] 
range at round it to the closest multiple of step. Other drivers might need 
similar code. Do you think it might be useful to introduce a clamp_step macro 
for this ?

If not,

Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>

Regards,

Laurent Pinchart

