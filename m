Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZCRN3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZCRN3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZCRN0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbZCRN0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:45 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/18] GFS2: Fix error path ref counting for root inode
Date: Wed, 18 Mar 2009 12:23:42 +0000
Message-Id: <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We were keeping hold of an extra ref to the root inode in one
of the error paths, that resulted in a hang.

Reported-by: Nate Straz <nstraz@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-by: Robert Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 95bb33e..e502b37 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1258,6 +1258,8 @@ fail_sb:
 		dput(sdp->sd_root_dir);
 	if (sdp->sd_master_dir)
 		dput(sdp->sd_master_dir);
+	if (sb->s_root)
+		dput(sb->s_root);
 	sb->s_root = NULL;
 fail_locking:
 	init_locking(sdp, &mount_gh, UNDO);
-- 
1.6.0.3

