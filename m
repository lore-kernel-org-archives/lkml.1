Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZAPBe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZAPBe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZAPBep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:34:45 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44480 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbZAPBeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:34:44 -0500
Date: Thu, 15 Jan 2009 17:34:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090116013443.GH6763@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain> <20090115180844.GL22472@elte.hu> <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain> <20090116005351.GD6763@linux.vnet.ibm.com> <alpine.LFD.2.00.0901151656060.3118@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901151656060.3118@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 05:01:32PM -0800, Linus Torvalds wrote:
> On Thu, 15 Jan 2009, Paul E. McKenney wrote:
> > On Thu, Jan 15, 2009 at 10:16:53AM -0800, Linus Torvalds wrote:
> > > 
> > > IOW, if you do pre-allocation instead of holding a lock over the 
> > > allocation, you win. So yes, spin-mutexes makes it easier to write the 
> > > code, but it also makes it easier to just plain be lazy.
> > 
> > In infrequently invoked code such as some error handling, lazy/simple
> > can be a big win.
> 
> Sure. I don't disagree at all. On such code we don't even care about 
> locking. If it _really_ is fundamentally very rarely invoked.
> 
> But if we're talking things like core filesystem locks, it's _really_ 
> irritating when one of those (supposedly rare) allocation delays or the 
> need to do IO then blocks all those (supposedly common) nice cached cases.

Certainly if there was one big mutex covering all the operations, it would
indeed be bad.  On the other hand, if the filesystem/cache was partitioned
(perhaps hashed) so that there was a large number of such locks, then
if should be OK.  Yes, I am making the perhaps naive assumption that
hot spots such as the root inode would be in the cache.  And that they
would rarely collide with allocation or I/O, which might also be naive.

But on this point I must defer to the filesystem folks.

> So I don't dispute at all that "mutex with spinning" performs better than 
> a mutex, but I _do_ claim that it has some potentially huge downsides 
> compared to a real spinlock. It may perform as well as a spinlock in the 
> nice common case, but then when you hit the non-common case you see the 
> difference between well-written code and badly written code.
> 
> And sadly, while allocations _usually_ are nice and immediate, and while 
> our caches _usually_ mean that we don't need to do IO, bad behavior when 
> we do need to do IO is what really kills interactive feel. Suddenly 
> everything else is hurting too, because they wanted that lock - even if 
> they didn't need to do IO or allocate anything.

I certainly agree that there are jobs that a spin-mutex is ill-suited for.

							Thanx, Paul
