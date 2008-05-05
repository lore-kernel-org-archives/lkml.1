Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbYEEVGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbYEEVGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbYEEVGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:06:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35300 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773AbYEEVGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:06:04 -0400
Date: Mon, 5 May 2008 23:05:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080505210526.GA1702@elte.hu>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu> <20080505182427.GA2025@uranus.ravnborg.org> <20080505184235.GD22332@elte.hu> <20080505125620.219c4bb6@infradead.org> <20080505202729.GA1199@elte.hu> <alpine.LFD.1.10.0805051337530.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805051337530.32269@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> Another example of that kind of behaviour, for example, is just you 
> fighting turning off 'default y' from FAIR_GROUP_SCHED, considering 
> that it is known to cause latency problems and the reason isn't 
> understood.

a side-note to this topic: after looking at a bunch of traces and after 
a lot of testing, the latency problems are complex, but reasonably 
well-understood.

Nevertheless we'll mark it default-disabled because it's been taking too 
long to create and propagate the fixes. I've queued up a patch for that. 
We might even mark it BROKEN for a single release so that the option 
disappears from people's config? Or we could change the name to achieve 
a similar effect.

The main design-level latency source was due to the hierarchic view of 
group scheduling - we had a hierarchy of runqueues. CFS met the latency 
targets, but only per level (per runqueue) of the hierarchy. So with 
every new level, we got more maximum latency.

So for example on a system with fair user scheduling, it takes just a 
couple of different UIDs to be probabilistically active at once to 
generate a bad latency: say if root, nobody, distcc and mingo UIDs are 
are active at once, the mingo task could see a 4x latency hit over the 
target - 160 msecs instead of 40 msecs.

This is now believed to be fixed in sched-devel.git, via the "single 
runqueue" and deadline-scheduling patches from Peter that flattens the 
hierarchy of the group scheduler.

Another latency source was the skew of sched_clock() running too slow - 
that way if the clock runs at 10% of its intended speed the scheduler 
will turn a 40msec intended latency target into a 400 msec latency 
target!

This bug too is now believed to be fixed via Peter's new sched_clock 
code in sched-devel.git.

... and users now have a very objective stick they can use on us: 
latencytop. It told us black and white when we sucked. (I am waiting for 
the days when it will auto-create a scheduler trace for the worst 
latency hit in the system, making it easy for users to submit traces.)

	Ingo
