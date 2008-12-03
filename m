Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbYLCCO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbYLCCO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYLCCOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:14:18 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:45048 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754368AbYLCCOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:14:17 -0500
X-YMail-OSG: NkrFqaAVM1nRYcZVJnXW.ASYIJUFkrh4eUaV6g8mKFzuTu_YoWT1VkbAi.V7d.L5k7rOlquKP77NzKS7xZPniYi1YPYISST0yZdynpvpjEPK8dlCTLYSXPN8W2x2FJwO7zEI9JN9gb9SnL2v9i_HXXCLoghdx3LJSQi9dzLf.dxgVr_yz3mQkeNGuzo-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [Target_Core_Mod]: Convert to se_task_t->task_sg usage in
	core and subsystem plugins
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Boaz Harrosh <bharrosh@panasas.com>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 18:14:14 -0800
Message-Id: <1228270454.6229.137.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 41e98940da5ffaf7e31fce8d1f706e3e0a679654 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 2 Dec 2008 18:06:54 -0800
Subject: [PATCH] [Target_Core_Mod]: Convert to se_task_t->task_sg usage in core and subsystem plugins

This patch adds makes the existing se_task_t->task_buf become se_task_t->task_sg of
type struct scatterlist.  Changes to target_core_transport.c in transport_calc_sg_num()
and transport_free_dev_tasks() are simple, along with a one-liner change in
target_core_seobj.c:dev_obj_do_se_mem_map().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |    2 +-
 drivers/lio-core/target_core_seobj.c     |   11 ++++++-----
 drivers/lio-core/target_core_transport.c |    9 ++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 5ee04d3..b866613 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -249,7 +249,7 @@ typedef struct se_transport_task_s {
 
 typedef struct se_task_s {
         unsigned char   task_sense;
-        unsigned char   *task_buf;
+	struct scatterlist *task_sg;
         void            *transport_req;
         u8              task_scsi_status;
         u8              task_flags;
diff --git a/drivers/lio-core/target_core_seobj.c b/drivers/lio-core/target_core_seobj.c
index 8e8c951..d013f2c 100644
--- a/drivers/lio-core/target_core_seobj.c
+++ b/drivers/lio-core/target_core_seobj.c
@@ -348,8 +348,9 @@ extern int dev_obj_do_se_mem_map (
 	 * been done by the transport plugin.
 	 */
 	if (TRANSPORT(dev)->do_se_mem_map) {
-		if ((ret = TRANSPORT(dev)->do_se_mem_map(task, se_mem_list, in_mem, in_se_mem,
-				out_se_mem, se_mem_cnt, task_offset)) == 0)
+		if ((ret = TRANSPORT(dev)->do_se_mem_map(task, se_mem_list,
+				in_mem, in_se_mem, out_se_mem, se_mem_cnt,
+				task_offset)) == 0)
 			T_TASK(task->iscsi_cmd)->t_task_se_num += *se_mem_cnt;
 
 		return(ret);
@@ -362,10 +363,10 @@ extern int dev_obj_do_se_mem_map (
 		return(-1);
 	
 	/*
-	 * se_task_t->task_buf now contains the struct scatterlist array.
+	 * se_task_t->task_sg now contains the struct scatterlist array.
 	 */
-	return(transport_map_mem_to_sg(task, se_mem_list, task->task_buf, in_se_mem, out_se_mem,
-			se_mem_cnt, task_offset));
+	return(transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
+		in_se_mem, out_se_mem, se_mem_cnt, task_offset));
 }
 
 extern int dev_obj_get_mem_buf (void *p, iscsi_cmd_t *cmd)
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index d92814c..b8e8294 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4643,7 +4643,7 @@ extern void transport_free_dev_tasks (iscsi_cmd_t *cmd)
 		if (!task->transport_req)
 			continue;
 		
-		kfree(task->task_buf);
+		kfree(task->task_sg);
 		
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 		if (task->iscsi_dev)
@@ -5097,13 +5097,12 @@ extern u32 transport_calc_sg_num (
 			break;
 	}
 
-	if (!(task->task_buf = kmalloc(task->task_sg_num * sizeof(struct scatterlist), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate memory for task->task_buf\n");
+	if (!(task->task_sg = kzalloc(task->task_sg_num * sizeof(struct scatterlist), GFP_KERNEL))) {
+		TRACE_ERROR("Unable to allocate memory for task->task_sg\n");
 		return(0);	
 	}
-	memset(task->task_buf, 0, task->task_sg_num * sizeof(struct scatterlist));
 
-	sg_init_table((struct scatterlist *)&task->task_buf[0], task->task_sg_num);
+	sg_init_table(&task->task_sg[0], task->task_sg_num);
 
 	DEBUG_SC("Successfully allocated task->task_sg_num: %u\n", task->task_sg_num);
 	
-- 
1.5.4.1



