Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbYHZIw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbYHZIw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYHZIwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:52:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:46722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbYHZIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:52:20 -0400
From: Tejun Heo <tj@kernel.org>
To: ericvh@gmail.com, rminnich@sandia.gov,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] 9p-trans_fd: don't do fs segment mangling in p9_fd_poll()
Date: Tue, 26 Aug 2008 17:50:54 +0900
Message-Id: <1219740656-26458-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219740656-26458-1-git-send-email-tj@kernel.org>
References: <1219740656-26458-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 Aug 2008 08:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p9_fd_poll() is never called with user pointers and f_op->poll()
doesn't expect its arguments to be from userland.  There's no need to
set kernel ds before calling f_op->poll() from p9_fd_poll().  Remove
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/9p/trans_fd.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 6c88e89..f6d4af1 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1344,7 +1344,6 @@ p9_fd_poll(struct p9_trans *trans, struct poll_table_struct *pt)
 {
 	int ret, n;
 	struct p9_trans_fd *ts = NULL;
-	mm_segment_t oldfs;
 
 	if (trans && trans->status == Connected)
 		ts = trans->priv;
@@ -1358,24 +1357,17 @@ p9_fd_poll(struct p9_trans *trans, struct poll_table_struct *pt)
 	if (!ts->wr->f_op || !ts->wr->f_op->poll)
 		return -EIO;
 
-	oldfs = get_fs();
-	set_fs(get_ds());
-
 	ret = ts->rd->f_op->poll(ts->rd, pt);
 	if (ret < 0)
-		goto end;
+		return ret;
 
 	if (ts->rd != ts->wr) {
 		n = ts->wr->f_op->poll(ts->wr, pt);
-		if (n < 0) {
-			ret = n;
-			goto end;
-		}
+		if (n < 0)
+			return n;
 		ret = (ret & ~POLLOUT) | (n & ~POLLIN);
 	}
 
-end:
-	set_fs(oldfs);
 	return ret;
 }
 
-- 
1.5.4.5

