Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZJGDYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZJGDYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZJGDYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:24:05 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:33259 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbZJGDYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:24:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsFAP+hy0pMROOX/2dsb2JhbACBUtNAhCoEgVM
Date: Tue, 6 Oct 2009 23:23:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ak@suse.de, roland@redhat.com, rth@redhat.com
Subject: Re: [PATCH 1/4] jump label - make init_kernel_text() global
Message-ID: <20091007032324.GA12202@Krystal>
References: <cover.1253831945.git.jbaron@redhat.com> <77d69d0f3c8e1f98a4c2392ea4e4f6c25ed177f4.1253831946.git.jbaron@redhat.com> <20091001112003.GA2962@elte.hu> <20091001203905.GD2660@redhat.com> <20091003104335.GB15919@elte.hu> <20091003123900.GA22046@Krystal> <1254880478.1696.104.camel@gandalf.stny.rr.com> <20091007023251.GA4664@Krystal> <4ACC06A4.5080508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4ACC06A4.5080508@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 23:18:26 up 49 days, 14:07,  2 users,  load average: 0.32, 0.22,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> 
> 
> Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> >> On Sat, 2009-10-03 at 08:39 -0400, Mathieu Desnoyers wrote:
> >>
> >>> I might be missing a bit of context here, I just want to make sure we
> >>> are on the same page: patching a jmp instruction is safe on UP, safe
> >>> with stop_machine(), is very likely safe with the breakpoint-ipi
> >>
> >> Hi Mathieu,
> >>
> >> I've been reading through these threads (both this one and the immediate
> >> one) and I'm still a bit confused. I really want to understand this in a
> >> simple way, thus make sure everyone else understands it too.
> >>
> >> >From what Arjan said here:
> >>
> >>   http://lkml.org/lkml/2009/9/25/98
> >>
> >> The issue is going back from the int3 to the old value. How does the
> >> breakpoint-ipi work?
> >>
> >> Supposedly, we can add an int3 to the code without any worry. If another
> >> CPU at that same time hits that code path, it will either run the old
> >> code, or take the interrupt. The breakpoint interrupt handler, will
> >> handle that code path, and the execution continues.
> >>
> >> Now what is the issues with removing the int3 and placing back the old
> >> (or new) value. Is there an issue if another CPU is about to execute
> >> that code path as we remove the int3? If so, how does sending an IPI
> >> help the matter without adding more races?
> >>
> >> Is there only an issue if we change the old value with something else,
> >> and you just need to send the IPI after you modify the old code and
> >> before removing the int3?
> >>
> >> I may just be totally confused, which I usually am. But when I'm not
> >> confused, I feel that the code is practical ;-)
> >>
> > 
> > Hi Steven,
> > 
> > OK, I'll make the explanation as straightforward as possible. I'll use a
> > race example to illustrate what we try to avoid by using the
> > breakpoint+ipi scheme. After that, I present the same scenario with the
> > breakpoint+ipi in place.
> > 
> > Each step shows what is executed, and what is the memory values seen by
> > the CPU. CPU A is doing the code patching, CPU B executing the code.
> > I intentionally left out some sfence required on CPU A for simplicity.)
> > 
> > Initially, let's say we have:
> > (1)  (2)
> > 0xeb 0xe5    (jmp to offset 0xe5)
> > 
> > And we want to change this to:
> > (1)  (2)
> > 0xeb 0xf0    (jmp to offset 0xf0)
> > 
> > (scenario "buggy")
> > 
> > CPU A       |       CPU B  (this is about as far as my ascii-art skills go)
> > -------------------------    ;)
> > 0xeb 0xe5     0xeb 0xe5
> > 0:            CPU B instruction pointer is earlier than (1)
> >               CPU B pipeline speculatively predicts branches,
> >               prefetches data, calculates speculated values.
> > 1:            CPU B loads 0xeb
> > 2:            CPU B loads 0xe5
> > 3:
> > Write to (2)
> > 0xeb 0xf0     0xeb 0xf0
> > 4:            CPU B instruction pointer gets to (1), needs to validate
> >               all the pipeline speculation.
> >               But ! The CPU does not expect code to change underneath.
> >               General protection fault (or any other fault.. random..)
> > 
> > 
> > Now with the breakpoint+ipi/mb() scheme:
> > (scenario A: CPU B does not hit the breakpoint)
> > 
> > CPU A       |       CPU B
> > -------------------------
> > 0xeb 0xe5     0xeb 0xe5
> > 0:            CPU B instruction pointer is earlier than (1)
> >               CPU B pipeline speculatively predicts branches,
> >               prefetches data, calculates speculated values.
> > 1:            CPU B loads 0xeb
> > 2:            CPU B loads 0xe5
> > 3:
> > Write to (1)
> > 0xcc 0xe5     0xcc 0xe5  # breakpoint inserted
> > 4: send IPI
> > 5:            mfence     # serializing instruction. Flushes CPU B's
> >                          # pipeline
> > 6:
> > Write to (2)
> > 0xcc 0xf0     0xcc 0xf0
> > 7:
> > Write to (1)
> > 0xeb 0xf0     0xeb 0xf0
> > 8:            CPU B instruction pointer gets to (1), needs to validate
> >               all the pipeline speculation. Because we flushed any
> >               speculation prior to the mfence, we're ok.
> > 
> > 
> > Now, I'll show why just using the breakpoint, without IPI, is
> > problematic:
> > 
> > CPU A       |       CPU B
> > -------------------------
> > 0xeb 0xe5     0xeb 0xe5
> > 0:            CPU B instruction pointer is earlier than (1)
> >               CPU B pipeline speculatively predicts branches,
> >               prefetches data, calculates speculated values.
> > 1:            CPU B loads 0xeb
> > 2:            CPU B loads 0xe5
> > 3:
> > Write to (1)
> > 0xcc 0xe5     0xcc 0xf0  # breakpoint inserted
> > 4:
> > Write to (2)
> > 0xcc 0xf0     0xeb 0xf0  # Silly CPU B. Did not see nor use the breakpoint.
> >                          # Same problem as scenario "buggy".
> > 5:
> > Write to (1)
> > 0xeb 0xf0     0xeb 0xf0
> > 4:            CPU B instruction pointer gets to (1), needs to validate
> >               all the pipeline speculation.
> >               But ! The CPU does not expect code to change underneath.
> >               General protection fault (or any other fault.. random..)
> > 
> > So, basically, we ensure that the only transitions CPU B will see are
> > either:
> > 
> > 0xeb 0xe5 -> 0xcc 0xe5 : OK, adding breakpoint
> > 0xcc 0xe5 -> 0xcc 0xf0 : OK, not using the operand anyway, it's a
> >                              breakpoint!
> > 0xcc 0xf0 -> 0xeb 0xf0 : OK, removing breakpoint
> > 
> > *but*, the transition we guarantee that CPU B will *never* see without
> > having a mfence executed between the old and the new version is:
> > 
> > 0xeb 0xe5 -> 0xeb 0xf0  <----- buggy.
> > 
> > Hope the explanation helps,
> 
> Thanks for explanation.
> One thing I'd like to know is why you are using mfence
> instead of cpuid (a.k.a. sync_core()). I assume that old
> processor doesn't have mfence and is that OK?

Ah, right. Well then we can use cpuid for portability to older archs
lacking mfence.

The reason why I use mfence here is that I wanted to combine:

lfence
cpuid

into

mfence

I use a lfense on CPU B before the cpuid (and matching sfence on CPU A
between the moment I write the breakpoint instruction and the moment I
send the IPI, and another one between the moment CPU A knows the IPI has
been executed and the moment it writes the new operands).

Thanks,

Mathieu

> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
