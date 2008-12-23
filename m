Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbYLWQPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbYLWQPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYLWQNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48924 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYLWQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:04 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] dlm: change lock time stamping
Date: Tue, 23 Dec 2008 10:58:40 -0600
Message-Id: <1230051523-5478-8-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ktime instead of jiffies for timestamping lkb's.  Also stamp the
time on every lkb whenever it's added to a resource queue, instead of
just stamping locks subject to timeouts.  This will allow us to use
timestamps more widely for debugging all locks.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/debug_fs.c     |   14 +++++++-------
 fs/dlm/dlm_internal.h |    2 +-
 fs/dlm/lock.c         |   21 +++++++++++----------
 fs/dlm/netlink.c      |    1 -
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 8fc24f4..19e4f9e 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -162,21 +162,21 @@ static int print_resource(struct dlm_rsb *res, struct seq_file *s)
 
 static void print_lock(struct seq_file *s, struct dlm_lkb *lkb, struct dlm_rsb *r)
 {
-	unsigned int waiting = 0;
-	uint64_t xid = 0;
+	u64 xid = 0;
+	u64 us;
 
 	if (lkb->lkb_flags & DLM_IFL_USER) {
 		if (lkb->lkb_ua)
 			xid = lkb->lkb_ua->xid;
 	}
 
-	if (lkb->lkb_timestamp)
-		waiting = jiffies_to_msecs(jiffies - lkb->lkb_timestamp);
+	/* microseconds since lkb was added to current queue */
+	us = ktime_to_us(ktime_sub(ktime_get(), lkb->lkb_timestamp));
 
-	/* id nodeid remid pid xid exflags flags sts grmode rqmode time_ms
+	/* id nodeid remid pid xid exflags flags sts grmode rqmode time_us
 	   r_nodeid r_len r_name */
 
-	seq_printf(s, "%x %d %x %u %llu %x %x %d %d %d %u %u %d \"%s\"\n",
+	seq_printf(s, "%x %d %x %u %llu %x %x %d %d %d %llu %u %d \"%s\"\n",
 		   lkb->lkb_id,
 		   lkb->lkb_nodeid,
 		   lkb->lkb_remid,
@@ -187,7 +187,7 @@ static void print_lock(struct seq_file *s, struct dlm_lkb *lkb, struct dlm_rsb *
 		   lkb->lkb_status,
 		   lkb->lkb_grmode,
 		   lkb->lkb_rqmode,
-		   waiting,
+		   (unsigned long long)us,
 		   r->res_nodeid,
 		   r->res_length,
 		   r->res_name);
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 868e4c9..e69135c 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -245,7 +245,7 @@ struct dlm_lkb {
 	struct list_head	lkb_astqueue;	/* need ast to be sent */
 	struct list_head	lkb_ownqueue;	/* list of locks for a process */
 	struct list_head	lkb_time_list;
-	unsigned long		lkb_timestamp;
+	ktime_t			lkb_timestamp;
 	unsigned long		lkb_timeout_cs;
 
 	char			*lkb_lvbptr;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 7b758da..dfc57ae 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -742,6 +742,8 @@ static void add_lkb(struct dlm_rsb *r, struct dlm_lkb *lkb, int status)
 
 	DLM_ASSERT(!lkb->lkb_status, dlm_print_lkb(lkb););
 
+	lkb->lkb_timestamp = ktime_get();
+
 	lkb->lkb_status = status;
 
 	switch (status) {
@@ -1011,10 +1013,8 @@ static void add_timeout(struct dlm_lkb *lkb)
 {
 	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 
-	if (is_master_copy(lkb)) {
-		lkb->lkb_timestamp = jiffies;
+	if (is_master_copy(lkb))
 		return;
-	}
 
 	if (test_bit(LSFL_TIMEWARN, &ls->ls_flags) &&
 	    !(lkb->lkb_exflags & DLM_LKF_NODLCKWT)) {
@@ -1029,7 +1029,6 @@ static void add_timeout(struct dlm_lkb *lkb)
 	DLM_ASSERT(list_empty(&lkb->lkb_time_list), dlm_print_lkb(lkb););
 	mutex_lock(&ls->ls_timeout_mutex);
 	hold_lkb(lkb);
-	lkb->lkb_timestamp = jiffies;
 	list_add_tail(&lkb->lkb_time_list, &ls->ls_timeout);
 	mutex_unlock(&ls->ls_timeout_mutex);
 }
@@ -1057,6 +1056,7 @@ void dlm_scan_timeout(struct dlm_ls *ls)
 	struct dlm_rsb *r;
 	struct dlm_lkb *lkb;
 	int do_cancel, do_warn;
+	s64 wait_us;
 
 	for (;;) {
 		if (dlm_locking_stopped(ls))
@@ -1067,14 +1067,15 @@ void dlm_scan_timeout(struct dlm_ls *ls)
 		mutex_lock(&ls->ls_timeout_mutex);
 		list_for_each_entry(lkb, &ls->ls_timeout, lkb_time_list) {
 
+			wait_us = ktime_to_us(ktime_sub(ktime_get(),
+					      		lkb->lkb_timestamp));
+
 			if ((lkb->lkb_exflags & DLM_LKF_TIMEOUT) &&
-			    time_after_eq(jiffies, lkb->lkb_timestamp +
-					  lkb->lkb_timeout_cs * HZ/100))
+			    wait_us >= (lkb->lkb_timeout_cs * 10000))
 				do_cancel = 1;
 
 			if ((lkb->lkb_flags & DLM_IFL_WATCH_TIMEWARN) &&
-			    time_after_eq(jiffies, lkb->lkb_timestamp +
-				   	   dlm_config.ci_timewarn_cs * HZ/100))
+			    wait_us >= dlm_config.ci_timewarn_cs * 10000)
 				do_warn = 1;
 
 			if (!do_cancel && !do_warn)
@@ -1120,12 +1121,12 @@ void dlm_scan_timeout(struct dlm_ls *ls)
 void dlm_adjust_timeouts(struct dlm_ls *ls)
 {
 	struct dlm_lkb *lkb;
-	long adj = jiffies - ls->ls_recover_begin;
+	u64 adj_us = jiffies_to_usecs(jiffies - ls->ls_recover_begin);
 
 	ls->ls_recover_begin = 0;
 	mutex_lock(&ls->ls_timeout_mutex);
 	list_for_each_entry(lkb, &ls->ls_timeout, lkb_time_list)
-		lkb->lkb_timestamp += adj;
+		lkb->lkb_timestamp = ktime_add_us(lkb->lkb_timestamp, adj_us);
 	mutex_unlock(&ls->ls_timeout_mutex);
 }
 
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 18bda83..46e582c 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -115,7 +115,6 @@ static void fill_data(struct dlm_lock_data *data, struct dlm_lkb *lkb)
 	data->status = lkb->lkb_status;
 	data->grmode = lkb->lkb_grmode;
 	data->rqmode = lkb->lkb_rqmode;
-	data->timestamp = lkb->lkb_timestamp;
 	if (lkb->lkb_ua)
 		data->xid = lkb->lkb_ua->xid;
 	if (r) {
-- 
1.5.5.1

