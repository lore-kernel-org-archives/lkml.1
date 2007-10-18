Return-Path: <linux-kernel-owner+w=401wt.eu-S1765405AbXJRDCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765405AbXJRDCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760701AbXJRDCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:02:12 -0400
Received: from rtr.ca ([76.10.145.34]:2798 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430AbXJRDCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:02:10 -0400
Message-ID: <4716CCB1.9060605@rtr.ca>
Date: Wed, 17 Oct 2007 23:02:09 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: [PATCH 3/3] pciehp_resume_reinit_hardware
References: <4716CB9D.6080503@rtr.ca>
In-Reply-To: <4716CB9D.6080503@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

03_pciehp_resume_reinit_hardware.patch:

Make use of the previously split out pcie_init_enable_events() function
to reinitialize the hotplug hardware on resume from suspend,
but only when pciehp_force==1.  Otherwise behaviour is unmodified.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
--- git12/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-17 19:28:23.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-17 19:31:22.000000000 -0400
@@ -37,7 +37,6 @@
 #include "pciehp.h"
 
 static void interrupt_event_handler(struct work_struct *work);
-static int pciehp_disable_slot(struct slot *p_slot);
 
 static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
 {
--- git12/drivers/pci/hotplug/pciehp.h	2007-10-17 19:28:23.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp.h	2007-10-17 19:32:03.000000000 -0400
@@ -162,6 +162,8 @@
 extern void pciehp_queue_pushbutton_work(struct work_struct *work);
 int pcie_init(struct controller *ctrl, struct pcie_device *dev);
 int pciehp_enable_slot(struct slot *p_slot);
+int pciehp_disable_slot(struct slot *p_slot);
+int pcie_init_hardware(struct controller *ctrl, struct pcie_device *dev);
 
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
 {
--- git12/drivers/pci/hotplug/pciehp_core.c	2007-10-17 19:28:23.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_core.c	2007-10-17 19:33:05.000000000 -0400
@@ -510,6 +510,24 @@
 static int pciehp_resume (struct pcie_device *dev)
 {
 	printk("%s ENTRY\n", __FUNCTION__);
+	if (pciehp_force) {
+		struct pci_dev *pdev = dev->port;
+		struct controller *ctrl = pci_get_drvdata(pdev);
+		struct slot *t_slot;
+		u8 status;
+
+		/* reinitialize the chipset's event detection logic */
+		pcie_init_hardware(ctrl, dev);
+
+		t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
+
+		/* Check if slot is occupied */
+		t_slot->hpc_ops->get_adapter_status(t_slot, &status);
+		if (status)
+			pciehp_enable_slot(t_slot);
+		else
+			pciehp_disable_slot(t_slot);
+	}
 	return 0;
 }
 #endif
