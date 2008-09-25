Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbYIYUWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbYIYUWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYIYUWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:22:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbYIYUWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:22:09 -0400
Date: Thu, 25 Sep 2008 22:20:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925202054.GA4903@elte.hu>
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925195522.GA22248@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> cpu_clock() proved to be a good middle ground. I'm not a believer in 
> any of this stuff, i just react to how things behave in practice, as 
> none of this is really easy to get right from the theoretical angle.
[...]
> If sched_clock() is broken then the kernel wont work anyway. And i never 
> wanted to trace inside sched_clock() itself. [...]

note, CONFIG_LOCKSTAT - which hooks deep inside lockdep, uses 
cpu_clock() too for timings, for similar reasons. Lockdep and lockstat 
both have a very robust design and a very good track record to prove it.

you'd be correct in pointing out that we _do_ have a relatively high 
regression count in cpu_clock()/sched_clock(), but the reason for that 
is that its implementation balances on the narrow edge of doability. It 
implements a very unstable set of requirements: "absolutely fast" pitted 
against "as accurate as possible".

That is two conflicting requirements and it is a very fine line to walk 
and everyone tries to have their own variant of it and their own 
balance. We try as hard as possible to use the TSC even in face of 
C2/C3, cpufreq, unstable TSCs, etc. The moment we go too much towards 
performance we regress accuracy and hurt the scheduler's quality and 
vice versa.

and note that my years long experience in the tracing field show that it 
has a _very_ similar need for accuracy versus performance, so it was a 
good match for ftrace.

	Ingo
