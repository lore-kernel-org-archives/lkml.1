Return-Path: <linux-kernel-owner+w=401wt.eu-S937707AbYD1Uuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937707AbYD1Uuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934819AbYD1Uu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:50:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932973AbYD1Uu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:50:26 -0400
Date: Mon, 28 Apr 2008 13:46:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Message-Id: <20080428134649.44cf239c.akpm@linux-foundation.org>
In-Reply-To: <200804281239.51729.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 12:39:51 -0700 David Brownell <david-b@pacbell.net> wrote:

> Simple sysfs interface for GPIOs.
> 
>     /sys/class/gpio
>         /gpio-N ... for each exported GPIO #N
> 	    /value ... always readable, writes fail except for output GPIOs
> 	    /direction ... writable as: in, out (default low), high, low
>     	/control ... to request a GPIO be exported or unexported
> 
> GPIOs may be exported by kernel code using gpio_export(), which should
> be most useful for driver debugging.  Userspace may also ask that they
> be exported by writing to the sysfs control file, helping to cope with
> incomplete board support:
> 
>   echo "export 23" > /sys/class/gpio/control
> 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> 	/sys/class/gpio/gpio-23/direction to configure it.
>   echo "unexport 23" > /sys/class/gpio/control
> 	... will gpio_free(23)

hm, does ths sysfs one-value-per-file rule apply to writes?

> The D-space footprint is negligible, except for the sysfs resources
> associated with each exported GPIO.  The additional I-space footprint
> is about half of the current size of gpiolib.  No /dev node creation
> involved, and no "udev" support is needed.
> 
> This adds a device pointer to "struct gpio_chip".  When GPIO providers
> initialize that, sysfs gpio class devices become children of that device
> instead of being "virtual" devices.  The (few) gpio_chip providers which
> have such a device node have been updated.  (Some also needed to update
> their module "owner" field ... for which missing kerneldoc was added.)
> 
> Based on a patch from Trent Piepho <tpiepho@freescale.com>, and comments
> from various folk including Hartley Sweeten.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  arch/avr32/mach-at32ap/pio.c |    2 
>  drivers/gpio/Kconfig         |   16 ++
>  drivers/gpio/gpiolib.c       |  281 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/gpio/mcp23s08.c      |    1 
>  drivers/gpio/pca953x.c       |    1 
>  drivers/gpio/pcf857x.c       |    1 
>  drivers/i2c/chips/tps65010.c |    2 
>  drivers/mfd/htc-egpio.c      |    2 
>  include/asm-generic/gpio.h   |   28 ++++

Documentation for the interface?

>  }
>  EXPORT_SYMBOL_GPL(gpio_request);
>  
> +
> +#ifdef CONFIG_GPIO_SYSFS
> +
> +/*
> + * /sys/class/gpio/gpio-N/... only for GPIOs that are exported
> + *  - direction
> + *      * is read/write as in/out
> + *      * may also be written as high/low, initializing output
> + *        value as specified (plain "out" implies "low")
> + *  - value
> + *      * always readable, subject to hardware behavior
> + *      * may be writable, as zero/nonzero
> + */
> +
> +#include <linux/device.h>
> +#include <linux/err.h>

Putting includes inside ifdefs tends to increase the risk of compilation
errors.

> +static ssize_t gpio_direction_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> +
> +	/* handle GPIOs being removed from underneath us... */
> +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +		return -EIO;
> +
> +	return sprintf(buf, "%s\n",
> +		test_bit(FLAG_IS_OUT, &desc->flags) ? "out" : "in");
> +}

What prevents FLAG_EXPORT from getting cleared just after we tested it?

iow: this looks racy.

> +static ssize_t gpio_direction_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	unsigned		gpio = desc - gpio_desc;
> +	unsigned		len = size;
> +	ssize_t			status = -EINVAL;
> +
> +	/* handle GPIOs being removed from underneath us... */
> +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +		return -EIO;

Dittoes.

> +	if (buf[len - 1] == '\n')
> +		len--;
> +
> +	if (len == 4 && strncmp(buf, "high", 4) == 0)
> +		status = gpio_direction_output(gpio, 1);
> +
> +	else if (len == 3 && (strncmp(buf, "out", 3) == 0
> +			|| strncmp(buf, "low", 3) == 0))
> +		status = gpio_direction_output(gpio, 0);
> +
> +	else if (len == 2 && strncmp(buf, "in", 2) == 0)
> +		status = gpio_direction_input(gpio);

urgh.

If we had a strcmp() variant which treats a \n in the first arg as a \0
the above would become

	if (sysfs_streq(buf, "high"))
		status = gpio_direction_output(gpio, 1);
	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
		status = gpio_direction_output(gpio, 0);
	else if (sysfs_streq(buf, "in"))
		status = gpio_direction_input(gpio);

(note the removal of the unneeded and misleading blank lines)

> +	return (status < 0) ? status : size;
> +}
> +
> +static const DEVICE_ATTR(direction, 0644, gpio_direction_show, gpio_direction_store);
> +
> +static ssize_t gpio_value_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	unsigned		gpio = desc - gpio_desc;
> +
> +	/* handle GPIOs being removed from underneath us... */
> +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +		return -EIO;
> +
> +	return sprintf(buf, "%d\n", gpio_get_value_cansleep(gpio));
> +}
> +
> +static ssize_t gpio_value_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	unsigned		gpio = desc - gpio_desc;
> +	long			value;
> +	int			ret;
> +
> +	/* handle GPIOs being removed from underneath us... */
> +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +		return -EIO;
> +
> +	if (!test_bit(FLAG_IS_OUT, &desc->flags))
> +		return -EINVAL;

racy?

> +	ret = strict_strtol(buf, 0, &value);
> +	if (ret < 0)
> +		return ret;
> +	gpio_set_value_cansleep(gpio, value != 0);
> +	return size;
> +}
>
> ...
>
> +/**
> + * gpio_export - export a GPIO through sysfs
> + * @gpio: gpio to make available, already requested
> + *
> + * When drivers want to make a GPIO accessible to userspace after they
> + * have requested it -- perhaps while debugging, or as part of their
> + * public interface -- they may use this routine.
> + *
> + * Returns zero on success, else an error.
> + */
> +int gpio_export(unsigned gpio)
> +{
> +	unsigned long		flags;
> +	struct gpio_desc	*desc;
> +	int			status = -EINVAL;
> +
> +	if (!gpio_class)
> +		return -ENOSYS;
> +
> +	if (!gpio_is_valid(gpio))
> +		return -EINVAL;
> +
> +	/* REVISIT mode param to say if it direction may be changed */
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +	desc = &gpio_desc[gpio];
> +	if (test_bit(FLAG_REQUESTED, &desc->flags)
> +			&& !test_bit(FLAG_EXPORT, &desc->flags))
> +		status = 0;
> +	spin_unlock_irqrestore(&gpio_lock, flags);

Well there's some locking.  But it's there to pin gpio_desc[].

> +	if (status)
> +		pr_debug("%s: gpio-%d status %d\n", __func__, gpio, status);
> +	else {
> +		struct device	*dev;
> +
> +		dev = device_create(gpio_class, desc->chip->dev, 0,
> +				"gpio-%d", gpio);
> +		if (dev) {
> +			dev_set_drvdata(dev, desc);
> +			status = sysfs_create_group(&dev->kobj,
> +					&gpio_attr_group);
> +		}
> +		if (status == 0)
> +			set_bit(FLAG_EXPORT, &desc->flags);
> +	}
> +
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(gpio_export);
> +
> +static int match_export(struct device *dev, void *data)
> +{
> +	return dev_get_drvdata(dev) == data;
> +}
> +
> +/**
> + * gpio_unexport - reverse effect of gpio_export()
> + * @gpio: gpio to make unavailable
> + *
> + * This is implicit on gpio_free().
> + */
> +void gpio_unexport(unsigned gpio)
> +{
> +	unsigned long		flags;
> +	struct gpio_desc	*desc;
> +	int			status = -EINVAL;
> +
> +	if (!gpio_is_valid(gpio))
> +		return;

Is that a programming error?

> +	spin_lock_irqsave(&gpio_lock, flags);
> +	desc = &gpio_desc[gpio];
> +	if (test_bit(FLAG_EXPORT, &desc->flags))
> +		status = 0;
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	if (status == 0) {
> +		struct device	*dev = NULL;
> +
> +		dev = class_find_device(gpio_class, desc, match_export);
> +		if (dev) {
> +			clear_bit(FLAG_EXPORT, &desc->flags);
> +			put_device(dev);
> +			device_unregister(dev);
> +		}
> +	}
> +
> +}
> +EXPORT_SYMBOL_GPL(gpio_unexport);
> +
> +/*
> + * /sys/class/gpio/control ... write-only
> + *	export N
> + *	unexport N
> + */
> +static ssize_t control_store(struct class *class, const char *buf, size_t len)
> +{
> +	char *scratch = (char *)buf;
> +	char *cmd, *tmp;
> +	int status;
> +	unsigned long gpio;
> +
> +	/* export/unexport */
> +	cmd = strsep(&scratch, " \t\n");

urgh.  We cast away the const and then smash up the caller's const string
with strsep.

> +	if (!cmd)
> +		goto fail;
> +
> +	/* N */
> +	tmp = strsep(&scratch, " \t\n");
> +	if (!tmp)
> +		goto fail;
> +	status = strict_strtoul(tmp, 0, &gpio);
> +	if (status < 0)
> +		goto done;
> +
> +	/* reject commands with garbage at end */

strict_strtoul() already does that?

> +	tmp = strsep(&scratch, " \t\n");
> +	if ((tmp && *tmp) || scratch)
> +		goto fail;
> +
> +	if (strcmp(cmd, "export") == 0) {
> +		status = gpio_request(gpio, "sysfs");
> +		if (status < 0)
> +			goto done;
> +
> +		status = gpio_export(gpio);
> +		if (status < 0)
> +			gpio_free(gpio);
> +		else
> +			set_bit(FLAG_SYSFS, &gpio_desc[gpio].flags);
> +
> +	} else if (strcmp(cmd, "unexport") == 0) {
> +		/* reject bogus commands (gpio_unexport ignores them) */
> +		if (!gpio_is_valid(gpio))
> +			goto fail;
> +		if (!test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags))
> +			goto fail;
> +
> +		gpio_free(gpio);
> +	}
> +done:
> +	return (status < 0) ? status : len;
> +fail:
> +	return -EINVAL;
> +}

The string handling in here seems way over-engineered.  All we're doing is
parting "export 42" or "unexport 42".  Surely it can be done better than
this.

The more sysfs-friendly way would be to create separate sysfs files for the
export and unexport operations, I expect.

> +static CLASS_ATTR(control, 0200, NULL, control_store);
> +
> +static int __init gpiolib_sysfs_init(void)
> +{
> +	int	status;
> +
> +	gpio_class = class_create(THIS_MODULE, "gpio");
> +	if (IS_ERR(gpio_class))
> +		return PTR_ERR(gpio_class);
> +
> +	status = class_create_file(gpio_class, &class_attr_control);
> +	if (status < 0) {
> +		class_destroy(gpio_class);
> +		gpio_class = NULL;
> +	}
> +	return status;
> +}
> +postcore_initcall(gpiolib_sysfs_init);
> +
> +#endif /* CONFIG_GPIO_SYSFS */
> +
>
> ...
>
> -#else
> +#ifdef CONFIG_GPIO_SYSFS
> +#define HAVE_GPIO_SYSFS

Can we find a way to make HAVE_GPIO_SYSFS go away?  Just use
CONFIG_GPIO_SYSFS?

> +/*
> + * A sysfs interface can be exported by individual drivers if they want,
> + * but more typically is configured entirely from userspace.
> + */
> +extern int gpio_export(unsigned gpio);
> +extern void gpio_unexport(unsigned gpio);
> +
> +#endif	/* CONFIG_GPIO_SYSFS */
> +
> +#else	/* !CONFIG_HAVE_GPIO_LIB */
>  
>  static inline int gpio_is_valid(int number)
>  {
> @@ -135,4 +150,15 @@ static inline void gpio_set_value_cansle
>  
>  #endif
>  
> +#ifndef HAVE_GPIO_SYSFS
> +static inline int gpio_export(unsigned gpio)
> +{
> +	return -ENOSYS;
> +}
> +
> +static inline void gpio_unexport(unsigned gpio)
> +{
> +}
> +#endif	/* HAVE_GPIO_SYSFS */
> +
>  #endif /* _ASM_GENERIC_GPIO_H */

Then this can just be moved into a #else.
