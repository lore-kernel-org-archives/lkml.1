Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbXJDJWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbXJDJWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbXJDJRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759468AbXJDJRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:42 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/51] [GFS2] Ensure journal file cache is flushed after recovery
Date: Thu,  4 Oct 2007 09:49:08 +0100
Message-Id: <11914878173677-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1191487815172-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is for bugzilla bug #248176: GFS2: invalid metadata block

Patches 1 thru 3 were accepted upstream, but there were problems
with 4 and 5.  Those issues have been resolved and now the recovery
tests are passing without errors.  This code has gone through
41 * 3 successful gfs2 recovery tests before it hit an
unrelated (openais) problem.  I'm continuing to test it.

This is a complete rewrite of patch 5 for bug #248176, written by
Steve Whitehouse.  This is referred to in the bugzilla record as
"new 6" and "a different solution".

The problem was that the journal inodes, although protected by
a glock, were not synched with the other nodes because they don't
use the inode glock synch operations (i.e. no "glops" were defined).
Therefore, journal recovery on a journal-recovering node were causing
the blocks to get out of sync with the node that was actually trying
to use that journal as it comes back up from a reboot.

There are two possible solutions: (1) To make the journals use the
normal inode glock sync operations, or (2) To make the journal
operations take effect immediately (i.e. no caching).  Although
option 1 works, it turns out to be a lot more code.  Steve opted
for option 2, which is much simpler and therefore less prone to
regression errors.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

--

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 58c730b..f0bcaa2 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -358,7 +358,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 
 		ip = GFS2_I(sdp->sd_jdesc->jd_inode);
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED,
-					   LM_FLAG_NOEXP | GL_EXACT,
+					   LM_FLAG_NOEXP | GL_EXACT | GL_NOCACHE,
 					   &sdp->sd_jinode_gh);
 		if (error) {
 			fs_err(sdp, "can't acquire journal inode glock: %d\n",
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 5ada38c..beb6c7a 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -469,7 +469,7 @@ int gfs2_recover_journal(struct gfs2_jdesc *jd)
 		};
 
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED,
-					   LM_FLAG_NOEXP, &ji_gh);
+					   LM_FLAG_NOEXP | GL_NOCACHE, &ji_gh);
 		if (error)
 			goto fail_gunlock_j;
 	} else {
-- 
1.5.1.2

