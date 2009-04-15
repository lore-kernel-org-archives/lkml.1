Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZDOIfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZDOIfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbZDOIed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:34:33 -0400
Received: from relay.atmel.no ([80.232.32.139]:62020 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759339AbZDOIea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:34:30 -0400
Date: Wed, 15 Apr 2009 10:33:52 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: tglx@linutronix.de, David Brownell <david-b@pacbell.net>,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       imre.deak@nokia.com, mingo@elte.hu
Subject: Re: [REGRESSION] threaded interrupt handler support breaks (some)
 irq handling on AVR32
Message-ID: <20090415103352.5ee43824@hskinnemoen-d830>
In-Reply-To: <20090415095710.5c853a7f@hskinnemoen-d830>
References: <1239685153.19815.12.camel@linux-51e8.site>
	<1239698225.29831.14.camel@linux-51e8.site>
	<1239759053.29831.37.camel@linux-51e8.site>
	<20090415095710.5c853a7f@hskinnemoen-d830>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> Ben Nizette wrote:
> > static irqreturn_t ads7846_irq(int irq, void *handle)
> > {
> > 	struct ads7846 *ts = handle;
> > 	unsigned long flags;
> > 
> > 	spin_lock_irqsave(&ts->lock, flags);
> > 	if (likely(get_pendown_state(ts))) {
> > 		if (!ts->irq_disabled) {
> > 			/* The ARM do_simple_IRQ() dispatcher doesn't act
> > 			 * like the other dispatchers:  it will report IRQs
> > 			 * even after they've been disabled.  We work around
> > 			 * that here.  (The "generic irq" framework may help...)
> > 			 */
> > 			ts->irq_disabled = 1;
> > 			disable_irq(ts->spi->irq);  
> 
> Shouldn't that be disable_irq_nosync()?

Ok, simply stating that without providing an explanation was probably
not so helpful...

I think the problem is that disable_irq() calls synchronize_irq(),
which waits until the corresponding interrupt handler is no longer
running on any CPU. And since we're calling it from the interrupt
handler, we'll have a deadlock because the interrupt handler won't
return until synchronize_irq() returns, and that won't happen until the
interrupt handler returns and so on.

So I think changing disable_irq() into disable_irq_nosync() (which
doesn't call synchronize_irq()) will fix it, though I'm not sure what
difference the threaded interrupt handling code makes -- AFAICT, this
code has always been dangerous.

Haavard
