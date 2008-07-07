Return-Path: <linux-kernel-owner+w=401wt.eu-S1750804AbYGGS5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750804AbYGGS5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYGGS4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:56:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45742 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358AbYGGS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:56:52 -0400
Date: Mon, 7 Jul 2008 13:56:51 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 3/6] sgi-xp: move xpc_check_remote_hb() to support both SN2 and UV
Message-ID: <20080707185651.GD657@sgi.com>
References: <20080707185322.GA657@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707185322.GA657@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move xpc_check_remote_hb() so it can support both SN2 and UV.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xpc.h      |    2 -
 drivers/misc/sgi-xp/xpc_main.c |   34 +++++++++++++++++
 drivers/misc/sgi-xp/xpc_sn2.c  |   70 ++++++++++++-------------------------
 3 files changed, 57 insertions(+), 49 deletions(-)

Index: linux/drivers/misc/sgi-xp/xpc.h
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc.h	2008-06-24 09:19:06.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xpc.h	2008-06-24 09:19:17.000000000 -0500
@@ -632,7 +632,7 @@ extern void (*xpc_heartbeat_exit) (void)
 extern void (*xpc_increment_heartbeat) (void);
 extern void (*xpc_offline_heartbeat) (void);
 extern void (*xpc_online_heartbeat) (void);
-extern void (*xpc_check_remote_hb) (void);
+extern enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *);
 extern enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *);
 extern u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *);
 extern enum xp_retval (*xpc_allocate_msgqueues) (struct xpc_channel *);
Index: linux/drivers/misc/sgi-xp/xpc_main.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_main.c	2008-06-24 09:19:06.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xpc_main.c	2008-06-24 09:19:17.000000000 -0500
@@ -178,7 +178,7 @@ void (*xpc_heartbeat_exit) (void);
 void (*xpc_increment_heartbeat) (void);
 void (*xpc_offline_heartbeat) (void);
 void (*xpc_online_heartbeat) (void);
-void (*xpc_check_remote_hb) (void);
+enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *part);
 
 enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *part);
 void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *ch);
@@ -270,6 +270,38 @@ xpc_stop_hb_beater(void)
 }
 
 /*
+ * At periodic intervals, scan through all active partitions and ensure
+ * their heartbeat is still active.  If not, the partition is deactivated.
+ */
+static void
+xpc_check_remote_hb(void)
+{
+	struct xpc_partition *part;
+	short partid;
+	enum xp_retval ret;
+
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
+
+		if (xpc_exiting)
+			break;
+
+		if (partid == xp_partition_id)
+			continue;
+
+		part = &xpc_partitions[partid];
+
+		if (part->act_state == XPC_P_INACTIVE ||
+		    part->act_state == XPC_P_DEACTIVATING) {
+			continue;
+		}
+
+		ret = xpc_get_remote_heartbeat(part);
+		if (ret != xpSuccess)
+			XPC_DEACTIVATE_PARTITION(part, ret);
+	}
+}
+
+/*
  * This thread is responsible for nearly all of the partition
  * activation/deactivation.
  */
Index: linux/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_sn2.c	2008-06-24 09:19:06.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xpc_sn2.c	2008-06-24 09:25:03.000000000 -0500
@@ -704,61 +704,37 @@ xpc_heartbeat_exit_sn2(void)
 	xpc_offline_heartbeat_sn2();
 }
 
-/*
- * At periodic intervals, scan through all active partitions and ensure
- * their heartbeat is still active.  If not, the partition is deactivated.
- */
-static void
-xpc_check_remote_hb_sn2(void)
+static enum xp_retval
+xpc_get_remote_heartbeat_sn2(struct xpc_partition *part)
 {
 	struct xpc_vars_sn2 *remote_vars;
-	struct xpc_partition *part;
-	short partid;
 	enum xp_retval ret;
 
 	remote_vars = (struct xpc_vars_sn2 *)xpc_remote_copy_buffer_sn2;
 
-	for (partid = 0; partid < XP_MAX_NPARTITIONS_SN2; partid++) {
-
-		if (xpc_exiting)
-			break;
-
-		if (partid == sn_partition_id)
-			continue;
-
-		part = &xpc_partitions[partid];
-
-		if (part->act_state == XPC_P_INACTIVE ||
-		    part->act_state == XPC_P_DEACTIVATING) {
-			continue;
-		}
-
-		/* pull the remote_hb cache line */
-		ret = xp_remote_memcpy(xp_pa(remote_vars),
-				       part->sn.sn2.remote_vars_pa,
-				       XPC_RP_VARS_SIZE);
-		if (ret != xpSuccess) {
-			XPC_DEACTIVATE_PARTITION(part, ret);
-			continue;
-		}
-
-		dev_dbg(xpc_part, "partid = %d, heartbeat = %ld, last_heartbeat"
-			" = %ld, heartbeat_offline = %ld, HB_mask[0] = 0x%lx\n",
-			partid, remote_vars->heartbeat, part->last_heartbeat,
-			remote_vars->heartbeat_offline,
-			remote_vars->heartbeating_to_mask[0]);
-
-		if (((remote_vars->heartbeat == part->last_heartbeat) &&
-		     (remote_vars->heartbeat_offline == 0)) ||
-		    !xpc_hb_allowed(sn_partition_id,
-				    &remote_vars->heartbeating_to_mask)) {
-
-			XPC_DEACTIVATE_PARTITION(part, xpNoHeartbeat);
-			continue;
-		}
+	/* pull the remote vars structure that contains the heartbeat */
+	ret = xp_remote_memcpy(xp_pa(remote_vars),
+			       part->sn.sn2.remote_vars_pa,
+			       XPC_RP_VARS_SIZE);
+	if (ret != xpSuccess)
+		return ret;
 
+	dev_dbg(xpc_part, "partid=%d, heartbeat=%ld, last_heartbeat=%ld, "
+		"heartbeat_offline=%ld, HB_mask[0]=0x%lx\n", XPC_PARTID(part),
+		remote_vars->heartbeat, part->last_heartbeat,
+		remote_vars->heartbeat_offline,
+		remote_vars->heartbeating_to_mask[0]);
+
+	if ((remote_vars->heartbeat == part->last_heartbeat &&
+	    remote_vars->heartbeat_offline == 0) ||
+	    !xpc_hb_allowed(sn_partition_id,
+			    &remote_vars->heartbeating_to_mask)) {
+		ret = xpNoHeartbeat;
+	} else {
 		part->last_heartbeat = remote_vars->heartbeat;
 	}
+
+	return ret;
 }
 
 /*
@@ -2416,7 +2392,7 @@ xpc_init_sn2(void)
 	xpc_online_heartbeat = xpc_online_heartbeat_sn2;
 	xpc_heartbeat_init = xpc_heartbeat_init_sn2;
 	xpc_heartbeat_exit = xpc_heartbeat_exit_sn2;
-	xpc_check_remote_hb = xpc_check_remote_hb_sn2;
+	xpc_get_remote_heartbeat = xpc_get_remote_heartbeat_sn2;
 
 	xpc_request_partition_activation = xpc_request_partition_activation_sn2;
 	xpc_request_partition_reactivation =
