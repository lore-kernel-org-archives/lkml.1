Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbYIYVR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbYIYVR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYIYVRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:17:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbYIYVRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:17:48 -0400
Date: Thu, 25 Sep 2008 23:16:54 +0200
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
Message-ID: <20080925211653.GA16403@elte.hu>
References: <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org> <20080925211017.GA12689@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925211017.GA12689@elte.hu>
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

> ftrace has the same robustness design as lockdep has: as little 
> external infrastructure dependencies as possible. And lockdep has 
> recursion checks too, and excessive amounts of paranoia all around the 
> place.
> 
> Ftrace has the same robustness philosophy too, and yes, despite that 
> we judged cpu_clock() to be worth the risk, because accurate and fast 
> timestamps are a feature and we didnt want to duplicate.

and note that there's another pragmatic argument: often we notice 
cpu_clock() bugs by looking at traces. I.e. people fixing trace 
timestamps _fix the scheduler_. Sometimes it is very hard to notice 
scheduling artifacts that happen due to small inaccuracies in 
cpu_clock().

so there's continuous coupling between precise scheduling and good trace 
timestamps. I'd be willing to pay a lot more for that than the few 
(rather obvious...) robustness problems we had with sched_clock() in the 
past.

anyway ... i'm not _that_ attached to the idea, we can certainly go back 
to the original ftrace method of saving raw TSC timestamps and 
postprocessing. I think users will quickly force us back to a more 
dependable clock, and if not then you were right and i was wrong ;-)

In fact even when we used sched_clock() there were some artifacts: as 
you pointed it out we dont want to do per event cross-CPU 
synchronization by default as that is very expensive. Some people wanted 
GTOD clock for tracing and we very briefly tried that - but that was an 
utter maintenance nightmare in practice.

	Ingo
