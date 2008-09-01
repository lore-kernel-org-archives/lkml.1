Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYIAI4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYIAI4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbYIAIz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:55:59 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39116 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYIAIz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:55:58 -0400
From: Julien Brunel <brunel@diku.dk>
To: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/reiserfs: Use an IS_ERR test rather than a NULL test
Date: Mon, 1 Sep 2008 10:55:47 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011055.48175.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>

In case of error, the function open_xa_dir returns an ERR pointer,
but never returns a NULL pointer. So a NULL test that comes after an
IS_ERR test should be deleted.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = open_xa_dir(...)
... when != x = E
(
*  if (x == NULL && ...) S1 else S2
|
*  if (x == NULL || ...) S1 else S2
)
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 fs/reiserfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -155,7 +155,7 @@ static struct dentry *get_xa_file_dentry
 	xadir = open_xa_dir(inode, flags);
 	if (IS_ERR(xadir)) {
 		return ERR_CAST(xadir);
-	} else if (xadir && !xadir->d_inode) {
+	} else if (!xadir->d_inode) {
 		dput(xadir);
 		return ERR_PTR(-ENODATA);
 	}
