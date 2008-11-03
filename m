Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYKCWc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYKCWc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYKCWcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:32:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:52025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYKCWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:32:50 -0500
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
From: Peter Zijlstra <peterz@infradead.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20081103210748.GC9937@sgi.com>
References: <20081103210748.GC9937@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Nov 2008 23:33:23 +0100
Message-Id: <1225751603.7803.1640.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 15:07 -0600, Dimitri Sivanich wrote:
> When load balancing gets switched off for a set of cpus via the
> sched_load_balance flag in cpusets, those cpus wind up with the
> globally defined def_root_domain attached.  The def_root_domain is
> attached when partition_sched_domains calls detach_destroy_domains().
> A new root_domain is never allocated or attached as a sched domain
> will never be attached by __build_sched_domains() for the non-load
> balanced processors.
> 
> The problem with this scenario is that on systems with a large number
> of processors with load balancing switched off, we start to see the
> cpupri->pri_to_cpu->lock in the def_root_domain becoming contended.
> This starts to become much more apparent above 8 waking RT threads
> (with each RT thread running on it's own cpu, blocking and waking up
> continuously).
> 
> I'm wondering if this is, in fact, the way things were meant to work,
> or should we have a root domain allocated for each cpu that is not to
> be part of a sched domain?  Note the the def_root_domain spans all of
> the non-load-balanced cpus in this case.  Having it attached to cpus
> that should not be load balancing doesn't quite make sense to me.

It shouldn't be like that, each load-balance domain (in your case a
single cpu) should get its own root domain. Gregory?

> Here's where we've often seen this lock contention occur:

what's this horrible output from?
