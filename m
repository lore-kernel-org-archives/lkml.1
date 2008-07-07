Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYGGOKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYGGOKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYGGOK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:10:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60142 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYGGOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:10:28 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Chris Mason <chris.mason@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: benh@kernel.crashing.org, ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
In-Reply-To: <1215007896.3330.6.camel@localhost.localdomain>
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>
	 <1215007896.3330.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 10:09:16 -0400
Message-Id: <1215439756.24425.21.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 09:11 -0500, James Bottomley wrote:

> If you really need the full scheduling capabilities of threads, then it
> sounds like a threadpool is all you need (and we should just provide a
> unified interface).
> 

workqueues weren't quite right for btrfs either, where I need to be able
to verify checksums after IO completes (among other things).  So I also
ended up with a simple thread pool system that can add kthreads on
demand.

So, it sounds like we'd have a number of users for a unified interface.

> Initially you were implying you'd prefer some type of non blockable
> workqueue (i.e. a workqueue that shifts to the next work item when and
> earlier item blocks).   I can see this construct being useful because it
> would have easier to use semantics and be more lightweight than a full
> thread spawn.  It strikes me we could use some of the syslets work to do
> this ... all the queue needs is an "next activation head", which will be
> the next job in the queue in the absence of blocking.  When a job
> blocks, syslets informs the workqueue and it moves on to the work on the
> "next activation head".  If a prior job unblocks, syslets informs the
> queue and it moves the "next activation head" to the unblocked job.
> What this is doing is implementing a really simple scheduler within a
> single workqueue, which I'm unsure is actually a good idea since
> schedulers are complex and tricky things, but it is probably worthy of
> discussion.

I have a few different users of the thread pools, and I ended up having
to create a number of pools to avoid deadlocks between different types
of operations on the same work list.  Ideas like the next activation
head really sound cool, but the simplicity of just making dedicated
pools to dedicated tasks is much much easier to debug.

If the pools are able to resize themselves sanely, it should perform
about the same as the fancy stuff ;)

-chris


