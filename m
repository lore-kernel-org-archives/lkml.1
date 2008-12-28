Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYL1WKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYL1WKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYL1WK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:10:27 -0500
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:12674
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbYL1WK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:10:26 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Dec 2008 17:10:25 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AggBAOqFV0l8qMVq/2dsb2JhbAAIvRpYjmeFBIFA
X-IronPort-AV: E=Sophos;i="4.36,292,1228057200"; 
   d="scan'208";a="294213836"
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
From: Ben Nizette <bn@niasdigital.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>,
       David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Eric Miao <eric.miao@marvell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>, Ben Gardner <bgardner@wabtec.com>,
       Greg KH <greg@kroah.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <200812281346.56703.rgetz@blackfin.uclinux.org>
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com>
	 <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com>
	 <200812281346.56703.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 09:00:34 +1100
Message-Id: <1230501634.16910.57.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-28 at 13:46 -0500, Robin Getz wrote:
> > gpio_set_batch(DB0, value, 0xFFFF, 16)
> > 
> > which has the nice performance benefit of skipping all the bit
> > counting in the most common use case scenario.
> 
> but has the requirement that the driver know exactly the board level 
> impmentation details (something that doesn't sound generic).

The original use case for these batch operations was in a fastpath -
setting data lines on a framebuffer.  Sure it's arguably not as generic
as may be, but it optimises for speed and current usage patterns - I'm
OK with that.  Other usage patterns which don't have a speed requirement
can be done using the individual pin operations and a loop.

> 
> > While we are here, I was thinking about it, and its better if I give
> > gpio_request/free/direction_batch a miss for now. Nothing prevents
> > those features being added at a later point.
> 
> I don't think that request/free are optional.
> 
> For example - in most SoC implementations - gpios are implemented as banks of 
> 16 or 32. (a 16 or 32 bit register).
> 
> Are there facilities to span these registers? 
>  - can you request 64 gpios as a 'bank'?
>  - can you request gpio_8 -> gpio_40 as a 'bank' on a 32-bit system?
> 
> Are non-adjacent/non-contiguous gpios avaliable to be put into 
> a 'bank/batch/bus'? can you use gpio_8 -> 11 &  28 -> 31 as a 8-bit 'bus'? 
> 
> How do you know what is avaliable to be talked to as a bank/bus/batch without 
> the request/free operation?

I think the read/write operations should be able to fail if you give
them invalid chunks of gpio, sure.  Request/free are not really designed
for that operation - they just ensure exclusive access to a gpio if
that's what the driver wants.  In the batch case the
request/free/direction operations can once again be performed by single
pin operations and iteration.

> 
> 
> I have seen various hardware designs (both at the PCB and SoC level) require 
> all of these options, and would like to see common infrastructure which 
> handles this.
> 
> The issue is that on many SoC implementations - dedicated peripherals can also 
> be GPIOs - so it someone wants to use SPI (for example) GPIO's 3->7 might be 
> removed from the avaliable 'gpio' resources. This is determined by the 
> silicon designer - and even the PCB designer has little to no flexibility on 
> this. It gets worse as multiple SPI or I2C are used on the PCB (which can 
> have lots of small (less than 5) dedicated pins in the middle of the larger 
> gpio resources)....

Yeah the request/free operation doesn't deal with muxing or any other
platform-specific kinda gumph, that was an original design decision.
They're really just a usage counter.

An example which comes to mind is the avr32-specific userspace gpio
interface.  This takes a bitmask, loops over the set bits and fails if
any of the gpio are previously requested or have been assigned to
non-gpio peripherals.  I don't really see a need to streamline this.

> 
> I would think that a 'bank' / 'bus' (whatever) would be a collection of 
> random/multiple GPIOs (a struct of gpio_port_t) rather than a start/length 
> (as you described) - or better yet - the request function takes a list (of 
> individual GPIO's - defined in the platform data), and creates the struct 
> itself.

Hmm, this seems a little overengineered for the basic use-cases I can
think of.  If this can be cranked up to the same speed as the current
proposition then OK maybe someone will like it but otherwise, once
again, I think most people will be happy with individual operations and
iteration.


	--Ben.



