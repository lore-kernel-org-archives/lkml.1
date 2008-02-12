Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbYBLQ0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbYBLQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbYBLQ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:26:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757919AbYBLQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:26:16 -0500
Date: Tue, 12 Feb 2008 08:25:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
In-Reply-To: <20080212161152.GA3281@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org>
References: <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu>
 <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Andi Kleen wrote:
> > 
> > KGDB does a very straightforward "all CPUs enter controlled state" 
> > transition when the session begins, and at the end an "all CPUs 
> > continue" transition.
> 
> Yes and the session has no fixed time limit.

Quite frankly, if kgdb starts doing somethign "fancy", there is no way 
I'll merge it.

This includes things like having "breakpoint reservations" (discussed 
earlier) and just generally trying to add lots of infrastructure to make 
kgdb "fit in" to the kernel.

The fact is, not having kgdb enabled should have _zero_ impact on the 
kernel, but the implication is also that when you *do* enable kgdb, that 
shouldn't change anything visible either: the rest of the kernel should 
simply not _possibly_ be able to even tell or care (which is why 
breakpoint reservations are out - they are against the whole point of 
debugging a unmodified kernel).

So kgdb in my opinion will *have* to step on some other kernel 
infrastructure. I also think that things like timeouts are not something 
the client should do - if a kgdb lock never gets through, then it should 
be the debugging end that should just react to ^C and tough titties: it's 
not like there's a whole lot to be done.

In other words: I think the kgdb patches have become a lot more palatable 
over the last week, but I think so exactly because they have gotten 
smaller and less invasive. Anything that evokes any discussion AT ALL 
should just be removed. It really should be that simple.

[ The exception being that I think hw breakpoint support should be added 
  back in - never mind that it won't work if the "native kernel" also uses 
  them. Tough.

  If the debugger screws up the hw breakpoint state, that's a debugger 
  error. I'd hope that the remote debugger *defaults* to just re-writing 
  the instruction stream for that reason, but if you want to do a data 
  breakpoint, you simply *have* to use the hw breakpoints for kgdb.

  And you just need to live with the fact that it simply won't be possible 
  to do if the client wants to use hw breakpoints too. If the client 
  starts using hw breakpoints - tough titties, it takes them. ]

So keep the damn thing really simple, and don't try to handle every 
possible thing. We expect the debugger side to have a person with some 
flexibility on it.

			Linus
