Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbXJBEUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbXJBEUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 00:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXJBEUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 00:20:44 -0400
Received: from ozlabs.org ([203.10.76.45]:43915 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbXJBEUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 00:20:44 -0400
Subject: Re: [RFC][PATCH] make module refcounts use percpu_counters
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1191258216.7344.129.camel@localhost>
References: <20070928230057.2712A579@kernel>
	 <1191231833.26950.66.camel@localhost.localdomain>
	 <1191258216.7344.129.camel@localhost>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 14:20:13 +1000
Message-Id: <1191298813.6979.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 10:03 -0700, Dave Hansen wrote:
> On Mon, 2007-10-01 at 19:43 +1000, Rusty Russell wrote:
> > On Fri, 2007-09-28 at 16:00 -0700, Dave Hansen wrote:
> > > Module refcounts currently use a percpu counter stored
> > > in the 'struct module'.  However, we also have a more
> > > generic implementation that does stuff like handle
> > > hotplug cpus.
> > > 
> > > I'm not actually all that convinced that this refcount
> > > actually does a lot of good, with cpus racing bumping
> > > the counters at the same time that they're being
> > > summed up.  But, it certainly isn't any worse than
> > > what was there before.
> > 
> > That's why we look at the counters inside stop_machine_run().
> 
> Ahhh.  That makes sense.  Although it wasn't apparent during my 3-second
> perusal of the code.
> 
> > Note that (1) the module implementation handles hotplug CPUs
> 
> 
> You're saying it handles hotplug because of stop_machine_run()?

No, it handles hotplug because it does every possible CPU, not every
online CPU.  percpu_counters empties cpu's counter presumably to avoid
systematic error.

Renaming percpu_counters to approximate_counters here would be nice.

> > But it might be a useful cleanup (although a slight de-optimization).
> > If you want I'll queue for 2.6.24 (there are several other module
> > patches pending too).
> 
> Might as well.  It removed a very small amount of code, and opens the
> door a bit for future optimizations in a single place.

You missed removing struct module_ref, too.  That's a little more code.

> > In an ideal world, (1) we would have percpu pointers using the same
> > percpu mechanism as percpu variables, (2) we would have a modal variant
> > of percpu counters which would collapse to a single counter when we
> > cared about the precise value (probably using stop_machine for the
> > transition).  This would be useful for many other cases.
> 
> Yeah, but before we do that, we need some kind of flag to get the
> percpu_counter_mod() fast path shoved into the slow path that takes the
> lock.

Well, there is already a branch in the fast path.  BTW, comparing before
and after applying your patch for a try_module_get/module_put pair, I
get 5.9 ns vs 20.6 ns.  We perhaps win something back on NUMA-like
machines, but it's not clear.

My initial implementation of such a counter used atomic ops via a
pointer.  The pointer was aimed at a shared counter for slow-mode.  The
problem is that you need to disable preemption around the counter update
(so you can use rcu to ensure everyone has seen the changeover).

> I'm not sure the stop_machine() mechanism will work very well if we try
> to expand this much further for other users.  What would the SGI guys
> think if these happened more than once in a blue moon?

Indeed, that's why I called it "stop_machine".  The real-time coders
hate it too.

Cheers,
Rusty.

