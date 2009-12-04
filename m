Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZLDJX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZLDJX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZLDJX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:23:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35435 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbZLDJXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:23:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eAK0LZ9XF76mfT/fG0BIOhvAGuJODo8Jxmqd1Vt3jlbjtkDOnW4H4R5zo4xOuCvXuV
         dKuWHjujVCIKyCzg0bFOCratFuDVzRPl/pbTBY1QRz9weW3CoEdxw+3yima3KkTqo3ls
         dpDpBJxahBo9tcjzQHAWV+hT3GLH301+rvEEg=
MIME-Version: 1.0
In-Reply-To: <1259744920.25505.2.camel@eight.analog.com>
References: <1259744920.25505.2.camel@eight.analog.com>
Date: Fri, 4 Dec 2009 17:24:00 +0800
Message-ID: <4e5ebad50912040124i35e8c8c7iba71737c966c26ea@mail.gmail.com>
Subject: Re: [PATCH] driver i2c-core: i2c bus should support PM entries in 
	struct dev_pm_ops.
From: Sonic Zhang <sonic.adi@gmail.com>
To: khali@linux-fr.org
Cc: linux-i2c@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments?

Thanks.

Sonic

On Wed, Dec 2, 2009 at 5:08 PM, sonic zhang <sonic.adi@gmail.com> wrote:
> Struct dev_pm_ops is not configured in current i2c bus type. i2c drivers
> only depends on suspend/resume entries in struct dev_pm_ops are not
> informed of PM suspend and resume events by i2c framework.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/i2c/i2c-core.c |   39 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 2965043..9713c0d 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -155,6 +155,39 @@ static void i2c_device_shutdown(struct device *dev)
>                driver->shutdown(client);
>  }
>
> +#ifdef CONFIG_SUSPEND
> +static int i2c_device_pm_suspend(struct device *dev)
> +{
> +       struct i2c_driver *driver;
> +       struct dev_pm_ops *pm;
> +
> +       if (!dev->driver)
> +               return 0;
> +       driver = to_i2c_driver(dev->driver);
> +       pm = driver->driver.pm;
> +       if (!pm || !pm->suspend)
> +               return 0;
> +       return pm->suspend(dev);
> +}
> +
> +static int i2c_device_pm_resume(struct device *dev)
> +{
> +       struct i2c_driver *driver;
> +       struct dev_pm_ops *pm;
> +
> +       if (!dev->driver)
> +               return 0;
> +       driver = to_i2c_driver(dev->driver);
> +       pm = driver->driver.pm;
> +       if (!pm || !pm->resume)
> +               return 0;
> +       return pm->resume(dev);
> +}
> +#else
> +# define i2c_device_pm_suspend NULL
> +# define i2c_device_pm_resume  NULL
> +#endif
> +
>  static int i2c_device_suspend(struct device *dev, pm_message_t mesg)
>  {
>        struct i2c_client *client = i2c_verify_client(dev);
> @@ -219,6 +252,11 @@ static const struct attribute_group *i2c_dev_attr_groups[] = {
>        NULL
>  };
>
> +static struct dev_pm_ops i2c_device_pm_ops = {
> +       .suspend = i2c_device_pm_suspend,
> +       .resume = i2c_device_pm_resume,
> +};
> +
>  struct bus_type i2c_bus_type = {
>        .name           = "i2c",
>        .match          = i2c_device_match,
> @@ -227,6 +265,7 @@ struct bus_type i2c_bus_type = {
>        .shutdown       = i2c_device_shutdown,
>        .suspend        = i2c_device_suspend,
>        .resume         = i2c_device_resume,
> +       .pm             = &i2c_device_pm_ops,
>  };
>  EXPORT_SYMBOL_GPL(i2c_bus_type);
>
> --
> 1.6.0
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
