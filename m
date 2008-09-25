Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYIYW2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYIYW2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYIYW1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:27:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbYIYW1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:27:54 -0400
Date: Fri, 26 Sep 2008 00:25:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925222548.GA28309@elte.hu>
References: <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org>
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

> That said, if people think they can do a good job of ns conversion, 
> I'll stop arguing. Quite frankly, I think people are wrong about that, 
> and quite frankly, I think that anybody who looks even for one second 
> at those "alternate" sched_clock() implementations should realize that 
> they aren't suitable, but whatever. I'm not writing the code, I can 
> only try to convince people to not add the insane call-chains we have 
> now.

hm, i'd really hope hw makers see the light and actually make the hw do 
it all. Signs are that they are cozying up to these ideas.

Good and fast timestamps are important, and it is _infinitely_ more easy 
to do it in hw than in sw.

Firstly they need a low-frequency (10khz-100khz) shared clock line 
across all CPUs. A single line - and since it's low frequency it could 
be overlaid on some existing data line and filtered out. That works 
across NUMA nodes as well and physics allows it to be nanosec accurate 
up to dozens of meters or so. Then they need some really cheap way to 
realize what absolute value the clock counts, and read it out every now 
and then in the CPU, and approximate it inbetween, and have a secondary 
stage cheap few-transitors long-latency multiplicator that keeps passing 
on the nanosec-ish value to a register/MSR that can be read out by the 
instruction.

This trivially works fine even if the CPU is turned off. It uses nary 
any power as it's low freq, and can be spread across larger system 
designs too. In fact it would be a totally exciting new capability for 
things like analysis of SMP events. PEBS/BTS could be extended to save 
this kind of timestamp, and suddenly one could see _very_ accurately 
what happens between CPUs, without expensive bus snooping kit.

and CPUs wont go beyond the '~1nsec' event granularity for quite some 
time anyway - so nanoseconds is not a time scale that gets obsoleted 
quickly.

[ i guess this proves it that everyone has his pipe dream ;-) ]

	Ingo
