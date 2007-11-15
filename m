Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbXKOHSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbXKOHSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbXKOHRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:17:23 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:22053 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752507AbXKOHRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:17:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fV67RNC5bAhM5Nfe+E9IN6nfFHwMT4i1aSLIf31lLxBu828EizydDAk5Wkwteo3+YvuzmOo3Uueslo1zentwyanR7Cwhm0eK6K3cHElqpz7fMMjRacROjbrtmluJPChhZJzdyOakKs5/n16YVZWgkxwvjIe1LdkNS8GOzIP8VO0=  ;
X-YMail-OSG: ROn5KvEVM1lYf6.uSsvb3rXhUfu_v7jafZYLSahGbQf_eEwubrAUHuuEbh..Yn7wqlnCUnb_oA--
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 23:02:01 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
References: <200711091136.20051.david-b@pacbell.net> <200711121726.39263.david-b@pacbell.net> <alpine.LFD.0.9999.0711141228210.3265@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711141228210.3265@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711142302.02498.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007, Thomas Gleixner wrote:
> On Mon, 12 Nov 2007, David Brownell wrote:
> > > I'm still trying to understand what you've observed here.  Is it the case
> > > that a single gpio operation went from 6.4 up to 11.2 usecs?
> > 
> > That was a single bitbanged I2C bit transfer, with embedded udelay()s.
> > I believe that was four gpio operations, as summarized at the end of
> > that email above.  Enabling preempt + debug increased the cost of
> > each GPIO call from whatever it was (reasonable) by 1.2 usecs.
> 
> This raw lock change is just pampering over the design problem of the
> gpio lib:
> 
> There is no need to check for every single access to a GPIO pin,
> whether the pin has a valid number and the chip, which provides access
> to the pin, is still registered.

As Haavard had noted.  The "requested" flag is actually serving
as a longterm bit-level lock, which -- assuming well-behaved
callers, and no debug instrumentation -- obviates any need to
grab a spinlock in hot paths.


> Each driver, which wants to access a pin, needs to make sure that
> 
> - the pin is available
> - the pin is associated to this driver
> - the chip reference count is incremented
> 
> _before_ it starts to do anything with the pin. Once this is done the
> access to the pin is completely lock free except for the protection of
> the chip hardware itself.

That's what the gpio_request() call does, although it's using
something isomorphic to a refcount, not an actual refcount.

The key observation here is that we already *have* a bit which
is serving as a per-gpio lock.  It's just never been viewed as
a lock before.  :)


> The protection of the chip list can be converted to a mutex and
> does not need to be a spinlock at all.

No, we still need to use a spinlock to protect table changes.
The reason for that is briefly:

  - gpio_request()/gpio_free() have so far been optional.  Most
    platforms implement them as NOPs, not all drivers use them.
    (Having gpiolib in place should help change that ...)

  - gpio_direction_input()/gpio_direction_output() implicitly
    request the pins, if they weren't already requested.

  - Those input/output direction-setting calls may be called
    in IRQ contexts, which means (on non-RT kernels) no mutex.


So we're actually in good shape; just take out a bit of code
(or turn it into debugging instrumentation) and I don't think
anyone will complain about the locking any more.

- Dave

