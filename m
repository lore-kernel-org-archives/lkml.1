Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYBYLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYBYLVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYBYLVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:21:05 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46709 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751384AbYBYLVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:21:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=uXzbiq1afrtb4lGRHRB2qpPmMtukpOPLbt+Modn6dAOD90reHigxgP2DkSzJDDFikcH+JKEwRglYd4z7SzmZKusNsfoXmlX7eNweCQQNuL/n8J8U3V3aB23PMEv4T1haMV1b2mAKtMrL4eCzfd2HhrKBDRb38kodu/59e1u7e5I=  ;
X-YMail-OSG: 1shHS04VM1mU0Hp_n1UT6r6E8JZP6LJugTXcomgQNWTNDowrBUAoDBgSTE_vHV.rHXB_RIlBMQ--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 25 Feb 2008 03:21:02 -0800
From: David Brownell <david-b@pacbell.net>
To: peterz@infradead.org
Subject: Re: [patch 2.6.25-rc3] lockdep:  add spin_lock_irq_nested()
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
References: <200801181429.00485.david-b@pacbell.net>
 <1200904299.6341.2.camel@lappy>
 <200801211022.36312.david-b@pacbell.net>
 <200802242033.52208.david-b@pacbell.net>
 <1203934828.6242.140.camel@lappy>
In-Reply-To: <1203934828.6242.140.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080225112102.3B6E928E368@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > >     ==> LOCKDEP feature is evidently missing:
> > > > >             spin_lock_irq_nested(lock_ptr, lock_class)
> > > > 
> > > > This rant is more lines than adding the API :-/ the reason for it not
> > > > being there is simple, it wasn't needed up until now.
> > > 
> > > I suspected that was the case, but for all I knew there was some
> > > religious objection. 
> > 
> > Does this look about right?  Or, I suppose it could just call
> > the _spin_lock_irqsave_nested() routine and discard the result.
>
> Before I look at the code, and with a notice that I haven't had my
> morning juice yet...
>
> It seems to me a spin_lock_irq_nested() thing is redundant, because:
>
> The lock must obviously be held hardirq safe and nested implies one is
> already held.

I thought the way to use the *_nested() calls was "consistently"!

That is, if one instance of a lock access uses it, they all should,
since that's the only way lockdep learns about equivalence classes.
Also, locks shouldn't move between those equivalence classes... so
the raw lockdep data stays correct.

The IRQ framework uses spin_lock_irq() in only one place that I saw:
in kernel/irq/autoprobe.c for the probe_irq_{on,off,mask}() calls.

Those calls will grab locks at their "top level", and then the
irqchip methods they call might need to grab locks for other irqs.
Potential example:  chip->startup() and chip->shutdown() could
need to ensure a *parent* controller starts/stops, and that should
involve mutual exclusion using the parent's irq lock (as well as
the child's).  So the chip and its parent should be in different
lock classes, else lockdep will wrongly warn of recursion.


>	Hence the context is already hardirq safe thus using
> spin_lock_irq/spin_unlock_irq is wrong because it will enable irqs and
> destroy the irqsafe guarantee for the parent lock.

That's not how the autoprobe() stuff works.  The other calls in
the genirq framework don't use the *_irq() variants though, so
your intuition is right there.  (Only the autoprobe paths had
the FIXME comments in that patch I sent earlier, related to the
lack of the $SUBJECT primitive.)


> Obviously I'm missing something here.. otherwise you wouldn't need it.
>
> As I'm very much not familiar with the IRQ code, could you spell it out
> to me?

The probe_irq_*() calls are made from task context, not hardirq
context, but they access the same locks involved in IRQ management
and processing.  So either they need to pass the same lock class
annodations to lockdep, or there's something that's unusually
counter-intuitive going on with respect to those annotations in
simple tree data structures.

- Dave

