Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYKDB3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYKDB3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 20:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYKDB3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 20:29:35 -0500
Received: from relay2.sgi.com ([192.48.179.30]:59852 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbYKDB3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:29:35 -0500
Date: Mon, 3 Nov 2008 19:29:33 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081104012933.GA246417@sgi.com>
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225751603.7803.1640.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 11:33:23PM +0100, Peter Zijlstra wrote:
> On Mon, 2008-11-03 at 15:07 -0600, Dimitri Sivanich wrote:
> > When load balancing gets switched off for a set of cpus via the
> > sched_load_balance flag in cpusets, those cpus wind up with the
> > globally defined def_root_domain attached.  The def_root_domain is
> > attached when partition_sched_domains calls detach_destroy_domains().
> > A new root_domain is never allocated or attached as a sched domain
> > will never be attached by __build_sched_domains() for the non-load
> > balanced processors.
> > 
> > The problem with this scenario is that on systems with a large number
> > of processors with load balancing switched off, we start to see the
> > cpupri->pri_to_cpu->lock in the def_root_domain becoming contended.
> > This starts to become much more apparent above 8 waking RT threads
> > (with each RT thread running on it's own cpu, blocking and waking up
> > continuously).
> > 
> > I'm wondering if this is, in fact, the way things were meant to work,
> > or should we have a root domain allocated for each cpu that is not to
> > be part of a sched domain?  Note the the def_root_domain spans all of
> > the non-load-balanced cpus in this case.  Having it attached to cpus
> > that should not be load balancing doesn't quite make sense to me.
> 
> It shouldn't be like that, each load-balance domain (in your case a
> single cpu) should get its own root domain. Gregory?
> 
> > Here's where we've often seen this lock contention occur:
> 
> what's this horrible output from?

This output is a stack backtrace from KDB.  KDB entry is triggered after too much time elapses prior to thread wakeup.  The traces pointed to this lock.  Too further test that theory, we hacked up a change to create root_domain's for each cpu and the max thread wakeup times improved.
