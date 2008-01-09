Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYAIRpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYAIRpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYAIRpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:45:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39964 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYAIRp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:45:29 -0500
Date: Wed, 9 Jan 2008 18:48:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109174800.GA15346@one.firstfloor.org>
References: <20080109035534.GA30321@basil.nowhere.org> <20080109090956.GA14274@elte.hu> <20080109141908.GB12855@one.firstfloor.org> <20080109152208.GA21280@elte.hu> <20080109155124.GB12923@one.firstfloor.org> <20080109163017.GG17739@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109163017.GG17739@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 05:30:18PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Wed, Jan 09, 2008 at 04:22:08PM +0100, Ingo Molnar wrote:
> > > 
> > > * Andi Kleen <andi@firstfloor.org> wrote:
> > > 
> > > > > nope, it's a 64-bit setup/dependency bug/problem: the vsyscall mappings 
> > > > > are installed via an __initcall, and that's too late for early use. The 
> > > > > combo patch below fixed the crash for me, does it work on your box too?
> > > > 
> > > > That gives
> > > > 
> > > > /home/lsrc/quilt/linux/arch/x86/kernel/setup_64.c: In function 'setup_arch':
> > > > /home/lsrc/quilt/linux/arch/x86/kernel/setup_64.c:468: error: implicit declarati
> > > > on of function 'map_vsyscall'
> > > 
> > > i guess you have an old repository.
> > 
> > I just applied the patch you sent out against yesterday's git-x86.
> 
> then you have a truly ancient x86.git repository ;-)

I update only infrequently because frankly git's remote branch tracking
is a mess. At least it doesn't really work for x86#mm here. 

I usually have to blow away the repository and reclone
to get back to a sane state.

> 
> think of x86.git#mm as an open development tree. It's high-flux, based 
> against Linux-bleeding-edge, it's frequently updated (daily, sometimes 
> hourly), breakages are possible (and likely) and fixes and other 
> feedback is more than welcome. And please feel free to complain about 

Right now Jan's cpa change you merged makes the cpa selftest to not pass 
anymore on 32bit. While that was likely a latent bug it just
triggered it's a little inconvenient.

There's also the problem on NX handling still not being right.

> patches that are included. (like you did in the past) Also please try to 
> post your patches as early as possible instead of in big chunks - last 
> week's 75 patches patchbomb from you was (and still is) ... challenging

There are still quite a lot outstanding. 

% wc -l patches/series 
90 patches/series

Some of that is debug or tbd or obsolete, but most isn't.

> > > since yesterday there's a full barrier around rdtsc.
> >
> > Great.
> 
> i have measured the impact of the barriers and it was in the noise 
> level. Barriers are notoriously easy to get wrong (because almost 
> nothing tells the programmer that they are wrong), that's why i did this 
> barrier-safe rdtsc() [& friends]. We had so much trouble with RDTSC 
> during the past 10 years of its existence that being a bit more 
> conservative with it is the only really maintainable option.

I would still think that the explicit barriers would make this 
all clearer, with long term giving cleaner semantics.

Admittedly I should have written some more comments in the
code.

I'm also a little unhappy on how many function calls the vgtod()
fast path contains now. Long ago it was a really lean function,
but it gets messed up more and more. Back when ->vread was introduced
the latency already suffered significantly (iirc multi digit
percent range), i suspect it now got worse again.

And after all that's still by far the most common system call
(not only for databases; i profiled this using systemtap in some
loads some time ago and it usually came up with >50%) 
and quite important for many workloads.

We have a lot far uglier code for less gain in far less critical calls.

-Andi

