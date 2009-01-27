Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZA0Hbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZA0Hbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZA0HbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:31:17 -0500
Received: from havoc.gtf.org ([69.61.125.42]:43923 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZA0HbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:31:15 -0500
Date: Tue, 27 Jan 2009 02:31:14 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata hibernation fixes
Message-ID: <20090127073114.GA30407@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'hibern_fixes' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git hibern_fixes

to receive the following updates:

 drivers/ata/ahci.c          |   32 ++++++++++++++++++
 drivers/ata/ata_piix.c      |   34 +++++++++++++++++++
 drivers/ata/libata-scsi.c   |   20 ++++++++++--
 drivers/ata/sata_sil.c      |   36 ++++++++++++++++++++-
 drivers/firmware/dmi_scan.c |   74 ++++++++++++++++++++++++++++++++-----------
 include/linux/dmi.h         |    1 +
 include/linux/libata.h      |    2 +
 include/linux/suspend.h     |    2 +
 kernel/power/disk.c         |   10 ++++++
 9 files changed, 188 insertions(+), 23 deletions(-)

Rafael J. Wysocki (6):
      Hibernation: Introduce system_entering_hibernation
      DMI: Introduce dmi_first_match to make the interface more flexible
      SATA: Blacklisting of systems that spin off disks during ACPI power off
      SATA AHCI: Blacklist system that spins off disks during ACPI power off
      SATA Sil: Blacklist system that spins off disks during ACPI power off
      SATA PIIX: Blacklist system that spins off disks during ACPI power off

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 9603967..77bba4c 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2548,6 +2548,32 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 	}
 }
 
+static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq nx6310",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6310"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+
+	if (dmi) {
+		unsigned long slot = (unsigned long)dmi->driver_data;
+		/* apply the quirk only to on-board controllers */
+		return slot == PCI_SLOT(pdev->devfn);
+	}
+
+	return false;
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2647,6 +2673,12 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
+	if (ahci_broken_system_poweroff(pdev)) {
+		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
+		dev_info(&pdev->dev,
+			"quirky BIOS, skipping spindown on poweroff\n");
+	}
+
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 887d8f4..54961c0 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1387,6 +1387,32 @@ static void piix_iocfg_bit18_quirk(struct ata_host *host)
 	}
 }
 
+static bool piix_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq 2510p",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 2510p"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+
+	if (dmi) {
+		unsigned long slot = (unsigned long)dmi->driver_data;
+		/* apply the quirk only to on-board controllers */
+		return slot == PCI_SLOT(pdev->devfn);
+	}
+
+	return false;
+}
+
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
  *	@pdev: PCI device to register
@@ -1422,6 +1448,14 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	if (!in_module_init)
 		return -ENODEV;
 
+	if (piix_broken_system_poweroff(pdev)) {
+		piix_port_info[ent->driver_data].flags |=
+				ATA_FLAG_NO_POWEROFF_SPINDOWN |
+					ATA_FLAG_NO_HIBERNATE_SPINDOWN;
+		dev_info(&pdev->dev, "quirky BIOS, skipping spindown "
+				"on poweroff and hibernation\n");
+	}
+
 	port_info[0] = piix_port_info[ent->driver_data];
 	port_info[1] = piix_port_info[ent->driver_data];
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a1a6e62..3c4c5ae 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -46,6 +46,7 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 
 #include "libata.h"
 
@@ -1303,6 +1304,17 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
 	} else {
+		/* Some odd clown BIOSen issue spindown on power off (ACPI S4
+		 * or S5) causing some drives to spin up and down again.
+		 */
+		if ((qc->ap->flags & ATA_FLAG_NO_POWEROFF_SPINDOWN) &&
+		    system_state == SYSTEM_POWER_OFF)
+			goto skip;
+
+		if ((qc->ap->flags & ATA_FLAG_NO_HIBERNATE_SPINDOWN) &&
+		     system_entering_hibernation())
+			goto skip;
+
 		/* XXX: This is for backward compatibility, will be
 		 * removed.  Read Documentation/feature-removal-schedule.txt
 		 * for more info.
@@ -1326,8 +1338,7 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 				scmd->scsi_done = qc->scsidone;
 				qc->scsidone = ata_delayed_done;
 			}
-			scmd->result = SAM_STAT_GOOD;
-			return 1;
+			goto skip;
 		}
 
 		/* Issue ATA STANDBY IMMEDIATE command */
@@ -1343,10 +1354,13 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 
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
 
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 564c142..bfd55b0 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -695,11 +695,38 @@ static void sil_init_controller(struct ata_host *host)
 	}
 }
 
+static bool sil_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq nx6325",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x12UL,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+
+	if (dmi) {
+		unsigned long slot = (unsigned long)dmi->driver_data;
+		/* apply the quirk only to on-board controllers */
+		return slot == PCI_SLOT(pdev->devfn);
+	}
+
+	return false;
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
@@ -713,6 +740,13 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (board_id == sil_3114)
 		n_ports = 4;
 
+	if (sil_broken_system_poweroff(pdev)) {
+		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN |
+					ATA_FLAG_NO_HIBERNATE_SPINDOWN;
+		dev_info(&pdev->dev, "quirky BIOS, skipping spindown "
+				"on poweroff and hibernation\n");
+	}
+
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index d76adfe..8f0f7c4 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -415,6 +415,29 @@ void __init dmi_scan_machine(void)
 }
 
 /**
+ *	dmi_matches - check if dmi_system_id structure matches system DMI data
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_matches(const struct dmi_system_id *dmi)
+{
+	int i;
+
+	WARN(!dmi_initialized, KERN_ERR "dmi check: not initialized yet.\n");
+
+	for (i = 0; i < ARRAY_SIZE(dmi->matches); i++) {
+		int s = dmi->matches[i].slot;
+		if (s == DMI_NONE)
+			continue;
+		if (dmi_ident[s]
+		    && strstr(dmi_ident[s], dmi->matches[i].substr))
+			continue;
+		/* No match */
+		return false;
+	}
+	return true;
+}
+
+/**
  *	dmi_check_system - check system DMI data
  *	@list: array of dmi_system_id structures to match against
  *		All non-null elements of the list must match
@@ -429,32 +452,45 @@ void __init dmi_scan_machine(void)
  */
 int dmi_check_system(const struct dmi_system_id *list)
 {
-	int i, count = 0;
-	const struct dmi_system_id *d = list;
-
-	WARN(!dmi_initialized, KERN_ERR "dmi check: not initialized yet.\n");
-
-	while (d->ident) {
-		for (i = 0; i < ARRAY_SIZE(d->matches); i++) {
-			int s = d->matches[i].slot;
-			if (s == DMI_NONE)
-				continue;
-			if (dmi_ident[s] && strstr(dmi_ident[s], d->matches[i].substr))
-				continue;
-			/* No match */
-			goto fail;
+	int count = 0;
+	const struct dmi_system_id *d;
+
+	for (d = list; d->ident; d++)
+		if (dmi_matches(d)) {
+			count++;
+			if (d->callback && d->callback(d))
+				break;
 		}
-		count++;
-		if (d->callback && d->callback(d))
-			break;
-fail:		d++;
-	}
 
 	return count;
 }
 EXPORT_SYMBOL(dmi_check_system);
 
 /**
+ *	dmi_first_match - find dmi_system_id structure matching system DMI data
+ *	@list: array of dmi_system_id structures to match against
+ *		All non-null elements of the list must match
+ *		their slot's (field index's) data (i.e., each
+ *		list string must be a substring of the specified
+ *		DMI slot's string data) to be considered a
+ *		successful match.
+ *
+ *	Walk the blacklist table until the first match is found.  Return the
+ *	pointer to the matching entry or NULL if there's no match.
+ */
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
+{
+	const struct dmi_system_id *d;
+
+	for (d = list; d->ident; d++)
+		if (dmi_matches(d))
+			return d;
+
+	return NULL;
+}
+EXPORT_SYMBOL(dmi_first_match);
+
+/**
  *	dmi_get_system_info - return DMI data value
  *	@field: data index (see enum dmi_field)
  *
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 3416190..aea2310 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -38,6 +38,7 @@ struct dmi_device {
 #ifdef CONFIG_DMI
 
 extern int dmi_check_system(const struct dmi_system_id *list);
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2c6bd66..bca3ba2 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -187,6 +187,8 @@ enum {
 	ATA_FLAG_PIO_POLLING	= (1 << 9), /* use polling PIO if LLD
 					     * doesn't handle PIO interrupts */
 	ATA_FLAG_NCQ		= (1 << 10), /* host supports NCQ */
+	ATA_FLAG_NO_POWEROFF_SPINDOWN = (1 << 11), /* don't spindown before poweroff */
+	ATA_FLAG_NO_HIBERNATE_SPINDOWN = (1 << 12), /* don't spindown before hibernation */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 2b409c4..c7d9bb1 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -237,6 +237,7 @@ extern int hibernate_nvs_alloc(void);
 extern void hibernate_nvs_free(void);
 extern void hibernate_nvs_save(void);
 extern void hibernate_nvs_restore(void);
+extern bool system_entering_hibernation(void);
 #else /* CONFIG_HIBERNATION */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
@@ -252,6 +253,7 @@ static inline int hibernate_nvs_alloc(void) { return 0; }
 static inline void hibernate_nvs_free(void) {}
 static inline void hibernate_nvs_save(void) {}
 static inline void hibernate_nvs_restore(void) {}
+static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 45e8541..432ee57 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -71,6 +71,14 @@ void hibernation_set_ops(struct platform_hibernation_ops *ops)
 	mutex_unlock(&pm_mutex);
 }
 
+static bool entering_platform_hibernation;
+
+bool system_entering_hibernation(void)
+{
+	return entering_platform_hibernation;
+}
+EXPORT_SYMBOL(system_entering_hibernation);
+
 #ifdef CONFIG_PM_DEBUG
 static void hibernation_debug_sleep(void)
 {
@@ -411,6 +419,7 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Close;
 
+	entering_platform_hibernation = true;
 	suspend_console();
 	error = device_suspend(PMSG_HIBERNATE);
 	if (error) {
@@ -445,6 +454,7 @@ int hibernation_platform_enter(void)
  Finish:
 	hibernation_ops->finish();
  Resume_devices:
+	entering_platform_hibernation = false;
 	device_resume(PMSG_RESTORE);
 	resume_console();
  Close:
