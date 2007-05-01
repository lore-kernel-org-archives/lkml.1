Return-Path: <linux-kernel-owner+w=401wt.eu-S1161674AbXEAKQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161674AbXEAKQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161668AbXEAKQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:16:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161674AbXEAKQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:16:43 -0400
Subject: [DLM] add orphan purging code (1/2) [17/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:12:09 +0100
Message-Id: <1178014329.5462.161.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8499137d4ef1829281e04838113b6b09a0bf1269 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Fri, 30 Mar 2007 15:02:40 -0500
Subject: [PATCH] [DLM] add orphan purging code (1/2)

Add code for purging orphan locks.  A process can also purge all of its
own non-orphan locks by passing a pid of zero.  Code already exists for
processes to create persistent locks that become orphans when the process
exits, but the complimentary capability for another process to then purge
these orphans has been missing.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 178931c..30994d6 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -342,6 +342,7 @@ struct dlm_header {
 #define DLM_MSG_LOOKUP		11
 #define DLM_MSG_REMOVE		12
 #define DLM_MSG_LOOKUP_REPLY	13
+#define DLM_MSG_PURGE		14
 
 struct dlm_message {
 	struct dlm_header	m_header;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 7807958..9d26b3a 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -85,6 +85,7 @@ static int _request_lock(struct dlm_rsb *r, struct dlm_lkb *lkb);
 static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 				    struct dlm_message *ms);
 static int receive_extralen(struct dlm_message *ms);
+static void do_purge(struct dlm_ls *ls, int nodeid, int pid);
 
 /*
  * Lock compatibilty matrix - thanks Steve
@@ -2987,6 +2988,11 @@ static void receive_remove(struct dlm_ls *ls, struct dlm_message *ms)
 	dlm_dir_remove_entry(ls, from_nodeid, ms->m_extra, len);
 }
 
+static void receive_purge(struct dlm_ls *ls, struct dlm_message *ms)
+{
+	do_purge(ls, ms->m_nodeid, ms->m_pid);
+}
+
 static void receive_request_reply(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
@@ -3409,6 +3415,12 @@ int dlm_receive_message(struct dlm_header *hd, int nodeid, int recovery)
 		receive_lookup_reply(ls, ms);
 		break;
 
+	/* other messages */
+
+	case DLM_MSG_PURGE:
+		receive_purge(ls, ms);
+		break;
+
 	default:
 		log_error(ls, "unknown message type %d", ms->m_type);
 	}
@@ -4260,3 +4272,92 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 	unlock_recovery(ls);
 }
 
+static void purge_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
+{
+	struct dlm_lkb *lkb, *safe;
+
+	while (1) {
+		lkb = NULL;
+		spin_lock(&proc->locks_spin);
+		if (!list_empty(&proc->locks)) {
+			lkb = list_entry(proc->locks.next, struct dlm_lkb,
+					 lkb_ownqueue);
+			list_del_init(&lkb->lkb_ownqueue);
+		}
+		spin_unlock(&proc->locks_spin);
+
+		if (!lkb)
+			break;
+
+		lkb->lkb_flags |= DLM_IFL_DEAD;
+		unlock_proc_lock(ls, lkb);
+		dlm_put_lkb(lkb); /* ref from proc->locks list */
+	}
+
+	spin_lock(&proc->locks_spin);
+	list_for_each_entry_safe(lkb, safe, &proc->unlocking, lkb_ownqueue) {
+		list_del_init(&lkb->lkb_ownqueue);
+		lkb->lkb_flags |= DLM_IFL_DEAD;
+		dlm_put_lkb(lkb);
+	}
+	spin_unlock(&proc->locks_spin);
+
+	spin_lock(&proc->asts_spin);
+	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_astqueue) {
+		list_del(&lkb->lkb_astqueue);
+		dlm_put_lkb(lkb);
+	}
+	spin_unlock(&proc->asts_spin);
+}
+
+/* pid of 0 means purge all orphans */
+
+static void do_purge(struct dlm_ls *ls, int nodeid, int pid)
+{
+	struct dlm_lkb *lkb, *safe;
+
+	mutex_lock(&ls->ls_orphans_mutex);
+	list_for_each_entry_safe(lkb, safe, &ls->ls_orphans, lkb_ownqueue) {
+		if (pid && lkb->lkb_ownpid != pid)
+			continue;
+		unlock_proc_lock(ls, lkb);
+		list_del_init(&lkb->lkb_ownqueue);
+		dlm_put_lkb(lkb);
+	}
+	mutex_unlock(&ls->ls_orphans_mutex);
+}
+
+static int send_purge(struct dlm_ls *ls, int nodeid, int pid)
+{
+	struct dlm_message *ms;
+	struct dlm_mhandle *mh;
+	int error;
+
+	error = _create_message(ls, sizeof(struct dlm_message), nodeid,
+				DLM_MSG_PURGE, &ms, &mh);
+	if (error)
+		return error;
+	ms->m_nodeid = nodeid;
+	ms->m_pid = pid;
+
+	return send_message(mh, ms);
+}
+
+int dlm_user_purge(struct dlm_ls *ls, struct dlm_user_proc *proc,
+		   int nodeid, int pid)
+{
+	int error = 0;
+
+	if (nodeid != dlm_our_nodeid()) {
+		error = send_purge(ls, nodeid, pid);
+	} else {
+		lock_recovery(ls);
+		if (pid == current->pid)
+			purge_proc_locks(ls, proc);
+		else
+			do_purge(ls, nodeid, pid);
+		unlock_recovery(ls);
+	}
+	return error;
+}
+
-- 
1.5.1.2



