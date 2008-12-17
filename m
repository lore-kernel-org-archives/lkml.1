Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758240AbYLQMaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYLQMaa (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYLQM3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53731 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYLQM3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:10 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/24] GFS2: Move generation number into "proper" part of inode
Date: Wed, 17 Dec 2008 11:30:04 +0000
Message-Id: <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This moves the generation number from the gfs2_dinode_host
into the gfs2_inode structure. Eventually the plan is to get
rid of the gfs2_dinode_host structure completely.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index f566ec1..4ff1d7e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -235,7 +235,6 @@ enum {
 
 struct gfs2_dinode_host {
 	u64 di_size;		/* number of bytes in file */
-	u64 di_generation;	/* generation number for NFS */
 	u32 di_flags;		/* GFS2_DIF_... */
 	/* These only apply to directories  */
 	u32 di_entries;		/* The number of entries in the directory */
@@ -246,6 +245,7 @@ struct gfs2_inode {
 	struct inode i_inode;
 	u64 i_no_addr;
 	u64 i_no_formal_ino;
+	u64 i_generation;
 	unsigned long i_flags;		/* GIF_... */
 
 	struct gfs2_dinode_host i_di; /* To be replaced by ref to block */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9f1e415..081ffff 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -286,7 +286,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_inode.i_ctime.tv_nsec = be32_to_cpu(str->di_ctime_nsec);
 
 	ip->i_goal = be64_to_cpu(str->di_goal_meta);
-	di->di_generation = be64_to_cpu(str->di_generation);
+	ip->i_generation = be64_to_cpu(str->di_generation);
 
 	di->di_flags = be32_to_cpu(str->di_flags);
 	gfs2_set_inode_flags(&ip->i_inode);
@@ -1263,7 +1263,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 
 	str->di_goal_meta = cpu_to_be64(ip->i_goal);
 	str->di_goal_data = cpu_to_be64(ip->i_goal);
-	str->di_generation = cpu_to_be64(di->di_generation);
+	str->di_generation = cpu_to_be64(ip->i_generation);
 
 	str->di_flags = cpu_to_be32(di->di_flags);
 	str->di_height = cpu_to_be16(ip->i_height);
-- 
1.6.0.3

