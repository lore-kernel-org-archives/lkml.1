Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZK0QqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZK0QqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 11:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZK0QqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 11:46:11 -0500
Received: from www.tglx.de ([62.245.132.106]:49069 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbZK0QqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 11:46:10 -0500
Date: Fri, 27 Nov 2009 17:44:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: kernel/smp.c:292 smp_call_function_single [Was: mmotm
 2009-11-24-16-47 uploaded]
In-Reply-To: <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911271742180.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009, Thomas Gleixner wrote:
> On Fri, 27 Nov 2009, Peter Zijlstra wrote:
> 
> > On Fri, 2009-11-27 at 16:03 +0100, Jiri Slaby wrote:
> > > On 11/25/2009 01:47 AM, akpm@linux-foundation.org wrote:
> > > > The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to
> > > 
> > > Hi, when executing qemu-kvm I often get following warning and a hard lockup.
> > > 
> > > WARNING: at kernel/smp.c:292 smp_call_function_single+0xbd/0x140()
> > > Hardware name: To Be Filled By O.E.M.
> > > Modules linked in: kvm_intel kvm fuse ath5k ath
> > > Pid: 3265, comm: qemu-kvm Not tainted 2.6.32-rc8-mm1_64 #912
> > > Call Trace:
> > >  [<ffffffff81039678>] warn_slowpath_common+0x78/0xb0
> > >  [<ffffffffa007fd50>] ? __vcpu_clear+0x0/0xd0 [kvm_intel]
> > >  [<ffffffff810396bf>] warn_slowpath_null+0xf/0x20
> > >  [<ffffffff8106410d>] smp_call_function_single+0xbd/0x140
> > >  [<ffffffffa0080af6>] vmx_vcpu_load+0x46/0x170 [kvm_intel]
> > >  [<ffffffffa004dd94>] kvm_arch_vcpu_load+0x24/0x60 [kvm]
> > >  [<ffffffffa0047a8d>] kvm_sched_in+0xd/0x10 [kvm]
> > >  [<ffffffff8102de37>] finish_task_switch+0x67/0xc0
> > >  [<ffffffff814699f8>] schedule+0x2f8/0x9c0
> > 
> > > 
> > > It is a regression against 2009-11-13-19-59.
> > > 
> > > Any ideas?
> > 
> > Looks like kvm is trying to send an IPI from the preempt notifiers,
> > which are called with IRQs disabled, not a sane thing to do.
> > 
> > If they really want that, they'll have to use a pre-allocated struct
> > call_single_data and use __smp_call_function_single.
> 
> Hmm, commit 498657a moved the fire_sched_in_preempt_notifiers() call
> into the irqs disabled section recently.
> 
>     sched, kvm: Fix race condition involving sched_in_preempt_notifers
>     
>     In finish_task_switch(), fire_sched_in_preempt_notifiers() is
>     called after finish_lock_switch().
>     
>     However, depending on architecture, preemption can be enabled after
>     finish_lock_switch() which breaks the semantics of preempt
>     notifiers.

This is patently wrong btw.

schedule()
{

need_resched:
        preempt_disable();
....
	task_switch();
....

        preempt_enable_no_resched();
	if (need_resched())
                goto need_resched;
}

>     
>     So move it before finish_arch_switch(). This also makes the in-
>     notifiers symmetric to out- notifiers in terms of locking - now
>     both are called under rq lock.
> 
> It's not a surprise that this breaks the existing code which does the
> smp function call.

Thanks,

	tglx
