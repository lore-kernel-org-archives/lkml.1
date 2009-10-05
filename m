Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbZJEI4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbZJEI4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbZJEI4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:56:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35517 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbZJEI4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:56:50 -0400
Date: Mon, 5 Oct 2009 10:55:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20091005085551.GA31147@elte.hu>
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb> <20090926183246.GA4141@in.ibm.com> <20090926204848.0b2b48d2@infradead.org> <20091001072518.GA1502@elte.hu> <20091001081616.GA3636@in.ibm.com> <20091001085330.GC15345@elte.hu> <1254729210.26976.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254729210.26976.15.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-10-01 at 10:53 +0200, Ingo Molnar wrote:
> > i'd suggest you extend perf events with a 'system 
> > wide' event abstraction, which:
> > 
> >  - Enumerates such registered events (via a list)
> > 
> >  - Adds a CPU hotplug handler (which clones those events over to a new
> >    CPU and directs it back to the ring-buffer of the existing event(s)
> >    [if any])
> > 
> >  - Plus a state field that allows the filtering out of stray/premature
> >    events.
> > 
> > Such an add-on layer/abstraction would sure be useful in other cases as 
> > well. It might make sense to expose it to user-space and make perf top 
> > use it by default.
> 
> Non-trivial.
> 
> Something like this would imply a single output channel for all these 
> CPUs, and we've already seen that stuffing too many CPUs down one such 
> channel (using -M) leads to significant performance issues.

We could add internal per cpu buffering before it hits any globally 
visible output channel. (That has come up when i talked to Frederic 
about the function tracer.) We could even have page sized output (via 
the introduction of a NOP event that fills up to the next page edge).

This would have advantages elsewhere as well - it would be an immediate 
speedup for 'perf sched record' for example.

> Therefore I would strongly argue to let the kernel interface be what 
> it is and solve this in a userspace library for those who care.
> 
> We really cannot sanely support an all-CPUs abstraction without 
> running into trouble.

User-space will be in an even poorer situation to solve this 
intelligently.

Really, the only reason to _not_ abstract something in the kernel, 
_ever_ is when:

 - it is so trivial that it needs no extra helpers in the kernel

 - or when it is so specialized that it's a policy in essence

'it is too difficult' is a real _in favor_ of putting something into the 
kernel ;-)

	Ingo
