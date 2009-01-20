Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbZATTje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbZATTje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZATTjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:39:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762618AbZATTjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:39:21 -0500
Date: Tue, 20 Jan 2009 14:38:27 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Christoph Hellwig <hch@infradead.org>
cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <20090118173144.GA1999@infradead.org>
Message-ID: <Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
 <20090113214949.GN8071@disturbed> <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
 <20090118173144.GA1999@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 Jan 2009, Christoph Hellwig wrote:

> On Tue, Jan 13, 2009 at 11:28:58PM -0500, Mikulas Patocka wrote:
> > The result must not depend on magic timer values. If it does, you end up 
> > with undebbugable nondeterministic failures.
> > 
> > Why don't you change that 500ms wait to "wait until the flush finishes"? 
> > That would be correct.
> 
> Yes, this probably would better.  Could I motivate you to come up with
> a patch for that?
> 

Hi

I looked at the source and found out that it uses sync_blockdev for 
syncing --- but sync_blockdev writes only metadata buffers, it doesn't 
touch inodes and pages and doesn't resolve delayed allocations. So it 
really doesn't sync anything.

I replaced it with correct syncing of all inodes. With this patch it 
passes my testcase (no more spurious -ENOSPCs), but it still isn't 
correct, there is that 500ms delay --- if the machine was so overloaded 
that it couldn't sync withing 500ms, you still get spurious -ENOSPC.

There are notions about possible deadlocks (the syncer may lock against 
the process that is waiting for the sync to finish), that's why removing 
that 500ms delay isn't that easy as it seems. I don't have XFS knowledge 
to check for the deadlocks, it should be done by XFS developers. Also, 
when you resolve the deadlocks and drop the timeout, replace WB_SYNC_NONE 
with WB_SYNC_ALL in this patch.

Mikulas

---

Properly sync when the filesystem runs out of space because of delayed
allocation overaccounting.

Note that sync_blockdev writes just dirty metadata buffers, it doesn't touch
inodes or data buffers --- so it had no effect.

WB_SYNC_ALL should be used instead of WB_SYNC_NONE, but WB_SYNC_ALL gets worse
results --- it is likely because WB_SYNC_ALL sync locks against the process
doing the write, stalling the whole sync. This needs to be further investigated
by XFS developers. Also, further investigation is needed to remove that
delay(msecs_to_jiffies(500)).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/xfs/linux-2.6/xfs_sync.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.29-rc1-devel/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.29-rc1-devel.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-01-20 20:13:32.000000000 +0100
+++ linux-2.6.29-rc1-devel/fs/xfs/linux-2.6/xfs_sync.c	2009-01-20 20:24:31.000000000 +0100
@@ -446,7 +446,13 @@ xfs_flush_device_work(
 	void		*arg)
 {
 	struct inode	*inode = arg;
-	sync_blockdev(mp->m_super->s_bdev);
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.nr_to_write = LONG_MAX,
+	};
+	generic_sync_sb_inodes(mp->m_super, &wbc);
 	iput(inode);
 }
 
