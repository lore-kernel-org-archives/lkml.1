Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbXDWP6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbXDWP6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXDWP6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:58:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbXDWP6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:58:05 -0400
Date: Mon, 23 Apr 2007 08:56:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Juliusz Chroboczek <jch@pps.jussieu.fr>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
In-Reply-To: <20070423013429.GB25162@wotan.suse.de>
Message-ID: <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org>
 <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org>
 <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
 <20070423013429.GB25162@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Apr 2007, Nick Piggin wrote:
> > If you have a single client, the X server is *not* more important than the 
> > client, and indeed, renicing the X server causes bad patterns: just 
> > because the client sends a request does not mean that the X server should 
> > immediately be given the CPU as being "more important". 
> 
> If the client is doing some processing, and the user moves the mouse, it
> feels much more interactive if the pointer moves rather than waits for
> the client to finish processing.

.. yes. However, that should be automatically true if the X process just 
has "enough CPU time" to merit being scheduled to.

Which it normally should always have, exactly because it's an 
"interactive" process (regardless of how the scheduler is done - any 
scheduler should always give sleepers good latency. The current one 
obviously does it by giving interactivity-bonuses, CFS does it by trying 
to be fair in giving out CPU time).

The problem tends to be the following scenario:

 - the X server is very CPU-busy, because it has lots of clients 
   connecting to it, and it's not getting any "bonus" for doing work for 
   those clients (ie it uses up its time-slice and thus becomes "less 
   important" than other processes, since it's already gotten its "fair" 
   slice of CPU - never mind that it was really unfair to not give it 
   more)

 - there is some process that is *not* dependent on X, that can (and does) 
   run, because X has spent its CPU time serving others.

but the point I'm trying to make is that X shouldn't get more CPU-time 
because it's "more important" (it's not: and as noted earlier, thinking 
that it's more important skews the problem and makes for too *much* 
scheduling). X should get more CPU time simply because it should get it's 
"fair CPU share" relative to the *sum* of the clients, not relative to any 
client individually.

Once you actually do give the X server "fair share" of the CPU, I'm sure
that you can still get into bad situations (trivial example: make clients 
that on purpose do X requests that are expensive for the server, but are 
cheap to generate). But it's likely not going to be an issue in practice 
any more.

Scheduling is not something you can do "perfectly". There's no point in 
even trying. To do "perfect" scheduling, you'd have to have ESP and know 
exactly what the user expects and know the future too. What you should aim 
for is the "obvious cases".

And I don't think anybody really disputes the fact that a process that 
does work for other processes "obviously" should get the CPU time skewed 
towards it (and away from the clients - not from non-clients!). I think 
the only real issue is that nobody really knows how to do it well (or at 
all).

I think the "schedule by user" would be reasonable in practice - not 
perfect by any means, but it *does* fall into the same class of issues: 
users are not in general "more important" than other users, but they 
should be treated fairly across the user, not on a per-process basis.

		Linus
