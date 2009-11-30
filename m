Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZK3KFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZK3KFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZK3KFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:05:39 -0500
Received: from www.tglx.de ([62.245.132.106]:44583 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZK3KFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:05:39 -0500
Date: Mon, 30 Nov 2009 11:02:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: kernel/smp.c:292 smp_call_function_single [Was: mmotm
 2009-11-24-16-47 uploaded]
In-Reply-To: <4B138950.9040905@kernel.org>
Message-ID: <alpine.LFD.2.00.0911301055000.24119@localhost.localdomain>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>  <4B0FEA3E.5050108@gmail.com> <1259335036.6483.440.camel@laptop> <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain> <4B1113C0.30505@redhat.com> <4B138950.9040905@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Tejun Heo wrote:
> Hello,
> 
> On 11/28/2009 09:12 PM, Avi Kivity wrote:
> >> Hmm, commit 498657a moved the fire_sched_in_preempt_notifiers() call
> >> into the irqs disabled section recently.
> >>
> >>      sched, kvm: Fix race condition involving sched_in_preempt_notifers
> >>
> >>      In finish_task_switch(), fire_sched_in_preempt_notifiers() is
> >>      called after finish_lock_switch().
> >>
> >>      However, depending on architecture, preemption can be enabled after
> >>      finish_lock_switch() which breaks the semantics of preempt
> >>      notifiers.
> >>
> >>      So move it before finish_arch_switch(). This also makes the in-
> >>      notifiers symmetric to out- notifiers in terms of locking - now
> >>      both are called under rq lock.
> >>
> >> It's not a surprise that this breaks the existing code which does the
> >> smp function call.
> > 
> > Yes, kvm expects preempt notifiers to be run with irqs enabled.  Copying
> > patch author.
> 
> Hmmm... then, it's broken both ways.  The previous code may get
> preempted after scheduling but before the notifier is run (which
> breaks the semantics of the callback horribly), the current code

No, it _CANNOT_ be preempted at that point:

schedule()
{
	preempt_disable();

	switch_to();

	preempt_enable();
}

> doesn't satisfy kvm's requirement.  Another thing is that in the
> previous implementation the context is different between the 'in' and
> 'out' callbacks, which is subtle and nasty.  Can kvm be converted to
> not do smp calls directly?
> 
> For the time being, maybe it's best to back out the fix given that the
> only architecture which may be affected by the original bug is ia64
> which is the only one with both kvm and the unlocked context switch.

Do you have a pointer to the original bug report ?

Thanks,

	tglx
