Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbYEFRwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbYEFRwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763774AbYEFRvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:51:42 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:55768 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764947AbYEFRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VoSMB40gKLHrU+35gYqGacqJGauyrBayDxsAwVcFShppt2HwZ847KtA5gDf9bpCOaj0ac/wKBNPmqw+M1UVbx+bTB0/BdeUzPeJcTdk7CsA54fMv3OcjDV4h/gqEEoK13kZaEDCIPsFMh6Fd92m4nrv8+PEv7zrzCrg1rQ3RliY=
From: Denis Cheng <crquan@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [fs-devel] the real needs of just_schedule
Date: Wed,  7 May 2008 01:51:03 +0800
Message-Id: <1210096264-27426-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there are some situations which really need a just schedule,
with int return value;
and this should be moved into lib/ in the future.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/inode.c                |    2 +-
 include/linux/writeback.h |   16 ++++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index bf64781..b355a44 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1291,7 +1291,7 @@ int inode_needs_sync(struct inode *inode)
 
 EXPORT_SYMBOL(inode_needs_sync);
 
-int inode_wait(void *word)
+int just_schedule(void *word)
 {
 	schedule();
 	return 0;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f462439..80ff5eb 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -67,23 +67,31 @@ struct writeback_control {
 
 /*
  * fs/fs-writeback.c
- */	
+ */
 void writeback_inodes(struct writeback_control *wbc);
-int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
 
+/*
+ * fs/inode.c
+ *
+ * there are some situations which really need a just schedule,
+ * with int return value;
+ * and this should be moved into lib/ in the future.
+ */
+int just_schedule(void *);
+
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
 {
 	might_sleep();
-	wait_on_bit(&inode->i_state, __I_LOCK, inode_wait,
+	wait_on_bit(&inode->i_state, __I_LOCK, just_schedule,
 							TASK_UNINTERRUPTIBLE);
 }
 static inline void inode_sync_wait(struct inode *inode)
 {
 	might_sleep();
-	wait_on_bit(&inode->i_state, __I_SYNC, inode_wait,
+	wait_on_bit(&inode->i_state, __I_SYNC, just_schedule,
 							TASK_UNINTERRUPTIBLE);
 }
 
-- 
1.5.5.1

