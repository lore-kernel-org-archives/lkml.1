Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbYCXSJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbYCXSJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbYCXSI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:08:56 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:47003 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbYCXSIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:08:54 -0400
Date: Mon, 24 Mar 2008 19:08:48 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: swhiteho@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] fs/gfs2: test for IS_ERR rather than 0
Message-ID: <Pine.LNX.4.64.0803241908210.32740@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function gfs2_inode_lookup always returns either a valid pointer or a
value made with ERR_PTR, so its result should be tested with IS_ERR, not
with a test for 0.


The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@a@
expression E, E1;
statement S,S1;
position p;
@@

E = gfs2_inode_lookup(...)
... when != E = E1
if@p (E) S else S1

@n@
position a.p;
expression E,E1;
statement S,S1;
@@

E = NULL
... when != E = E1
if@p (E) S else S1

@depends on !n@
expression E;
statement S,S1;
position a.p;
@@

* if@p (E)
  S else S1
//</smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 fs/gfs2/ops_export.c |    2 --
 1 file changed, 2 deletions(-)

diff -u -p a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
--- a/fs/gfs2/ops_export.c	2008-03-12 14:13:14.000000000 +0100
+++ b/fs/gfs2/ops_export.c	2008-03-24 16:04:41.000000000 +0100
@@ -204,8 +204,6 @@ static struct dentry *gfs2_get_dentry(st
 	inode = gfs2_inode_lookup(sb, DT_UNKNOWN,
 					inum->no_addr,
 					0, 0);
-	if (!inode)
-		goto fail;
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
 		goto fail;
