Return-Path: <linux-kernel-owner+w=401wt.eu-S1765052AbXJRDAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765052AbXJRDAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761058AbXJRC76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:59:58 -0400
Received: from rtr.ca ([76.10.145.34]:2737 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760998AbXJRC75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:59:57 -0400
Message-ID: <4716CC2B.3040307@rtr.ca>
Date: Wed, 17 Oct 2007 22:59:55 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 1/3] pciehp_handle_preinserted_card
References: <4716CB9D.6080503@rtr.ca>
In-Reply-To: <4716CB9D.6080503@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

01_pciehp_handle_preinserted_card.patch:

Fix pciehp_probe() to deal with ExpressCard cards
that were inserted prior to the driver being loaded.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
--- git12/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-17 22:30:19.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-17 22:29:59.000000000 -0400
@@ -37,7 +37,6 @@
 #include "pciehp.h"
 
 static void interrupt_event_handler(struct work_struct *work);
-static int pciehp_enable_slot(struct slot *p_slot);
 static int pciehp_disable_slot(struct slot *p_slot);
 
 static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
--- git12/drivers/pci/hotplug/pciehp.h	2007-10-17 22:30:19.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp.h	2007-10-17 22:29:59.000000000 -0400
@@ -161,6 +161,7 @@
 extern int pciehp_unconfigure_device(struct slot *p_slot);
 extern void pciehp_queue_pushbutton_work(struct work_struct *work);
 int pcie_init(struct controller *ctrl, struct pcie_device *dev);
+int pciehp_enable_slot(struct slot *p_slot);
 
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
 {
--- git12/drivers/pci/hotplug/pciehp_core.c	2007-10-17 22:30:19.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_core.c	2007-10-17 22:36:06.000000000 -0400
@@ -471,6 +471,11 @@
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
+	if (value) {
+		rc = pciehp_enable_slot(t_slot);
+		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
+			value = 0;
+	}
 	if ((POWER_CTRL(ctrl->ctrlcap)) && !value) {
 		rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot if not occupied*/
 		if (rc)
