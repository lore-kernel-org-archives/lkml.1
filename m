Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbXGIQc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbXGIQc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbXGIQYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbXGIQYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:00 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] fix jdata issues
Date: Mon,  9 Jul 2007 17:02:33 +0100
Message-Id: <11839970442448-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970421091-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

This is a patch for the first three issues of RHBZ #238162

The first issue is that when you allocate a new page for a file, it will not
start off uptodate. This makes sense, since you haven't written anything to that
part of the file yet.  Unfortunately, gfs2_pin() checks to make sure that the
buffers are uptodate.  The solution to this is to mark the buffers uptodate in
gfs2_commit_write(), after they have been zeroed out and have the data written
into them.  I'm pretty confident with this fix, although it's not completely
obvious that there is no problem with marking the buffers uptodate here.

The second issue is simply that you can try to pin a data buffer that is already
on the incore log, and thus, already pinned. This patch checks to see if this
buffer is already on the log, and exits databuf_lo_add() if it is, just like
buf_lo_add() does.

The third issue is that gfs2_log_flush() doesn't do it's block accounting
correctly.  Both metadata and journaled data are logged, but gfs2_log_flush()
only compares the number of metadata blocks with the number of blocks to commit
to the ondisk journal.  This patch also counts the journaled data blocks.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 586923d..1fb846f 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -566,7 +566,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	INIT_LIST_HEAD(&ai->ai_ail1_list);
 	INIT_LIST_HEAD(&ai->ai_ail2_list);
 
-	gfs2_assert_withdraw(sdp, sdp->sd_log_num_buf == sdp->sd_log_commited_buf);
+	gfs2_assert_withdraw(sdp, sdp->sd_log_num_buf + sdp->sd_log_num_jdata == sdp->sd_log_commited_buf);
 	gfs2_assert_withdraw(sdp,
 			sdp->sd_log_num_revoke == sdp->sd_log_commited_revoke);
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index f82d84d..3e971f2 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -475,6 +475,8 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 		tr->tr_num_buf++;
 		list_add(&bd->bd_list_tr, &tr->tr_list_buf);
 		gfs2_log_unlock(sdp);
+		if (!list_empty(&le->le_list))
+			return;
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_buf_new++;
 	} else {
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index fb84478..ac56595 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -50,6 +50,8 @@ static void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
 		end = start + bsize;
 		if (end <= from || start >= to)
 			continue;
+		if (gfs2_is_jdata(ip))
+			set_buffer_uptodate(bh);
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 	}
 }
-- 
1.5.1.2

