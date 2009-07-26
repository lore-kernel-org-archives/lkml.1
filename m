Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZGZOht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZGZOht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 10:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZGZOht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 10:37:49 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:33528 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZGZOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 10:37:48 -0400
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jul 2009 10:37:48 EDT
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Arnaud Faucher <arnaud.faucher@gmail.com>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Date: Sun, 26 Jul 2009 15:23:29 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       Manuel Lauss <manuel.lauss@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com> <200907252204.44875.rjw@sisk.pl> <1248616413.3922.7.camel@green>
In-Reply-To: <1248616413.3922.7.camel@green>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907261523.30378.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sun, 26 Jul 2009 14:23:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Removing linux-mips from CC - I don't know why they'd be interested in an x86 
only platform driver...]

On Sunday 26 July 2009 14:53:33 Arnaud Faucher wrote:
> Gets rid of the following warning:
> Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
>
> Take 2, thanks to Dmitry, Rafael and Frans for pointing out PM issue on
> hibernation when using dev_pm_ops blindly.
>
> This patch was tested against suspendand hibernation (Acer mail led
> status).
>
> Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> ---
>  drivers/platform/x86/acer-wmi.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/platform/x86/acer-wmi.c
> b/drivers/platform/x86/acer-wmi.c
> index be2fd6f..29374bc 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
> platform_device *device)
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
> @@ -1190,15 +1189,23 @@ static int acer_platform_resume(struct
> platform_device *device)
>  	return 0;
>  }
>
> +static struct dev_pm_ops acer_platform_pm_ops = {
> +	.suspend = acer_platform_suspend,
> +	.resume = acer_platform_resume,

Are these necessary? For suspend-to-RAM, I've never needed these. The old 
callbacks here were just for suspend-to-disk.

> +	.freeze = acer_platform_suspend,
> +	.thaw = acer_platform_resume,

If we only need these callbacks for freeze & thaw, they should be rebamed.

> +	.poweroff = acer_platform_suspend,
> +	.restore = acer_platform_resume,

What do poweroff and restore mean in this context. Do my comments above apply 
again (i.e. are the callbacks necessary here)?

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

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
