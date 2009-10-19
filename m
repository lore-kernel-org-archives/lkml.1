Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZJSUJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZJSUJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 16:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZJSUJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 16:09:35 -0400
Received: from b.jim.sh ([75.150.123.26]:58069 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757414AbZJSUJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 16:09:34 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 16:09:34 EDT
Date: Mon, 19 Oct 2009 16:03:20 -0400
From: Jim Paris <jim@jtan.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block/ps3: Fix slow VRAM IO
Message-ID: <20091019200320.GA30464@psychosis.jim.sh>
References: <4ADCC4E3.8060104@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADCC4E3.8060104@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geoff Levand wrote:
> 
> From: Hideyuki Sasaki <Hideyuki_Sasaki@hq.scei.sony.co.jp>
> 
> The current PS3 VRAM driver uses msleep() to wait for completion
> of RSX DMA transfers between system memory and VRAM.  Depending
> on the system timing, the processing delay and overhead of this
> msleep() call can significantly impact VRAM driver IO.
> 
> To avoid the condition, add a short duration (200 usec max)
> udelay() polling loop before entering the msleep() polling
> loop.
> 
> Signed-off-by: Hideyuki Sasaki <xhide@rd.scei.sony.co.jp>
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>

Acked-by: Jim Paris <jim@jtan.com>

Thanks for tracking this down.

-jim

> ---
> 
>  drivers/block/ps3vram.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c
> @@ -123,7 +123,15 @@ static int ps3vram_notifier_wait(struct 
>  {
>  	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
>  	u32 *notify = ps3vram_get_notifier(priv->reports, NOTIFIER);
> -	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
> +	unsigned long timeout;
> +
> +	for (timeout = 20; timeout; timeout--) {
> +		if (!notify[3])
> +			return 0;
> +		udelay(10);
> +	}
> +
> +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
>  
>  	do {
>  		if (!notify[3])
