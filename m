Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYBWSPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYBWSPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbYBWSPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:15:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49267 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760511AbYBWSPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:15:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: [PATCH] PM: Introduce PM_EVENT_HIBERNATE (was: Re: i915 hibernation patch (was: Re: 2.6.25-rc2 System no longer ...))
Date: Sat, 23 Feb 2008 19:13:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <alpine.LFD.1.00.0802221805540.21332@woody.linux-foundation.org> <b6a2187b0802222036i33d5bcc2n4e3bafd6d846cc09@mail.gmail.com>
In-Reply-To: <b6a2187b0802222036i33d5bcc2n4e3bafd6d846cc09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802231913.27592.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 23 of February 2008, Jeff Chua wrote:
> On Sat, Feb 23, 2008 at 10:07 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> 
> >  On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:
> >  > OK, please have a look at the modified patch below.
> >
> >  All right, I'm fine with it. Now we just need to confirm that it works for
> >  people..
> 
> Looks good. Applied Rafael patch on top of your latest git tree that
> has Jesse's i915 fix.
> 
> No green screen. Tested with STD (platform), STR, and plain echo mem >
> /sys/power/state.

Thanks for testing.  Below is the final version of the patch with a changelog
etc.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

During the last step of hibernation in the "platform" mode (with the
help of ACPI) we use the suspend code, including the devices'
->suspend() methods, to prepare the system for entering the ACPI S4
system sleep state.  At least for some devices the operations
performed by the ->suspend() callback in that case must be different
from its operations during regular suspend.  For this reason,
introduce the new PM event type PM_EVENT_HIBERNATE and pass it to
the device drivers' ->suspend() methods during the last phase of
hibernation, so that they can distinguish this case and handle it as
appropriate.  Modify the drivers that handle PM_EVENT_SUSPEND in a
special way and need to handle PM_EVENT_HIBERNATE in the same way.

These changes are necessary to fix a hibernation regression related
to the i915 driver (ref. http://lkml.org/lkml/2008/2/22/488).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
---
 Documentation/power/devices.txt        |   13 ++++++++-----
 drivers/ata/ahci.c                     |    2 +-
 drivers/ata/ata_piix.c                 |    2 +-
 drivers/ata/libata-core.c              |    2 +-
 drivers/ide/ppc/pmac.c                 |    4 ++--
 drivers/macintosh/mediabay.c           |    3 ++-
 drivers/pci/pci.c                      |    1 +
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    2 +-
 drivers/scsi/mesh.c                    |    1 +
 drivers/scsi/sd.c                      |    3 +--
 drivers/usb/host/sl811-hcd.c           |    1 +
 drivers/usb/host/u132-hcd.c            |   11 ++++++++---
 drivers/video/chipsfb.c                |    2 +-
 drivers/video/nvidia/nvidia.c          |    2 +-
 include/linux/pm.h                     |    9 ++++++++-
 kernel/power/disk.c                    |    4 ++--
 net/rfkill/rfkill.c                    |    2 +-
 18 files changed, 42 insertions(+), 24 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -391,7 +391,7 @@ int hibernation_platform_enter(void)
 		goto Close;
 
 	suspend_console();
-	error = device_suspend(PMSG_SUSPEND);
+	error = device_suspend(PMSG_HIBERNATE);
 	if (error)
 		goto Resume_console;
 
@@ -404,7 +404,7 @@ int hibernation_platform_enter(void)
 		goto Finish;
 
 	local_irq_disable();
-	error = device_power_down(PMSG_SUSPEND);
+	error = device_power_down(PMSG_HIBERNATE);
 	if (!error) {
 		hibernation_ops->enter();
 		/* We should never get here */
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -143,6 +143,9 @@ typedef struct pm_message {
  * 		the upcoming system state (such as PCI_D3hot), and enable
  * 		wakeup events as appropriate.
  *
+ * HIBERNATE	Enter a low power device state appropriate for the hibernation
+ * 		state (eg. ACPI S4) and enable wakeup events as appropriate.
+ *
  * FREEZE	Quiesce operations so that a consistent image can be saved;
  * 		but do NOT otherwise enter a low power device state, and do
  * 		NOT emit system wakeup events.
@@ -166,11 +169,15 @@ typedef struct pm_message {
 #define PM_EVENT_ON 0
 #define PM_EVENT_FREEZE 1
 #define PM_EVENT_SUSPEND 2
-#define PM_EVENT_PRETHAW 3
+#define PM_EVENT_HIBERNATE 4
+#define PM_EVENT_PRETHAW 8
+
+#define PM_EVENT_SLEEP	(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
 
 #define PMSG_FREEZE	((struct pm_message){ .event = PM_EVENT_FREEZE, })
 #define PMSG_PRETHAW	((struct pm_message){ .event = PM_EVENT_PRETHAW, })
 #define PMSG_SUSPEND	((struct pm_message){ .event = PM_EVENT_SUSPEND, })
+#define PMSG_HIBERNATE	((struct pm_message){ .event = PM_EVENT_HIBERNATE, })
 #define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
 
 struct dev_pm_info {
Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c
+++ linux-2.6/drivers/ata/ahci.c
@@ -1932,7 +1932,7 @@ static int ahci_pci_device_suspend(struc
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	u32 ctl;
 
-	if (mesg.event == PM_EVENT_SUSPEND) {
+	if (mesg.event & PM_EVENT_SLEEP) {
 		/* AHCI spec rev1.1 section 8.3.3:
 		 * Software must disable interrupts prior to requesting a
 		 * transition of the HBA to D3 state.
Index: linux-2.6/drivers/ata/ata_piix.c
===================================================================
--- linux-2.6.orig/drivers/ata/ata_piix.c
+++ linux-2.6/drivers/ata/ata_piix.c
@@ -1339,7 +1339,7 @@ static int piix_pci_device_suspend(struc
 	 * cycles and power trying to do something to the sleeping
 	 * beauty.
 	 */
-	if (piix_broken_suspend() && mesg.event == PM_EVENT_SUSPEND) {
+	if (piix_broken_suspend() && (mesg.event & PM_EVENT_SLEEP)) {
 		pci_save_state(pdev);
 
 		/* mark its power state as "unknown", since we don't
Index: linux-2.6/drivers/ata/libata-core.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-core.c
+++ linux-2.6/drivers/ata/libata-core.c
@@ -7368,7 +7368,7 @@ void ata_pci_device_do_suspend(struct pc
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 
-	if (mesg.event == PM_EVENT_SUSPEND)
+	if (mesg.event & PM_EVENT_SLEEP)
 		pci_set_power_state(pdev, PCI_D3hot);
 }
 
Index: linux-2.6/drivers/ide/ppc/pmac.c
===================================================================
--- linux-2.6.orig/drivers/ide/ppc/pmac.c
+++ linux-2.6/drivers/ide/ppc/pmac.c
@@ -1254,7 +1254,7 @@ pmac_ide_macio_suspend(struct macio_dev 
 	int		rc = 0;
 
 	if (mesg.event != mdev->ofdev.dev.power.power_state.event
-			&& mesg.event == PM_EVENT_SUSPEND) {
+			&& (mesg.event & PM_EVENT_SLEEP)) {
 		rc = pmac_ide_do_suspend(hwif);
 		if (rc == 0)
 			mdev->ofdev.dev.power.power_state = mesg;
@@ -1364,7 +1364,7 @@ pmac_ide_pci_suspend(struct pci_dev *pde
 	int		rc = 0;
 	
 	if (mesg.event != pdev->dev.power.power_state.event
-			&& mesg.event == PM_EVENT_SUSPEND) {
+			&& (mesg.event & PM_EVENT_SLEEP)) {
 		rc = pmac_ide_do_suspend(hwif);
 		if (rc == 0)
 			pdev->dev.power.power_state = mesg;
Index: linux-2.6/drivers/macintosh/mediabay.c
===================================================================
--- linux-2.6.orig/drivers/macintosh/mediabay.c
+++ linux-2.6/drivers/macintosh/mediabay.c
@@ -698,7 +698,8 @@ static int media_bay_suspend(struct maci
 {
 	struct media_bay_info	*bay = macio_get_drvdata(mdev);
 
-	if (state.event != mdev->ofdev.dev.power.power_state.event && state.event == PM_EVENT_SUSPEND) {
+	if (state.event != mdev->ofdev.dev.power.power_state.event
+	    && (state.event & PM_EVENT_SLEEP)) {
 		down(&bay->lock);
 		bay->sleeping = 1;
 		set_mb_power(bay, 0);
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -554,6 +554,7 @@ pci_power_t pci_choose_state(struct pci_
 	case PM_EVENT_PRETHAW:
 		/* REVISIT both freeze and pre-thaw "should" use D0 */
 	case PM_EVENT_SUSPEND:
+	case PM_EVENT_HIBERNATE:
 		return PCI_D3hot;
 	default:
 		printk("Unrecognized suspend event %d\n", state.event);
Index: linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -89,7 +89,7 @@ ahd_linux_pci_dev_suspend(struct pci_dev
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 
-	if (mesg.event == PM_EVENT_SUSPEND)
+	if (mesg.event & PM_EVENT_SLEEP)
 		pci_set_power_state(pdev, PCI_D3hot);
 
 	return rc;
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -134,7 +134,7 @@ ahc_linux_pci_dev_suspend(struct pci_dev
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 
-	if (mesg.event == PM_EVENT_SUSPEND)
+	if (mesg.event & PM_EVENT_SLEEP)
 		pci_set_power_state(pdev, PCI_D3hot);
 
 	return rc;
Index: linux-2.6/drivers/scsi/mesh.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mesh.c
+++ linux-2.6/drivers/scsi/mesh.c
@@ -1759,6 +1759,7 @@ static int mesh_suspend(struct macio_dev
 
 	switch (mesg.event) {
 	case PM_EVENT_SUSPEND:
+	case PM_EVENT_HIBERNATE:
 	case PM_EVENT_FREEZE:
 		break;
 	default:
Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c
+++ linux-2.6/drivers/scsi/sd.c
@@ -1835,8 +1835,7 @@ static int sd_suspend(struct device *dev
 			goto done;
 	}
 
-	if (mesg.event == PM_EVENT_SUSPEND &&
-	    sdkp->device->manage_start_stop) {
+	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
 	}
Index: linux-2.6/drivers/usb/host/sl811-hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/sl811-hcd.c
+++ linux-2.6/drivers/usb/host/sl811-hcd.c
@@ -1766,6 +1766,7 @@ sl811h_suspend(struct platform_device *d
 		retval = sl811h_bus_suspend(hcd);
 		break;
 	case PM_EVENT_SUSPEND:
+	case PM_EVENT_HIBERNATE:
 	case PM_EVENT_PRETHAW:		/* explicitly discard hw state */
 		port_power(sl811, 0);
 		break;
Index: linux-2.6/drivers/usb/host/u132-hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/u132-hcd.c
+++ linux-2.6/drivers/usb/host/u132-hcd.c
@@ -3214,14 +3214,19 @@ static int u132_suspend(struct platform_
                 return -ESHUTDOWN;
         } else {
                 int retval = 0;
-                if (state.event == PM_EVENT_FREEZE) {
+
+		switch (state.event) {
+		case PM_EVENT_FREEZE:
                         retval = u132_bus_suspend(hcd);
-                } else if (state.event == PM_EVENT_SUSPEND) {
+			break;
+		case PM_EVENT_SUSPEND:
+		case PM_EVENT_HIBERNATE:
                         int ports = MAX_U132_PORTS;
                         while (ports-- > 0) {
                                 port_power(u132, ports, 0);
                         }
-                }
+			break;
+		}
                 if (retval == 0)
                         pdev->dev.power.power_state = state;
                 return retval;
Index: linux-2.6/drivers/video/chipsfb.c
===================================================================
--- linux-2.6.orig/drivers/video/chipsfb.c
+++ linux-2.6/drivers/video/chipsfb.c
@@ -459,7 +459,7 @@ static int chipsfb_pci_suspend(struct pc
 
 	if (state.event == pdev->dev.power.power_state.event)
 		return 0;
-	if (state.event != PM_EVENT_SUSPEND)
+	if (!(state.event & PM_EVENT_SLEEP))
 		goto done;
 
 	acquire_console_sem();
Index: linux-2.6/drivers/video/nvidia/nvidia.c
===================================================================
--- linux-2.6.orig/drivers/video/nvidia/nvidia.c
+++ linux-2.6/drivers/video/nvidia/nvidia.c
@@ -1066,7 +1066,7 @@ static int nvidiafb_suspend(struct pci_d
 	acquire_console_sem();
 	par->pm_state = mesg.event;
 
-	if (mesg.event == PM_EVENT_SUSPEND) {
+	if (mesg.event & PM_EVENT_SLEEP) {
 		fb_set_suspend(info, 1);
 		nvidiafb_blank(FB_BLANK_POWERDOWN, info);
 		nvidia_write_regs(par, &par->SavedReg);
Index: linux-2.6/net/rfkill/rfkill.c
===================================================================
--- linux-2.6.orig/net/rfkill/rfkill.c
+++ linux-2.6/net/rfkill/rfkill.c
@@ -232,7 +232,7 @@ static int rfkill_suspend(struct device 
 	struct rfkill *rfkill = to_rfkill(dev);
 
 	if (dev->power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND) {
+		if (state.event & PM_EVENT_SLEEP) {
 			mutex_lock(&rfkill->mutex);
 
 			if (rfkill->state == RFKILL_STATE_ON)
Index: linux-2.6/Documentation/power/devices.txt
===================================================================
--- linux-2.6.orig/Documentation/power/devices.txt
+++ linux-2.6/Documentation/power/devices.txt
@@ -310,9 +310,12 @@ used with suspend-to-disk:
     PM_EVENT_SUSPEND -- quiesce the driver and put hardware into a low-power
 	state.  When used with system sleep states like "suspend-to-RAM" or
 	"standby", the upcoming resume() call will often be able to rely on
-	state kept in hardware, or issue system wakeup events.  When used
-	instead with suspend-to-disk, few devices support this capability;
-	most are completely powered off.
+	state kept in hardware, or issue system wakeup events.
+
+    PM_EVENT_HIBERNATE -- Put hardware into a low-power state and enable wakeup
+	events as appropriate.  It is only used with hibernation
+	(suspend-to-disk) and few devices are able to wake up the system from
+	this state; most are completely powered off.
 
     PM_EVENT_FREEZE -- quiesce the driver, but don't necessarily change into
 	any low power mode.  A system snapshot is about to be taken, often
@@ -329,8 +332,8 @@ used with suspend-to-disk:
 	wakeup events nor DMA are allowed.
 
 To enter "standby" (ACPI S1) or "Suspend to RAM" (STR, ACPI S3) states, or
-the similarly named APM states, only PM_EVENT_SUSPEND is used; for "Suspend
-to Disk" (STD, hibernate, ACPI S4), all of those event codes are used.
+the similarly named APM states, only PM_EVENT_SUSPEND is used; the other event
+codes are used for hibernation ("Suspend to Disk", STD, ACPI S4).
 
 There's also PM_EVENT_ON, a value which never appears as a suspend event
 but is sometimes used to record the "not suspended" device state.
