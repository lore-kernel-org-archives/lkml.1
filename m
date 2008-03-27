Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYC0FqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYC0FqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 01:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYC0FqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 01:46:05 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:9691
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbYC0FqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 01:46:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvEAAO7R6kd8qNIK/2dsb2JhbAAIqnU
X-IronPort-AV: E=Sophos;i="4.25,562,1199631600"; 
   d="scan'208";a="197821677"
Subject: Re: [PATCH 1/1] [GPIO]: new arch-independent simple-gpio driver
From: Ben Nizette <bn@niasdigital.com>
To: Bryan Wu <cooloney@kernel.org>, Mike Frysinger <vapier.adi@gmail.com>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1206579921-22221-1-git-send-email-cooloney@kernel.org>
References: <>  <1206579921-22221-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain
Organization: Nias Digital
Date: Thu, 27 Mar 2008 16:52:30 +1100
Message-Id: <1206597150.3315.48.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wed, 2008-03-26 at 18:05 -0700, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/char/Kconfig       |   14 ++
>  drivers/char/Makefile      |    1 +
>  drivers/char/simple-gpio.c |  308 ++++++++++++++++++++++++++++++++++++++++++++

Considered putting this in drivers/gpio?  Not a real problem, up to you
(or David).

>  3 files changed, 323 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/char/simple-gpio.c
> 
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 47c6be8..dd17d06 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -4,6 +4,20 @@
>  
>  menu "Character devices"
>  
> +config SIMPLE_GPIO
> +	tristate "Simple GPIO char interface"
> +	depends on GENERIC_GPIO
> +	default n
> +	help
> +	  If you say Y here, you will get support for a character device
> +	  interface to the GPIO pins which will allow you to read and
> +	  write GPIO values from userspace.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called simple-gpio.
> +
> +	  If unsure, it is safe to say Y.
> +
>  config VT
>  	bool "Virtual terminal" if EMBEDDED
>  	depends on !S390
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index 5407b76..e087ec1 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -97,6 +97,7 @@ obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
>  obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
>  obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
>  obj-$(CONFIG_TELCLOCK)		+= tlclk.o
> +obj-$(CONFIG_SIMPLE_GPIO)	+= simple-gpio.o
>  
>  obj-$(CONFIG_MWAVE)		+= mwave/
>  obj-$(CONFIG_AGP)		+= agp/
> diff --git a/drivers/char/simple-gpio.c b/drivers/char/simple-gpio.c
> new file mode 100644
> index 0000000..36204ca
> --- /dev/null
> +++ b/drivers/char/simple-gpio.c
> @@ -0,0 +1,308 @@
> +/*
> + * Simple character interface to GPIOs.  Allows you to read/write values and
> + * control the direction.  Maybe add wakeup when gpio framework supports it ...

Userspace notification of a GPIO IRQ?  Not too 'simple' but very
worthwhile.

If you're feeling keen (and it doesn't violate the 'simple' in the name)
then I think it would be well worth being able to attach a string to
each gpio entry in the platform_data and make them available through
sysfs.  Very few userspace users will know what gpio_id they actually
want unless they can see a "PortA-05" tag attached to it somewhere.

This is extra-especially true for dynamically allocated gpio ids
(through gpiolib).

> + *
> + * To use, just declare in your board resources:
> + * static struct resource foo_resources[] = {
> + *     .start = 0,
> + *     .end = 5,
> + *     .flags = IORESOURCE_IRQ,
> + * };

This don't sit right with me; I reckon an IORESOURCE_GPIO may not be a
bad move but that's for a different patch.  In the mean time getting the
user to fill out some platform_data would be preferable IMO.

> + * static struct platform_device foo_dev = {
> + *     .name = "simple-gpio",
> + *     .num_resources = 1,
> + *     .resource = &foo_resources
> + * };
> + * This will setup GPIO0 - GPIO5 (inclusive) for use by this driver.
> + *
> + * Copyright 2008 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2 or later.
> + */
> +
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +
> +#include <asm/atomic.h>
> +#include <asm/gpio.h>
> +#include <asm/uaccess.h>
> +
> +#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
> +#define stampit() stamp("here i am")
> +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
> +#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
> +
> +#define DRIVER_NAME "simple-gpio"
> +#define PFX DRIVER_NAME ": "

Hmm, a bit of a cleanup regarding messaging is needed IMO.

Should your pr_*init macros be accepted somewhere higher up the tree?
Either that or dropped, it doesn't seem right wedging them in here.
Sure it might cost you a few hundred bytes of RAM but would be nice to
keep it all consistent across the kernel.

> +
> +struct gpio_data {
> +	atomic_t open_count;
> +};
> +struct group_data {
> +	dev_t dev_node;
> +	struct cdev cdev;
> +	struct resource *gpio_range;
> +	struct gpio_data *gpios;
> +};
> +
> +/**
> + *	simple_gpio_read - sample the value of the specified GPIO
> + */
> +static ssize_t simple_gpio_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
> +{
> +	unsigned int gpio = iminor(file->f_path.dentry->d_inode);
> +	ssize_t ret;
> +
> +	stampit();
> +
> +	for (ret = 0; ret < count; ++ret) {
> +		char byte = '0' + gpio_get_value(gpio);
> +		if (put_user(byte, buf + ret))
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + *	simple_gpio_write - modify the state of the specified GPIO
> + *
> + *	We allow people to control the direction and value of the specified GPIO.
> + *	You can only change these once per write though.  We process the user buf
> + *	and only do the last thing specified.  We also ignore newlines.  This way
> + *	you can quickly test by doing from the shell:
> + *		$ echo 'O1' > /dev/gpio8
> + *	This will set GPIO8 to ouput mode and set the value to 1.
> + */
> +static ssize_t simple_gpio_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
> +{
> +	unsigned int gpio = iminor(file->f_path.dentry->d_inode);
> +	ssize_t ret;
> +	char dir = '?', uvalue = '?';
> +	int value;
> +
> +	stampit();
> +
> +	ret = 0;
> +	while (ret < count) {
> +		char byte;
> +		int user_ret = get_user(byte, buf + ret++);
> +		if (user_ret)
> +			return user_ret;
> +
> +		switch (byte) {
> +		case '\r':
> +		case '\n': continue;
> +		case 'I':
> +		case 'O': dir = byte; break;
> +		case 'T':
> +		case '0':
> +		case '1': uvalue = byte; break;
> +		default:  return -EINVAL;
> +		}
> +		stamp("processed byte '%c'", byte);
> +	}
> +
> +	switch (uvalue) {
> +	case '?': value = gpio_get_value(gpio); break;
> +	case 'T': value = !gpio_get_value(gpio); break;
> +	default:  value = uvalue - '0'; break;
> +	}
> +
> +	switch (dir) {
> +	case 'I': gpio_direction_input(gpio); break;
> +	case 'O': gpio_direction_output(gpio, value); break;
> +	}

Hmm, coding style question marks around a 2- or even 3-entry switch
statement...

> +
> +	if (uvalue != '?')
> +		gpio_set_value(gpio, value);
> +
> +	return ret;
> +}
> +
> +/**
> + *	simple_gpio_open - claim the specified GPIO
> + *
> + *	Grab the specified GPIO if it's available and keep track of how many times
> + *	we've been opened (see close() below).  We allow multiple people to open
> + *	at the same time as there's no real limitation in the hardware for reading
> + *	from different processes.  Plus this way you can have one app do the write
> + *	and management while quickly monitoring from another by doing:
> + *		$ cat /dev/gpio8
> + */
> +static int simple_gpio_open(struct inode *ino, struct file *file)
> +{
> +	struct group_data *group_data = container_of(ino->i_cdev, struct group_data, cdev);
> +	unsigned int gpio = iminor(ino);
> +	struct gpio_data *gpio_data = &group_data->gpios[gpio - group_data->gpio_range->start];
> +	int ret;
> +
> +	stampit();
> +
> +	if (gpio < group_data->gpio_range->start || gpio > group_data->gpio_range->end)
> +		return -ENXIO;
> +
> +	ret = gpio_request(gpio, DRIVER_NAME);
> +	if (ret)
> +		return ret;
> +
> +	atomic_inc(&gpio_data->open_count);
> +
> +	return 0;
> +}
> +
> +/**
> + *	simple_gpio_close - release the specified GPIO
> + *
> + *	Do not actually free the specified GPIO until the last person has closed.
> + *	We claim/release here rather than during probe() so that people can swap
> + *	between drivers on the fly during runtime without having to load/unload
> + *	kernel modules.
> + */
> +static int simple_gpio_release(struct inode *ino, struct file *file)
> +{
> +	struct group_data *group_data = container_of(ino->i_cdev, struct group_data, cdev);
> +	unsigned int gpio = iminor(ino);
> +	struct gpio_data *gpio_data = &group_data->gpios[gpio - group_data->gpio_range->start];
> +
> +	stampit();
> +
> +	/* do not free until last consumer has closed */
> +	if (atomic_dec_and_test(&gpio_data->open_count))
> +		gpio_free(gpio);
> +	else
> +		stamp("gpio still in use -- not freeing");
> +
> +	return 0;
> +}
> +
> +static struct class *simple_gpio_class;
> +
> +static struct file_operations simple_gpio_fops = {
> +	.owner    = THIS_MODULE,
> +	.read     = simple_gpio_read,
> +	.write    = simple_gpio_write,
> +	.open     = simple_gpio_open,
> +	.release  = simple_gpio_release,
> +};
> +
> +/**
> + *	simple_gpio_probe - setup the range of GPIOs
> + *
> + *	Create a character device for the range of GPIOs and have the minor be
> + *	used to specify the GPIO.
> + */
> +static int __devinit simple_gpio_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct group_data *group_data;
> +	struct resource *gpio_range = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	int gpio, gpio_max = gpio_range->end - gpio_range->start + 1;
> +

Was it a conscious thing to only allow 1 range of gpios per device?  I
can imagine that it's quite likely that people are going to want to
expose all unused gpios on a SoC to userspace.  This is going to mean
lots of small ranges split either side of pre-reserved pins and one
device per little range is gonna get cumbersome.


> +	stampit();
> +
> +	group_data = kzalloc(sizeof(*group_data) + sizeof(struct gpio_data) * gpio_max, GFP_KERNEL);
> +	if (!group_data)
> +		return -ENOMEM;
> +	group_data->gpio_range = gpio_range;
> +	group_data->gpios = (void *)group_data + sizeof(*group_data);

Why this ugliness, can't you just allocate the gpio_data separately?

> +	platform_set_drvdata(pdev, group_data);
> +
> +	ret = alloc_chrdev_region(&group_data->dev_node, gpio_range->start, gpio_max, "gpio");
> +	if (ret) {
> +		pr_devinit(KERN_ERR PFX "unable to get a char device\n");
> +		kfree(group_data);
> +		return ret;
> +	}
> +
> +	cdev_init(&group_data->cdev, &simple_gpio_fops);
> +	group_data->cdev.owner = THIS_MODULE;
> +
> +	ret = cdev_add(&group_data->cdev, group_data->dev_node, gpio_max);
> +	if (ret) {
> +		pr_devinit(KERN_ERR PFX "unable to register char device\n");
> +		kfree(group_data);
> +		unregister_chrdev_region(group_data->dev_node, gpio_max);
> +		return ret;
> +	}
> +
> +	for (gpio = gpio_range->start; gpio < gpio_range->end; ++gpio)
> +		device_create(simple_gpio_class, &pdev->dev, group_data->dev_node + gpio, "gpio%i", gpio);

Making assumptions about the format of a dev_t is Bad.  Sure it's a bit
of a pain constructing the correct node with MKDEV/MAJOR macros but it's
the way to do it (rather than '+').

> +
> +	device_init_wakeup(&pdev->dev, 1);
> +
> +	pr_devinit(KERN_INFO PFX "now handling %i GPIOs: %i - %i\n",
> +		gpio_max, gpio_range->start, gpio_range->end);
> +
> +	return 0;
> +}
> +
> +/**
> + *	simple_gpio_remove - break down the range of GPIOs
> + *
> + *	Release the character device and related pieces for this range of GPIOs.
> + */
> +static int __devexit simple_gpio_remove(struct platform_device *pdev)
> +{
> +	struct group_data *group_data = platform_get_drvdata(pdev);
> +	struct resource *gpio_range = group_data->gpio_range;
> +	int gpio, gpio_max = gpio_range->end - gpio_range->start + 1;
> +
> +	stampit();
> +
> +	for (gpio = gpio_range->start; gpio < gpio_range->end; ++gpio)
> +		device_destroy(simple_gpio_class, group_data->dev_node + gpio);

same dev_t assumptions as above

> +
> +	cdev_del(&group_data->cdev);
> +	unregister_chrdev_region(group_data->dev_node, gpio_max);
> +
> +	kfree(group_data);
> +
> +	return 0;
> +}
> +
> +struct platform_driver simple_gpio_device_driver = {
> +	.probe   = simple_gpio_probe,
> +	.remove  = __devexit_p(simple_gpio_remove),
> +	.driver  = {
> +		.name = DRIVER_NAME,
> +	}
> +};
> +
> +/**
> + *	simple_gpio_init - setup our GPIO device driver
> + *
> + *	Create one GPIO class for the entire driver
> + */
> +static int __init simple_gpio_init(void)
> +{
> +	simple_gpio_class = class_create(THIS_MODULE, DRIVER_NAME);
> +	if (IS_ERR(simple_gpio_class)) {
> +		pr_init(KERN_ERR PFX "unable to create gpio class\n");
> +		return PTR_ERR(simple_gpio_class);
> +	}
> +
> +	return platform_driver_register(&simple_gpio_device_driver);
> +}
> +module_init(simple_gpio_init);
> +
> +/**
> + *	simple_gpio_exit - break down our GPIO device driver
> + */
> +static void __exit simple_gpio_exit(void)
> +{
> +	class_destroy(simple_gpio_class);
> +
> +	platform_driver_unregister(&simple_gpio_device_driver);
> +}
> +module_exit(simple_gpio_exit);
> +
> +MODULE_AUTHOR("Mike Frysinger <vapier@gentoo.org>");
> +MODULE_DESCRIPTION("Simple GPIO character interface");
> +MODULE_LICENSE("GPL");
