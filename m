Return-Path: <linux-kernel-owner+w=401wt.eu-S1765370AbXKOHd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765370AbXKOHd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbXKOHdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:33:17 -0500
Received: from www.tglx.de ([62.245.132.106]:42500 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbXKOHdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:33:16 -0500
Date: Thu, 15 Nov 2007 08:32:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
In-Reply-To: <200711142302.02498.david-b@pacbell.net>
Message-ID: <alpine.LFD.0.9999.0711150824480.3265@localhost.localdomain>
References: <200711091136.20051.david-b@pacbell.net> <200711121726.39263.david-b@pacbell.net> <alpine.LFD.0.9999.0711141228210.3265@localhost.localdomain> <200711142302.02498.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, David Brownell wrote:
> > The protection of the chip list can be converted to a mutex and
> > does not need to be a spinlock at all.
> 
> No, we still need to use a spinlock to protect table changes.
> The reason for that is briefly:
> 
>   - gpio_request()/gpio_free() have so far been optional.  Most
>     platforms implement them as NOPs, not all drivers use them.
>     (Having gpiolib in place should help change that ...)

By magically doing the request of the pin ? See below.

>   - gpio_direction_input()/gpio_direction_output() implicitly
>     request the pins, if they weren't already requested.

Eek, that's completely wrong. Allowing to access a resource _before_
it is assigned and then doing the assignment implicit is a really bad
idea.

>   - Those input/output direction-setting calls may be called
>     in IRQ contexts, which means (on non-RT kernels) no mutex.

There is no reason to do that if you actually have a useful reference
to the chip _before_ accessing the pin.
 
> So we're actually in good shape; just take out a bit of code
> (or turn it into debugging instrumentation) and I don't think
> anyone will complain about the locking any more.

This still does not solve the lookup, which is done for each operation
on a pin (direction setting, read, write).

     	 tglx

