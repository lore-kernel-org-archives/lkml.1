Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbXK2L1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbXK2L1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbXK2L1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:27:33 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:14219 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbXK2L1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lPC6+AuMHArjI08q/8VQ60VQ/yweTOUhWByLN2vBWHqRgk5AG7hiYXrWhXSx34vy83Xe2Pik1TfKnhH0NXphA3xJEMyIVviD00YSpmsNrE+4bvUwkclvgiNOboSwVGVFz6p8yUIP0YtvP8Q7PvTaEwAQGu34Ln+qgKIpkoqhWds=
Message-ID: <3efb10970711290327s3c60da1ey3b6fae738090ca5@mail.gmail.com>
Date: Thu, 29 Nov 2007 12:27:30 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Daniel Walker" <dwalker@mvista.com>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20071129102506.GB22793@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
	 <1196177122.23808.7.camel@imap.mvista.com>
	 <1196178834.23808.11.camel@imap.mvista.com>
	 <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
	 <20071128172509.GA30173@flint.arm.linux.org.uk>
	 <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com>
	 <20071128200550.GA3494@flint.arm.linux.org.uk>
	 <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com>
	 <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com>
	 <20071129102506.GB22793@flint.arm.linux.org.uk>
X-Google-Sender-Auth: ad7d3f3100eec0de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

> If 'no' then it's the right handler and the mask/unmask methods associated
> with the interrupt will be no-ops.

I completely understand what you keep on saying, but that would imply
that the following piece of code in chip.c is completely bogus anyway!
(snip from mainline 2.6.23)

handle_simple_irq(unsigned int irq, struct irq_desc *desc)
...
	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
		if (desc->chip->mask)
			desc->chip->mask(irq);
...
}

Why trying to mask the interrupt if that is illegal use of the interrupt type?
This piece of code assumes that there CAN be a handler for masking
interrupts for the simple_irq type. This is in contradiction what you
are trying to explain.

If what you say is (completely) true the code is better to be:
....
		if (desc->chip->mask)
                             BUG();
....

IMO, interrupts can still be simple_irq types if the interrupt source
does **not have to** be disabled to be able to handle them. These
(GPIO) interrupts signal an event, that is already gone when the
interrupt handler starts, they are **never** really pending, waiting
for some device driver to handle the event. The device does not really
care if the interrupt is really handled, it just generates a new
interrupt on the next event.
And yes, it is possible that these interrupts can be seperately
masked/unmasked, but it is not necessary, and therefor others chose
apparantly for the simple_irq() types.

So, I do not think that the argument of **can** masked/unmasked is
valid, but more the **need** to be masked/unmasked is valid.

I think we should not argue if this is correct use, or misuse.
Fact is now that there is a bug in RT, that this type of 'misuse' does
not work on RT and breaks the interrupt handling. There are even more
patches floating around to fix this.

According to what Daniel also mentions, there are already several
architectures that use this type of interrupt with a masking/unmasking
implementation, apparantly all without the **need** to masking them.

So, the code must prevent this type of 'misuse' (and thus not
supporting it as it is doing now) or fully support it on RT, just like
on mainline.

So, in short: IMO, only RT is broken, not mainline -> thus fix RT,
otherwise we will have regression compared to mainline.

Kind Regards,

Remy


2007/11/29, Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Thu, Nov 29, 2007 at 11:14:30AM +0100, Remy Bohmer wrote:
> > I do not think Russell is right here with assuming that the wrong
> > interrupt handler type is used. Looking at the behaviour of the
> > mainline kernel (non-RT), the implementation is quite different: On
> > mainline the handle_simple_irq() in chip.c is not re-entrant, the
> > masking is **only** done in case of errors, and therefor never
> > unmasked again, of course.
>
> The issue comes down to a very simple question:
>
>   Are you using handle_simple_irq() with an interrupt which can be masked?
>
> If the answer to that question is 'yes' then you're using the wrong handler.
> If 'no' then it's the right handler and the mask/unmask methods associated
> with the interrupt will be no-ops.
>
> Therefore, if you have mask/unmask methods for a simple IRQ which actually
> do something, clearly the first answer is the one which applies.  You're
> using the wrong handler.  Use the level or edge handlers instead.
>
