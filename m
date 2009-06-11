Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZFKP3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZFKP3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZFKP3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:29:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55888 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZFKP3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:29:19 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] dlm: use more NOFS allocation
Date: Thu, 11 Jun 2009 10:20:49 -0500
Message-Id: <1244733649-26003-5-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change some GFP_KERNEL allocations to use either GFP_NOFS or
ls_allocation (when available) which the fs sets to GFP_NOFS.
The point is to prevent allocations from going back into the
cluster fs in places where that might lead to deadlock.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c          |    7 ++++---
 fs/dlm/lowcomms.c     |    6 +++---
 fs/dlm/member.c       |    8 ++++----
 fs/dlm/requestqueue.c |    2 +-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index 858fba1..c4dfa1d 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -49,7 +49,8 @@ static struct dlm_direntry *get_free_de(struct dlm_ls *ls, int len)
 	spin_unlock(&ls->ls_recover_list_lock);
 
 	if (!found)
-		de = kzalloc(sizeof(struct dlm_direntry) + len, GFP_KERNEL);
+		de = kzalloc(sizeof(struct dlm_direntry) + len,
+			     ls->ls_allocation);
 	return de;
 }
 
@@ -211,7 +212,7 @@ int dlm_recover_directory(struct dlm_ls *ls)
 
 	dlm_dir_clear(ls);
 
-	last_name = kmalloc(DLM_RESNAME_MAXLEN, GFP_KERNEL);
+	last_name = kmalloc(DLM_RESNAME_MAXLEN, ls->ls_allocation);
 	if (!last_name)
 		goto out;
 
@@ -322,7 +323,7 @@ static int get_entry(struct dlm_ls *ls, int nodeid, char *name,
 	if (namelen > DLM_RESNAME_MAXLEN)
 		return -EINVAL;
 
-	de = kzalloc(sizeof(struct dlm_direntry) + namelen, GFP_KERNEL);
+	de = kzalloc(sizeof(struct dlm_direntry) + namelen, ls->ls_allocation);
 	if (!de)
 		return -ENOMEM;
 
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 2559a97..cdb580a 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -500,7 +500,7 @@ static void process_sctp_notification(struct connection *con,
 				return;
 			}
 
-			new_con = nodeid2con(nodeid, GFP_KERNEL);
+			new_con = nodeid2con(nodeid, GFP_NOFS);
 			if (!new_con)
 				return;
 
@@ -736,7 +736,7 @@ static int tcp_accept_from_sock(struct connection *con)
 	 *  the same time and the connections cross on the wire.
 	 *  In this case we store the incoming one in "othercon"
 	 */
-	newcon = nodeid2con(nodeid, GFP_KERNEL);
+	newcon = nodeid2con(nodeid, GFP_NOFS);
 	if (!newcon) {
 		result = -ENOMEM;
 		goto accept_err;
@@ -746,7 +746,7 @@ static int tcp_accept_from_sock(struct connection *con)
 		struct connection *othercon = newcon->othercon;
 
 		if (!othercon) {
-			othercon = kmem_cache_zalloc(con_cache, GFP_KERNEL);
+			othercon = kmem_cache_zalloc(con_cache, GFP_NOFS);
 			if (!othercon) {
 				log_print("failed to allocate incoming socket");
 				mutex_unlock(&newcon->sock_mutex);
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 2afb770..b128775 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -48,7 +48,7 @@ static int dlm_add_member(struct dlm_ls *ls, int nodeid)
 	struct dlm_member *memb;
 	int w, error;
 
-	memb = kzalloc(sizeof(struct dlm_member), GFP_KERNEL);
+	memb = kzalloc(sizeof(struct dlm_member), ls->ls_allocation);
 	if (!memb)
 		return -ENOMEM;
 
@@ -143,7 +143,7 @@ static void make_member_array(struct dlm_ls *ls)
 
 	ls->ls_total_weight = total;
 
-	array = kmalloc(sizeof(int) * total, GFP_KERNEL);
+	array = kmalloc(sizeof(int) * total, ls->ls_allocation);
 	if (!array)
 		return;
 
@@ -226,7 +226,7 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 			continue;
 		log_debug(ls, "new nodeid %d is a re-added member", rv->new[i]);
 
-		memb = kzalloc(sizeof(struct dlm_member), GFP_KERNEL);
+		memb = kzalloc(sizeof(struct dlm_member), ls->ls_allocation);
 		if (!memb)
 			return -ENOMEM;
 		memb->nodeid = rv->new[i];
@@ -341,7 +341,7 @@ int dlm_ls_start(struct dlm_ls *ls)
 	int *ids = NULL, *new = NULL;
 	int error, ids_count = 0, new_count = 0;
 
-	rv = kzalloc(sizeof(struct dlm_recover), GFP_KERNEL);
+	rv = kzalloc(sizeof(struct dlm_recover), ls->ls_allocation);
 	if (!rv)
 		return -ENOMEM;
 
diff --git a/fs/dlm/requestqueue.c b/fs/dlm/requestqueue.c
index daa4183..7a2307c 100644
--- a/fs/dlm/requestqueue.c
+++ b/fs/dlm/requestqueue.c
@@ -35,7 +35,7 @@ void dlm_add_requestqueue(struct dlm_ls *ls, int nodeid, struct dlm_message *ms)
 	struct rq_entry *e;
 	int length = ms->m_header.h_length - sizeof(struct dlm_message);
 
-	e = kmalloc(sizeof(struct rq_entry) + length, GFP_KERNEL);
+	e = kmalloc(sizeof(struct rq_entry) + length, ls->ls_allocation);
 	if (!e) {
 		log_print("dlm_add_requestqueue: out of memory len %d", length);
 		return;
-- 
1.5.5.6

