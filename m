Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbZFPVOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbZFPVOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZFPVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:14:22 -0400
Received: from tomts38.bellnexxia.net ([209.226.175.95]:45819 "EHLO
	tomts38-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbZFPVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:14:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlEGADOoN0pMROLw/2dsb2JhbACBT9NDhAsF
Date: Tue, 16 Jun 2009 17:13:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090616211357.GB21305@Krystal>
References: <20090615223038.GA15903@Krystal> <4A36CCFC.8070908@zytor.com> <20090615224908.GA16661@Krystal> <4A36F520.6020604@zytor.com> <20090616030522.GA22162@Krystal> <20090616083343.GD16229@elte.hu> <20090616141956.GB6541@Krystal> <4A37B8CF.8090804@zytor.com> <20090616190634.GA16430@Krystal> <4A380000.5090206@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A380000.5090206@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:55:59 up 108 days, 17:22,  4 users,  load average: 1.22, 0.87,
	0.61
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
> > * H. Peter Anvin (hpa@zytor.com) wrote:
> >> Mathieu Desnoyers wrote:
> >>> With respect to cr2, yes, this is the only window we care about.
> >>> However, the rest of vmalloc_fault() must be audited for other non
> >>> nmi-suitable data structure use (e.g. "current"), which I did in the
> >>> past.
> >>>
> >>> My intent was just to respond to Peter's concerns by showing that the
> >>> part of page fault handler which needs to be NMI-reentrant is really not
> >>> that big.
> >>>
> >> Even if that is true now, you want it to be true for all future time,
> >> and all to support an out-of-tree piece of code.  All of this is
> >> virtually impossible to test for without said out-of-tree piece of code,
> >> so I will object to it anyway.
> >>
> > 
> > I think we are confusing two very distinct topics here :
> > 
> > LTTng is currently out-of-tree. Yes. It does not have to stay like this
> > in the future. Or it can be a different tracer, like ftrace for
> > instance.
> > 
> > LTTng can be built as modules. This is very likely to stay like this
> > even if LTTng (or parts of) are merged. Or as a different tracer is
> > merged. The reason why building a tracer as a module is convenient for
> > users has been expressed in a previous mail.
> > 
> > So now you argue that it should not be made easy to implement
> > tracers/profilers so they can be built as kernel modules because the
> > LTTng tracer is out-of-tree. I'm sorry, but I really don't follow your
> > line of reasoning.
> > 
> > So let's say we merge tracer or profiler code into the mainline kernel
> > and permit that code to be built as module, hence enable testing within
> > the mainline tree, would you be fine with this?
> > 
> 
> I'm saying that imposing constraints on kernel code has cost.  The cost
> may not be immediately evident, but it constraints the kernel
> development going forward, potentially for all times.  It is
> particularly obnoxious with out-of-tree users, because it is impossible
> to fix up those users to deal with a new interface, or even know what
> their constraints really are.
> 
> This is part of the fundamental problem that Xen causes, for example.
> 

Agreed. And I agree that mainlining such users is a big part of the
answer, because then it makes the whole community aware of their
(ab)uses. However, wrt the specific case discussed here, I prefer by far
adding a reentrancy constraint on a very well defined path of the trap
handler if it permits to simplify a bunch of in-kernel users. This added
encapsulation of architecture corner-cases will eventually make overall
kernel development _simpler_, not harder.

Now if such encapsulation has an unbearable runtime cost, fine, we're
big boys and we can tweak the kernel code to deal on a case-by-case
basis with these corner-cases. However this kind of approach is usually
more error-prone.

So, in summary :

- near-zero measurable runtime cost.
- NMI-reentrancy constraint on a very small and well-defined trap
  handler code path.
- simplifies life of tracer and profilers. (meaning : makes a lot of
  _other_ kernel code much easier to write and understand)
- removes ad-hoc corner cases management from those users.
- provides early error detection because the nmi-reentrant code path is
  shared by all users.

So I'll use your own argument : making this trap handler code path
nmi-reentrant will simplify an already existing bunch of in-kernel users
(oprofile, perf counter tool, ftrace..). Moving the burden from
subsystems spread across the kernel tree to a single, well defined spot
looks like a constraint that will _diminish_ overall kernel development
cost.

Mathieu

> 	-hpa

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
