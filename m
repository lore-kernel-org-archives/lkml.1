Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYHZIxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYHZIxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYHZIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:52:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:46731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbYHZIwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:52:22 -0400
From: Tejun Heo <tj@kernel.org>
To: ericvh@gmail.com, rminnich@sandia.gov,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] 9p-trans_fd: fix and clean up module init/exit paths
Date: Tue, 26 Aug 2008 17:50:55 +0900
Message-Id: <1219740656-26458-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219740656-26458-1-git-send-email-tj@kernel.org>
References: <1219740656-26458-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 Aug 2008 08:52:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trans_fd leaked p9_mux_wq on module unload.  Fix it.  While at it,
collapse p9_mux_global_init() into p9_trans_fd_init().  It's easier to
follow this way and the global poll_tasks array is about to removed
anyway.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/9p/trans_fd.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index f6d4af1..0b4eb5f 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -238,22 +238,6 @@ static int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
 
 static void p9_conn_cancel(struct p9_conn *m, int err);
 
-static int p9_mux_global_init(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
-		p9_mux_poll_tasks[i].task = NULL;
-
-	p9_mux_wq = create_workqueue("v9fs");
-	if (!p9_mux_wq) {
-		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
 static u16 p9_mux_get_tag(struct p9_conn *m)
 {
 	int tag;
@@ -1616,10 +1600,15 @@ static struct p9_trans_module p9_fd_trans = {
 
 int p9_trans_fd_init(void)
 {
-	int ret = p9_mux_global_init();
-	if (ret) {
-		printk(KERN_WARNING "9p: starting mux failed\n");
-		return ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
+		p9_mux_poll_tasks[i].task = NULL;
+
+	p9_mux_wq = create_workqueue("v9fs");
+	if (!p9_mux_wq) {
+		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
+		return -ENOMEM;
 	}
 
 	v9fs_register_trans(&p9_tcp_trans);
@@ -1634,4 +1623,6 @@ void p9_trans_fd_exit(void)
 	v9fs_unregister_trans(&p9_tcp_trans);
 	v9fs_unregister_trans(&p9_unix_trans);
 	v9fs_unregister_trans(&p9_fd_trans);
+
+	destroy_workqueue(p9_mux_wq);
 }
-- 
1.5.4.5

