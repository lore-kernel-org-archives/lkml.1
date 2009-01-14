Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbZANVhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbZANVhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbZANVgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:36:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbZANVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:36:40 -0500
Date: Wed, 14 Jan 2009 13:35:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
       andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com, dmitry.adamushko@gmail.com,
       hannes@cmpxchg.org
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-Id: <20090114133529.317a346c.akpm@linux-foundation.org>
In-Reply-To: <20090114211458.GD6519@elte.hu>
References: <1231867314.7141.16.camel@twins>
	<1231952436.14825.28.camel@laptop>
	<20090114183319.GA18630@elte.hu>
	<20090114105300.66bd014d.akpm@linux-foundation.org>
	<20090114190008.GA13203@elte.hu>
	<20090114113638.c818fcf8.akpm@linux-foundation.org>
	<20090114201435.GA6519@elte.hu>
	<20090114123017.9acf42d7.akpm@linux-foundation.org>
	<20090114205122.GC6519@elte.hu>
	<20090114130642.cf2b18b2.akpm@linux-foundation.org>
	<20090114211458.GD6519@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 22:14:58 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 14 Jan 2009 21:51:22 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > > > Do people enable CONFIG_SCHED_DEBUG?
> > > > > 
> > > > > If they suspect performance problems and want to analyze them?
> > > > 
> > > > The vast majority of users do not and usually cannot compile their own 
> > > > kernels.
> > > 
> > > ... which they derive from distro kernels or some old .config they always 
> > > used, via 'make oldconfig'. You are arguing against well-established facts 
> > > here.
> > > 
> > > If you dont believe my word for it, here's an analysis of all kernel 
> > > configs posted to lkml in the past 8 months:
> > > 
> > >    $ grep ^CONFIG_SCHED_DEBUG linux-kernel | wc -l
> > >    424
> > > 
> > >    $ grep 'CONFIG_SCHED_DEBUG is not' linux-kernel | wc -l
> > >    109
> > > 
> > > i.e. CONFIG_SCHED_DEBUG=y is set in 80% of the configs. A large majority 
> > > of testers has it enabled and /sys/debug/sched_features was always a good 
> > > mechanism that we used for runtime toggles.
> > 
> > You just disproved your own case :(
> 
> how so? 80% is not enough?

No.

It really depends on what distros do.

> I also checked Fedora and it has SCHED_DEBUG=y 
> in its kernel rpms.

If all distros set SCHED_DEBUG=y then fine.

But if they do this then we should do this at the kernel.org level, and
make it a hard-to-turn-off thing via CONFIG_EMBEDDED=y.

> note that there's also a performance issue here: we generally _dont want_ 
> a debug sysctl overhead in the mutex code or in any fastpath for that 
> matter. So making it depend on SCHED_DEBUG is useful.
> 
> sched_feat() features get optimized out at build time when SCHED_DEBUG is 
> disabled. So it gives us the best of two worlds: the utility of sysctls in 
> the SCHED_DEBUG=y, and they get compiled out in the !SCHED_DEBUG case.

I'm not detecting here a sufficient appreciation of the number of
sched-related regressions we've seen in recent years, nor of the
difficulty encountered in diagnosing and fixing them.  Let alone
the difficulty getting those fixes propagated out a *long* time
after the regression was added.

You're taking a whizzy new feature which drastically changes a critical
core kernel feature and jamming it into mainline with a vestigial
amount of testing coverage without giving sufficient care and thought
to the practical lessons which we have learned from doing this in the
past.

This is a highly risky change.  It's not that the probability of
failure is high - the problem is that the *cost* of the improbable
failure is high.  We should seek to minimize that cost.
