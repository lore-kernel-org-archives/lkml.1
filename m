Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbXJDJ2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbXJDJ2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbXJDJSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbXJDJSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:08 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 29/51] [GFS2] panic after can't parse mount arguments
Date: Thu,  4 Oct 2007 09:49:22 +0100
Message-Id: <1191487844772-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878422398-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

When you try to mount gfs2 with -o garbage, the mount fails and the gfs2
superblock is deallocated and becomes NULL. The vfs comes around later
on and calls gfs2_kill_sb. At this point the hidden gfs2 superblock
pointer (sb->s_fs_info) is NULL and dereferencing it through
gfs2_meta_syncfs causes the panic. (the other function call to
gfs2_delete_debugfs_file() succeeds because this function already checks
for a NULL pointer)

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 9e0e9be..314c113 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -887,8 +887,10 @@ error:
 
 static void gfs2_kill_sb(struct super_block *sb)
 {
-	gfs2_delete_debugfs_file(sb->s_fs_info);
-	gfs2_meta_syncfs(sb->s_fs_info);
+	if (sb->s_fs_info) {
+		gfs2_delete_debugfs_file(sb->s_fs_info);
+		gfs2_meta_syncfs(sb->s_fs_info);
+	}
 	kill_block_super(sb);
 }
 
-- 
1.5.1.2

