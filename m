Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953Ab0A0JIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0A0JIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655Ab0A0JIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:08:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57770 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab0A0JIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:08:48 -0500
Date: Wed, 27 Jan 2010 10:08:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100127090824.GA23570@elte.hu>
References: <4B5459CA.9060603@redhat.com>
 <4B545ACF.40203@cs.helsinki.fi>
 <1263852957.2266.38.camel@localhost.localdomain>
 <4B556855.6040800@redhat.com>
 <1263923265.4998.28.camel@localhost.localdomain>
 <4B56D027.3010808@redhat.com>
 <1263981472.4283.843.camel@laptop>
 <4B56F588.2060109@redhat.com>
 <20100127082440.GA16640@elte.hu>
 <4B5FFADB.5090209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5FFADB.5090209@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 01/27/2010 10:24 AM, Ingo Molnar wrote:
> >
> >
> >>>Not to mention that that process could wreck the trace data rendering it
> >>>utterly unreliable.
> >>It could, but it also might not.  Are we going to deny high performance
> >>tracing to users just because it doesn't work in all cases?
> >Tracing and monitoring is foremost about being able to trust the instrument,
> >then about performance and usability. That's one of the big things about
> >ftrace and perf.
> >
> >By proposing 'user space tracing' you are missing two big aspects:
> >
> >  - That self-contained, kernel-driven tracing can be replicated in user-space.
> >    It cannot. Sharing and global state is much harder to maintain reliably,
> >    but the bigger problem is that user-space can stomp on its own tracing
> >    state and can make it unreliable. Tracing is often used to figure out bugs,
> >    and tracers will be trusted less if they can stomp on themselves.
> >
> >  - That somehow it's much faster and that this edge matters. It isnt and it
> >    doesnt matter. The few places that need very very fast tracing wont use any
> >    of these facilities - it will use something specialized.
> >
> >So you are creating a solution for special cases that dont need it, and you
> >are also ignoring prime qualities of a good tracing framework.
> 
> I see it exactly the opposite.  Only a very small minority of cases will 
> have such severe memory corruption that tracing will fall apart because of 
> random writes to memory; especially on 64-bit where the address space is 
> sparse.  On the other hand, knowing that the cost is a few dozen cycles 
> rather than a thousand or so means that you can trace production servers 
> running full loads without worrying about whether tracing will affect 
> whatever it is you're trying to observe.
> 
> I'm not against slow reliable tracing, but we shouldn't ignore the need for 
> speed.

I havent seen a conscise summary of your points in this thread, so let me 
summarize it as i've understood them (hopefully not putting words into your 
mouth): AFAICS you are arguing for some crazy fragile architecture-specific 
solution that traps INT3 into ring3 just to shave off a few cycles, and then 
use user-space state to trace into.

If so then you ignore the obvious solution to _that_ problem: dont use INT3 at 
all, but rebuild (or re-JIT) your program with explicit callbacks. It's _MUCH_ 
faster than _any_ breakpoint based solution - literally just the cost of a 
function call (or not even that - i've written very fast inlined tracers - 
they do rock when it comes to performance). Problem solved and none of the 
INT3 details matters at all.

INT3 only matters to _transparent_ probing, and for that, the cost of INT3 is 
almost _by definition_ less important than the fact that we can do transparent 
tracing. If performance were the overriding issue they'd use dedicated 
callbacks - and the INT3 technique wouldnt matter at all.

( Also, just like we were able to extend the kprobes code with more and more
  optimizations, the same can be done with any user-space probing as well, to 
  make it faster. But at the core of it has to be a sane design that is 
  transparent and controlled by the kernel, so that it has the option to apply 
  more and more otimizations - yours isnt such and its limitations are 
  designed-in. Which is neither smart nor useful. )

	Ingo
