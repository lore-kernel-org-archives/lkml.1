Return-Path: <linux-kernel-owner+w=401wt.eu-S1762907AbYBLSWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762907AbYBLSWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbYBLSWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:22:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757991AbYBLSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:22:38 -0500
Date: Tue, 12 Feb 2008 10:20:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] kgdb-light -v10
Message-Id: <20080212102010.d88886f3.akpm@linux-foundation.org>
In-Reply-To: <20080212182024.GA4940@one.firstfloor.org>
References: <20080211162141.GA31434@elte.hu>
	<20080211171039.GA20446@one.firstfloor.org>
	<20080211230335.GA16102@elte.hu>
	<20080212100327.GA30873@one.firstfloor.org>
	<20080212112747.GA1569@elte.hu>
	<20080212121903.GA419@one.firstfloor.org>
	<20080212123839.GA15360@elte.hu>
	<20080212135027.GA1343@one.firstfloor.org>
	<20080212152846.GC3078@elte.hu>
	<alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org>
	<20080212182024.GA4940@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 19:20:24 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> >  - the kgdb commands should always act on the *current* CPU only
> >  - add one command that says "switch over to CPU #n" which just releases 
> >    the current CPU and sends an IPI to that CPU #n (no timeouts, no 
> >    synchronous waiting, no nothing - it's like a "continue", but with a 
> >    "try to get the other CPU to stop"
> 
> The problem I see here is that the kernel tends to get badly confused
> if one CPU just stops responding. At some point someone does an global
> IPI and that then hangs.

Yes.  A stopped CPU is very visible and hence can change the behaviour of
the system which is being tested.

>  You would need to hotunplug the CPU which
> is theoretically possible, but quite intrusive. Or maybe the "isolate CPUs 
> in cpusets" frame work someone posted recently on l-k could be used.  Still 
> would probably have all kinds of tricky issues and races.

I don't think you'd want to be poking around in kernel internals while some
of the CPUs are continuing to run.  It sounds rather creepy.  You want
everything to stop.  Including time-related things.

Bear in mind that one of the things you do with kgdb is to modify kernel
memory - I'd do things like

int foo;

	...
	if (foo == 1)
		special_stuff();
	...

to trigger a particular behaviour at a particular time.  If you're making
multiple changes, you want them "atomic" wrt all CPUs.  (Of course, if you
happeed to breakpoint one CPU while it was partway through reading multiple
locations, you lose.  But that's a teeny window).



OT: another thing you can do with kgdb is error-path testing:

	foo = kmalloc(...)
BP->	if (!foo)
		recover();

put a breakpoint on the !foo test and set foo to zero by hand.
