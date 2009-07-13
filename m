Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZGMVDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZGMVDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZGMVDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:03:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57346 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937AbZGMVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:03:17 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, shaohua.li@intel.com,
       linux-ide@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] SCSI: Allow platform-specific code to be run against the SCSI tree
Date: Mon, 13 Jul 2009 22:03:05 +0100
Message-Id: <1247518987-10818-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain cases (such as ACPI) we want to be able to associate
platform-specific data against the SCSI device tree. Handling this
properly requires the ability to run platform code at SCSI init time.
This patch adds stub functions that can be overridden if the platform
defines CONFIG_SCSI_PLATFORM.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/scsi/Kconfig     |    4 ++++
 drivers/scsi/scsi.c      |    6 ++++++
 drivers/scsi/scsi_priv.h |    1 -
 include/scsi/scsi.h      |   10 ++++++++++
 4 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9c23122..7537d0b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -34,6 +34,10 @@ config SCSI_DMA
 	bool
 	default n
 
+config SCSI_PLATFORM
+	bool
+	default n
+
 config SCSI_TGT
 	tristate "SCSI target support"
 	depends on SCSI && EXPERIMENTAL
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2de5f3a..da02f64 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1332,12 +1332,17 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error = scsi_platform_register();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1356,6 +1361,7 @@ cleanup_queue:
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_platform_unregister();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 021e503..bce4a70 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -131,7 +131,6 @@ extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
-extern struct bus_type scsi_bus_type;
 extern struct attribute_group *scsi_sysfs_shost_attr_groups[];
 
 /* scsi_netlink.c */
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..f349c83 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -140,6 +140,16 @@ struct scsi_cmnd;
 
 #define SCSI_MAX_VARLEN_CDB_SIZE 260
 
+#ifdef CONFIG_SCSI_PLATFORM
+extern int scsi_platform_register(void);
+extern void scsi_platform_unregister(void);
+#else
+static inline int scsi_platform_register(void) { return 0; };
+static inline void scsi_platform_unregister(void) { };
+#endif
+
+extern struct bus_type scsi_bus_type;
+
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
 	u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-- 
1.6.2.5

