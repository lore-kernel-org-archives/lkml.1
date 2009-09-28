Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZI1Rr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZI1Rr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZI1Rr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:47:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbZI1Rr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:47:58 -0400
Date: Mon, 28 Sep 2009 10:46:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-Id: <20090928104617.9c4b868a.akpm@linux-foundation.org>
In-Reply-To: <20090928012337.GC1656@one.firstfloor.org>
References: <20090924132626.485545323@polymtl.ca>
	<20090924133359.218934235@polymtl.ca>
	<20090924212013.d27226c4.akpm@linux-foundation.org>
	<20090928012337.GC1656@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 03:23:37 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Sep 24, 2009 at 09:20:13PM -0700, Andrew Morton wrote:
> > On Thu, 24 Sep 2009 09:26:28 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Immediate values are used as read mostly variables that are rarely updated. They
> > > use code patching to modify the values inscribed in the instruction stream. It
> > > provides a way to save precious cache lines that would otherwise have to be used
> > > by these variables.
> > 
> > What a hare-brained concept.
> 
> The concept makes a lot of sense.

But does it?

> Cache misses are extremly costly
> on modern CPUs and when the workload has blown the caches away in user space
> it can literally be hundreds or even thousands of cycles to fetch
> a data cache line.

Well yes.  But for a kernel dcache entry to have been replaced by a
userspace one, userspace will, on average, have itself incurred a *lot*
of dcache misses.  So we just spent a lot of CPU cycles in userspace,
so the cost of the in-kernel dcache miss is relatively small.

That's how caches work!  If a kernel variable is read frequently, it's
still in dcache.  If it's read infrequently, it falls out of dcache but
that doesn't matter much because it's read infrequently!

And lo, it appears that we're unable to observe any measurable benefit
from the changes, so we're cooking up weird fake testcases to be able to
drag this thing out of the noise floor.

Obviously the change will have _some_ performance benefit.  But is it
enough to justify the addition of yet more tricksy code to maintain? 
That's a very different question.  

> There's a lot of data around that the kernel has very little IPC
> due to a lot of cache misses in some workloads.

Kernel gets a lot of cache misses, but that's usually against
userspace, pagecache, net headers/data, etc.  I doubt if it gets many
misses against a small number of small, read-mostly data items which is
what this patch addresses.

And it is a *small* number of things to which this change is
applicable.  This is because the write operation for these read-mostly
variables becomes very expensive indeed.  This means that we cannot use
"immediate values" for any variable which can conceivable be modified
at high frequency by any workload.

For example, how do we know it's safe to use immediate-values for
anything which can be modified from userspace, such as a sysfs-accessed
tunable?  How do we know this won't take someone's odd-but-legitimate
workload and shoot it in the head?


Summary:

- at this stage no real-world beenefit has been demonstrated afaict

- the feature is narrowly applicable anyway

- it addes complexity and maintenance cost


