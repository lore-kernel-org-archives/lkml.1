Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXDUK4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXDUK4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 06:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030673AbXDUK4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 06:56:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030664AbXDUK4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 06:56:15 -0400
Date: Sat, 21 Apr 2007 03:54:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
Message-Id: <20070421035444.f7a42fad.akpm@linux-foundation.org>
In-Reply-To: <E1HfCzN-0002dZ-00@dorka.pomaz.szeredi.hu>
References: <20070420155154.898600123@chello.nl>
	<20070420155503.608300342@chello.nl>
	<20070421025532.916b1e2e.akpm@linux-foundation.org>
	<E1HfCzN-0002dZ-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007 12:38:45 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> The other deadlock, in throttle_vm_writeout() is still to be solved.

Let's go back to the original changelog:

Author: marcelo.tosatti <marcelo.tosatti>
Date:   Tue Mar 8 17:25:19 2005 +0000

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
    
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

(A good one!  I wrote it ;))


I believe that the combination of dirty-page-tracking and its calls to
balance_dirty_pages() mean that we can now never get more than dirty_ratio
of memory into the dirty-or-writeback condition.

The vm scanner can convert dirty pages into clean, under-writeback pages,
but it cannot increase the total of dirty+writeback.

Hence I assert that the problem which throttle_vm_writeout() was designed
to address can no longer happen, so we can simply remove it.

(There might be problems with ZONE_DMA or ZONE_NORMAL 100% full of
dirty+writeback pages, but throttle_vm_writeout() wont help in this case
anyway)
