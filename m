Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbXGKABy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbXGKABy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763475AbXGKABF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:01:05 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38431 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763280AbXGKAA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:00:59 -0400
Date: Tue, 10 Jul 2007 16:52:30 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/5] try parent numa_node at first before using default
In-reply-to: <200707101641.17672.yinghai.lu@sun.com>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, rientjes@google.com,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707101652.31378.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200707101641.17672.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/5] try parent numa_node at first before using default

For pci_device, pcibios_scan_root and pci_scan_root will call pci_device_add.
pci_device_add will call device_initialize and set_dev_node(&dev->dev,
pcibus_to_node(bus)).
other device such as netdev, and usb_device, set_dev_node is never be
used. So that field numa_node always is -1.

So for netdev, it will need to use dev->parent to get pci_device to
use it's numa_node. esp in netdev_alloc_skb()
not sure how other device such as infiniband do that.

Actually before patch
[PATCH 1/2] x86_64: get mp_bus_to_node as early
there is a bug about squence of bus->sysdata and using pcibus_to_node.
the numa_node of pci_dev->dev is never set correctly...always 0.

So some device have to use pcibus_to_node(to_pci_dev(dev)->bus) directly
such as dma_alloc_pages in arch/x86_64/kernel/pci-dma.c.
or hwif_to_node in include/linux/ide.h

with this patch, we could use device->numa_node direclty for all device.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/base/core.c b/drivers/base/core.c
index dd40d78..c344d82 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -547,6 +547,8 @@ static void klist_children_put(struct klist_node *n)
 
 void device_initialize(struct device *dev)
 {
+	int node;
+
 	kobj_set_kset_s(dev, devices_subsys);
 	kobject_init(&dev->kobj);
 	klist_init(&dev->klist_children, klist_children_get,
@@ -557,7 +559,9 @@ void device_initialize(struct device *dev)
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);
-	set_dev_node(dev, -1);
+
+	node = dev->parent ? dev_to_node(dev->parent) : -1;
+	set_dev_node(dev, node);
 }
 
 #ifdef CONFIG_SYSFS_DEPRECATED
