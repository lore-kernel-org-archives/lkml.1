Return-Path: <linux-kernel-owner+w=401wt.eu-S934491AbZLKEtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491AbZLKEtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbZLKEgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:22 -0500
Received: from kroah.org ([198.145.64.141]:52918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759487AbZLKEfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:46 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:36 2009
Message-Id: <20091211042735.238833324@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>
Subject: [16/90] ext4: fix cache flush in ext4_sync_file
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0016-ext4-fix-cache-flush-in-ext4_sync_file.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 5f3481e9a80c240f169b36ea886e2325b9aeb745)

We need to flush the write cache unconditionally in ->fsync, otherwise
writes into already allocated blocks can get lost.  Writes into fully
allocated files are very common when using disk images for
virtualization, and without this fix can easily lose data after
an fdatasync, which is the typical implementation for a cache flush on
the virtual drive.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/fsync.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -92,9 +92,9 @@ int ext4_sync_file(struct file *file, st
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
-		if (journal && (journal->j_flags & JBD2_BARRIER))
-			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	}
 out:
+	if (journal && (journal->j_flags & JBD2_BARRIER))
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
 }


