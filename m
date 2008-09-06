Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYIFRTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYIFRTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYIFRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:19:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYIFRTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:19:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] SATA: Blacklist systems that spin off disks during ACPI power off
Date: Sat, 6 Sep 2008 19:23:27 +0200
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200808290002.55026.rjw@sisk.pl> <200808291241.04183.rjw@sisk.pl> <48B7D286.7050104@gmail.com>
In-Reply-To: <48B7D286.7050104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809061923.29020.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 of August 2008, Tejun Heo wrote:
> Rafael J. Wysocki wrote:
> > Actaully, they do belong to it.  This is the part "fixing" the hibernation code
> > path, in which the disk is also powered off unnecessarily.
> > 
> > Well, probably I should use SYSTEM_HIBERNATE_ENTER or something similar
> > instead of SYSTEM_SUSPEND_DISK.
> > 
> > In short, the idea is to change system_state to something specific to the last
> > phase of hibernation (after saving the image) and check that in
> > ata_scsi_start_stop_xlat().  In fact that's completely analogous to what's done
> > for SYSTEM_POWER_OFF in there.
> 
> Ah.. right, missed the added check for SUSPEND_DISK in libata-scsi.c.
> Maybe it's a good idea to note it in the commit message later?

After some more debugging and refinements I've obtained the patch below.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

SATA: Blacklist systems that spin off disks during ACPI power off

Some notebooks from HP have the problem that their BIOSes attempt to
spin down hard drives before entering ACPI system states S4 and S5.
This leads to a yo-yo effect during system power-off shutdown and the
last phase of hibernation when the disk is first spun down by the
kernel and then almost immediately turned on and off by the BIOS.
This, in turn, may result in shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems
using DMI information.  However, only the on-board controlles should
be blacklisted and their PCI slot numbers can be used for this
purpose.  Unfortunately the existing interface for checking DMI
information of the system is not very convenient for this purpose,
because to use it, we would have to define special callback functions
or create a separate struct dmi_system_id table for each blacklisted
system.

To overcome this difficulty introduce a new function
dmi_first_match() returning a pointer to the first entry in an array
of struct dmi_system_id elements that matches the system DMI
information.  Then, we can use this pointer to access the entry's
.driver_data field containing the additional information, such as
the PCI slot number, allowing us to do the desired blacklisting.

Introduce a new libata flag ATA_FLAG_NO_POWEROFF_SPINDOWN that, if
set, will prevent disks from being spun off during system power off
and hibernation (to handle the hibernation case we need a new system
state SYSTEM_HIBERNATE_ENTER that can be checked against by libata,
in analogy with SYSTEM_POWER_OFF).  Use dmi_first_match() to set this
flag for some systems affected by the problem described above (HP nx6325,
HP nx6310, HP 2510p).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/ata/ahci.c          |   32 ++++++++++++++++++++
 drivers/ata/ata_piix.c      |   33 +++++++++++++++++++++
 drivers/ata/libata-scsi.c   |   16 ++++++++--
 drivers/ata/sata_sil.c      |   35 +++++++++++++++++++++-
 drivers/firmware/dmi_scan.c |   69 +++++++++++++++++++++++++++++++++-----------
 include/linux/dmi.h         |    1 
 include/linux/kernel.h      |    2 -
 include/linux/libata.h      |    1 
 kernel/power/disk.c         |    2 +
 9 files changed, 170 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/ata/libata-scsi.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-scsi.c
+++ linux-2.6/drivers/ata/libata-scsi.c
@@ -1181,6 +1181,14 @@ static unsigned int ata_scsi_start_stop_
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
 	} else {
+		/* Some odd clown BIOSen issue spindown on power off (ACPI S4
+		 * or S5) causing some drives to spin up and down again.
+		 */
+		if ((qc->ap->flags & ATA_FLAG_NO_POWEROFF_SPINDOWN) &&
+		    (system_state == SYSTEM_POWER_OFF ||
+		     system_state == SYSTEM_HIBERNATE_ENTER))
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
@@ -603,11 +603,38 @@ static void sil_init_controller(struct a
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
+		return (slot == PCI_SLOT(pdev->devfn));
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
@@ -621,6 +648,12 @@ static int sil_init_one(struct pci_dev *
 	if (board_id == sil_3114)
 		n_ports = 4;
 
+	if (sil_broken_system_poweroff(pdev)) {
+		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
+		dev_info(&pdev->dev,
+			   "quirky BIOS, skipping spindown on poweroff\n");
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
+	ATA_FLAG_NO_POWEROFF_SPINDOWN = (1 << 14), /* don't spindown before poweroff */
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
 
+	system_state = SYSTEM_HIBERNATE_ENTER;
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
Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -247,7 +247,7 @@ extern enum system_states {
 	SYSTEM_HALT,
 	SYSTEM_POWER_OFF,
 	SYSTEM_RESTART,
-	SYSTEM_SUSPEND_DISK,
+	SYSTEM_HIBERNATE_ENTER,
 } system_state;
 
 #define TAINT_PROPRIETARY_MODULE	(1<<0)
Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c
+++ linux-2.6/drivers/ata/ahci.c
@@ -2515,6 +2515,32 @@ static void ahci_p5wdh_workaround(struct
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
+		return (slot == PCI_SLOT(pdev->devfn));
+	}
+
+	return false;
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2604,6 +2630,12 @@ static int ahci_init_one(struct pci_dev 
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
Index: linux-2.6/drivers/firmware/dmi_scan.c
===================================================================
--- linux-2.6.orig/drivers/firmware/dmi_scan.c
+++ linux-2.6/drivers/firmware/dmi_scan.c
@@ -407,6 +407,27 @@ void __init dmi_scan_machine(void)
 }
 
 /**
+ *	dmi_match - check if dmi_system_id structure matches system DMI data
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_match(const struct dmi_system_id *dmi)
+{
+	int i;
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
@@ -421,30 +442,46 @@ void __init dmi_scan_machine(void)
  */
 int dmi_check_system(const struct dmi_system_id *list)
 {
-	int i, count = 0;
-	const struct dmi_system_id *d = list;
+	int count = 0;
+	const struct dmi_system_id *d;
 
-	while (d->ident) {
-		for (i = 0; i < ARRAY_SIZE(d->matches); i++) {
-			int s = d->matches[i].slot;
-			if (s == DMI_NONE)
-				continue;
-			if (dmi_ident[s] && strstr(dmi_ident[s], d->matches[i].substr))
-				continue;
-			/* No match */
-			goto fail;
+	for (d = list; d->ident; d++)
+		if (dmi_match(d)) {
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
+struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
+{
+	int i;
+	const struct dmi_system_id *d;
+
+	for (d = list; d->ident; d++)
+		if (dmi_match(d))
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
Index: linux-2.6/include/linux/dmi.h
===================================================================
--- linux-2.6.orig/include/linux/dmi.h
+++ linux-2.6/include/linux/dmi.h
@@ -75,6 +75,7 @@ struct dmi_device {
 #ifdef CONFIG_DMI
 
 extern int dmi_check_system(const struct dmi_system_id *list);
+struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
Index: linux-2.6/drivers/ata/ata_piix.c
===================================================================
--- linux-2.6.orig/drivers/ata/ata_piix.c
+++ linux-2.6/drivers/ata/ata_piix.c
@@ -1449,6 +1449,32 @@ static void piix_iocfg_bit18_quirk(struc
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
+		return (slot == PCI_SLOT(pdev->devfn));
+	}
+
+	return false;
+}
+
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
  *	@pdev: PCI device to register
@@ -1484,6 +1510,13 @@ static int __devinit piix_init_one(struc
 	if (!in_module_init)
 		return -ENODEV;
 
+	if (piix_broken_system_poweroff(pdev)) {
+		piix_port_info[ent->driver_data].flags |=
+						ATA_FLAG_NO_POWEROFF_SPINDOWN;
+		dev_info(&pdev->dev,
+			   "quirky BIOS, skipping spindown on poweroff\n");
+	}
+
 	port_info[0] = piix_port_info[ent->driver_data];
 	port_info[1] = piix_port_info[ent->driver_data];
 
