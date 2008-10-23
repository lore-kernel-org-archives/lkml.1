Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbYJWA6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbYJWA6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYJWA5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:57:52 -0400
Received: from ozlabs.org ([203.10.76.45]:40312 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbYJWA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:57:51 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu Oct 23 11:55:16 EST 2008
CC: travis@sgi.com
Subject: [PATCH 4/7] work_on_cpu: use in drivers/pci/pci-driver.c
Message-Id: <20081023005750.72754DDEF7@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This uses work_on_cpu().

Note the cleanups:

1) I've removed the CONFIG_NUMA test, since dev_to_node() returns -1
   for !CONFIG_NUMA anyway and the compiler will eliminate it.

2) No need to reset mempolicy to default (a bad idea anyway) since
   work_on_cpu is run from a workqueue.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/pci/pci-driver.c |   53 ++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff -r 1f09cc544188 drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c	Thu Oct 23 11:23:39 2008 +1100
+++ b/drivers/pci/pci-driver.c	Thu Oct 23 11:26:53 2008 +1100
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
 #include "pci.h"
 
 /*
@@ -183,32 +184,42 @@ static const struct pci_device_id *pci_m
 	return pci_match_id(drv->id_table, dev);
 }
 
+struct drv_dev_and_id {
+	struct pci_driver *drv;
+	struct pci_dev *dev;
+	const struct pci_device_id *id;
+};
+
+static long local_pci_probe(void *_ddi)
+{
+	struct drv_dev_and_id *ddi = _ddi;
+
+	return ddi->drv->probe(ddi->dev, ddi->id);
+}
+
 static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 			  const struct pci_device_id *id)
 {
-	int error;
-#ifdef CONFIG_NUMA
-	/* Execute driver initialization on node where the
-	   device's bus is attached to.  This way the driver likely
-	   allocates its local memory on the right node without
-	   any need to change it. */
-	struct mempolicy *oldpol;
-	cpumask_t oldmask = current->cpus_allowed;
-	int node = dev_to_node(&dev->dev);
+	int error, node;
+	struct drv_dev_and_id ddi = { drv, dev, id };
 
+	/* Execute driver initialization on node where the device's
+	   bus is attached to.  This way the driver likely allocates
+	   its local memory on the right node without any need to
+	   change it. */
+	node = dev_to_node(&dev->dev);
 	if (node >= 0) {
-		node_to_cpumask_ptr(nodecpumask, node);
-		set_cpus_allowed_ptr(current, nodecpumask);
-	}
-	/* And set default memory allocation policy */
-	oldpol = current->mempolicy;
-	current->mempolicy = NULL;	/* fall back to system default policy */
-#endif
-	error = drv->probe(dev, id);
-#ifdef CONFIG_NUMA
-	set_cpus_allowed_ptr(current, &oldmask);
-	current->mempolicy = oldpol;
-#endif
+		int cpu;
+		node_to_cpumask_ptr(mask, node);
+		get_online_cpus();
+		cpu = cpumask_any_and(mask, cpu_online_mask);
+		if (cpu < nr_cpu_ids)
+			error = work_on_cpu(cpu, local_pci_probe, &ddi);
+		else
+			error = local_pci_probe(&ddi);
+		put_online_cpus();
+	} else
+		error = local_pci_probe(&ddi);
 	return error;
 }
 

