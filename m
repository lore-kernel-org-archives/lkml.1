Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325Ab0AZKUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0AZKUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536Ab0AZKUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:20:35 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:47581 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0AZKUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:20:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HTSO4yJdnSvC+oil5N87kOIr4FBdfMHlzmfflZ1oxn49qVI2N9RaqroMIv+k+nMhK/
         nNP9kgFfq7kS4F2+WF8YMOVhM0Aku71Eanfis7hsGM/WmYOKmx7yygpJMgcU+TsMAFFt
         8aElwiCn5uqY5lOTku02C8ChV9PodEkzRX0t8=
MIME-Version: 1.0
In-Reply-To: <1264500824.4480.79.camel@utx.utx.cz>
References: <20100106071026.GD1382@ucw.cz> <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com> 
	<20100107065230.GA1303@ucw.cz> <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com> 
	<1264275669.9100.11.camel@utx.utx.cz> <1264286611.11766.49.camel@utx.utx.cz> 
	<f17812d71001251958t377e158bxc64aac0cb426110b@mail.gmail.com> 
	<1264500824.4480.79.camel@utx.utx.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 26 Jan 2010 18:20:13 +0800
Message-ID: <f17812d71001260220v5d03b0e1u1e3bc229827c37c8@mail.gmail.com>
Subject: Re: gpio_keys and how PXA27x sets gpio_set_wake() (was Re: sharp 
	c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1)
To: Stanislav Brabec <utx@penguin.cz>
Cc: Andrew Morton <akpm@osdl.org>, thommycheck@gmail.com, dbaryshkov@gmail.com,
       dtor@mail.ru, arminlitzel@web.de, linux-input@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       "Rafael J. Wysocki" <rjw@sisk.pl>, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, Cyril Hrubis <metan@ucw.cz>,
       zaurus-devel@www.linuxtogo.org, omegamoon@gmail.com,
       Vojtech Pavlik <vojtech@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/26 Stanislav Brabec <utx@penguin.cz>:
> Eric Miao wrota:
>
>> I prefer 2) - the ugly and hardcoded setup in spitz_pm.c should really
>> be removed. That's why the gpio_set_wake() and keypad_set_wake()
>> are introduced.
>
> I am unsure, whether gpio_keys driver is interested in the way, how wake
> happens. I guess that is interested only in the fact, that wake
> happened.
>
> Handling platform specific edge/level wake setup would only complicate
> the code. (In fact, even the PXA270 platform code does not exist yet -
> arch/arm/mach-pxa/mfp-pxa2xx.c:__mfp_config_gpio() is not capable to
> configure Power Manager Keyboard Wake-Up Enable Register (PKWR).)
>

That's why WAKEUP_ON_EDGE_* is introduced, no need for gpio-keys
to know this.

> I talked to Vojtěch Pavlík and he told that 1 is correct: Follow
> include/linux/interrupt.h. Setting edge/level wake mode should be done
> in the platform file. The driver could use just irq_set_wake() and don't
> care about details. And irq_set_wake() should do something useful even
> for PKWR capable GPIO.
>

I don't mind if IRQF_TRIGGER_ will always be correct regarding the
wakeup edge/level settings in MFP, but honestly - I don't think so.

>> keypad_set_wake() is really specifically introduced for use by pxa27x_keypad
>> and no generic GPIO stuffs. So it's really annoying a GPIO will use
>> the PKWR as a wakeup GPIO, I'd recommend one still get this hard coded
>> into the platform file, with combination of WAKEUP_ON_LEVEL_HIGH (which
>> is specifically designed for keypad GPIOs) and keypad_set_wake().
>
> Well, keypad_set_wake() seems to be possibly broken for GPIO 38. Imagine
> a device, that has a small keypad, but GPIO 38 has a different purpose
> that requires an edge triggered wakeup (PWER). I think that
> keypad_set_wake() reprograms it to PKWR.

Unless someone specifies that by

GPIO38_GPIO | WAKEUP_ON_LEVEL_HIGH,

keypad_set_wake() will never try to enable the bit in PKWR.

>
> The problem affects gpio_keys: It is a driver implementing "one key per
> gpio". It now handles On/Off and lid switches on Zaurus. Lid switches
> are on "normal" GPIOs, On/Off switch is wired to PKWR capable GPIO.
>

Ain't On/Off switch one of the matrix key? And so SPITZ_GPIO_KEY_INT
could be used to handle that?

>> The spitz, however, is doing a good job on this though it's using a GPIO
>> emulated matrix keypad, that there is a separate SPITZ_GPIO_KEY_INT,
>> which triggers whenever there is any key press on this matrix (I don't
>> know how that's designed in HW, but it seems to do that job), and
>> which can be setup as a GPIO wakeup.
>
> SPITZ_GPIO_KEY_INT happens if AC adapter is connected or key is pressed.
> Surprisingly, the key press logic is part of NAND flash controller CPLD.
> SPITZ_GPIO_KEY_INT==0 - it makes possible to wake Zaurus even from deep
> sleep by any key press. It would be impossible only with PKWR.
>
> I guess that this and implementation of keypad_set_wake() is a reason,
> why most devices suspend and resume correctly even if the irq_set_wake()
> refuses to configure wake and the warning is only visible symptom.
