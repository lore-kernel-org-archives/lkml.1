Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZBFH7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZBFH7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZBFH7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:59:35 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:29300 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752545AbZBFH7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:59:34 -0500
X-YMail-OSG: UCZ2qCAVM1l5vDESBG1AJiZAHG5zBKKfo4lG9NeOrCkYBM8v3gPfNy3viHv2P20hf5ElKum2K.9tb.ytidr9yo54azzExwMzEebb2mbSHNhQTKABb8JkMU2Vqdhs3Q.oxi4wnQ4gvWt9oIa.V0I6kxGSDO_NYhPRaVmAKHMrNL8ieSSY0HkOuYsRZ.w1gJR.n7MkRAoybKe3t7ywpm9syhgRNNL7Zp1nUjlrI9CdskkR9J0ayx8-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 2/6] [Target_Core_Mod/ALUA]: Add setup for
	target_core_device.c code
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
       "Ross S. W. Walker" <rswwalker@gmail.com>,
       Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 23:58:27 -0800
Message-Id: <1233907107.12375.358.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 69d33dbf59baa538df587ee6c36e586f7274be5b Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 5 Feb 2009 23:12:45 -0800
Subject: [PATCH 2/6] [Target_Core_Mod/ALUA]: Add setup for target_core_device.c code

This patch will attach a give se_port_t to the default Target Port Group
in core_export_port() when SPC3_ALUA_EMULATED is enabled.

Also, add core_release_port() and se_free_virtual_device() for releasing
associated Target Port Group and Logical Unit Group assoicaton respectively
in release paths.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_device.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 9f1503c..f7ad451 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -50,6 +50,7 @@
 #include <iscsi_target_error.h>
 #include <target_core_device.h>
 #include <target_core_hba.h>
+#include <target_core_alua.h>
 #include <target_core_pr.h>
 #include <target_core_tpg.h>
 #include <target_core_transport.h>
@@ -500,6 +501,8 @@ extern se_port_t *core_alloc_port (se_device_t *dev)
 		return(NULL);
 	}
 	INIT_LIST_HEAD(&port->sep_list);
+	INIT_LIST_HEAD(&port->sep_tg_pt_gp_list);
+	spin_lock_init(&port->sep_alua_lock);
 
 	spin_lock(&dev->se_port_lock);
 	if (dev->dev_port_count == 0x0000ffff) {
@@ -542,6 +545,8 @@ extern void core_export_port (
 	se_port_t *port,
 	se_lun_t *lun)
 {
+	se_subsystem_dev_t *su_dev = SU_DEV(dev);
+
 	spin_lock(&dev->se_port_lock);
 	spin_lock(&lun->lun_sep_lock);
 	port->sep_tpg = tpg;
@@ -552,6 +557,13 @@ extern void core_export_port (
 	list_add_tail(&port->sep_list, &dev->dev_sep_list);
 	spin_unlock(&dev->se_port_lock);
 
+	if (T10_ALUA(su_dev)->alua_type == SPC3_ALUA_EMULATED) {
+		core_alua_attach_tg_pt_gp(port, se_global->default_tg_pt_gp);
+		printk("%s/%s: Adding to default ALUA Target Port Group:"
+			" core/alua/tg_pt_gps/default_tg_pt_gp\n",
+			TRANSPORT(dev)->name, TPG_TFO(tpg)->get_fabric_name());
+	}
+
 	dev->dev_port_count++;
 #ifdef SNMP_SUPPORT
 	port->sep_index = port->sep_rtpi; /* RELATIVE TARGET PORT IDENTIFER */
@@ -564,6 +576,8 @@ extern void core_export_port (
  */
 extern void core_release_port (se_device_t *dev, se_port_t *port)
 {
+	core_alua_put_tg_pt_gp(port, 1);
+
 	list_del(&port->sep_list);
 	dev->dev_port_count--;
 	kfree(port);
@@ -750,6 +764,8 @@ extern int se_free_virtual_device (se_device_t *dev, se_hba_t *hba)
 	se_clear_dev_ports(dev);
 	spin_unlock(&hba->device_lock);
 
+	core_alua_put_lu_gp(dev, 1);	
+	
 	se_release_device_for_hba(dev);
 	
 	return(0);
-- 
1.5.4.1



