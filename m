Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbZJNJ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbZJNJ7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbZJNJ7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:59:16 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:19373 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbZJNJ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:59:15 -0400
From: Joel Becker <joel.becker@ORACLE.COM>
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, torvalds@linux-foundation.org
Subject: [PATCH 2/2] ocfs2: Use MAY_CREATE in ocfs2_permission()
Date: Wed, 14 Oct 2009 02:57:41 -0700
Message-Id: <1255514261-25823-3-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1255514261-25823-1-git-send-email-joel.becker@oracle.com>
References: <1255514261-25823-1-git-send-email-joel.becker@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AD5A09C.00F3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2 has a problem with open(O_CREAT|O_EXCL).  Once you've created the
file, you can't restart the open(), because O_CREAT|O_EXCL will trigger
-EEXIST.

The problem is that ocfs2 is catching the signal ->permission(), called
by may_open().  This happens after ->create() has successfully created
the file.  ocfs2_permission() has to get a cluster lock, and this is
what can be interrupted by a signal.  Now, obviously we want to block
signals in the O_CREAT|O_EXCL case, but ocfs2_permission() has no way of
knowing it just got called from open_namei_create().

We key on the MAY_CREATE flag passed to permission to block signals.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/file.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 89fc8ee..b8749fa 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1141,9 +1141,18 @@ bail:
 int ocfs2_permission(struct inode *inode, int mask)
 {
 	int ret;
+	sigset_t oldset;
 
 	mlog_entry_void();
 
+	/*
+	 * If this inode was just created by open(O_CREAT|O_EXCL), we
+	 * can't allow signal restarting.  So we need to block signals
+	 * around the cluster locking.
+	 */
+	if (mask & MAY_CREATE)
+		ocfs2_block_signals(&oldset);
+
 	ret = ocfs2_inode_lock(inode, NULL, 0);
 	if (ret) {
 		if (ret != -ENOENT)
@@ -1154,7 +1163,11 @@ int ocfs2_permission(struct inode *inode, int mask)
 	ret = generic_permission(inode, mask, ocfs2_check_acl);
 
 	ocfs2_inode_unlock(inode, 0);
+
 out:
+	if (mask & MAY_CREATE)
+		ocfs2_unblock_signals(&oldset);
+
 	mlog_exit(ret);
 	return ret;
 }
-- 
1.6.3.3

