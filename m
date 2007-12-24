Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXLXOlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXLXOlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbXLXOkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:40:52 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58619 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbXLXOkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:40:51 -0500
Date: Mon, 24 Dec 2007 15:40:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 21/38] drivers/scsi: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241540070.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/drivers/scsi/eata.c b/drivers/scsi/eata.c
--- a/drivers/scsi/eata.c	2007-10-22 11:25:23.000000000 +0200
+++ b/drivers/scsi/eata.c	2007-12-23 20:30:39.000000000 +0100
@@ -928,6 +928,7 @@ static char boot_options[MAX_BOOT_OPTION
 #if defined(MODULE)
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/jiffies.h>
 
 module_param_string(eata, boot_options, MAX_BOOT_OPTIONS_SIZE, 0);
 MODULE_PARM_DESC(eata, " equivalent to the \"eata=...\" kernel boot option."
@@ -1996,7 +1997,7 @@ static int eata2x_eh_host_reset(struct s
 
 	/* FIXME: use a sleep instead */
 	time = jiffies;
-	while ((jiffies - time) < (10 * HZ) && limit++ < 200000)
+	while (time_before(jiffies, time + 10 * HZ) && limit++ < 200000)
 		udelay(100L);
 
 	spin_lock_irq(shost->host_lock);
diff -r -u -p a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-11-08 08:00:52.000000000 +0100
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-12-23 20:41:54.000000000 +0100
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -55,7 +56,8 @@ lpfc_adjust_queue_depth(struct lpfc_hba 
 	atomic_inc(&phba->num_rsrc_err);
 	phba->last_rsrc_error_time = jiffies;
 
-	if ((phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL) > jiffies) {
+	if (time_before(jiffies,
+			phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL)){
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
@@ -94,8 +96,10 @@ lpfc_rampup_queue_depth(struct lpfc_vpor
 	if (vport->cfg_lun_queue_depth <= sdev->queue_depth)
 		return;
 	spin_lock_irqsave(&phba->hbalock, flags);
-	if (((phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL) > jiffies) ||
-	 ((phba->last_rsrc_error_time + QUEUE_RAMP_UP_INTERVAL ) > jiffies)) {
+	if ((time_before(jiffies,
+			 phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL)) ||
+	 (time_before(jiffies,
+		      phba->last_rsrc_error_time + QUEUE_RAMP_UP_INTERVAL))) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
@@ -617,10 +621,12 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		lpfc_rampup_queue_depth(vport, sdev);
 
 	if (!result && pnode != NULL &&
-	   ((jiffies - pnode->last_ramp_up_time) >
-		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
-	   ((jiffies - pnode->last_q_full_time) >
-		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
+	   (time_after(jiffies,
+		       pnode->last_ramp_up_time +
+		       LPFC_Q_RAMP_UP_INTERVAL * HZ)) &&
+	   (time_after(jiffies,
+		       pnode->last_q_full_time +
+		       LPFC_Q_RAMP_UP_INTERVAL * HZ)) &&
 	   (vport->cfg_lun_queue_depth > sdev->queue_depth)) {
 		shost_for_each_device(tmp_sdev, sdev->host) {
 			if (vport->cfg_lun_queue_depth > tmp_sdev->queue_depth){
diff -r -u -p a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c	2007-10-22 11:25:24.000000000 +0200
+++ b/drivers/scsi/u14-34f.c	2007-12-23 20:42:31.000000000 +0100
@@ -673,6 +673,7 @@ static char boot_options[MAX_BOOT_OPTION
 #if defined(MODULE)
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/jiffies.h>
 
 module_param_string(u14_34f, boot_options, MAX_BOOT_OPTIONS_SIZE, 0);
 MODULE_PARM_DESC(u14_34f, " equivalent to the \"u14-34f=...\" kernel boot " \
@@ -778,7 +779,7 @@ static int board_inquiry(unsigned int j)
 
    spin_unlock_irq(&driver_lock);
    time = jiffies;
-   while ((jiffies - time) < HZ && limit++ < 20000) udelay(100L);
+   while (time_before(jiffies, time + HZ) && limit++ < 20000) udelay(100L);
    spin_lock_irq(&driver_lock);
 
    if (cpp->adapter_status || HD(j)->cp_stat[0] != FREE) {
@@ -1479,7 +1480,8 @@ static int u14_34f_eh_host_reset(struct 
 
    spin_unlock_irq(sh[j]->host_lock);
    time = jiffies;
-   while ((jiffies - time) < (10 * HZ) && limit++ < 200000) udelay(100L);
+   while (time_before(jiffies, time + 10 * HZ) && limit++ < 200000)
+      udelay(100L);
    spin_lock_irq(sh[j]->host_lock);
 
    printk("%s: reset, interrupts disabled, loops %d.\n", BN(j), limit);
