Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYGKLDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYGKLDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYGKLBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbYGKLBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:38 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/18] [GFS2] kernel panic mounting volume
Date: Fri, 11 Jul 2008 11:11:08 +0100
Message-Id: <12157710983282-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157710973601-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes Red Hat bugzilla bug 450156.

This started with a not-too-improbable mount failure because the
locking protocol was never set back to its proper "lock_dlm" after the
system was rebooted in the middle of a gfs2_fsck.  That left a
(purposely) invalid locking protocol in the superblock, which caused an
error when the file system was mounted the next time.

When there's an error mounting, vfs calls DQUOT_OFF, which calls
vfs_quota_off which calls gfs2_sync_fs.  Next, gfs2_sync_fs calls
gfs2_log_flush passing s_fs_info.  But due to the error, s_fs_info
had been previously set to NULL, and so we have the kernel oops.

My solution in this patch is to test for the NULL value before passing
it.  I tested this patch and it fixes the problem.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 0b7cc92..6690792 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -155,7 +155,7 @@ static void gfs2_write_super(struct super_block *sb)
 static int gfs2_sync_fs(struct super_block *sb, int wait)
 {
 	sb->s_dirt = 0;
-	if (wait)
+	if (wait && sb->s_fs_info)
 		gfs2_log_flush(sb->s_fs_info, NULL);
 	return 0;
 }
-- 
1.5.1.2

