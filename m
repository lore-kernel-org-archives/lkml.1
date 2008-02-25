Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYBYNqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYBYNqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYBYNpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:45:50 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42672 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750800AbYBYNpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:45:47 -0500
Date: Mon, 25 Feb 2008 14:45:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       stern@rowland.harvard.edu
Cc: linux-ide@vger.kernel.org
Subject: [ugly patch] Save .15W-.5W by AHCI powersaving
Message-ID: <20080225134558.GA1611@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

This is a patch (very ugly, assumes you have just one disk) to bring
powersaving to AHCI. You need Alan's SCSI autosuspend (attached) patch
as a base.

It saves .5W compared to config with disk spinning, and even .15W
compared to hdparm -y... on my thinkpad x60 anyway.

It is also mandatory first step towards sleepy linux ;-).

								Pavel
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 29e71bd..0197b1f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -259,8 +260,8 @@ static void ahci_fill_cmd_slot(struct ah
 			       u32 opts);
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int ahci_pci_device_resume(struct pci_dev *pdev);
+int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
+int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
 static struct class_device_attribute *ahci_shost_attrs[] = {
@@ -268,6 +269,35 @@ static struct class_device_attribute *ah
 	NULL
 };
 
+struct pci_dev *my_pdev;
+int autosuspend_enabled;
+
+/* The host and its devices are all idle so we can autosuspend */
+static int autosuspend(struct Scsi_Host *host)
+{
+	if (my_pdev && autosuspend_enabled) {
+		printk("ahci: should autosuspend\n");
+		ahci_pci_device_suspend(my_pdev, PMSG_SUSPEND);
+		return 0;
+	} 
+	printk("ahci: autosuspend disabled\n");
+	return -EINVAL;
+}
+
+/* The host needs to be autoresumed */
+static int autoresume(struct Scsi_Host *host)
+{
+	if (my_pdev && autosuspend_enabled) {
+		printk("ahci: should autoresume\n");
+		ahci_pci_device_resume(my_pdev);
+		return 0;
+	}
+	printk("ahci: autoresume disabled\n");
+	return -EINVAL;
+}
+
+
+
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -286,6 +322,8 @@ static struct scsi_host_template ahci_sh
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 	.shost_attrs		= ahci_shost_attrs,
+	.autosuspend		= autosuspend,
+	.autoresume		= autoresume,
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -2300,8 +2356,12 @@ static int ahci_init_one(struct pci_dev 
 	ahci_print_info(host);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
+
+	rc = ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
+	pci_save_state(pdev);
+	my_pdev = pdev;
+	return rc;
 }
 
 static int __init ahci_init(void)
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 4e31071..5c40ac2 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -380,7 +381,7 @@ enum scsi_eh_timer_return ata_scsi_timed
  *	Inherited from SCSI layer (none, can sleep)
  *
  *	RETURNS:
- *	Zero.
+ *	Nothing.
  */
 void ata_scsi_error(struct Scsi_Host *host)
 {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c838e65..0edc25e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -484,6 +484,8 @@ static int scsi_try_host_reset(struct sc
 	if (scsi_autoresume_host(shost) != 0)
 		return FAILED;
 
+	rtn = shost->hostt->eh_host_reset_handler(scmd);
+
 	if (rtn == SUCCESS) {
 		if (!shost->hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
@@ -1577,7 +1579,11 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
+#if 0
+		/* libata uses scsi_error_handler to suspend its parts; we deadlock
+		   if we try to autoresume here */
 		autoresume_rc = scsi_autoresume_host(shost);
+#endif
 		if (shost->transportt->eh_strategy_handler)
 			shost->transportt->eh_strategy_handler(shost);
 		else
@@ -1591,8 +1597,10 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
+#if 0
 		if (autoresume_rc == 0)
 			scsi_autosuspend_host(shost);
+#endif
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 233feee..3c598e0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -67,6 +67,8 @@ #undef SP
 
 static struct kmem_cache *scsi_bidi_sdb_cache;
 
+void scsi_run_queue(struct request_queue *q);
+
 /*
  * Function:	scsi_unprep_request()
  *
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5393e15..25bebc1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -340,6 +340,21 @@ static int scsi_bus_uevent(struct device
 	return 0;
 }
 
+static int scsi_bus_remove(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int err = 0;
+
+	/* reset the prep_fn back to the default since the
+	 * driver may have altered it and it's being removed */
+	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
+
+	if (drv && drv->remove)
+		err = drv->remove(dev);
+
+	return 0;
+}
 
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 16add9a..9ca12d1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1596,6 +1596,8 @@ static int sd_revalidate_disk(struct gen
 	return 0;
 }
 
+struct device *my_scsi_disk; 
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -1715,6 +1717,7 @@ static int sd_probe(struct device *dev)
 
 	scsi_use_ULD_pm(sdp, 1);
 	scsi_autosuspend_device(sdp);
+	my_scsi_disk = dev;
 	return 0;
 
  out_suspend:
@@ -1835,6 +1838,8 @@ static int sd_suspend(struct device *dev
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;
 
+	printk("sleepy: sd_suspend start\n");
+
 	if (!sdkp)
 		return 0;	/* this can happen */
 



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=delme2

From: Alan Stern <stern@rowland.harvard.edu>

Alan Stern's autosuspend-for-SCSI patches.

---
commit 8b534a6dc550b4115627e35535f07753d5612800
tree a8e2b2eafb680fb8c5c5bcad049d29f23f576b43
parent 9c269a8b0695a4b18d36b918cb14b757f73e6a49
author Pavel <pavel@amd.ucw.cz> Mon, 25 Feb 2008 13:43:18 +0100
committer Pavel <pavel@amd.ucw.cz> Mon, 25 Feb 2008 13:43:18 +0100

 Documentation/scsi/scsi_mid_low_api.txt |   50 ++++++++++++++++++++++++++++
 drivers/scsi/Kconfig                    |   12 +++++++
 drivers/scsi/Makefile                   |    3 +-
 drivers/scsi/hosts.c                    |   20 ++++-------
 drivers/scsi/scsi.c                     |    8 ++++
 drivers/scsi/scsi_error.c               |   36 +++++++++++++-------
 drivers/scsi/scsi_lib.c                 |    7 ++--
 drivers/scsi/scsi_priv.h                |   38 +++++++++++++++++++++
 drivers/scsi/scsi_scan.c                |    9 +++++
 drivers/scsi/scsi_sysfs.c               |   56 ++++---------------------------
 drivers/scsi/sd.c                       |   12 ++++++-
 drivers/scsi/sg.c                       |   10 ++++++
 drivers/usb/storage/scsiglue.c          |   35 +++++++++++++++++--
 drivers/usb/storage/usb.c               |   15 ++++----
 include/scsi/scsi_device.h              |   23 ++++++++++++-
 include/scsi/scsi_host.h                |   24 +++++++++++++
 16 files changed, 264 insertions(+), 94 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index a6d5354..98dc005 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -782,6 +782,8 @@ In some cases more detail is given in sc
 The interface functions are listed below in alphabetical order.
 
 Summary:
+   autoresume - perform dynamic (runtime) host resume
+   autosuspend - perform dynamic (runtime) host suspend
    bios_param - fetch head, sector, cylinder info for a disk
    detect - detects HBAs this driver wants to control
    eh_timed_out - notify the host that a command timer expired
@@ -802,6 +804,54 @@ Summary:
 Details:
 
 /**
+ *	autoresume - perform dynamic (runtime) host resume
+ *	@shp: host to resume
+ *
+ *	Resume (return to an operational power level) the specified host.
+ *	Return 0 if the resume was successful, otherwise a negative
+ *	error code.
+ *
+ *	Locks: struct Scsi_Host::pm_mutex held throughout the call.
+ *
+ *	Calling context: process
+ *
+ *	Notes: If the host is not currently suspended, this method does
+ *	need to do anything.
+ *
+ *	Optionally defined in: LLD
+ **/
+    int autoresume(struct Scsi_Host *shp)
+
+
+/**
+ *	autosuspend - perform dynamic (runtime) host suspend
+ *	@shp: host to suspend
+ *
+ *	Suspend (change to a non-operational low-power state) the
+ *	specified host.
+ *	Return 0 if the suspend was successful (or was successfully
+ *	queued, or was successfully ignored), otherwise a negative
+ *	error code.
+ *
+ *	Locks: struct Scsi_Host::pm_mutex held throughout the call.
+ *
+ *	Calling context: process
+ *
+ *	Notes: The suspend need not be carried out immediately (or indeed
+ *	at all); it may be delayed indefinitely.  The real meaning of this
+ *	method call is that all of the host's devices are now idle.  It can
+ *	happen that an autosuspend is quickly followed by an autoresume,
+ *	so it is beneficial if the suspend is delayed by a few seconds.
+ *		A host is assumed to be at full power (resumed) when it is
+ *	first created.  In the absence of errors, the LLD will receive a
+ *	strictly alternating sequence of autosuspend, autoresume,... calls.
+ *
+ *	Optionally defined in: LLD
+ **/
+    int autosuspend(struct Scsi_Host *shp)
+
+
+/**
  *      bios_param - fetch head, sector, cylinder info for a disk
  *      @sdev: pointer to scsi device context (defined in 
  *             include/scsi/scsi_device.h)
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a7a0813..9bada81 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -57,6 +57,18 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_DYNAMIC_PM
+	bool "SCSI dynamic Power Management support (EXPERIMENTAL)"
+	depends on SCSI && PM && EXPERIMENTAL
+	---help---
+	  This option enables support for dynamic (or runtime)
+	  power management of SCSI devices and host adapters.
+	  If you say Y here, you can use the sysfs "power/level"
+	  and "power/autosuspend" files to control manual or
+	  automatic suspend/resume of individual SCSI devices.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 925c26b..634a0e4 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -139,7 +139,8 @@ obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wai
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
-scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
+scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o \
+				   scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 880c78b..250cdab 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -154,24 +154,15 @@ EXPORT_SYMBOL(scsi_host_set_state);
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
-	unsigned long flags;
-	mutex_lock(&shost->scan_mutex);
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_set_state(shost, SHOST_CANCEL))
-		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
-			mutex_unlock(&shost->scan_mutex);
-			return;
-		}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	mutex_unlock(&shost->scan_mutex);
+	if (scsi_pm_host_stop(shost))
+		return;
 	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irq(shost->host_lock);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irq(shost->host_lock);
 
 	transport_unregister_device(&shost->shost_gendev);
 	class_device_unregister(&shost->shost_classdev);
@@ -236,6 +227,7 @@ int scsi_add_host(struct Scsi_Host *shos
 	if (error)
 		goto out_destroy_host;
 
+	scsi_autosuspend_host(shost);
 	scsi_proc_host_add(shost);
 	return error;
 
@@ -386,6 +378,8 @@ struct Scsi_Host *scsi_host_alloc(struct
 	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
 
+	scsi_pm_host_initialize(shost);
+
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
 	if (IS_ERR(shost->ehandler)) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index fecba05..4fa9db4 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1133,15 +1133,20 @@ static int __init init_scsi(void)
 	error = scsi_init_sysctl();
 	if (error)
 		goto cleanup_hosts;
-	error = scsi_sysfs_register();
+	error = scsi_init_pm();
 	if (error)
 		goto cleanup_sysctl;
+	error = scsi_sysfs_register();
+	if (error)
+		goto cleanup_pm;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
+cleanup_pm:
+	scsi_exit_pm();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1161,6 +1166,7 @@ static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
 	scsi_sysfs_unregister();
+	scsi_exit_pm();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
 	scsi_exit_devinfo();
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 045a086..c838e65 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -468,30 +468,32 @@ static void scsi_eh_done(struct scsi_cmn
 
 /**
  * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send hsot reset.
+ * @scmd:	SCSI cmd to send host reset.
  */
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *shost = scmd->device->host;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
 					  __FUNCTION__));
 
 	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
-
-	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
+	if (scsi_autoresume_host(shost) != 0)
+		return FAILED;
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!shost->hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
+		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_report_bus_reset(shost,
 				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
+	scsi_autosuspend_host(shost);
 	return rtn;
 }
 
@@ -503,24 +505,28 @@ static int scsi_try_bus_reset(struct scs
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *shost = scmd->device->host;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __FUNCTION__));
 
-	if (!scmd->device->host->hostt->eh_bus_reset_handler)
+	if (!shost->hostt->eh_bus_reset_handler)
+		return FAILED;
+	if (scsi_autoresume_host(shost) != 0)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
+	rtn = shost->hostt->eh_bus_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!shost->hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
+		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_report_bus_reset(shost,
 				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
+	scsi_autosuspend_host(shost);
 	return rtn;
 }
 
@@ -1541,6 +1547,7 @@ static void scsi_unjam_host(struct Scsi_
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	int autoresume_rc;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -1570,6 +1577,7 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
+		autoresume_rc = scsi_autoresume_host(shost);
 		if (shost->transportt->eh_strategy_handler)
 			shost->transportt->eh_strategy_handler(shost);
 		else
@@ -1583,6 +1591,8 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
+		if (autoresume_rc == 0)
+			scsi_autosuspend_host(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 135c1d0..233feee 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -67,8 +67,6 @@ #undef SP
 
 static struct kmem_cache *scsi_bidi_sdb_cache;
 
-static void scsi_run_queue(struct request_queue *q);
-
 /*
  * Function:	scsi_unprep_request()
  *
@@ -461,6 +459,7 @@ void scsi_device_unbusy(struct scsi_devi
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 	sdev->device_busy--;
+	scsi_mark_last_busy(sdev);
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
 
@@ -522,7 +521,7 @@ static void scsi_single_lun_run(struct s
  * Notes:	The previous command was completely finished, start
  *		a new one if possible.
  */
-static void scsi_run_queue(struct request_queue *q)
+void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
@@ -1201,6 +1200,8 @@ int scsi_prep_state_check(struct scsi_de
 			ret = BLKPREP_KILL;
 			break;
 		case SDEV_QUIESCE:
+			ret = scsi_pm_state_check(sdev, req);
+			break;
 		case SDEV_BLOCK:
 			/*
 			 * If the devices is blocked we defer normal commands.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3f34e93..c331de4 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -4,11 +4,13 @@ #define _SCSI_PRIV_H
 #include <linux/device.h>
 
 struct request_queue;
+struct request;
 struct scsi_cmnd;
 struct scsi_device;
 struct scsi_host_template;
 struct Scsi_Host;
 struct scsi_nl_hdr;
+struct workqueue_struct;
 
 
 /*
@@ -67,6 +69,7 @@ int scsi_eh_get_sense(struct list_head *
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_run_queue(struct request_queue *q);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
@@ -132,6 +135,41 @@ static inline void scsi_netlink_init(voi
 static inline void scsi_netlink_exit(void) {}
 #endif
 
+/* scsi_pm.c */
+extern int scsi_bus_suspend(struct device *, pm_message_t);
+extern int scsi_bus_resume(struct device *);
+extern int scsi_pm_state_check(struct scsi_device *, struct request *);
+extern int scsi_pm_device_stop(struct scsi_device *);
+extern int scsi_pm_host_stop(struct Scsi_Host *);
+#ifdef CONFIG_SCSI_DYNAMIC_PM
+extern void scsi_autosuspend_host(struct Scsi_Host *);
+extern int scsi_autoresume_host(struct Scsi_Host *);
+extern void scsi_pm_host_initialize(struct Scsi_Host *);
+extern void scsi_mark_last_busy(struct scsi_device *);
+extern void scsi_use_ULD_pm(struct scsi_device *, int);
+extern void scsi_autosuspend_device(struct scsi_device *);
+extern int scsi_autoresume_device(struct scsi_device *);
+extern int scsi_pm_create_device_files(struct scsi_device *);
+extern void scsi_pm_device_initialize(struct scsi_device *);
+extern int scsi_init_pm(void);
+extern void scsi_exit_pm(void);
+#else
+static inline void scsi_autosuspend_host(struct Scsi_Host *shost)	{}
+static inline int scsi_autoresume_host(struct Scsi_Host *shost)
+					{ return 0; }
+static inline void scsi_pm_host_initialize(struct Scsi_Host *shost)	{}
+static inline void scsi_mark_last_busy(struct scsi_device *sdev)	{}
+static inline void scsi_use_ULD_pm(struct scsi_device *sdev, int v)	{}
+static inline void scsi_autosuspend_device(struct scsi_device *sdev)	{}
+static inline int scsi_autoresume_device(struct scsi_device *sdev)
+					{ return 0; }
+static inline int scsi_pm_create_device_files(struct scsi_device *sdev)
+					{ return 0; }
+static inline void scsi_pm_device_initialize(struct scsi_device *sdev)	{}
+static inline int scsi_init_pm(void)	{ return 0; }
+static inline void scsi_exit_pm(void)	{}
+#endif /* CONFIG_SCSI_DYNAMIC_PM */
+
 /* 
  * internal scsi timeout functions: for use by mid-layer and transport
  * classes.
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1dc165a..c48a143 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -297,6 +297,9 @@ static struct scsi_device *scsi_alloc_sd
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
 	scsi_sysfs_device_initialize(sdev);
+	scsi_pm_device_initialize(sdev);
+	if (scsi_autoresume_host(shost) != 0)
+		goto out_device_destroy;
 
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);
@@ -307,6 +310,7 @@ static struct scsi_device *scsi_alloc_sd
 			 */
 			if (ret == -ENXIO)
 				display_failure_msg = 0;
+			scsi_autosuspend_host(shost);
 			goto out_device_destroy;
 		}
 	}
@@ -922,6 +926,7 @@ static int scsi_add_lun(struct scsi_devi
 static inline void scsi_destroy_sdev(struct scsi_device *sdev)
 {
 	scsi_device_set_state(sdev, SDEV_DEL);
+	scsi_autosuspend_host(sdev->host);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(&sdev->sdev_gendev);
@@ -1084,6 +1089,7 @@ static int scsi_probe_and_add_lun(struct
 
 	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
+		scsi_autosuspend_device(sdev);
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
 			scsi_unlock_floptical(sdev, result);
@@ -1785,6 +1791,8 @@ static void scsi_finish_async_scan(struc
 
 static void do_scsi_scan_host(struct Scsi_Host *shost)
 {
+	if (scsi_autoresume_host(shost) != 0)
+		return;
 	if (shost->hostt->scan_finished) {
 		unsigned long start = jiffies;
 		if (shost->hostt->scan_start)
@@ -1796,6 +1804,7 @@ static void do_scsi_scan_host(struct Scs
 		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
 				SCAN_WILD_CARD, 0);
 	}
+	scsi_autosuspend_host(shost);
 }
 
 static int do_scan_async(void *_data)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ed83cdb..5393e15 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -340,54 +340,6 @@ static int scsi_bus_uevent(struct device
 	return 0;
 }
 
-static int scsi_bus_suspend(struct device * dev, pm_message_t state)
-{
-	struct device_driver *drv = dev->driver;
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int err;
-
-	err = scsi_device_quiesce(sdev);
-	if (err)
-		return err;
-
-	if (drv && drv->suspend) {
-		err = drv->suspend(dev, state);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int scsi_bus_resume(struct device * dev)
-{
-	struct device_driver *drv = dev->driver;
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int err = 0;
-
-	if (drv && drv->resume)
-		err = drv->resume(dev);
-
-	scsi_device_resume(sdev);
-
-	return err;
-}
-
-static int scsi_bus_remove(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int err = 0;
-
-	/* reset the prep_fn back to the default since the
-	 * driver may have altered it and it's being removed */
-	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
-
-	if (drv && drv->remove)
-		err = drv->remove(dev);
-
-	return 0;
-}
 
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
@@ -814,6 +766,12 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		goto out;
 	}
 
+	error = scsi_pm_create_device_files(sdev);
+	if (error) {
+		__scsi_remove_device(sdev);
+		goto out;
+	}
+
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);
 
 	if (error)
@@ -854,7 +812,7 @@ void __scsi_remove_device(struct scsi_de
 {
 	struct device *dev = &sdev->sdev_gendev;
 
-	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+	if (scsi_pm_device_stop(sdev) != 0)
 		return;
 
 	bsg_unregister_queue(sdev->request_queue);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 37df8bb..16add9a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -61,6 +61,7 @@ #include <scsi/scsicam.h>
 #include <scsi/sd.h>
 
 #include "scsi_logging.h"
+#include "scsi_priv.h"
 
 MODULE_AUTHOR("Eric Youngdale");
 MODULE_DESCRIPTION("SCSI disk (sd) driver");
@@ -1649,6 +1650,10 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
+	error = scsi_autoresume_device(sdp);
+	if (error)
+		goto out_put;
+
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -1668,7 +1673,7 @@ static int sd_probe(struct device *dev)
 	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
 
 	if (class_device_add(&sdkp->cdev))
-		goto out_put;
+		goto out_suspend;
 
 	get_device(&sdp->sdev_gendev);
 
@@ -1708,8 +1713,12 @@ static int sd_probe(struct device *dev)
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 
+	scsi_use_ULD_pm(sdp, 1);
+	scsi_autosuspend_device(sdp);
 	return 0;
 
+ out_suspend:
+	scsi_autosuspend_device(sdp);
  out_put:
 	put_disk(gd);
  out_free:
@@ -1735,6 +1744,7 @@ static int sd_remove(struct device *dev)
 
 	class_device_del(&sdkp->cdev);
 	del_gendisk(sdkp->disk);
+	scsi_use_ULD_pm(sdkp->device, 0);
 	sd_shutdown(dev);
 
 	mutex_lock(&sd_ref_mutex);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index e5156aa..27e3669 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -57,6 +57,7 @@ #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 
+#include "scsi_priv.h"
 #include "scsi_logging.h"
 
 #ifdef CONFIG_SCSI_PROC_FS
@@ -226,6 +227,7 @@ sg_open(struct inode *inode, struct file
 	Sg_fd *sfp;
 	int res;
 	int retval;
+	int autoresume_rc = 1;
 
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
@@ -241,6 +243,10 @@ sg_open(struct inode *inode, struct file
 	if (retval)
 		return retval;
 
+	retval = autoresume_rc = scsi_autoresume_device(sdp->device);
+	if (retval)
+		goto error_out;
+
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -298,6 +304,8 @@ sg_open(struct inode *inode, struct file
 	return 0;
 
       error_out:
+	if (autoresume_rc == 0)
+		scsi_autosuspend_device(sdp->device);
 	scsi_device_put(sdp->device);
 	return retval;
 }
@@ -313,6 +321,8 @@ sg_release(struct inode *inode, struct f
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 	sg_fasync(-1, filp, 0);	/* remove filp from async notification list */
+	scsi_autosuspend_device(sdp->device);
+
 	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
 		if (!sdp->detached) {
 			scsi_device_put(sdp->device);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 8c1e295..ca954fa 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -299,10 +299,15 @@ static int device_reset(struct scsi_cmnd
 
 	US_DEBUGP("%s called\n", __FUNCTION__);
 
-	/* lock the device pointers and do the reset */
-	mutex_lock(&(us->dev_mutex));
-	result = us->transport_reset(us);
-	mutex_unlock(&us->dev_mutex);
+	result = usb_autopm_get_interface(us->pusb_intf);
+	if (result == 0) {
+
+		/* lock the device pointers and do the reset */
+		mutex_lock(&(us->dev_mutex));
+		result = us->transport_reset(us);
+		mutex_unlock(&us->dev_mutex);
+		usb_autopm_put_interface(us->pusb_intf);
+	}
 
 	return result < 0 ? FAILED : SUCCESS;
 }
@@ -345,6 +350,24 @@ void usb_stor_report_bus_reset(struct us
 	scsi_unlock(host);
 }
 
+/* The host and its devices are all idle so we can autosuspend */
+static int autosuspend(struct Scsi_Host *host)
+{
+	struct us_data *us = host_to_us(host);
+
+	usb_autopm_put_interface(us->pusb_intf);
+	return 0;
+}
+
+/* The host needs to be autoresumed */
+static int autoresume(struct Scsi_Host *host)
+{
+	struct us_data *us = host_to_us(host);
+
+	return usb_autopm_get_interface(us->pusb_intf);
+}
+
+
 /***********************************************************************
  * /proc/scsi/ functions
  ***********************************************************************/
@@ -471,6 +494,10 @@ struct scsi_host_template usb_stor_host_
 	.eh_device_reset_handler =	device_reset,
 	.eh_bus_reset_handler =		bus_reset,
 
+	/* dynamic power management */
+	.autosuspend =			autosuspend,
+	.autoresume =			autoresume,
+
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
 	.cmd_per_lun =			1,
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index ac6114e..a574646 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -184,16 +184,14 @@ static int storage_suspend(struct usb_in
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
+	US_DEBUGP("%s\n", __FUNCTION__);
+
 	/* Wait until no command is running */
 	mutex_lock(&us->dev_mutex);
 
-	US_DEBUGP("%s\n", __FUNCTION__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_SUSPEND);
 
-	/* When runtime PM is working, we'll set a flag to indicate
-	 * whether we should autoresume when a SCSI request arrives. */
-
 	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
@@ -202,13 +200,10 @@ static int storage_resume(struct usb_int
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-	mutex_lock(&us->dev_mutex);
-
 	US_DEBUGP("%s\n", __FUNCTION__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_RESUME);
 
-	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
 
@@ -928,6 +923,7 @@ static int usb_stor_scan_thread(void * _
 		/* Should we unbind if no devices were detected? */
 	}
 
+	usb_autopm_put_interface(us->pusb_intf);
 	complete_and_exit(&us->scanning_done, 0);
 }
 
@@ -957,6 +953,9 @@ static int storage_probe(struct usb_inte
 		return -ENOMEM;
 	}
 
+	/* Don't autosuspend until the SCSI core tells us */
+	usb_autopm_get_interface(intf);
+
 	/*
 	 * Allow 16-byte CDBs and thus > 2TB
 	 */
@@ -1017,6 +1016,7 @@ static int storage_probe(struct usb_inte
 		goto BadDevice;
 	}
 
+	usb_autopm_get_interface(intf); /* dropped in the scanning thread */
 	wake_up_process(th);
 
 	return 0;
@@ -1054,6 +1054,7 @@ #endif
 	.pre_reset =	storage_pre_reset,
 	.post_reset =	storage_post_reset,
 	.id_table =	storage_usb_ids,
+	.supports_autosuspend = 1,
 };
 
 static int __init usb_stor_init(void)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ab7acbe..1c181c4 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -36,8 +36,9 @@ enum scsi_device_state {
 				 * Only error handler commands allowed */
 	SDEV_DEL,		/* device deleted 
 				 * no commands allowed */
-	SDEV_QUIESCE,		/* Device quiescent.  No block commands
-				 * will be accepted, only specials (which
+	SDEV_QUIESCE,		/* Device quiescent or suspended.
+				 * No block commands will be accepted,
+				 * only specials (which
 				 * originate in the mid-layer) */
 	SDEV_OFFLINE,		/* Device offlined (by error handling or
 				 * user request */
@@ -161,6 +162,24 @@ #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
 	struct execute_work	ew; /* used to get process context on put */
 
+#ifdef CONFIG_SCSI_DYNAMIC_PM
+	struct mutex pm_mutex;		/* protect PM data & operations */
+	struct work_struct autoresume_work;
+
+	unsigned long last_busy;	/* time of last use */
+	int autosuspend_delay;		/* delay in jiffies */
+	int pm_usage_cnt;		/* usage counter for autosuspend */
+
+	unsigned is_suspended:1;
+	unsigned pm_in_progress:1;	/* performing suspend or resume */
+	unsigned auto_pm:1;		/* doing autosuspend or autoresume */
+	unsigned autosuspend_disabled:1;	/* autosuspend & autoresume */
+	unsigned autoresume_disabled:1;		/*  disabled by the user */
+	unsigned skip_sys_resume:1;	/* skip the next system resume */
+	unsigned use_ULD_pm:1;		/* call the Upper-Level Driver's
+					 *   suspend/resume methods */
+#endif /* CONFIG_SCSI_DYNAMIC_PM */
+
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 530ff4c..906c4b5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -176,6 +176,22 @@ #endif
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
 
 	/*
+	 * Power management routines.  These are optional; you should
+	 * implement them if you want your LLD to perform dynamic Power
+	 * Management.  The autosuspend method will be called whenever
+	 * all the devices below a host have been suspended (are in an
+	 * idle state), at which time the host adapter can safely be
+	 * autosuspended.  The autoresume method will be called whenever
+	 * a suspended host must be resumed for one of its devices to
+	 * carry out a command.  Both routines are always called in a
+	 * process context with interrupts enabled.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* autosuspend)(struct Scsi_Host *);
+	int (* autoresume)(struct Scsi_Host *);
+
+	/*
 	 * Before the mid layer attempts to scan for a new device where none
 	 * currently exists, it will call this entry in your driver.  Should
 	 * your driver need to allocate any structs or perform any other init
@@ -657,6 +673,14 @@ struct Scsi_Host {
 	struct device		shost_gendev;
 	struct class_device	shost_classdev;
 
+#ifdef CONFIG_SCSI_DYNAMIC_PM
+	struct mutex pm_mutex;		/* protect PM data & operations */
+	struct delayed_work autosuspend_work;
+
+	int pm_usage_cnt;		/* usage counter for autosuspend */
+	unsigned is_suspended:1;
+#endif /* CONFIG_SCSI_DYNAMIC_PM */
+
 	/*
 	 * List of hosts per template.
 	 *

--ReaqsoxgOBHFXBhH--
