Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbZJKHpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbZJKHpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 03:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZJKHpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 03:45:15 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:54025 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZJKHpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 03:45:13 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091011022813.GA21315@localhost>
References: <20091007073818.318088777@intel.com>
	 <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz>
	 <1255101512.8802.65.camel@laptop> <20091009154759.GJ7654@duck.suse.cz>
	 <20091011022813.GA21315@localhost>
Content-Type: text/plain
Date: Sun, 11 Oct 2009 09:44:40 +0200
Message-Id: <1255247080.11081.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-11 at 10:28 +0800, Wu Fengguang wrote:
> 
> Note that the total limit check itself may not be sufficient. For
> example, there are no nr_writeback limit for NFS (and maybe btrfs)
> after removing the congestion waits.  Therefore it is very possible
> 
>         nr_writeback => dirty_thresh
>         nr_dirty     => 0
> 
> which is obviously undesirable: everything newly dirtied are soon put
> to writeback. It violates the 30s expire time and the background
> threshold rules, and will hurt write-and-truncate operations (ie. temp
> files).
> 
> So the better solution would be to impose a nr_writeback limit for
> every filesystem that didn't already have one (the block io queue).
> NFS used to have that limit with congestion_wait, but now we need
> to do a wait queue for it.
> 
> With the nr_writeback wait queue, it can be guaranteed that once
> balance_dirty_pages() asks for writing 1500 pages, it will be done
> with necessary sleeping in the bdi flush thread. So we can safely
> remove the loop and double checking of global dirty limit in
> balance_dirty_pages().

nr_reclaim = nr_dirty + nr_writeback + nr_unstable, so anything calling
into balance_dirty_pages() would still block on seeing such large
amounts of nr_writeback.

Having the constraint nr_dirty + nr_writeback + nr_unstable <
dirty_thresh should ensure we never have nr_writeback > dirty_thresh,
simply because you cannot dirty more, which then cannot be converted to
more writeback.

Or am I missing something?

