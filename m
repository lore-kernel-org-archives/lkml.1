Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYGZEt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYGZEt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 00:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYGZEtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 00:49:21 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5801 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYGZEtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 00:49:21 -0400
Subject: Re: [PATCH v3 4/4] powerpc/mpc5200: Add mpc5200-spi (non-PSC)
	device driver
From: Daniel Walker <dwalker@mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org,
       jonsmirl@gmail.com
In-Reply-To: <fa686aa40807251945t26a1656ep7a57ca71faa096c4@mail.gmail.com>
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <20080725073326.8485.99210.stgit@trillian.secretlab.ca>
	 <1217009954.13539.23.camel@localhost.localdomain>
	 <fa686aa40807251945t26a1656ep7a57ca71faa096c4@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 00:47:39 -0400
Message-Id: <1217047659.3970.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 22:45 -0400, Grant Likely wrote:
> On Fri, Jul 25, 2008 at 2:19 PM, Daniel Walker <dwalker@mvista.com> wrote:
> > On Fri, 2008-07-25 at 03:33 -0400, Grant Likely wrote:
> >
> >> +     if (status && (irq != NO_IRQ))
> >> +             dev_err(&ms->master->dev, "spurious irq, status=0x%.2x\n",
> >> +                     status);
> >> +
> >> +     /* Check if there is another transfer waiting */
> >> +     if (list_empty(&ms->queue))
> >> +             return FSM_STOP;
> >
> > I don't think doing list_empty outside the critical section is totally
> > safe.. You might want to move it down inside the spin_lock() section.
> 
> This should be fine.  This is the only place where items are dequeued,
> and it will only ever be called from the ISR or the work queue.  The
> work queue and IRQ will never be active at the same time (I'll add a
> comment to the fact).  It also looks like list_empty is perfectly safe
> to call without the protection of a spin lock (but somebody correct me
> if I'm out to lunch).  It doesn't dereference any of the pointers in
> the list_head structure.

The list_empty wouldn't crash, but the result isn't necessarily
accurate.

> >
> >> +     /* Get the next message */
> >> +     spin_lock(&ms->lock);
> >
> > The part that's a little confusing here is that the interrupt can
> > actually activate the workqueue .. So I'm wondering if maybe you could
> > have this interrupt driven any workqueue driven at the same time? If you
> > could then you would need the above to be
> > spin_lock_irq/spin_lock_irqsave ..
> 
> Ditto here, since the irq and workqueue are not enabled at the same
> time there is no worry about collision.

Why are you waking up the work queue from inside the irq handler? You
might also want to break out the handling from inside the irq handler
and call that from the workqueue, instead of re-calling the irq handler
function from the workqueue.. It's a little confusing from a context
perspective.

Daniel

