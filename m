Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZC3QzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZC3QzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbZC3QuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:50:22 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:8816 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbZC3QuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:50:20 -0400
Subject: [PATCH v2 2/3] PCI Hotplug: acpiphp: grab refcount on p2p subordinate
	bus
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Date: Mon, 30 Mar 2009 10:50:14 -0600
Message-ID: <20090330165014.18855.67275.stgit@bob.kio>
In-Reply-To: <20090330164737.18855.7137.stgit@bob.kio>
References: <20090330164737.18855.7137.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a logical hot unplug (remove) is performed on a bridge claimed
by acpiphp and then acpiphp is unloaded, we will encounter an oops.

This is because acpiphp will access the bridge's subordinate bus,
which was released by the user's prior hot unplug.

The solution is to grab a reference on the subordinate PCI bus.
This will prevent the bus from release until acpiphp is unloaded.

Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/acpiphp_glue.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 803d9dd..a33794d 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -38,6 +38,8 @@
  *  - The one in acpiphp_bridge has its refcount elevated by pci_get_slot()
  *    when the bridge is scanned and it loses a refcount when the bridge
  *    is removed.
+ *  - When a P2P bridge is present, we elevate the refcount on the subordinate
+ *    bus. It loses the refcount when the the driver unloads.
  */
 
 #include <linux/init.h>
@@ -440,6 +442,12 @@ static void add_p2p_bridge(acpi_handle *handle, struct pci_dev *pci_dev)
 		goto err;
 	}
 
+	/*
+	 * Grab a ref to the subordinate PCI bus in case the bus is
+	 * removed via PCI core logical hotplug. The ref pins the bus
+	 * (which we access during module unload).
+	 */
+	get_device(&bridge->pci_bus->dev);
 	spin_lock_init(&bridge->res_lock);
 
 	init_bridge_misc(bridge);
@@ -619,6 +627,12 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 		slot = next;
 	}
 
+	/*
+	 * Only P2P bridges have a pci_dev
+	 */
+	if (bridge->pci_dev)
+		put_device(&bridge->pci_bus->dev);
+
 	pci_dev_put(bridge->pci_dev);
 	list_del(&bridge->list);
 	kfree(bridge);

