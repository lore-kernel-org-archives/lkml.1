Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXCUSsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXCUSsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXCUSr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:47:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:37896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591AbXCUSr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:47:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,309,1170662400"; 
   d="scan'208"; a="200249187:sNHT19736395"
Date: Wed, 21 Mar 2007 11:45:31 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: 2.6.21-rc4-mm1: multiple definition of `queue_pushbutton_work'
Message-Id: <20070321114531.feffad51.kristen.c.accardi@intel.com>
In-Reply-To: <20070320204936.GE752@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<20070320204936.GE752@stusta.de>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix duplicate names in shpchp and pciehp.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-mm/drivers/pci/hotplug/pciehp.h
===================================================================
--- 2.6-mm.orig/drivers/pci/hotplug/pciehp.h
+++ 2.6-mm/drivers/pci/hotplug/pciehp.h
@@ -158,7 +158,7 @@ extern u8 pciehp_handle_presence_change(
 extern u8 pciehp_handle_power_fault(u8 hp_slot, struct controller *ctrl);
 extern int pciehp_configure_device(struct slot *p_slot);
 extern int pciehp_unconfigure_device(struct slot *p_slot);
-extern void queue_pushbutton_work(struct work_struct *work);
+extern void pciehp_queue_pushbutton_work(struct work_struct *work);
 int pcie_init(struct controller *ctrl, struct pcie_device *dev);
 
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
Index: 2.6-mm/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- 2.6-mm.orig/drivers/pci/hotplug/pciehp_core.c
+++ 2.6-mm/drivers/pci/hotplug/pciehp_core.c
@@ -229,7 +229,7 @@ static int init_slots(struct controller 
 		slot->hpc_ops = ctrl->hpc_ops;
 		slot->number = ctrl->first_slot;
 		mutex_init(&slot->lock);
-		INIT_DELAYED_WORK(&slot->work, queue_pushbutton_work);
+		INIT_DELAYED_WORK(&slot->work, pciehp_queue_pushbutton_work);
 
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->private = slot;
Index: 2.6-mm/drivers/pci/hotplug/pciehp_ctrl.c
===================================================================
--- 2.6-mm.orig/drivers/pci/hotplug/pciehp_ctrl.c
+++ 2.6-mm/drivers/pci/hotplug/pciehp_ctrl.c
@@ -351,7 +351,7 @@ static void pciehp_power_thread(struct w
 	kfree(info);
 }
 
-void queue_pushbutton_work(struct work_struct *work)
+void pciehp_queue_pushbutton_work(struct work_struct *work)
 {
 	struct slot *p_slot = container_of(work, struct slot, work.work);
 	struct power_work_info *info;
Index: 2.6-mm/drivers/pci/hotplug/shpchp.h
===================================================================
--- 2.6-mm.orig/drivers/pci/hotplug/shpchp.h
+++ 2.6-mm/drivers/pci/hotplug/shpchp.h
@@ -166,7 +166,7 @@ extern u8 shpchp_handle_power_fault(u8 h
 extern int shpchp_configure_device(struct slot *p_slot);
 extern int shpchp_unconfigure_device(struct slot *p_slot);
 extern void cleanup_slots(struct controller *ctrl);
-extern void queue_pushbutton_work(struct work_struct *work);
+extern void shpchp_queue_pushbutton_work(struct work_struct *work);
 extern int shpc_init( struct controller *ctrl, struct pci_dev *pdev);
 
 #ifdef CONFIG_ACPI
Index: 2.6-mm/drivers/pci/hotplug/shpchp_core.c
===================================================================
--- 2.6-mm.orig/drivers/pci/hotplug/shpchp_core.c
+++ 2.6-mm/drivers/pci/hotplug/shpchp_core.c
@@ -136,7 +136,7 @@ static int init_slots(struct controller 
 		slot->hpc_ops = ctrl->hpc_ops;
 		slot->number = ctrl->first_slot + (ctrl->slot_num_inc * i);
 		mutex_init(&slot->lock);
-		INIT_DELAYED_WORK(&slot->work, queue_pushbutton_work);
+		INIT_DELAYED_WORK(&slot->work, shpchp_queue_pushbutton_work);
 
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->private = slot;
Index: 2.6-mm/drivers/pci/hotplug/shpchp_ctrl.c
===================================================================
--- 2.6-mm.orig/drivers/pci/hotplug/shpchp_ctrl.c
+++ 2.6-mm/drivers/pci/hotplug/shpchp_ctrl.c
@@ -433,7 +433,7 @@ static void shpchp_pushbutton_thread(str
 	kfree(info);
 }
 
-void queue_pushbutton_work(struct work_struct *work)
+void shpchp_queue_pushbutton_work(struct work_struct *work)
 {
 	struct slot *p_slot = container_of(work, struct slot, work.work);
 	struct pushbutton_work_info *info;
