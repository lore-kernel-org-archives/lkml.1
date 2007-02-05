Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbXBEOBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbXBEOBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbXBEOBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:01:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932594AbXBEOBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:01:44 -0500
Subject: [GFS2] don't try to lockfs after shutdown [1/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:09:45 +0000
Message-Id: <1170684585.11001.270.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From d951e07bc1d2d3e43af5325d4cad19b41ae4d427 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 6 Dec 2006 11:46:33 -0600
Subject: [PATCH] [GFS2] don't try to lockfs after shutdown

If an fs has already been shut down, a lockfs callback should do nothing.
An fs that's been shut down can't acquire locks or do anything with
respect to the cluster.

Also, remove FIXME comment in withdraw function.  The missing bits of the
withdraw procedure are now all done by user space.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lm.c b/fs/gfs2/lm.c
index effe4a3..e30673d 100644
--- a/fs/gfs2/lm.c
+++ b/fs/gfs2/lm.c
@@ -104,15 +104,9 @@ int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
 	vprintk(fmt, args);
 	va_end(args);
 
-	fs_err(sdp, "about to withdraw from the cluster\n");
+	fs_err(sdp, "about to withdraw this file system\n");
 	BUG_ON(sdp->sd_args.ar_debug);
 
-
-	fs_err(sdp, "waiting for outstanding I/O\n");
-
-	/* FIXME: suspend dm device so oustanding bio's complete
-	   and all further io requests fail */
-
 	fs_err(sdp, "telling LM to withdraw\n");
 	gfs2_withdraw_lockproto(&sdp->sd_lockstruct);
 	fs_err(sdp, "withdrawn\n");
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 7685b46..b283783 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -173,6 +173,9 @@ static void gfs2_write_super_lockfs(struct super_block *sb)
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
 
+	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
+		return;
+
 	for (;;) {
 		error = gfs2_freeze_fs(sdp);
 		if (!error)
-- 
1.4.4.2



