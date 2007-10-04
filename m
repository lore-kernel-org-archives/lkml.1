Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbXJDV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbXJDV5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbXJDV5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:57:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758199AbXJDV5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:57:31 -0400
Date: Thu, 4 Oct 2007 14:56:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: wfg@mail.ustc.edu.cn, a.p.zijlstra@chello.nl, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove throttle_vm_writeout()
Message-Id: <20071004145640.18ced770.akpm@linux-foundation.org>
In-Reply-To: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 14:25:22 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> By relying on the global diry limits, this can cause a deadlock when
> devices are stacked.
> 
> If the stacking is done through a fuse filesystem, the __GFP_FS,
> __GFP_IO tests won't help: the process doing the allocation doesn't
> have any special flag.

This description of the bug-which-is-being-fixed is nowhere near adequate
enough for a reviewer to understand the problem.  This makes it hard to
suggest alternative fixes.

> So why exactly does this function exist?

That's described in the changelog for the patch which added
throttle_vm_writeout().  Unsurprisingly ;)

> Direct reclaim does not _increase_ the number of dirty pages in the
> system, so rate limiting it seems somewhat pointless.
> 
> There are two cases:
> 
> 1) File backed pages -> file
> 
>   dirty + writeback count remains constant
> 
> 2) Anonymous pages -> swap
> 
>   writeback count increases, dirty balancing will hold back file
>   writeback in favor of swap
> 
> So the real question is: does case 2 need rate limiting, or is it OK
> to let the device queue fill with swap pages as fast as possible?

None of the above.

    [PATCH] vm: pageout throttling
    
    With silly pageout testcases it is possible to place huge amounts of memory
    under I/O.  With a large request queue (CFQ uses 8192 requests) it is
    possible to place _all_ memory under I/O at the same time.
    
    This means that all memory is pinned and unreclaimable and the VM gets
    upset and goes oom.
    
    The patch limits the amount of memory which is under pageout writeout to be
    a little more than the amount of memory at which balance_dirty_pages()
    callers will synchronously throttle.
    
    This means that heavy pageout activity can starve heavy writeback activity
    completely, but heavy writeback activity will not cause starvation of
    pageout.  Because we don't want a simple `dd' to be causing excessive
    latencies in page reclaim.

afaict that problem is still there.  It is possible to get all of
ZONE_NORMAL dirty on a highmem machine.  With a large queue (or lots of
queues), vmscan can them place all of ZONE_NORMAL under IO.

It could be that we've fixed this problem via other means in the interrim,
but from a quick peek to seems to me that the scanner will still do a 100%
CPU burn when all of a zone's pages are under writeback.

throttle_vm_writeout() should be a per-zone thing, I guess.  Perhaps fixing
that would fix your deadlock.  That's doubtful, but I don't know anything
about your deadlock so I cannot say.

