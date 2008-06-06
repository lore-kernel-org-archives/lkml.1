Return-Path: <linux-kernel-owner+w=401wt.eu-S1765373AbYFFQw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765373AbYFFQw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYFFQwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:52:18 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35145 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753241AbYFFQwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:52:17 -0400
Date: Fri, 6 Jun 2008 11:52:16 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 09/18] base xpc_rsvd_page's timestamp on jiffies
Message-ID: <20080606165216.GJ13695@sgi.com>
References: <20080606164034.GA13695@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606164034.GA13695@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change XPC's reserved page timestamp to be based on jiffies.

Signed-off-by: Dean Nelson <dcn@sgi.com>

 drivers/misc/sgi-xp/xpc.h           |   26 ++-----------------------
 drivers/misc/sgi-xp/xpc_main.c      |   16 +++++++--------
 drivers/misc/sgi-xp/xpc_partition.c |   33 ++++++++++++++++----------------
 drivers/misc/sgi-xp/xpc_sn2.c       |   16 +++++----------
 4 files changed, 34 insertions(+), 57 deletions(-)

Index: linux-2.6/drivers/misc/sgi-xp/xpc.h
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc.h	2008-06-02 07:08:34.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc.h	2008-06-02 07:10:00.361526785 -0500
@@ -115,8 +115,8 @@ struct xpc_rsvd_page {
 		u64 vars_pa;	/* physical address of struct xpc_vars */
 		u64 activate_mq_gpa;	/* global phys address of activate_mq */
 	} sn;
-	struct timespec stamp;	/* time when reserved page was setup by XPC */
-	u64 pad2[9];		/* align to last u64 in 2nd 64-byte cacheline */
+	unsigned long stamp;	/* time when reserved page was setup by XPC */
+	u64 pad2[10];		/* align to last u64 in 2nd 64-byte cacheline */
 	u64 SAL_nasids_size;	/* SAL: size of each nasid mask in bytes */
 };
 
@@ -125,26 +125,6 @@ struct xpc_rsvd_page {
 #define XPC_SUPPORTS_RP_STAMP(_version) \
 			(_version >= _XPC_VERSION(1, 1))
 
-#define ZERO_STAMP	((struct timespec){0, 0})
-/*
- * compare stamps - the return value is:
- *
- *	< 0,	if stamp1 < stamp2
- *	= 0,	if stamp1 == stamp2
- *	> 0,	if stamp1 > stamp2
- */
-static inline int
-xpc_compare_stamps(struct timespec *stamp1, struct timespec *stamp2)
-{
-	int ret;
-
-	ret = stamp1->tv_sec - stamp2->tv_sec;
-	if (ret == 0)
-		ret = stamp1->tv_nsec - stamp2->tv_nsec;
-
-	return ret;
-}
-
 /*
  * Define the structures by which XPC variables can be exported to other
  * partitions. (There are two: struct xpc_vars and struct xpc_vars_part)
@@ -492,7 +472,7 @@ struct xpc_partition {
 	/* XPC HB infrastructure */
 
 	u8 remote_rp_version;	/* version# of partition's rsvd pg */
-	struct timespec remote_rp_stamp; /* time when rsvd pg was initialized */
+	unsigned long remote_rp_stamp; /* time when rsvd pg was initialized */
 	u64 remote_rp_pa;	/* phys addr of partition's rsvd pg */
 	u64 remote_vars_pa;	/* phys addr of partition's vars */
 	u64 remote_vars_part_pa;	/* phys addr of partition's vars part */
Index: linux-2.6/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc_sn2.c	2008-06-02 07:08:34.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc_sn2.c	2008-06-02 07:09:09.923429772 -0500
@@ -597,8 +597,8 @@ xpc_initiate_partition_activation_sn2(st
  */
 static void
 xpc_update_partition_info_sn2(struct xpc_partition *part, u8 remote_rp_version,
-			      struct timespec *remote_rp_stamp,
-			      u64 remote_rp_pa, u64 remote_vars_pa,
+			      unsigned long *remote_rp_stamp, u64 remote_rp_pa,
+			      u64 remote_vars_pa,
 			      struct xpc_vars_sn2 *remote_vars)
 {
 	part->remote_rp_version = remote_rp_version;
@@ -606,8 +606,8 @@ xpc_update_partition_info_sn2(struct xpc
 		part->remote_rp_version);
 
 	part->remote_rp_stamp = *remote_rp_stamp;
-	dev_dbg(xpc_part, "  remote_rp_stamp (tv_sec = 0x%lx tv_nsec = 0x%lx\n",
-		part->remote_rp_stamp.tv_sec, part->remote_rp_stamp.tv_nsec);
+	dev_dbg(xpc_part, "  remote_rp_stamp = 0x%016lx\n",
+		part->remote_rp_stamp);
 
 	part->remote_rp_pa = remote_rp_pa;
 	dev_dbg(xpc_part, "  remote_rp_pa = 0x%016lx\n", part->remote_rp_pa);
@@ -664,8 +664,7 @@ xpc_identify_act_IRQ_req_sn2(int nasid)
 	u64 remote_vars_pa;
 	int remote_rp_version;
 	int reactivate = 0;
-	int stamp_diff;
-	struct timespec remote_rp_stamp = { 0, 0 }; /*>>> ZERO_STAMP */
+	unsigned long remote_rp_stamp = 0;
 	short partid;
 	struct xpc_partition *part;
 	enum xp_retval ret;
@@ -788,10 +787,7 @@ xpc_identify_act_IRQ_req_sn2(int nasid)
 	} else {
 		DBUG_ON(!XPC_SUPPORTS_DISENGAGE_REQUEST(remote_vars->version));
 
-		stamp_diff = xpc_compare_stamps(&part->remote_rp_stamp,
-						&remote_rp_stamp);
-		if (stamp_diff != 0) {
-			DBUG_ON(stamp_diff >= 0);
+		if (remote_rp_stamp != part->remote_rp_stamp) {
 
 			/*
 			 * Other side rebooted and the previous XPC did support
Index: linux-2.6/drivers/misc/sgi-xp/xpc_main.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc_main.c	2008-06-02 07:08:34.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc_main.c	2008-06-02 07:09:09.943432190 -0500
@@ -233,7 +233,7 @@ xpc_timeout_partition_disengage_request(
 {
 	struct xpc_partition *part = (struct xpc_partition *)data;
 
-	DBUG_ON(time_before(jiffies, part->disengage_request_timeout));
+	DBUG_ON(time_is_after_jiffies(part->disengage_request_timeout));
 
 	(void)xpc_partition_disengaged(part);
 
@@ -262,7 +262,7 @@ xpc_hb_beater(unsigned long dummy)
 {
 	xpc_increment_heartbeat();
 
-	if (time_after_eq(jiffies, xpc_hb_check_timeout))
+	if (time_is_before_eq_jiffies(xpc_hb_check_timeout))
 		wake_up_interruptible(&xpc_act_IRQ_wq);
 
 	xpc_hb_timer.expires = jiffies + (xpc_hb_interval * HZ);
@@ -312,7 +312,7 @@ xpc_hb_checker(void *ignore)
 			atomic_read(&xpc_act_IRQ_rcvd) - last_IRQ_count);
 
 		/* checking of remote heartbeats is skewed by IRQ handling */
-		if (time_after_eq(jiffies, xpc_hb_check_timeout)) {
+		if (time_is_before_eq_jiffies(xpc_hb_check_timeout)) {
 			dev_dbg(xpc_part, "checking remote heartbeats\n");
 			xpc_check_remote_hb();
 
@@ -344,8 +344,8 @@ xpc_hb_checker(void *ignore)
 		(void)wait_event_interruptible(xpc_act_IRQ_wq,
 					       (last_IRQ_count <
 						atomic_read(&xpc_act_IRQ_rcvd)
-						|| time_after_eq(jiffies,
-							xpc_hb_check_timeout) ||
+						|| time_is_before_eq_jiffies(
+						xpc_hb_check_timeout) ||
 						xpc_exiting));
 	}
 
@@ -929,7 +929,7 @@ xpc_do_exit(enum xp_retval reason)
 		}
 
 		if (xpc_partition_engaged(-1UL)) {
-			if (time_after(jiffies, printmsg_time)) {
+			if (time_is_before_jiffies(printmsg_time)) {
 				dev_info(xpc_part, "waiting for remote "
 					 "partitions to disengage, timeout in "
 					 "%ld seconds\n",
@@ -964,7 +964,7 @@ xpc_do_exit(enum xp_retval reason)
 	DBUG_ON(xpc_any_hbs_allowed() != 0);
 
 	/* indicate to others that our reserved page is uninitialized */
-	xpc_rsvd_page->stamp = ZERO_STAMP;
+	xpc_rsvd_page->stamp = 0;
 
 	if (reason == xpUnloading) {
 		(void)unregister_die_notifier(&xpc_die_notifier);
@@ -1295,7 +1295,7 @@ xpc_init(void)
 	/* initialization was not successful */
 out_4:
 	/* indicate to others that our reserved page is uninitialized */
-	xpc_rsvd_page->stamp = ZERO_STAMP;
+	xpc_rsvd_page->stamp = 0;
 
 	(void)unregister_die_notifier(&xpc_die_notifier);
 	(void)unregister_reboot_notifier(&xpc_reboot_notifier);
Index: linux-2.6/drivers/misc/sgi-xp/xpc_partition.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc_partition.c	2008-06-02 07:08:34.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc_partition.c	2008-06-02 07:09:09.959434124 -0500
@@ -152,6 +152,7 @@ xpc_setup_rsvd_page(void)
 {
 	struct xpc_rsvd_page *rp;
 	u64 rp_pa;
+	unsigned long new_stamp;
 
 	/* get the local reserved page's address */
 
@@ -201,7 +202,10 @@ xpc_setup_rsvd_page(void)
 	 * This signifies to the remote partition that our reserved
 	 * page is initialized.
 	 */
-	rp->stamp = CURRENT_TIME;
+	new_stamp = jiffies;
+	if (new_stamp == 0 || new_stamp == rp->stamp)
+		new_stamp++;
+	rp->stamp = new_stamp;
 
 	return rp;
 }
@@ -350,18 +354,8 @@ xpc_get_remote_rp(int nasid, u64 *discov
 			discovered_nasids[i] |= remote_part_nasids[i];
 	}
 
-	/* check that the partid is valid and is for another partition */
-
-	if (remote_rp->SAL_partid < 0 ||
-	    remote_rp->SAL_partid >= xp_max_npartitions) {
-		return xpInvalidPartid;
-	}
-
-	if (remote_rp->SAL_partid == sn_partition_id)
-		return xpLocalPartid;
-
-	/* see if the rest of the reserved page has been set up by XPC */
-	if (timespec_equal(&remote_rp->stamp, &ZERO_STAMP))
+	/* see if the reserved page has been set up by XPC */
+	if (remote_rp->stamp == 0)
 		return xpRsvdPageNotSet;
 
 	if (XPC_VERSION_MAJOR(remote_rp->version) !=
@@ -369,8 +363,15 @@ xpc_get_remote_rp(int nasid, u64 *discov
 		return xpBadVersion;
 	}
 
-	if (remote_rp->max_npartitions <= sn_partition_id)
+	/* check that both local and remote partids are valid for each side */
+	if (remote_rp->SAL_partid < 0 ||
+	    remote_rp->SAL_partid >= xp_max_npartitions ||
+	    remote_rp->max_npartitions <= sn_partition_id) {
 		return xpInvalidPartid;
+	}
+
+	if (remote_rp->SAL_partid == sn_partition_id)
+		return xpLocalPartid;
 
 	return xpSuccess;
 }
@@ -388,8 +389,8 @@ xpc_partition_disengaged(struct xpc_part
 	disengaged = (xpc_partition_engaged(1UL << partid) == 0);
 	if (part->disengage_request_timeout) {
 		if (!disengaged) {
-			if (time_before(jiffies,
-			    part->disengage_request_timeout)) {
+			if (time_is_after_jiffies(part->
+						  disengage_request_timeout)) {
 				/* timelimit hasn't been reached yet */
 				return 0;
 			}
