Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZAEWBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZAEWBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZAEWBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:01:39 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46919 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZAEWBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:01:38 -0500
Date: Mon, 5 Jan 2009 14:01:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       segher@kernel.crashing.org, rth@gcc.gnu.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
	from unsigned long
Message-ID: <20090105220136.GS6959@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090103124400.GA1572@ucw.cz> <200901060325.13362.nickpiggin@yahoo.com.au> <20090105173004.GG6959@linux.vnet.ibm.com> <200901060525.31472.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901060525.31472.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 05:25:30AM +1100, Nick Piggin wrote:
> On Tuesday 06 January 2009 04:30:04 Paul E. McKenney wrote:
> > On Tue, Jan 06, 2009 at 03:25:12AM +1100, Nick Piggin wrote:
> > > On Tuesday 06 January 2009 03:05:01 Paul E. McKenney wrote:
> > > > On Mon, Jan 05, 2009 at 11:00:24PM +1100, Nick Piggin wrote:
> > > > > On Monday 05 January 2009 22:23:50 Alan Cox wrote:
> > > > > > > Pretty much everywhere that uses RCU for example does so using
> > > > > > > atomic pointer loads and stores. The nastiest issue IMO actually
> > > > > > > is reloading the value through the pointer even if it isn't
> > > > > > > explicitly dereferenced. RCU gets this right with ACCESS_ONCE.
> > > > > > > Probably a lot of code using basic types does not. x86
> > > > > > > atomic_read maybe should be using ACCESS_ONCE too...
> > > > > >
> > > > > > I'm pretty sure it should. gcc makes no guarantees about not being
> > > > > > clever with accesses.
> > > > >
> > > > > Arguably it should. I don't know what the concurrent C standard looks
> > > > > like, but prohibiting reloads of potentially concurrently modified
> > > > > memory when there is no explicit pointer dereference is the natural
> > > > > complement to prohibiting stores to potentially concurrently read
> > > > > memory when there is no explicit store (which I think is begrudgingly
> > > > > agreed to be a problem).
> > > > >
> > > > > http://lkml.org/lkml/2007/10/24/673
> > > > >
> > > > > I think I would like to see multiple reloads to local variables
> > > > > prohibited, to avoid potential really subtle problems... But if
> > > > > ACCESS_ONCE is here to stay, then I do think that atomic_read etc
> > > > > should use it.
> > > >
> > > > The concurrency stuff in c++0x still permits the compiler to have its
> > > > way with loads and stores to normal variables, but provides an "atomic"
> > > > type that must be loaded and stored as specified in the program.
> > >
> > > So:
> > > if (trylock())
> > >   locked = 1;
> > > ...
> > > if (locked)
> > >   *var = blah;
> > > ...
> > > if (locked)
> > >   unlock();
> > >
> > > So the second part can still be transformed into a predicated calculation
> > > of blah, then an unconditional store to *var?
> >
> > Assuming that "var" is an ordinary variable...
> >
> > If you are asking whether the compiler guys believe that they are within
> > their rights to do a store to *var and then store the old value to *var
> > if !locked, the unfortunate answer is "yes".  Hence ACCESS_ONCE().
> 
> Right. Part of the problem is that it might not be so clear. Each part of
> the above sequence might be somewhat hidden by different call chains, gotos,
> etc. *var = blah may not be that simple in form but actually be a call to
> some helper function (which ends up being inlined, etc).
> 
> if (!trylock())
>   return;
> 
> *var = blah;
> 
> unlock();
> 
> This is basically the same sequence, isn't it? var definitely doesn't need
> to be atomic. It actually shouldn't have to be subject to any compiler
> constraints within the critical section in order for the compiler to
> generate an optimal critical section.

Agreed, in this case, the compiler should be permitted to optimize to
its heart's content.  Which is one of the reasons that we will probably
eventually have to explicitly mark the cases that the compiler cannot be
permitted to optimize -- preferably with such marking buried in some
other primitive!

> > > > The issue with ACCESS_ONCE() is that gcc doesn't do any optimizations
> > > > on volatile accesses, even the obvious ones.  Speaking of which, the
> > > > gcc guys kicked out my bug 33102, which was complaining about this
> > > > situation.  :-/
> > >
> > > Hmm. It's still quite annoying even to have to switch everything to the
> > > atomic type. I guarantee there will be bugs in Linux caused by the
> > > compiler reloading pointers/longs/ints to access local variables...
> >
> > Another approach would be to change ACCESS_ONCE() to use the atomic
> > types.  Then we have a bigger hammer with which to beat the gcc guys
> > about optimizations.  We can hope, anyway...
> 
> Well... I'm less concerned about performance as correctness and difficulty
> of programming this model.

Indeed!  And the compiler optimizations certainly can degrade
correctness more than a bit at times.  :-/

							Thanx, Paul
