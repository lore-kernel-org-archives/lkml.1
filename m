Return-Path: <linux-kernel-owner+w=401wt.eu-S1750900AbZHOEwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbZHOEwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 00:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZHOEwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 00:52:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:41938 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbZHOEwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 00:52:39 -0400
Date: Sat, 15 Aug 2009 06:52:37 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Message-ID: <20090815045237.GC19195@wotan.suse.de>
References: <200908141946.n7EJkh7B018160@mail.q-ag.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908141946.n7EJkh7B018160@mail.q-ag.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 09:16:00PM +0200, Manfred Spraul wrote:
> An alternative patch to Nick's proposal:
> http://lkml.org/lkml/2009/8/11/11
> The patch is based on Nick's patch.
> 
> The patch is ontop of the first three patches from Nick.
> 
> Identical with Nick's patch:
> - per semaphore list to optimize single sop semop calls:
> This avoids that the semaphore operations have to scan through all waiting
> tasks, even for the tasks that are waiting on a different semaphore from
> the same array.
> 
> Differences:
> - same code for per-semaphore and global list.
> - one list for both wait-for-zero and decrement instead of two lists.
> - unlink_queue helper function
> 
> Open points:
> - further testing
> - understand all changes. e.g. why switch from "if (alter)" to
> 	"if (alter & !error)" in update_queue
> 
> >From the diffstat, it's simpler: 50 new lines instead of 110 new lines.
> 
> Nick: What do you think? Could you try your test app?

The problem with using the same algorithm is that we don't need to
"restart scanning" the simple-op lists when one of them succeeds.
This is because if a negative op fails, then no amount of subsequent
simple negative ops will make it succeed.

With multi-ops, it can be adding and subtracting and waiting for
zero of different sems etc, so in order to try to stay strictly
FIFO, then we always have to recheck all previous failed ops after
one succeeds.

The other problem is that we have to scan all ops in the multi-op
list because we don't know what combination of sem values might
allow the op to succeed. With the single-op lists, we know if the
semval is 0, then we don't have to scan the negative list, and if
it is non-0 then we don't have to scan the zero list.

Combine these two problems and that is where the O(n^2) behaviour
comes in to the complex-op algorithm.

