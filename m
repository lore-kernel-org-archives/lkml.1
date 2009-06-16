Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbZFPPmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbZFPPmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759110AbZFPPmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:42:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47821 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbZFPPmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:42:23 -0400
Date: Tue, 16 Jun 2009 18:41:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based
	notifier interface
Message-ID: <20090616154150.GA17494@redhat.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37B832.6040206@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 11:20:18AM -0400, Gregory Haskins wrote:
> >>> eventfd can't detect this state. But the callers know in what context they are.
> >>> So the *caller* of eventfd_signal_task makes sure of this: if you are in a task,
> >>> you can call eventfd_signal_task() if not, you must call eventfd_signal.
> >>>
> >>>
> >>>   
> >>>       
> >> Hmm, this is an interesting idea, but I think it would be problematic in
> >> real-world applications for the long-term.  For instance, the -rt tree
> >> and irq-threads .config option in the process of merging into mainline
> >> changes context types for established code.  Therefore, what might be
> >> "hardirq/softirq" logic today may execute in a kthread tomorrow.
> >>     
> >
> > That's OK, it's always safe to call eventfd_signal: eventfd_signal_task is just
> > an optimization. I think everyone not in the context of a system call or vmexit
> > can just call eventfd_signal_task.
> >   
>                                  ^^^^^^^^^^^^^^^^^^^^
> 
> I assume you meant s/eventfd_signal_task/eventfd_signal there?

Yea. Sorry.

> >   
> >>  I
> >> think its dangerous to try to solve the problem with caller provided
> >> info:  the caller may be ignorant of its true state.
> >>     
> >
> > I assume this wasn't clear enough: the idea is that you only
> > calls eventfd_signal_task if you know you are on a systemcall path.
> > If you are ignorant of the state, call eventfd_signal.
> >   
> 
> Well, its not a matter of correctness.  Its more for optimal
> performance.  If I have PCI pass-though injecting interrupts from
> hardirq in mainline, clearly eventfd_signal() is proper.  In -rt, the
> hardirq is transparently converted to a kthread, so technically
> eventfd_signal_task() would work

I think it's wrong to sleep for a long time while handling interrupts even if
you technically can with threaded interrupts. For that matter, I think you can
sleep while within a spinlock if preempt is on, but that does not mean you
should - and I think you will get warnings in the log if you do. No?

> (at least for the can_sleep() part, not
> for current->mm per se).  But in this case, the PCI logic would not know
> it was converted to a kthread.  It all happens transparently in the
> low-level code and the pci code is unmodified.
> 
> In this case, your proposal would have the passthrough path invoking
> irqfd with eventfd_signal().  It  would therefore still shunt to a
> workqueue to inject the interrupt, even though it would have been
> perfectly fine to just inject it directly because taking
> mutex_lock(&kvm->irq_lock) is legal.

This specific issue should just be addressed by making it possible
to inject the interrupt from an atomic context.

>  Perhaps I am over-optimizing, but
> this is the scenario I am concerned about and what I was trying to
> address with preemptible()/can_sleep().

What, a path that is never invoked without threaded interrupts?
Yes, I would say it currently looks like an over-optimization.

> I think your idea is a good one to address the current->mm portion.  It
> would only ever be safe to access the MM context from syscall/vmexit
> context, as you point out.  Therefore, I see no problem with
> implementing something like iosignalfd with eventfd_signal_task().
> 
> But accessing current->mm is only a subset of the use-cases.  The other
> use-cases would include the ability to sleep, and possibly the ability
> to address other->mm.  For these latter cases, I really only need the
> "can_sleep()" behavior, not the full blown "can_access_current_mm()". 
> Additionally, the eventfd_signal_task() data at least for iosignalfd is
> superfluous:  I already know that I can access current->mm by virtue of
> the design.

Maybe I misunderstand what iosignalfd is - isn't it true that you get eventfd
and kvm will signal that when guest performs io write to a specific
address, and then drivers can get eventfd and poll it to detect
these writes?

If yes, you have no way to know that the other end of eventfd
is connected to kvm, so you don't know you can access current->mm.

> So since I cannot use it accurately for the hardirq/threaded-irq type
> case, and I don't actually need it for the iosignalfd case, I am not
> sure its the right direction (at least for now).  I do think it might
> have merit for syscal/vmexit uses outside of iosignalfd, but I do not
> see a current use-case for it so perhaps it can wait until one arises.
> 
> -Greg

But, it addresses the CONFIG_PREEMPT off case, which your design doesn't
seem to.

> >   
> >>  IMO, the ideal
> >> solution needs to be something we can detect at run-time.
> >>
> >> Thanks Michael,
> >> -Greg
> >>
> >>     
> >
> >
> >   
> 
> 


