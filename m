Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZGYRnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZGYRnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 13:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZGYRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 13:43:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:47079 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZGYRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 13:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UowYwpeMwm7QGNYXG3yUYmEzZBRJu/LLpEzUeNFWKPWiF3AyATdk2XLWH2dt1mP+g1
         mgNhmpHXJ7GrxG3bKFjadd01P1EUvrn3KUJXxSg0/0vy0+asSf1lPdz10mcwozZXV9DT
         Aw4PDs6FOT5tfoECsS4YsQk2tozVhenJhpbkA=
Date: Sat, 25 Jul 2009 10:43:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnaud Faucher <arnaud.faucher@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Message-ID: <20090725174311.GB14062@dtor-d630.eng.vmware.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud,

On Sat, Jul 25, 2009 at 09:04:51AM -0400, Arnaud Faucher wrote:
> Gets rid of the following warning:
> Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
> 

Have you tested it with Suspend to disk? You are [potentially] breaking
it since the new suspend and resume methods are not used by it, it calls
freeze() and thaw() instead.

Rafael,

I wonder if PM core should automatically use suspend()/resume() in place of
freeze()/thaw() when the latter pair is missing.

> Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> ---
>  drivers/platform/x86/acer-wmi.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index be2fd6f..b2b6aef 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct platform_device *device)
>  	return 0;
>  }
>  
> -static int acer_platform_suspend(struct platform_device *dev,
> -pm_message_t state)
> +static int acer_platform_suspend(struct device *dev)
>  {
>  	u32 value;
>  	struct acer_data *data = &interface->data;
> @@ -1174,7 +1173,7 @@ pm_message_t state)
>  	return 0;
>  }
>  
> -static int acer_platform_resume(struct platform_device *device)
> +static int acer_platform_resume(struct device *dev)
>  {
>  	struct acer_data *data = &interface->data;
>  
> @@ -1190,15 +1189,19 @@ static int acer_platform_resume(struct platform_device *device)
>  	return 0;
>  }
>  
> +static struct dev_pm_ops acer_platform_pm_ops = {
> +	.suspend = acer_platform_suspend,
> +	.resume = acer_platform_resume,
> +};
> +
>  static struct platform_driver acer_platform_driver = {
>  	.driver = {
>  		.name = "acer-wmi",
>  		.owner = THIS_MODULE,
> +		.pm = &acer_platform_pm_ops,
>  	},
>  	.probe = acer_platform_probe,
>  	.remove = acer_platform_remove,
> -	.suspend = acer_platform_suspend,
> -	.resume = acer_platform_resume,
>  };
>  
>  static struct platform_device *acer_platform_device;
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Dmitry
