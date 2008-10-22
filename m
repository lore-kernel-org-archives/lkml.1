Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYJVWHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYJVWHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYJVWHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:07:33 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:47325 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753415AbYJVWHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:07:32 -0400
X-YMail-OSG: ihxQ9SIVM1lc8uRb.W9gkAI7a4VS3SbzEtAoOJ1IchCm6JrJUD2mqt8KIUDtRx2hLIxpuPtWwwJc39khcHyknBTZ5DuSFh6xjzQajpJIah.8x_nQdcr84QTSvrQ5dRdRBqK.1eoqeXTGomzITwRTvynTZF9raovTRFsd6I9H_Gz7loqS2d2vFlcrkCo-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [LIO-Target/ConfigFS]: Convert TPG and Node attributes to
	use updated ConfigFS macros
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 15:07:29 -0700
Message-Id: <1224713249.24358.113.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e305460ebaa92ce1f8542a55bd62648904fb2fd6 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 22 Oct 2008 14:54:36 -0700
Subject: [PATCH] [LIO-Target/ConfigFS]: Convert TPG and Node attributes to use updated ConfigFS macros

Use updated include/linux/configfs.h macros from commit 71fc659e337dcc5941f6f64f6c8abfb6b477fd7c

This commit removed the need for our internal 'to_<name>()' functions, and renames
the TPG and Node attribute code to not be dependent on structure name.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |   64 ++++++++++++------------------
 1 files changed, 26 insertions(+), 38 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index bdcd981..9d5319c 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -722,18 +722,12 @@ static ssize_t lio_target_store_nacl_attrib_##name (			\
 	return(count);							\
 }
 
-static struct iscsi_node_attrib_s *to_iscsi_node_attrib_s (struct config_item *item)
-{
-	return((item) ? container_of(to_config_group(item), struct iscsi_node_attrib_s,
-		acl_attrib_group) : NULL);
-}
-
 /*
  * Define the iSCSI Node attributes using hybrid wrappers from include/linux/configfs.h
  */
-CONFIGFS_ATTR_STRUCT(iscsi_node_attrib_s);
-#define NACL_ATTR(_name, _mode, _show, _store)					\
-static struct iscsi_node_attrib_s_attribute iscsi_node_attrib_s_##_name =	\
+CONFIGFS_ATTR_STRUCT(iscsi_node_attrib, iscsi_node_attrib_s);
+#define NACL_ATTR(_name, _mode, _show, _store)				\
+static struct iscsi_node_attrib_attribute iscsi_node_attrib_##_name =	\
 		__CONFIGFS_ATTR(_name, _mode, _show, _store)
 /*
  * Define iscsi_node_attrib_s_dataout_timeout
@@ -796,23 +790,23 @@ NACL_ATTR(random_r2t_offsets, S_IRUGO | S_IWUSR,
  * Finally, define functions iscsi_node_attrib_s_attr_show() and
  * iscsi_node_attrib_s_attr_store() for lio_target_nacl_attrib_ops below..
  */
-CONFIGFS_ATTR_OPS(iscsi_node_attrib_s);
+CONFIGFS_ATTR_OPS(iscsi_node_attrib, iscsi_node_attrib_s, acl_attrib_group);
 
 static struct configfs_attribute *lio_target_nacl_attrib_attrs[] = {
-	&iscsi_node_attrib_s_dataout_timeout.attr,
-	&iscsi_node_attrib_s_dataout_timeout_retries.attr,
-	&iscsi_node_attrib_s_default_erl.attr,
-	&iscsi_node_attrib_s_nopin_timeout.attr,
-	&iscsi_node_attrib_s_nopin_response_timeout.attr,
-	&iscsi_node_attrib_s_random_datain_pdu_offsets.attr,
-	&iscsi_node_attrib_s_random_datain_seq_offsets.attr,
-	&iscsi_node_attrib_s_random_r2t_offsets.attr,
+	&iscsi_node_attrib_dataout_timeout.attr,
+	&iscsi_node_attrib_dataout_timeout_retries.attr,
+	&iscsi_node_attrib_default_erl.attr,
+	&iscsi_node_attrib_nopin_timeout.attr,
+	&iscsi_node_attrib_nopin_response_timeout.attr,
+	&iscsi_node_attrib_random_datain_pdu_offsets.attr,
+	&iscsi_node_attrib_random_datain_seq_offsets.attr,
+	&iscsi_node_attrib_random_r2t_offsets.attr,
 	NULL,
 };
 
 static struct configfs_item_operations lio_target_nacl_attrib_ops = {
-	.show_attribute		= iscsi_node_attrib_s_attr_show,
-	.store_attribute	= iscsi_node_attrib_s_attr_store,
+	.show_attribute		= iscsi_node_attrib_attr_show,
+	.store_attribute	= iscsi_node_attrib_attr_store,
 };
 
 static struct config_item_type lio_target_nacl_attrib_cit = {
@@ -1519,18 +1513,12 @@ out:									\
 	return(ret);							\
 }
 
-static struct iscsi_tpg_attrib_s *to_iscsi_tpg_attrib_s (struct config_item *item)
-{
-	return((item) ? container_of(to_config_group(item), struct iscsi_tpg_attrib_s,
-		tpg_attrib_group) : NULL);	
-}
-
 /*
  * Define the iSCSI TPG attributes using hybrid wrappers from include/linux/configfs.h
  */
-CONFIGFS_ATTR_STRUCT(iscsi_tpg_attrib_s);
+CONFIGFS_ATTR_STRUCT(iscsi_tpg_attrib, iscsi_tpg_attrib_s);
 #define TPG_ATTR(_name, _mode, _show, _store)				\
-static struct iscsi_tpg_attrib_s_attribute iscsi_tpg_attrib_s_##_name =	\
+static struct iscsi_tpg_attrib_attribute iscsi_tpg_attrib_##_name =	\
 	__CONFIGFS_ATTR(_name, _mode, _show, _store)
 
 /*
@@ -1587,21 +1575,21 @@ TPG_ATTR(demo_mode_lun_access, S_IRUGO | S_IWUSR,
  * Finally, define functions iscsi_tpg_attrib_s_attr_show() and
  * iscsi_tpg_attrib_s_attr_store() for lio_target_tpg_attrib_ops below..
  */
-CONFIGFS_ATTR_OPS(iscsi_tpg_attrib_s);
+CONFIGFS_ATTR_OPS(iscsi_tpg_attrib, iscsi_tpg_attrib_s, tpg_attrib_group);
 
 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
-	&iscsi_tpg_attrib_s_authentication.attr,
-	&iscsi_tpg_attrib_s_login_timeout.attr,
-	&iscsi_tpg_attrib_s_netif_timeout.attr,
-	&iscsi_tpg_attrib_s_generate_node_acls.attr,
-	&iscsi_tpg_attrib_s_default_cmdsn_depth.attr,
-	&iscsi_tpg_attrib_s_cache_dynamic_acls.attr,
-	&iscsi_tpg_attrib_s_demo_mode_lun_access.attr,
+	&iscsi_tpg_attrib_authentication.attr,
+	&iscsi_tpg_attrib_login_timeout.attr,
+	&iscsi_tpg_attrib_netif_timeout.attr,
+	&iscsi_tpg_attrib_generate_node_acls.attr,
+	&iscsi_tpg_attrib_default_cmdsn_depth.attr,
+	&iscsi_tpg_attrib_cache_dynamic_acls.attr,
+	&iscsi_tpg_attrib_demo_mode_lun_access.attr,
 };
 
 static struct configfs_item_operations lio_target_tpg_attrib_ops = {
-	.show_attribute		= iscsi_tpg_attrib_s_attr_show,
-	.store_attribute	= iscsi_tpg_attrib_s_attr_store,
+	.show_attribute		= iscsi_tpg_attrib_attr_show,
+	.store_attribute	= iscsi_tpg_attrib_attr_store,
 };
 
 static struct config_item_type lio_target_tpg_attrib_cit = {
-- 
1.5.4.1



