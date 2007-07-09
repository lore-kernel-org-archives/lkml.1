Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbXGIQe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbXGIQe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbXGIQYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758224AbXGIQYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:09 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Fix bug in error path of inode
Date: Mon,  9 Jul 2007 17:02:39 +0100
Message-Id: <1183997056121-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970542719-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This fixes a bug in the ordering of operations in the error path of
createi. Its not valid to do an iput() when holding the inode's glock
since the iput() will (in this case) result in delete_inode() being
called which needs to grab the lock itself. This was causing the
recursive lock checking code to trigger.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3ef0f05..87505f7 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -857,7 +857,7 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip)
 struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 			   unsigned int mode, dev_t dev)
 {
-	struct inode *inode;
+	struct inode *inode = NULL;
 	struct gfs2_inode *dip = ghs->gh_gl->gl_object;
 	struct inode *dir = &dip->i_inode;
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
@@ -900,28 +900,28 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 
 	error = gfs2_inode_refresh(GFS2_I(inode));
 	if (error)
-		goto fail_iput;
+		goto fail_gunlock2;
 
 	error = gfs2_acl_create(dip, GFS2_I(inode));
 	if (error)
-		goto fail_iput;
+		goto fail_gunlock2;
 
 	error = gfs2_security_init(dip, GFS2_I(inode));
 	if (error)
-		goto fail_iput;
+		goto fail_gunlock2;
 
 	error = link_dinode(dip, name, GFS2_I(inode));
 	if (error)
-		goto fail_iput;
+		goto fail_gunlock2;
 
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	return inode;
 
-fail_iput:
-	iput(inode);
 fail_gunlock2:
 	gfs2_glock_dq_uninit(ghs + 1);
+	if (inode)
+		iput(inode);
 fail_gunlock:
 	gfs2_glock_dq(ghs);
 fail:
-- 
1.5.1.2

