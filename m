Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZKULxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZKULxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 06:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZKULxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 06:53:05 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42598 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbZKULxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 06:53:03 -0500
Date: Sat, 21 Nov 2009 12:53:08 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: sage@newdream.net, ceph-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/8] fs/ceph: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0911211252440.23681@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 fs/ceph/xattr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 1a48a55..04769a3 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -655,8 +655,10 @@ static int ceph_sync_setxattr(struct dentry *dentry, const char *name,
 	/* do request */
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_SETXATTR,
 				       USE_AUTH_MDS);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto out;
+	}
 	req->r_inode = igrab(inode);
 	req->r_inode_drop = CEPH_CAP_XATTR_SHARED;
 	req->r_num_caps = 1;
