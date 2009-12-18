Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbZLRU5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbZLRU5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932905AbZLRU5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:57:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:57535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932921AbZLRU5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:57:02 -0500
Message-ID: <4B2BEC4C.2010406@kernel.org>
Date: Fri, 18 Dec 2009 12:55:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 11/12] pciehp: add support for bridge resource reallocation
 -v2
References: <4B2BE9DD.3040504@kernel.org>
In-Reply-To: <4B2BE9DD.3040504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From:  Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

With this patch, pciehp driver try to clear PCI bridge resources to
parent bridge (root port or switch downstream port) of the slot

so we can shrink pci bridge resource for those port

This feature is enabled when 'pciehp_realloc' option is specified.

-v2: make it could be appiled after Yinghai patchset that touch pci bridge resource
     also remove poweron check, because pci_bridge_release_res will check child at first

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/hotplug/pciehp.h      |    1 +
 drivers/pci/hotplug/pciehp_core.c |    7 +++++++
 drivers/pci/hotplug/pciehp_pci.c  |    4 ++++
 3 files changed, 12 insertions(+)

Index: linux-2.6/drivers/pci/hotplug/pciehp.h
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp.h
+++ linux-2.6/drivers/pci/hotplug/pciehp.h
@@ -43,6 +43,7 @@ extern int pciehp_poll_mode;
 extern int pciehp_poll_time;
 extern int pciehp_debug;
 extern int pciehp_force;
+extern int pciehp_realloc;
 extern struct workqueue_struct *pciehp_wq;
 
 #define dbg(format, arg...)						\
Index: linux-2.6/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_core.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_core.c
@@ -41,6 +41,7 @@ int pciehp_debug;
 int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
+int pciehp_realloc;
 struct workqueue_struct *pciehp_wq;
 
 #define DRIVER_VERSION	"0.4"
@@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
 module_param(pciehp_poll_mode, bool, 0644);
 module_param(pciehp_poll_time, int, 0644);
 module_param(pciehp_force, bool, 0644);
+module_param(pciehp_realloc, bool, 0644);
 MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
 MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
+MODULE_PARM_DESC(pciehp_realloc, "Realloc resources for slot's parent bridge");
 
 #define PCIE_MODULE_NAME "pciehp"
 
@@ -297,6 +300,10 @@ static int pciehp_probe(struct pcie_devi
 	if (!occupied && poweron && POWER_CTRL(ctrl))
 		pciehp_power_off_slot(slot);
 
+	/* Release I/O window of the slots's parent bridge */
+	if (pciehp_realloc)
+		pci_bridge_release_res(dev->port->subordinate);
+
 	return 0;
 
 err_out_free_ctrl_slot:
Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
@@ -166,5 +166,9 @@ int pciehp_unconfigure_device(struct slo
 		pci_dev_put(temp);
 	}
 
+	/* Release I/O window of the slots's parent bridge */
+	if (pciehp_realloc)
+		pci_bridge_release_res(parent);
+
 	return rc;
 }


