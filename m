Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYJ0Tqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYJ0Tqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYJ0Tq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:46:27 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:31048 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751889AbYJ0Tq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:46:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rxN41p5WGSClg5+WFx3klcYfta7AIk8u3y8Jnh2QPJ/gvu/PEhcNN5jUQyFVZH4oPJyNPCOuYexf5nl337qcsNAJC5dIpTNH+bs4rAeuRM1PQ2vet3J2wOB4gx/Ex00UMQCQ/M6Q5vWKWj6jjjYTnV3dZ23e4N1t9Rnb0JJCXmw=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH v2 RESEND] gpiolib: Add pin change notification
Date: Mon, 27 Oct 2008 12:46:21 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-embedded" <linux-embedded@vger.kernel.org>
References: <1224543007.3954.71.camel@moss.renham>
In-Reply-To: <1224543007.3954.71.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271246.22149.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way ... I noticed some new use cases for this sort of mechanism.
In the OMAP git tree, say the copy at

  http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git

Have a look at arch/arm/plat-omap/gpio-switch.c ... current users
include mach-omap2/board-n800.c and mach-omap1/board-palmte.c (in
that tree), and report things like headphone jack insertion.  Some
of that fanciness seems like it shouldn't live in-kernel.

I'll be glad to see the need for that driver vanish (except for
the need to upgrade userspace, sigh), because of a more generic
mechanism existing.  :)


On Monday 20 October 2008, Ben Nizette wrote:
> This adds pin change notification to the gpiolib sysfs interface. It
> requires 16 extra bytes in gpio_desc iff CONFIG_GPIO_SYSFS which in turn
> means, eg, 4k of .bss usage on AVR32.

Which seems quite problematic to me, for a mechanism that will
in most cases not be used and certainly doesn't have the same
level of fast-path considerations as gpio get/set operations.

How about using a <linux/idr.h> table to map GPIOs to some
notification structure ... and only when such notifications
have been configured?  A "busy" system might have one IDR
and a handful of 16 byte structs ... lots less than 4KB, and
coming out of kmalloc heaps (and thus barely observable).


> Due to limitations in sysfs, this 
> patch makes poll(2) and friends work as expected on the "value"
> attribute, though reads on "value" will never block and there is no
> facility for async reads and writes.

I like poll() and friends working, and the rest seems like
it's not something to worry about here.


Have you thought about how to leverage the interrupt signals on
chips like the pcf857x and pca953x, which have dedicated "pin
changed" signals?  They're nothing like the real interrupts,
with per-pin irq status and disable masks, found in most
SOC-integrated GPIO banks (and in fancier discrete ones).
So they seem to me like bad matches for genirq... though I
might be persuaded otherwise.

Effectively, those IRQ are "poll now" advice ... advice that
is not yet used.  (The IRQs all seem to stay active until the
GPIO bank status is read, FYI, so you can easily imagine how
to fake out some IRQ-ish mechanism.)



> --- a/Documentation/gpio.txt
> +++ b/Documentation/gpio.txt
> @@ -529,6 +529,21 @@ and have the following read/write attrib
>  		is configured as an output, this value may be written;
>  		any nonzero value is treated as high.
>  
> +	"notify" ... Selects a method for the detection of pin change
> +		events.  This can be written or read as one of "none",
> +		"irq" or a number.  If "none", no detection will be
> +		done, if "irq" then the change detection will be done
> +		by registering an interrupt handler on the line given
> +		by gpio_to_irq for that gpio.  If a number is written,
> +		the gpio will be polled for a state change every n
> +		milliseconds where n is the number written.  The
> +		minimum interval is 10 milliseconds.

That "10 milliseconds" seems a bit arbitrary.  By analogy to the
RTC framework's handling of periodic IRQs, maybe this should be a
limit that a privileged user can change.

IMO it's worth noting that polling modes should not be used if
IRQs could work ... and that polling *will* miss all changes
that happen between polls.


> +	"notify_filter" ... This can be written and read as one of
> +		"rising", "falling" or "both".  If "rising", only
> +		rising edges will be reported, similarly for "falling"
> +		and "both".

See below ... maybe writing those values to "notify" should be allowed,
for IRQ-driven notification.  Then this wouldn't be needed except
when polling.  


> +
>  GPIO controllers have paths like /sys/class/gpio/chipchip42/ (for the
>  controller implementing GPIOs starting at #42) and have the following
>  read-only attributes:
> @@ -549,6 +564,39 @@ gpiochip nodes (possibly in conjunction 
>  the correct GPIO number to use for a given signal.
>  
>  
> +Pin Change Notification
> +-----------------------
> +The "value" attribute of a gpio is pollable.  For this to work, you
> +must have set up the notify attribute of that gpio to the type of
> +detection suitable for the underlying hardware.
> +
> +If the hardware supports interrupts on both edges and the gpio to
> +interrupt line mapping is unique, you should write "irq" to the notify
> +attribute.

Suppose it only supports one edge (unlikely, to be sure)
and that's the edge that's of interest?  Maybe you should
allow writing just "falling" (or "rising") to "notify" in
those cases.

I don't see what you mean by gpio_to_irq() being unique.
Of course it is -- by definition, that can't return more
than one value!


> +If the hardware doesn't support this, or you're unsure, you can write
> +a number to the notify attribute.  This number is the delay between
> +successive polls of the gpio state in milliseconds.  You may not poll
> +more often than 10ms intervals.

Surely if the hardware doesn't support rising/falling/both
edge IRQ driven notifications, writing that value to the
"notify" attribute will fail?  There should be no need for
any "unsure" option here... please restructure these user
visible attributes to make sure "unsure" isn't an option.

This would seem to be the best place to explain why it's
not a good idea to use polling.  (System overhead, certain
loss ove some events, etc.)


> +
> +You must use poll mode if communication with the gpio's chip requires
> +sleeping.  This is the case if, for example, the gpio is part of a
> +I2C or SPI GPIO expander.

Strike that ... surely the issue is that when IRQs can't
be used, polling is the *only* other option?

And there's nothing preventing I2C or SPI based expanders
from presenting IRQs.  (Other than current messiness imposed
by the genirq framework, some of which will be resolved over
time.)  The drivers/gpio/twl4030-gpio.c code certainly presents
IRQs right now, over I2C.

The fact that some gpio chips, like those pcf857x ones, provide
"poll me now" advice -- which we don't currently use -- instead
of real interrupt controllers is perhaps deceptive.


> +By default, both rising and falling edges are reported.  To filter
> +this, you can write one of "rising" or "falling" to the notify_filter
> +attribute.  To go back to being notified of both edge changes, write
> +"both" to this attribute.

If the "notify" attribute accepts rising/falling/both,
then this paragraph can be removed.


> +Once the notification has been set up, you may use poll(2) and friends
> +on the "value" attribute.  This attribute will register as having new
> +data ready to be read if and only if there has been a state change
> +since the last read(2) to the "value" attribute.

Not entirely true:  (a) as noted, polling will overlook changes that
happen between poll intervals, and (b) even for irq-driven notifications,
the state may have changed back.

Best to say the notification is only a hint that the "value" might now
be different.  It would be wrong for any userspace code to remember
the last value, expect that the current value is different, and then
act accordingly... instead of checking the current value.

 
> +
> +Note that unlike a regular device file, a read on the "value" attribute
> +will never block whether or not there's new data to be read.
> +
> +
>  Exporting from Kernel code
>  --------------------------
>  Kernel code can explicitly manage exports of GPIOs which have already been
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1,6 +1,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/irq.h>
> +#include <linux/interrupt.h>
>  #include <linux/spinlock.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
> @@ -49,13 +50,35 @@ struct gpio_desc {
>  #define FLAG_RESERVED	2
>  #define FLAG_EXPORT	3	/* protected by sysfs_lock */
>  #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
> +#define ASYNC_MODE_IRQ	5	/* using interrupts for async notification */
> +#define ASYNC_MODE_POLL	6	/* using polling for async notification */
> +#define ASYNC_RISING	7	/* will notify on rising edges */
> +#define ASYNC_FALLING	8	/* will notify on falling edges */

I suspect all you'd need here is a single flag to indicate
that there's an IDR entry for this GPIO ...

>  
>  #ifdef CONFIG_DEBUG_FS
>  	const char		*label;
>  #endif
> +
> +#ifdef CONFIG_GPIO_SYSFS
> +	struct device		*dev;

This "dev" would be the exported sysfs node for the GPIO?

> +	struct poll_desc	*poll;
> +
> +	/* Poll interval in jiffies, here (rather than in struct poll_desc
> +	 * so the user can change the value no matter what their current
> +	 * notification mode is */
> +	long			timeout;
> +
> +	/* Last known value */
> +	int			val;

... and these four elements would move to a struct that's
stored in the IDR.


> +#endif
>  };
>  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
>  
> +struct poll_desc {
> +	struct delayed_work	work;
> +	unsigned		gpio;
> +};
> +
>  static inline void desc_set_label(struct gpio_desc *d, const char *label)
>  {
>  #ifdef CONFIG_DEBUG_FS
> @@ -184,12 +207,56 @@ static DEFINE_MUTEX(sysfs_lock);
>   *   /value
>   *      * always readable, subject to hardware behavior
>   *      * may be writable, as zero/nonzero
> - *
> - * REVISIT there will likely be an attribute for configuring async
> - * notifications, e.g. to specify polling interval or IRQ trigger type
> - * that would for example trigger a poll() on the "value".
> + *   /notify
> + *      * read/write as "irq", numeric or "none"
> + *   /notify_filter
> + *      * read/write as "rising", "falling" or "both"

Whoo!  Someone actually updated a comment when changing the
behavior being commented on!  :)

Note that Documentation/ABI/testing/sysfs-gpio would need
updating here too.


>   */
>  
> +struct poll_desc *work_to_poll(struct work_struct *ws)
> +{
> +	return container_of((struct delayed_work *)ws, struct poll_desc, work);
> +}
> +
> +void gpio_poll_work(struct work_struct *ws)
> +{
> +	struct poll_desc	*poll = work_to_poll(ws);
> +
> +	unsigned		gpio = poll->gpio;
> +	struct gpio_desc	*desc = &gpio_desc[gpio];
> +
> +	int new = gpio_get_value_cansleep(gpio);
> +	int old = desc->val;
> +
> +	if ((new && !old && test_bit(ASYNC_RISING, &desc->flags)) ||
> +	    (!new && old && test_bit(ASYNC_FALLING, &desc->flags)))
> +		sysfs_notify(&desc->dev->kobj, NULL, "value");
> +
> +	desc->val = new;
> +	schedule_delayed_work(&poll->work, desc->timeout);
> +}
> +
> +static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
> +{
> +	struct gpio_desc *desc = dev_id;
> +	int gpio = desc - gpio_desc;
> +	int new, old;
> +
> +	if (!gpio_is_valid(gpio))
> +		return IRQ_NONE;

I'd make the data be the notification struct stored in the IDR, with
the invariant that the IDR entry is NULL for all non-requested GPIOs...
and for all GPIOs for which notification hasn't been explicitly enabled.
(So this IRQ handler wouldn't need that flavor of error checking.)


> +
> +	new = gpio_get_value(gpio);
> +	old = desc->val;
> +
> +	if ((new && !old && test_bit(ASYNC_RISING, &desc->flags)) ||
> +	    (!new && old && test_bit(ASYNC_FALLING, &desc->flags)))
> +		sysfs_notify(&desc->dev->kobj, NULL, "value");
> +
> +	desc->val = new;
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static ssize_t gpio_direction_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> @@ -284,9 +351,162 @@ static ssize_t gpio_value_store(struct d
>  static /*const*/ DEVICE_ATTR(value, 0644,
>  		gpio_value_show, gpio_value_store);
>  
> +static ssize_t gpio_notify_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	ssize_t ret;
> +
> +	mutex_lock(&sysfs_lock);

This might be "if the IDR lookup returns NULL, return 'none' else ..."


> +
> +	if (test_bit(ASYNC_MODE_IRQ, &desc->flags))
> +		ret = sprintf(buf, "irq\n");
> +	else if (test_bit(ASYNC_MODE_POLL, &desc->flags))
> +		ret = sprintf(buf, "%ld\n", desc->timeout * 1000 / HZ);
> +	else
> +		ret = sprintf(buf, "none\n");
> +
> +	mutex_unlock(&sysfs_lock);
> +	return ret;
> +}
> +
> +static ssize_t gpio_notify_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	unsigned		gpio = desc - gpio_desc;
> +	ssize_t			status = 0;
> +	int			new;
> +	long			value;
> +
> +	mutex_lock(&sysfs_lock);

This might be "if the IDR lookup returns NULL, initialize..."

> +
> +	if (sysfs_streq(buf, "irq"))
> +		new = ASYNC_MODE_IRQ;
> +	else if (sysfs_streq(buf, "none"))
> +		new = -1;

... that might scrub out the IDR entry ...


> +	else {
> +		status = strict_strtol(buf, 0, &value);
> +
> +		if (status || value < 10) {
> +			status = -EINVAL;
> +			goto out;
> +		}
> +
> +		/* value will be in ms, convert to jiffies. */
> +		desc->timeout = DIV_ROUND_UP(value * HZ, 1000);
> +		new = ASYNC_MODE_POLL;
> +	}
> +
> +	if (test_and_clear_bit(ASYNC_MODE_IRQ, &desc->flags))
> +		free_irq(gpio_to_irq(gpio), desc);
> +	else if (test_and_clear_bit(ASYNC_MODE_POLL, &desc->flags)) {
> +		BUG_ON(!desc->poll);
> +
> +		cancel_delayed_work(&desc->poll->work);
> +		kfree(desc->poll);
> +	}
> +
> +	if (new == ASYNC_MODE_IRQ) {
> +		if (desc->chip->can_sleep) {
> +			/* -EINVAL probably isn't appropriate here,
> +			 * what's code for "not supported by
> +			 * underlying hardware"? */
> +			status = -EINVAL;
> +			goto out;
> +		}
> +
> +		desc->val = gpio_get_value(gpio);
> +
> +		/* REVISIT: We always request both edges then filter in the
> +		 * irq handler.  How many devices don't support this..?? */
> +		status = request_irq(gpio_to_irq(gpio), gpio_irq_handler,
> +				     IRQF_SHARED | IRQF_TRIGGER_RISING |
> +						IRQF_TRIGGER_FALLING,
> +				     "gpiolib", desc);

Can you avoid requesting the IRQ until something actually needs the
notification?  Like by receiving a poll() or fasync() call for the
"value" attribute.

Ditto starting the polling timer, below.  Especially in that case,
I don't like the notion that something could start a fast timer
that nothing is really waiting for, needlessly increase the speed
with which the battery drains.

But I suspect you'll tell me sysfs won't cooperate here.  :(


> +	} else if (new == ASYNC_MODE_POLL) {
> +
> +		desc->poll = kmalloc(sizeof(struct poll_desc), GFP_KERNEL);
> +		if (!desc->poll) {
> +			status = -ENOMEM;
> +			goto out;
> +		}
> +
> +		desc->poll->gpio = gpio;
> +
> +		desc->val = gpio_get_value_cansleep(gpio);
> +
> +		INIT_DELAYED_WORK(&desc->poll->work, gpio_poll_work);
> +		schedule_delayed_work(&desc->poll->work, desc->timeout);
> +	}
> +
> +	if (new >= 0 && !status)
> +		set_bit(new, &desc->flags);
> +
> +out:
> +	if (status)
> +		dev_dbg(dev, "gpio notification mode set fail, err %d\n",
> +			(int)status);
> +
> +	mutex_unlock(&sysfs_lock);
> +	return status ? : size;
> +}
> +
> +static const DEVICE_ATTR(notify, 0644,
> +		gpio_notify_show, gpio_notify_store);
> +
> +static ssize_t gpio_notify_filter_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	ssize_t			status;
> +
> +	mutex_lock(&sysfs_lock);

This might be "if the IDR lookup returns NULL, return 'none' else ..."


> +
> +	if (test_bit(ASYNC_FALLING, &desc->flags) &&
> +			test_bit(ASYNC_RISING, &desc->flags))
> +		status = sprintf(buf, "both\n");
> +	else if (test_bit(ASYNC_RISING, &desc->flags))
> +		status = sprintf(buf, "rising\n");
> +	else
> +		status = sprintf(buf, "falling\n");
> +
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
> +static ssize_t gpio_notify_filter_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	ssize_t			status = 0;
> +
> +	mutex_lock(&sysfs_lock);

This might be "if the IDR lookup returns NULL, fail ..."


> +
> +	if (sysfs_streq(buf, "rising")) {
> +		set_bit(ASYNC_RISING, &desc->flags);
> +		clear_bit(ASYNC_FALLING, &desc->flags);
> +	} else if (sysfs_streq(buf, "falling")) {
> +		clear_bit(ASYNC_RISING, &desc->flags);
> +		set_bit(ASYNC_FALLING, &desc->flags);
> +	} else if (sysfs_streq(buf, "both")) {
> +		set_bit(ASYNC_RISING, &desc->flags);
> +		set_bit(ASYNC_FALLING, &desc->flags);
> +	} else
> +		status = -EINVAL;
> +
> +	mutex_unlock(&sysfs_lock);
> +	return status ? : size;
> +}
> +
> +static const DEVICE_ATTR(notify_filter, 0644,
> +		gpio_notify_filter_show, gpio_notify_filter_store);
> +
>  static const struct attribute *gpio_attrs[] = {
>  	&dev_attr_direction.attr,
>  	&dev_attr_value.attr,
> +	&dev_attr_notify.attr,
> +	&dev_attr_notify_filter.attr,
>  	NULL,
>  };
>  
> @@ -398,6 +618,17 @@ static ssize_t unexport_store(struct cla
>  		status = 0;
>  		gpio_free(gpio);
>  	}
> +
> +	if (test_and_clear_bit(ASYNC_MODE_IRQ, &gpio_desc[gpio].flags))
> +		free_irq(gpio_to_irq(gpio), &gpio_desc[gpio]);
> +
> +	if (test_and_clear_bit(ASYNC_MODE_POLL, &gpio_desc[gpio].flags)) {
> +		BUG_ON(!gpio_desc[gpio].poll);
> +
> +		cancel_delayed_work(&gpio_desc[gpio].poll->work);
> +		kfree(gpio_desc[gpio].poll);
> +	}

This might be "if the IDR lookup doesn't return NULL, scrub it out ..."


> +
>  done:
>  	if (status)
>  		pr_debug("%s: status %d\n", __func__, status);
> @@ -479,6 +710,12 @@ int gpio_export(unsigned gpio, bool dire
>  			status = -ENODEV;
>  		if (status == 0)
>  			set_bit(FLAG_EXPORT, &desc->flags);
> +
> +		desc->dev = dev;
> +		/* 100ms default poll interval */
> +		desc->timeout = HZ / 10;
> +		set_bit(ASYNC_RISING, &desc->flags);
> +		set_bit(ASYNC_FALLING, &desc->flags);

I'd rather see the notification infrastructure kick on only when
it's explicitly requested by userspace ... so the cost of this
mechanism is just some code and an IDR, except when it's in use.

Plus, a default polling rate of 10 Hz is pretty unfriendly, on
systems where NO_HZ would otherwise cause a tick rate that's
a lot lower.  Best IMO to just require userspace to specify a
poll rate when that's required.


>  	}
>  
>  	mutex_unlock(&sysfs_lock);
> @@ -626,7 +863,6 @@ static int __init gpiolib_sysfs_init(voi
>  	}
>  	spin_unlock_irqrestore(&gpio_lock, flags);
>  
> -
>  	return status;
>  }
>  postcore_initcall(gpiolib_sysfs_init);


Minor nit:  the Kconfig for GPIO_SYSFS will deserve updating
if this mechanism is added.  It doesn't currently mention
such notifications... 

