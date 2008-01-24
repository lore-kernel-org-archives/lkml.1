Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYAXREv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYAXREv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbYAXQ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758285AbYAXQ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:40 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] dlm: limit dir lookup loop
Date: Thu, 24 Jan 2008 10:50:38 -0600
Message-Id: <1201193442-8260-16-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a rare case we may need to repeat a local resource directory lookup
due to a race with removing the rsb and removing the resdir record.
We'll never need to do more than a single additional lookup, though,
so the infinite loop around the lookup can be removed.  In addition
to being unnecessary, the infinite loop is dangerous since some other
unknown condition may appear causing the loop to never break.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index fa68e9b..bc2e4ba 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1851,7 +1851,7 @@ static void send_blocking_asts_all(struct dlm_rsb *r, struct dlm_lkb *lkb)
 static int set_master(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	struct dlm_ls *ls = r->res_ls;
-	int error, dir_nodeid, ret_nodeid, our_nodeid = dlm_our_nodeid();
+	int i, error, dir_nodeid, ret_nodeid, our_nodeid = dlm_our_nodeid();
 
 	if (rsb_flag(r, RSB_MASTER_UNCERTAIN)) {
 		rsb_clear_flag(r, RSB_MASTER_UNCERTAIN);
@@ -1885,7 +1885,7 @@ static int set_master(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		return 1;
 	}
 
-	for (;;) {
+	for (i = 0; i < 2; i++) {
 		/* It's possible for dlm_scand to remove an old rsb for
 		   this same resource from the toss list, us to create
 		   a new one, look up the master locally, and find it
@@ -1899,6 +1899,8 @@ static int set_master(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		log_debug(ls, "dir_lookup error %d %s", error, r->res_name);
 		schedule();
 	}
+	if (error && error != -EEXIST)
+		return error;
 
 	if (ret_nodeid == our_nodeid) {
 		r->res_first_lkid = 0;
-- 
1.5.3.3

