Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZI1ULL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZI1ULL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZI1ULJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:11:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58489 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZI1ULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:11:05 -0400
Date: Mon, 28 Sep 2009 22:11:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-ID: <20090928201108.GG1656@one.firstfloor.org>
References: <20090924132626.485545323@polymtl.ca> <20090924133359.218934235@polymtl.ca> <20090924212013.d27226c4.akpm@linux-foundation.org> <20090928012337.GC1656@one.firstfloor.org> <20090928104617.9c4b868a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928104617.9c4b868a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's how caches work!  If a kernel variable is read frequently, it's
> still in dcache.  If it's read infrequently, it falls out of dcache but
> that doesn't matter much because it's read infrequently!

You're assuming that the CPU's cache LRU is perfect. e.g. that it
never gets swamped by a lot of short term accesses. And that it has perfect
insight if something is really frequently used or not. But that's 
not true. A short term cache pig, even when it uses the data only
once, can swamp it and throw out all the kernel state, even when it's
accessed frequently enough.  It's a bit similar to all the similar problems
with the page cache LRU.
> 
> And lo, it appears that we're unable to observe any measurable benefit
> from the changes, so we're cooking up weird fake testcases to be able to
> drag this thing out of the noise floor.

Yes, a really measurable improvement would be great. One problem
right now is that not enough users are there, so measuring
something would first need more users to really reduce the cache misses.
> 
> Obviously the change will have _some_ performance benefit.  But is it
> enough to justify the addition of yet more tricksy code to maintain? 

I don't think the code is particularly tricky. Especially the user API
is very simple and neat.
> 
> And it is a *small* number of things to which this change is
> applicable.  This is because the write operation for these read-mostly
> variables becomes very expensive indeed.  This means that we cannot use
> "immediate values" for any variable which can conceivable be modified
> at high frequency by any workload.

A natural target is any sysctl for example.

> 
> For example, how do we know it's safe to use immediate-values for
> anything which can be modified from userspace, such as a sysfs-accessed
> tunable?  How do we know this won't take someone's odd-but-legitimate
> workload and shoot it in the head?

You're arguing we should tune for sysctl performance? That doesn't make
sense to me.

> 
> 
> Summary:
> 
> - at this stage no real-world beenefit has been demonstrated afaict

Yes that's an issue that needs to be addressed.

A good way would be probably to do some measurements on cache misses
for given workloads and then convert all applicable global references
and see how much difference it makes.

> - the feature is narrowly applicable anyway

I don't think so, there are quite a lot of global flag variables.

% find /proc/sys -type f | wc -l
565

not counting sysfs, boot options and other things.
> 
> - it addes complexity and maintenance cost

Very little as far as I can see.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
