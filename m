Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYAFQvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYAFQvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbYAFQul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:50:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:37316 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236AbYAFQuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:50:39 -0500
Date: Sun, 6 Jan 2008 17:50:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/jffs2: Add missing call to posix_acl_release
Message-ID: <Pine.LNX.4.64.0801061749490.24950@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

posix_acl_clone does a memory allocation and sets a reference count, so
posix_acl_release is needed afterwards to free it.


The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier E;
expression E1, E2;
int ret;
statement S;
@@

  T E;
  <+...
(
  E = \(posix_acl_clone\|posix_acl_alloc\|posix_acl_dup\)(...);
  if (E == NULL) S
|
  if ((E = \(posix_acl_clone\|posix_acl_alloc\|posix_acl_dup\)(...)) == NULL) S
)
  ... when != E2 = E
      when strict
(
  posix_acl_release(E);
|
  E1 = E;
|
+ posix_acl_release(E);
  return;
|
+ posix_acl_release(E);
  return ret;
)
  ...+>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/fs/jffs2/acl.c b/fs/jffs2/acl.c
--- a/fs/jffs2/acl.c 2008-01-03 09:49:31.000000000 +0100
+++ b/fs/jffs2/acl.c 2008-01-06 17:38:52.000000000 +0100
@@ -345,8 +345,10 @@ int jffs2_init_acl_pre(struct inode *dir
 		if (!clone)
 			return -ENOMEM;
 		rc = posix_acl_create_masq(clone, (mode_t *)i_mode);
-		if (rc < 0)
+		if (rc < 0) {
+			posix_acl_release(clone);
 			return rc;
+		}
 		if (rc > 0)
 			jffs2_iset_acl(inode, &f->i_acl_access, clone);
 
