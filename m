Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYIVSlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYIVSlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYIVSkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:40:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54651 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbYIVSkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:40:41 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] dlm: fix locking of lockspace list in dlm_scand
Date: Mon, 22 Sep 2008 13:28:36 -0500
Message-Id: <1222108119-24928-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dlm_scand thread needs to lock the list of lockspaces
when going through it.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |    1 +
 fs/dlm/lockspace.c    |   27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 9e0622a..868e4c9 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -445,6 +445,7 @@ struct dlm_ls {
 						   the dlm using this ls */
 	int			ls_create_count; /* create/release refcount */
 	unsigned long		ls_flags;	/* LSFL_ */
+	unsigned long		ls_scan_time;
 	struct kobject		ls_kobj;
 
 	struct dlm_rsbtable	*ls_rsbtbl;
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index ba672fe..d910501 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -212,19 +212,41 @@ void dlm_lockspace_exit(void)
 	kset_unregister(dlm_kset);
 }
 
+static struct dlm_ls *find_ls_to_scan(void)
+{
+	struct dlm_ls *ls;
+
+	spin_lock(&lslist_lock);
+	list_for_each_entry(ls, &lslist, ls_list) {
+		if (time_after_eq(jiffies, ls->ls_scan_time +
+					    dlm_config.ci_scan_secs * HZ)) {
+			spin_unlock(&lslist_lock);
+			return ls;
+		}
+	}
+	spin_unlock(&lslist_lock);
+	return NULL;
+}
+
 static int dlm_scand(void *data)
 {
 	struct dlm_ls *ls;
+	int timeout_jiffies = dlm_config.ci_scan_secs * HZ;
 
 	while (!kthread_should_stop()) {
-		list_for_each_entry(ls, &lslist, ls_list) {
+		ls = find_ls_to_scan();
+		if (ls) {
 			if (dlm_lock_recovery_try(ls)) {
+				ls->ls_scan_time = jiffies;
 				dlm_scan_rsbs(ls);
 				dlm_scan_timeout(ls);
 				dlm_unlock_recovery(ls);
+			} else {
+				ls->ls_scan_time += HZ;
 			}
+		} else {
+			schedule_timeout_interruptible(timeout_jiffies);
 		}
-		schedule_timeout_interruptible(dlm_config.ci_scan_secs * HZ);
 	}
 	return 0;
 }
@@ -418,6 +440,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	ls->ls_lvblen = lvblen;
 	ls->ls_count = 0;
 	ls->ls_flags = 0;
+	ls->ls_scan_time = jiffies;
 
 	if (flags & DLM_LSFL_TIMEWARN)
 		set_bit(LSFL_TIMEWARN, &ls->ls_flags);
-- 
1.5.5.1

