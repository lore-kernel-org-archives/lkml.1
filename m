Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYILOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYILOXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYILOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:23:28 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51460 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbYILOX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:23:27 -0400
From: Julien Brunel <brunel@diku.dk>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/9p: Use an IS_ERR test rather than a NULL test
Date: Fri, 12 Sep 2008 16:23:22 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121623.22644.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>

In case of error, the function p9_client_walk returns an ERR pointer,
but never returns a NULL pointer. So a NULL test that comes after an
IS_ERR test should be deleted.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = p9_client_walk(...)
... when != x = E
*  if (x != NULL) 
S1 else S2
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 fs/9p/vfs_inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -626,8 +626,7 @@ static struct dentry *v9fs_vfs_lookup(st
 	return NULL;
 
 error:
-	if (fid)
-		p9_client_clunk(fid);
+	p9_client_clunk(fid);
 
 	return ERR_PTR(result);
 }
