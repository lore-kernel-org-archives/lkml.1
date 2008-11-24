Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYKXKfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYKXKfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYKXKfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:35:25 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:35496 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbYKXKfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:35:22 -0500
Date: Mon, 24 Nov 2008 11:37:55 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Switch WM8350 revision detection to a feature
	based model
Message-ID: <20081124103755.GA3479@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1227113220-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227113220-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Nov 19, 2008 at 04:46:59PM +0000, Mark Brown wrote:
> Rather than check for chip revisions in the WM8350 drivers have the core
> code set flags for relevant differences.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-core.c         |   14 ++++++--------
>  drivers/power/wm8350_power.c      |    2 +-
>  include/linux/mfd/wm8350/core.h   |    8 --------
>  include/linux/mfd/wm8350/supply.h |    2 ++
>  4 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index 3f2a68d..84fc90e 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1238,21 +1238,19 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
>  
>  	if (id1 == 0x6143) {
>  		switch ((id2 & WM8350_CHIP_REV_MASK) >> 12) {
> -		case WM8350_REV_E:
> +		case 0x4:
Dont you prefer to use the WM8350_REV_* values in your code rather than some
undocumented constants like that ?
I understand that reading the code below will make those constants obvious,
but still...

Cheers,
Samuel.



>  			dev_info(wm8350->dev, "Found Rev E device\n");
> -			wm8350->rev = WM8350_REV_E;
>  			break;
> -		case WM8350_REV_F:
> +		case 0x5:
>  			dev_info(wm8350->dev, "Found Rev F device\n");
> -			wm8350->rev = WM8350_REV_F;
>  			break;
> -		case WM8350_REV_G:
> +		case 0x6:
>  			dev_info(wm8350->dev, "Found Rev G device\n");
> -			wm8350->rev = WM8350_REV_G;
> +			wm8350->power.rev_g_coeff = 1;
>  			break;
> -		case WM8350_REV_H:
> +		case 0x7:
>  			dev_info(wm8350->dev, "Found Rev H device\n");
> -			wm8350->rev = WM8350_REV_H;
> +			wm8350->power.rev_g_coeff = 1;
>  			break;
>  		default:
>  			/* For safety we refuse to run on unknown hardware */
> diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
> index 9c0a847..74e7593 100644
> --- a/drivers/power/wm8350_power.c
> +++ b/drivers/power/wm8350_power.c
> @@ -44,7 +44,7 @@ static int wm8350_read_usb_uvolts(struct wm8350 *wm8350)
>  
>  static inline int wm8350_charge_time_min(struct wm8350 *wm8350, int min)
>  {
> -	if (wm8350->rev < WM8350_REV_G)
> +	if (!wm8350->power.rev_g_coeff)
>  		return (((min - 30) / 15) & 0xf) << 8;
>  	else
>  		return (((min - 30) / 30) & 0xf) << 8;
> diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
> index d2614df..8563408 100644
> --- a/include/linux/mfd/wm8350/core.h
> +++ b/include/linux/mfd/wm8350/core.h
> @@ -558,12 +558,6 @@
>  #define WM8350_IRQ_WKUP_ONKEY			48
>  #define WM8350_IRQ_WKUP_GP_WAKEUP		49
>  
> -/* wm8350 chip revisions */
> -#define WM8350_REV_E				0x4
> -#define WM8350_REV_F				0x5
> -#define WM8350_REV_G				0x6
> -#define WM8350_REV_H				0x7
> -
>  #define WM8350_NUM_IRQ				63
>  
>  struct wm8350_reg_access {
> @@ -585,8 +579,6 @@ struct wm8350_irq {
>  };
>  
>  struct wm8350 {
> -	int rev;		/* chip revision */
> -
>  	struct device *dev;
>  
>  	/* device IO */
> diff --git a/include/linux/mfd/wm8350/supply.h b/include/linux/mfd/wm8350/supply.h
> index 7972151..2b94793 100644
> --- a/include/linux/mfd/wm8350/supply.h
> +++ b/include/linux/mfd/wm8350/supply.h
> @@ -127,6 +127,8 @@ struct wm8350_power {
>  	struct power_supply usb;
>  	struct power_supply ac;
>  	struct wm8350_charger_policy *policy;
> +
> +	int rev_g_coeff;
>  };
>  
>  #endif
> -- 
> 1.5.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
