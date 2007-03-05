Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbXCEE6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbXCEE6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXCEE6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:58:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbXCEE6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:58:39 -0500
Date: Mon, 5 Mar 2007 05:58:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: optimize siblings status check logic in wake_idle()
Message-ID: <20070305045831.GA2972@wotan.suse.de>
References: <20070302202331.B27368@unix-os.sc.intel.com> <20070305023534.GB16666@wotan.suse.de> <20070304201309.C27368@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070304201309.C27368@unix-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 08:13:09PM -0800, Suresh B wrote:
> On Mon, Mar 05, 2007 at 03:35:34AM +0100, Nick Piggin wrote:
> > On Fri, Mar 02, 2007 at 08:23:32PM -0800, Suresh B wrote:
> > > When a logical cpu 'x' already has more than one process running, then most likely
> > > the siblings of that cpu 'x' must be busy. Otherwise the idle siblings
> > > would have likely(in most of the scenarios) picked up the extra load making
> > > the load on 'x' atmost one.
> > 
> > Do you have any stats on this?
> 
> Its more of a theory. There will be some conditions that this won't be true but
> IMO those won't be common cases.
> 
> > > Use this logic to eliminate the siblings status check and minimize the cache
> > > misses encountered on a heavily loaded system.
> > 
> > Well it does increase the cacheline footprint a bit, but all cachelines
> > should be local to our L1 cache, presuming you don't have any CPUs where
> > threads have seperate caches.
> 
> These wakeup's can happen across SMP and NUMA domains. In those cases, most likely
> the sibling runqueue lines won't be in the caches. This has nothing to do with
> siblings sharing caches or not.

Oh that's true.

> > 
> > What sort of numbers do you have?
> 
> On a 16 node system, we have seen ~1.25% perf improvement on a database workload
> when we completely short circuited wake_idle(). This patch is trying to comeup
> with a best compromise to avoid the cache misses and also minimize the latenices,
> perf impact.

Hmm, I wonder what if we only wake_idle if the wakeup comes from this
CPU or a sibling? That's probably going to have downsides in some
workloads as well, though.

