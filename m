Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbZB1GR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbZB1GR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 01:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZB1GRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 01:17:48 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:26643 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750942AbZB1GRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 01:17:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=biTB4RLbfnLH5jIajJ1aB16TK/7va9+jLnaRzUJgEO9cqLxc0Y+KypYhYX+7rO1Vh4o/9hbmnMqmceaAwi3AIr/QAxGLQStlHDVBzNWxD0vPGhqOFPUkxqfk7TzxRZVUKRKwdsqYBDtffVXfe6ihzo9HGNRbx9po6X3/gKU76yI=  ;
X-YMail-OSG: G2A.USIVM1nICL4jRQOi9Ml9obm40AODSbZPxHq1GFBCsIRwp5VCyp1XMmzAZqfcsQsF0.VRrUhka.b_pBZTvM2Ej3kkK6DduDR70Tg1TgRs6.PmULhwmAEMKqBqRjzYyfNnE4BtgF.LNH8iXJdwipp8H9t5EzMCyAM1Pm19t7RaUxIs.P6tSIaRFzUa
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Fri, 27 Feb 2009 22:17:44 -0800
User-Agent: KMail/1.9.10
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902272046.50572.david-b@pacbell.net> <20090227211203.4ebb0524.akpm@linux-foundation.org>
In-Reply-To: <20090227211203.4ebb0524.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902272217.44688.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Andrew Morton wrote:
> On Fri, 27 Feb 2009 20:46:50 -0800 David Brownell <david-b@pacbell.net> wrote:
> 
> >   drivers/mfd/twl4030-irq.c
> > 
> > Where you'll observe twl_init_irq() at line 688 setting
> > up the thread and the Primary IRQ Handler (PIH) dispatch.
> > That's pretty much bog-standard chained IRQ setup code,
> > except that it chains through a thread.
> 
> OK, that's clever.  I never knew that anyone was doing that.  afaict
> MFD is the only such place...

This is the Mark II code, which can look clever
because it uses genirq better than the fairly
ugly Mark I code (and doesn't clone the same
logic into three separate drivers).

What's unique about this particular code is that
it chains those IRQs, instead of creating its own
little irq core (like menelaus.c in that directory)
or only needing to handle one IRQ (as with RTC
alarm drivers).


> Yes, it's regrettable that it's a private-to-mfd implementation.

More like:  private-to-twl4030.  If a more generic
version (Mark III) comes along at some point, I'd
hope switching would be easy...


> I expect a lot of i2c clients (at least) would like this.

I2C, SPI, maybe some more ... yes.  RTC alarm handling,
as one fairly routine example.


> Perhaps it would be somewhat less dirty to do something like

Yeah, that #ifdef is pretty ugly.

Thomas sent some threaded IRQ patches around sometime
last fall, which handled the top level dispatch but
ISTR not the chaining part.  This kind of thing would
be appropriate for the chained IRQs.  Maybe the flag
would better be named IRQF_THREADED.

(However, this flavor hack wouldn't address the lockdep
breakage for drivers like the AT91 and OMAP1 MMC hosts.)

- Dave


> --- a/kernel/irq/manage.c~a
> +++ a/kernel/irq/manage.c
> @@ -689,7 +689,8 @@ int request_irq(unsigned int irq, irq_ha
>  	/*
>  	 * Lockdep wants atomic interrupt handlers:
>  	 */
> -	irqflags |= IRQF_DISABLED;
> +	if (!(irqflags & IRQF_NO_LOCKDEP_HACK))
> +		irqflags |= IRQF_DISABLED;
>  #endif
>  	/*
>  	 * Sanity-check: shared interrupts must pass in a real dev-ID,
> 


