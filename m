Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbXHQVyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbXHQVyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbXHQVyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:54:04 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27607 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbXHQVxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:53:51 -0400
X-IronPort-AV: i="4.19,277,1183348800"; 
   d="scan'208"; a="48711838:sNHT28048384"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Fri, 17 Aug 2007 17:53:50 -0400
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <1186544139342-git-send-email-bryan.wu@analog.com> <200708171124.54839.david-b@pacbell.net>
In-Reply-To: <200708171124.54839.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171753.50326.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Aug 2007 21:53:49.0812 (UTC) FILETIME=[1819BB40:01C7E119]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17 Aug 2007 14:24, David Brownell pondered:
> Just for the record, this is an unusual way to use these calls.

That is part of the natural evolution of the kernel isn't it - per James's 
keynote at OLS - you release something, and see how people [ab]use it until 
it either grows, evolves, or it dies.

> Other platforms completely decouple these issues from the
> IRQ infrastructure ... doing the pinmux and gpio claiming
> separately from the request_irq()/free_irq() paths, mostly
> as part of board setup.  Doing all of that "early":

is early:
 - early in the kernel?
 - early before the kernel? (in the bootloader).

>  - keeps those error returns from causing hard-to-track-down
>    runtime bugs;

The current Blackfin implementation causes a run time message:
"the pin xxxx driver requested, was already claimed by yyy driver".

I don't think that is too bad?

>  - works always, even on platforms where a given IRQ may
>    appear on any of several pins/balls;

But requires custom bootloaders or board setup for every hardware platform? 
Most of our users would not like that, since they do as you say - use the 
same kernel - with different drivers on multiple platforms.

>  - makes it easier to cross-check against board schematics,
>    by keeping most board-specific setup in one source file;

Yes - but we are not talking about muxing a common peripheral (like a single 
UART) out many different pins (A or B or C). The UART pins are fixed. If you 
want the UART, you need to use pin A. If you want to use the I2C that also 
sits on pin A, you will get the message:
"pin A, requested by I2C, was already claimed by UART driver".

>  - shrinks the kernel's runtime footprint;

I agree - making things more flexible/easier to use - is normally more 
complex/larger/slower. (I know - easier to use is a matter of opinion). Since 
this is normally done once, in _init functions, I'm not sure that makes much 
of a difference here.
 
>  - allows the label to be more descriptive ... describeing
>    exactly *which* IRQ, so that using the labels for better
>    diagnostics actually gives better diagnostics.

I'm not sure what you mean?

> Again, not "wrong"; but probably sub-optimal.  You might
> want to move towards earlier binding now, while Linux is
> still young on Blackfin and you don't have legacy code to
> worry about.

Our overall goal is to keep as much code - including bootloader - platform 
agnostic, and not require people to write any of code/configuration data to 
boot up something, and get things working in a semi-standard manner.

This still has it's limits - which is why we publish all our hardware designs. 
If you implement things the similar way (because for the most part it is 
fixed by the processor designer) - the bootloader/kernel/driver will just 
work.

I would rather force a little extra complexity on me (as a kernel developer) 
than have to answer thousands of questions from end users, who are trying to 
move the kernel onto their hardware.

-Robin
