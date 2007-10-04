Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbXJDJ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbXJDJ1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbXJDJSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbXJDJSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:04 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steve French <smfrench@gmail.com>, Steve French <sfrench@us.ibm.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/51] [GFS2] GFS2 not checking pointer on create when running under nfsd
Date: Thu,  4 Oct 2007 09:48:57 +0100
Message-Id: <11914877971413-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914877952291-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve French <smfrench@gmail.com>

When looking at an unrelated problem, I noticed that nfsd does not
set nameidata pointer on create (ie nd is NULL).  This should
cause an oops in some cases in which when NFSd is mounted over GFS2.

Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 911c115..5b8b994 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -69,7 +69,7 @@ static int gfs2_create(struct inode *dir, struct dentry *dentry,
 			mark_inode_dirty(inode);
 			break;
 		} else if (PTR_ERR(inode) != -EEXIST ||
-			   (nd->intent.open.flags & O_EXCL)) {
+			   (nd && (nd->intent.open.flags & O_EXCL))) {
 			gfs2_holder_uninit(ghs);
 			return PTR_ERR(inode);
 		}
-- 
1.5.1.2

