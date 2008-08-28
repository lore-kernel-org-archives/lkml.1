Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYH1V7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYH1V7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbYH1V7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:59:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbYH1V7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:59:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Regression: SATA disk double spin-off during hibernation on hp nx6325
Date: Fri, 29 Aug 2008 00:02:54 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808290002.55026.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It appears that the "double spin-off" problem described in

http://bugzilla.kernel.org/show_bug.cgi?id=8855

has recently started to appear during hibernation as well as during shutdown.
It didn't appear during hibernation on my hp nx6325 with 2.6.26, so this is a
recent regression.

I have prepared the appended patch that fixes the problem for me, based on the
 earlier Tejun's patch at

http://bugzilla.kernel.org/attachment.cgi?id=15441&action=view

but I'm not really sure if this is an acceptable solution.  Please advise.

Thanks,
Rafael


not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/ata/libata-scsi.c |   16 +++++++++++++---
 drivers/ata/sata_sil.c    |   30 +++++++++++++++++++++++++++++-
 include/linux/libata.h    |    1 +
 kernel/power/disk.c       |    2 ++
 4 files changed, 45 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/ata/libata-scsi.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-scsi.c
+++ linux-2.6/drivers/ata/libata-scsi.c
@@ -1181,6 +1181,14 @@ static unsigned int ata_scsi_start_stop_
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
 	} else {
+		/* Some odd clown BIOSen issue spindown on shutdown
+		 * causing some drives to spin up and down again.
+		 */
+		if ((qc->ap->flags & ATA_FLAG_NO_SHUTDOWN_SPINDOWN) &&
+		    (system_state == SYSTEM_POWER_OFF ||
+		     system_state == SYSTEM_SUSPEND_DISK))
+			goto skip;
+
 		/* XXX: This is for backward compatibility, will be
 		 * removed.  Read Documentation/feature-removal-schedule.txt
 		 * for more info.
@@ -1204,8 +1212,7 @@ static unsigned int ata_scsi_start_stop_
 				scmd->scsi_done = qc->scsidone;
 				qc->scsidone = ata_delayed_done;
 			}
-			scmd->result = SAM_STAT_GOOD;
-			return 1;
+			goto skip;
 		}
 
 		/* Issue ATA STANDBY IMMEDIATE command */
@@ -1221,10 +1228,13 @@ static unsigned int ata_scsi_start_stop_
 
 	return 0;
 
-invalid_fld:
+ invalid_fld:
 	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
 	return 1;
+ skip:
+	scmd->result = SAM_STAT_GOOD;
+	return 1;
 }
 
 
Index: linux-2.6/drivers/ata/sata_sil.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sil.c
+++ linux-2.6/drivers/ata/sata_sil.c
@@ -603,11 +603,33 @@ static void sil_init_controller(struct a
 	}
 }
 
+static int sil_broken_shutdown(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id sysid_nx6325[] = {
+		{
+			.ident = "HP Compaq nx6325",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+			},
+		},
+
+		{ }	/* terminate list */
+	};
+
+	/* apply the quirk only to the on-board controller */
+	if (dmi_check_system(sysid_nx6325) && PCI_SLOT(pdev->devfn) == 18)
+		return 1;
+
+	return 0;
+}
+
 static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	int board_id = ent->driver_data;
-	const struct ata_port_info *ppi[] = { &sil_port_info[board_id], NULL };
+	struct ata_port_info pi = sil_port_info[board_id];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ata_host *host;
 	void __iomem *mmio_base;
 	int n_ports, rc;
@@ -621,6 +643,12 @@ static int sil_init_one(struct pci_dev *
 	if (board_id == sil_3114)
 		n_ports = 4;
 
+	if (sil_broken_shutdown(pdev)) {
+		pi.flags |= ATA_FLAG_NO_SHUTDOWN_SPINDOWN;
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "quirky BIOS, skipping spindown on shutdown\n");
+	}
+
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
Index: linux-2.6/include/linux/libata.h
===================================================================
--- linux-2.6.orig/include/linux/libata.h
+++ linux-2.6/include/linux/libata.h
@@ -187,6 +187,7 @@ enum {
 					     * doesn't handle PIO interrupts */
 	ATA_FLAG_NCQ		= (1 << 10), /* host supports NCQ */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
+	ATA_FLAG_NO_SHUTDOWN_SPINDOWN = (1 << 14), /* don't spindown on shutdown */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -416,6 +416,7 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Close;
 
+	system_state = SYSTEM_SUSPEND_DISK;
 	suspend_console();
 	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_HIBERNATE);
@@ -451,6 +452,7 @@ int hibernation_platform_enter(void)
  Finish:
 	hibernation_ops->finish();
  Resume_devices:
+	system_state = SYSTEM_RUNNING;
 	device_resume(PMSG_RESTORE);
 	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
