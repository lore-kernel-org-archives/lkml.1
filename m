Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZGVWdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZGVWdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZGVWdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:33:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51572 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbZGVWdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=alAelQ4Y9aC2ISTVMQa6ClGcncygkCCM+nMY2wCwCT84Z/pvc6LRoxGaQgWaEa3QPg
         MEYlPOtsv/rTo63Xqi7Y6NWZcfS/1UaaL+1afYn9xKm/OjZMXE6EGar1aWF4iImngq1B
         cnaNM7ZaXCzV5XlaogffXUW/YoxwLonaoZffg=
MIME-Version: 1.0
In-Reply-To: <4A6701E3.3000204@csr.com>
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
	 <4A6701E3.3000204@csr.com>
Date: Thu, 23 Jul 2009 00:33:13 +0200
Message-ID: <63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com>
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <pierre@ossman.eu>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/22 David Vrabel <david.vrabel@csr.com>:

> Linus Walleij wrote:

> I'm not sure this is the right approach.

It's been discussed a bit back and forth for a few months, but let's keep
at it...

> 1. With some controllers (e.g., PXA270 I think) turning the clock on and
> off is slow.  This means if you're doing back-to-back commands you
> should leave the clock on for best performance.

OK, when I've been testing this using the default workqueue and
schedule_work() covered these cases. Back-on-back commands
seemingly doesn't allow the timeout work to schedule, but I might be
overseeing the case of several CPU:s there though :-/

> I think there needs to
> be a higher level active/idle knob for the user of the card (be it the
> block driver or an SDIO function driver) to control whether to idle the
> bus clock or controller.

The code doesn't tell the driver to idle the controller, it sets ios.clock
to zero to give the host driver the *opportunity* to turn controller clocks
off when it's OK from the MMC spec to do so (after 8 MCI cycles), the
driver doesn't *have* to do that. It can add addtional logic for different
HW. So it's only about the bus clock (whereas my patch to mmci.c takes
advantage of the possibility to also gate the block clock).

> 2. Some controllers cannot detect SDIO interrupts if the clock is
> stopped.  There should either be a distinction between clock off and
> clock idle.

This is on the driver level, not in the core. The core doesn't tell whether
to clock off or not, it only tells the device driver that the MCI clk doesn't
need to run by setting it to 0. Clearly, some hardware cannot exploit
that, but some (like PL180, OMAP and Atmel) can, easily.

There can possibly also be HW that can turn of MCI clk but not the
clock to the HW block itself, that is fine with the implementation.

> 3. Regardless of point 1 above.  Using a workqueue item in this way
> seems overkill.  Consider using a timer and simply calling mod_timer()
> at the start of every command.  When the timer expires, idle the clock.
>  You will probably need a "command in progress" bit to ensure you don't
> idle the clock if the timer expires in the middle of a command.

I would agree if I created a new workqueue, but the timeout of this
particular workqueue is unimportant and that's why I'm using the
global workqueue and just schedule_work(). This means no extra
overhead, no extra thread and basically does the exact same thing.

But I could experiment with switching that for a timer if I get time
at my hands, so point taken.

Linus Walleij
