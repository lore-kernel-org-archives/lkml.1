Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbXICN1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbXICN1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXICN1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:27:15 -0400
Received: from waste.org ([66.93.16.53]:45702 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbXICN1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:27:14 -0400
Date: Mon, 3 Sep 2007 08:29:04 -0500
From: Matt Mackall <mpm@selenic.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       josh@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] Make rcutorture RNG use temporal entropy
Message-ID: <20070903132904.GV21720@waste.org>
References: <20070816024904.GA5312@linux.vnet.ibm.com> <20070817115356.cb201e42.akpm@linux-foundation.org> <20070817200022.GH8464@linux.vnet.ibm.com> <20070823180658.GQ11166@waste.org> <20070823185830.GC8371@linux.vnet.ibm.com> <20070823194037.GW30556@waste.org> <20070828011554.GB31860@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828011554.GB31860@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 06:15:54PM -0700, Paul E. McKenney wrote:
> On Thu, Aug 23, 2007 at 02:40:37PM -0500, Matt Mackall wrote:
> > On Thu, Aug 23, 2007 at 11:58:31AM -0700, Paul E. McKenney wrote:
> > > On Thu, Aug 23, 2007 at 01:06:58PM -0500, Matt Mackall wrote:
> > > > On Fri, Aug 17, 2007 at 01:00:22PM -0700, Paul E. McKenney wrote:
> > > > > On Fri, Aug 17, 2007 at 11:53:56AM -0700, Andrew Morton wrote:
> > > > > > On Wed, 15 Aug 2007 19:49:04 -0700
> > > > > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > > > > 
> > > > > > > Repost of http://lkml.org/lkml/2007/8/10/472 made available by request.
> > > > > > > 
> > > > > > > The locking used by get_random_bytes() can conflict with the
> > > > > > > preempt_disable() and synchronize_sched() form of RCU.  This patch changes
> > > > > > > rcutorture's RNG to gather entropy from the new cpu_clock() interface
> > > > > > > (relying on interrupts, preemption, daemons, and rcutorture's reader
> > > > > > > thread's rock-bottom scheduling priority to provide useful entropy),
> > > > > > > and also adds and EXPORT_SYMBOL_GPL() to make that interface available
> > > > > > > to GPLed kernel modules such as rcutorture.
> > > > > > > 
> > > > > > > Passes several hours of rcutorture.
> > > > > > 
> > > > > > Please explain what "conflict with" means so that I can work out if
> > > > > > this is a needed-in-2.6.23 change, thanks.
> > > > > 
> > > > > Not needed in 2.6.23.  This change falls into the "preparation for -rt"
> > > > > category.  Also in the "don't unnecessarily eat entropy, leave some for
> > > > > the people needing crypographically secure randomness" category.
> > > > 
> > > > We've had several calls for a more fast and loose version of
> > > > get_random_bytes. Generalizing one of the cookie generation functions
> > > > is probably a good way to go.
> > > 
> > > Are you thinking in terms of secure_tcp_syn_cookie(), or did you have
> > > something else in mind?
> > 
> > Yes. Using a hash function rather than a trivial LFSR is preferable.
> > But pulling the guts out and giving it an n-bytes interface like
> > get_random_bytes().
> 
> OK.  But this cannot be the first discussion of getting a fast and loose
> version of get_random_bytes() into the kernel.  Anyplace I should look
> for cautionary tales?  A quick search located a spirited discussion of
> proposed kernel infrastructure for user-mode random number generation
> back in 2003, but...
> 
> Also a 2006 proposal from Stephan Eranian: http://lkml.org/lkml/2006/8/23/41
> This appears to have gotten zero replies.  :-/  (Though not hash-based.)

You probably did the same searches I would do, so no, don't have any
pointers, just vague recollections.
 
> Other semi-related threads:
> 
> 	http://lkml.org/lkml/2005/3/15/102
> 	http://lkml.org/lkml/2004/9/23/337
> 
> Some years back, my reflexive design would have been per-CPU state,
> accessed with interrupts disabled.  Not so good for realtime usage,
> though.  One could go with per-task state in order to avoid the
> interrupt disabling, which might be OK if the state is quite small.

We only need be concerned here with locking insofar as we'd produce
duplicate output without it. So it's fairly easy to imagine a lockless
design using percpu data and perhaps folding in the preemption state.

-- 
Mathematics is the supreme nostalgia of our time.
