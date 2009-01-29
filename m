Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbZA2DbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbZA2DbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZA2DbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:31:13 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47606 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZA2DbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:31:11 -0500
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 28 Jan 2009 19:31:18 -0800
Message-ID: <m1pri623g9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jesse Barnes <jbarnes@virtuousgeek.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] pciehp:  Handle interrupts that happen during initialization. 
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move the enabling of interrupts after all of the data structures
are setup so that we can safely run the interrupt handler as
soon as it is registered.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/pci/hotplug/pciehp.h      |    2 ++
 drivers/pci/hotplug/pciehp_core.c |    7 +++++++
 drivers/pci/hotplug/pciehp_hpc.c  |   15 +++++++--------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index db85284..39ae375 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -111,6 +111,7 @@ struct controller {
 	int cmd_busy;
 	unsigned int no_cmd_complete:1;
 	unsigned int link_active_reporting:1;
+	unsigned int notification_enabled:1;
 };
 
 #define INT_BUTTON_IGNORE		0
@@ -170,6 +171,7 @@ extern int pciehp_configure_device(struct slot *p_slot);
 extern int pciehp_unconfigure_device(struct slot *p_slot);
 extern void pciehp_queue_pushbutton_work(struct work_struct *work);
 struct controller *pcie_init(struct pcie_device *dev);
+int pcie_init_notification(struct controller *ctrl);
 int pciehp_enable_slot(struct slot *p_slot);
 int pciehp_disable_slot(struct slot *p_slot);
 int pcie_enable_notification(struct controller *ctrl);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index c248554..681e391 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -434,6 +434,13 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 		goto err_out_release_ctlr;
 	}
 
+	/* Enable events after we have setup the data structures */
+	rc = pcie_init_notification(ctrl);
+	if (rc) {
+		ctrl_err(ctrl, "Notification initialization failed\n");
+		goto err_out_release_ctlr;
+	}
+
 	/* Check if slot is occupied */
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 	t_slot->hpc_ops->get_adapter_status(t_slot, &value);
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 71a8012..7a16c68 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -934,7 +934,7 @@ static void pcie_disable_notification(struct controller *ctrl)
 		ctrl_warn(ctrl, "Cannot disable software notification\n");
 }
 
-static int pcie_init_notification(struct controller *ctrl)
+int pcie_init_notification(struct controller *ctrl)
 {
 	if (pciehp_request_irq(ctrl))
 		return -1;
@@ -942,13 +942,17 @@ static int pcie_init_notification(struct controller *ctrl)
 		pciehp_free_irq(ctrl);
 		return -1;
 	}
+	ctrl->notification_enabled = 1;
 	return 0;
 }
 
 static void pcie_shutdown_notification(struct controller *ctrl)
 {
-	pcie_disable_notification(ctrl);
-	pciehp_free_irq(ctrl);
+	if (ctrl->notification_enabled) {
+		pcie_disable_notification(ctrl);
+		pciehp_free_irq(ctrl);
+		ctrl->notification_enabled = 0;
+	}
 }
 
 static int pcie_init_slot(struct controller *ctrl)
@@ -1110,13 +1114,8 @@ struct controller *pcie_init(struct pcie_device *dev)
 	if (pcie_init_slot(ctrl))
 		goto abort_ctrl;
 
-	if (pcie_init_notification(ctrl))
-		goto abort_slot;
-
 	return ctrl;
 
-abort_slot:
-	pcie_cleanup_slot(ctrl);
 abort_ctrl:
 	kfree(ctrl);
 abort:
-- 
1.5.6.6

