Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbZDCLvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbZDCLvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759275AbZDCLvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:51:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbZDCLvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:51:41 -0400
Date: Fri, 3 Apr 2009 13:51:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] tracing/filters: use ring_buffer_discard_commit
	for discarded events
Message-ID: <20090403115100.GH31399@elte.hu>
References: <20090402052721.013878388@goodmis.org> <20090402053522.834546042@goodmis.org> <1238663187.6621.13.camel@bookworm> <alpine.DEB.2.00.0904021033080.965@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904021033080.965@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > [  240.462396]  [<ffffffff802c843b>] trace_function+0xab/0xc0
> 
> Oo, you have trace filters in trace_function. I'm not sure we want 
> that. If we do, please make it a separate function register. That 
> is, the function tracer is such a extreme hot path, that I would 
> like to avoid as many branch conditionals as possible. With the 
> dynamic function tracing, we can pick functions that do conditions 
> when we want them, and we can pick those that do not. If you look 
> at some of the register_ftrace_function callers, you will see 
> where I've picked different functions to be called by the tracer 
> depending on what the options are.

Actually, i like Tom's idea very much: as it allows pretty flexible 
context based filtering - not just function based filtering.

So we could filter for:

 -    a specific PID

 - or a pattern of ->comm strings ['bash' or 'sshd' or 'hackbench']

 - or we could filter for non-zero preempt-counts
   (i.e. critical sections only).

So this extends the function symbol based regexp mechanism in a 
quite natural way, and it would be sad to not do this just because 
it's ... arguably hard to implement robustly ;-)

The filter expression predicaments are pre-constructed and static at 
the point of execution, so they rely on no external facility other 
than some internal C code. So it should be possible to do this.

And if the tracepoint causes runtime overhead .. we need to optimize 
that. We could register a different, filter-aware mcount callback 
depending on whether there's any filter defined there.

	Ingo
