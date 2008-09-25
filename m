Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYIYWQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYIYWQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYIYWQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:16:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35625 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYIYWQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:16:00 -0400
Date: Fri, 26 Sep 2008 00:14:41 +0200
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
Message-ID: <20080925221441.GA29060@elte.hu>
References: <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org> <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu> <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 25 Sep 2008, Ingo Molnar wrote:
> > 
> > to prove it, i just applied this patch:
> 
> Now do the same on a CPU that doesn't have TSC. And notice how useless 
> the timestamps are.

i do not understand this argument of yours. (really)

1) is your point that we might lock up?


2) or perhaps that the timestamps update only once every jiffy, and are 
in essence useless because they show the same value again and again?

the latter is true, and that's why we were pushed hard in the past by 
tracer users towards using GTOD timestamps. Everyone's favorite 
suggestion was: "why dont you use gettimeofday internally in the 
tracer???".

We resisted that because GTOD timestamps are totally crazy IMO:

- it is 1-2 orders of magnitude more code than cpu_clock() and 
  all sched_clock() variants altogether.

- it's also pretty fragile code that uses non-trivial locking
  internally.

- pmtimer takes like 6000-10000 cycles to read. hpet ditto. Not to talk
  about the PIT. Same on other architectures.

[ ... and as usual, only Sparc64 is sane in this field. ]

for a some time we had a runtime option in the latency tracer that 
allowed the GTOD clock to be used (default-off) - but even that one was 
too much and too fragile so we removed it - it never got upstream.

Fortunately this is not a big issue as almost everything on this planet 
that runs Linux and has a kernel developer or user sitting in front of 
it has a TSC - and if it doesnt have a TSC it doesnt have any other 
high-precision time source to begin with. So worst-case sched_clock() 
falls back to a sucky jiffies approximation:

unsigned long long __attribute__((weak)) sched_clock(void)
{
        return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
}


3) ... or perhaps is it your point more highlevel, that we shouldnt be 
dealing with timestamps in a central manner _at all_ in the tracer, and 
we should make them purely optional?

I indeed _had_ a few cases (bugs i debugged) where i was not interested 
at all in the timestamps, just in their relative ordering. For that we 
had a switch in the latency tracer that turned on (expensive!) central 
synchronization [a shared global atomic counter] between traced events. 
After some struggling it died a quick and peaceful death.

In that sense the global counter was a kind of 'time' though.


4) ... or if you have some other point which you already mentioned 
before then i totally missed it and apologize. :-/

	Ingo
