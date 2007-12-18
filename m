Return-Path: <linux-kernel-owner+w=401wt.eu-S934477AbXLRHdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbXLRHdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762276AbXLRHc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:32:59 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:59384 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761959AbXLRHc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=v8GyBDZxEHBYMEAChWzeRcSGoDNQwx4K+Y3Yd6UiQgVZebhOZhBiB+9oSrGntiSEDnb7TYdhWwh+DdEzkzwowKGNxbBXkUTXwfz3NNJ/D7aPFzWNTLBpmeNwAWONMOo3CARGXfghuFXUrNJNS54gWYxZwoBoBn3VcsjWRBNkLuo=
Message-ID: <3efb10970712172332o32b6dab5l33ecac57d18f49d4@mail.gmail.com>
Date: Tue, 18 Dec 2007 08:32:57 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH]: Atmel Serial Console interrupt handler splitup
Cc: "Andrew Victor" <linux@maxim.org.za>, RT <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071218001240.5cb42aae@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970712070724i6fa66666t2b8422329759ce24@mail.gmail.com>
	 <3efb10970712121429l7b41d57md4f826f6aaf4b71@mail.gmail.com>
	 <3efb10970712130840r7a2c5f72jca641d1cac545464@mail.gmail.com>
	 <cd73a99e0712130933s6f601ef7sed90f48c08d9adaa@mail.gmail.com>
	 <3efb10970712131232j5f747420g4aa8b5bd956e3dd3@mail.gmail.com>
	 <3efb10970712131235t47a9ceb5y7d9a7d5023d07bf6@mail.gmail.com>
	 <3efb10970712140346l1845d563k900d72d8788ac6f5@mail.gmail.com>
	 <20071217131701.6b2cdf2c@dhcp-252-066.norway.atmel.com>
	 <3efb10970712171256v4230eb38q84d01f2d0d554935@mail.gmail.com>
	 <20071218001240.5cb42aae@siona>
X-Google-Sender-Auth: 13f4982dad44d29a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> > Yep. All calls that block on a Mutex somehow on Preempt-RT. (such as
> > spinlocks, wakeup_interruptible() and many of its friends.)
> Right. Looks like the DMA patch call these functions from irq context
> too...I guess it'll need the same treatment?

That is correct. DMA code does do that, but the DMA code is not used
for DBGU, and _only_ the interrupt handler of DBGU runs in
IRQF_NODELAY context (because it is part of the System-IRQ and thus
shared with the timer-irq). The DMA code always runs in IRQ-thread
context, where it is safe to block on a mutex.
So, it is not mandatory to change that also. (It may be nice to do it anyway)

> > > > +struct atmel_uart_char {
> > > > +     unsigned int status;
> > > > +     unsigned int overrun;
> > > > +     unsigned int ch;
> > > > +     unsigned int flg;
> > > > +};
> > >
> > > Hmm. 16 bytes per char is a bit excessive, isn't it? How about
> > >
> > > struct atmel_uart_char {
> > >         u16     ch;
> > >         u16     status;
> > > };
> > >
> > > where ch is the received character (up to 9 bits) and status is the
> > > lowest 16 bits of the status register?
> > I used the NODELAY patch for the 8250 serial port as reference, it
> > contains similar code, and I tried to make both look the same.
> Ok, I see. But...
> > > > +#define ATMEL_SERIAL_RINGSIZE 1024
> This means that the buffer ends up at 16K. Since the buffer itself is
> kept in a struct along with a few other pieces of data, we end up
> kmalloc()ing 32KB of memory...

Oops... 32kB on X86 is not much, relatively, on ARM it is somewhat different.
We can also decrease the total RingSize, 128 would be good enough also.
I can look at it later this week.

> I'm a bit tempted to just go ahead and do the changes we agree on and
> post the result. Then I'll see if I can make the DMA stuff behave. I've
> got a different driver lying around which is DMA-only and has a few
> problems on its own.

Beware that, according to several older discussions, DBGU cannot make
use of DMA... (If I understood it correctly, it was because the buffer
first have to be full, before an interupt is generated. That would be
very annoying while typing 1 character at the time ;-)

> Also, I think the DMA patch needs to be more integrated with your
> "interrupt handler splitup" patch. No point in keeping two RX buffers
> around, and the DMA code needs to obey the same rules as the rest of
> the driver if it's going to work in -rt.

As mentioned, not necessarily...

> And I'd really like to have working DMA support on avr32 before
> christmas ;-)

Me too ;-)


Kind Regards,

Remy
