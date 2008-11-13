Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYKMMyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYKMMyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYKMMyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:54:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYKMMyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:54:31 -0500
Date: Thu, 13 Nov 2008 13:54:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
	return tracer lockless
Message-ID: <20081113125419.GA32574@elte.hu>
References: <491B4F0A.3080901@gmail.com> <20081112221552.GA6125@elte.hu> <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com> <20081113085551.GF25479@elte.hu> <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com> <20081113092340.GJ25479@elte.hu> <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com> <20081113094027.GK25479@elte.hu> <c62985530811130436s160e3983nd7debbb96cc971ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811130436s160e3983nd7debbb96cc971ae@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Ok, so correct me if I'm wrong. Global timestamp would be captured 
> by using sched_clock(). That's what is done currently in 
> ring_buffer_time_stamp() And the global timestamp would be 
> combination of a last global timestamp and a relative position from 
> now to this last at each insertion in the ring-buffer (or tracing 
> time capture). Am I right? I don't really understand why you want to 
> update with a cmpxchg loop...

the cmpxchg loop would be needed to ensure timestamp monotonicity: 
every new "global time" is cmpxchg-ed with the "previous global time" 
(and is first monotonicity checked).

"prev_global_time" also acts as a global serializer: it ensures that 
events are timestamped in a monotonic and ordered way.

i.e. something like this (pseudocode, without the cmpxchg):

 u64 prev_global_time;

 DEFINE_PER_CPU(prev_local_time);

 u64 global_time()
 {
	u64 now, delta, now_global;

	prev_global = prev_global_time;
	now = sched_clock();
	delta = now - per_cpu(prev_local_time, this_cpu);
	per_cpu(prev_local_time, this_cpu) = now;

	now_global = prev_global + delta;
	prev_global = now_global;

	return now_global;
 }

note how we build "global time" out of "local time".

The cmpxchg would be used to put the above one into a loop, and 
instead of updating the global time in a racy way:

	prev_global = now_global;

We'd update it via the cmpxchg:

	atomic64_t prev_global_time;

	...

	while (atomic64_cmpxchg(&prev_global_time,
				 prev_global, now_global) != prev_global) {
		[...]
	}

To make sure the global time goes monotonic. (this way we also avoid a 
spinlock - locks are fragile for instrumentation)

	Ingo
