Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbXHQUTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbXHQUTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761812AbXHQUTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:19:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:39339 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbXHQUTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PR5Z2tCH5YRyyamxFpdX8P9l3v+kPQuUXjNRZzhh4Yxo+cNqwZ/rx2rlzR+aoBA16Tu2ko5/iAbPvGXTojxoZeWuLnyifRso6PuS3kjNLyQ7eJ2f0zO1S9nhPrjoTQum/euOnXO4FlDOAUVBdqJ7fOAKAoGTNKGKkEOEUL0m5/M=
Message-ID: <8bd0f97a0708171319q71b5a117v8882f4fb70d2dc43@mail.gmail.com>
Date: Fri, 17 Aug 2007 16:19:32 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <200708171309.25529.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865441373719-git-send-email-bryan.wu@analog.com>
	 <200708171124.54839.david-b@pacbell.net>
	 <8bd0f97a0708171245j74e856e0uce009de16c00f517@mail.gmail.com>
	 <200708171309.25529.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, David Brownell <david-b@pacbell.net> wrote:
> On Friday 17 August 2007, Mike Frysinger wrote:
> > On 8/17/07, David Brownell <david-b@pacbell.net> wrote:
> > > ...
> > > Just for the record, this is an unusual way to use these calls.
> > >
> > > Other platforms completely decouple these issues from the
> > > IRQ infrastructure ... doing the pinmux and gpio claiming
> > > separately from the request_irq()/free_irq() paths, mostly
> > > as part of board setup.  Doing all of that "early":
> > >
> > >  - keeps those error returns from causing hard-to-track-down
> > >    runtime bugs;
> > >
> > >  - works always, even on platforms where a given IRQ may
> > >    appear on any of several pins/balls;
> > >
> > >  - makes it easier to cross-check against board schematics,
> > >    by keeping most board-specific setup in one source file;
> > >
> > >  - shrinks the kernel's runtime footprint;
> > >
> > >  - allows the label to be more descriptive ... describeing
> > >    exactly *which* IRQ, so that using the labels for better
> > >    diagnostics actually gives better diagnostics.
> > >
> > > Again, not "wrong"; but probably sub-optimal.  You might
> > > want to move towards earlier binding now, while Linux is
> > > still young on Blackfin and you don't have legacy code to
> > > worry about.
> >
> > in the Blackfin port, if you want to use a pin as an IRQ rather than
> > GPIO, you use the normal request_irq/free_irq API ... those functions
> > will call back into the proper GPIO/PORTMUX code so that the pin is
> > setup properly.  this is done so that code isnt duplicated across
> > files and so that we can easily detect if someone does something
> > incorrect like try to take the same pin and use it as
> > irq/gpio/whatever at the same time ...
> >
> > are you saying that other ports dont unify the backend code paths at all ?
>
> Some platforms try to "unify" the pin setup in the boot loader.
> Most of them cope with bogus bootloaders by doing it in the board
> setup code.
>
> I don't know of any who try to do it "late" as you summarized.
>
> See above why "late" unification is not necessarily as good as
> "early" unification.
>
> And then there's the OMAP1 example, where for example you might
> know that you want MPUIO-0 but that's insufficient to tell whether
> you must mux ball F18 or R13 ... so it's impossible to do the kind
> of "late" unification done here, and pinmux *MUST* be separate from
> IRQ setup.

sorry, i'm not familiar at all with anything OMAP, but the Blackfin
architecture is such that all of its pins can be flipped on the fly
between modes ... i have seen once or twice some drivers which
actually needed this ability at runtime as they were muxing things
(maybe our fault there ... give someone the ability and they'll use
it).

as Michael pointed out, in the Blackfin world we tend to keep things
very dynamic as we have dev systems which allow for dropping in of
optional cards at will, so doing this in the bootloader is way too
inflexible.
-mike
