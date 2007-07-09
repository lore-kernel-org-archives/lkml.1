Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbXGIQ2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbXGIQ2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbXGIQXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbXGIQXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:40 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] wait for config check during join [6/6]
Date: Mon,  9 Jul 2007 17:02:22 +0100
Message-Id: <11839970222606-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970204036-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Joining the lockspace should wait for the initial round of inter-node
config checks to complete before returning.  This way, if there's a
configuration mismatch between the joining node and the existing nodes,
the join can fail and return an error to the application.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index a8d6e99..03ba6c4 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -472,6 +472,8 @@ struct dlm_ls {
 
 	wait_queue_head_t	ls_uevent_wait;	/* user part of join/leave */
 	int			ls_uevent_result;
+	struct completion	ls_members_done;
+	int			ls_members_result;
 
 	struct miscdevice       ls_device;
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index a3a50e6..c8f0c15 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -197,13 +197,24 @@ static int do_uevent(struct dlm_ls *ls, int in)
 	else
 		kobject_uevent(&ls->ls_kobj, KOBJ_OFFLINE);
 
+	log_debug(ls, "%s the lockspace group...", in ? "joining" : "leaving");
+
+	/* dlm_controld will see the uevent, do the necessary group management
+	   and then write to sysfs to wake us */
+
 	error = wait_event_interruptible(ls->ls_uevent_wait,
 			test_and_clear_bit(LSFL_UEVENT_WAIT, &ls->ls_flags));
+
+	log_debug(ls, "group event done %d %d", error, ls->ls_uevent_result);
+
 	if (error)
 		goto out;
 
 	error = ls->ls_uevent_result;
  out:
+	if (error)
+		log_error(ls, "group %s failed %d %d", in ? "join" : "leave",
+			  error, ls->ls_uevent_result);
 	return error;
 }
 
@@ -490,6 +501,8 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 
 	init_waitqueue_head(&ls->ls_uevent_wait);
 	ls->ls_uevent_result = 0;
+	init_completion(&ls->ls_members_done);
+	ls->ls_members_result = -1;
 
 	ls->ls_recoverd_task = NULL;
 	mutex_init(&ls->ls_recoverd_active);
@@ -540,10 +553,21 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	/* let kobject handle freeing of ls if there's an error */
 	do_unreg = 1;
 
+	/* This uevent triggers dlm_controld in userspace to add us to the
+	   group of nodes that are members of this lockspace (managed by the
+	   cluster infrastructure.)  Once it's done that, it tells us who the
+	   current lockspace members are (via configfs) and then tells the
+	   lockspace to start running (via sysfs) in dlm_ls_start(). */
+
 	error = do_uevent(ls, 1);
 	if (error)
 		goto out_stop;
 
+	wait_for_completion(&ls->ls_members_done);
+	error = ls->ls_members_result;
+	if (error)
+		goto out_members;
+
 	dlm_create_debug_file(ls);
 
 	log_debug(ls, "join complete");
@@ -551,6 +575,10 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	*lockspace = ls;
 	return 0;
 
+ out_members:
+	do_uevent(ls, 0);
+	dlm_clear_members(ls);
+	kfree(ls->ls_node_array);
  out_stop:
 	dlm_recoverd_stop(ls);
  out_delist:
@@ -588,6 +616,8 @@ int dlm_new_lockspace(char *name, int namelen, void **lockspace,
 	error = new_lockspace(name, namelen, lockspace, flags, lvblen);
 	if (!error)
 		ls_count++;
+	else if (!ls_count)
+		threads_stop();
  out:
 	mutex_unlock(&ls_lock);
 	return error;
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index f08faec..073599d 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -233,6 +233,12 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 	*neg_out = neg;
 
 	error = ping_members(ls);
+	if (!error || error == -EPROTO) {
+		/* new_lockspace() may be waiting to know if the config
+		   is good or bad */
+		ls->ls_members_result = error;
+		complete(&ls->ls_members_done);
+	}
 	if (error)
 		goto out;
 
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 6bfbd61..f71c235 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -90,7 +90,7 @@ static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		log_error(ls, "version mismatch: %x nodeid %d: %x",
 			  DLM_HEADER_MAJOR | DLM_HEADER_MINOR, nodeid,
 			  rc->rc_header.h_version);
-		return -EINVAL;
+		return -EPROTO;
 	}
 
 	if (rf->rf_lvblen != ls->ls_lvblen ||
@@ -98,7 +98,7 @@ static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		log_error(ls, "config mismatch: %d,%x nodeid %d: %d,%x",
 			  ls->ls_lvblen, ls->ls_exflags,
 			  nodeid, rf->rf_lvblen, rf->rf_lsflags);
-		return -EINVAL;
+		return -EPROTO;
 	}
 	return 0;
 }
-- 
1.5.1.2

