Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbYJKOP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbYJKOP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYJKOPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:15:48 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:48425 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYJKOPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:15:48 -0400
Date: Sat, 11 Oct 2008 16:18:20 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] mfd: Add WM8350 subdevice registration helper
Message-ID: <20081011141820.GC2712@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1223650696-15552-5-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-6-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-7-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-8-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-9-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-10-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-11-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-12-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-13-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-14-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223650696-15552-14-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 03:58:16PM +0100, Mark Brown wrote:
> Most of the subdevices for the WM8350 code are registered in the same
> fashion so factor out the code to do the initial registration.
Out of curiosity (and also because I would like to start working on improving
mfd-core), why didnt you consider using the mfd-core API ?

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-core.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index 9a1a0b2..cd1f76e 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1130,6 +1130,32 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(wm8350_create_cache);
>  
> +/*
> + * Register a client device.  This is non-fatal since there is no need to
> + * fail the entire device init due to a single platform device failing.
> + */
> +static void wm8350_client_dev_register(struct wm8350 *wm8350,
> +				       const char *name,
> +				       struct platform_device **pdev)
> +{
> +	int ret;
> +
> +	*pdev = platform_device_alloc(name, -1);
> +	if (pdev == NULL) {
> +		dev_err(wm8350->dev, "Failed to allocate %s\n", name);
> +		return;
> +	}
> +
> +	(*pdev)->dev.parent = wm8350->dev;
> +	platform_set_drvdata(*pdev, wm8350);
> +	ret = platform_device_add(*pdev);
> +	if (ret != 0) {
> +		dev_err(wm8350->dev, "Failed to register %s: %d\n", name, ret);
> +		platform_device_put(*pdev);
> +		*pdev = NULL;
> +	}
> +}
> +
>  int wm8350_device_init(struct wm8350 *wm8350, int irq,
>  		       struct wm8350_platform_data *pdata)
>  {
> -- 
> 1.5.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
