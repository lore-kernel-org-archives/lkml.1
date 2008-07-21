Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbYGUH7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbYGUH7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYGUH7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:59:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35444 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323AbYGUH7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:59:17 -0400
Date: Mon, 21 Jul 2008 09:59:15 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/7] fs/ocfs2/file.c: Release mutex in error handling code
Message-ID: <Pine.LNX.4.64.0807210958570.24625@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/fs/ocfs2/file.c b/fs/ocfs2/file.c
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1766,8 +1766,8 @@ out_inode_unlock:
 out_rw_unlock:
 	ocfs2_rw_unlock(inode, 1);
 
-	mutex_unlock(&inode->i_mutex);
 out:
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 
