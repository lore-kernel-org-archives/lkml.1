Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZD2EPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZD2EPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZD2EP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:15:26 -0400
Received: from kroah.org ([198.145.64.141]:34909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZD2EP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:15:26 -0400
Date: Tue, 28 Apr 2009 21:08:11 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>, Ming Lei <tom.leiming@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.30-rc3] platform_bus:  remove "which
	platform_data?" confusion
Message-ID: <20090429040810.GI23062@kroah.com>
References: <200904271943.40588.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271943.40588.david-b@pacbell.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 07:43:40PM -0700, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Recent patches have caused platform_device_add_pdata() users
> to trigger confused "use which platform_data?" error messages
> from the kernel.  ("The _only_ one you were given, dummy!" is
> the correct answer.)
> 
> This patch fixes those messages so they only appear if there's
> reason to be confused.  (The call should probably fail too...)
> 
> Those patches seem to support what I think is a misguided
> notion:  that somehow device.platform_data might move into
> the platform_device.  The problem with that idea is that it's
> a general purpose hook, and is used by other busses to provide
> board-specific configuration data ... not just for platform_bus.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---

Ming, what do you think of this?

thanks,

greg k-h


> For 2.6.30, which recently acquired this confusion.
> 
>  drivers/base/platform.c |   22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -251,16 +251,20 @@ int platform_device_add(struct platform_
>  	* if all platform devices pass its platform specific data
>  	* from platform_device. The conversion is going to be a
>  	* long time, so we allow the two cases coexist to make
> -	* this kind of fix more easily*/
> -	if (pdev->platform_data && pdev->dev.platform_data) {
> -		printk(KERN_ERR
> -			       "%s: use which platform_data?\n",
> -			       dev_name(&pdev->dev));
> -	} else if (pdev->platform_data) {
> -		pdev->dev.platform_data = pdev->platform_data;
> -	} else if (pdev->dev.platform_data) {
> +	* this kind of fix more easily
> +	*
> +	* REVISIT platform_data is used by more than "platform_bus".
> +	* It's a generic hook for data that's specific to a given
> +	* board.  Removing it seems rather impractical...
> +	*/
> +	if (!pdev->platform_data)
>  		pdev->platform_data = pdev->dev.platform_data;
> -	}
> +	else if (!pdev->dev.platform_data)
> +		pdev->dev.platform_data = pdev->platform_data;
> +
> +	if (pdev->platform_data != pdev->dev.platform_data)
> +		pr_err("%s: use which platform_data?\n",
> +			       dev_name(&pdev->dev));
>  
>  	for (i = 0; i < pdev->num_resources; i++) {
>  		struct resource *p, *r = &pdev->resource[i];
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
