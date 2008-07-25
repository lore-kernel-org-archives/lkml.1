Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYGYTds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYGYTds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYGYTda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:33:30 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50395 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYGYTd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:33:29 -0400
Date: Fri, 25 Jul 2008 21:33:25 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/suse/inode.c: Add missing fuse_request_alloc
Message-ID: <Pine.LNX.4.64.0807252131280.1602@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The error handling code for the second call to fuse_request_alloc should
include freeing the result of the first one.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
expression x,E;
statement S;
position p1,p2,p3;
@@

(
if ((x = fuse_request_alloc@p1(...)) == NULL || ...) S
|
x = fuse_request_alloc@p1(...)
... when != x
if (x == NULL || ...) S
)
<...
if@p3 (...) { ... when != fuse_request_free(x)
    return@p2 ...;
}
...>
(
return x;
|
return 0;
|
x = E
|
E = x
|
fuse_request_free(x)
)

@exists@
position r.p1,r.p2,r.p3;
expression x;
int ret != 0;
statement S;
@@

* x = fuse_request_alloc@p1(...)
  <...
* if@p3 (...)
  S
  ...>
* return@p2 \(NULL\|ret\);

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/fuse/inode.c               |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 3141690..ae1d4fd 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -690,7 +690,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	if (is_bdev) {
 		fc->destroy_req = fuse_request_alloc();
 		if (!fc->destroy_req)
-			goto err_put_root;
+			goto err_free_init_req;
 	}
 
 	mutex_lock(&fuse_mutex);
@@ -720,6 +720,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 
  err_unlock:
 	mutex_unlock(&fuse_mutex);
+ err_free_init_req:
 	fuse_request_free(init_req);
  err_put_root:
 	dput(root_dentry);
