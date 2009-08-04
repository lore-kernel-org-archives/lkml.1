Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbZHDXol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbZHDXol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbZHDXok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:44:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755385AbZHDXoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:44:39 -0400
Date: Tue, 4 Aug 2009 16:43:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ben@fluff.org
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: gpiolib: add names file in gpio chip sysfs.
Message-Id: <20090804164339.99667a23.akpm@linux-foundation.org>
In-Reply-To: <20090803165536.345974601@fluff.org>
References: <20090803165536.345974601@fluff.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Aug 2009 17:55:36 +0100
ben@fluff.org wrote:
>

Did you mean the commit to have an author of ben@fluff.org?  I assumed
not and rewrote it to

	Ben Dooks <ben@simtec.co.uk>

If you indeed want a different Author: and Signed-off-by: line then
please indicate that explicitly by putting a From: line at the top of
the changelog.

As your MUA didn't fill in the real-name part of the From: address,
it's nice to provide a From: line in the changelog so the patch
receiver doesn't have to type it in.

> Add a 'names' file to the sysfs entries for each chip to show which
> have names.

Why?

> Signed-off-by: Ben Dooks <ben@simtec.co.uk>
> CC: David Brownell <dbrownell@users.sourceforge.net>
> 
> ---
>  drivers/gpio/gpiolib.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> Index: b/drivers/gpio/gpiolib.c
> ===================================================================
> --- a/drivers/gpio/gpiolib.c	2009-08-03 17:51:40.000000000 +0100
> +++ b/drivers/gpio/gpiolib.c	2009-08-03 17:53:04.000000000 +0100
> @@ -303,6 +303,7 @@ static const struct attribute_group gpio
>   *   /base ... matching gpio_chip.base (N)
>   *   /label ... matching gpio_chip.label
>   *   /ngpio ... matching gpio_chip.ngpio
> + *   /names ... matching gpio_chip.names
>   */
>  
>  static ssize_t chip_base_show(struct device *dev,
> @@ -332,10 +333,30 @@ static ssize_t chip_ngpio_show(struct de
>  }
>  static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
>  
> +static ssize_t chip_names_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_chip*chip = dev_get_drvdata(dev);

Please use checkpatch.

> +	char **names = chip->names;
> +	int ptr = 0;
> +	int name;
> +
> +	if (!names)
> +		return -EINVAL;

Should this return -EINVAL?  Or should we simply return an empty read()?

> +	for (name = 0; name < chip->ngpio && ptr < PAGE_SIZE; name++)
> +		ptr += snprintf(buf + ptr, PAGE_SIZE - ptr,
> +				"%s\n", names[name] ? names[name] : "");
> +
> +	return ptr;
> +}
> +DEVICE_ATTR(names, 0444, chip_names_show, NULL);

I shall make this static.

>  static const struct attribute *gpiochip_attrs[] = {
>  	&dev_attr_base.attr,
>  	&dev_attr_label.attr,
>  	&dev_attr_ngpio.attr,
> +	&dev_attr_names.attr,
>  	NULL,
>  };
>  
> 
> -- 
