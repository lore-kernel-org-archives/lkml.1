Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZJLJGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZJLJGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbZJLJGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:06:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51257 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbZJLJGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:06:01 -0400
Date: Mon, 12 Oct 2009 11:05:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: David Miller <davem@davemloft.net>, paulus@samba.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sf.net
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for
	Intel processors
Message-ID: <20091012090515.GA24031@elte.hu>
References: <1254911461.26976.239.camel@twins> <19148.30773.350036.411105@cargo.ozlabs.ibm.com> <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com> <20091007.134626.238756485.davem@davemloft.net> <20091008200839.GA24354@elte.hu> <7c86c4470910081328r24be0f63ha436b008b66077c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c86c4470910081328r24be0f63ha436b008b66077c4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* stephane eranian <eranian@googlemail.com> wrote:

> On Thu, Oct 8, 2009 at 10:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * David Miller <davem@davemloft.net> wrote:
> >
> >> From: stephane eranian <eranian@googlemail.com>
> >> Date: Wed, 7 Oct 2009 14:31:58 +0200
> >>
> >> > What PPC does is probably the only way to do this given the interface between
> >> > generic and machine-specific code. The one advantage I see is that it works
> >> > inside an event group but also across event groups because that code does not
> >> > look at group boundary, it only looks at the events and the number of available
> >> > registers. The downside is that you duplicate state.
> >> >
> >> > Did I get this right, Paul?
> >>
> >> That's basically how his code works, yes.  I intend on duplicating it
> >> to some extent on sparc64 since I'm operating in a similar problem
> >> space.
> >>
> >> So if at least some of this engine went to a generic place, there'd be
> >> at least a 3rd user :-)
> >
> > Yeah, i'd definitely suggest to generalize this. We've missed updating
> > PowerPC lowlevel details a couple of times in perf core updates, just
> > because it's in a non-obvious place. Even if it's used by just a single
> > arch, generic code is much more visible.
> >
> 
> It is not clear how you can do this without creating a monster. As I 
> said the constraints can be far more difficult than just event X => 
> allowed_counter_bitmask.

The event constraints we are interested in come from the physics of 
CPUs, not from inherent properties of particular architectures.

If you check the various constraints you'll see there's many repeating 
patterns and many of those will repeat between architectures.

Arbitrary, random constraints (that stem from design stupidity/laziness) 
can be kept at arch level, as a quirk in essence.

Spreading them all out into architecture code is the far worse solution, 
it creates a fragile distributed monster with repeating patterns - 
instead we want a manageable central monster ;-) [We are also quite good 
at controlling and shrinking monsters in the core kernel.]

So we could start all this by factoring out the sane looking bits of 
PowerPC and x86 constraints into generic helpers, and go step by step 
starting from that point.

Would you be interested in trying that, to finish what you started with 
'struct event_constraint' in arch/x86/kernel/cpu/perf_event.c?

Thanks,

	Ingo
