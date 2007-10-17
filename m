Return-Path: <linux-kernel-owner+w=401wt.eu-S936062AbXJQByy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936062AbXJQByy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762197AbXJQByp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:54:45 -0400
Received: from rtr.ca ([76.10.145.34]:3444 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760036AbXJQByo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:54:44 -0400
Message-ID: <47156B62.3070807@rtr.ca>
Date: Tue, 16 Oct 2007 21:54:42 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 2/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version
 2)
References: <4714C0A6.1030204@rtr.ca> <4714D700.7060008@rtr.ca> <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <47156B14.2080608@rtr.ca> <47156B40.4060006@rtr.ca>
In-Reply-To: <47156B40.4060006@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix pciehp_probe() to deal with pre-inserted ExpressCard cards,
but only when pciehp_force==1.  Otherwise behaviour is unmodified.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
--- old/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-16 21:14:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-16 21:16:36.000000000 -0400
@@ -37,7 +37,6 @@
 #include "pciehp.h"
 
 static void interrupt_event_handler(struct work_struct *work);
-static int pciehp_enable_slot(struct slot *p_slot);
 static int pciehp_disable_slot(struct slot *p_slot);
 
 static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
--- old/drivers/pci/hotplug/pciehp.h	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp.h	2007-10-16 21:16:06.000000000 -0400
@@ -161,6 +161,7 @@
 extern int pciehp_unconfigure_device(struct slot *p_slot);
 extern void pciehp_queue_pushbutton_work(struct work_struct *work);
 int pcie_init(struct controller *ctrl, struct pcie_device *dev);
+int pciehp_enable_slot(struct slot *p_slot);
 
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
 {
--- old/drivers/pci/hotplug/pciehp_core.c	2007-10-16 21:14:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_core.c	2007-10-16 21:15:56.000000000 -0400
@@ -477,7 +477,8 @@
 		rc = t_slot->hpc_ops->power_off_slot(t_slot);
 		if (rc)
 			goto err_out_free_ctrl_slot;
-	}
+	} else if (pciehp_force)
+		pciehp_enable_slot(t_slot);
 
 	return 0;
 
