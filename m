Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYIWCC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYIWCC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYIWCCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:02:19 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:47394 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbYIWCCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:02:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEANzo10hMQWq+/2dsb2JhbACBXbUNgWY
Date: Mon, 22 Sep 2008 22:02:16 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923020216.GC24937@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com> <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <adaod2f649o.fsf@cisco.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:39:45 up 110 days,  6:20,  7 users,  load average: 0.89, 0.45,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Dreier (rdreier@cisco.com) wrote:
>  > Because all it tells you is the ordering of the atomic increment, not of 
>  > the caller. The atomic increment is not related to all the other ops that 
>  > the code that you trace actually does in any shape or form, and so the 
>  > ordering of the trace doesn't actually imply anything for the ordering of 
>  > the operations you are tracing!
> 
> This reminds me of a naive question that occurred to me while we were
> discussing this at KS.  Namely, what does "ordering" mean for events?
> 
> An example I'm all too familiar with is the lack of ordering of MMIO on
> big SGI systems -- if you forget an mmiowb(), then two CPUs taking a
> spinlock and doing writel() inside the spinlock and then dropping the
> spinlock (which should be enough to "order" things) might see the
> writel() reach the final device "out of order" because the write has to
> travel through a routed system fabric.
> 
> Just like Einstein said, it really seems to me that the order of things
> depends on your frame of reference.
> 
>  - R.
> 

Exactly as Linus said, event ordering comes down to this : a choice
between heavy locking around the real operation traced and the tracing
statement itself (irq disable/spinlock) or the acknowledgement that the
ordering is only insured across the actual tracing _instrumentation_.

A worse case scenario would be to get an interrupt between the "real"
operation (e.g. a memory or mmio write) and the tracing statement, be
scheduled out, which would let a lot of stuff happen between the actual
impact of the operation on kernel memory and the tracing statement
itself.

If we want to be _sure_ such thing never happen, we would then have to
pay the price of heavy locking and that would not be pretty, especially
for complex data structure modifications comes in play. I don't really
think anyone with an half-sane mind would want to slow down such
critical kernel operations for the benefit of totally ordered tracing.

However, in many cases where ordering matters, e.g. to instrument
spinlocks themselves, if we put the instrumentation within the critical
section rather than outside of it, then we benefit from the existing
kernel locking (but only for events related to this specific spinlock).
This is the same for many synchronization primitives, except for atomic
operations, where we have to accept that the order will be imperfect.

So only in the specific case of instrumentation of things like locking,
where it is possible to insure that instrumentation is synchronized with
the instrumented operation, does it make a difference to choose the TSC
(which implies a slight delta between the TSCs due to cache line delays
at synchronization and delay due to TSCs drifts caused by temperature)
over an atomic increment.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
