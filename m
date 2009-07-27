Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZG0JJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZG0JJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZG0JJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:09:28 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:57522 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbZG0JJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:09:27 -0400
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com> <cone.1247683003.40459.21332.1000@deskpiie> <20090723082904.GE3997@dtor-d630.eng.vmware.com> <cone.1248339143.133822.15136.1000@arca> <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com> <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com>
Message-ID: <cone.1248685630.590706.15136.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
Date: Mon, 27 Jul 2009 11:07:10 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

I can't apply this patch, tried different methods to get the patch to ensure 
my mailclient doesn't screw the patch up.

The last one I tried was from:
http://lkml.org/lkml/2009/7/23/106

When patching I'm getting this error:
patch: **** malformed patch at line 15: *dev, pm_message_t state)

Could you please fix and resend the patch? Unfortunatelly can't I test s2d 
as I do have the 8gb ssd version of the acer aspire. But I'll try to use 
a sd-card for s2d, maybe it'll work this way.

kind regards,
--peter


Borislav Petkov writes:

>> Dmitry's right, suspend() and resume() are used only for S2R. Since
>> the only thing we do when suspending/hibernating is set fan speed to
>> auto, we might just as well replicate those functions to .freeze() and
>> .thaw().
> 
> here's a fix:
> 
> --
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Wed, 15 Jul 2009 17:33:32 +0200
> Subject: [PATCH] acerhdf: convert to dev_pm_ops
> 
> v 1.1:
> Add .freeze/.thaw func ptrs to support
> suspend-to-disk, as suggested by Dmitry Torokhov.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/platform/x86/acerhdf.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index aa298d6..8cd7a7b 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -435,7 +435,7 @@ struct thermal_cooling_device_ops acerhdf_cooling_ops = {
>  };
> 
>  /* suspend / resume functionality */
> -static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
> +static int acerhdf_suspend(struct device *dev)
>  {
>  	if (kernelmode)
>  		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
> @@ -446,7 +446,7 @@ static int acerhdf_suspend(struct platform_device
> *dev, pm_message_t state)
>  	return 0;
>  }
> 
> -static int acerhdf_resume(struct platform_device *device)
> +static int acerhdf_resume(struct device *dev)
>  {
>  	if (verbose)
>  		pr_notice("resuming\n");
> @@ -464,15 +464,21 @@ static int acerhdf_remove(struct platform_device *device)
>  	return 0;
>  }
> 
> +static struct dev_pm_ops acerhdf_pm_ops = {
> +	.suspend = acerhdf_suspend,
> +	.resume  = acerhdf_resume,
> +	.freeze  = acerhdf_suspend,
> +	.thaw	 = acerhdf_resume,
> +};
> +
>  static struct platform_driver acerhdf_driver = {
>  	.driver = {
> -		.name = "acerhdf",
> +		.name  = "acerhdf",
>  		.owner = THIS_MODULE,
> +		.pm    = &acerhdf_pm_ops,
>  	},
>  	.probe = acerhdf_probe,
>  	.remove = acerhdf_remove,
> -	.suspend = acerhdf_suspend,
> -	.resume = acerhdf_resume,
>  };
> 
> 
> -- 
> 1.6.3.3
> 
> -- 
> Regards/Gruss,
> Boris
