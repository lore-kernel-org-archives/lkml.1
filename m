Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbXGIQbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbXGIQbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXGIQX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbXGIQXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:54 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Make the log reserved blocks depend on block size
Date: Mon,  9 Jul 2007 17:02:31 +0100
Message-Id: <11839970403929-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970383020-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The number of blocks which we reserve in the log at the start of each
transaction needs to depends upon the block size since the overhead is
related to the number of "pointers" which can be fitted into a single
block.

This relates to Red Hat bz #240435

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 291415d..586923d 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -262,7 +262,7 @@ static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
  * @sdp: The GFS2 superblock
  * @blks: The number of blocks to reserve
  *
- * Note that we never give out the last 6 blocks of the journal. Thats
+ * Note that we never give out the last few blocks of the journal. Thats
  * due to the fact that there is are a small number of header blocks
  * associated with each log flush. The exact number can't be known until
  * flush time, so we ensure that we have just enough free blocks at all
@@ -274,6 +274,7 @@ static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
 int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks)
 {
 	unsigned int try = 0;
+	unsigned reserved_blks = 6 * (4096 / sdp->sd_vfs->s_blocksize);
 
 	if (gfs2_assert_warn(sdp, blks) ||
 	    gfs2_assert_warn(sdp, blks <= sdp->sd_jdesc->jd_blocks))
@@ -281,7 +282,7 @@ int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks)
 
 	mutex_lock(&sdp->sd_log_reserve_mutex);
 	gfs2_log_lock(sdp);
-	while(sdp->sd_log_blks_free <= (blks + 6)) {
+	while(sdp->sd_log_blks_free <= (blks + reserved_blks)) {
 		gfs2_log_unlock(sdp);
 		gfs2_ail1_empty(sdp, 0);
 		gfs2_log_flush(sdp, NULL);
-- 
1.5.1.2

