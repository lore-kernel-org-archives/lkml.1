Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0CDA52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:57:28 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:42935 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101Ab0CDA5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:57:23 -0500
Date: Thu, 4 Mar 2010 11:57:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: xfs-masters@oss.sgi.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com, aelder@sgi.com
Subject: [PATCH] Re: linux-next: build warning after merge of the xfs tree
Message-ID: <20100304005709.GE14317@discord.disaster>
References: <20100304111930.86f7cc62.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304111930.86f7cc62.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 11:19:30AM +1100, Stephen Rothwell wrote:
> Hi Dave,
> 
> After merging the xfs tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> fs/xfs/linux-2.6/xfs_aops.c: In function 'xfs_end_io':
> fs/xfs/linux-2.6/xfs_aops.c:232: warning: 'error' may be used uninitialized in this function
> 
> Introduced by commit 77d7a0c2eeb285c9069e15396703d0cb9690ac50 ("xfs:
> Non-blocking inode locking in IO completion").
> 
> I can't tell if this is a false positive.  If the first two "if"
> statement bodies are skipped, then error is tested uninitialised.  It is
> possible that at least one of them has to be executed.

Right, there is a warning being generated there - I thought I fixed
that immediately after posting the first version of the patch. The
second version:

http://oss.sgi.com/archives/xfs/2010-02/msg00340.html

definitely had it fixed.

Alex, can you make sure you take the entire patch rather than
cutting and pasting bits from one patch version to another?  That
way you don't miss small changes to the patch that might have been
forgotten about....

Stephen, the patch below should fix the warning.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix uninitialised variable warning in xfs_end_io

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index f41a2d8..8989c16 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -230,7 +230,7 @@ xfs_end_io(
 {
 	xfs_ioend_t	*ioend = container_of(work, xfs_ioend_t, io_work);
 	struct xfs_inode *ip = XFS_I(ioend->io_inode);
-	int		error;
+	int		error = 0;
 
 	/*
 	 * For unwritten extents we need to issue transactions to convert a
