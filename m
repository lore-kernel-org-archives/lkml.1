Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbXJDJ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbXJDJ0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbXJDJSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbXJDJSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:00 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Wendy Cheng <wcheng@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 25/51] [GFS2] Reduce truncate IO traffic
Date: Thu,  4 Oct 2007 09:49:18 +0100
Message-Id: <11914878361239-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878342921-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wendy Cheng <wcheng@redhat.com>

Current GFS2 setattr call unconditionally invokes do_shrink even the
requested size and actual file size are equal. This has generated large
amount of extra IOs found during NFS benchmark runs. This patch moves
the relevant logic out of shrink code path. Since setattr is a system
call, the time stamps update is still required.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index cd805a6..9b89904 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1085,6 +1085,33 @@ static int do_shrink(struct gfs2_inode *ip, u64 size)
 	return error;
 }
 
+static int do_touch(struct gfs2_inode *ip, u64 size)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct buffer_head *dibh;
+	int error;
+
+	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
+	if (error)
+		return error;
+
+	down_write(&ip->i_rw_mutex);
+
+	error = gfs2_meta_inode_buffer(ip, &dibh);
+	if (error)
+		goto do_touch_out;
+
+	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
+	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_dinode_out(ip, dibh->b_data);
+	brelse(dibh);
+
+do_touch_out:
+	up_write(&ip->i_rw_mutex);
+	gfs2_trans_end(sdp);
+	return error;
+}
+
 /**
  * gfs2_truncatei - make a file a given size
  * @ip: the inode
@@ -1105,8 +1132,11 @@ int gfs2_truncatei(struct gfs2_inode *ip, u64 size)
 
 	if (size > ip->i_di.di_size)
 		error = do_grow(ip, size);
-	else
+	else if (size < ip->i_di.di_size)
 		error = do_shrink(ip, size);
+	else
+		/* update time stamps */
+		error = do_touch(ip, size);
 
 	return error;
 }
-- 
1.5.1.2

