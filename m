Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbXIUOPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbXIUOPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbXIUOPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:15:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:21591 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbXIUOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qd/EirdvggtYbPWx8Bu7XVsI6RTMAghhyebglHnyQZOOxSyj42yEJVcY5eRwZIR3OnRWgl9PQJb40VQ8nsd8zEDyUB+MuL2oBSbNGyalNYw0TxTj4Ymqic+TOxqu0rnLj1oc51ThMfrZ2vrYR2oYXslGChDKJnFdUvzd0Qh6YJo=
Message-ID: <d120d5000709210715q22682893ib87998727baffe38@mail.gmail.com>
Date: Fri, 21 Sep 2007 10:15:10 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070921000155.GI9825@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070919174857.GA11922@linux.vnet.ibm.com>
	 <20070919214110.5d832f28@lappy>
	 <d120d5000709191249w461967d6w8da303dc54f2dd41@mail.gmail.com>
	 <20070919221349.2935f69d@lappy>
	 <d120d5000709191341p1c331e80qf7bad973bc899a0@mail.gmail.com>
	 <20070919231943.4b121361@lappy>
	 <d120d5000709191429n29f5dc78g2746de3ee4e9ca81@mail.gmail.com>
	 <20070919234700.3b532dcd@lappy>
	 <d120d5000709201031o687ac0d5qe4d32406c12a7886@mail.gmail.com>
	 <20070921000155.GI9825@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/07, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Sep 20, 2007 at 01:31:35PM -0400, Dmitry Torokhov wrote:
> >
> > OK, then what is the purpose of synchronize_sched() in -rt?
>
> To wait for all preempt-disable, irq-disable, hard-irq, and SMI/NMI code
> sequences to complete.

OK, so what spin_lock_irq[save]? Does is disable IRQs in -rt or not anymore?
If IRQs are disabled it appears that I can continue using synchronize_sched().

>
> > You really need to provide users with a replacement. There are several
> > drivers that use it and for example r8169 is not what you'd call a
> > 'low performer'.
>
> I did look at making a synchronize_all_irq() some time back, and all
> the approaches I came up with at the time were busted.
>
> But I just took another look, and I think I see a way to handle it.
> Either that, or I simply forgot the way in which this approach is
> broken...
>
> I will stare at is some more.
>

Thank you.

> > I guess I can switch i8042 to use synchronize_irq(). That still works
> > in -rt, doesn't it? That still leaves atkbd...
>
> Yep, looks that way to me.  The only difference that I can see is that
> in -rt, concurrent synchronize_irq() calls on the same descriptor mean
> that the guy that gets there second has to wait for the next interrupt
> to happen.
>

Does this mean that there is a possibility for a thread to hang in
synchronize_irq() if that second IRQ never comes?

-- 
Dmitry
