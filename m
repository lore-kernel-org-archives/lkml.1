Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZFJJjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZFJJjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbZFJJiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40275 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZFJJiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:00 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/24] GFS2: Fix timestamps on write
Date: Wed, 10 Jun 2009 09:30:45 +0100
Message-Id: <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This patch copies the timestamps from the vfs inode into gfs2 and syncs
it to the disk inode during writes.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index a6dde17..e566421 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -781,10 +781,12 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 	unlock_page(page);
 	page_cache_release(page);
 
-	if (inode->i_size < to) {
-		i_size_write(inode, to);
-		ip->i_disksize = inode->i_size;
-		di->di_size = cpu_to_be64(inode->i_size);
+	if (copied) {
+		if (inode->i_size < to) {
+			i_size_write(inode, to);
+			ip->i_disksize = inode->i_size;
+		}
+		gfs2_dinode_out(ip, di);
 		mark_inode_dirty(inode);
 	}
 
@@ -824,7 +826,6 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct buffer_head *dibh;
 	struct gfs2_alloc *al = ip->i_alloc;
-	struct gfs2_dinode *di;
 	unsigned int from = pos & (PAGE_CACHE_SIZE - 1);
 	unsigned int to = from + len;
 	int ret;
@@ -847,11 +848,10 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 		gfs2_page_add_databufs(ip, page, from, to);
 
 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
-
-	if (likely(ret >= 0) && (inode->i_size > ip->i_disksize)) {
-		di = (struct gfs2_dinode *)dibh->b_data;
-		ip->i_disksize = inode->i_size;
-		di->di_size = cpu_to_be64(inode->i_size);
+	if (ret > 0) {
+		if (inode->i_size > ip->i_disksize)
+			ip->i_disksize = inode->i_size;
+		gfs2_dinode_out(ip, dibh->b_data);
 		mark_inode_dirty(inode);
 	}
 
-- 
1.6.0.6

