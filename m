Return-Path: <linux-kernel-owner+w=401wt.eu-S1763120AbXJRJNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763120AbXJRJNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXJRJNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:13:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34925 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755419AbXJRJNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:13:35 -0400
Date: Thu, 18 Oct 2007 02:13:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch](memory hotplug) Make kmem_cache_node for SLUB on memory
 online to avoid panic(take 3)
In-Reply-To: <20071018000004.cf4727e7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710180203500.13576@schroedinger.engr.sgi.com>
References: <20071018122345.514F.Y-GOTO@jp.fujitsu.com>
 <20071017204651.aefcece7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0710172321550.11401@schroedinger.engr.sgi.com>
 <20071018000004.cf4727e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007, Andrew Morton wrote:

> > Slab brings up a per node structure when the corresponding cpu is brought 
> > up. That was sufficient as long as we did not have any memoryless nodes. 
> > Now we may have to fix some things over there as well.
> 
> Is there amy point?  Our time would be better spent in making
> slab.c go away.  How close are we to being able to do that anwyay?

Well the problem right now is the regression in slab_free() on SMP. 
AFAICT UP and NUMA is fine and also most loads under SMP. Concurrent 
allocation / frees on multiple processors are several times faster (I see 
up to 10 fold improvements on an 8p).

However, long sequences of free operations from a single processor under 
SMP require too many atomic operations compared with SLAB. If I only do 
frees on a single processor on SMP then I can produce a 30% regression for 
slabs between 128 and 1024 byte in size. I have a patchset in the works 
that reduces the atomic operations for those.

SLAB currently has an advantage since it uses coarser grained locking. 
SLAB can take a global lock and then perform queue operations on 
multiple objects. SLUB has fine grained locking which increases 
concurrency but also the overhead of atomic operations.

The regression does not surface under UP since we do not need to do 
locking. And it does not surface under NUMA since the alien cache stuff in 
SLAB is reducing slab_free performance compared to SMP.

