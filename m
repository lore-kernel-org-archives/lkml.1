Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZAVU7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZAVU7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZAVU7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:59:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZAVU7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:59:15 -0500
Date: Thu, 22 Jan 2009 15:59:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090122205913.GA30859@infradead.org>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com> <20090113214949.GN8071@disturbed> <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com> <20090118173144.GA1999@infradead.org> <Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com> <20090120232422.GF10158@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120232422.GF10158@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 10:24:22AM +1100, Dave Chinner wrote:
> Right, so you need to use internal xfs sync functions that don't
> have these problems. That is:
> 
> 	error = xfs_sync_inodes(ip->i_mount, SYNC_DELWRI|SYNC_WAIT);
> 
> will do a blocking flush of all the inodes without deadlocks occurring.
> Then you can remove the 500ms wait.

I've given this a try with Eric's testcase from #724 in the oss bugzilla,
but it's not enough yet.  I thinks that's because SYNC_WAIT is rather
meaningless for data writeout, and we need SYNC_IOWAIT instead.  The
patch below gets the testcase working for me:


Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-01-22 06:29:30.646141628 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-01-22 21:57:53.073864570 +0100
@@ -446,7 +446,9 @@ xfs_flush_device_work(
 	void		*arg)
 {
 	struct inode	*inode = arg;
-	sync_blockdev(mp->m_super->s_bdev);
+
+	xfs_sync_inodes(mp, SYNC_DELWRI);
+	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_IOWAIT);
 	iput(inode);
 }
 

