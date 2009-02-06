Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZBFIEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZBFIEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbZBFIER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:04:17 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:29884 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755746AbZBFIEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:04:15 -0500
X-YMail-OSG: 4tGSVAUVM1n4LwJnDkTEH9Xh0phNMit6aehONLzjbZ9QvuUL77j_dyc6ztIHm4jhy10pothoyNAauJCpn4I3LaW_008uVuwE19VBd6OYlufhU5FwsF.ggPEKgbFugMeD6NstYmzhppxI0QqPJPfzNItqFntWecWZTdZMxNs6vq4pSp8MVeqmWtFJmm_d4jPaBz_gJBboYshDyToQtSlajy9msA3CBJxR8gUXcgMLOalzIKWhchw-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 6/6] [LIO-Target/ConfigFS]: Add ALUA wrapper functions to
	Target_Core_Mod/ALUA code
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
       "Lawrence E. Rosen" <lrosen@pyxtechnologies.com>,
       Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 00:03:09 -0800
Message-Id: <1233907389.12375.370.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 07c4589df0d95b09dbe57dd41d65b6002096c2e3 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 5 Feb 2009 23:29:06 -0800
Subject: [PATCH 6/6] [LIO-Target/ConfigFS]: Add ALUA wrapper functions to Target_Core_Mod/ALUA code

This patch adds /sys/kernel/config/target/iscsi/$TARGETNAME/$TPGT/lun/$LUN/alua_tg_pt_gp
for adding/moving/releasing Target_Core_Mod/ConfigFS ALUA Target Port Group assocations.

This patch also removes some unused (control, and info) attributes from
iscsi/$TARGETNAME/$TPGT/lun/$LUN/

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |   42 ++++++++----------------------
 1 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 13cab60..7047cc8 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -38,6 +38,7 @@
 #include <target_core_fabric_ops.h>
 #include <target_core_device.h>
 #include <target_core_configfs.h>
+#include <target_core_alua.h>
 #include <configfs_macros.h>
 
 #include <iscsi_protocol.h>
@@ -402,51 +403,30 @@ static struct config_item_type lio_target_np_cit = {
 
 // Start items for lio_target_port_cit
 
-static ssize_t lio_target_show_port_info (void *p, char *page)
+static ssize_t lio_target_show_port_alua_tg_pt_gp (void *p, char *page)
 {
 	se_lun_t *lun = (se_lun_t *)p;
-	int read_bytes = 0;
 
-	read_bytes += sprintf(page, "lio_target_show_port_info()\n");
-	return(read_bytes);
+	return(core_alua_show_tg_pt_gp_info(lun->lun_sep, page));
 }
 
-static struct lio_target_configfs_attribute lio_target_attr_port_info = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "info",
-		    .ca_mode = S_IRUGO },
-	.show	= lio_target_show_port_info,
-	.store	= NULL,
-};
-
-static ssize_t lio_target_store_port_control (void *p, const char *page, size_t count)
+static ssize_t lio_target_store_port_alua_tg_pt_gp (void *p, const char *page, size_t count)
 {
 	se_lun_t *lun = (se_lun_t *)p;
-	char *buf, *cur;
-
-	if (!(buf = kzalloc(count, GFP_KERNEL))) {
-		printk(KERN_ERR "Unable to allocate memory for temporary buffer\n");
-		return(-ENOMEM);
-	}
-	memcpy(buf, page, count);
 
-	printk("lio_target_store_port_control(): %s\n", buf);
-
-	kfree(buf);
-	return(count);
+	return(core_alua_store_tg_pt_gp_info(lun->lun_sep, page, count));
 }
 
-static struct lio_target_configfs_attribute lio_target_attr_port_control = {
+static struct lio_target_configfs_attribute lio_target_attr_port_alua_tg_pt_gp = {
 	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "control",
-		    .ca_mode = S_IWUSR },
-	.show	= NULL,
-	.store	= lio_target_store_port_control,
+		    .ca_name = "alua_tg_pt_gp",
+		    .ca_mode = S_IRUGO | S_IWUSR },
+	.show	= lio_target_show_port_alua_tg_pt_gp,
+	.store	= lio_target_store_port_alua_tg_pt_gp,
 };
 
 static struct configfs_attribute *lio_target_port_attrs[] = {
-	&lio_target_attr_port_info.attr,
-	&lio_target_attr_port_control.attr,
+	&lio_target_attr_port_alua_tg_pt_gp.attr,
 	NULL,
 };
 
-- 
1.5.4.1



