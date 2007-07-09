Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbXGIQkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbXGIQkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbXGIQYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758271AbXGIQYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:45 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] remounting w/o acl option leaves acls enabled
Date: Mon,  9 Jul 2007 17:02:56 +0100
Message-Id: <1183997089710-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970871671-git-send-email-swhiteho@redhat.com>
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
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
 <11839970711372-git-send-email-swhiteho@redhat.com>
 <1183997073435-git-send-email-swhiteho@redhat.com>
 <11839970752058-git-send-email-swhiteho@redhat.com>
 <11839970773694-git-send-email-swhiteho@redhat.com>
 <11839970793713-git-send-email-swhiteho@redhat.com>
 <11839970813260-git-send-email-swhiteho@redhat.com>
 <11839970832750-git-send-email-swhiteho@redhat.com>
 <11839970852076-git-send-email-swhiteho@redhat.com>
 <11839970871671-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch is for bugzilla bug #245663.  This crosswrites a fix from
gfs1 (bz #210369) so that the mount options are reset properly upon
remount.  This was tested on system trin-10.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index 4864659..6f006a8 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -82,20 +82,19 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 	char *options, *o, *v;
 	int error = 0;
 
-	if (!remount) {
-		/*  If someone preloaded options, use those instead  */
-		spin_lock(&gfs2_sys_margs_lock);
-		if (gfs2_sys_margs) {
-			data = gfs2_sys_margs;
-			gfs2_sys_margs = NULL;
-		}
-		spin_unlock(&gfs2_sys_margs_lock);
-
-		/*  Set some defaults  */
-		args->ar_num_glockd = GFS2_GLOCKD_DEFAULT;
-		args->ar_quota = GFS2_QUOTA_DEFAULT;
-		args->ar_data = GFS2_DATA_DEFAULT;
+	/*  If someone preloaded options, use those instead  */
+	spin_lock(&gfs2_sys_margs_lock);
+	if (!remount && gfs2_sys_margs) {
+		data = gfs2_sys_margs;
+		gfs2_sys_margs = NULL;
 	}
+	spin_unlock(&gfs2_sys_margs_lock);
+
+	/*  Set some defaults  */
+	memset(args, 0, sizeof(struct gfs2_args));
+	args->ar_num_glockd = GFS2_GLOCKD_DEFAULT;
+	args->ar_quota = GFS2_QUOTA_DEFAULT;
+	args->ar_data = GFS2_DATA_DEFAULT;
 
 	/* Split the options into tokens with the "," character and
 	   process them */
-- 
1.5.1.2

