Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZCZDY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZCZDY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZCZDYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:24:48 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39406 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbZCZDYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:24:48 -0400
Date: Wed, 25 Mar 2009 23:24:45 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] issue storage device flush via sync_blockdev()
Message-ID: <20090326032445.GA16999@havoc.gtf.org>
References: <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325212923.GA5620@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush storage dev writeback cache, for each call to sync_blockdev().

sync_blockdev() is used primarily for two purposes:

1) To flush all data to permanent storage prior to a major event,
such as: unmount, journal close, unplug, poweroff, explosion, ...

2) As a "sledgehammer hack" to provide fsync(2) via file_fsync to
filesystems, generally simple or legacy filesystems, such as HFS,
HFS+, ADFS, AFFS, bfs, UFS, NTFS, qnx4 and FAT.

This change guarantees that the underlying storage device will have
flushed any pending data in its writeback cache to permanent media,
before it returns (...if underlying storage dev supports flushes).

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
Changes since last patch:
- do not return error, if storage dev does not support flushes at all
  (-EOPNOTSUPP)

diff --git a/fs/buffer.c b/fs/buffer.c
index 891e1c7..e04d7a4 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -173,8 +173,17 @@ int sync_blockdev(struct block_device *bdev)
 {
 	int ret = 0;
 
-	if (bdev)
-		ret = filemap_write_and_wait(bdev->bd_inode->i_mapping);
+	if (!bdev)
+		return 0;
+	
+	ret = filemap_write_and_wait(bdev->bd_inode->i_mapping);
+	if (ret)
+		return ret;
+	
+	ret = blkdev_issue_flush(bdev, NULL);
+	if (ret == -EOPNOTSUPP)
+		ret = 0;
+	
 	return ret;
 }
 EXPORT_SYMBOL(sync_blockdev);
