Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbZELMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbZELMmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZELMmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:42:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41211 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZELMmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:42:01 -0400
Date: Tue, 12 May 2009 14:42:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, mel@csn.ul.ie,
       a.p.zijlstra@chello.nl, npiggin@suse.de, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Divy Le Ray <divy@chelsio.com>
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
Message-ID: <20090512124201.GO4140@kernel.dk>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com> <20090511134038.5cf1ad3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511134038.5cf1ad3b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11 2009, Andrew Morton wrote:
> On Sat, 9 May 2009 15:46:39 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
> 
> > The oom killer must be invoked regardless of the order if the allocation
> > is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> > free some memory.
> 
> Sigh.  We're supposed to be deleting __GFP_NOFAIL.  I added it as a way
> of easily finding lame error-handling-challenged callers which need to
> be fixed up.  So of course we went and added lots more callers.
> 
> y:/usr/src/linux-2.6.30-rc5> grep -rl GFP_NOFAIL . 
> ./arch/x86/xen/mmu.c
> ./arch/sparc/kernel/mdesc.c
> ./mm/page_alloc.c
> ./mm/failslab.c
> ./block/cfq-iosched.c
> ./fs/bio-integrity.c
> ./fs/ntfs/ChangeLog
> ./fs/ntfs/malloc.h
> ./fs/reiserfs/journal.c
> ./fs/gfs2/meta_io.c
> ./fs/gfs2/rgrp.c
> ./fs/gfs2/dir.c
> ./fs/gfs2/log.c
> ./fs/jbd/transaction.c
> ./fs/jbd/journal.c
> ./fs/jbd2/transaction.c
> ./fs/jbd2/journal.c
> ./drivers/net/cxgb3/cxgb3_main.c
> ./drivers/net/cxgb3/cxgb3_offload.c
> ./include/linux/slab.h
> ./include/linux/gfp.h
> 
> JBD (and hence JBD2) are the original sinners.
> 
> That net driver should be taught to just handle the allocation failure,
> please.
> 
> 
> It's super-uber-bad to be using __GFP_NOFAIL in an IO scheduler!  But maybe
> that's just a brainfart:
> 
> 			/*
> 			 * Inform the allocator of the fact that we will
> 			 * just repeat this allocation if it fails, to allow
> 			 * the allocator to do whatever it needs to attempt to
> 			 * free memory.
> 			 */
> 
> If "we will just repeat this allocation" means what it says then we
> should use __GFP_NORETRY here, then retry the allocation if it failed. 
> But a) this risks getting stuck in a hot loop in CFQ and b) we really
> really don't want to be looping infinitely for memory relcaim down in
> the guts of the block layer!
> 
> From my reading, this function is called from get_request_wait(), via
> 
> 	rq = get_request(q, rw_flags, bio, GFP_NOIO);
> 
> so we can't even do pageout here.
> 
> Jens, this all looks quite risky.

I agree, it's not all that pretty. That particular piece of code has
been there since v3 of CFQ at least, probably even earlier. So it is
2-3 years old at least.

I'll see what I can do about improving it. There's no easy solution to
this, we can't do any sort of pool backing since cfqq allocations could
persist forever. So it's probably better to handle the failure to
allocate by just stuffing the request directly on the dispatch queue and
just forget about the whole thing. If it happens only once in a blue
moon, it doesn't matter. If it happens regularly, not good...

-- 
Jens Axboe

