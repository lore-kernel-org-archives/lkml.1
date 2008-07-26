Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYGZFUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYGZFUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 01:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYGZFUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 01:20:09 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:17912 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYGZFUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 01:20:08 -0400
Message-ID: <fa686aa40807252220x5b224e91ucca467ff6eecc0ae@mail.gmail.com>
Date: Sat, 26 Jul 2008 01:20:06 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH v3 4/4] powerpc/mpc5200: Add mpc5200-spi (non-PSC) device driver
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org,
       jonsmirl@gmail.com
In-Reply-To: <1217047659.3970.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <20080725073326.8485.99210.stgit@trillian.secretlab.ca>
	 <1217009954.13539.23.camel@localhost.localdomain>
	 <fa686aa40807251945t26a1656ep7a57ca71faa096c4@mail.gmail.com>
	 <1217047659.3970.14.camel@localhost.localdomain>
X-Google-Sender-Auth: 149fbee35a840bbd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 12:47 AM, Daniel Walker <dwalker@mvista.com> wrote:
> On Fri, 2008-07-25 at 22:45 -0400, Grant Likely wrote:
>> On Fri, Jul 25, 2008 at 2:19 PM, Daniel Walker <dwalker@mvista.com> wrote:
>> > On Fri, 2008-07-25 at 03:33 -0400, Grant Likely wrote:
>> >
>> >> +     if (status && (irq != NO_IRQ))
>> >> +             dev_err(&ms->master->dev, "spurious irq, status=0x%.2x\n",
>> >> +                     status);
>> >> +
>> >> +     /* Check if there is another transfer waiting */
>> >> +     if (list_empty(&ms->queue))
>> >> +             return FSM_STOP;
>> >
>> > I don't think doing list_empty outside the critical section is totally
>> > safe.. You might want to move it down inside the spin_lock() section.
>>
>> This should be fine.  This is the only place where items are dequeued,
>> and it will only ever be called from the ISR or the work queue.  The
>> work queue and IRQ will never be active at the same time (I'll add a
>> comment to the fact).  It also looks like list_empty is perfectly safe
>> to call without the protection of a spin lock (but somebody correct me
>> if I'm out to lunch).  It doesn't dereference any of the pointers in
>> the list_head structure.
>
> The list_empty wouldn't crash, but the result isn't necessarily
> accurate.

It doesn't need to be accurate because the spinlock is obtained before
actually trying to dequeue anything.  Even if it held the spinlock
there would still be uncertainty depending on which routine ran first.
 If this function ran first, then it's going to stop the state machine
regardless and the enqueue function will have to kick it off again
anyway.

But, I've taken a look at the code, and you're right, the spin lock
does need to be held while running the state machine because I do have
a case where the IRQ and workqueue could get executed at the same
time.  I'll fix it up.

>
>> >
>> >> +     /* Get the next message */
>> >> +     spin_lock(&ms->lock);
>> >
>> > The part that's a little confusing here is that the interrupt can
>> > actually activate the workqueue .. So I'm wondering if maybe you could
>> > have this interrupt driven any workqueue driven at the same time? If you
>> > could then you would need the above to be
>> > spin_lock_irq/spin_lock_irqsave ..
>>
>> Ditto here, since the irq and workqueue are not enabled at the same
>> time there is no worry about collision.
>
> Why are you waking up the work queue from inside the irq handler? You
> might also want to break out the handling from inside the irq handler
> and call that from the workqueue, instead of re-calling the irq handler
> function from the workqueue.. It's a little confusing from a context
> perspective.

Sure, I can rework that.  The irq handler would then just simply be a
straight call into the state machine runner.  I just dropped the
additional 4 lines of code for conciseness, but I can change it around
for clarity... actually, with the spin lock stuff above I need to do
this rework.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
