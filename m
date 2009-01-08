Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZAHLaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZAHLaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbZAHLaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:30:11 -0500
Received: from www.tglx.de ([62.245.132.106]:58954 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbZAHLaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:30:09 -0500
Date: Thu, 8 Jan 2009 12:29:59 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       ben-linux@fluff.org
Subject: Re: [PATCH 1/2] Driver for user access to internal timer
Message-ID: <20090108112959.GB3053@local>
References: <8447d6730901080205o1a337d4cx867c7b2bd429ceb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730901080205o1a337d4cx867c7b2bd429ceb0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 11:05:30AM +0100, Davide Rizzo wrote:
> Allows user programs to manage internal timers, through virtual files
>  frequency and duty.
> If pwm_one_shot is implemented, it allows also waiting for one-shot period.
> 
> Signed-off-by: Davide Rizzo <elpa-rizzo@gmail.com>
> ---
> diff -urNp linux-2.6.28/drivers/uio/Kconfig

Davide,
please don't use drivers/uio/ for things that are no UIO drivers.

Thanks,
Hans

> linux-2.6.28.elpa/drivers/uio/Kconfig
> --- linux-2.6.28/drivers/uio/Kconfig	2008-12-25 00:26:37.000000000 +0100
> +++ linux-2.6.28.elpa/drivers/uio/Kconfig	2009-01-07 18:58:10.000000000 +0100
> @@ -13,6 +13,26@ menuconfig UIO
> 
>  if UIO
> 
> +config UIO_TIMER
> +	tristate "General purpose timer driver"
> +	default y
> +	---help---
> +	  This driver allows to configure and control general purpose timers
> +	   from user level code.
> +	  To use driver to generate one-shot interrupt-terminated delays, the
> +	   function pwm_one_shot() must be implemented in low-level drivers
> +	  Currently it's implemented only on Samsung S3C24xx platforms.
> +
> +config UIO_TIMER_ONESHOT
> +	bool "Timer driver uses one-shot mode"
> +	depends on PLAT_S3C
> +	default y
> +	---help---
> +	  Enable this to allow general purpose timer driver to use timers
> +	   in one-shot mode. For this to work, the function pwm_one_shot()
> +	   must be implemented in low-level drivers.
> +	  Currently it's implemented only on Samsung S3C24xx platforms.
> +
>  config UIO_CIF
>  	tristate "generic Hilscher CIF Card driver"
>  	depends on PCI
> diff -urNp linux-2.6.28/drivers/uio/Makefile
> linux-2.6.28.elpa/drivers/uio/Makefile
> --- linux-2.6.28/drivers/uio/Makefile	2008-12-25 00:26:37.000000000 +0100
> +++ linux-2.6.28.elpa/drivers/uio/Makefile	2009-01-06 18:20:17.000000000 +0100
> @@ -1,4 +1,5@@
>  obj-$(CONFIG_UIO)	+= uio.o
> +obj-$(CONFIG_UIO_TIMER) += timer.o
>  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
>  obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
>  obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
> diff -urNp linux-2.6.28/drivers/uio/timer.c
> linux-2.6.28.elpa/drivers/uio/timer.c
> --- linux-2.6.28/drivers/uio/timer.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.28.elpa/drivers/uio/timer.c	2009-01-07 19:02:25.000000000 +0100
> @@ -0,0 +1,302 @@
> +/*
> + drivers/misc/timer.c
> +
> + Written Jan 2009 by Davide Rizzo <elpa-rizzo@gmail.com>
> +
> + This driver allows user to access internal timers
> + You can use any timer to generate a fixed frequency signal, or to wait for a
> + defined short time (if hardware can do it).
> + To generate a PWM signal, you have to write the frequency value in Hz into the
> + virtual file "freq". After that you can program the duty cycle in the virtual
> + file "duty", in 1/1000 units (500 = 50%).
> + To wait for a time, you have to write the number of microseconds in virtual
> + file "wait". Reading from same file will complete when timer will expire.
> +
> + This program is free software; you can redistribute it and/or modify
> + it under the terms of the GNU General Public License as published by
> + the Free Software Foundation; either version 2 of the License, or
> + (at your option) any later version.
> +
> + This program is distributed in the hope that it will be useful,
> + but WITHOUT ANY WARRANTY; without even the implied warranty of
> + MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + GNU General Public License for more details.
> +
> + You should have received a copy of the GNU General Public License
> + along with this program; if not, write to the Free Software
> + Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> +*/
> +
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/pwm.h>
> +
> +struct timer_info {
> +	int id;
> +	struct pwm_device *pwm;
> +	unsigned long period_ns, duty_ns;
> +	struct mutex mtx;
> +#ifdef CONFIG_UIO_TIMER_ONESHOT
> +	int flag;
> +	wait_queue_head_t wq;
> +#endif	/* CONFIG_UIO_TIMER_ONESHOT */
> +};
> +
> +#ifdef CONFIG_UIO_TIMER_ONESHOT
> +static void expired(struct pwm_device *pwm, void *arg)
> +{
> +	struct timer_info *info = dev_get_drvdata((struct device *)arg);
> +
> +	info->flag = 1;
> +
> +	wake_up_interruptible(&info->wq);
> +}
> +
> +/* Delay is in usec */
> +static ssize_t wait_store(struct device *dev, struct device_attribute *attr,
> +	const char *buffer, size_t count)
> +{
> +	struct timer_info *info = dev_get_drvdata(dev);
> +	unsigned long delay;
> +	int err = strict_strtoul(buffer, 10, &delay);
> +
> +	if (err)
> +		return err;
> +
> +	mutex_lock(&info->mtx);
> +
> +	info->flag = 0;
> +	pwm_one_shot(info->pwm, delay * 1000, expired, dev);
> +
> +	mutex_unlock(&info->mtx);
> +
> +	return count;
> +}
> +
> +/* Waits for delay */
> +static ssize_t wait_show(struct device *dev, struct device_attribute *attr,
> +	char *buffer)
> +{
> +	struct timer_info *info = dev_get_drvdata(dev);
> +	int ret;
> +
> +	mutex_lock(&info->mtx);
> +
> +	/* !=0 if interrupted by some other signal */
> +	ret = wait_event_interruptible(info->wq, info->flag);
> +
> +	mutex_unlock(&info->mtx);
> +
> +	snprintf(buffer, PAGE_SIZE - 1, "%d\n", ret);
> +	return strlen(buffer);
> +}
> +#endif	/* CONFIG_UIO_TIMER_ONESHOT */
> +
> +#define NS_IN_HZ (1000000000UL)
> +
> +/* Freq is in Hz */
> +static ssize_t freq_store(struct device *dev, struct device_attribute *attr,
> +	const char *buffer, size_t count)
> +{
> +	struct timer_info *info = dev_get_drvdata(dev);
> +	unsigned long output_freq;
> +	int err = strict_strtoul(buffer, 10, &output_freq);
> +	if (err)
> +		return err;
> +
> +	mutex_lock(&info->mtx);
> +
> +	if (output_freq == 0) { /* Stop timer */
> +		pwm_disable(info->pwm);
> +		info->period_ns = 0;
> +		info->duty_ns = 0;
> +	} else {
> +		unsigned long new_period = NS_IN_HZ / output_freq;
> +		if (info->period_ns == 0)
> +			info->duty_ns = new_period / 2;
> +		else {
> +			unsigned long long ll = (unsigned long long)new_period *
> +				info->duty_ns ;
> +			do_div(ll, info->period_ns);
> +			info->duty_ns = ll;
> +		}
> +		info->period_ns = new_period;
> +		pwm_config(info->pwm, info->duty_ns, info->period_ns);
> +		pwm_enable(info->pwm);
> +	}
> +
> +	mutex_unlock(&info->mtx);
> +
> +	return count;
> +}
> +
> +/* Freq is in Hz */
> +static ssize_t freq_show(struct device *dev, struct device_attribute *attr,
> +	char *buffer)
> +{
> +	struct timer_info *info = dev_get_drvdata(dev);
> +	if (info->period_ns)
> +		snprintf(buffer, PAGE_SIZE - 1, "%ld\n", NS_IN_HZ /
> +			info->period_ns);
> +	else
> +		strlcpy(buffer, "0\n", PAGE_SIZE);
> +	return strlen(buffer);
> +}
> +
> +/* Duty is in 1/1000 units */
> +static ssize_t duty_store(struct device *dev, struct device_attribute *attr,
> +	const char *buffer, size_t count)
> +{
> +	struct timer_info *info = dev_get_drvdata(dev);
> +	unsigned long duty;
> +	int err = strict_strtoul(buffer, 10, &duty);
> +	if (err)
> +		return err;
> +	if (duty > 1000)
> +		return -ERANGE;
> +
> +	mutex_lock(&info->mtx);
> +
> +	if ((info->period_ns == 0) || (duty == 0)) { /* Stop timer */
> +		info->duty_ns = 0;
> +		pwm_disable(info->pwm);
> +	} else {
> +		unsigned long long ll = (unsigned long long)duty *
> +			info->period_ns;
> +		do_div(ll, 1000);
> +		info->duty_ns = ll;
> +		pwm_config(info->pwm, info->duty_ns, info->period_ns);
> +		pwm_enable(info->pwm);
> +	}
> +
> +	mutex_unlock(&info->mtx);
> +
> +	return count;
> +}
> +
> +/* Duty is in 1/1000 units */
> +static ssize_t duty_show(struct device *dev, struct device_attribute *attr,
> +	char *buffer)
> +{
> +	struct timer_info *info = dev_get_drvdata(dev);
> +
> +	mutex_lock(&info->mtx);
> +
> +	if (info->period_ns) {
> +		volatile unsigned long long ll = info->duty_ns * 1000;
> +		do_div(ll, info->period_ns);
> +		snprintf(buffer, PAGE_SIZE - 1, "%ld\n", (long int)ll);
> +	} else
> +		strlcpy(buffer, "0\n", PAGE_SIZE);
> +
> +	mutex_unlock(&info->mtx);
> +
> +	return strlen(buffer);
> +}
> +
> +#ifdef CONFIG_UIO_TIMER_ONESHOT
> +static DEVICE_ATTR(wait, S_IRUGO | S_IWUSR, wait_show, wait_store);
> +#endif	/* CONFIG_UIO_TIMER_ONESHOT */
> +static DEVICE_ATTR(frequency, S_IRUGO | S_IWUSR, freq_show, freq_store);
> +static DEVICE_ATTR(duty, S_IRUGO | S_IWUSR, duty_show, duty_store);
> +
> +static int timer_probe(struct platform_device *pdev)
> +{
> +	struct timer_info *info;
> +	int err;
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info) {
> +		dev_err(&pdev->dev, "out of kernel memory\n");
> +		err = -ENOMEM;
> +		goto fail_malloc;
> +	}
> +	platform_set_drvdata(pdev, info);
> +	mutex_init(&info->mtx);
> +	info->pwm = pwm_request(pdev->id, "timer driver");
> +	if (IS_ERR(info->pwm)) {
> +		err = PTR_ERR(info->pwm);
> +		goto fail_req;
> +	}
> +#ifdef CONFIG_UIO_TIMER_ONESHOT
> +	init_waitqueue_head(&info->wq);
> +	info->flag = 1;
> +	err = device_create_file(&pdev->dev, &dev_attr_wait);
> +	if (err) {
> +		dev_err(&pdev->dev, "Unable to create wait virtual file\n");
> +		goto fail_wait;
> +	}
> +#endif	/* CONFIG_UIO_TIMER_ONESHOT */
> +	err = device_create_file(&pdev->dev, &dev_attr_frequency);
> +	if (err) {
> +		dev_err(&pdev->dev, "Unable to create freq virtual file\n");
> +		goto fail_freq;
> +	}
> +	err = device_create_file(&pdev->dev, &dev_attr_duty);
> +	if (err) {
> +		dev_err(&pdev->dev, "Unable to create duty virtual file\n");
> +		goto fail_duty;
> +	}
> +	dev_notice(&pdev->dev, "timer %d device driver loaded OK\n", pdev->id);
> +	return 0;
> +
> +fail_duty:
> +	device_remove_file(&pdev->dev, &dev_attr_frequency);
> +fail_freq:
> +#ifdef CONFIG_UIO_TIMER_ONESHOT
> +	device_remove_file(&pdev->dev, &dev_attr_wait);
> +fail_wait:
> +#endif	/* CONFIG_UIO_TIMER_ONESHOT */
> +	pwm_free(info->pwm);
> +fail_req:
> +	platform_set_drvdata(pdev, NULL);
> +	kfree(info);
> +fail_malloc:
> +	return err;
> +}
> +
> +static int timer_remove(struct platform_device *pdev)
> +{
> +	struct timer_info *info = platform_get_drvdata(pdev);
> +
> +	mutex_lock(&info->mtx);
> +
> +	device_remove_file(&pdev->dev, &dev_attr_duty);
> +	device_remove_file(&pdev->dev, &dev_attr_frequency);
> +#ifdef CONFIG_UIO_TIMER_ONESHOT
> +	device_remove_file(&pdev->dev, &dev_attr_wait);
> +#endif	/* CONFIG_UIO_TIMER_ONESHOT */
> +	pwm_free(info->pwm);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	mutex_unlock(&info->mtx);
> +
> +	kfree(info);
> +	return 0;
> +}
> +
> +static struct platform_driver timer_driver = {
> +	.probe  = timer_probe,
> +	.remove = timer_remove,
> +	.driver = {
> +		.name = "timer",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init timer_init_module(void)
> +{
> +	return platform_driver_register(&timer_driver);
> +}
> +
> +static void __exit timer_cleanup_module(void)
> +{
> +	platform_driver_unregister(&timer_driver);
> +}
> +
> +module_init(timer_init_module);
> +module_exit(timer_cleanup_module);
> +
> +MODULE_AUTHOR("Davide Rizzo <elpa-rizzo@gmail.com>");
> +MODULE_DESCRIPTION("Timers driver");
> +MODULE_SUPPORTED_DEVICE("timers");
> +MODULE_LICENSE("GPL");
