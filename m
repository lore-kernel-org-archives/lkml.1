Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYKRKwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYKRKwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 05:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYKRKwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 05:52:35 -0500
Received: from www.tglx.de ([62.245.132.106]:43885 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYKRKwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:52:33 -0500
Message-ID: <49229E64.2010907@linutronix.de>
Date: Tue, 18 Nov 2008 11:52:20 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] USB/ISP1760: Fix for unaligned exceptions
References: <1227000131-19145-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1227000131-19145-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/usb/host/isp1760-hcd.c |   67 ++++++++++++++++++++++++++++-----------
>  1 files changed, 48 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
> index 8017f1c..00bece2 100644
> --- a/drivers/usb/host/isp1760-hcd.c
> +++ b/drivers/usb/host/isp1760-hcd.c
> @@ -136,12 +136,21 @@ static void priv_read_copy(struct isp1760_hcd *priv, u32 *src,
>  		return;
>  	}
>  
> -	while (len >= 4) {
> -		*src = __raw_readl(dst);
> -		len -= 4;
> -		src++;
> -		dst++;
> -	}
> +	if (unlikely((u32)src & 0x3)) {
> +		while (len >= 4) {
> +			put_unaligned(__raw_readl(dst), src);
> +			len -= 4;
> +			src++;
> +			dst++;
> +		}
> +	} else {
> +		while (len >= 4) {
> +			*src = __raw_readl(dst);
> +			len -= 4;
> +			src++;
> +			dst++;
> +		}
> +	} 
>  
>  	if (!len)
>  		return;
> @@ -159,25 +168,45 @@ static void priv_read_copy(struct isp1760_hcd *priv, u32 *src,
>  		len--;
>  		buff8++;
>  	}
> +
>  }
>  
>  static void priv_write_copy(const struct isp1760_hcd *priv, const u32 *src,
>  		__u32 __iomem *dst, u32 len)
>  {
> -	while (len >= 4) {
> -		__raw_writel(*src, dst);
> -		len -= 4;
> -		src++;
> -		dst++;
> -	}
>  
> -	if (!len)
> -		return;
> -	/* in case we have 3, 2 or 1 by left. The buffer is allocated and the
> -	 * extra bytes should not be read by the HW
> -	 */
> -
> -	__raw_writel(*src, dst);
The link [1] you sent me reports an unaligned access which occurred here. 
So I thing the access to *src should be either a get_unaligned helper or a 
byte read loop like I did it in the read path.
The r8a66597 is doing the same thing (as you suggest) for one SH machine. 
However, I'm not convinced to fix it that way: The buffer should be 
properly aligned by the driver. Unless there is HW which requires 
unaligned data, I would prefer just to fix this unaligned access. 
According to the thread in [1] a similar patch fixed it for the user until 
he dropped into another bug.

> +	if (unlikely((u32)src & 0x3)) {
> +		while (len >= 4) {
> +			__raw_writel(get_unaligned(src), dst);
> +			len -= 4;
> +			src++;
> +			dst++;
> +		}
> +	
> +		if (!len)
> +			return;
> +		/* in case we have 3, 2 or 1 by left. The buffer is allocated and the
> +		 * extra bytes should not be read by the HW
> +		 */
> +	
> +		__raw_writel(get_unaligned(src), dst);
> +	
> +	} else{
> +		while (len >= 4) {
> +			__raw_writel(*src, dst);
> +			len -= 4;
> +			src++;
> +			dst++;
> +		}
> +	
> +		if (!len)
> +			return;
> +		/* in case we have 3, 2 or 1 by left. The buffer is allocated and the
> +		 * extra bytes should not be read by the HW
> +		 */
> +	
> +		__raw_writel(*src, dst);	
> +	}
>  }
>  
>  /* memory management of the 60kb on the chip from 0x1000 to 0xffff */

[1] 
http://blackfin.uclinux.org/gf/project/uclinux-dist/forum/?action=ForumBrowse&_forum_action=MessageReply&message_id=64889

Sebastian
