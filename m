Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXJ3BZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXJ3BZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXJ3BYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:24:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34895 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbXJ3BYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:24:51 -0400
Subject: Re: [PATCH] raise tsc clocksource rating
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, --cc@redhat.com,
       Ingo Molnar <mingo@elte.hu>, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net
In-Reply-To: <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain>
References: <11936994092607-git-send-email-gcosta@redhat.com>
	 <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 18:26:56 -0700
Message-Id: <1193707616.11323.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 23:17 +0100, Thomas Gleixner wrote:
> On Mon, 29 Oct 2007, Glauber de Oliveira Costa wrote:
> 
> CC'ed John and removed glauber@t60.localdomain :)
> 
> > From: Glauber de Oliveira Costa <glauber@t60.localdomain>
> > 
> > tsc is very good time source (when it does not have drifts, does not
> > change it's frequency, i.e. when it works), so it should have its rating
> > raised to a value greater than, or equal 400.

But all of those qualities (and more) make it less then ideal.

What issue exactly does this patch resolve?

> > Since it's being a tendency among paravirt clocksources to use values
> > around 400, we should declare tsc as even better: So we use 500.

This is the rating inflation I was initially worried about and created
the advisory scale to avoid. If paravirt clocksources are rated too
high, they should be dropped. 

I strongly disagree that the TSC is a "perfect" clocksource, and I think
its rating is appropriate. 


> > This patch also touches the comments on clocksource.h, which suggests
> > that 499 would be a limit on the rating values.
> > 
> > Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

If a better justification can be provided, I might reconsider, but right
now I can't ack this.

thanks
-john

> > ---
> >  arch/x86/kernel/tsc_32.c    |    2 +-
> >  arch/x86/kernel/tsc_64.c    |    2 +-
> >  include/linux/clocksource.h |    2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
> > index 9ebc0da..4d91e59 100644
> > --- a/arch/x86/kernel/tsc_32.c
> > +++ b/arch/x86/kernel/tsc_32.c
> > @@ -280,7 +280,7 @@ static cycle_t read_tsc(void)
> >  
> >  static struct clocksource clocksource_tsc = {
> >  	.name			= "tsc",
> > -	.rating			= 300,
> > +	.rating			= 500,
> >  	.read			= read_tsc,
> >  	.mask			= CLOCKSOURCE_MASK(64),
> >  	.mult			= 0, /* to be set */
> > diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
> > index 9c70af4..4fd5b1b 100644
> > --- a/arch/x86/kernel/tsc_64.c
> > +++ b/arch/x86/kernel/tsc_64.c
> > @@ -262,7 +262,7 @@ static cycle_t __vsyscall_fn vread_tsc(void)
> >  
> >  static struct clocksource clocksource_tsc = {
> >  	.name			= "tsc",
> > -	.rating			= 300,
> > +	.rating			= 500,
> >  	.read			= read_tsc,
> >  	.mask			= CLOCKSOURCE_MASK(64),
> >  	.shift			= 22,
> > diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> > index 107787a..5b0aadd 100644
> > --- a/include/linux/clocksource.h
> > +++ b/include/linux/clocksource.h
> > @@ -39,7 +39,7 @@ struct clocksource;
> >   *				A correct and usable clocksource.
> >   *			300-399: Desired.
> >   *				A reasonably fast and accurate clocksource.
> > - *			400-499: Perfect
> > + *			>= 400 : Perfect
> >   *				The ideal clocksource. A must-use where
> >   *				available.
> >   * @read:		returns a cycle value
> > -- 
> > 1.5.0.6
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 

