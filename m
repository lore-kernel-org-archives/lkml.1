Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbYJKSBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbYJKSBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762112AbYJKSBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:01:24 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:22759 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762108AbYJKSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:01:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HVIVKWvjsvFp15Ad/r8naYSYiQ0mBBmLoWXa5UmMejU5jBaWWulmqauVarz0OIGL29Cj+IOS/QDTIZPPdHRYTCuIcw84efbTGOaIoXvGuG5jof1wJI/15QGWpya44M4AHUpiRpM4sYHal9ZFGJczBUjjHS6M+/mUHrAz4UPlsKI=  ;
X-YMail-OSG: JG7ejRAVM1n8Er.PSUkMjreDfqSpjMhA5bVxuYyeDzRH4rewk8AqIJlLWhGTyK7xhLfcFGZIJtDFEp984FQtVICZ6NjiZv4cBmvFCB_nuqBPwgvdqsJhY2TPX4UlpvSjpa4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Date: Sat, 11 Oct 2008 11:01:20 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
References: <200809241251.32606.david-b@pacbell.net> <200810090234.41243.david-b@pacbell.net> <20081009123030.4c9607c1@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081009123030.4c9607c1@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810111101.20885.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008, Haavard Skinnemoen wrote:
>
> On the other hand, lack of debouncing might cause the gpio_keys driver
> to report 1000 keypresses instead of one when the user pushes a button.
> That's much more harmful.
> 
> So if someone goes and replaces the debounce timer in gpio_keys with
> this IRQF_DEBOUNCE flag, it might work very well on hardware which
> happens to use a 30 ms debounce interval, but will break horribly on
> hardware with shorter debounce intervals.

Agreed that if you want to _replace_ software debouncing with a flag
that's a pure hint, it wouldn't work.  But I didn't suggest that...

Instead, if you just added IRQF_DEBOUNCE to the existing gpio_keys,
what you'd get is a reduction in useless IRQs received.  Which is
a behavioral improvement, coming at essentially zero system cost.
(After discounting the cost of "how to do it" discussions!)

(As Pavel also observed.)

 
> > > > What would you think about advice to debounce by default on the
> > > > order of one millisecond, where hardware allows?  Later, ways
> > > > to query and update that QOS could be defined.
> > > 
> > > I suppose a good start would be to add a comment saying that.
> > > 
> > > On the other hand, I don't see how drivers can even tell if the
> > > hardware supports IRQF_DEBOUNCED at all...
> > 
> > That is, "On the other hand, 'later' is not yet..." ?
> 
> Right.
> 
> > Are you suggesting that debouncing support shouldn't
> > be provided without QOS query/update support?
> 
> Sort of. I'm just wondering how drivers can rely on a feature which
> provides such vague promises.

As with madvise(), by just hinting "here's a way to improve
behavior a bit, if hardware allows".  As you noted, ignoring
such hints would mean some missed optimizations ... but the
system would still behave correctly.


> > The debounce() method might usefully be changed to take the
> > requested delay in microseconds, instead of a boolean.  And
> > to return the actual delay.  That would make it easier to
> > support fancier calls later, maybe just exposing the raw
> > irq_chip call like
> > 
> > 	usecs = set_irq_debounce(irq, range_spec);
> 
> Maybe that's better. Just request the interrupt as normal, and then try
> to enable debouncing. If the actual delay is too short, the driver can
> set up its own timer.

So we seem to be thinking about two mechanisms:

 - I focussed on hinting, as a lightweight way to kick in a
   common hardware mechanism to improve system behavior;

 - You focussed on abstracting the whole debouncing problem,
   leveraging those mechanisms more highly and (implicitly)
   helping improve much messy software debounce logic.

Still seems to me there should be no problem having both
mechanisms, supported by one irq_chip.debounce() hook
that's a little different from the one in $PATCH.  And I
think you agreed with that.

Specifically with respect to the Atmel GPIO modules, the
hinting would eliminate a few glitches but would not be as
powerful as on some other hardware.  (As you had observed
earlier.)  So if I were wearing the same corporate hat you
are, I'd want Linux to support that second mechanism too!!


> > > A flag will 
> > > never be able to convey some important parameters like how long to
> > > debounce.
> > 
> > But how important *is* that detail to most drivers?  In practice.
> > I suspect they pick numbers today since they have to debounce with
> > software timers, which require numbers.
> 
> I think it's very important to drivers that have to deal with
> mechanical buttons and switches. In many cases, only the board code
> knows what kind of switch is hooked up to the interrupt, so the driver
> just passes on that information from the platform data.

If the platform setup code knows the hardware debounce will
be requested, it can adjust its platform_data debounce parameter
accordingly.

- Dave

