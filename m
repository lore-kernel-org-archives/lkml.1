Return-Path: <linux-kernel-owner+w=401wt.eu-S1161560AbXDXDqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161560AbXDXDqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 23:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161569AbXDXDqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 23:46:38 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:63302 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161560AbXDXDqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 23:46:37 -0400
Message-ID: <462D7D8F.7000401@bigpond.net.au>
Date: Tue, 24 Apr 2007 13:46:23 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 24 Apr 2007 03:46:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 23 Apr 2007, Ingo Molnar wrote:
>> The "give scheduler money" transaction can be both an "implicit 
>> transaction" (for example when writing to UNIX domain sockets or 
>> blocking on a pipe, etc.), or it could be an "explicit transaction": 
>> sched_yield_to(). This latter i've already implemented for CFS, but it's 
>> much less useful than the really significant implicit ones, the ones 
>> which will help X.
> 
> Yes. It would be wonderful to get it working automatically, so please say 
> something about the implementation..
> 
> The "perfect" situation would be that when somebody goes to sleep, any 
> extra points it had could be given to whoever it woke up last. Note that 
> for something like X, it means that the points are 100% ephemeral: it gets 
> points when a client sends it a request, but it would *lose* the points 
> again when it sends the reply!
> 
> So it would only accumulate "scheduling points" while multiuple clients 
> are actively waiting for it, which actually sounds like exactly the right 
> thing. However, I don't really see how to do it well, especially since the 
> kernel cannot actually match up the client that gave some scheduling 
> points to the reply that X sends back.
> 
> There are subtle semantics with these kinds of things: especially if the 
> scheduling points are only awarded when a process goes to sleep, if X is 
> busy and continues to use the CPU (for another client), it wouldn't give 
> any scheduling points back to clients and they really do accumulate with 
> the server. Which again sounds like it would be exactly the right thing 
> (both in the sense that the server that runs more gets more points, but 
> also in the sense that we *only* give points at actual scheduling events).
> 
> But how do you actually *give/track* points? A simple "last woken up by 
> this process" thing that triggers when it goes to sleep? It might work, 
> but on the other hand, especially with more complex things (and networking 
> tends to be pretty complex) the actual wakeup may be done by a software 
> irq. Do we just say "it ran within the context of X, so we assume X was 
> the one that caused it?" It probably would work, but we've generally tried 
> very hard to avoid accessing "current" from interrupt context, including 
> bh's.

Within reason, it's not the number of clients that X has that causes its 
CPU bandwidth use to sky rocket and cause problems.  It's more to to 
with what type of clients they are.  Most GUIs (even ones that are 
constantly updating visual data (e.g. gkrellm -- I can open quite a 
large number of these without increasing X's CPU usage very much)) cause 
very little load on the X server.  The exceptions to this are the 
various terminal emulators (e.g. xterm, gnome-terminal, etc.) when being 
used to run output intensive command line programs e.g. try "ls -lR /" 
in an xterm.  The other way (that I've noticed) X's CPU usage bandwidth 
sky rocket is when you grab a large window and wiggle it about a lot and 
hopefully this doesn't happen a lot so the problem that needs to be 
addressed is the one caused by text output on xterm and its ilk.

So I think that an elaborate scheme for distributing "points" between X 
and its clients would be overkill.  A good scheduler will make sure 
other tasks such as audio streamers get CPU when they need it with good 
responsiveness even when X takes off by giving them higher priority 
because their CPU bandwidth use is low.

The one problem that might still be apparent in these cases is the mouse 
becoming jerky while X is working like crazy to spew out text too fast 
for anyone to read.  But the only way to fix that is to give X more 
bandwidth but if it's already running at about 95% of a CPU that's 
unlikely to help.  To fix this you would probably need to modify X so 
that it knows re-rendering the cursor is more important than rendering 
text in an xterm.

In normal circumstances, the re-rendering of the mouse happens quickly 
enough for the user to experience good responsiveness because X's normal 
CPU use is low enough for it to be given high priority.

Just because the O(1) tried this model and failed doesn't mean that the 
model is bad.  O(1) was a flawed implementation of a good model.

Peter
PS Doing a kernel build in an xterm isn't an example of high enough 
output to cause a problem as (on my system) it only raises X's 
consumption from 0 to 2% to 2 to 5%.  The type of output that causes the 
problem is usually flying past too fast to read.
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
