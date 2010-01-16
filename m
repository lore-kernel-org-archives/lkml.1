Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0APLJo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362Ab0APLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:08:58 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63409 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0APLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:08:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sat, 16 Jan 2010 03:07:16 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/11] pciehp: add support for bridge resource reallocation
In-reply-to: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263640037-24134-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

With this patch, pciehp driver try to clear PCI bridge resources to
parent bridge (root port or switch downstream port) of the slot

so we can shrink pci bridge resource for those port

This feature is enabled when 'pciehp_realloc' option is specified.

-v2: make it could be appiled after Yinghai patchset that touch pci bridge
     resource also remove poweron check, because pci_bridge_release_res will
     check child at first

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/pciehp.h      |    1 +
 drivers/pci/hotplug/pciehp_core.c |    7 +++++++
 drivers/pci/hotplug/pciehp_pci.c  |    4 ++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 4ed76b4..78cf0f4 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -43,6 +43,7 @@ extern int pciehp_poll_mode;
 extern int pciehp_poll_time;
 extern int pciehp_debug;
 extern int pciehp_force;
+extern int pciehp_realloc;
 extern struct workqueue_struct *pciehp_wq;
 
 #define dbg(format, arg...)						\
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 920f820..8f990ad 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
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
 
@@ -272,6 +275,10 @@ static int pciehp_probe(struct pcie_device *dev)
 	if (!occupied && poweron && POWER_CTRL(ctrl))
 		pciehp_power_off_slot(slot);
 
+	/* Release I/O window of the slots's parent bridge */
+	if (pciehp_realloc)
+		pci_bridge_release_res(dev->port->subordinate);
+
 	return 0;
 
 err_out_free_ctrl_slot:
diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index 0a16444..f6119e4 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -166,5 +166,9 @@ int pciehp_unconfigure_device(struct slot *p_slot)
 		pci_dev_put(temp);
 	}
 
+	/* Release I/O window of the slots's parent bridge */
+	if (pciehp_realloc)
+		pci_bridge_release_res(parent);
+
 	return rc;
 }
-- 
1.6.4.2

