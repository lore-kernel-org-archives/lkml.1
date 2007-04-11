Return-Path: <linux-kernel-owner+w=401wt.eu-S1161062AbXDKCKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062AbXDKCKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 22:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030757AbXDKCKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 22:10:55 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:16152 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030754AbXDKCKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 22:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=J0TR8dcAkR3f8yZBwhMG2MiS30OsXLkvSL2+DK6dUG3T60p6coJ/pu6rGZ7KtWy2k6+BL/8YOQp12FiRZoZOZfdKtbhn7FZFwhv+Yq7tvJDYtRycqTXAzeMuzPTVSx48qye+fEbkF4q/KQnFu9j9fHEd08h4tn5rEujQcshKLNo=
Date: Wed, 11 Apr 2007 05:11:02 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <4010410762.20070411051102@gmail.com>
To: "Eric Miao" <eric.y.miao@gmail.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] gpiodev - API definitions
In-Reply-To: <f17812d70704101730x601eaa2cr96fe3502ceb20a0f@mail.gmail.com>
References: <774343545.20070411003058@gmail.com> <f17812d70704101730x601eaa2cr96fe3502ceb20a0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

Wednesday, April 11, 2007, 3:30:45 AM, you wrote:

> it looks ok, but I have several questions:

> 1. why should we bind this to platform_device, what if the gpio device
> is not actually a "platform_device", say, a I2C device, a SPI device or
> even a USB device?

  Good point. That was handhelds.org-specific "optimization", as we so
far mostly dealing with GPIO devices on platform bus, and could save
us writing "&pdev.dev". This must be changed to use struct device,
sure.

> 2. I still doubt the benefit of using of a structure for a gpio, isn't a gpio
> number not enough?

  Well, I replied to David's earlier post to LAKML after posting this,
and discussed both approach in more detail (and even more color). To
sum up, yes, we can use either structures for GPIOs, or scalar ints.
But both these approaches leads to some tradeoffs. Our argument is
that "scalar" (aka flat) approach leads to more tradeoffs - you need
to "flatten" your GPIO space first, and this is least evil, as indeed
this could be done using compile-time defines. But then you need to
"unflatten" it, and this happens at runtime, wasting cycles.

  Using structure GPIO ids skips this "flattening"/"unflattening"
(maybe multiplexing/demultiplexing are better terms) phases. Trade off
is necessity to write:

.gpio = {&gpio_device, GPIO_DEVICE_GPIO_1}

instead of:

#define BASE_FOR_GPIO_DEVICE_ON_MY_BOARD 1000
.gpio = BASE_FOR_GPIO_DEVICE_ON_MY_BOARD + GPIO_DEVICE_GPIO_1


  IMHO, pretty acceptable syntactical tradeoff ;-)

> 3. If one is going to use a GPIO, he has to initialize a "struct gpio"
> before that, how is he suppose to know the value for "gpio->gpio_dev"?

  Yes, so the target usage of GPIODEV API is to write
device-independent driver. Such driver simply shouldn't care what
device is used for GPIO - it should be able to accept any, - and how
exactly GPIO ops are performed.

  But something should care what actual GPIO device is being used. And
we know what's that - something which people call "platform code", but
I better call old good "machine definition file", to remove any
ambiguities. Such a definition is written for a specific machine, so
obviously you know what GPIO devices it has, and for what purpose pins
of them I used for. So, you have something like:

struct platform_device my_gpio_device = { .dev = {.name = "asic_foo"}};

struct some_driver_platform_data some_driver_pdata = {
...
   .pullup = {&my_gpio_device.dev, ASIC_FOO_GPIO_PULLUP},
...
}


  Important thing to note here is that structured GPIO id's are still
constants! Link-time constant, not compile-time, as scalar id's would
be, but still there's zero overhead at runtime.


> 4. how can we optimize to a direct register access instruction (e.g.
> to GPDR in PXA) for bit-banging operation (pardon me, I don't exactly
> remember the name for such operation, maybe bit-banging)

  Well, you should first decide what exactly you want. If you want to
do bit-banging on PXA, then well, - you don't need GPIODEV and its
polymorphic support at all! If you know GPIO# beforehand, just use
David's GPIO API - it will constant-optimize it to GPCR/GPSR access
rigth away.

  If you need to support arbitrary GPIO#, you can get better
frequency/throughput by skipping GPIO API still, like in the following
pseudocode:

  MASK = 1 << GPIO#;
  for (;count < SIZE; count--) {
    GPSR = MASK;
    nop;
    GPCR = MASK;
  }

  If you'd use GPIO API, it would recompute MASK on each call, wasting
your cycles.


  But now it's completely different story if you have a need to
write a driver which will bang bits on any GPIO of any device,
including such devices which you can't imagine at the time of driver's
writing at all - that's the GPIODEV estate. Obviously, for such general
usage it doesn't make too much sense to speak about optimization for a one
tiny specific device out of infinity of its domain - it's purpose is
exactly generality, not optimality, and it's well known that these
notions are reciprocals.

  If you still want super-optimal handling for PXA case, while being
able to still support anything else, solution is also known - have two
drivers, one fast and PXA-adhoc, another generic but slower, and use
extraneous logic to select which one to use.


  Back to GPIODEV's traits, it's still offers best performance which
can be achieved for infinitely extendable solution (within bounds of
the interface defined, of course), because it uses best known solution
for such problem (and such solution is simple and fast) - indirect
function call, and all data needed for such call are available right
away due to the magic of structural GPIO id's.

  In this regard, your implementation draft, which uses scalars and
looping to find out owning GPIO device/handler, pretty bad suited for
bit-banging at all: just consider that GPIO operation overhead in this
case is dependent on number of GPIO devices present. Add new one, and
your (supposedly) carefully tuned latencies and delay "float".

  David's code, which is essentially a simple hashing scheme, at least
has O(1) complexity in regard to number of GPIO devices present, but
still wastes precious cycles for useless things, like making a lookup
in hash table and subtracting GPIO base.


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

