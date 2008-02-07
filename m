Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYBGGVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYBGGVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYBGGSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 01/16] dlm: use proper C for dlm/requestqueue stuff (and fix alignment bug)
Date: Thu,  7 Feb 2008 00:09:04 -0600
Message-Id: <1202364559-9201-2-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

a) don't cast the pointer to dlm_header *, we use it as dlm_message *
   anyway.
b) we copy the message into a queue element, then pass the pointer to
   copy to dlm_receive_message_saved(); declare it properly to make sure
   that we have the right alignment.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c         |    2 +-
 fs/dlm/requestqueue.c |   12 ++++++------
 fs/dlm/requestqueue.h |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ff4a198..d9f07a4 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3802,7 +3802,7 @@ static void dlm_receive_message(struct dlm_ls *ls, struct dlm_message *ms,
 				int nodeid)
 {
 	if (dlm_locking_stopped(ls)) {
-		dlm_add_requestqueue(ls, nodeid, (struct dlm_header *) ms);
+		dlm_add_requestqueue(ls, nodeid, ms);
 	} else {
 		dlm_wait_requestqueue(ls);
 		_receive_message(ls, ms);
diff --git a/fs/dlm/requestqueue.c b/fs/dlm/requestqueue.c
index 0de04f1..daa4183 100644
--- a/fs/dlm/requestqueue.c
+++ b/fs/dlm/requestqueue.c
@@ -20,7 +20,7 @@
 struct rq_entry {
 	struct list_head list;
 	int nodeid;
-	char request[0];
+	struct dlm_message request;
 };
 
 /*
@@ -30,10 +30,10 @@ struct rq_entry {
  * lockspace is enabled on some while still suspended on others.
  */
 
-void dlm_add_requestqueue(struct dlm_ls *ls, int nodeid, struct dlm_header *hd)
+void dlm_add_requestqueue(struct dlm_ls *ls, int nodeid, struct dlm_message *ms)
 {
 	struct rq_entry *e;
-	int length = hd->h_length;
+	int length = ms->m_header.h_length - sizeof(struct dlm_message);
 
 	e = kmalloc(sizeof(struct rq_entry) + length, GFP_KERNEL);
 	if (!e) {
@@ -42,7 +42,7 @@ void dlm_add_requestqueue(struct dlm_ls *ls, int nodeid, struct dlm_header *hd)
 	}
 
 	e->nodeid = nodeid;
-	memcpy(e->request, hd, length);
+	memcpy(&e->request, ms, ms->m_header.h_length);
 
 	mutex_lock(&ls->ls_requestqueue_mutex);
 	list_add_tail(&e->list, &ls->ls_requestqueue);
@@ -76,7 +76,7 @@ int dlm_process_requestqueue(struct dlm_ls *ls)
 		e = list_entry(ls->ls_requestqueue.next, struct rq_entry, list);
 		mutex_unlock(&ls->ls_requestqueue_mutex);
 
-		dlm_receive_message_saved(ls, (struct dlm_message *)e->request);
+		dlm_receive_message_saved(ls, &e->request);
 
 		mutex_lock(&ls->ls_requestqueue_mutex);
 		list_del(&e->list);
@@ -176,7 +176,7 @@ void dlm_purge_requestqueue(struct dlm_ls *ls)
 
 	mutex_lock(&ls->ls_requestqueue_mutex);
 	list_for_each_entry_safe(e, safe, &ls->ls_requestqueue, list) {
-		ms = (struct dlm_message *) e->request;
+		ms =  &e->request;
 
 		if (purge_request(ls, ms, e->nodeid)) {
 			list_del(&e->list);
diff --git a/fs/dlm/requestqueue.h b/fs/dlm/requestqueue.h
index aba34fc..10ce449 100644
--- a/fs/dlm/requestqueue.h
+++ b/fs/dlm/requestqueue.h
@@ -13,7 +13,7 @@
 #ifndef __REQUESTQUEUE_DOT_H__
 #define __REQUESTQUEUE_DOT_H__
 
-void dlm_add_requestqueue(struct dlm_ls *ls, int nodeid, struct dlm_header *hd);
+void dlm_add_requestqueue(struct dlm_ls *ls, int nodeid, struct dlm_message *ms);
 int dlm_process_requestqueue(struct dlm_ls *ls);
 void dlm_wait_requestqueue(struct dlm_ls *ls);
 void dlm_purge_requestqueue(struct dlm_ls *ls);
-- 
1.5.3.3

