Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYHIEMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYHIEMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 00:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbYHIEMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 00:12:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYHIEMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 00:12:41 -0400
Date: Sat, 9 Aug 2008 00:12:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <20080809011955.GE9038@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0808082359220.10556@gandalf.stny.rr.com>
References: <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal> <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
 <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <20080809011955.GE9038@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 9 Aug 2008, Andi Kleen wrote:

> > I wish we had a true 5 byte nop. The alternative is a jmp 0, which is 
> > measurable.  This is replacing mcount from a kernel compile with the -pg 
> 
> Scary usage.  How much is the difference? 
> 
> BTW a good way to get most of that back would be to not use frame 
> pointers if you have them enabled ;-) Unfortunately recently
> the "select FRAME_POINTER"s keep creeping all over so far too many kernels
> suffer from this slow mode now :-/


I checked out the latest git tree from Linus, and set up a basic config 
for it. I built it once. Then I rebooted into various versions of the 
kernel and timed the makes. This is what I did for each kernel.

# cd /work/git/linux-compile.git
# make distclean
# cp config-use .config
# make oldconfig
# time make

Here are the results. Just for curiosity sake.

Using the two part nop:
 real    3m26.751s
 user    1m36.064s
 sys     0m39.450s

Using the 5 byte nop with the four 0x66:
 real    3m31.543s
 user    1m36.197s
 sys     0m39.309s

Using jmp 0 as a nop:
 real    3m30.025s
 user    1m35.948s
 sys     0m39.540s


Then I realized that I had the irqsoff, and preemptoff tracers configured.
These do add an overhead when configured in, even when they are disabled.
I disabled them and ran the code with the two part nop again:

Using two part nop without other tracers:
 real    3m26.851s
 user    1m36.425s
 sys     0m35.437s

I then disabled ftrace completely:

no ftrace times:
 real    3m25.807s
 user    1m36.992s
 sys     0m35.715s

Then I disabled frame pointers as well:
 real    3m25.104s
 user    1m35.726s
 sys     0m34.797s

The important numbers here is the sys time. The user and real should not
be that much affected by these changes. Well, the real would, but not the 
user.

I have an old toshiba that I want to run this on too. That might give more 
interesting results. But it's getting late, and I'll do that another time.

Looking at the results, and yes I should run this more than once, but I 
just wanted an idea, this box did not show much difference between the two 
part nop, the jmp and the 5 byte nop.

Running with or without ftrace enabled did not make a difference. Heck, 
the ftrace disabled was actually slower.

But it does seem that Andi is correct about the frame pointers. It did 
slow the compile down by almost a second.

Just some food for thought.

-- Steve

