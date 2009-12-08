Return-Path: <linux-kernel-owner+w=401wt.eu-S966684AbZLHWKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966684AbZLHWKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966558AbZLHWKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:10:20 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:37390 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966535AbZLHWKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:10:20 -0500
Message-ID: <4B1ECEEE.3000209@bluewatersys.com>
Date: Wed, 09 Dec 2009 11:10:54 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz>
In-Reply-To: <20091208214658.GC4164@elf.ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Add GPIO support for HTC Dream.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> +int register_gpio_chip(struct gpio_chip *new_gpio_chip)
> +{
> +	int err = 0;
> +	struct gpio_chip *gpio_chip;
> +	int i;
> +	unsigned long irq_flags;
> +	/* Start/end indexes into chip array */
> +	unsigned int start, end;
> +	int size = (new_gpio_chip->end + 1 - new_gpio_chip->start) *
> +		   sizeof(new_gpio_chip->state[0]);
> +
> +	new_gpio_chip->state = kzalloc(size, GFP_KERNEL);
> +	if (new_gpio_chip->state == NULL) {
> +		printk(KERN_ERR "register_gpio_chip: failed to allocate state\n");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	start = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->start);
> +	end = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->end);
> +
> +	if (end >= gpio_chip_array_size) {
> +		/* New gpio chip array */
> +		struct gpio_chip **new_array;
> +		/* Size of gpio chip array */
> +		unsigned long array_size = end + 1;
> +
> +		new_array = kmalloc(array_size * sizeof(new_array[0]), GFP_ATOMIC);
> +		if (!new_array) {
> +			printk(KERN_ERR "register_gpio_chip: failed to allocate array\n");
> +			err = -ENOMEM;
> +			goto failed;
> +		}
> +		for (i = 0; i < gpio_chip_array_size; i++)
> +			new_array[i] = gpio_chip_array[i];
> +		for (i = gpio_chip_array_size; i < array_size; i++)
> +			new_array[i] = NULL;
> +		gpio_chip_array = new_array;
> +		gpio_chip_array_size = array_size;
> +	}
> +
> +	list_for_each_entry(gpio_chip, &gpio_chip_list, list) {
> +		if (gpio_chip->start > new_gpio_chip->end) {
> +			list_add_tail(&new_gpio_chip->list, &gpio_chip->list);
> +			goto added;
> +		}
> +		if (gpio_chip->end >= new_gpio_chip->start) {
> +			printk(KERN_ERR "register_gpio_source %u-%u overlaps with %u-%u\n",
> +			       new_gpio_chip->start, new_gpio_chip->end,
> +			       gpio_chip->start, gpio_chip->end);
> +			err = -EBUSY;
> +			goto failed;
> +		}
> +	}
> +
> +	list_add_tail(&new_gpio_chip->list, &gpio_chip_list);
> +added:
> +	for (i = start; i <= end; i++) {
> +		if ((!gpio_chip_array[i]) || gpio_chip_array[i]->start > new_gpio_chip->start)
> +			gpio_chip_array[i] = new_gpio_chip;
> +	}
> +failed:
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +	if (err)
> +		kfree(new_gpio_chip->state);
> +	return err;
> +}

This is still really screwy. Why are you creating your own version of
struct gpio_chip in addition to the one in include/asm-generic/gpio.h
(which you also appear to include in some places). It makes the code
extremely confusing. Other architectures use wrapper structures. Can you
have something like this instead:

	struct dream_gpio_chip {
		struct gpio_chip chip;

		/* Dream specific bits */
	};

The name of this function also needs to be changed to something less
generic since it is being exported globally.

I also think this function is doing way to much work for what it is.
Does it really need to be this complicated?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
