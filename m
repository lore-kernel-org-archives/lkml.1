Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0CESKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:10:14 -0500
Received: from mga10.intel.com ([192.55.52.92]:32065 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754199Ab0CESKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:10:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,588,1262592000"; 
   d="scan'208";a="546456520"
Date: Fri, 5 Mar 2010 19:11:17 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Subject: Re: sch_gpio: fix compilation warning "ignoring return value of
 gpiochip_remove"
Message-ID: <20100305181117.GA5615@sortiz.org>
References: <20100303162252.e7cf0e43.sfr@canb.auug.org.au>
 <4B8E2CE9.3050001@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8E2CE9.3050001@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Wed, Mar 03, 2010 at 11:33:29AM +0200, Denis Turischev wrote:
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
I modified this patch as you were leaking some resources releasing.

Cheers,
Samuel.

> ---
>  drivers/gpio/sch_gpio.c |   25 +++++++++++++++++++++----
>  1 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpio/sch_gpio.c b/drivers/gpio/sch_gpio.c
> index 761071a..a89c02d 100644
> --- a/drivers/gpio/sch_gpio.c
> +++ b/drivers/gpio/sch_gpio.c
> @@ -229,7 +229,12 @@ static int __devinit sch_gpio_probe(struct platform_device *pdev)
>  	return 0;
> 
>  err_sch_gpio_resume:
> -	gpiochip_remove(&sch_gpio_core);
> +	err = gpiochip_remove(&sch_gpio_core);
> +	if (err) {
> +		dev_err(&pdev->dev, "%s failed, %d\n",
> +				"gpiochip_remove()", err);
> +		return err;
> +	}
> 
>  err_sch_gpio_core:
>  	release_region(res->start, resource_size(res));
> @@ -240,11 +245,23 @@ err_sch_gpio_core:
> 
>  static int __devexit sch_gpio_remove(struct platform_device *pdev)
>  {
> +	int err_c, err_r;
>  	struct resource *res;
>  	if (gpio_ba) {
> -		gpiochip_remove(&sch_gpio_core);
> -		gpiochip_remove(&sch_gpio_resume);
> -
> +		err_c = gpiochip_remove(&sch_gpio_core);
> +		
> +		err_r = gpiochip_remove(&sch_gpio_resume);
> +
> +		if (err_c) {
> +			dev_err(&pdev->dev, "%s failed, %d\n",
> +					"gpiochip_remove()", err_c);
> +			return err_c;
> +		}
> +		if (err_r) {
> +			dev_err(&pdev->dev, "%s failed, %d\n",
> +					"gpiochip_remove()", err_r);
> +			return err_r;
> +		}
>  		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> 
>  		release_region(res->start, resource_size(res));
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
