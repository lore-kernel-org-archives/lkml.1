Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYHMKgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYHMKgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYHMKfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:35:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58198 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYHMKfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:35:52 -0400
Date: Wed, 13 Aug 2008 11:50:55 +0200
From: Pavel Machek <pavel@suse.cz>
To: stern@rowland.harvard.edu, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       James.Bottomley@HansenPartnership.com, teheo@novell.com
Cc: oneukum@suse.de
Subject: Power management for SCSI
Message-ID: <20080813095055.GA475@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alan Stern <stern@rowland.harvard.edu>

Add support for autosuspend/autoresume. Lowlevel driver can use it to
spin the disk down and power down its SATA link, to turn off the USB
interface, etc.

Spinning down the disk is useful - saves ~0.5W here. Powering down
SATA controller is even better -- should save ~1W.

Now, I guess the patch will need to be split to small pieces for
merge... I tried to rearrange it so that the documentation and hooks
go before stuff that needs the hooks, and before Kconfig enabler. If
it looks reasonably good, I'll split it into smaller pieces.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <teheo@novell.com>


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

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 79f0f75..70b1eca 100644
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
@@ -134,6 +137,41 @@ static inline void scsi_netlink_init(voi
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



diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 291d56a..9aa96e9 100644
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
@@ -163,6 +164,24 @@ #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
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
 	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 44a55d1..b60445f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -177,6 +177,22 @@ #endif
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
@@ -659,6 +675,14 @@ struct Scsi_Host {
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
 
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

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index fed0b02..2ec7fa1 100644
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
 	device_unregister(&shost->shost_dev);
@@ -246,6 +237,7 @@ int scsi_add_host(struct Scsi_Host *shos
 	if (error)
 		goto out_destroy_host;
 
+	scsi_autosuspend_host(shost);
 	scsi_proc_host_add(shost);
 	return error;
 
@@ -402,6 +394,8 @@ #endif
 		 shost->host_no);
 	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
 
+	scsi_pm_host_initialize(shost);
+
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
 	if (IS_ERR(shost->ehandler)) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ee6be59..a638bc5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1279,15 +1279,20 @@ static int __init init_scsi(void)
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
@@ -1307,6 +1312,7 @@ static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
 	scsi_sysfs_unregister();
+	scsi_exit_pm();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
 	scsi_exit_devinfo();
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 880051c..0cb7448 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -482,30 +482,32 @@ static void scsi_eh_done(struct scsi_cmn
 
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
 					  __func__));
 
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
 
@@ -517,24 +519,28 @@ static int scsi_try_bus_reset(struct scs
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *shost = scmd->device->host;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __func__));
 
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
 
@@ -1646,6 +1652,7 @@ static void scsi_unjam_host(struct Scsi_
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	int autoresume_rc;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -1675,6 +1682,7 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
+		autoresume_rc = scsi_autoresume_host(shost);
 		if (shost->transportt->eh_strategy_handler)
 			shost->transportt->eh_strategy_handler(shost);
 		else
@@ -1688,6 +1696,8 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
+		if (autoresume_rc == 0)
+			scsi_autosuspend_host(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ff5d56b..f6d8c75 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -67,8 +67,6 @@ #undef SP
 
 struct kmem_cache *scsi_sdb_cache;
 
-static void scsi_run_queue(struct request_queue *q);
-
 /*
  * Function:	scsi_unprep_request()
  *
@@ -470,6 +468,7 @@ void scsi_device_unbusy(struct scsi_devi
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 	sdev->device_busy--;
+	scsi_mark_last_busy(sdev);
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
 
@@ -531,7 +530,7 @@ static void scsi_single_lun_run(struct s
  * Notes:	The previous command was completely finished, start
  *		a new one if possible.
  */
-static void scsi_run_queue(struct request_queue *q)
+void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
@@ -1249,6 +1248,8 @@ int scsi_prep_state_check(struct scsi_de
 			ret = BLKPREP_KILL;
 			break;
 		case SDEV_QUIESCE:
+			ret = scsi_pm_state_check(sdev, req);
+			break;
 		case SDEV_BLOCK:
 			/*
 			 * If the devices is blocked we defer normal commands.

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 72fd504..9ab631c 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -143,7 +143,8 @@ obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wai
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
-scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
+scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o \
+				   scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o


diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
new file mode 100644
index 0000000..e76f1bd
--- /dev/null
+++ b/drivers/scsi/scsi_pm.c
@@ -0,0 +1,860 @@
+/*
+ *	scsi_pm.c	Copyright (C) 2008 Alan Stern
+ *
+ *	SCSI dynamic Power Management
+ *		Initial version: Alan Stern <stern@rowland.harvard.edu>
+ */
+
+#define DEBUG
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include <linux/delay.h>
+
+#include "scsi_priv.h"
+
+#define shost_dbg(shost, format, arg...)	\
+		dev_dbg(&shost->shost_gendev , format , ## arg)
+#define sdev_dbg(sdev, format, arg...)		\
+		dev_dbg(&sdev->sdev_gendev , format , ## arg)
+
+#ifdef CONFIG_SCSI_DYNAMIC_PM
+
+/* This value is completely arbitrary.  Should it be a module parameter? */
+#define SCSI_DEFAULT_AUTOSUSPEND_DELAY	(30*HZ)
+
+/* Workqueue for autosuspend and autoresume of devices and hosts */
+struct workqueue_struct *ksuspend_scsi_wq;
+
+static void scsi_try_autosuspend_device(struct scsi_device *);
+static int autosuspend_check(struct scsi_device *);
+
+/**
+ * scsi_autosuspend_host - autosuspend a SCSI host
+ * @shost: the Scsi_Host to autosuspend
+ *
+ * This routine should be called when a core subsystem is finished using
+ * @shost and wants to allow it to autosuspend.  @shost's usage counter
+ * is decremented.  If the result is non-positive and the host is in the
+ * proper state, an autosuspend request will be forwarded to the LLD.
+ *
+ * This routine can run only in process context.
+ */
+void scsi_autosuspend_host(struct Scsi_Host *shost)
+{
+	mutex_lock(&shost->pm_mutex);
+	--shost->pm_usage_cnt;
+	WARN_ON(shost->pm_usage_cnt < 0);
+	if (shost->pm_usage_cnt <= 0 && !shost->is_suspended &&
+			shost->shost_state == SHOST_RUNNING) {
+		WARN_ON(shost->host_busy);
+		if (!shost->hostt->autosuspend ||
+				shost->hostt->autosuspend(shost) == 0) {
+			shost->is_suspended = 1;
+			shost_dbg(shost, "suspended\n");
+		}
+	}
+	mutex_unlock(&shost->pm_mutex);
+}
+
+/**
+ * scsi_autoresume_host - autoresume a SCSI host
+ * @shost: the Scsi_Host to autoresume
+ *
+ * This routine should be called when a core subsystem wants to use @shost
+ * and needs to guarantee that it is not suspended.  No autosuspend will
+ * occur until scsi_autosuspend_host is called.  (Note that this will not
+ * prevent suspend events originating in the PM core.)
+ *
+ * @shost's usage counter is incremented to prevent subsequent autosuspends.
+ * If @shost was suspended, an autoresume request is forwarded to the LLD.
+ * If the autoresume fails, the usage counter is re-decremented.
+ *
+ * This routine can run only in process context.
+ */
+
+int scsi_autoresume_host(struct Scsi_Host *shost)
+{
+	int status = 0;
+
+	mutex_lock(&shost->pm_mutex);
+	++shost->pm_usage_cnt;
+	if (shost->is_suspended) {
+		if (shost->hostt->autoresume &&
+				(shost->shost_state == SHOST_RUNNING ||
+				 shost->shost_state == SHOST_RECOVERY))
+			status = shost->hostt->autoresume(shost);
+		if (status == 0) {
+			shost->is_suspended = 0;
+			shost_dbg(shost, "resumed\n");
+		} else {
+			--shost->pm_usage_cnt;
+		}
+	}
+	mutex_unlock(&shost->pm_mutex);
+	return status;
+}
+
+#define SCAN_INTERVAL	(10 * HZ)	/* Autosuspend scan every 10 seconds */
+#define MAX_ATTEMPTS	3		/* Max autosuspend attempts */
+
+/**
+ * periodic_autosuspend_scan - try to autosuspend devices under a host
+ * @shost: host whose devices should be scanned for autosuspend
+ *
+ * Every so often (the default interval is 10 seconds but the actual
+ * interval can be shorter) all the devices under a host are checked to
+ * see if any of them can be autosuspended.  This check is also made
+ * whenever a device's state changes so that it may be autosuspended.
+ * If any devices are in a suspendable state (i.e., not prohibited from
+ * autosuspending) but their idle-time delay hasn't yet expired, another
+ * scan is scheduled.
+ */
+static void periodic_autosuspend_scan(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	int any_suspendable;
+	int min_delay;
+	int num_attempts = 0;
+	int status;
+	unsigned long delay;
+
+ restart:
+	any_suspendable = 0;
+	min_delay = SCAN_INTERVAL;
+	spin_lock_irq(shost->host_lock);
+
+	/* Check each device below this host */
+	__shost_for_each_device(sdev, shost) {
+		if (sdev->is_suspended)
+			continue;
+		status = autosuspend_check(sdev);
+		if (status == -EPERM)
+			continue;
+
+		/* The device is suspendable.  Should it be autosuspended? */
+		if (status == 0) {
+			if (num_attempts < MAX_ATTEMPTS) {
+				++num_attempts;
+				spin_unlock_irq(shost->host_lock);
+				scsi_try_autosuspend_device(sdev);
+				goto restart;
+			}
+			status = HZ;	/* Try again later */
+		}
+		if (status >= 0)
+			min_delay = min(min_delay, status);
+		any_suspendable = 1;
+	}
+
+	/* If any devices are still suspendable, rearm the periodic scan */
+	if (any_suspendable && (shost->shost_state == SHOST_RUNNING ||
+			shost->shost_state == SHOST_RECOVERY)) {
+
+		/* Round the delay up to the nearest second */
+		delay = round_jiffies_relative(min_delay);
+		if (delay < min_delay)
+			delay += HZ;
+		queue_delayed_work(ksuspend_scsi_wq, &shost->autosuspend_work,
+				delay);
+	}
+	spin_unlock_irq(shost->host_lock);
+}
+
+/* Periodic autosuspend workqueue routine */
+static void autosuspend_shost_work(struct work_struct *work)
+{
+	struct Scsi_Host *shost =
+		container_of(work, struct Scsi_Host, autosuspend_work.work);
+
+	periodic_autosuspend_scan(shost);
+}
+
+void scsi_pm_host_initialize(struct Scsi_Host *shost)
+{
+	mutex_init(&shost->pm_mutex);
+	INIT_DELAYED_WORK(&shost->autosuspend_work, autosuspend_shost_work);
+	shost->pm_usage_cnt = 1;
+}
+
+int scsi_pm_host_stop(struct Scsi_Host *shost)
+{
+	int rc = 0;
+
+	/* Prevent new device addition and synchronize with any ongoing
+	 * PM activity.
+	 */
+	mutex_lock(&shost->scan_mutex);
+	mutex_lock(&shost->pm_mutex);
+	spin_lock_irq(shost->host_lock);
+	if (scsi_host_set_state(shost, SHOST_CANCEL))
+		rc = scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);
+	spin_unlock_irq(shost->host_lock);
+	mutex_unlock(&shost->pm_mutex);
+	mutex_unlock(&shost->scan_mutex);
+
+	/* Stop any autosuspend requests already pending */
+	cancel_delayed_work_sync(&shost->autosuspend_work);
+	return rc;
+}
+
+/*
+ * Internal routine to check whether we may autosuspend a device.
+ * The return value isn't fully reliable unless the caller holds
+ * the device's request-queue lock.
+ */
+static int autosuspend_check(struct scsi_device *sdev)
+{
+	unsigned long suspend_time;
+
+	if (sdev->autosuspend_delay < 0 || sdev->autosuspend_disabled
+			|| sdev->pm_usage_cnt > 0)
+		return -EPERM;
+	if (sdev->device_busy > 0)
+		return -EBUSY;
+	if (!(sdev->sdev_state == SDEV_RUNNING ||
+			sdev->sdev_state == SDEV_QUIESCE))
+		return -ENODEV;
+
+	suspend_time = sdev->last_busy + sdev->autosuspend_delay;
+	if (time_before(jiffies, suspend_time))
+		return suspend_time - jiffies;
+	return 0;
+}
+
+/* Record the time the device was most recently busy */
+void scsi_mark_last_busy(struct scsi_device *sdev)
+{
+	sdev->last_busy = jiffies;
+}
+
+/* Allow/disallow calls to the Upper-Level Driver's suspend/resume methods */
+void scsi_use_ULD_pm(struct scsi_device *sdev, int v)
+{
+	mutex_lock(&sdev->pm_mutex);
+	sdev->use_ULD_pm = v;
+	mutex_unlock(&sdev->pm_mutex);
+}
+EXPORT_SYMBOL_GPL(scsi_use_ULD_pm);
+
+static void device_may_be_suspendable(struct scsi_device *sdev)
+{
+	int status;
+
+	/* sdev's state has changed and as a result it may now be
+	 * suspendable.
+	 */
+	if (sdev->is_suspended)
+		return;
+	status = autosuspend_check(sdev);
+	if (status == -EPERM)
+		return;
+
+	/* It is suspendable, so schedule a periodic host scan
+	 * unless one is already pending.
+	 */
+	if (!timer_pending(&sdev->host->autosuspend_work.timer))
+		periodic_autosuspend_scan(sdev->host);
+}
+
+/**
+ * scsi_suspend_sdev - suspend a SCSI device
+ * @sdev: the scsi_device to suspend
+ * @msg: Power Management message describing this state transition
+ *
+ * SCSI devices can't actually be suspended in a literal sense,
+ * because SCSI doesn't have any notion of power management.  Instead
+ * this routine drains the request queue and calls the ULD's suspend
+ * method to flush caches, spin-down drives, and so on.
+ *
+ * If the suspend succeeds, we call scsi_autosuspend_host to decrement
+ * the host's count of unsuspended devices and invoke the LLD's suspend
+ * method.
+ *
+ * The caller must hold @sdev->pm_mutex.
+ *
+ * This routine can run only in process context.
+ */
+static int scsi_suspend_sdev(struct scsi_device *sdev, pm_message_t msg)
+{
+	struct device_driver *drv = sdev->sdev_gendev.driver;
+	int status = 0;
+	enum scsi_device_state oldstate;
+
+	/*
+	 * If the device is already suspended, offline or going away
+	 * then succeed immediately.  Otherwise the device must be
+	 * either running or quiescent.
+	 */
+	if (sdev->is_suspended)
+		goto done;
+
+	spin_lock_irq(sdev->request_queue->queue_lock);
+	oldstate = sdev->sdev_state;
+	if (sdev->auto_pm)
+		status = autosuspend_check(sdev);
+	if (status == 0) {
+		sdev->pm_in_progress = 1;
+		status = scsi_device_set_state(sdev, SDEV_QUIESCE);
+		if (status)
+			sdev->pm_in_progress = 0;
+	}
+	spin_unlock_irq(sdev->request_queue->queue_lock);
+	if (status)
+		goto done;
+
+	/* Unfortunate duplication of code in scsi_device_quiesce()... */
+	scsi_run_queue(sdev->request_queue);
+	while (sdev->device_busy) {
+		msleep_interruptible(200);
+		scsi_run_queue(sdev->request_queue);
+	}
+	if (sdev->auto_pm)	/* sdev->last_busy may have changed */
+		status = autosuspend_check(sdev);
+
+	if (status == 0 && drv && drv->suspend && sdev->use_ULD_pm)
+		status = drv->suspend(&sdev->sdev_gendev, msg);
+
+	spin_lock_irq(sdev->request_queue->queue_lock);
+	sdev->pm_in_progress = 0;
+	if (status == 0)
+		sdev->is_suspended = 1;
+	else
+		scsi_device_set_state(sdev, oldstate);
+	spin_unlock_irq(sdev->request_queue->queue_lock);
+
+	/* If the suspend succeeded, inform the transport and
+	 * propagate it up to the host.
+	 */
+	if (status == 0) {
+		sdev_dbg(sdev, "suspended\n");
+		/* FIXME: Inform the transport */
+		scsi_autosuspend_host(sdev->host);
+	}
+
+ done:
+//	if (status == 0)
+//		sdev->sdev_gendev.power.power_state.event = msg.event;
+	return status;
+}
+
+/**
+ * scsi_resume_sdev - resume a SCSI device
+ * @sdev: the scsi_device to resume
+ *
+ * SCSI devices can't actually be resumed in a literal sense,
+ * because SCSI doesn't have any notion of power management.  Instead
+ * this routine calls the ULD's resume method to spin-up drives, etc.,
+ * and starts executing commands from the request queue.
+ *
+ * Before doing the resume, we call scsi_autoresume_host to increment
+ * the host's count of unsuspended devices and invoke the LLD's resume
+ * method.
+ *
+ * The caller must hold @sdev->pm_mutex.
+ *
+ * This routine can run only in process context.
+ */
+static int scsi_resume_sdev(struct scsi_device *sdev)
+{
+	struct device_driver *drv = sdev->sdev_gendev.driver;
+	int status = 0;
+
+	if (!sdev->is_suspended)
+		goto done;
+	if (sdev->sdev_state != SDEV_QUIESCE) {
+		status = -ENODEV;
+		goto done;
+	}
+	if (sdev->auto_pm && sdev->autoresume_disabled) {
+		status = -EPERM;
+		goto done;
+	}
+
+	/* Propagate the resume up to the host and inform the transport */
+	status = scsi_autoresume_host(sdev->host);
+	if (status)
+		goto done;
+	/* FIXME: Inform the transport */
+
+	spin_lock_irq(sdev->request_queue->queue_lock);
+	if (sdev->sdev_state != SDEV_QUIESCE) {
+		status = -ENODEV;
+	} else {
+		sdev->is_suspended = 0;
+		sdev->pm_in_progress = 1;
+	}
+	spin_unlock_irq(sdev->request_queue->queue_lock);
+
+	if (status == 0 && drv && drv->resume && sdev->use_ULD_pm)
+		status = drv->resume(&sdev->sdev_gendev);
+
+	/* Unfortunate duplication of code in scsi_device_resume()... */
+	spin_lock_irq(sdev->request_queue->queue_lock);
+	sdev->pm_in_progress = 0;
+	if (status == 0)
+		status = scsi_device_set_state(sdev, SDEV_RUNNING);
+	spin_unlock_irq(sdev->request_queue->queue_lock);
+
+	if (status == 0) {
+		sdev_dbg(sdev, "resumed\n");
+		scsi_run_queue(sdev->request_queue);
+	} else {
+		/* Propagate resume failure to the host and the transport */
+		/* FIXME: inform the transport */
+		scsi_autosuspend_host(sdev->host);
+	}
+ done:
+//	if (status == 0)
+//		sdev->sdev_gendev.power.power_state.event = PM_EVENT_ON;
+	return status;
+}
+
+/* callback routine to autoresume a SCSI device */
+static void autoresume_sdev_work(struct work_struct *work)
+{
+	struct scsi_device *sdev =
+		container_of(work, struct scsi_device, autoresume_work);
+
+	printk("autoresume_sdev_work\n");
+	mutex_lock(&sdev->pm_mutex);
+	sdev->auto_pm = 1;
+	printk("autoresume_sdev_work: have mutex\n");
+	scsi_resume_sdev(sdev);
+	printk("autoresume_sdev_work: resume_sdev done\n");
+	mutex_unlock(&sdev->pm_mutex);
+	printk("autoresume_sdev_work: may be suspendable\n");
+	device_may_be_suspendable(sdev);
+	printk("autoresume_sdev_work: done\n");
+}
+
+/**
+ * scsi_autosuspend_device - autosuspend a SCSI device
+ * @sdev: the scsi_device to autosuspend
+ *
+ * This routine should be called when a core subsystem is finished using
+ * @sdev and wants to allow it to autosuspend.  @sdev's usage counter
+ * is decremented.  If the result is non-positive and the device is in the
+ * proper state, it will be suspended.
+ *
+ * This routine can run only in process context.
+ */
+void scsi_autosuspend_device(struct scsi_device *sdev)
+{
+	mutex_lock(&sdev->pm_mutex);
+	sdev->auto_pm = 1;
+	--sdev->pm_usage_cnt;
+	WARN_ON(sdev->pm_usage_cnt < 0);
+	if (sdev->pm_usage_cnt <= 0) {
+		if (scsi_suspend_sdev(sdev, PMSG_SUSPEND) != 0)
+			device_may_be_suspendable(sdev);
+	}
+	mutex_unlock(&sdev->pm_mutex);
+}
+EXPORT_SYMBOL_GPL(scsi_autosuspend_device);
+
+/**
+ * scsi_autoresume_device - autoresume a SCSI device
+ * @sdev: the scsi_device to autoresume
+ *
+ * This routine should be called when a core subsystem wants to use @sdev
+ * and needs to guarantee that it is not suspended.  No autosuspend will
+ * occur until scsi_autosuspend_device is called.  (Note that this will not
+ * prevent suspend events originating in the PM core.)
+ *
+ * @sdev's usage counter is incremented to prevent subsequent autosuspends.
+ * If @sdev was suspended, an autoresume is attempted.  If the autoresume
+ * fails, the usage counter is re-decremented.
+ *
+ * This routine can run only in process context.
+ */
+int scsi_autoresume_device(struct scsi_device *sdev)
+{
+	int status = 0;
+
+	mutex_lock(&sdev->pm_mutex);
+	sdev->auto_pm = 1;
+	++sdev->pm_usage_cnt;
+	sdev->last_busy = jiffies;
+	if (sdev->is_suspended) {
+		status = scsi_resume_sdev(sdev);
+		if (status != 0)
+			--sdev->pm_usage_cnt;
+	}
+	mutex_unlock(&sdev->pm_mutex);
+	return status;
+}
+EXPORT_SYMBOL_GPL(scsi_autoresume_device);
+
+/**
+ * scsi_try_autosuspend_device - attempt an autosuspend of a SCSI device
+ * @sdev: the scsi_device to autosuspend
+ *
+ * This routine should be called when a core subsystem thinks @sdev may
+ * be ready to autosuspend.  @sdev's usage counter is left unchanged.
+ * If it is greater than 0 or autosuspend is not allowed for any other
+ * reason, nothing will happen.  Otherwise @sdev will be suspended.
+ *
+ * This routine can run only in process context.
+ */
+static void scsi_try_autosuspend_device(struct scsi_device *sdev)
+{
+	mutex_lock(&sdev->pm_mutex);
+	sdev->auto_pm = 1;
+	if (sdev->pm_usage_cnt <= 0)
+		scsi_suspend_sdev(sdev, PMSG_SUSPEND);
+	mutex_unlock(&sdev->pm_mutex);
+}
+
+/**
+ * scsi_external_suspend_device - external suspend of a SCSI device
+ * @sdev: the scsi_device to suspend
+ * @msg: Power Management message describing this state transition
+ *
+ * This routine handles external suspend requests: ones not generated
+ * internally by a SCSI driver (autosuspend) but rather coming from the user
+ * (via sysfs) or the PM core (system sleep).  The suspend will be carried
+ * out regardless of @sdev's usage counter.  Of course, the Upper-Level
+ * Driver still has the option of failing the suspend.
+ *
+ * The caller must hold @sdev's device lock.
+ */
+static int scsi_external_suspend_device(struct scsi_device *sdev,
+		pm_message_t msg)
+{
+	int status;
+
+	mutex_lock(&sdev->pm_mutex);
+	sdev->auto_pm = 0;
+	status = scsi_suspend_sdev(sdev, msg);
+	mutex_unlock(&sdev->pm_mutex);
+	return status;
+}
+
+/**
+ * scsi_external_resume_device - external resume of a SCSI device
+ * @sdev: the scsi_device to resume
+ *
+ * This routine handles external resume requests: ones not generated
+ * internally by a SCSI driver (autoresume) but rather coming from the user
+ * (via sysfs), the PM core (system resume).  @sdev's usage counter is
+ * unaffected.
+ *
+ * The caller must hold @sdev's device lock.
+ */
+static int scsi_external_resume_device(struct scsi_device *sdev)
+{
+	int status;
+
+	mutex_lock(&sdev->pm_mutex);
+	sdev->auto_pm = 0;
+	status = scsi_resume_sdev(sdev);
+	sdev->last_busy = jiffies;
+	mutex_unlock(&sdev->pm_mutex);
+
+	/* Now that the device is awake, we can start trying to autosuspend
+	 * it again. */
+	device_may_be_suspendable(sdev);
+	return status;
+}
+
+/* Bus method invoked by the PM core for system sleep */
+int scsi_bus_suspend(struct device *dev, pm_message_t message)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int ret;
+
+	printk("sleepy: scsi_bus_suspend start\n");
+
+	/* If sdev is already suspended, we can skip this suspend and
+	 * we may also want to skip the upcoming system resume. */
+	if (sdev->is_suspended) {
+		sdev->skip_sys_resume = sdev->autoresume_disabled;
+		return 0;
+	}
+
+	sdev->skip_sys_resume = 0;
+	ret = scsi_external_suspend_device(sdev, message);
+	printk("sleepy: scsi_bus_suspend done\n");
+	return ret;
+}
+
+/* Bus method invoked by the PM core for system awakening */
+int scsi_bus_resume(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int ret;
+
+	printk("sleepy: scsi_bus_resume start\n");
+	if (sdev->skip_sys_resume)
+		return -EHOSTUNREACH;
+	ret = scsi_external_resume_device(sdev);
+	printk("sleepy: scsi_bus_resume done\n");
+	return ret;
+}
+
+/* Subroutine for scsi_prep_state_check().  This handles state checking
+ * when the device is in the SDEV_QUIESCE state.
+ */
+int scsi_pm_state_check(struct scsi_device *sdev, struct request *req)
+{
+	/*
+	 * Special commands are allowed through if the device is merely
+	 * quiescent.  Some are allowed if it is in the process of
+	 * suspending or resuming.
+	 */
+	if ((req->cmd_flags & REQ_PREEMPT) && !sdev->is_suspended) {
+		if (!sdev->pm_in_progress)
+			return BLKPREP_OK;
+
+		/* Only certain commands are allowed during a transition */
+		if (req->cmd[0] == TEST_UNIT_READY ||
+				req->cmd[0] == START_STOP ||
+				req->cmd[0] == SYNCHRONIZE_CACHE)
+			return BLKPREP_OK;
+	}
+
+	/*
+	 * If the device is suspending or suspended and autoresume is
+	 * enabled, queue a wakeup request.  But if autoresume isn't
+	 * enabled then the command fails immediately.
+	 */
+	if (sdev->is_suspended || sdev->pm_in_progress) {
+		if (sdev->autoresume_disabled)
+			return BLKPREP_KILL;
+		queue_work(ksuspend_scsi_wq, &sdev->autoresume_work);
+	}
+	return BLKPREP_DEFER;
+}
+
+/* Power-Management-related sysfs device attributes */
+
+static const char power_group[] = "power";
+
+static ssize_t
+show_autosuspend(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return sprintf(buf, "%d\n", sdev->autosuspend_delay / HZ);
+}
+
+static ssize_t
+set_autosuspend(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int value;
+
+	if (sscanf(buf, "%d", &value) != 1 || value >= INT_MAX/HZ ||
+			value <= - INT_MAX/HZ)
+		return -EINVAL;
+	value *= HZ;
+
+	sdev->autosuspend_delay = value;
+	if (value >= 0) {
+		scsi_try_autosuspend_device(sdev);
+		device_may_be_suspendable(sdev);
+	} else {
+		if (scsi_autoresume_device(sdev) == 0)
+			scsi_autosuspend_device(sdev);
+	}
+	return count;
+}
+
+static DEVICE_ATTR(autosuspend, S_IRUGO | S_IWUSR,
+		show_autosuspend, set_autosuspend);
+
+static const char on_string[] = "on";
+static const char auto_string[] = "auto";
+static const char suspend_string[] = "suspend";
+
+static ssize_t
+show_level(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	const char *p = auto_string;
+
+	if (sdev->is_suspended) {
+		if (sdev->autoresume_disabled)
+			p = suspend_string;
+	} else {
+		if (sdev->autosuspend_disabled)
+			p = on_string;
+	}
+	return sprintf(buf, "%s\n", p);
+}
+
+static ssize_t
+set_level(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int len = count;
+	char *cp;
+	int rc = 0;
+	int old_autosuspend_disabled, old_autoresume_disabled;
+
+	cp = memchr(buf, '\n', count);
+	if (cp)
+		len = cp - buf;
+
+	down(&sdev->sdev_gendev.sem);
+	old_autosuspend_disabled = sdev->autosuspend_disabled;
+	old_autoresume_disabled = sdev->autoresume_disabled;
+
+	/* Setting the flags without locking sdev->pm_mutex is a subject to
+	 * races, but who cares...
+	 */
+	if (len == sizeof on_string - 1 &&
+			strncmp(buf, on_string, len) == 0) {
+		sdev->autosuspend_disabled = 1;
+		sdev->autoresume_disabled = 0;
+		rc = scsi_external_resume_device(sdev);
+
+	} else if (len == sizeof auto_string - 1 &&
+			strncmp(buf, auto_string, len) == 0) {
+		sdev->autosuspend_disabled = 0;
+		sdev->autoresume_disabled = 0;
+		rc = scsi_external_resume_device(sdev);
+
+	} else if (len == sizeof suspend_string - 1 &&
+			strncmp(buf, suspend_string, len) == 0) {
+		sdev->autosuspend_disabled = 0;
+		sdev->autoresume_disabled = 1;
+		rc = scsi_external_suspend_device(sdev, PMSG_SUSPEND);
+
+	} else
+		rc = -EINVAL;
+
+	if (rc) {
+		sdev->autosuspend_disabled = old_autosuspend_disabled;
+		sdev->autoresume_disabled = old_autoresume_disabled;
+	}
+	up(&sdev->sdev_gendev.sem);
+	return (rc < 0 ? rc : count);
+}
+
+static DEVICE_ATTR(level, S_IRUGO | S_IWUSR, show_level, set_level);
+
+int scsi_pm_create_device_files(struct scsi_device *sdev)
+{
+	int rc;
+
+	rc = sysfs_add_file_to_group(&sdev->sdev_gendev.kobj,
+				&dev_attr_autosuspend.attr, power_group);
+	if (rc == 0)
+		rc = sysfs_add_file_to_group(&sdev->sdev_gendev.kobj,
+				&dev_attr_level.attr, power_group);
+	return rc;
+}
+
+void scsi_pm_device_initialize(struct scsi_device *sdev)
+{
+	mutex_init(&sdev->pm_mutex);
+	INIT_WORK(&sdev->autoresume_work, autoresume_sdev_work);
+	sdev->autosuspend_delay = SCSI_DEFAULT_AUTOSUSPEND_DELAY;
+	sdev->autosuspend_disabled = 1;
+	sdev->pm_usage_cnt = 1;
+}
+
+int scsi_pm_device_stop(struct scsi_device *sdev)
+{
+	int rc;
+
+	/* Synchronize with any ongoing PM activity */
+	mutex_lock(&sdev->pm_mutex);
+	rc = scsi_device_set_state(sdev, SDEV_CANCEL);
+
+	/* Decrement the host's count of unsuspended children */
+	if (rc == 0 && !sdev->is_suspended)
+		scsi_autosuspend_host(sdev->host);
+	mutex_unlock(&sdev->pm_mutex);
+
+	/* Stop any autoresume requests already submitted */
+	cancel_work_sync(&sdev->autoresume_work);
+	return rc;
+}
+
+/* Create the ksuspend_scsid workqueue thread */
+int __init scsi_init_pm(void)
+{
+	/* This workqueue is supposed to be both freezable and
+	 * singlethreaded.  Its job doesn't justify running on more
+	 * than one CPU.
+	 */
+	ksuspend_scsi_wq = create_singlethread_workqueue("ksuspend_scsid");
+	if (!ksuspend_scsi_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+void __exit scsi_exit_pm(void)
+{
+	destroy_workqueue(ksuspend_scsi_wq);
+}
+
+#else /* CONFIG_SCSI_DYNAMIC_PM */
+
+/* Legacy bus suspend method */
+int scsi_bus_suspend(struct device *dev, pm_message_t message)
+{
+	struct device_driver *drv = dev->driver;
+	int err;
+
+	BUG();
+
+	err = scsi_device_quiesce(to_scsi_device(dev));
+	if (!err && drv && drv->suspend)
+		err = drv->suspend(dev, message);
+	return err;
+}
+
+/* Legacy bus resume method */
+int scsi_bus_resume(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int err = 0;
+
+	BUG();
+
+	if (drv && drv->resume)
+		err = drv->resume(dev);
+	scsi_device_resume(to_scsi_device(dev));
+	return err;
+}
+
+/* Legacy subroutine for scsi_prep_state_check().  This handles state checking
+ * when the device is in the SDEV_QUIESCE state.
+ */
+int scsi_pm_state_check(struct scsi_device *sdev, struct request *req)
+{
+	/*
+	 * If the device is blocked we defer normal commands.
+	 */
+	if (!(req->cmd_flags & REQ_PREEMPT))
+		return BLKPREP_DEFER;
+	return BLKPREP_OK;
+}
+
+int scsi_pm_device_stop(struct scsi_device *sdev)
+{
+	return scsi_device_set_state(sdev, SDEV_DEL);
+}
+
+int scsi_pm_host_stop(struct Scsi_Host *shost)
+{
+	int rc = 0;
+
+	mutex_lock(&shost->scan_mutex);
+	spin_lock_irq(shost->host_lock);
+	if (scsi_host_set_state(shost, SHOST_CANCEL))
+		rc = scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);
+	spin_unlock_irq(shost->host_lock);
+	mutex_unlock(&shost->scan_mutex);
+	return rc;
+}
+
+#endif /* CONFIG_SCSI_DYNAMIC_PM */
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 84b4879..99de5d1 100644
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
@@ -927,6 +931,7 @@ static int scsi_add_lun(struct scsi_devi
 static inline void scsi_destroy_sdev(struct scsi_device *sdev)
 {
 	scsi_device_set_state(sdev, SDEV_DEL);
+	scsi_autosuspend_host(sdev->host);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(&sdev->sdev_gendev);
@@ -1090,6 +1095,7 @@ static int scsi_probe_and_add_lun(struct
 
 	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
+		scsi_autosuspend_device(sdev);
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
 			scsi_unlock_floptical(sdev, result);
@@ -1789,6 +1795,8 @@ static void scsi_finish_async_scan(struc
 
 static void do_scsi_scan_host(struct Scsi_Host *shost)
 {
+	if (scsi_autoresume_host(shost) != 0)
+		return;
 	if (shost->hostt->scan_finished) {
 		unsigned long start = jiffies;
 		if (shost->hostt->scan_start)
@@ -1800,6 +1808,7 @@ static void do_scsi_scan_host(struct Scs
 		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
 				SCAN_WILD_CARD, 0);
 	}
+	scsi_autosuspend_host(shost);
 }
 
 static int do_scan_async(void *_data)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ab3c718..ac16a39 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -374,74 +374,12 @@ static int scsi_bus_uevent(struct device
 	return 0;
 }
 
-static int scsi_bus_suspend(struct device * dev, pm_message_t state)
-{
-	struct device_driver *drv;
-	struct scsi_device *sdev;
-	int err;
-
-	if (dev->type != &scsi_dev_type)
-		return 0;
-
-	drv = dev->driver;
-	sdev = to_scsi_device(dev);
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
-	struct device_driver *drv;
-	struct scsi_device *sdev;
-	int err = 0;
-
-	if (dev->type != &scsi_dev_type)
-		return 0;
-
-	drv = dev->driver;
-	sdev = to_scsi_device(dev);
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
-
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
 	.suspend	= scsi_bus_suspend,
 	.resume		= scsi_bus_resume,
-	.remove		= scsi_bus_remove,
 };
 EXPORT_SYMBOL_GPL(scsi_bus_type);
 
@@ -899,6 +837,12 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		goto out;
 	}
 
+	error = scsi_pm_create_device_files(sdev);
+	if (error) {
+		__scsi_remove_device(sdev);
+		goto out;
+	}
+
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
 
 	if (error)
@@ -939,7 +883,7 @@ void __scsi_remove_device(struct scsi_de
 {
 	struct device *dev = &sdev->sdev_gendev;
 
-	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+	if (scsi_pm_device_stop(sdev) != 0)
 		return;
 
 	bsg_unregister_queue(sdev->request_queue);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..65dd73c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -61,6 +61,7 @@ #include <scsi/scsicam.h>
 
 #include "sd.h"
 #include "scsi_logging.h"
+#include "scsi_priv.h"
 
 MODULE_AUTHOR("Eric Youngdale");
 MODULE_DESCRIPTION("SCSI disk (sd) driver");
@@ -1815,6 +1816,10 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
+	error = scsi_autoresume_device(sdp);
+	if (error)
+		goto out_put;
+
 	error = -EBUSY;
 	if (index >= SD_MAX_DISKS)
 		goto out_free_index;
@@ -1880,8 +1885,12 @@ static int sd_probe(struct device *dev)
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 
+	scsi_use_ULD_pm(sdp, 1);
+	scsi_autosuspend_device(sdp);
 	return 0;
 
+ out_suspend:
+	scsi_autosuspend_device(sdp);
  out_free_index:
 	ida_remove(&sd_index_ida, index);
  out_put:
@@ -1909,6 +1918,7 @@ static int sd_remove(struct device *dev)
 
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
+	scsi_use_ULD_pm(sdkp->device, 0);
 	sd_shutdown(dev);
 
 	mutex_lock(&sd_ref_mutex);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3d36270..bd53ae3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -58,6 +58,7 @@ #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 
+#include "scsi_priv.h"
 #include "scsi_logging.h"
 
 #ifdef CONFIG_SCSI_PROC_FS
@@ -227,6 +228,7 @@ sg_open(struct inode *inode, struct file
 	Sg_fd *sfp;
 	int res;
 	int retval;
+	int autoresume_rc = 1;
 
 	lock_kernel();
 	nonseekable_open(inode, filp);
@@ -249,6 +251,10 @@ sg_open(struct inode *inode, struct file
 		return retval;
 	}
 
+	retval = autoresume_rc = scsi_autoresume_device(sdp->device);
+	if (retval)
+		goto error_out;
+
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -307,6 +313,8 @@ sg_open(struct inode *inode, struct file
 	return 0;
 
       error_out:
+	if (autoresume_rc == 0)
+		scsi_autosuspend_device(sdp->device);
 	scsi_device_put(sdp->device);
 	unlock_kernel();
 	return retval;
@@ -323,6 +331,8 @@ sg_release(struct inode *inode, struct f
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 	sg_fasync(-1, filp, 0);	/* remove filp from async notification list */
+	scsi_autosuspend_device(sdp->device);
+
 	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
 		if (!sdp->detached) {
 			scsi_device_put(sdp->device);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 09779f6..ef64fd8 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -304,10 +304,15 @@ static int device_reset(struct scsi_cmnd
 
 	US_DEBUGP("%s called\n", __func__);
 
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
@@ -350,6 +355,24 @@ void usb_stor_report_bus_reset(struct us
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
@@ -476,6 +499,10 @@ struct scsi_host_template usb_stor_host_
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
index bfea851..65c86ac 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -185,6 +185,8 @@ static int storage_suspend(struct usb_in
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
+	US_DEBUGP("%s\n", __FUNCTION__);
+
 	/* Wait until no command is running */
 	mutex_lock(&us->dev_mutex);
 
@@ -192,9 +194,6 @@ static int storage_suspend(struct usb_in
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_SUSPEND);
 
-	/* When runtime PM is working, we'll set a flag to indicate
-	 * whether we should autoresume when a SCSI request arrives. */
-
 	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
@@ -209,7 +208,6 @@ static int storage_resume(struct usb_int
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_RESUME);
 
-	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
 
@@ -930,6 +928,7 @@ static int usb_stor_scan_thread(void * _
 		/* Should we unbind if no devices were detected? */
 	}
 
+	usb_autopm_put_interface(us->pusb_intf);
 	complete_and_exit(&us->scanning_done, 0);
 }
 
@@ -959,6 +958,9 @@ static int storage_probe(struct usb_inte
 		return -ENOMEM;
 	}
 
+	/* Don't autosuspend until the SCSI core tells us */
+	usb_autopm_get_interface(intf);
+
 	/*
 	 * Allow 16-byte CDBs and thus > 2TB
 	 */
@@ -1020,6 +1022,7 @@ static int storage_probe(struct usb_inte
 		goto BadDevice;
 	}
 
+	usb_autopm_get_interface(intf); /* dropped in the scanning thread */
 	wake_up_process(th);
 
 	return 0;
@@ -1057,6 +1060,7 @@ #endif
 	.pre_reset =	storage_pre_reset,
 	.post_reset =	storage_post_reset,
 	.id_table =	storage_usb_ids,
+	.supports_autosuspend = 1,
 	.soft_unbind =	1,
 };
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c7f0629..eba766d 100644
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
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
