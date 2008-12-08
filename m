Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbYLHLMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbYLHLMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYLHLM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:12:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbYLHLMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:12:25 -0500
Date: Mon, 8 Dec 2008 12:11:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081208111153.GA12377@elte.hu>
References: <18744.29747.728320.652642@cargo.ozlabs.ibm.com> <20081205063131.GB12785@elte.hu> <18744.56857.259756.129894@cargo.ozlabs.ibm.com> <20081205080813.GA2030@elte.hu> <18744.61429.548462.667020@cargo.ozlabs.ibm.com> <20081205120734.GA26244@elte.hu> <18745.49593.567217.277510@cargo.ozlabs.ibm.com> <1228566879.16244.4.camel@lappy.programming.kicks-ass.net> <18747.23509.977047.540995@cargo.ozlabs.ibm.com> <7c86c4470812072318n33e27045k50490f180ecfd8c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470812072318n33e27045k50490f180ecfd8c0@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> Let me explain the HW complexity a bit. It's all a matter of tradeoffs. 
> I have regular discussions with the PMU design architects about this. 
> If you talk to them, then you understand the environment they have to 
> live in and you understand why those constraints are there. The key 
> point to understand is that the PMU is never critical to the chip. The 
> chip can work well without. The real-estate on the chip is always very 
> tight. PMU is a 2nd class citizen, thus low in the priority list. [...]

The chip designers i talk to with my scheduler maintainer hat on do point 
out that performance monitoring is (of course) in the critical path of 
any chip, and hence its overhead and impact on the gate count of various 
critical components of the CPU core and its impact on the power envelope 
must be kept very low.

Nevertheless, the same chip designers rely on performance counters on a 
daily basis to plan their next-gen chip. They very much want them to work 
fine, and they work hard on making them relevant and easy to use. Often 
the performance counters are the _only_ real cheap hands-on insight into 
the dynamic situation of a modern CPU core, even for hw designers.

And all the current hw trends show that it's not just talk but action as 
well: the Core2 PMCs are already much saner (less constrained) than the 
P4 ones, and now they even expanded on them: Nehalem / Core i7 doubled 
the number of generic PMCs from two to four.

So, contrary to your suggestion, chip designers very much care about 
performance counters and they are working very hard to make this stuff 
useful to us. [ Yes, there are constraints even with generic counters 
(for example you only want a single line towards a PMC register from 
divider units), but the number of cross-counter constraints and their 
relevance is decreasing, not increasing. ]

Anyway ... i think your reply highlights why the fundamental premise of 
your patchset is so wrong: i believe you have designed your code and APIs 
at the wrong level by (paradoxically) assuming in essence that 
performance counters do not matter in the general scheme of things. (!)

So you introduced limited, special-purpose but still quite complex APIs 
that tailored the ABIs to intricate low level details of PMUs. I see an 
explosion in complexity due to that incorrect design choice: too many 
syscalls, too broad interaction between core code and architecture code, 
and too little practical utility in the end.

We did what we believe to be the right thing: we gave performance 
counters the proper high-level abstraction they _deserve_, and we made 
performance counters a prime-time Linux citizen as well.

	Ingo
