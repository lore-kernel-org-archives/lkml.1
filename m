Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYIZM6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYIZM6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYIZMyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbYIZMyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:32 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/12] GFS2: Support for I/O barriers
Date: Fri, 26 Sep 2008 13:00:55 +0100
Message-Id: <1222430455-4632-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-12-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-7-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-8-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-9-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-10-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-11-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-12-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds barrier support to GFS2. There is not a lot of change
really... we just add the barrier flag when we write journal header
blocks. If the underlying device refuses to support them, we fall back
to the previous way of doing things (wait for the I/O and hope) since
there is nothing else we can do. There is no user configuration,
barriers will always be on unless the device refuses to support them.
This seems a reasonable solution to me since this is a correctness
issue.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index f1ed3a1..f566ec1 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -432,6 +432,7 @@ enum {
 	SDF_JOURNAL_CHECKED	= 0,
 	SDF_JOURNAL_LIVE	= 1,
 	SDF_SHUTDOWN		= 2,
+	SDF_NOBARRIERS		= 3,
 };
 
 #define GFS2_FSNAME_LEN		256
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 6c6af9f..ad30585 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/bio.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -584,7 +585,6 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	memset(bh->b_data, 0, bh->b_size);
 	set_buffer_uptodate(bh);
 	clear_buffer_dirty(bh);
-	unlock_buffer(bh);
 
 	gfs2_ail1_empty(sdp, 0);
 	tail = current_tail(sdp);
@@ -601,8 +601,23 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	hash = gfs2_disk_hash(bh->b_data, sizeof(struct gfs2_log_header));
 	lh->lh_hash = cpu_to_be32(hash);
 
-	set_buffer_dirty(bh);
-	if (sync_dirty_buffer(bh))
+	bh->b_end_io = end_buffer_write_sync;
+	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
+		goto skip_barrier;
+	get_bh(bh);
+	submit_bh(WRITE_BARRIER | (1 << BIO_RW_META), bh);
+	wait_on_buffer(bh);
+	if (buffer_eopnotsupp(bh)) {
+		clear_buffer_eopnotsupp(bh);
+		set_buffer_uptodate(bh);
+		set_bit(SDF_NOBARRIERS, &sdp->sd_flags);
+		lock_buffer(bh);
+skip_barrier:
+		get_bh(bh);
+		submit_bh(WRITE_SYNC | (1 << BIO_RW_META), bh);
+		wait_on_buffer(bh);
+	}
+	if (!buffer_uptodate(bh))
 		gfs2_io_error_bh(sdp, bh);
 	brelse(bh);
 
-- 
1.5.5.1

