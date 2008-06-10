Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYFJQbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYFJQbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYFJQbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:31:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48620 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752535AbYFJQbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:31:42 -0400
Date: Tue, 10 Jun 2008 11:31:41 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 3/3] sgi-xp: add 'jiffies' to reserved page's timestamp name
Message-ID: <20080610163141.GD12985@sgi.com>
References: <20080610162436.GA12985@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610162436.GA12985@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename XPC's reserved page's timestamp member to reflect the units of time
involved.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

On Sun, Jun 08, 2008 at 05:15:37PM -0700, Andrew Morton wrote:
> On Fri, 6 Jun 2008 11:52:16 -0500 Dean Nelson <dcn@sgi.com> wrote:
> 
> > +   unsigned long stamp;    /* time when reserved page was setup by XPC */
> 
> "time" is a rubbery concept in-kernel.  What are the units of this? 
> microseconds?  jiffies?  seconds?
> 
> At the least, the covering comment should make clear what units this
> variable is using.  Better would be to actually embed the units in the
> variable's identifier.  Because it's awfulyl easy to make mistakes over
> this, and not knowing the units makes the code harder to follow.

Agreed. Thanks for the feedback.

Dean

 drivers/misc/sgi-xp/xpc.h           |    6 +++---
 drivers/misc/sgi-xp/xpc_main.c      |    8 ++++----
 drivers/misc/sgi-xp/xpc_partition.c |   14 +++++++-------
 drivers/misc/sgi-xp/xpc_sn2.c       |   26 ++++++++++++++------------
 4 files changed, 28 insertions(+), 26 deletions(-)

Index: linux-next/drivers/misc/sgi-xp/xpc.h
===================================================================
--- linux-next.orig/drivers/misc/sgi-xp/xpc.h	2008-06-10 10:17:06.091909005 -0500
+++ linux-next/drivers/misc/sgi-xp/xpc.h	2008-06-10 10:17:12.688730757 -0500
@@ -87,7 +87,7 @@
  *     which are partition specific (vars part). These are setup by XPC.
  *     (Local partition's vars pointers are xpc_vars and xpc_vars_part.)
  *
- * Note: Until 'stamp' is set non-zero, the partition XPC code has not been
+ * Note: Until 'ts_jiffies' is set non-zero, the partition XPC code has not been
  *       initialized.
  */
 struct xpc_rsvd_page {
@@ -101,7 +101,7 @@ struct xpc_rsvd_page {
 		u64 vars_pa;	/* physical address of struct xpc_vars */
 		u64 activate_mq_gpa;	/* global phys address of activate_mq */
 	} sn;
-	unsigned long stamp;	/* time when reserved page was setup by XPC */
+	unsigned long ts_jiffies; /* timestamp when rsvd pg was setup by XPC */
 	u64 pad2[10];		/* align to last u64 in 2nd 64-byte cacheline */
 	u64 SAL_nasids_size;	/* SAL: size of each nasid mask in bytes */
 };
@@ -534,7 +534,7 @@ struct xpc_partition {
 	/* XPC HB infrastructure */
 
 	u8 remote_rp_version;	/* version# of partition's rsvd pg */
-	unsigned long remote_rp_stamp; /* time when rsvd pg was initialized */
+	unsigned long remote_rp_ts_jiffies; /* timestamp when rsvd pg setup */
 	u64 remote_rp_pa;	/* phys addr of partition's rsvd pg */
 	u64 last_heartbeat;	/* HB at last read */
 	u32 activate_IRQ_rcvd;	/* IRQs since activation */
Index: linux-next/drivers/misc/sgi-xp/xpc_main.c
===================================================================
--- linux-next.orig/drivers/misc/sgi-xp/xpc_main.c	2008-06-10 10:16:48.593729274 -0500
+++ linux-next/drivers/misc/sgi-xp/xpc_main.c	2008-06-10 10:17:12.812746205 -0500
@@ -862,8 +862,8 @@ xpc_do_exit(enum xp_retval reason)
 	DBUG_ON(xpc_any_partition_engaged());
 	DBUG_ON(xpc_any_hbs_allowed() != 0);
 
-	/* indicate to others that our reserved page is uninitialized */
-	xpc_rsvd_page->stamp = 0;
+	/* a zero timestamp indicates our rsvd page is not initialized */
+	xpc_rsvd_page->ts_jiffies = 0;
 
 	if (reason == xpUnloading) {
 		(void)unregister_die_notifier(&xpc_die_notifier);
@@ -1152,8 +1152,8 @@ xpc_init(void)
 
 	/* initialization was not successful */
 out_3:
-	/* indicate to others that our reserved page is uninitialized */
-	xpc_rsvd_page->stamp = 0;
+	/* a zero timestamp indicates our rsvd page is not initialized */
+	xpc_rsvd_page->ts_jiffies = 0;
 
 	(void)unregister_die_notifier(&xpc_die_notifier);
 	(void)unregister_reboot_notifier(&xpc_reboot_notifier);
Index: linux-next/drivers/misc/sgi-xp/xpc_partition.c
===================================================================
--- linux-next.orig/drivers/misc/sgi-xp/xpc_partition.c	2008-06-10 10:17:06.071906513 -0500
+++ linux-next/drivers/misc/sgi-xp/xpc_partition.c	2008-06-10 10:17:12.976766637 -0500
@@ -133,7 +133,7 @@ xpc_setup_rsvd_page(void)
 {
 	struct xpc_rsvd_page *rp;
 	u64 rp_pa;
-	unsigned long new_stamp;
+	unsigned long new_ts_jiffies;
 
 	/* get the local reserved page's address */
 
@@ -183,10 +183,10 @@ xpc_setup_rsvd_page(void)
 	 * This signifies to the remote partition that our reserved
 	 * page is initialized.
 	 */
-	new_stamp = jiffies;
-	if (new_stamp == 0 || new_stamp == rp->stamp)
-		new_stamp++;
-	rp->stamp = new_stamp;
+	new_ts_jiffies = jiffies;
+	if (new_ts_jiffies == 0 || new_ts_jiffies == rp->ts_jiffies)
+		new_ts_jiffies++;
+	rp->ts_jiffies = new_ts_jiffies;
 
 	return rp;
 }
@@ -225,8 +225,8 @@ xpc_get_remote_rp(int nasid, unsigned lo
 			discovered_nasids[l] |= remote_part_nasids[l];
 	}
 
-	/* see if the reserved page has been set up by XPC */
-	if (remote_rp->stamp == 0)
+	/* zero timestamp indicates the reserved page has not been setup */
+	if (remote_rp->ts_jiffies == 0)
 		return xpRsvdPageNotSet;
 
 	if (XPC_VERSION_MAJOR(remote_rp->version) !=
Index: linux-next/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- linux-next.orig/drivers/misc/sgi-xp/xpc_sn2.c	2008-06-10 10:17:06.095909503 -0500
+++ linux-next/drivers/misc/sgi-xp/xpc_sn2.c	2008-06-10 10:17:13.000769626 -0500
@@ -863,8 +863,8 @@ xpc_partition_deactivation_requested_sn2
  */
 static void
 xpc_update_partition_info_sn2(struct xpc_partition *part, u8 remote_rp_version,
-			      unsigned long *remote_rp_stamp, u64 remote_rp_pa,
-			      u64 remote_vars_pa,
+			      unsigned long *remote_rp_ts_jiffies,
+			      u64 remote_rp_pa, u64 remote_vars_pa,
 			      struct xpc_vars_sn2 *remote_vars)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
@@ -873,9 +873,9 @@ xpc_update_partition_info_sn2(struct xpc
 	dev_dbg(xpc_part, "  remote_rp_version = 0x%016x\n",
 		part->remote_rp_version);
 
-	part->remote_rp_stamp = *remote_rp_stamp;
-	dev_dbg(xpc_part, "  remote_rp_stamp = 0x%016lx\n",
-		part->remote_rp_stamp);
+	part->remote_rp_ts_jiffies = *remote_rp_ts_jiffies;
+	dev_dbg(xpc_part, "  remote_rp_ts_jiffies = 0x%016lx\n",
+		part->remote_rp_ts_jiffies);
 
 	part->remote_rp_pa = remote_rp_pa;
 	dev_dbg(xpc_part, "  remote_rp_pa = 0x%016lx\n", part->remote_rp_pa);
@@ -933,7 +933,7 @@ xpc_identify_activate_IRQ_req_sn2(int na
 	u64 remote_vars_pa;
 	int remote_rp_version;
 	int reactivate = 0;
-	unsigned long remote_rp_stamp = 0;
+	unsigned long remote_rp_ts_jiffies = 0;
 	short partid;
 	struct xpc_partition *part;
 	struct xpc_partition_sn2 *part_sn2;
@@ -952,7 +952,7 @@ xpc_identify_activate_IRQ_req_sn2(int na
 
 	remote_vars_pa = remote_rp->sn.vars_pa;
 	remote_rp_version = remote_rp->version;
-	remote_rp_stamp = remote_rp->stamp;
+	remote_rp_ts_jiffies = remote_rp->ts_jiffies;
 
 	partid = remote_rp->SAL_partid;
 	part = &xpc_partitions[partid];
@@ -981,8 +981,9 @@ xpc_identify_activate_IRQ_req_sn2(int na
 	    part->act_state == XPC_P_INACTIVE) {
 
 		xpc_update_partition_info_sn2(part, remote_rp_version,
-					      &remote_rp_stamp, remote_rp_pa,
-					      remote_vars_pa, remote_vars);
+					      &remote_rp_ts_jiffies,
+					      remote_rp_pa, remote_vars_pa,
+					      remote_vars);
 
 		if (xpc_partition_deactivation_requested_sn2(partid)) {
 			/*
@@ -999,7 +1000,7 @@ xpc_identify_activate_IRQ_req_sn2(int na
 	DBUG_ON(part->remote_rp_version == 0);
 	DBUG_ON(part_sn2->remote_vars_version == 0);
 
-	if (remote_rp_stamp != part->remote_rp_stamp) {
+	if (remote_rp_ts_jiffies != part->remote_rp_ts_jiffies) {
 
 		/* the other side rebooted */
 
@@ -1007,8 +1008,9 @@ xpc_identify_activate_IRQ_req_sn2(int na
 		DBUG_ON(xpc_partition_deactivation_requested_sn2(partid));
 
 		xpc_update_partition_info_sn2(part, remote_rp_version,
-					      &remote_rp_stamp, remote_rp_pa,
-					      remote_vars_pa, remote_vars);
+					      &remote_rp_ts_jiffies,
+					      remote_rp_pa, remote_vars_pa,
+					      remote_vars);
 		reactivate = 1;
 	}
 
