Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYIZM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYIZM5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYIZMyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57609 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbYIZMya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:30 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Julien Brunel <brunel@diku.dk>, Julia Lawall <julia@diku.dk>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/12] GFS2: Use an IS_ERR test rather than a NULL test
Date: Fri, 26 Sep 2008 13:00:49 +0100
Message-Id: <1222430455-4632-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>

In case of error, the function gfs2_inode_lookup returns an
ERR pointer, but never returns a NULL pointer. So a NULL test that
necessarily comes after an IS_ERR test should be deleted, and a NULL
test that may come after a call to this function should be
strengthened by an IS_ERR test.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = gfs2_inode_lookup(...)
... when != x = E
* if (x != NULL)
S1 else S2
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8752552..c8a959c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1033,13 +1033,11 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 
 	if (bh)
 		brelse(bh);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
 	return inode;
 
 fail_gunlock2:
 	gfs2_glock_dq_uninit(ghs + 1);
-	if (inode)
+	if (inode && !IS_ERR(inode))
 		iput(inode);
 fail_gunlock:
 	gfs2_glock_dq(ghs);
-- 
1.5.5.1

