Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbXHQUJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbXHQUJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXHQUJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:09:30 -0400
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:48634 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751952AbXHQUJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:09:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o4ZQxX7cqPOTOTWgyfIoxyp1tJaIUmHd8UsvsRiZXGM1sZpTRunDsHomm7V0dFlyt+K4s6+Bf38Hj5kI0NHd9kUCimn/NC4TQDJpb1K1yp3KZ9msAGAD9gX7q9apI78eA5E+1o8Og9xZfsV/nzEsWgMFzF5JcJj/BZiEvdWUAxs=  ;
X-YMail-OSG: J7K.AwkVM1nT1JXLDbZW3c63LYjrip75qdRzeOHV7Htk9dvVlMLwkqYjO72ZpyEIpAqnnUkHcA--
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Fri, 17 Aug 2007 13:09:25 -0700
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <200708171124.54839.david-b@pacbell.net> <8bd0f97a0708171245j74e856e0uce009de16c00f517@mail.gmail.com>
In-Reply-To: <8bd0f97a0708171245j74e856e0uce009de16c00f517@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171309.25529.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Mike Frysinger wrote:
> On 8/17/07, David Brownell <david-b@pacbell.net> wrote:
> > ...
> > Just for the record, this is an unusual way to use these calls.
> >
> > Other platforms completely decouple these issues from the
> > IRQ infrastructure ... doing the pinmux and gpio claiming
> > separately from the request_irq()/free_irq() paths, mostly
> > as part of board setup.  Doing all of that "early":
> >
> >  - keeps those error returns from causing hard-to-track-down
> >    runtime bugs;
> >
> >  - works always, even on platforms where a given IRQ may
> >    appear on any of several pins/balls;
> >
> >  - makes it easier to cross-check against board schematics,
> >    by keeping most board-specific setup in one source file;
> >
> >  - shrinks the kernel's runtime footprint;
> >
> >  - allows the label to be more descriptive ... describeing
> >    exactly *which* IRQ, so that using the labels for better
> >    diagnostics actually gives better diagnostics.
> >
> > Again, not "wrong"; but probably sub-optimal.  You might
> > want to move towards earlier binding now, while Linux is
> > still young on Blackfin and you don't have legacy code to
> > worry about.
> 
> in the Blackfin port, if you want to use a pin as an IRQ rather than
> GPIO, you use the normal request_irq/free_irq API ... those functions
> will call back into the proper GPIO/PORTMUX code so that the pin is
> setup properly.  this is done so that code isnt duplicated across
> files and so that we can easily detect if someone does something
> incorrect like try to take the same pin and use it as
> irq/gpio/whatever at the same time ...
> 
> are you saying that other ports dont unify the backend code paths at all ?

Some platforms try to "unify" the pin setup in the boot loader.
Most of them cope with bogus bootloaders by doing it in the board
setup code.

I don't know of any who try to do it "late" as you summarized.

See above why "late" unification is not necessarily as good as
"early" unification.

And then there's the OMAP1 example, where for example you might
know that you want MPUIO-0 but that's insufficient to tell whether
you must mux ball F18 or R13 ... so it's impossible to do the kind
of "late" unification done here, and pinmux *MUST* be separate from
IRQ setup.

- Dave


