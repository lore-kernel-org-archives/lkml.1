Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYABMtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYABMtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYABMsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:48:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbYABMsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:48:54 -0500
Date: Wed, 2 Jan 2008 13:47:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       mathieu.desnoyers@polymtl.ca, paulmck@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost
	Tracing
Message-ID: <20080102124734.GC11208@elte.hu>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0modc4vr7a.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > [...]  Firstly, why on earth does a full format string have to be
> > passed in for something as simple as a CPU id? This way we basically
> > codify it forever that tracing _has_ to be expensive when
> > enabled. [...]
> 
> FWIW, I'm not keen about the format strings either, but they don't 
> constitute a performance hit beyond an additional parameter.  It does 
> not need to actually get parsed at run time.

"only" an additional parameter. The whole _point_ behind these markers 
is for them to have minimal effect!

> >[...]
> > Secondly, the inlined overhead of trace_mark() is still WAY too large:
> >
> >                 if (unlikely(__mark_##name.state)) {                    \
> > [...]
> >                 }                                                       \
> 
> Note that this is for the unoptimized case.  The immediate-value code 
> is better.  I have still yet to see some good measurements of how much 
> the overheads of the various variants are, however.  It's only fair to 
> gather these numbers and continue the debate with them in hand.

this is a general policy matter. It is _so much easier_ to add markers 
if they _can_ have near-zero overhead (as in 1-2 instructions). 
Otherwise we'll keep arguing about it, especially if any is added to 
performance-critical codepath. (where we are counting instructions)

> > Whatever became of the obvious suggestion that i outlined years ago, 
> > to have a _single_ trace call instruction and to _patch out_ the 
> > damn marker calls by default?  [...]  only leaving a ~5-byte NOP 
> > sequence behind them (and some minimal disturbance to the variables 
> > the tracepoint accesses). [...]
> 
> This has been answered several times before.  It's because the marker 
> parameters have to be (conditionally) evaluated and pushed onto a call 
> frame.  It's not just a call that would need being nop'd, but a whole 
> function call setup/teardown sequence, which itself can be interleaved 
> with adjacent code.

you are still missing my point. Firstly, the kernel is regparm built so 
there's no call frame to be pushed to in most cases - we pass most 
parameters in registers. (hence my stressing of minimizing the number of 
parameters to an absolute minimum)

Secondly, the side-effects of a function call is what i referred to via:

> [...]  (and some minimal disturbance to the variables the tracepoint 
> accesses). [...]

really, a tracepoint obviously accesses data that is readily accessible 
in that spot. Worst-case we'll have some additional register constraints 
that make the code a bit less optimal.

Yes, if a trace point references data that is _not_ readily available, 
then of course the preparation for the function call might not be cheap. 
But that can be optimized by placing the tracepoints intelligently.

what cannot be optimized away at all are the conditional instructions 
introduced by the probe points, extra parameters and the space overhead 
of the function call itself.

	Ingo
