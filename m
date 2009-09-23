Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZIWIws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZIWIws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZIWIws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:52:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbZIWIwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:52:47 -0400
Subject: Re: perf sched record hangs machine
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Malley <mail@chrismalley.co.uk>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
	 <20090922212453.GB6062@nowhere> <1253686585.7695.84.camel@twins>
	 <20090923073253.GA18022@elte.hu> <20090923074028.GA3078@elte.hu>
	 <aa79d98a0909230044q3548cf0bjda62e05e0400edd6@mail.gmail.com>
	 <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Sep 2009 10:52:48 +0200
Message-Id: <1253695968.7695.125.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 12:48 +0400, Cyrill Gorcunov wrote:
> On 9/23/09, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On 9/23/09, Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> * Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >>>
> >>> * Peter Zijlstra <peterz@infradead.org> wrote:
> >>>
> >>> >         .size   default_send_IPI_self, .-default_send_IPI_self
> >>> >
> >>> > Which seems to suggest that cmove is in __prepare_ICR, but I'm not
> >>> > sure how that can cause a page-fault, as that function is rather
> >>> > pointer-less.
> >>> >
> >>> > Did it maybe delay evaluating apic->dest_logical that late, it appear
> >>> > to be the first usage of that argument?
> >>> >
> >>> > Ingo, any ideas?
> >>>
> >>> Yeah, the problem is:
> >>>
> >>> [    0.042445] Local APIC not detected. Using dummy APIC emulation.
> >>>
> >>> we shouldnt be trying to program the lapic in that case - all ops
> >>> should be a NOP, including send-ipi-self. Cyrill?
> >>
> >> Cyrill, the right fix would be to define a:
> >>
> >> 	struct apic apic_none;
> >>
> >> with dummy functions injected. Set struct apic *apic to _that_, instead
> >> of apic_default.
> >>
> >> This means that if we manage to detect a local APIC, we will set it to
> >> apic_default (or some other driver) - but the bootup default will be 'no
> >> APIC'.
> >>
> >
> > May it wait till evening (i'll back from office and take a look)?
> >
> >> This is a lot cleaner and a lot less error-prone than the direct
> >> frobbing of the function pointers.
> >>
> >> 	Ingo
> >>
> >
> 
> Btw, meanwhile Chris may try to pass lapic boot-option in attempt to
> reenable apic via msr registers. Also (iirc) i feel we may be hiding
> errors if complete noop apic would be used since i belive we need to
> check out under which condition a particular operation is called and
> when apic is disabled it's mean we're switched to UP mode and
> inter-cpu interrupts are under suspicion too. Will take a look during
> ~6 hours ;)

Thing is, this is a self-ipi, nothing inter-cpu about it.
