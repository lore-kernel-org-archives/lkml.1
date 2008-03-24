Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbYCXSJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbYCXSJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbYCXSJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:09:21 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:47030 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbYCXSJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:09:20 -0400
Date: Mon, 24 Mar 2008 19:09:15 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] fs/ocfs2/aops.c: test for IS_ERR rather than 0
Message-ID: <Pine.LNX.4.64.0803241908490.32740@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function ocfs2_start_trans always returns either a valid pointer or a
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

E = ocfs2_start_trans(...)
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
 fs/ocfs2/aops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c	2008-03-24 17:50:26.000000000 +0100
+++ b/fs/ocfs2/aops.c	2008-03-24 17:52:02.000000000 +0100
@@ -467,11 +467,11 @@ handle_t *ocfs2_start_walk_page_trans(st
 							 unsigned to)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	handle_t *handle = NULL;
+	handle_t *handle;
 	int ret = 0;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (!handle) {
+	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -487,7 +487,7 @@ handle_t *ocfs2_start_walk_page_trans(st
 	}
 out:
 	if (ret) {
-		if (handle)
+		if (!IS_ERR(handle))
 			ocfs2_commit_trans(osb, handle);
 		handle = ERR_PTR(ret);
 	}
