Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYJUUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYJUUcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYJUUbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:31:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbYJUUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:31:49 -0400
Date: Tue, 21 Oct 2008 13:31:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Nizette <bn@niasdigital.com>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] gpiolib: Add pin change notification
Message-Id: <20081021133106.be5cc01c.akpm@linux-foundation.org>
In-Reply-To: <1224543007.3954.71.camel@moss.renham>
References: <1224543007.3954.71.camel@moss.renham>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 09:50:06 +1100
Ben Nizette <bn@niasdigital.com> wrote:

> 
> This adds pin change notification to the gpiolib sysfs interface. It
> requires 16 extra bytes in gpio_desc iff CONFIG_GPIO_SYSFS which in turn
> means, eg, 4k of .bss usage on AVR32.  Due to limitations in sysfs, this
> patch makes poll(2) and friends work as expected on the "value"
> attribute, though reads on "value" will never block and there is no
> facility for async reads and writes.
> 
>
> ...
>
> +struct poll_desc *work_to_poll(struct work_struct *ws)

static

> +{
> +	return container_of((struct delayed_work *)ws, struct poll_desc, work);
> +}
> +
> +void gpio_poll_work(struct work_struct *ws)

static

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
> +
> +	new = gpio_get_value(gpio);
> +	old = desc->val;
> +
> +	if ((new && !old && test_bit(ASYNC_RISING, &desc->flags)) ||
> +	    (!new && old && test_bit(ASYNC_FALLING, &desc->flags)))
> +		sysfs_notify(&desc->dev->kobj, NULL, "value");

eekeekeek!  sysfs_notify() does mutex_lock() and will die horridly if
called from an interrupt handler.

You should have got a storm of warnings when runtime testing this code.
Please ensure that all debug options are enabled when testing code. 
Documentation/SubmitChecklist has help.

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

<panics>

oh, sysfs_lock is a gpiolib-local thing, not a sysfs-core thing. 
Crappy name.


