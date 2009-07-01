Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZGAIZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZGAIZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZGAIZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:25:13 -0400
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:22740 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752952AbZGAIZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:25:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lB/FNzgA8TVg8IVVHVESIOduMo1fh124x6APXidK+ZW2rWH6NdACzMRrD8ADqWX5HupAKPFNHw2HQRot4DzpFnqG2PsWPvtMsQTOBL55FTWPBJnPV7Qx/MtNcF9qetumS66ifhvOcvwgguOHfSyC9UIoV1MWbrcZ5zQK7Bqcr4I=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: fhXH.bIVM1l8WojoennXmSTOu0wojGtYrEgEak5XoVppWo8BkW.SF4WDvXgBwbIarNtD0tFtx2bk0.liWH1hmpLz7dFX68UsQkYcwckTQisl8BZUxEHWcNsICMlZpDP9jIt7kUYAJZDSDtCXVWqhd3EzP8ZkovwCjeU4QZ6plOW3B9bHAaELhKi8y8Su1tSOmX5cn4KPfHBa0QSlPJaceXbBLe_dG4snC.M0uj9mEslnc_rSJZSkKe0ccYWSHeERuRdCaKCNq0545KXkqxJYhp468k9WI_UDljcvZAKDaDjqz0R7
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] gpiolib: allow exported GPIO nodes to be named using sysfs links
Date: Wed, 1 Jul 2009 01:25:07 -0700
User-Agent: KMail/1.9.10
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200906301843.22646.david-b@pacbell.net> <1246435306-7371-1-git-send-email-ext-jani.1.nikula@nokia.com>
In-Reply-To: <1246435306-7371-1-git-send-email-ext-jani.1.nikula@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907010125.08002.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Jani Nikula wrote:
> Commit 926b663ce8215ba448960e1ff6e58b67a2c3b99b (gpiolib: allow GPIOs to
> be named) already provides naming on the chip level. This patch provides
> more flexibility by allowing multiple names where ever in sysfs on a per
> GPIO basis.
> 
> Adapted from David Brownell's comments on a similar concept:
> http://lkml.org/lkml/2009/4/20/203.
> 
> Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Andrew, this replaces a patch now in your MM tree...

> 
> ---
> 
> Changes in v2:
>  - remove BUG_ON()
> ---
>  Documentation/gpio.txt     |   10 +++++++++
>  drivers/gpio/gpiolib.c     |   45 ++++++++++++++++++++++++++++++++++++++++++++
>  include/asm-generic/gpio.h |    8 +++++++
>  include/linux/gpio.h       |    9 ++++++++
>  4 files changed, 72 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
> index e4b6985..566edaa 100644
> --- a/Documentation/gpio.txt
> +++ b/Documentation/gpio.txt
> @@ -555,6 +555,11 @@ requested using gpio_request():
>  	/* reverse gpio_export() */
>  	void gpio_unexport();
>  
> +	/* create a sysfs link to an exported GPIO node */
> +	int gpio_export_link(struct device *dev, const char *name,
> +		unsigned gpio)
> +
> +
>  After a kernel driver requests a GPIO, it may only be made available in
>  the sysfs interface by gpio_export().  The driver can control whether the
>  signal direction may change.  This helps drivers prevent userspace code
> @@ -563,3 +568,8 @@ from accidentally clobbering important system state.
>  This explicit exporting can help with debugging (by making some kinds
>  of experiments easier), or can provide an always-there interface that's
>  suitable for documenting as part of a board support package.
> +
> +After the GPIO has been exported, gpio_export_link() allows creating
> +symlinks from elsewhere in sysfs to the GPIO sysfs node.  Drivers can
> +use this to provide the interface under their own device in sysfs with
> +a descriptive name.
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 51a8d41..aef6b3d 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -505,6 +505,51 @@ static int match_export(struct device *dev, void *data)
>  }
>  
>  /**
> + * gpio_export_link - create a sysfs link to an exported GPIO node
> + * @dev: device under which to create symlink
> + * @name: name of the symlink
> + * @gpio: gpio to create symlink to, already exported
> + *
> + * Set up a symlink from /sys/.../dev/name to /sys/class/gpio/gpioN
> + * node. Caller is responsible for unlinking.
> + *
> + * Returns zero on success, else an error.
> + */
> +int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
> +{
> +	struct gpio_desc	*desc;
> +	int			status = -EINVAL;
> +
> +	if (!gpio_is_valid(gpio))
> +		goto done;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	desc = &gpio_desc[gpio];
> +
> +	if (test_bit(FLAG_EXPORT, &desc->flags)) {
> +		struct device *tdev;
> +
> +		tdev = class_find_device(&gpio_class, NULL, desc, match_export);
> +		if (tdev != NULL) {
> +			status = sysfs_create_link(&dev->kobj, &tdev->kobj,
> +						name);
> +		} else {
> +			status = -ENODEV;
> +		}
> +	}
> +
> +	mutex_unlock(&sysfs_lock);
> +
> +done:
> +	if (status)
> +		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(gpio_export_link);
> +
> +/**
>   * gpio_unexport - reverse effect of gpio_export()
>   * @gpio: gpio to make unavailable
>   *
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index d6c379d..9cca378 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -141,6 +141,8 @@ extern int __gpio_to_irq(unsigned gpio);
>   * but more typically is configured entirely from userspace.
>   */
>  extern int gpio_export(unsigned gpio, bool direction_may_change);
> +extern int gpio_export_link(struct device *dev, const char *name,
> +			unsigned gpio);
>  extern void gpio_unexport(unsigned gpio);
>  
>  #endif	/* CONFIG_GPIO_SYSFS */
> @@ -185,6 +187,12 @@ static inline int gpio_export(unsigned gpio, bool direction_may_change)
>  	return -ENOSYS;
>  }
>  
> +static inline int gpio_export_link(struct device *dev, const char *name,
> +				unsigned gpio)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline void gpio_unexport(unsigned gpio)
>  {
>  }
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index e10c49a..ff374ce 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -89,6 +89,15 @@ static inline int gpio_export(unsigned gpio, bool direction_may_change)
>  	return -EINVAL;
>  }
>  
> +static inline int gpio_export_link(struct device *dev, const char *name,
> +				unsigned gpio)
> +{
> +	/* GPIO can never have been exported */
> +	WARN_ON(1);
> +	return -EINVAL;
> +}
> +
> +
>  static inline void gpio_unexport(unsigned gpio)
>  {
>  	/* GPIO can never have been exported */
> -- 
> 1.6.3.2
> 
> 


