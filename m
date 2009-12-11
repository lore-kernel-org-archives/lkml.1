Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbZLKEqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbZLKEqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933366AbZLKEqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:46:31 -0500
Received: from kroah.org ([198.145.64.141]:37037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762182AbZLKEgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:35 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:11 2009
Message-Id: <20091211042811.145411136@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [69/90] ext4: avoid issuing unnecessary barriers
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0069-ext4-avoid-issuing-unnecessary-barriers.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 6b17d902fdd241adfa4ce780df20547b28bf5801)

We don't to issue an I/O barrier on an error or if we force commit
because we are doing data journaling.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/fsync.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -60,7 +60,7 @@ int ext4_sync_file(struct file *file, st
 
 	ret = flush_aio_dio_completed_IO(inode);
 	if (ret < 0)
-		goto out;
+		return ret;
 	/*
 	 * data=writeback:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
@@ -79,10 +79,8 @@ int ext4_sync_file(struct file *file, st
 	 *  (they were dirtied by commit).  But that's OK - the blocks are
 	 *  safe in-journal, which is all fsync() needs to ensure.
 	 */
-	if (ext4_should_journal_data(inode)) {
-		ret = ext4_force_commit(inode->i_sb);
-		goto out;
-	}
+	if (ext4_should_journal_data(inode))
+		return ext4_force_commit(inode->i_sb);
 
 	if (!journal)
 		ret = sync_mapping_buffers(inode->i_mapping);


