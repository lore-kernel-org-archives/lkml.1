Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXHQTpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXHQTpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXHQTpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:45:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:54080 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbXHQTph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IlHf8eF0ZLo+hUodDmIL+6cpR/Uxki6+KM5wjciyYN6XTeOigxvDGAr0fCloYWddl7BKu2WVY9hXDqXWaz3/a7W7oZRLQKGZoCeJkOqQf5JMV5AojV5rQ0Mrrwu8O39H6SLQ26U4sjqHI/SoopaqFMr25XT83DFK3dBFJEM0hHI=
Message-ID: <8bd0f97a0708171245j74e856e0uce009de16c00f517@mail.gmail.com>
Date: Fri, 17 Aug 2007 15:45:36 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <200708171124.54839.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865441373719-git-send-email-bryan.wu@analog.com>
	 <1186544139342-git-send-email-bryan.wu@analog.com>
	 <200708171124.54839.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, David Brownell <david-b@pacbell.net> wrote:
> Again, the patch descriptions need work.  This changes the
> IRQ code (to add those labels).  $SUBJECT doesn't mention IRQs,
> neither does the description ...
>
>
> On Tuesday 07 August 2007, Bryan Wu wrote:
> > --- a/arch/blackfin/mach-common/ints-priority-dc.c
> > +++ b/arch/blackfin/mach-common/ints-priority-dc.c
> > @@ -221,7 +221,7 @@ static unsigned int bf561_gpio_irq_startup(unsigned int irq)
> >
> > if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
> >
> > -ret = gpio_request(gpionr, NULL);
> > +ret = gpio_request(gpionr, "IRQ");
> > if (ret)
> > return ret;
> >
> > @@ -261,7 +261,7 @@ static int bf561_gpio_irq_type(unsigned int irq, unsigned int type)
> >
> > if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
> >
> > -ret = gpio_request(gpionr, NULL);
> > +ret = gpio_request(gpionr, "IRQ");
> > if (ret)
> > return ret;
> >
>
> Just for the record, this is an unusual way to use these calls.
>
> Other platforms completely decouple these issues from the
> IRQ infrastructure ... doing the pinmux and gpio claiming
> separately from the request_irq()/free_irq() paths, mostly
> as part of board setup.  Doing all of that "early":
>
>  - keeps those error returns from causing hard-to-track-down
>    runtime bugs;
>
>  - works always, even on platforms where a given IRQ may
>    appear on any of several pins/balls;
>
>  - makes it easier to cross-check against board schematics,
>    by keeping most board-specific setup in one source file;
>
>  - shrinks the kernel's runtime footprint;
>
>  - allows the label to be more descriptive ... describeing
>    exactly *which* IRQ, so that using the labels for better
>    diagnostics actually gives better diagnostics.
>
> Again, not "wrong"; but probably sub-optimal.  You might
> want to move towards earlier binding now, while Linux is
> still young on Blackfin and you don't have legacy code to
> worry about.

in the Blackfin port, if you want to use a pin as an IRQ rather than
GPIO, you use the normal request_irq/free_irq API ... those functions
will call back into the proper GPIO/PORTMUX code so that the pin is
setup properly.  this is done so that code isnt duplicated across
files and so that we can easily detect if someone does something
incorrect like try to take the same pin and use it as
irq/gpio/whatever at the same time ...

are you saying that other ports dont unify the backend code paths at all ?
-mike
