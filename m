Return-Path: <linux-kernel-owner+w=401wt.eu-S966385AbXEVSmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966385AbXEVSmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbXEVSmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:42:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15367 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbXEVSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:42:04 -0400
Date: Tue, 22 May 2007 14:39:35 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-ID: <20070522183935.GF6138@think.oraclecorp.com>
References: <20070516171156.GY26766@think.oraclecorp.com> <20070516112515.b6f247b2.akpm@linux-foundation.org> <20070516191339.GA26766@think.oraclecorp.com> <20070516123342.714a11d8.akpm@linux-foundation.org> <20070516195359.GE26766@think.oraclecorp.com> <20070516130413.1fd391bf.akpm@linux-foundation.org> <20070516201414.GF26766@think.oraclecorp.com> <20070516133726.0c68a65f.akpm@linux-foundation.org> <20070522163511.GB6138@think.oraclecorp.com> <20070522112120.4a5c6a5d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522112120.4a5c6a5d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 11:21:20AM -0700, Andrew Morton wrote:
> > 
> > I patched jbd's log_do_checkpoint to put all the blocks it wanted to
> > write in a radix tree, then send them all down in order at the end.
> 
> Side note: we already have all of that capability in the kernel:
> sync_inode(blockdev_inode, wbc) will do an ascending-LBA write of the whole
> blockdev.
> 
> It could be that as a quick diddle, running sync_inode() in
> do-block-on-queue-congestion mode prior to doing the checkpoint would have
> some benefit.

I had played with this in the past (although not this time around), but
I had performance problems with newly dirtied blocks sneaking in.

> > At any rate, it may be worth putzing with the writeback routines to try
> > and find dirty pages close by in the block dev inode when doing data
> > writeback.  My guess is that ext3 should be going 1.5x to 2x faster for
> > this particular run, but that's a huge amount of complexity added so I'm
> > not convinced it is a great idea.
> 
> Yes, this is a distinct disadvantage of the whole per-address-space
> writeback scheme - we're leaving IO scheduling optimisations on the floor,
> especially wrt the blockdev inode, but probably also wrt regular-file
> versus regular-file.  Even if one makes the request queue tremendously
> huge, that won't help if there's dirty data close-by the disk head which
> hasn't even been put into the queue yet.
> 

I'm not sure yet on a good way to fix it, but I do think I've nailed
it down as the cause of the strange performance numbers I'm getting.

-chris

