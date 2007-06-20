Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbXFTI7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbXFTI7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbXFTI7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:59:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbXFTI7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:59:07 -0400
Date: Wed, 20 Jun 2007 01:58:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: davej@redhat.com, tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Change in default vm_dirty_ratio
Message-Id: <20070620015826.03f1d71a.akpm@linux-foundation.org>
In-Reply-To: <1182328536.21117.24.camel@twins>
References: <1182201271.4883.22.camel@localhost.localdomain>
	<20070618164711.9de1c38e.akpm@linux-foundation.org>
	<20070620042434.GC12096@redhat.com>
	<20070619214407.dfff0ca6.akpm@linux-foundation.org>
	<1182328536.21117.24.camel@twins>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 20 Jun 2007 10:35:36 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2007-06-19 at 21:44 -0700, Andrew Morton wrote:
> 
> > Anyway, this is all arse-about.  What is the design?  What algorithms
> > do we need to implement to do this successfully?  Answer me that, then
> > we can decide upon these implementation details.
> 
> Building on the per BDI patches, how about integrating feedback from the
> full-ness of device queues. That is, when we are happily doing IO and we
> cannot possibly saturate the active devices (as measured by their queue
> never reaching 75%?) then we can safely increase the total dirty limit.
> 
> OTOH, when even with the per BDI dirty limit the device queue is
> constantly saturated (contended) we ought to lower the total dirty
> limit.
> 
> Lots of detail here to work out, but does this sound workable?

It's pretty easy to fill the queues - I'd expect that there are a lot of
not-very-heavy workloads which cause the kernel to shove a lot of little
writes into the queue when it visits the blockdev mapping: a shower of
inodes, directory entries, indirect blocks, etc.  With very little dirty
memory associated with it.

But back away further.

What do we actually want the kernel to *do*?  Stated in terms of "when the
dirty memory state is A, do B" and "when userspace does C, the kernel should
do D".

Top-level statement: "when userspace does anything, the kernel should not
suck" ;)  Some refinement is needed there.

I _think_ the problem is basically one of latency: a) writes starving reads
and b) dirty memory causing page reclaim to stall and c) inter-device
contention on the global memory limits.

Hard.  If the device isn't doing anything else then we can shove data at it
freely.  If reads (or synchronous writes) come in then perhaps the VM
should back off and permit dirty memory to go higher.

The anticipatory scheduler(s) are supposed to fix this.

Perhaps our queues are too long - if the VFS _does_ back off, it'll take
some time for that to have an effect.

Perhaps the fact that the queue size knows nothing about the _size_ of the
requests in the queue is a problem.


Back away even further here.

What user-visible problem(s) are we attemping to fix?
