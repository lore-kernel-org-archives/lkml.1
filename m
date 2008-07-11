Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbYGKOKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYGKOKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbYGKOKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:10:44 -0400
Received: from havoc.gtf.org ([69.61.125.42]:34595 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbYGKOKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:10:43 -0400
Date: Fri, 11 Jul 2008 10:10:42 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes for .26
Message-ID: <20080711141042.GA17624@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-acpi.c |   19 ++++++++++++++++---
 drivers/ata/pata_sis.c    |    1 +
 2 files changed, 17 insertions(+), 3 deletions(-)

Kai Krakow (1):
      Added Targa Visionary 1000 IDE adapter to pata_sis.c

Tejun Heo (1):
      libata-acpi: filter out DIPM enable

Zhang Rui (1):
      libata-acpi: don't call sleeping function from invalid context

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 3ff8b14..9330b79 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -29,14 +29,16 @@
 enum {
 	ATA_ACPI_FILTER_SETXFER	= 1 << 0,
 	ATA_ACPI_FILTER_LOCK	= 1 << 1,
+	ATA_ACPI_FILTER_DIPM	= 1 << 2,
 
 	ATA_ACPI_FILTER_DEFAULT	= ATA_ACPI_FILTER_SETXFER |
-				  ATA_ACPI_FILTER_LOCK,
+				  ATA_ACPI_FILTER_LOCK |
+				  ATA_ACPI_FILTER_DIPM,
 };
 
 static unsigned int ata_acpi_gtf_filter = ATA_ACPI_FILTER_DEFAULT;
 module_param_named(acpi_gtf_filter, ata_acpi_gtf_filter, int, 0644);
-MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=set xfermode, 0x2=lock/freeze lock)");
+MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=set xfermode, 0x2=lock/freeze lock, 0x4=DIPM)");
 
 #define NO_PORT_MULT		0xffff
 #define SATA_ADR(root, pmp)	(((root) << 16) | (pmp))
@@ -195,6 +197,10 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 		/* This device does not support hotplug */
 		return;
 
+	if (event == ACPI_NOTIFY_BUS_CHECK ||
+	    event == ACPI_NOTIFY_DEVICE_CHECK)
+		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+
 	spin_lock_irqsave(ap->lock, flags);
 
 	switch (event) {
@@ -202,7 +208,6 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		ata_ehi_push_desc(ehi, "ACPI event");
 
-		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
 		if (ACPI_FAILURE(status)) {
 			ata_port_printk(ap, KERN_ERR,
 				"acpi: failed to determine bay status (0x%x)\n",
@@ -690,6 +695,14 @@ static int ata_acpi_filter_tf(const struct ata_taskfile *tf,
 			return 1;
 	}
 
+	if (ata_acpi_gtf_filter & ATA_ACPI_FILTER_DIPM) {
+		/* inhibit enabling DIPM */
+		if (tf->command == ATA_CMD_SET_FEATURES &&
+		    tf->feature == SETFEATURES_SATA_ENABLE &&
+		    tf->nsect == SATA_DIPM)
+			return 1;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index e82c66e..26345d7 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -56,6 +56,7 @@ static const struct sis_laptop sis_laptop[] = {
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
 	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
+	{ 0x5513, 0x1039, 0x5513 },	/* Targa Visionary 1000 */
 	/* end marker */
 	{ 0, }
 };
