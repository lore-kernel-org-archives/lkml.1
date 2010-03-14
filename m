Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab0CNJTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 05:19:00 -0400
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:41945 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756542Ab0CNJSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 05:18:53 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Mar 2010 05:18:53 EDT
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 0dJxdk8VM1lxxphW69dJxseYYy9_8YqL92r5u.07e_mrf7m7C9rEIyZkXwhlXc6AUG1zx5sL7coMVH7cGnBvBKH_5O.T6TeMwgr23JdsGLT4deDuQ6JyrW_ymIjVfRvTmv_FLMeEN7KHdBDvzW2MqCVjmBECWTJaRn75I6bR0AnRLVmScnmdja12103YaJXV8Fo3Bxnvd5hXW3yyqKUj9pWKUQup31OK2RGStNk3wr4RcNZGGSDXsXzCJiVxpcBCGyd9YDaou3eR1tOZ6n67lhLodzsQJLWRQemf_hhZdwZwfi3NgEesSfbLcM4oSf6yvYOkKenessee06zNtWKMtyEYcQDK99Ft2WLb7cnRq6n21A--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>,
       Douglas Gilbert <dgilbert@interlog.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
       Joe Eykholt <jeykholt@cisco.com>,
       James Bottomley <James.Bottomley@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/3] [TCM/PR]: Convert REGISTER_AND_MOVE use new configfs dependency wrappers
Date: Sun, 14 Mar 2010 01:17:52 -0800
Message-Id: <1268558272-10784-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts core_scsi3_emulate_pro_register_and_move() to use
the new demo-mode safe configfs dependency wrappers in 9c8e057ee5 instead of
using direct calls to configfs_depend_item() and configfs_undepend_item() which
originally require explict NodeACLs for REGISTER_AND_MOVE to function.

This patch also adds the *pr_ref_count + 1 references for TPG, NodeACL and MappedLUN
structures used by REGISTER_AND_MOVE, which are dropped when REGISTER_AND_MOVE
is complete by core_scsi3_tpg_undepend_item(), core_scsi3_nodeacl_undepend_item() and
core_scsi3_lunacl_undepend_item() respectively.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |   62 +++++++++++++++++++++++---------------
 1 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 03f40e3..6211d59 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2842,7 +2842,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	unsigned char *initiator_str;
 	char *iport_ptr = NULL, dest_iport[64];
-	u32 tid_len;
+	u32 tid_len, tmp_tid_len;
 	int new_reg = 0, type, scope, ret;
 	unsigned short rtpi;
 	unsigned char proto_ident;
@@ -2923,13 +2923,17 @@ static int core_scsi3_emulate_pro_register_and_move(
 		dest_tf_ops = TPG_TFO(dest_se_tpg);
 		if (!(dest_tf_ops))
 			continue;
+
+		atomic_inc(&dest_se_tpg->tpg_pr_ref_count);
+		smp_mb__after_atomic_inc();
 		spin_unlock(&dev->se_port_lock);
 
-		ret = configfs_depend_item(dest_tf_ops->tf_subsys,
-				&dest_se_tpg->tpg_group.cg_item);
+		ret = core_scsi3_tpg_depend_item(dest_se_tpg);
 		if (ret != 0) {
-			printk(KERN_ERR "configfs_depend_item() failed for"
-				" dest_se_tpg->tpg_group\n");
+			printk(KERN_ERR "core_scsi3_tpg_depend_item() failed"
+				" for dest_se_tpg\n");
+			atomic_dec(&dest_se_tpg->tpg_pr_ref_count);
+			smp_mb__after_atomic_dec();
 			core_scsi3_put_pr_reg(pr_reg);
 			return PYX_TRANSPORT_LU_COMM_FAILURE;
 		}
@@ -2968,7 +2972,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 		goto out;
 	}
 	initiator_str = dest_tf_ops->tpg_parse_pr_out_transport_id(
-			(const char *)&buf[24], NULL, &iport_ptr);
+			(const char *)&buf[24], &tmp_tid_len, &iport_ptr);
 	if (!(initiator_str)) {
 		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" initiator_str from Transport ID\n");
@@ -2999,8 +3003,13 @@ static int core_scsi3_emulate_pro_register_and_move(
 	/*
 	 * Locate the destination se_node_acl_t from the received Transport ID
 	 */
-	dest_node_acl = core_tpg_get_initiator_node_acl(dest_se_tpg,
+	spin_lock_bh(&dest_se_tpg->acl_node_lock);
+	dest_node_acl = __core_tpg_get_initiator_node_acl(dest_se_tpg,
 				initiator_str);
+	atomic_inc(&dest_node_acl->acl_pr_ref_count);
+	smp_mb__after_atomic_inc();
+	spin_unlock_bh(&dest_se_tpg->acl_node_lock);
+
 	if (!(dest_node_acl)) {
 		printk(KERN_ERR "Unable to locate %s dest_node_acl for"
 			" TransportID%s\n", dest_tf_ops->get_fabric_name(),
@@ -3008,11 +3017,12 @@ static int core_scsi3_emulate_pro_register_and_move(
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		goto out;
 	}
-	ret = configfs_depend_item(dest_tf_ops->tf_subsys,
-				&dest_node_acl->acl_group.cg_item);
+	ret = core_scsi3_nodeacl_depend_item(dest_node_acl);
 	if (ret != 0) {
-		printk(KERN_ERR "configfs_depend_item() failed for"
-			" dest_node_acl->acl_group\n");
+		printk(KERN_ERR "core_scsi3_nodeacl_depend_item() for"
+			" dest_node_acl\n");
+		atomic_dec(&dest_node_acl->acl_pr_ref_count);
+		smp_mb__after_atomic_dec();
 		ret = PYX_TRANSPORT_LU_COMM_FAILURE;
 		dest_node_acl = NULL;
 		goto out;
@@ -3056,8 +3066,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	}
 	/*
 	 * Locate the se_dev_entry_t pointer for the matching RELATIVE TARGET
-	 * PORT IDENTIFIER.  core_get_se_deve_from_rtpi() will call
-	 * configfs_item_depend() on deve->se_lun_acl->se_lun_group.cg_item
+	 * PORT IDENTIFIER.
 	 */
 	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
 	if (!(dest_se_deve)) {
@@ -3066,6 +3075,15 @@ static int core_scsi3_emulate_pro_register_and_move(
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		goto out;
 	}
+	
+	ret = core_scsi3_lunacl_depend_item(dest_se_deve);
+	if (ret < 0) {
+		printk(KERN_ERR "core_scsi3_lunacl_depend_item() failed\n");
+		atomic_dec(&dest_se_deve->pr_ref_count);
+		smp_mb__after_atomic_dec();
+		ret = PYX_TRANSPORT_LU_COMM_FAILURE;
+		goto out;
+	}
 #if 0
 	printk(KERN_INFO "SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN"
 		" ACL for dest_se_deve->mapped_lun: %u\n",
@@ -3201,12 +3219,9 @@ static int core_scsi3_emulate_pro_register_and_move(
 	 * It is now safe to release configfs group dependencies for destination
 	 * of Transport ID Initiator Device/Port Identifier
 	 */
-	configfs_undepend_item(dest_tf_ops->tf_subsys,
-			&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
-	configfs_undepend_item(dest_tf_ops->tf_subsys,
-			&dest_node_acl->acl_group.cg_item);
-	configfs_undepend_item(dest_tf_ops->tf_subsys,
-			&dest_se_tpg->tpg_group.cg_item);
+	core_scsi3_lunacl_undepend_item(dest_se_deve);
+	core_scsi3_nodeacl_undepend_item(dest_node_acl);
+	core_scsi3_tpg_undepend_item(dest_se_tpg);
 	/*
 	 * h) If the UNREG bit is set to one, unregister (see 5.7.11.3) the I_T
 	 * nexus on which PERSISTENT RESERVE OUT command was received.
@@ -3241,13 +3256,10 @@ static int core_scsi3_emulate_pro_register_and_move(
 	return 0;
 out:
 	if (dest_se_deve)
-		configfs_undepend_item(dest_tf_ops->tf_subsys,
-			&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
+		core_scsi3_lunacl_undepend_item(dest_se_deve);
 	if (dest_node_acl)
-		configfs_undepend_item(dest_tf_ops->tf_subsys,
-				&dest_node_acl->acl_group.cg_item);
-	configfs_undepend_item(dest_tf_ops->tf_subsys,
-			&dest_se_tpg->tpg_group.cg_item);
+		core_scsi3_nodeacl_undepend_item(dest_node_acl);
+	core_scsi3_tpg_undepend_item(dest_se_tpg);
 	core_scsi3_put_pr_reg(pr_reg);
 	return ret;
 }
-- 
1.5.6.5

