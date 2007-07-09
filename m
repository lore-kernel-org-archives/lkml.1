Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbXGIQ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbXGIQ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbXGIQXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544AbXGIQXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:32 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] add lock timeouts and warnings [2/6]
Date: Mon,  9 Jul 2007 17:02:18 +0100
Message-Id: <11839970143164-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970122624-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

New features: lock timeouts and time warnings.  If the DLM_LKF_TIMEOUT
flag is set, then the request/conversion will be canceled after waiting
the specified number of centiseconds (specified per lock).  This feature
is only available for locks requested through libdlm (can be enabled for
kernel dlm users if there's a use for it.)

If the new DLM_LSFL_TIMEWARN flag is set when creating the lockspace, then
a warning message will be sent to userspace (using genetlink) after a
request/conversion has been waiting for a given number of centiseconds
(configurable per node).  The time warnings will be used in the future
to do deadlock detection in userspace.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/Makefile b/fs/dlm/Makefile
index 604cf7d..d248e60 100644
--- a/fs/dlm/Makefile
+++ b/fs/dlm/Makefile
@@ -8,6 +8,7 @@ dlm-y :=			ast.o \
 				member.o \
 				memory.o \
 				midcomms.o \
+				netlink.o \
 				lowcomms.o \
 				rcom.o \
 				recover.o \
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 5a3d390..2909abf 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -90,6 +90,7 @@ struct cluster {
 	unsigned int cl_scan_secs;
 	unsigned int cl_log_debug;
 	unsigned int cl_protocol;
+	unsigned int cl_timewarn_cs;
 };
 
 enum {
@@ -103,6 +104,7 @@ enum {
 	CLUSTER_ATTR_SCAN_SECS,
 	CLUSTER_ATTR_LOG_DEBUG,
 	CLUSTER_ATTR_PROTOCOL,
+	CLUSTER_ATTR_TIMEWARN_CS,
 };
 
 struct cluster_attribute {
@@ -162,6 +164,7 @@ CLUSTER_ATTR(toss_secs, 1);
 CLUSTER_ATTR(scan_secs, 1);
 CLUSTER_ATTR(log_debug, 0);
 CLUSTER_ATTR(protocol, 0);
+CLUSTER_ATTR(timewarn_cs, 1);
 
 static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_TCP_PORT] = &cluster_attr_tcp_port.attr,
@@ -174,6 +177,7 @@ static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_SCAN_SECS] = &cluster_attr_scan_secs.attr,
 	[CLUSTER_ATTR_LOG_DEBUG] = &cluster_attr_log_debug.attr,
 	[CLUSTER_ATTR_PROTOCOL] = &cluster_attr_protocol.attr,
+	[CLUSTER_ATTR_TIMEWARN_CS] = &cluster_attr_timewarn_cs.attr,
 	NULL,
 };
 
@@ -916,6 +920,7 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 #define DEFAULT_SCAN_SECS          5
 #define DEFAULT_LOG_DEBUG          0
 #define DEFAULT_PROTOCOL           0
+#define DEFAULT_TIMEWARN_CS      500 /* 5 sec = 500 centiseconds */
 
 struct dlm_config_info dlm_config = {
 	.ci_tcp_port = DEFAULT_TCP_PORT,
@@ -927,6 +932,7 @@ struct dlm_config_info dlm_config = {
 	.ci_toss_secs = DEFAULT_TOSS_SECS,
 	.ci_scan_secs = DEFAULT_SCAN_SECS,
 	.ci_log_debug = DEFAULT_LOG_DEBUG,
-	.ci_protocol = DEFAULT_PROTOCOL
+	.ci_protocol = DEFAULT_PROTOCOL,
+	.ci_timewarn_cs = DEFAULT_TIMEWARN_CS
 };
 
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index 967cc3d..a3170fe 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -27,6 +27,7 @@ struct dlm_config_info {
 	int ci_scan_secs;
 	int ci_log_debug;
 	int ci_protocol;
+	int ci_timewarn_cs;
 };
 
 extern struct dlm_config_info dlm_config;
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 30994d6..65a5fc0 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -213,8 +213,10 @@ struct dlm_args {
 #define DLM_IFL_OVERLAP_UNLOCK  0x00080000
 #define DLM_IFL_OVERLAP_CANCEL  0x00100000
 #define DLM_IFL_ENDOFLIFE	0x00200000
+#define DLM_IFL_WATCH_TIMEWARN	0x00400000
 #define DLM_IFL_USER		0x00000001
 #define DLM_IFL_ORPHAN		0x00000002
+#define DLM_IFL_TIMEOUT_CANCEL	0x00000004
 
 struct dlm_lkb {
 	struct dlm_rsb		*lkb_resource;	/* the rsb */
@@ -243,6 +245,9 @@ struct dlm_lkb {
 	struct list_head	lkb_wait_reply;	/* waiting for remote reply */
 	struct list_head	lkb_astqueue;	/* need ast to be sent */
 	struct list_head	lkb_ownqueue;	/* list of locks for a process */
+	struct list_head	lkb_time_list;
+	unsigned long		lkb_timestamp;
+	unsigned long		lkb_timeout_cs;
 
 	char			*lkb_lvbptr;
 	struct dlm_lksb		*lkb_lksb;      /* caller's status block */
@@ -447,6 +452,9 @@ struct dlm_ls {
 	struct mutex		ls_orphans_mutex;
 	struct list_head	ls_orphans;
 
+	struct mutex		ls_timeout_mutex;
+	struct list_head	ls_timeout;
+
 	struct list_head	ls_nodes;	/* current nodes in ls */
 	struct list_head	ls_nodes_gone;	/* dead node list, recovery */
 	int			ls_num_nodes;	/* number of nodes in ls */
@@ -472,6 +480,7 @@ struct dlm_ls {
 	struct task_struct	*ls_recoverd_task;
 	struct mutex		ls_recoverd_active;
 	spinlock_t		ls_recover_lock;
+	unsigned long		ls_recover_begin; /* jiffies timestamp */
 	uint32_t		ls_recover_status; /* DLM_RS_ */
 	uint64_t		ls_recover_seq;
 	struct dlm_recover	*ls_recover_args;
@@ -501,6 +510,7 @@ struct dlm_ls {
 #define LSFL_RCOM_READY		3
 #define LSFL_RCOM_WAIT		4
 #define LSFL_UEVENT_WAIT	5
+#define LSFL_TIMEWARN		6
 
 /* much of this is just saving user space pointers associated with the
    lock that we pass back to the user lib with an ast */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 09668ec..ab986df 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -82,10 +82,13 @@ static int send_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int mode);
 static int send_lookup(struct dlm_rsb *r, struct dlm_lkb *lkb);
 static int send_remove(struct dlm_rsb *r);
 static int _request_lock(struct dlm_rsb *r, struct dlm_lkb *lkb);
+static int _cancel_lock(struct dlm_rsb *r, struct dlm_lkb *lkb);
 static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 				    struct dlm_message *ms);
 static int receive_extralen(struct dlm_message *ms);
 static void do_purge(struct dlm_ls *ls, int nodeid, int pid);
+static void del_timeout(struct dlm_lkb *lkb);
+void dlm_timeout_warn(struct dlm_lkb *lkb);
 
 /*
  * Lock compatibilty matrix - thanks Steve
@@ -286,8 +289,17 @@ static void queue_cast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rv)
 	if (is_master_copy(lkb))
 		return;
 
+	del_timeout(lkb);
+
 	DLM_ASSERT(lkb->lkb_lksb, dlm_print_lkb(lkb););
 
+	/* if the operation was a cancel, then return -DLM_ECANCEL, if a
+	   timeout caused the cancel then return -ETIMEDOUT */
+	if (rv == -DLM_ECANCEL && (lkb->lkb_flags & DLM_IFL_TIMEOUT_CANCEL)) {
+		lkb->lkb_flags &= ~DLM_IFL_TIMEOUT_CANCEL;
+		rv = -ETIMEDOUT;
+	}
+
 	lkb->lkb_lksb->sb_status = rv;
 	lkb->lkb_lksb->sb_flags = lkb->lkb_sbflags;
 
@@ -581,6 +593,7 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 	kref_init(&lkb->lkb_ref);
 	INIT_LIST_HEAD(&lkb->lkb_ownqueue);
 	INIT_LIST_HEAD(&lkb->lkb_rsb_lookup);
+	INIT_LIST_HEAD(&lkb->lkb_time_list);
 
 	get_random_bytes(&bucket, sizeof(bucket));
 	bucket &= (ls->ls_lkbtbl_size - 1);
@@ -993,6 +1006,125 @@ void dlm_scan_rsbs(struct dlm_ls *ls)
 	}
 }
 
+static void add_timeout(struct dlm_lkb *lkb)
+{
+	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
+
+	if (is_master_copy(lkb))
+		return;
+
+	if (lkb->lkb_exflags & DLM_LKF_TIMEOUT)
+		goto add_it;
+
+	if (test_bit(LSFL_TIMEWARN, &ls->ls_flags) &&
+	    !(lkb->lkb_exflags & DLM_LKF_NODLCKWT)) {
+		lkb->lkb_flags |= DLM_IFL_WATCH_TIMEWARN;
+		goto add_it;
+	}
+	return;
+
+ add_it:
+	DLM_ASSERT(list_empty(&lkb->lkb_time_list), dlm_print_lkb(lkb););
+	mutex_lock(&ls->ls_timeout_mutex);
+	hold_lkb(lkb);
+	lkb->lkb_timestamp = jiffies;
+	list_add_tail(&lkb->lkb_time_list, &ls->ls_timeout);
+	mutex_unlock(&ls->ls_timeout_mutex);
+}
+
+static void del_timeout(struct dlm_lkb *lkb)
+{
+	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
+
+	mutex_lock(&ls->ls_timeout_mutex);
+	if (!list_empty(&lkb->lkb_time_list)) {
+		list_del_init(&lkb->lkb_time_list);
+		unhold_lkb(lkb);
+	}
+	mutex_unlock(&ls->ls_timeout_mutex);
+}
+
+/* FIXME: is it safe to look at lkb_exflags, lkb_flags, lkb_timestamp, and
+   lkb_lksb_timeout without lock_rsb?  Note: we can't lock timeout_mutex
+   and then lock rsb because of lock ordering in add_timeout.  We may need
+   to specify some special timeout-related bits in the lkb that are just to
+   be accessed under the timeout_mutex. */
+
+void dlm_scan_timeout(struct dlm_ls *ls)
+{
+	struct dlm_rsb *r;
+	struct dlm_lkb *lkb;
+	int do_cancel, do_warn;
+
+	for (;;) {
+		if (dlm_locking_stopped(ls))
+			break;
+
+		do_cancel = 0;
+		do_warn = 0;
+		mutex_lock(&ls->ls_timeout_mutex);
+		list_for_each_entry(lkb, &ls->ls_timeout, lkb_time_list) {
+
+			if ((lkb->lkb_exflags & DLM_LKF_TIMEOUT) &&
+			    time_after_eq(jiffies, lkb->lkb_timestamp +
+					  lkb->lkb_timeout_cs * HZ/100))
+				do_cancel = 1;
+
+			if ((lkb->lkb_flags & DLM_IFL_WATCH_TIMEWARN) &&
+			    time_after_eq(jiffies, lkb->lkb_timestamp +
+				   	   dlm_config.ci_timewarn_cs * HZ/100))
+				do_warn = 1;
+
+			if (!do_cancel && !do_warn)
+				continue;
+			hold_lkb(lkb);
+			break;
+		}
+		mutex_unlock(&ls->ls_timeout_mutex);
+
+		if (!do_cancel && !do_warn)
+			break;
+
+		r = lkb->lkb_resource;
+		hold_rsb(r);
+		lock_rsb(r);
+
+		if (do_warn) {
+			/* clear flag so we only warn once */
+			lkb->lkb_flags &= ~DLM_IFL_WATCH_TIMEWARN;
+			if (!(lkb->lkb_exflags & DLM_LKF_TIMEOUT))
+				del_timeout(lkb);
+			dlm_timeout_warn(lkb);
+		}
+
+		if (do_cancel) {
+			lkb->lkb_flags &= ~DLM_IFL_WATCH_TIMEWARN;
+			lkb->lkb_flags |= DLM_IFL_TIMEOUT_CANCEL;
+			del_timeout(lkb);
+			_cancel_lock(r, lkb);
+		}
+
+		unlock_rsb(r);
+		unhold_rsb(r);
+		dlm_put_lkb(lkb);
+	}
+}
+
+/* This is only called by dlm_recoverd, and we rely on dlm_ls_stop() stopping
+   dlm_recoverd before checking/setting ls_recover_begin. */
+
+void dlm_adjust_timeouts(struct dlm_ls *ls)
+{
+	struct dlm_lkb *lkb;
+	long adj = jiffies - ls->ls_recover_begin;
+
+	ls->ls_recover_begin = 0;
+	mutex_lock(&ls->ls_timeout_mutex);
+	list_for_each_entry(lkb, &ls->ls_timeout, lkb_time_list)
+		lkb->lkb_timestamp += adj;
+	mutex_unlock(&ls->ls_timeout_mutex);
+}
+
 /* lkb is master or local copy */
 
 static void set_lvb_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
@@ -1902,6 +2034,9 @@ static int validate_unlock_args(struct dlm_lkb *lkb, struct dlm_args *args)
 		if (is_overlap(lkb))
 			goto out;
 
+		/* don't let scand try to do a cancel */
+		del_timeout(lkb);
+
 		if (lkb->lkb_flags & DLM_IFL_RESEND) {
 			lkb->lkb_flags |= DLM_IFL_OVERLAP_CANCEL;
 			rv = -EBUSY;
@@ -1933,6 +2068,9 @@ static int validate_unlock_args(struct dlm_lkb *lkb, struct dlm_args *args)
 		if (is_overlap_unlock(lkb))
 			goto out;
 
+		/* don't let scand try to do a cancel */
+		del_timeout(lkb);
+
 		if (lkb->lkb_flags & DLM_IFL_RESEND) {
 			lkb->lkb_flags |= DLM_IFL_OVERLAP_UNLOCK;
 			rv = -EBUSY;
@@ -1993,6 +2131,7 @@ static int do_request(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		error = -EINPROGRESS;
 		add_lkb(r, lkb, DLM_LKSTS_WAITING);
 		send_blocking_asts(r, lkb);
+		add_timeout(lkb);
 		goto out;
 	}
 
@@ -2040,6 +2179,7 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		del_lkb(r, lkb);
 		add_lkb(r, lkb, DLM_LKSTS_CONVERT);
 		send_blocking_asts(r, lkb);
+		add_timeout(lkb);
 		goto out;
 	}
 
@@ -3110,9 +3250,10 @@ static void receive_request_reply(struct dlm_ls *ls, struct dlm_message *ms)
 		lkb->lkb_remid = ms->m_lkid;
 		if (is_altmode(lkb))
 			munge_altmode(lkb, ms);
-		if (result)
+		if (result) {
 			add_lkb(r, lkb, DLM_LKSTS_WAITING);
-		else {
+			add_timeout(lkb);
+		} else {
 			grant_lock_pc(r, lkb, ms);
 			queue_cast(r, lkb, 0);
 		}
@@ -3178,6 +3319,7 @@ static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 			munge_demoted(lkb, ms);
 		del_lkb(r, lkb);
 		add_lkb(r, lkb, DLM_LKSTS_CONVERT);
+		add_timeout(lkb);
 		break;
 
 	case 0:
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 19403aa..6b5b71f 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -26,6 +26,8 @@ int dlm_put_lkb(struct dlm_lkb *lkb);
 void dlm_scan_rsbs(struct dlm_ls *ls);
 int dlm_lock_recovery_try(struct dlm_ls *ls);
 void dlm_unlock_recovery(struct dlm_ls *ls);
+void dlm_scan_timeout(struct dlm_ls *ls);
+void dlm_adjust_timeouts(struct dlm_ls *ls);
 
 int dlm_purge_locks(struct dlm_ls *ls);
 void dlm_purge_mstcpy_locks(struct dlm_rsb *r);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 414a108..339a204 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -237,6 +237,7 @@ static int dlm_scand(void *data)
 		list_for_each_entry(ls, &lslist, ls_list) {
 			if (dlm_lock_recovery_try(ls)) {
 				dlm_scan_rsbs(ls);
+				dlm_scan_timeout(ls);
 				dlm_unlock_recovery(ls);
 			}
 		}
@@ -421,11 +422,16 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 		goto out;
 	memcpy(ls->ls_name, name, namelen);
 	ls->ls_namelen = namelen;
-	ls->ls_exflags = flags;
 	ls->ls_lvblen = lvblen;
 	ls->ls_count = 0;
 	ls->ls_flags = 0;
 
+	/* ls_exflags are forced to match among nodes, and we don't
+	   need to require all nodes to have TIMEWARN active */
+	if (flags & DLM_LSFL_TIMEWARN)
+		set_bit(LSFL_TIMEWARN, &ls->ls_flags);
+	ls->ls_exflags = (flags & ~DLM_LSFL_TIMEWARN);
+
 	size = dlm_config.ci_rsbtbl_size;
 	ls->ls_rsbtbl_size = size;
 
@@ -465,6 +471,8 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	mutex_init(&ls->ls_waiters_mutex);
 	INIT_LIST_HEAD(&ls->ls_orphans);
 	mutex_init(&ls->ls_orphans_mutex);
+	INIT_LIST_HEAD(&ls->ls_timeout);
+	mutex_init(&ls->ls_timeout_mutex);
 
 	INIT_LIST_HEAD(&ls->ls_nodes);
 	INIT_LIST_HEAD(&ls->ls_nodes_gone);
diff --git a/fs/dlm/main.c b/fs/dlm/main.c
index 162fbae..eca2907 100644
--- a/fs/dlm/main.c
+++ b/fs/dlm/main.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -25,6 +25,8 @@ void dlm_unregister_debugfs(void);
 static inline int dlm_register_debugfs(void) { return 0; }
 static inline void dlm_unregister_debugfs(void) { }
 #endif
+int dlm_netlink_init(void);
+void dlm_netlink_exit(void);
 
 static int __init init_dlm(void)
 {
@@ -50,10 +52,16 @@ static int __init init_dlm(void)
 	if (error)
 		goto out_debug;
 
+	error = dlm_netlink_init();
+	if (error)
+		goto out_user;
+
 	printk("DLM (built %s %s) installed\n", __DATE__, __TIME__);
 
 	return 0;
 
+ out_user:
+	dlm_user_exit();
  out_debug:
 	dlm_unregister_debugfs();
  out_config:
@@ -68,6 +76,7 @@ static int __init init_dlm(void)
 
 static void __exit exit_dlm(void)
 {
+	dlm_netlink_exit();
 	dlm_user_exit();
 	dlm_config_exit();
 	dlm_memory_exit();
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 85e2897..f08faec 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -284,6 +284,9 @@ int dlm_ls_stop(struct dlm_ls *ls)
 	dlm_recoverd_suspend(ls);
 	ls->ls_recover_status = 0;
 	dlm_recoverd_resume(ls);
+
+	if (!ls->ls_recover_begin)
+		ls->ls_recover_begin = jiffies;
 	return 0;
 }
 
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
new file mode 100644
index 0000000..804b32c
--- /dev/null
+++ b/fs/dlm/netlink.c
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2007 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ */
+
+#include <net/genetlink.h>
+#include <linux/dlm.h>
+#include <linux/dlm_netlink.h>
+
+#include "dlm_internal.h"
+
+static uint32_t dlm_nl_seqnum;
+static uint32_t listener_nlpid;
+
+static struct genl_family family = {
+	.id		= GENL_ID_GENERATE,
+	.name		= DLM_GENL_NAME,
+	.version	= DLM_GENL_VERSION,
+};
+
+static int prepare_data(u8 cmd, struct sk_buff **skbp, size_t size)
+{
+	struct sk_buff *skb;
+	void *data;
+
+	skb = genlmsg_new(size, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	/* add the message headers */
+	data = genlmsg_put(skb, 0, dlm_nl_seqnum++, &family, 0, cmd);
+	if (!data) {
+		nlmsg_free(skb);
+		return -EINVAL;
+	}
+
+	*skbp = skb;
+	return 0;
+}
+
+static struct dlm_lock_data *mk_data(struct sk_buff *skb)
+{
+	struct nlattr *ret;
+
+	ret = nla_reserve(skb, DLM_TYPE_LOCK, sizeof(struct dlm_lock_data));
+	if (!ret)
+		return NULL;
+	return nla_data(ret);
+}
+
+static int send_data(struct sk_buff *skb)
+{
+	struct genlmsghdr *genlhdr = nlmsg_data((struct nlmsghdr *)skb->data);
+	void *data = genlmsg_data(genlhdr);
+	int rv;
+
+	rv = genlmsg_end(skb, data);
+	if (rv < 0) {
+		nlmsg_free(skb);
+		return rv;
+	}
+
+	return genlmsg_unicast(skb, listener_nlpid);
+}
+
+static int user_cmd(struct sk_buff *skb, struct genl_info *info)
+{
+	listener_nlpid = info->snd_pid;
+	printk("user_cmd nlpid %u\n", listener_nlpid);
+	return 0;
+}
+
+static struct genl_ops dlm_nl_ops = {
+	.cmd		= DLM_CMD_HELLO,
+	.doit		= user_cmd,
+};
+
+int dlm_netlink_init(void)
+{
+	int rv;
+
+	rv = genl_register_family(&family);
+	if (rv)
+		return rv;
+
+	rv = genl_register_ops(&family, &dlm_nl_ops);
+	if (rv < 0)
+		goto err;
+	return 0;
+ err:
+	genl_unregister_family(&family);
+	return rv;
+}
+
+void dlm_netlink_exit(void)
+{
+	genl_unregister_ops(&family, &dlm_nl_ops);
+	genl_unregister_family(&family);
+}
+
+static void fill_data(struct dlm_lock_data *data, struct dlm_lkb *lkb)
+{
+	struct dlm_rsb *r = lkb->lkb_resource;
+	struct dlm_user_args *ua = (struct dlm_user_args *) lkb->lkb_astparam;
+
+	memset(data, 0, sizeof(struct dlm_lock_data));
+
+	data->version = DLM_LOCK_DATA_VERSION;
+	data->nodeid = lkb->lkb_nodeid;
+	data->ownpid = lkb->lkb_ownpid;
+	data->id = lkb->lkb_id;
+	data->remid = lkb->lkb_remid;
+	data->status = lkb->lkb_status;
+	data->grmode = lkb->lkb_grmode;
+	data->rqmode = lkb->lkb_rqmode;
+	data->timestamp = lkb->lkb_timestamp;
+	if (ua)
+		data->xid = ua->xid;
+	if (r) {
+		data->lockspace_id = r->res_ls->ls_global_id;
+		data->resource_namelen = r->res_length;
+		memcpy(data->resource_name, r->res_name, r->res_length);
+	}
+}
+
+void dlm_timeout_warn(struct dlm_lkb *lkb)
+{
+	struct dlm_lock_data *data;
+	struct sk_buff *send_skb;
+	size_t size;
+	int rv;
+
+	log_debug(lkb->lkb_resource->res_ls, "timeout_warn %x", lkb->lkb_id);
+
+	size = nla_total_size(sizeof(struct dlm_lock_data)) +
+	       nla_total_size(0); /* why this? */
+
+	rv = prepare_data(DLM_CMD_TIMEOUT, &send_skb, size);
+	if (rv < 0)
+		return;
+
+	data = mk_data(send_skb);
+	if (!data) {
+		nlmsg_free(send_skb);
+		return;
+	}
+
+	fill_data(data, lkb);
+
+	send_data(send_skb);
+}
+
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 3cb636d..6657599 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -190,6 +190,8 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	dlm_clear_members_gone(ls);
 
+	dlm_adjust_timeouts(ls);
+
 	error = enable_locking(ls, rv->seq);
 	if (error) {
 		log_debug(ls, "enable_locking failed %d", error);
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index b0201ec..c7612da 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -348,7 +348,7 @@ static int device_create_lockspace(struct dlm_lspace_params *params)
 		return -EPERM;
 
 	error = dlm_new_lockspace(params->name, strlen(params->name),
-				  &lockspace, 0, DLM_USER_LVB_LEN);
+				  &lockspace, params->flags, DLM_USER_LVB_LEN);
 	if (error)
 		return error;
 
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index f317c27..afae306 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -49,6 +49,7 @@ header-y += consolemap.h
 header-y += const.h
 header-y += cycx_cfm.h
 header-y += dlm_device.h
+header-y += dlm_netlink.h
 header-y += dm-ioctl.h
 header-y += dn.h
 header-y += dqblk_v1.h
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index 1b1dcb9..975f17d 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -149,6 +149,7 @@
 #define DLM_LKF_ALTPR		0x00008000
 #define DLM_LKF_ALTCW		0x00010000
 #define DLM_LKF_FORCEUNLOCK	0x00020000
+#define DLM_LKF_TIMEOUT		0x00040000
 
 /*
  * Some return codes that are not in errno.h
@@ -199,11 +200,11 @@ struct dlm_lksb {
 	char *	 sb_lvbptr;
 };
 
+#define DLM_LSFL_NODIR		0x00000001
+#define DLM_LSFL_TIMEWARN	0x00000002
 
 #ifdef __KERNEL__
 
-#define DLM_LSFL_NODIR		0x00000001
-
 /*
  * dlm_new_lockspace
  *
diff --git a/include/linux/dlm_netlink.h b/include/linux/dlm_netlink.h
new file mode 100644
index 0000000..1927633
--- /dev/null
+++ b/include/linux/dlm_netlink.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2007 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ */
+
+#ifndef _DLM_NETLINK_H
+#define _DLM_NETLINK_H
+
+enum {
+	DLM_STATUS_WAITING = 1,
+	DLM_STATUS_GRANTED = 2,
+	DLM_STATUS_CONVERT = 3,
+};
+
+#define DLM_LOCK_DATA_VERSION 1
+
+struct dlm_lock_data {
+	uint16_t version;
+	uint32_t lockspace_id;
+	int nodeid;
+	int ownpid;
+	uint32_t id;
+	uint32_t remid;
+	uint64_t xid;
+	int8_t status;
+	int8_t grmode;
+	int8_t rqmode;
+	unsigned long timestamp;
+	int resource_namelen;
+	char resource_name[DLM_RESNAME_MAXLEN];
+};
+
+enum {
+	DLM_CMD_UNSPEC = 0,
+	DLM_CMD_HELLO,		/* user->kernel */
+	DLM_CMD_TIMEOUT,	/* kernel->user */
+	__DLM_CMD_MAX,
+};
+
+#define DLM_CMD_MAX (__DLM_CMD_MAX - 1)
+
+enum {
+	DLM_TYPE_UNSPEC = 0,
+	DLM_TYPE_LOCK,
+	__DLM_TYPE_MAX,
+};
+
+#define DLM_TYPE_MAX (__DLM_TYPE_MAX - 1)
+
+#define DLM_GENL_VERSION 0x1
+#define DLM_GENL_NAME "DLM"
+
+#endif /* _DLM_NETLINK_H */
-- 
1.5.1.2

