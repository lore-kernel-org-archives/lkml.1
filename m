Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbYBLSlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbYBLSlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758314AbYBLSla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:41:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36101 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbYBLSl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:41:29 -0500
Date: Tue, 12 Feb 2008 20:16:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212191659.GA6458@one.firstfloor.org>
References: <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org> <20080212182024.GA4940@one.firstfloor.org> <20080212102010.d88886f3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212102010.d88886f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:20:10AM -0800, Andrew Morton wrote:
> On Tue, 12 Feb 2008 19:20:24 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > >  - the kgdb commands should always act on the *current* CPU only
> > >  - add one command that says "switch over to CPU #n" which just releases 
> > >    the current CPU and sends an IPI to that CPU #n (no timeouts, no 
> > >    synchronous waiting, no nothing - it's like a "continue", but with a 
> > >    "try to get the other CPU to stop"
> > 
> > The problem I see here is that the kernel tends to get badly confused
> > if one CPU just stops responding. At some point someone does an global
> > IPI and that then hangs.
> 
> Yes.  A stopped CPU is very visible and hence can change the behaviour of
> the system which is being tested.
> 
> >  You would need to hotunplug the CPU which
> > is theoretically possible, but quite intrusive. Or maybe the "isolate CPUs 
> > in cpusets" frame work someone posted recently on l-k could be used.  Still 
> > would probably have all kinds of tricky issues and races.
> 
> I don't think you'd want to be poking around in kernel internals while some
> of the CPUs are continuing to run.  It sounds rather creepy.  You want
> everything to stop.  Including time-related things.

Note I wrote the one above only as a reply to Linus' proposal, not
because I was advocating "live debugging" (or rather I think if you want
that just use gdb vmlinux /proc/kcore) 

I agree with you in principle, but what do you do if one of the CPUs doesn't 
answer? 

Ingo seems to think it's ok for the debugger then to just hang too,
I think it should eventually time out and debug anyways.

Also there are some limits on how much the system should be frozen
down. For example if you're strict about this requirement you
would need to require full DMA quiescence (like kexec does). But that's
obvious not a good idea for the debugger. So it's always shades
of gray, not black/white.

What I find strange with the current patch is that it goes to extreme
measures to stop the CPUs (will hang forever), but not do the whole
thing (DMA quiescence too) 

-Andi

