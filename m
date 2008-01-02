Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYABQfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYABQfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYABQfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:35:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbYABQf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:35:28 -0500
Date: Wed, 2 Jan 2008 11:33:09 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       mathieu.desnoyers@polymtl.ca, paulmck@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost Tracing
Message-ID: <20080102163309.GC11496@redhat.com>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com> <20080102124734.GC11208@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102124734.GC11208@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Jan 02, 2008 at 01:47:34PM +0100, Ingo Molnar wrote:
> [...]
> > FWIW, I'm not keen about the format strings either, but they don't 
> > constitute a performance hit beyond an additional parameter.  It does 
> > not need to actually get parsed at run time.
> 
> "only" an additional parameter. The whole _point_ behind these markers 
> is for them to have minimal effect!

Agreed.  The only alternative I recall seeing proposed was my own
cartesian-product macro suite that encodes parameter types into the
marker function/macro name itself.  (Maybe some of that could be
hidden with gcc typeof() magic.)  There appeared to be a consensus
that this was more undesirable.  Do you agree?


> [...]
> this is a general policy matter. It is _so much easier_ to add markers 
> if they _can_ have near-zero overhead (as in 1-2 instructions). 
> Otherwise we'll keep arguing about it, especially if any is added to 
> performance-critical codepath. (where we are counting instructions)

The effect of the immediate-values patch, combined with gcc
CFLAGS+=-freorder-blocks, *is* to keep the overhead at 1-2
dcache-impact-free instructions.  The register saves, parameter
evaluation, the function call, can all be moved out of line.


> > > Whatever became of the obvious suggestion that i outlined years ago, 
> > > to have a _single_ trace call instruction and to _patch out_ the 
> > > damn marker calls by default?  [...]  only leaving a ~5-byte NOP 
> > > sequence behind them (and some minimal disturbance to the variables 
> > > the tracepoint accesses). [...]
> > 
> > This has been answered several times before.  It's because the marker 
> > parameters have to be (conditionally) evaluated and pushed onto a call 
> > frame.  It's not just a call that would need being nop'd, but a whole 
> > function call setup/teardown sequence, which itself can be interleaved 
> > with adjacent code.
> 
> you are still missing my point. Firstly, the kernel is regparm built so 
> there's no call frame to be pushed to in most cases - we pass most 
> parameters in registers. [...]

Yes, but those registers will already be used, so their former values
need to be saved or later recomputed as a part of the call sequence.
Even wrapping it all with an asm barrier may not be enough to
completely bound the code with an address range that can be naively
NOP'd out.


> Secondly, the side-effects of a function call is what i referred to via:
> 
> > [...]  (and some minimal disturbance to the variables the tracepoint 
> > accesses). [...]
> 
> really, a tracepoint obviously accesses data that is readily accessible 
> in that spot. Worst-case we'll have some additional register constraints 
> that make the code a bit less optimal. [...]

It's more than that - people will want to pass some dereferenced
fields from a struct*; some old function parameters that were by the
time of the marker call shoved out of registers again.  Register
constraints that prohibit general expressions would impede the
utility of the tool.


> what cannot be optimized away at all are the conditional
> instructions introduced by the probe points, extra parameters and
> the space overhead of the function call itself.

Almost all of that can & should be moved out of line.


- FChE
