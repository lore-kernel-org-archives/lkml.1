Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbXJDJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbXJDJYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759537AbXJDJR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759524AbXJDJRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:54 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/51] [GFS2] Fix quota do_list operation hang
Date: Thu,  4 Oct 2007 09:49:14 +0100
Message-Id: <11914878283252-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878271468-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This is the filesystem part of the patches to fix this bz. There are
additional userland patches (gfs2_quota, libgfs2) for the complete
solution. This patch adds a new field qu_ll_next to the gfs2_quota
structure. This field allows us to create linked lists of quotas in the
ondisk quota inode. Instead of scanning through the entire sparse quota
file for valid quotas, we can now simply walk through the user and group
quota linked lists to perform the do_list operation.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 5dfa465..addb51e 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -70,6 +70,7 @@ struct gfs2_quota_host {
 	u64 qu_limit;
 	u64 qu_warn;
 	s64 qu_value;
+	u32 qu_ll_next;
 };
 
 struct gfs2_quota_change_host {
@@ -580,6 +581,7 @@ static void gfs2_quota_in(struct gfs2_quota_host *qu, const void *buf)
 	qu->qu_limit = be64_to_cpu(str->qu_limit);
 	qu->qu_warn = be64_to_cpu(str->qu_warn);
 	qu->qu_value = be64_to_cpu(str->qu_value);
+	qu->qu_ll_next = be32_to_cpu(str->qu_ll_next);
 }
 
 static void gfs2_quota_out(const struct gfs2_quota_host *qu, void *buf)
@@ -589,6 +591,7 @@ static void gfs2_quota_out(const struct gfs2_quota_host *qu, void *buf)
 	str->qu_limit = cpu_to_be64(qu->qu_limit);
 	str->qu_warn = cpu_to_be64(qu->qu_warn);
 	str->qu_value = cpu_to_be64(qu->qu_value);
+	str->qu_ll_next = cpu_to_be32(qu->qu_ll_next);
 	memset(&str->qu_reserved, 0, sizeof(str->qu_reserved));
 }
 
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index a44a6a0..c3c19f9 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -170,6 +170,33 @@ struct gfs2_rgrp {
 };
 
 /*
+ * quota linked list: user quotas and group quotas form two separate 
+ * singly linked lists. ll_next stores uids or gids of next quotas in the 
+ * linked list.
+
+Given the uid/gid, how to calculate the quota file offsets for the corresponding
+gfs2_quota structures on disk:
+
+for user quotas, given uid,
+offset = uid * sizeof(struct gfs2_quota);
+
+for group quotas, given gid,
+offset = (gid * sizeof(struct gfs2_quota)) + sizeof(struct gfs2_quota);
+
+
+  uid:0   gid:0       uid:12   gid:12      uid:17   gid:17     uid:5142 gid:5142
++-------+-------+    +-------+-------+    +-------+- - - -+    +- - - -+-------+
+| valid | valid | :: | valid | valid | :: | valid | inval | :: | inval | valid |
++-------+-------+    +-------+-------+    +-------+- - - -+    +- - - -+-------+
+next:12   next:12    next:17 next:5142    next:NULL                    next:NULL
+    |       |            |       |            |<-- user quota list         |
+     \______|___________/ \______|___________/         group quota list -->|
+            |                    |                                         |
+             \__________________/ \_______________________________________/
+
+*/
+
+/*
  * quota structure
  */
 
@@ -177,7 +204,8 @@ struct gfs2_quota {
 	__be64 qu_limit;
 	__be64 qu_warn;
 	__be64 qu_value;
-	__u8 qu_reserved[64];
+	__be32 qu_ll_next; /* location of next quota in list */
+	__u8 qu_reserved[60];
 };
 
 /*
-- 
1.5.1.2

