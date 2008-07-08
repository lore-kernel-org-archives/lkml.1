Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYGHShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYGHShq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYGHShh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:37:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:47751 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbYGHShg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:37:36 -0400
Message-ID: <4873B3D2.1090101@suse.com>
Date: Tue, 08 Jul 2008 14:37:06 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: [PATCH] reiserfs: discard prealloc in reiserfs_delete_inode
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 With the removal of struct file from the xattr code, reiserfs_file_release()
 isn't used anymore, so the prealloc isn't discarded. This causes hangs
 later down the line.

 This patch adds it to reiserfs_delete_inode. In most cases it will be
 a no-op due to it already having been called, but will avoid hangs with xattrs.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -45,6 +45,8 @@ void reiserfs_delete_inode(struct inode
 			goto out;
 		reiserfs_update_inode_transaction(inode);
 
+		reiserfs_discard_prealloc(&th, inode);
+
 		err = reiserfs_delete_object(&th, inode);
 
 		/* Do quota update inside a transaction for journaled quotas. We must do that

-- 
Jeff Mahoney
SUSE Labs
