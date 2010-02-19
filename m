Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab0BSLvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:51:05 -0500
Received: from mga07.intel.com ([143.182.124.22]:9957 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750902Ab0BSLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:51:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,502,1262592000"; 
   d="scan'208";a="245802459"
Date: Fri, 19 Feb 2010 12:52:16 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] gpiolib: Actually set output state in
 wm831x_gpio_direction_output()
Message-ID: <20100219115215.GF10255@sortiz.org>
References: <1266429875-4046-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266429875-4046-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Feb 17, 2010 at 06:04:35PM +0000, Mark Brown wrote:
> wm831x_gpio_direction_output() ignored the state passed into it.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@kernel.org
> ---
> 
> Ideally this could make it into 2.6.33, though it's not super critical
> and it's probably reasonable to handle it via the stable releases.
Agreed. I'll push it upstream through my for-next branch, thanks.

Cheers,
Samuel.

>  drivers/gpio/wm831x-gpio.c |   22 +++++++++++++++-------
>  1 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
> index b4468b6..c5a00f7 100644
> --- a/drivers/gpio/wm831x-gpio.c
> +++ b/drivers/gpio/wm831x-gpio.c
> @@ -60,23 +60,31 @@ static int wm831x_gpio_get(struct gpio_chip *chip, unsigned offset)
>  		return 0;
>  }
>  
> -static int wm831x_gpio_direction_out(struct gpio_chip *chip,
> -				     unsigned offset, int value)
> +static void wm831x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>  {
>  	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
>  	struct wm831x *wm831x = wm831x_gpio->wm831x;
>  
> -	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
> -			       WM831X_GPN_DIR | WM831X_GPN_TRI, 0);
> +	wm831x_set_bits(wm831x, WM831X_GPIO_LEVEL, 1 << offset,
> +			value << offset);
>  }
>  
> -static void wm831x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +static int wm831x_gpio_direction_out(struct gpio_chip *chip,
> +				     unsigned offset, int value)
>  {
>  	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
>  	struct wm831x *wm831x = wm831x_gpio->wm831x;
> +	int ret;
>  
> -	wm831x_set_bits(wm831x, WM831X_GPIO_LEVEL, 1 << offset,
> -			value << offset);
> +	ret = wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
> +			      WM831X_GPN_DIR | WM831X_GPN_TRI, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Can only set GPIO state once it's in output mode */
> +	wm831x_gpio_set(chip, offset, value);
> +
> +	return 0;
>  }
>  
>  static int wm831x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> -- 
> 1.6.6.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
