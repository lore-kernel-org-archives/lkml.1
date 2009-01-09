Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZAIUyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZAIUyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbZAIUyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:54:25 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:31967 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754356AbZAIUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:54:24 -0500
X-YMail-OSG: a1D_0GIVM1m5NKaZyB9bUSEmqEHsVyuv.wukEArs76_0It0Ju90SbqWJxIfz5OiHFtdJaGoK7_yEvSYFi8NFZB33N.uyEOI4kGy7Ll78IhEJePmqY20PEa6MA.WnPGLJ0eMnIzV_sH3KBl2xtK8.qm.y37EWSvkmhJOkbSB1EOE5J94BM1a4Kco3GYgb14jvg8myh3sFw6IAnhvkBKKKjnKpSUgMQRcF2lytgee8AB8fIiMR9lQ-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 2/5] [LIO-Target]: Convert iscsi_datain_req_t to use struct
	kmem_cache
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 12:53:58 -0800
Message-Id: <1231534438.4560.999.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 480de313d016c482ff8622d2195231e1475f8275 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 9 Jan 2009 10:37:19 -0800
Subject: [PATCH 2/5] [LIO-Target]: Convert iscsi_datain_req_t to use struct kmem_cache

This patch converts usage of the structure iscsi_datain_req_t to use
struct kmem_cache *lio_dr_cache.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c               |   11 +++++++++++
 drivers/lio-core/iscsi_target_datain_values.c |    8 ++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index 5c73c82..77c0e52 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -97,6 +97,7 @@ iscsi_global_t *iscsi_global = NULL;
 struct kmem_cache *lio_cmd_cache = NULL;
 struct kmem_cache *lio_sess_cache = NULL;
 struct kmem_cache *lio_qr_cache = NULL;
+struct kmem_cache *lio_dr_cache = NULL;
 
 extern int se_allocate_rl_cmd (se_cmd_t *, unsigned char *, u64);
 extern int iscsi_build_report_luns_response (iscsi_cmd_t *);
@@ -1125,6 +1126,13 @@ static int iscsi_target_detect(void)
 		goto out;
 	}
 
+	if (!(lio_dr_cache = kmem_cache_create("lio_dr_cache",
+			sizeof(iscsi_datain_req_t), __alignof__(iscsi_datain_req_t),
+			0, NULL))) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for lio_dr_cache\n");
+		goto out;
+	}
+
 	if (core_load_discovery_tpg() < 0)
 		goto out;
 
@@ -1140,6 +1148,8 @@ out:
 		kmem_cache_destroy(lio_sess_cache);
 	if (lio_qr_cache)
 		kmem_cache_destroy(lio_qr_cache);
+	if (lio_dr_cache)
+		kmem_cache_destroy(lio_dr_cache);
 	iscsi_deallocate_thread_sets(TARGET);
 	iscsi_target_deregister_configfs();
 #ifdef CONFIG_PROC_FS
@@ -1193,6 +1203,7 @@ extern void iscsi_target_release_phase2 (void)
 	kmem_cache_destroy(lio_cmd_cache);
 	kmem_cache_destroy(lio_sess_cache);
 	kmem_cache_destroy(lio_qr_cache);
+	kmem_cache_destroy(lio_dr_cache);
 	core_release_discovery_tpg();
 	core_release_tiqns();
 	plugin_deregister_class(PLUGIN_TYPE_FRONTEND);
diff --git a/drivers/lio-core/iscsi_target_datain_values.c b/drivers/lio-core/iscsi_target_datain_values.c
index 219d685..268f3fe 100644
--- a/drivers/lio-core/iscsi_target_datain_values.c
+++ b/drivers/lio-core/iscsi_target_datain_values.c
@@ -50,16 +50,16 @@
 #undef ISCSI_TARGET_DATAIN_VALUES_C
 
 extern iscsi_global_t *iscsi_global;
+extern struct kmem_cache *lio_dr_cache;
 
 extern iscsi_datain_req_t *iscsi_allocate_datain_req (void)
 {
 	iscsi_datain_req_t *dr;
 
-	if (!(dr = kmalloc(sizeof(iscsi_datain_req_t), GFP_ATOMIC))) {
+	if (!(dr = kmem_cache_zalloc(lio_dr_cache, GFP_ATOMIC))) {
 		TRACE_ERROR("Unable to allocate memory for iscsi_datain_req_t\n");
 		return(NULL);
 	}
-	memset(dr, 0, sizeof(iscsi_datain_req_t));
 
 	return(dr);
 }
@@ -83,7 +83,7 @@ extern void iscsi_free_datain_req (
 	REMOVE_ENTRY_FROM_LIST(dr, cmd->datain_req_head, cmd->datain_req_tail);
 	spin_unlock(&cmd->datain_lock);
 
-	kfree(dr);
+	kmem_cache_free(lio_dr_cache, dr);
 
 	return;
 }
@@ -97,7 +97,7 @@ extern void iscsi_free_all_datain_reqs (
 	dr = cmd->datain_req_head;
 	while (dr) {
 		dr_next = dr->next;
-		kfree(dr);	
+		kmem_cache_free(lio_dr_cache, dr);
 		dr = dr_next;
 	}
 	cmd->datain_req_head = cmd->datain_req_tail = NULL;
-- 
1.5.4.1



