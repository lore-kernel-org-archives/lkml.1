Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZBXUHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZBXUHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbZBXUHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:07:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbZBXUHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:07:41 -0500
Date: Tue, 24 Feb 2009 15:07:40 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: next-20090220: XFS: inconsistent lock state
Message-ID: <20090224200740.GA9266@infradead.org>
References: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 08:52:59PM +0300, Alexander Beregalov wrote:
> Hi
> 
> [ INFO: inconsistent lock state ]
> 2.6.29-rc5-next-20090220 #2
> ---------------------------------
> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
> kswapd0/324 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&(&ip->i_lock)->mr_lock){+++++?}, at: [<ffffffff803ca60a>]
> xfs_ilock+0xaa/0x120
> {RECLAIM_FS-ON-W} state was registered at:

That's a false positive.  While the ilock can be taken in reclaim the
allocation here is done before the inode is added to the inode cache.

The patch below should help avoiding the warning:


Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-02-24 20:56:00.716027739 +0100
+++ xfs/fs/xfs/xfs_iget.c	2009-02-24 20:56:46.089031360 +0100
@@ -246,9 +246,6 @@ xfs_iget_cache_miss(
 		goto out_destroy;
 	}
 
-	if (lock_flags)
-		xfs_ilock(ip, lock_flags);
-
 	/*
 	 * Preload the radix tree so we can insert safely under the
 	 * write spinlock. Note that we cannot sleep inside the preload
@@ -259,6 +256,15 @@ xfs_iget_cache_miss(
 		goto out_unlock;
 	}
 
+	/*
+	 * Because the inode hasn't been added to the radix-tree yet it can't
+	 * be found by another thread, so we can do the non-sleeping lock here.
+	 */
+	if (lock_flags) {
+		if (!xfs_ilock_nowait(ip, lock_flags))
+			BUG();
+	}
+
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = agino & mask;
 	write_lock(&pag->pag_ici_lock);
