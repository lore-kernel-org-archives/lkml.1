Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYJ0Hvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYJ0Hvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYJ0Hvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:51:38 -0400
Received: from ozlabs.org ([203.10.76.45]:58115 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYJ0Hvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:51:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] OF-device: Don't overwrite numa_node in device registration
Message-Id: <1225093885.321819.747371980567.1.gpush@pingu>
To: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: <cbe-oss-dev@ozlabs.org>, <linuxppc-dev@ozlabs.org>, <davem@davemloft.net>,
       <linux-kernel@vger.kernel.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Mon, 27 Oct 2008 18:51:25 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the numa_node of OF-devices will be overwritten during
device_register, which simply sets the node to -1. On cell machines,
this means that devices can't find their IOMMU, which is referenced
through the device's numa node.

Set the numa node for OF devices with no parent, and use the
lower-level device_initialize and device_add functions, so that the
node is preserved.

We can remove the call to set_dev_node in of_device_alloc, as it
will be overwritten during register.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
Ben: please apply pending davem's approval - this fixes a
regression in 2.6.28

---
 arch/powerpc/kernel/of_device.c |    1 -
 drivers/of/device.c             |   11 ++++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
index 93ae5b1..f3c9cae 100644
--- a/arch/powerpc/kernel/of_device.c
+++ b/arch/powerpc/kernel/of_device.c
@@ -78,7 +78,6 @@ struct of_device *of_device_alloc(struct device_node *np,
 	dev->dev.parent = parent;
 	dev->dev.release = of_release_dev;
 	dev->dev.archdata.of_node = np;
-	set_dev_node(&dev->dev, of_node_to_nid(np));
 
 	if (bus_id)
 		strlcpy(dev->dev.bus_id, bus_id, BUS_ID_SIZE);
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 51e5214..224ae6b 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -105,7 +105,16 @@ EXPORT_SYMBOL(of_release_dev);
 int of_device_register(struct of_device *ofdev)
 {
 	BUG_ON(ofdev->node == NULL);
-	return device_register(&ofdev->dev);
+
+	device_initialize(&ofdev->dev);
+
+	/* device_add will assume that this device is on the same node as
+	 * the parent. If there is no parent defined, set the node
+	 * explicitly */
+	if (!ofdev->dev.parent)
+		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->node));
+
+	return device_add(&ofdev->dev);
 }
 EXPORT_SYMBOL(of_device_register);
 
