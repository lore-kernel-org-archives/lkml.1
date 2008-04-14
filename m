Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbYDNUec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbYDNUec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYDNUeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:34:24 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:29518 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYDNUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lHdayXwZGHcfoJPiLfh9DI0n72FHWZu2jY9TV7RxOMBYHZpE8y+tNJAH+0CVIK23bg92DzOnwoxqyK2MvuGwy9SXZ0Ui/uvMg7ZUq6gwGL5U5wMh9/Iyrb1SRSu6X9hovpt4VPnOmMf7Oo0Dsy1Aug8TEtqyVAGzb53VpKLnXgU=
Date: Mon, 14 Apr 2008 16:34:13 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 3/3] wm97xx-core: Support use as a wakeup source
Message-ID: <20080414163033.ZZRA012@mailhub.coreip.homeip.net>
References: <20080414173841.GA2213@rakim.wolfsonmicro.main> <1208194775-4293-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1208194775-4293-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1208194775-4293-3-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208194775-4293-3-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Apr 14, 2008 at 06:39:35PM +0100, Mark Brown wrote:
> The PENDOWN signal from the WM97xx touch screen controllers can be used
> to generate a wakeup event when the system is suspended. Provide a new
> machine configuration option 'suspend_mode' allowing machine drivers to
> enable this. If no suspend_mode is provided then the touch panel will be
> powered down when the system is suspended.
> 

Hmm, another unique module option... How about using device_can_wakeup()
infrastructure that we already have. I'm adding David Brownell to CC since
I believe he's doing a lot of similar work.

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/input/touchscreen/wm97xx-core.c |   22 ++++++++++++++++++++++
>  include/linux/wm97xx.h                  |    3 +++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
> index fec07c2..e1a1ca0 100644
> --- a/drivers/input/touchscreen/wm97xx-core.c
> +++ b/drivers/input/touchscreen/wm97xx-core.c
> @@ -689,10 +689,32 @@ static int wm97xx_remove(struct device *dev)
>  static int wm97xx_suspend(struct device *dev, pm_message_t state)
>  {
>  	struct wm97xx *wm = dev_get_drvdata(dev);
> +	u16 reg;
> +	int suspend_mode;
> +
> +	if (wm->mach_ops)
> +		suspend_mode = wm->mach_ops->suspend_mode;
> +	else
> +		suspend_mode = 0;
>  
>  	if (wm->input_dev->users)
>  		cancel_delayed_work_sync(&wm->ts_reader);
>  
> +	/* Power down the digitiser (bypassing the cache for resume) */
> +	reg = wm97xx_reg_read(wm, AC97_WM97XX_DIGITISER2);
> +	reg &= ~WM97XX_PRP_DET_DIG;
> +	if (wm->input_dev->users && suspend_mode)
> +		reg |= suspend_mode;
> +	wm->ac97->bus->ops->write(wm->ac97, AC97_WM97XX_DIGITISER2, reg);
> +
> +	/* WM9713 has an additional power bit - turn it off if there
> +	 * are no users or if suspend mode is zero. */
> +	if (wm->id == WM9713_ID2 &&
> +	    (!wm->input_dev->users || !suspend_mode)) {
> +		reg = wm97xx_reg_read(wm, AC97_EXTENDED_MID) | 0x8000;
> +		wm97xx_reg_write(wm, AC97_EXTENDED_MID, reg);
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/wm97xx.h b/include/linux/wm97xx.h
> index ed01c7d..2082833 100644
> --- a/include/linux/wm97xx.h
> +++ b/include/linux/wm97xx.h
> @@ -258,6 +258,9 @@ struct wm97xx_mach_ops {
>  	/* pre and post sample - can be used to minimise any analog noise */
>  	void (*pre_sample) (int);  /* function to run before sampling */
>  	void (*post_sample) (int);  /* function to run after sampling */
> +
> +	/* WM97XX_PRP value to configure while system is suspended */
> +	u16 suspend_mode;
>  };
>  
>  struct wm97xx {
> -- 
> 1.5.5
> 

-- 
Dmitry
