Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYGYUoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYGYUoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYGYUor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:44:47 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64675 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYGYUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:44:46 -0400
Date: Fri, 25 Jul 2008 13:38:12 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Grant Likely <grant.likely@secretlab.ca>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
In-Reply-To: <20080718100549.GA28741@polina.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp>
 <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru>
 <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca>
 <20080717152006.GA26120@polina.dev.rtsoft.ru>
 <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com>
 <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
 <20080717234201.GA15745@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp>
 <20080718100549.GA28741@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are my patches for the OF bindings.  The first is just a tiny change to
the leds code to silence a warning.  The second is the real patch.

The leds-gpio driver gets two sub-options in Kconfig, one for platform
device support and one for openfirmware platform device support.

There is support for setting an LED trigger.  I didn't include support for
active-low or initial brightness, but I think those would be good features
to add.  See below for more on that.

Since each device node can describe multiple leds, I used "gpio-leds"
instead of "gpio-led" for the compatible property.

Examples of the dts syntax:

leds {
         compatible = "gpio-leds";
         hdd {
                 label = "IDE activity";
                 gpios = <&mcu_pio 0 0>;
                 function = "ide-disk";
         };
};

run-control {
         compatible = "gpio-leds";
         red {
                 gpios = <&mpc8572 6 0>;
         };
         green {
                 gpios = <&mpc8572 7 0>;
         };
}


On Fri, 18 Jul 2008, Anton Vorontsov wrote:
> Later I tried to use aliases for default-trigger.
>
> http://ozlabs.org/pipermail/linuxppc-dev/2008-June/057244.html

I doesn't seem to me that the alias method will work very well.  If I want
an LED that starts on, I need to add code to the kernel to support an
"led-on-while-kernel-boots" alias?  And if I want red & green leds to flash
while booting, I need to add aliases "led-flashing-while-kernel-boots-1" and
"led-flashing-while-kernel-boots-2", since you can't assign two leds to the
same alias?

> As for linux,default-brightness... we don't need this since now we
> have default-on trigger.

Except we can't use triggers....

There is an issue with the default-on trigger, besides requiring led
triggers be turned on and the extra code that needs.  It causes the led to
have a glitch in it.  Suppose the LED is already on from reset or the boot
loader.  When the gpio is allocated, it's allocated with an initial value of
off.  Then, later, it's turned back on when the trigger runs.  But say the
trigger doesn't run?

Here's a real example.  I have an LED that comes on the board powers on.  It
was supposed to turn off when the kernel has finished booting.  But suppose
the kernel panics between the gpio getting lowered when the led is added and
the trigger turning it back on?  Now the LED is off and it appears the
problem happened after the kernel finished booting, but really it happened
during the kernel boot.  In an embedded system with no console, that's quite
a bit of misinformation.  It can be entirely avoided by changing just three
lines of code with the leds-gpio driver to add an option to start the led
on.

It could also be the case that the gpio the led is on also triggers some
other piece of hardware.  An alarm that's on the same line as a fault led
for example.  The glitch created by the default-on trigger could be
unacceptable in that case.
