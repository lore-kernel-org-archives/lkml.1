Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZFVWzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZFVWzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFVWz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:55:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZFVWzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:55:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] genirq: do not disable IRQ_WAKEUP marked irqs on suspend
Date: Tue, 23 Jun 2009 00:56:05 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, khilman@deeprootsystems.com,
       linux-kernel@vger.kernel.org
References: <cMiA9-1MZ-13@gated-at.bofh.it> <alpine.LFD.2.00.0906122039420.2800@localhost.localdomain> <20090622142722.183fedc8.akpm@linux-foundation.org>
In-Reply-To: <20090622142722.183fedc8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230056.06387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Andrew Morton wrote:
> On Fri, 12 Jun 2009 21:52:46 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 12 Jun 2009, Kevin Hilman wrote:
> > >   http://lkml.org/lkml/2009/5/4/448
> > > 
> > > Only difference is I did the checking outside of the lock, which is
> > > probably wrong.  In any case, you'll be interested in the thread that
> > > follows.
> > 
> > Hmm, darn. That means that on hardware which has trouble with the
> > delayed disable and therefor uses it's own chip->disable_irq() method
> > the suspend logic is wreckaged.
> 
> Does this maen that your original patch is no longer applicable to
> mainline/-stable?

I'd say so.  There are good arguments for not doing this.

> > But there is always a way to get broken hardware tamed. :)
> > 
> > suspend does:
> > 	__disable_irq();
> > 		status |= IRQ_SUSPENDED;
> > 		chip->disable_irq();
> > 
> > resume does:
> >        __enable_irq();
> > 		status &= ~IRQ_SUSPENDED;
> > 		chip->enable_irq();
> > 
> > So
> > 
> > -      set_irq_handler(handle_level_irq);
> > +      set_irq_handler(my_own_handler);
> > 
> > +my_own_handler()
> > +{
> > +	if (!(status & IRQ_SUSPENDED)) {
> > +	       handle_level_irq();
> > +	} else {
> > +	       mask_at_hardware_level();
> > +	       status |= IRQ_PENDING;
> > +	       save_important_information();
> > +	} 
> > +}
> > 
> > my_disable_irq()
> > {
> > +	if (!(status & IRQ_SUSPENDED))
> > 	       mask_at_hardware_level();
> > }
> > 
> > my_enable_irq()
> > {
> > +	if (important_information_has_been_saved)
> > +	       replay_what_happened();
> > +
> >         unmask_at_hardware_level();
> > }
> > 
> > Ugly, but that might work somehow. Not sure about the replay part, but
> > that can be deferred via some more hackery as well :)
> > 
> > Raphael, these delayed disable and the chip->irq_disable() override
> > implications vs. suspend really need to be documented. The current
> > comment of suspend_device_irqs() is bogus:
> > 
> >  * During system-wide suspend or hibernation device interrupts need to be
> >  * disabled at the chip level and this function is provided for this purpose.
> >    ^^^^^^^^^^^^^^^^^^^^^^^^^^
