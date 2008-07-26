Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYGZCqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYGZCqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 22:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYGZCp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 22:45:56 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:63281 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYGZCp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 22:45:56 -0400
Message-ID: <fa686aa40807251945t26a1656ep7a57ca71faa096c4@mail.gmail.com>
Date: Fri, 25 Jul 2008 22:45:54 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH v3 4/4] powerpc/mpc5200: Add mpc5200-spi (non-PSC) device driver
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org,
       jonsmirl@gmail.com
In-Reply-To: <1217009954.13539.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <20080725073326.8485.99210.stgit@trillian.secretlab.ca>
	 <1217009954.13539.23.camel@localhost.localdomain>
X-Google-Sender-Auth: eb30f428ce4a8709
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 2:19 PM, Daniel Walker <dwalker@mvista.com> wrote:
> On Fri, 2008-07-25 at 03:33 -0400, Grant Likely wrote:
>
>> +     if (status && (irq != NO_IRQ))
>> +             dev_err(&ms->master->dev, "spurious irq, status=0x%.2x\n",
>> +                     status);
>> +
>> +     /* Check if there is another transfer waiting */
>> +     if (list_empty(&ms->queue))
>> +             return FSM_STOP;
>
> I don't think doing list_empty outside the critical section is totally
> safe.. You might want to move it down inside the spin_lock() section.

This should be fine.  This is the only place where items are dequeued,
and it will only ever be called from the ISR or the work queue.  The
work queue and IRQ will never be active at the same time (I'll add a
comment to the fact).  It also looks like list_empty is perfectly safe
to call without the protection of a spin lock (but somebody correct me
if I'm out to lunch).  It doesn't dereference any of the pointers in
the list_head structure.

>
>> +     /* Get the next message */
>> +     spin_lock(&ms->lock);
>
> The part that's a little confusing here is that the interrupt can
> actually activate the workqueue .. So I'm wondering if maybe you could
> have this interrupt driven any workqueue driven at the same time? If you
> could then you would need the above to be
> spin_lock_irq/spin_lock_irqsave ..

Ditto here, since the irq and workqueue are not enabled at the same
time there is no worry about collision.

Cheers,
g.



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
