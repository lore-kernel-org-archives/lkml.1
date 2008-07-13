Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYGMRn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYGMRn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGMRnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:43:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYGMRnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:43:18 -0400
Date: Sun, 13 Jul 2008 19:42:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Message-ID: <20080713174252.GA13115@elte.hu>
References: <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org> <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com> <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com> <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org> <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com> <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org>
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

> The thing is, we should fix the top level code to never even 
> _consider_ an invalid CPU as a target, and that in turn should mean 
> that all the other code should be able to just totally ignore CPU 
> hotplug events.

agreed. We thought we could get away by hiding the "is the CPU dead" 
information in existing data structures (by shaping sched domains to 
never lead to a dead CPU) - but this method has proven itself fragile 
via a series of bugs.

It was one micro-optimization one too many. We should just accept the 
fact that the current model is not maintainable and add your extra (and 
trivial) cpu_active_map layer that protects against migrating to CPUs 
that are going down. [we'll basically introduce a "going down" state 
inbetween 'online' and 'offline']

And this will get rid of some other fragile trickery - because from that 
point on we dont have to be super-careful about the whole sequence of 
manipulating sched domains anymore. Cpusets can do whatever it wants, it 
wont be able to break hotplug+scheduling - and that's important for any 
functionality that is not used by default.

[ I dont think Dmitry will disagree with this notion all that much, it's
  just that his personal limit for calling an algorithm unmaintainable
  is probably a lot higher than normal :-) ]

	Ingo
