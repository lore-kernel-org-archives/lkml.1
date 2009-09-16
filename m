Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbZIPWjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbZIPWjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760293AbZIPWjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:39:44 -0400
Received: from kroah.org ([198.145.64.141]:48896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZIPWjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:13 2009
Message-Id: <20090916223713.500478052@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 02/45] [SCSI] mpt2sas : Rescan topology from Interrupt context instead of work thread
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=mpt2sas-rescan-topology-from-interrupt-context-instead-of-work-thread.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit cd4e12e8ad246ec5bc23ab04d0da0e6985025620 upstream.

Following host reset its possible that the controller firmware could
assign new handles for devices, as well as adding or deleting devices. There is
code in the driver that will rescan the topology folowing host reset; updating
device handles, and remove devices that are no longer responding. This patch
will improve the responsivness by moving this rescaning from the delayed hotplug
worker thread to immediately following the host reset.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <Eric.moore@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    3 
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    1 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  142 +++++++++++++----------------------
 3 files changed, 57 insertions(+), 89 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3536,5 +3536,8 @@ mpt2sas_base_hard_reset_handler(struct M
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	ioc->ioc_reset_in_progress = 0;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+
+	if (!r)
+		_base_reset_handler(ioc, MPT2_IOC_RUNNING);
 	return r;
 }
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -119,6 +119,7 @@
 #define MPT2_IOC_PRE_RESET		1 /* prior to host reset */
 #define MPT2_IOC_AFTER_RESET		2 /* just after host reset */
 #define MPT2_IOC_DONE_RESET		3 /* links re-initialized */
+#define MPT2_IOC_RUNNING		4 /* shost running */
 
 /*
  * logging format
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -103,7 +103,6 @@ struct sense_info {
 };
 
 
-#define MPT2SAS_RESCAN_AFTER_HOST_RESET (0xFFFF)
 /**
  * struct fw_event_work - firmware event struct
  * @list: link list framework
@@ -2405,27 +2404,6 @@ _scsih_check_topo_delete_events(struct M
 }
 
 /**
- * _scsih_queue_rescan - queue a topology rescan from user context
- * @ioc: per adapter object
- *
- * Return nothing.
- */
-static void
-_scsih_queue_rescan(struct MPT2SAS_ADAPTER *ioc)
-{
-	struct fw_event_work *fw_event;
-
-	if (ioc->wait_for_port_enable_to_complete)
-		return;
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
-	if (!fw_event)
-		return;
-	fw_event->event = MPT2SAS_RESCAN_AFTER_HOST_RESET;
-	fw_event->ioc = ioc;
-	_scsih_fw_event_add(ioc, fw_event);
-}
-
-/**
  * _scsih_flush_running_cmds - completing outstanding commands.
  * @ioc: per adapter object
  *
@@ -2456,46 +2434,6 @@ _scsih_flush_running_cmds(struct MPT2SAS
 }
 
 /**
- * mpt2sas_scsih_reset_handler - reset callback handler (for scsih)
- * @ioc: per adapter object
- * @reset_phase: phase
- *
- * The handler for doing any required cleanup or initialization.
- *
- * The reset phase can be MPT2_IOC_PRE_RESET, MPT2_IOC_AFTER_RESET,
- * MPT2_IOC_DONE_RESET
- *
- * Return nothing.
- */
-void
-mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
-{
-	switch (reset_phase) {
-	case MPT2_IOC_PRE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
-		_scsih_fw_event_off(ioc);
-		break;
-	case MPT2_IOC_AFTER_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
-		if (ioc->tm_cmds.status & MPT2_CMD_PENDING) {
-			ioc->tm_cmds.status |= MPT2_CMD_RESET;
-			mpt2sas_base_free_smid(ioc, ioc->tm_cmds.smid);
-			complete(&ioc->tm_cmds.done);
-		}
-		_scsih_fw_event_on(ioc);
-		_scsih_flush_running_cmds(ioc);
-		break;
-	case MPT2_IOC_DONE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
-		_scsih_queue_rescan(ioc);
-		break;
-	}
-}
-
-/**
  * _scsih_setup_eedp - setup MPI request for EEDP transfer
  * @scmd: pointer to scsi command object
  * @mpi_request: pointer to the SCSI_IO reqest message frame
@@ -5156,22 +5094,9 @@ static void
 _scsih_remove_unresponding_devices(struct MPT2SAS_ADAPTER *ioc)
 {
 	struct _sas_device *sas_device, *sas_device_next;
-	struct _sas_node *sas_expander, *sas_expander_next;
+	struct _sas_node *sas_expander;
 	struct _raid_device *raid_device, *raid_device_next;
-	unsigned long flags;
 
-	_scsih_search_responding_sas_devices(ioc);
-	_scsih_search_responding_raid_devices(ioc);
-	_scsih_search_responding_expanders(ioc);
-
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	ioc->shost_recovery = 0;
-	if (ioc->shost->shost_state == SHOST_RECOVERY) {
-		printk(MPT2SAS_INFO_FMT "putting controller into "
-		    "SHOST_RUNNING\n", ioc->name);
-		scsi_host_set_state(ioc->shost, SHOST_RUNNING);
-	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	list_for_each_entry_safe(sas_device, sas_device_next,
 	    &ioc->sas_device_list, list) {
@@ -5207,16 +5132,63 @@ _scsih_remove_unresponding_devices(struc
 		_scsih_raid_device_remove(ioc, raid_device);
 	}
 
-	list_for_each_entry_safe(sas_expander, sas_expander_next,
-	    &ioc->sas_expander_list, list) {
+ retry_expander_search:
+	sas_expander = NULL;
+	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
 		if (sas_expander->responding) {
 			sas_expander->responding = 0;
 			continue;
 		}
-		printk("\tremoving expander: handle(0x%04x), "
-		    " sas_addr(0x%016llx)\n", sas_expander->handle,
-		    (unsigned long long)sas_expander->sas_address);
 		_scsih_expander_remove(ioc, sas_expander->handle);
+		goto retry_expander_search;
+	}
+}
+
+/**
+ * mpt2sas_scsih_reset_handler - reset callback handler (for scsih)
+ * @ioc: per adapter object
+ * @reset_phase: phase
+ *
+ * The handler for doing any required cleanup or initialization.
+ *
+ * The reset phase can be MPT2_IOC_PRE_RESET, MPT2_IOC_AFTER_RESET,
+ * MPT2_IOC_DONE_RESET
+ *
+ * Return nothing.
+ */
+void
+mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
+{
+	switch (reset_phase) {
+	case MPT2_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
+		_scsih_fw_event_off(ioc);
+		break;
+	case MPT2_IOC_AFTER_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
+		if (ioc->tm_cmds.status & MPT2_CMD_PENDING) {
+			ioc->tm_cmds.status |= MPT2_CMD_RESET;
+			mpt2sas_base_free_smid(ioc, ioc->tm_cmds.smid);
+			complete(&ioc->tm_cmds.done);
+		}
+		_scsih_fw_event_on(ioc);
+		_scsih_flush_running_cmds(ioc);
+		break;
+	case MPT2_IOC_DONE_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
+		_scsih_sas_host_refresh(ioc, 0);
+		_scsih_search_responding_sas_devices(ioc);
+		_scsih_search_responding_raid_devices(ioc);
+		_scsih_search_responding_expanders(ioc);
+		break;
+	case MPT2_IOC_RUNNING:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_RUNNING\n", ioc->name, __func__));
+		_scsih_remove_unresponding_devices(ioc);
+		break;
 	}
 }
 
@@ -5236,14 +5208,6 @@ _firmware_event_work(struct work_struct 
 	unsigned long flags;
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
-	/* This is invoked by calling _scsih_queue_rescan(). */
-	if (fw_event->event == MPT2SAS_RESCAN_AFTER_HOST_RESET) {
-		_scsih_fw_event_free(ioc, fw_event);
-		_scsih_sas_host_refresh(ioc, 1);
-		_scsih_remove_unresponding_devices(ioc);
-		return;
-	}
-
 	/* the queue is being flushed so ignore this event */
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	if (ioc->fw_events_off || ioc->remove_host) {


