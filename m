Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZDNDfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZDNDfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZDNDed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:34:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40684 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZDNDeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aS45EJfn7aPvVqGFFAkMBRYFYkc0ISdS8jZlf6W3gtjZa2DUK95csHwd1sCMexI206
         uDU6n5dmruvUxrWwhDLDoPLucGwXaoKD8eVwjoZ0u7Rf3AA6rNRGxHGPsMTKv17LwkMu
         OJ5ZeqbjrT8/CUS+P/sKfUqt+dyreLInG6uF8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 2/3] kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
Date: Tue, 14 Apr 2009 05:34:24 +0200
Message-Id: <1239680065-25013-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a deadlock

reiserfs_truncate_file() can be called from multiple context where
the write lock can be already hold or not.

This function also acquire (possibly recursively) the write
lock. Subsequent releases before sleeping will not actually release
the lock because we may be in more than one lock depth degree.

A typical case is:

reiserfs_file_release {
	acquire_the_lock()
	reiserfs_truncate_file()
		reacquire_the_lock()
		journal_begin() {
			do_journal_begin_r() {
				reiserfs_wait_on_write_block() {
					/*
					 * Not released because still one
					 * depth owned
					 */
					release_lock()
					wait_for_event()

At this stage the event never happen because the one which provides
it needs the write lock.

We use reiserfs_write_lock_once() here to ensure that we don't acquire the
write lock recursively.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/inode.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 88ef0b7..153668e 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2083,8 +2083,9 @@ int reiserfs_truncate_file(struct inode *inode, int update_timestamps)
 	int error;
 	struct buffer_head *bh = NULL;
 	int err2;
+	int lock_depth;
 
-	reiserfs_write_lock(inode->i_sb);
+	lock_depth = reiserfs_write_lock_once(inode->i_sb);
 
 	if (inode->i_size > 0) {
 		error = grab_tail_page(inode, &page, &bh);
@@ -2153,14 +2154,17 @@ int reiserfs_truncate_file(struct inode *inode, int update_timestamps)
 		page_cache_release(page);
 	}
 
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
+
 	return 0;
       out:
 	if (page) {
 		unlock_page(page);
 		page_cache_release(page);
 	}
-	reiserfs_write_unlock(inode->i_sb);
+
+	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
+
 	return error;
 }
 
-- 
1.6.1

