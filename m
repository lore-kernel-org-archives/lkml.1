Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZJEJtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZJEJtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 05:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbZJEJtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 05:49:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441AbZJEJtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 05:49:45 -0400
Date: Mon, 5 Oct 2009 11:48:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20091005094849.GA10620@elte.hu>
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb> <20090926183246.GA4141@in.ibm.com> <20090926204848.0b2b48d2@infradead.org> <20091001072518.GA1502@elte.hu> <20091001081616.GA3636@in.ibm.com> <20091001085330.GC15345@elte.hu> <1254729210.26976.15.camel@twins> <20091005085551.GA31147@elte.hu> <c62985530910050224u5e755808jc2a25c3dd5c172da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530910050224u5e755808jc2a25c3dd5c172da@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2009/10/5 Ingo Molnar <mingo@elte.hu>:
> >
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> >> Non-trivial.
> >>
> >> Something like this would imply a single output channel for all these
> >> CPUs, and we've already seen that stuffing too many CPUs down one such
> >> channel (using -M) leads to significant performance issues.
> >
> > We could add internal per cpu buffering before it hits any globally 
> > visible output channel. (That has come up when i talked to Frederic 
> > about the function tracer.) We could even have page sized output 
> > (via the introduction of a NOP event that fills up to the next page 
> > edge).
> 
> That looks good for the counting/sampling fast path, but would that 
> scale once it comes to reordering in the globally visible output 
> channel? Such a union has its costs.

Well, reordering always has a cost, and we have multiple models 
regarding to where to put that cost.

The first model is 'everything is per cpu' - i.e. completely separate 
event buffers and the reordering is pushed to the user-space 
post-processing stage. This is the most scalable solution - but it can 
also lose information such as the true ordering of events.

The second model is 'event multiplexing' - here we use a single output 
buffer for events. This serializes all output on the same buffer and 
hence is the least scalable one. It is the easiest to use one: just a 
single channel of output to deal with. It is also the most precise 
solution and it saves the post-processing stage from reordering hassles.

What i suggested above is a third model: 'short-term per cpu, 
multiplexed into an output channel with page granularity'. It has the 
advantage of being per cpu on a page granular basis. It has the ease of 
use of having a single output channel only.

Neither solution can eliminate the costs and tradeoffs involved. What 
they do is to offer an app a spectrum to choose from.

	Ingo
