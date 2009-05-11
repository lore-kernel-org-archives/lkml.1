Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZEKUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZEKUpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZEKUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:45:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbZEKUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:45:43 -0400
Date: Mon, 11 May 2009 13:40:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: mel@csn.ul.ie, a.p.zijlstra@chello.nl, npiggin@suse.de,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Divy Le Ray <divy@chelsio.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
Message-Id: <20090511134038.5cf1ad3b.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 15:46:39 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> The oom killer must be invoked regardless of the order if the allocation
> is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> free some memory.

Sigh.  We're supposed to be deleting __GFP_NOFAIL.  I added it as a way
of easily finding lame error-handling-challenged callers which need to
be fixed up.  So of course we went and added lots more callers.

y:/usr/src/linux-2.6.30-rc5> grep -rl GFP_NOFAIL . 
./arch/x86/xen/mmu.c
./arch/sparc/kernel/mdesc.c
./mm/page_alloc.c
./mm/failslab.c
./block/cfq-iosched.c
./fs/bio-integrity.c
./fs/ntfs/ChangeLog
./fs/ntfs/malloc.h
./fs/reiserfs/journal.c
./fs/gfs2/meta_io.c
./fs/gfs2/rgrp.c
./fs/gfs2/dir.c
./fs/gfs2/log.c
./fs/jbd/transaction.c
./fs/jbd/journal.c
./fs/jbd2/transaction.c
./fs/jbd2/journal.c
./drivers/net/cxgb3/cxgb3_main.c
./drivers/net/cxgb3/cxgb3_offload.c
./include/linux/slab.h
./include/linux/gfp.h

JBD (and hence JBD2) are the original sinners.

That net driver should be taught to just handle the allocation failure,
please.


It's super-uber-bad to be using __GFP_NOFAIL in an IO scheduler!  But maybe
that's just a brainfart:

			/*
			 * Inform the allocator of the fact that we will
			 * just repeat this allocation if it fails, to allow
			 * the allocator to do whatever it needs to attempt to
			 * free memory.
			 */

If "we will just repeat this allocation" means what it says then we
should use __GFP_NORETRY here, then retry the allocation if it failed. 
But a) this risks getting stuck in a hot loop in CFQ and b) we really
really don't want to be looping infinitely for memory relcaim down in
the guts of the block layer!

>From my reading, this function is called from get_request_wait(), via

	rq = get_request(q, rw_flags, bio, GFP_NOIO);

so we can't even do pageout here.

Jens, this all looks quite risky.
