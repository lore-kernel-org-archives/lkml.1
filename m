Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXDWGOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXDWGOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161199AbXDWGOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:14:55 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:35216 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105AbXDWGOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:14:53 -0400
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com
In-Reply-To: <E1HfM9K-0003OA-00@dorka.pomaz.szeredi.hu>
References: <20070420155154.898600123@chello.nl>
	 <20070420155503.608300342@chello.nl>
	 <20070421025532.916b1e2e.akpm@linux-foundation.org>
	 <E1HfCzN-0002dZ-00@dorka.pomaz.szeredi.hu>
	 <20070421035444.f7a42fad.akpm@linux-foundation.org>
	 <E1HfM9K-0003OA-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 08:14:49 +0200
Message-Id: <1177308889.26937.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-21 at 22:25 +0200, Miklos Szeredi wrote: 
> > > The other deadlock, in throttle_vm_writeout() is still to be solved.
> > 
> > Let's go back to the original changelog:
> > 
> > Author: marcelo.tosatti <marcelo.tosatti>
> > Date:   Tue Mar 8 17:25:19 2005 +0000
> > 
> >     [PATCH] vm: pageout throttling
> >     
> >     With silly pageout testcases it is possible to place huge amounts of memory
> >     under I/O.  With a large request queue (CFQ uses 8192 requests) it is
> >     possible to place _all_ memory under I/O at the same time.
> >     
> >     This means that all memory is pinned and unreclaimable and the VM gets
> >     upset and goes oom.
> >     
> >     The patch limits the amount of memory which is under pageout writeout to be
> >     a little more than the amount of memory at which balance_dirty_pages()
> >     callers will synchronously throttle.
> >     
> >     This means that heavy pageout activity can starve heavy writeback activity
> >     completely, but heavy writeback activity will not cause starvation of
> >     pageout.  Because we don't want a simple `dd' to be causing excessive
> >     latencies in page reclaim.
> >     
> >     Signed-off-by: Andrew Morton <akpm@osdl.org>
> >     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> > 
> > (A good one!  I wrote it ;))
> > 
> > 
> > I believe that the combination of dirty-page-tracking and its calls to
> > balance_dirty_pages() mean that we can now never get more than dirty_ratio
> > of memory into the dirty-or-writeback condition.
> > 
> > The vm scanner can convert dirty pages into clean, under-writeback pages,
> > but it cannot increase the total of dirty+writeback.
> 
> What about swapout?  That can increase the number of writeback pages,
> without decreasing the number of dirty pages, no?

Could we not solve that by enabling cap_account_writeback on
swapper_space, and thereby account swap writeback pages. Then the VM
knows it has outstanding IO and need not panic.

