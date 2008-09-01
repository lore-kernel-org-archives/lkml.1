Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYIAIvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYIAIvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYIAIva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:51:30 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39012 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbYIAIv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:51:29 -0400
From: Julien Brunel <brunel@diku.dk>
To: swhiteho@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/gfs2: Use an IS_ERR test rather than a NULL test
Date: Mon, 1 Sep 2008 10:51:22 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011051.22862.brunel@diku.dk>
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

---
 fs/gfs2/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -u -p a/fs/gfs2/inode.c b/fs/gfs2/inode.c
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1033,13 +1033,11 @@ struct inode *gfs2_createi(struct gfs2_h
 
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
