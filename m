Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbXGZQYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbXGZQYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbXGZQYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:24:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758496AbXGZQYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:24:13 -0400
Date: Thu, 26 Jul 2007 12:22:31 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ankita Garg <ankita@in.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       linux@bohmer.net, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070726162231.GB30643@redhat.com>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com> <20070726133138.GA30559@Krystal> <y0mps2f1asz.fsf@ton.toronto.redhat.com> <20070726150226.GB1299@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726150226.GB1299@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jul 26, 2007 at 11:02:26AM -0400, Mathieu Desnoyers wrote:
> [...]
> > > The problem is also in _stp_print_flush, not *only* in relay code:
> > > void _stp_print_flush (void)
> > > ...
> > >                 spin_lock(&_stp_print_lock);
> > >                 spin_unlock(&_stp_print_lock);
> > > 
> > > Those will turn into mutexes with -rt.
> > 
> > Indeed,

(Though actually that bug was fixed some time ago.)


> > plus systemtap-generated locking code uses rwlocks,
> > local_irq_save/restore or preempt_disable, in various places.  Could
> > someone point to a place that spells out what would be more
> > appropriate way of ensuring atomicity while being compatible with -rt?
> 
> AFAIK, for your needs either:
> [...]
> - Use per-cpu data with preempt disabling/irq disabling

As in local_irq_save / preempt_disable?  Yes, already done.

> - Use the original "real" spin locks/rwlocks (raw_*).
> [...]

It was unclear from the OLS paper whether the spin_lock_irq* family of
functions also had to be moved to the raw forms.

> You just don't want to sleep in the tracing code. [...]  Since you
> will likely disable preemption, make sure your tracing code executes
> in a deterministic time.

Definitely, that has always been the case.

> Make sure that the sub-buffer switch code respects that too [...]

We will review that part of the related code.

- FChE
