Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZGWORj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZGWORj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZGWORj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:17:39 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:48463 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZGWORi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:17:38 -0400
Message-ID: <4A68709E.5060207@csr.com>
Date: Thu, 23 Jul 2009 15:15:58 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <pierre@ossman.eu>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>	 <4A6701E3.3000204@csr.com> <63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com>
In-Reply-To: <63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2009 14:15:58.0571 (UTC) FILETIME=[199A83B0:01CA0BA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 2009/7/22 David Vrabel <david.vrabel@csr.com>:
> 
>> Linus Walleij wrote:
> 
>> I'm not sure this is the right approach.
> 
> It's been discussed a bit back and forth for a few months, but let's keep
> at it...
> 
>> 1. With some controllers (e.g., PXA270 I think) turning the clock on and
>> off is slow.  This means if you're doing back-to-back commands you
>> should leave the clock on for best performance.
> 
> OK, when I've been testing this using the default workqueue and
> schedule_work() covered these cases. Back-on-back commands
> seemingly doesn't allow the timeout work to schedule, but I might be
> overseeing the case of several CPU:s there though :-/

Ok, with a configurable timeout your scheme is fine.  The timeout can be
extended beyond 8 SDCLKs if this is beneficial.

>>  I think there needs to
>> be a higher level active/idle knob for the user of the card (be it the
>> block driver or an SDIO function driver) to control whether to idle the
>> bus clock or controller.
> 
> The code doesn't tell the driver to idle the controller, it sets ios.clock
> to zero to give the host driver the *opportunity* to turn controller clocks
> off when it's OK from the MMC spec to do so (after 8 MCI cycles), the
> driver doesn't *have* to do that. It can add addtional logic for different
> HW. So it's only about the bus clock (whereas my patch to mmci.c takes
> advantage of the possibility to also gate the block clock).

Many host controllers do stop the clock when ios->clock == 0 (pxamci and
sdhci, for example).  Therefore. your patch will stop SDIO cards from
working on (at least) PXA27x platforms.

There needs to be three different bus states: active (max clock), idle
(minimal clock, SDIO interrupts work), and off (minimal clocks, SDIO
interrupts not required).

I'm not sure what the best way to add this would be.  You could:

1. Have a special clock frequency to mean idle and fix up all existing
controller drivers to interpret this as 400 kHz unless you know the
controller handles SDIO interrupts with no SDCLK.

or:

2. Add an additional controller method (set_bus_state?) and only provide
this on controller drivers you're interested in.

>> 2. Some controllers cannot detect SDIO interrupts if the clock is
>> stopped.  There should either be a distinction between clock off and
>> clock idle.
> 
> This is on the driver level, not in the core. The core doesn't tell whether
> to clock off or not, it only tells the device driver that the MCI clk doesn't
> need to run by setting it to 0. Clearly, some hardware cannot exploit
> that, but some (like PL180, OMAP and Atmel) can, easily.

See previous comment.

> There can possibly also be HW that can turn of MCI clk but not the
> clock to the HW block itself, that is fine with the implementation.

Ok.

>> 3. Regardless of point 1 above.  Using a workqueue item in this way
>> seems overkill.  Consider using a timer and simply calling mod_timer()
>> at the start of every command.  When the timer expires, idle the clock.
>>  You will probably need a "command in progress" bit to ensure you don't
>> idle the clock if the timer expires in the middle of a command.
> 
> I would agree if I created a new workqueue, but the timeout of this
> particular workqueue is unimportant and that's why I'm using the
> global workqueue and just schedule_work(). This means no extra
> overhead, no extra thread and basically does the exact same thing.

You currently queue a work item and wake the workqueue every command.
This is considerably more overhead (when doing back-to-back commands)
than simply calling mod_timer().

You also potentially delay for a considerable amount of time in the work
item.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
