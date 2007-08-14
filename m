Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbXHNKTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbXHNKTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbXHNKLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:11:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196AbXHNKK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:58 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH] [GFS2] Revert remounting w/o acl option leaves acls enabled
Date: Tue, 14 Aug 2007 10:47:16 +0100
Message-Id: <11870848623828-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This reverts commit 569a7b6c2e8965ff4908003b925757703a3d649c. The
code was correct originally. The default setting for ACLs after a
remount should be to be the same as before the remount.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index 6f006a8..4864659 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -82,19 +82,20 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 	char *options, *o, *v;
 	int error = 0;
 
-	/*  If someone preloaded options, use those instead  */
-	spin_lock(&gfs2_sys_margs_lock);
-	if (!remount && gfs2_sys_margs) {
-		data = gfs2_sys_margs;
-		gfs2_sys_margs = NULL;
-	}
-	spin_unlock(&gfs2_sys_margs_lock);
+	if (!remount) {
+		/*  If someone preloaded options, use those instead  */
+		spin_lock(&gfs2_sys_margs_lock);
+		if (gfs2_sys_margs) {
+			data = gfs2_sys_margs;
+			gfs2_sys_margs = NULL;
+		}
+		spin_unlock(&gfs2_sys_margs_lock);
 
-	/*  Set some defaults  */
-	memset(args, 0, sizeof(struct gfs2_args));
-	args->ar_num_glockd = GFS2_GLOCKD_DEFAULT;
-	args->ar_quota = GFS2_QUOTA_DEFAULT;
-	args->ar_data = GFS2_DATA_DEFAULT;
+		/*  Set some defaults  */
+		args->ar_num_glockd = GFS2_GLOCKD_DEFAULT;
+		args->ar_quota = GFS2_QUOTA_DEFAULT;
+		args->ar_data = GFS2_DATA_DEFAULT;
+	}
 
 	/* Split the options into tokens with the "," character and
 	   process them */
-- 
1.5.1.2

