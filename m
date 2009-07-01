Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZGAXFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZGAXFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZGAXFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:05:30 -0400
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:47110 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750949AbZGAXF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:05:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=l53hBKjRxp8o2t5ynBxjkSXdwWq7LETpYSxQ9HpiiW3kbhvvBRXsr7sJcQV+p3eDlRrTjHfOgCKsG9wLAVYbd3lYCgE9WovVcRjw9PTeSYhztE7qMoDZQHc7+bHIUQ6hqZZt4g3eNtvek52cPfmNqUkehD3BJoL7XeGbzPA+PX4=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: vpp9ZfYVM1koHhoNsltXEPpQVFDNQBHcTsGbXRgQXtdWJ_4z3_FOKQASjW3.G67IJhutejGN4eQ9lfkBiVq5fSg3OFpZ9mh4S96TUo_v_UM_CUg5bDmCn64CW7Aik_lOU5l0M6Spnzi1jVTOCXcHfRcAMjwTomleiCzV47gJ2977c3ZV2b.5urUjLaMUcJ8DcnGWSGoZ5Xn4ANswQbJfwzukx.QnvEs.HJkBVJfJQ_fEtocJnHRsDliobwWoDhEcttvZEFB1NEOypXQpNOkGqmOQFieA_dx7r5IuSYYyoc29YBzcEQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>
Subject: Re: [PATCH v2] gpiolib: allow poll(2) on gpio value
Date: Wed, 1 Jul 2009 16:05:30 -0700
User-Agent: KMail/1.9.10
Cc: Ben Nizette <bn@niasdigital.com>, linux-kernel@vger.kernel.org,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
References: <1244212590-15620-1-git-send-email-dg@emlix.com> <1244637376-24666-1-git-send-email-dg@emlix.com>
In-Reply-To: <1244637376-24666-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907011605.31154.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009, Daniel Glöckner wrote:
> Many gpio chips allow to generate interrupts when the value of a pin
> changes. This patch gives usermode application the opportunity to make
> use of this feature by calling poll(2) on the /sys/class/gpio/gpioN/value
> sysfs file. The edge to trigger can be set in the edge file in the same
> directory. Possible values are "none", "rising", "falling", and "both".

Looks pretty clean.  Comments from anyone else?

Presumably you tested this on Real Hardware(tm).  At one point
I thought sysfs poll() support looked a bit flakey ... was it
acting OK for you in the face of repeated triggers of events?


> Using level triggers is not possible with current sysfs as poll will
> not return if the value did not change. On the other hand edge triggers
> are relative to the last read by the application and not to the start
> of poll. So if there was an event between read and poll, poll will
> return immediately.
> 
> Changes compared to v1:
> - use workqueue to call sysfs_notify_dirent as it takes a spinlock

Do you mean "mutex"?  IRQ handing code can grab most
spinocks ... so long as they're irq-safe spinlocks.
Either way, if you need a mutex, add a comment saying
why the work_struct is needed.


> - move reconfiguration into separate function
> - allocate work_struct & co. as needed
> - wrap additional element in gpio_desc in #ifdef CONFIG_GPIO_SYSFS
> - rename poll_edge to edge
> - update Documentation/ABI/testing/sysfs-gpio as well
> - refer to poll syscall as "poll(2)"
> - use BIT() and define trigger mask for more readable expressions
> - whitespace changes

Even so, I have a few cosmetic comments.  :)

 
> Signed-off-by: Daniel Glöckner <dg@emlix.com>
> ---
>  Documentation/ABI/testing/sysfs-gpio |    1 +
>  Documentation/gpio.txt               |    7 ++
>  drivers/gpio/gpiolib.c               |  176 +++++++++++++++++++++++++++++++++-
>  3 files changed, 180 insertions(+), 4 deletions(-)
> 
> 
> Due to the need for a work_struct (16 bytes) per polled pin I created a
> poll_desc structure which also keeps the sysfs_dirent pointer. The memory
> requirement in gpio_desc is still 4 bytes. Is this acceptable?

It's more like "one pointer" not "4 bytes" ... although most
systems wanting this will be using 32-bit embedded CPUs.

So the additional *fixed* overhead is ARCH_NR_GPIOS*sizeof(void*),
or 1 KByte on most systems.


> I have looked into IDRs to store the pointer to the poll_desc structure.
> It appears the interface is not designed to allow allocation of specific
> numbers. One would have to rely on idr_get_new_above to return the number
> passed in. Another possibility would be to use some of the 25 unused bits
> of the flags variable to store the ID.

The reason to want to allocate about log2(ARCH_NR_GPIOS) of those
bits would be to save that 1KByte.  This stuff isn't critical path,
and most of that KByte will never be used... few systems will use
more than two GPIOs for such event triggering.  An IDR would take
less than 1KB in such a case, I think.

So the call isn't quite straightforward.  Maybe other folk have
some feedback.


>   Daniel
> 
> diff --git a/Documentation/ABI/testing/sysfs-gpio b/Documentation/ABI/testing/sysfs-gpio
> index 8aab809..80f4c94 100644
> --- a/Documentation/ABI/testing/sysfs-gpio
> +++ b/Documentation/ABI/testing/sysfs-gpio
> @@ -19,6 +19,7 @@ Description:
>  	/gpioN ... for each exported GPIO #N
>  	    /value ... always readable, writes fail for input GPIOs
>  	    /direction ... r/w as: in, out (default low); write: high, low
> +	    /edge ... r/w as: none, falling, rising, both
>  	/gpiochipN ... for each gpiochip; #N is its first GPIO
>  	    /base ... (r/o) same as N
>  	    /label ... (r/o) descriptive, not necessarily unique
> diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
> index 145c25a..68848b5 100644
> --- a/Documentation/gpio.txt
> +++ b/Documentation/gpio.txt
> @@ -524,6 +524,13 @@ and have the following read/write attributes:
>  		is configured as an output, this value may be written;
>  		any nonzero value is treated as high.
>  
> +	"edge" ... reads as either "none", "rising", "falling", or
> +		"both". Write these strings to select the signal edge(s)
> +		that will make poll(2) on the "value" file return.
> +
> +		This file exists only if the pin can be configured as an
> +		interrupt generating input pin.
> +
>  GPIO controllers have paths like /sys/class/gpio/chipchip42/ (for the
>  controller implementing GPIOs starting at #42) and have the following
>  read-only attributes:
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 51a8d41..e239975 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1,5 +1,6 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/interrupt.h>
>  #include <linux/irq.h>
>  #include <linux/spinlock.h>
>  #include <linux/device.h>
> @@ -40,6 +41,11 @@
>   */
>  static DEFINE_SPINLOCK(gpio_lock);
>  
> +struct poll_desc {
> +	struct work_struct	work;
> +	struct sysfs_dirent	*value_sd;
> +};
> +
>  struct gpio_desc {
>  	struct gpio_chip	*chip;
>  	unsigned long		flags;
> @@ -49,10 +55,18 @@ struct gpio_desc {
>  #define FLAG_RESERVED	2
>  #define FLAG_EXPORT	3	/* protected by sysfs_lock */
>  #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
> +#define FLAG_TRIG_FALL	5	/* trigger on falling edge */
> +#define FLAG_TRIG_RISE	6	/* trigger on rising edge */
> +
> +#define GPIO_TRIGGER_MASK (BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE))
>  
>  #ifdef CONFIG_DEBUG_FS
>  	const char		*label;
>  #endif
> +
> +#ifdef CONFIG_GPIO_SYSFS
> +	struct poll_desc	*pdesc;
> +#endif
>  };
>  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
>  
> @@ -188,10 +202,10 @@ static DEFINE_MUTEX(sysfs_lock);
>   *   /value
>   *      * always readable, subject to hardware behavior
>   *      * may be writable, as zero/nonzero
> - *
> - * REVISIT there will likely be an attribute for configuring async
> - * notifications, e.g. to specify polling interval or IRQ trigger type
> - * that would for example trigger a poll() on the "value".
> + *   /edge
> + *      * configures behavior of poll(2) on /value
> + *      * available only if pin can generate IRQs on input
> + *      * is read/write as "none", "falling", "rising", or "both"
>   */
>  
>  static ssize_t gpio_direction_show(struct device *dev,
> @@ -288,6 +302,151 @@ static ssize_t gpio_value_store(struct device *dev,
>  static /*const*/ DEVICE_ATTR(value, 0644,
>  		gpio_value_show, gpio_value_store);
>  
> +static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
> +{
> +	struct work_struct	*work = priv;
> +
> +	schedule_work(work);
> +	return IRQ_HANDLED;
> +}
> +
> +static void gpio_notify_sysfs(struct work_struct *work)
> +{
> +	struct poll_desc	*pdesc;
> +
> +	pdesc = container_of(work, struct poll_desc, work);
> +	sysfs_notify_dirent(pdesc->value_sd);
> +}
> +
> +static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
> +		unsigned long gpio_flags)
> +{
> +	unsigned long	irq_flags;
> +	int		ret, irq;
> +
> +	if ((desc->flags & GPIO_TRIGGER_MASK) == gpio_flags)
> +		return 0;
> +
> +	irq = gpio_to_irq(desc - gpio_desc);
> +	if (irq < 0)
> +		return -EIO;
> +
> +	if (desc->flags & GPIO_TRIGGER_MASK) {
> +		free_irq(irq, &desc->pdesc->work);
> +		cancel_work_sync(&desc->pdesc->work);
> +	}
> +
> +	desc->flags &= ~GPIO_TRIGGER_MASK;
> +
> +	if (!gpio_flags) {
> +		ret = 0;
> +		goto free_sd;
> +	}
> +
> +	irq_flags = IRQF_SHARED;
> +	if (test_bit(FLAG_TRIG_FALL, &gpio_flags))
> +		irq_flags |= IRQF_TRIGGER_FALLING;
> +	if (test_bit(FLAG_TRIG_RISE, &gpio_flags))
> +		irq_flags |= IRQF_TRIGGER_RISING;
> +	if (!desc->pdesc) {
> +		desc->pdesc = kmalloc(sizeof(struct poll_desc), GFP_KERNEL);
> +		if (!desc->pdesc) {
> +			ret = -ENOMEM;
> +			goto err_out;
> +		}
> +		desc->pdesc->value_sd = sysfs_get_dirent(dev->kobj.sd,
> +							 "value");
> +		if (!desc->pdesc->value_sd) {
> +			ret = -ENODEV;
> +			goto free_mem;
> +		}
> +		INIT_WORK(&desc->pdesc->work, gpio_notify_sysfs);
> +	}
> +
> +	ret = request_irq(irq, gpio_sysfs_irq, irq_flags,
> +			  "gpiolib", &desc->pdesc->work);
> +	if (ret)
> +		goto free_sd;
> +
> +	desc->flags |= gpio_flags;
> +	return 0;
> +
> +free_sd:
> +	sysfs_put(desc->pdesc->value_sd);
> +free_mem:
> +	kfree(desc->pdesc);
> +	desc->pdesc = NULL;
> +err_out:
> +	return ret;
> +}
> +
> +static const struct {
> +	const char *name;
> +	unsigned long flags;
> +} trigger_types[] = {
> +	{ "none",    0 },
> +	{ "falling", BIT(FLAG_TRIG_FALL) },
> +	{ "rising",  BIT(FLAG_TRIG_RISE) },
> +	{ "both",    BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE) },
> +};
> +
> +static ssize_t gpio_edge_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	ssize_t			status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +		status = -EIO;
> +	else {
> +		int i;
> +
> +		status = 0;
> +		for (i = 0; i < ARRAY_SIZE(trigger_types); i++)
> +			if ((desc->flags & GPIO_TRIGGER_MASK)
> +					== trigger_types[i].flags) {
> +				status = sprintf(buf, "%s\n",
> +						 trigger_types[i].name);
> +				break;
> +			}
> +	}
> +
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
> +static ssize_t gpio_edge_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	ssize_t			status;
> +	int			i;
> +
> +	for (i = 0; i < ARRAY_SIZE(trigger_types); i++)
> +		if (sysfs_streq(trigger_types[i].name, buf))
> +			break;

It'd be more clear to return -EINVAL for bogus "buf" *here* not
lower down, without taking the mutex.  Likely swapping a "goto"
for that "break" would let it be a net code shrink.


> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +		status = -EIO;
> +	else if (i == ARRAY_SIZE(trigger_types))
> +		status = -EINVAL;
> +	else {
> +		status = gpio_setup_irq(desc, dev, trigger_types[i].flags);
> +		if (!status)
> +			status = size;
> +	}
> +
> +	mutex_unlock(&sysfs_lock);
> +
> +	return status;
> +}
> +
> +static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
> +
>  static const struct attribute *gpio_attrs[] = {
>  	&dev_attr_direction.attr,
>  	&dev_attr_value.attr,
> @@ -481,6 +640,14 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>  			else
>  				status = device_create_file(dev,
>  						&dev_attr_value);
> +
> +			if (!status
> +			    && gpio_to_irq(gpio) >= 0
> +			    && (direction_may_change
> +				|| !test_bit(FLAG_IS_OUT, &desc->flags)))

Cosmetic:  use *only* tabs to indent.  All of them at least
one more level than the "status = ..." body of the test.


> +				status = device_create_file(dev,
> +						&dev_attr_edge);
> +
>  			if (status != 0)
>  				device_unregister(dev);
>  		} else
> @@ -527,6 +694,7 @@ void gpio_unexport(unsigned gpio)
>  
>  		dev = class_find_device(&gpio_class, NULL, desc, match_export);
>  		if (dev) {
> +			gpio_setup_irq(desc, dev, 0);
>  			clear_bit(FLAG_EXPORT, &desc->flags);
>  			put_device(dev);
>  			device_unregister(dev);
> -- 
> 1.6.1.3
> 
> 


