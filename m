Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZLJTsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZLJTsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZLJTsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:48:36 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:56017 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752307AbZLJTsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:48:35 -0500
Message-ID: <4B2150B7.3040207@bluewatersys.com>
Date: Fri, 11 Dec 2009 08:49:11 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz>
In-Reply-To: <20091210172458.GJ19454@elf.ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> This is still really screwy. Why are you creating your own version of
>>> struct gpio_chip in addition to the one in include/asm-generic/gpio.h
>>> (which you also appear to include in some places). It makes the code
>>> extremely confusing. Other architectures use wrapper structures. Can you
>>> have something like this instead:
>>>
>>> 	struct dream_gpio_chip {
>>> 		struct gpio_chip chip;
>>>
>>> 		/* Dream specific bits */
>>> 	};
>>>
>>> The name of this function also needs to be changed to something less
>>> generic since it is being exported globally.
>>>
>>> I also think this function is doing way to much work for what it is.
>>> Does it really need to be this complicated?
>> Further to this, I think it is worth doing the work to make this gpiolib
>> now. Most of the other ARM chips now support gpiolib, so it would seem a
>> bit of a step backwards to start adding new chips which don't. I think
>> that adding the gpiolib support will also cleanup the mess that is
>> register_gpio_chip, since this is all already handled by the gpiolib core.
> 
> I tried going through drivers/gpio/gpiolib.c and it seems to be a lot
> of code -- mostly sysrq interface to userland. I'm not sure how much
> code could be shared... 

Its not much work to go from generic gpio (which you have now) to
gpiolib, and in the end it will make the code simpler, more extensible,
you get sysfs access for free, etc. You will need to wrap up your
gpio_chip struct as I suggested:

struct msm_gpio_chip {
	struct gpio_chip;
	
	/* MSM/Dream/Trout(?) bits */
};
#define to_msm_gpio_chip(c, container_of(c, struct msm_gpio_chip, chip)

As an aside, I don't quite understand the naming conventions here. Is
the gpio stuff generic to the MSM chip, or specific to the Dream/Trout
board? It would be good if the gpio implementation could be completely
generic to the chip, and all the board specific bits be kept in the
board specific files.

You gpio_set, get, direction, etc functions become static:

static gpio_set_value(struct gpio_chip *chip, unsigned offset, int val)
{
	struct msm_gpio_chip *msm_chip = to_msm_gpio_chip(chip);
	
	...
}

and you have a descriptor for your chip (or an array of these if you
want multiple banks of gpios):

static struct msm_gpios = {
	.chip = {
		.label		= "msm_gpio",
		.set		= gpio_set_value,
		...
	},
	/* MSM specific bits */
};

void __init msm_init_gpio(void)
{
	gpiochip_add(&msm_gpios);

	/* Other setup, gpio irqs, etc */
}

Your msm_register_gpio_chip function should disappear and your
gpio_request and gpio_free functions can either be removed, or at least
become much simpler since gpiolib already handles most of what those
functions are doing.

Have a look at the other ARM chips which have gpiolib support for a
guide. The ep93xx and at91 ones which I did are reasonably simple to
follow, and also demonstrate how to use the debugfs hooks which you may
find useful. Also look at Documentation/gpio.txt which has some more
detailed information on gpiolib.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
