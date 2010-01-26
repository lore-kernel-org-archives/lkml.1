Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536Ab0AZLkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab0AZLkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 06:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065Ab0AZLkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 06:40:04 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:35576 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0AZLkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 06:40:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=B5oESiHh2Da0YPWnO0qED8h52biQ5E2pYo9R3t4VPQ4Ary5vqFq/akeZ4QZgwuz6YE
         bNXjb6gHKre5ETnUFhDOWaQkWD5cGsLRQwVPOzkXRed2gHy8DYooYkTm7KVVkWxVHDUo
         CMHER3nzj0aJGFmKR2jiUgrpaPHnqYduQINMg=
MIME-Version: 1.0
In-Reply-To: <1264502668.4480.97.camel@utx.utx.cz>
References: <20100106071026.GD1382@ucw.cz> <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com> 
	<20100107065230.GA1303@ucw.cz> <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com> 
	<1264275669.9100.11.camel@utx.utx.cz> <1264286611.11766.49.camel@utx.utx.cz> 
	<f17812d71001251958t377e158bxc64aac0cb426110b@mail.gmail.com> 
	<1264500824.4480.79.camel@utx.utx.cz> <f17812d71001260220v5d03b0e1u1e3bc229827c37c8@mail.gmail.com> 
	<1264502668.4480.97.camel@utx.utx.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 26 Jan 2010 19:39:40 +0800
Message-ID: <f17812d71001260339h6184c82bj25ff13a168284c24@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/26 Stanislav Brabec <utx@penguin.cz>:
> Eric Miao wrote:
>> 2010/1/26 Stanislav Brabec <utx@penguin.cz>:
>
>> > Handling platform specific edge/level wake setup would only complicate
>> > the code. (In fact, even the PXA270 platform code does not exist yet -
>> > arch/arm/mach-pxa/mfp-pxa2xx.c:__mfp_config_gpio() is not capable to
>> > configure Power Manager Keyboard Wake-Up Enable Register (PKWR).)
>> That's why WAKEUP_ON_EDGE_* is introduced, no need for gpio-keys
>> to know this.
>
> But WAKEUP_ON_EDGE_* is impossible for GPIO 95,
> enable_irq_wake()/gpio_set_wake() returns EINVAL and disable_irq_wake()
> complains on "Unbalanced IRQ 191".
>

Now I see, but I don't know why disable_irq_wake() will complains about
unbalance since it should really manage it well.

A quick dirty solution would be the platform to call keypad_set_wake()
directly somewhere. Otherwise we have to let gpio_set_wake() to handle
those keypad GPIOs and to live together with keypad_set_wake() happily,
which is really difficult.

> In case of Zaurus, gpio_keys.c have to live with wakeup on level (PKWR)
> when using enable/disable_irq_wake().
>
>> > The problem affects gpio_keys: It is a driver implementing "one key per
>> > gpio". It now handles On/Off and lid switches on Zaurus. Lid switches
>> > are on "normal" GPIOs, On/Off switch is wired to PKWR capable GPIO.
>> Ain't On/Off switch one of the matrix key? And so SPITZ_GPIO_KEY_INT
>> could be used to handle that?
>
> No. On/Off is connected directly to GPIO 95. Other keys use strobe/sense
> matrix keypad.
>
> SPITZ_GPIO_KEY_INT is a bit unspecific. I think it means: Charger was
> inserted or key was pressed or On/Off was pressed.
>
>
>
> ________________________________________________________________________
> Stanislav Brabec
> http://www.penguin.cz/~utx/zaurus
>
>
