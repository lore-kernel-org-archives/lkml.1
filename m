Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXCEEtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXCEEtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXCEEtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:49:49 -0500
Received: from mga06.intel.com ([134.134.136.21]:36276 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbXCEEts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:49:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,247,1170662400"; 
   d="scan'208"; a="203904332:sNHT17816365"
Date: Sun, 4 Mar 2007 20:13:09 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: optimize siblings status check logic in wake_idle()
Message-ID: <20070304201309.C27368@unix-os.sc.intel.com>
References: <20070302202331.B27368@unix-os.sc.intel.com> <20070305023534.GB16666@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070305023534.GB16666@wotan.suse.de>; from npiggin@suse.de on Mon, Mar 05, 2007 at 03:35:34AM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 03:35:34AM +0100, Nick Piggin wrote:
> On Fri, Mar 02, 2007 at 08:23:32PM -0800, Suresh B wrote:
> > When a logical cpu 'x' already has more than one process running, then most likely
> > the siblings of that cpu 'x' must be busy. Otherwise the idle siblings
> > would have likely(in most of the scenarios) picked up the extra load making
> > the load on 'x' atmost one.
> 
> Do you have any stats on this?

Its more of a theory. There will be some conditions that this won't be true but
IMO those won't be common cases.

> > Use this logic to eliminate the siblings status check and minimize the cache
> > misses encountered on a heavily loaded system.
> 
> Well it does increase the cacheline footprint a bit, but all cachelines
> should be local to our L1 cache, presuming you don't have any CPUs where
> threads have seperate caches.

These wakeup's can happen across SMP and NUMA domains. In those cases, most likely
the sibling runqueue lines won't be in the caches. This has nothing to do with
siblings sharing caches or not.

> 
> What sort of numbers do you have?

On a 16 node system, we have seen ~1.25% perf improvement on a database workload
when we completely short circuited wake_idle(). This patch is trying to comeup
with a best compromise to avoid the cache misses and also minimize the latenices,
perf impact.

thanks,
suresh
