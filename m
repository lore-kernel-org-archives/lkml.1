Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYLaNZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYLaNZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbYLaNZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:25:10 -0500
Received: from ozlabs.org ([203.10.76.45]:46250 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbYLaNZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:25:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] work_on_cpu: use in drivers/pci/pci-driver.c
Date: Wed, 31 Dec 2008 23:54:56 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <200812011850.42203.rusty@rustcorp.com.au> <200812091452.48824.jbarnes@virtuousgeek.org>
In-Reply-To: <200812091452.48824.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812312354.56454.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008 09:22:48 Jesse Barnes wrote:
> On Monday, December 01, 2008 12:20 am Rusty Russell wrote:
> > This uses work_on_cpu(), rather than altering the cpumask of the
> > thread which we happen to be.
> 
> Nice, I applied this to my linux-next branch to get some build/test coverage.  
> Please cc linux-pci in the future though.

Hi Jesse,

   I don't see this in linux-next, nor Linus' tree.  Here it is again...

Subject: work_on_cpu: use in drivers/pci/pci-driver.c

This uses work_on_cpu(), rather than altering the cpumask of the
thread which we happen to be.

Note the cleanups:

1) I've removed the CONFIG_NUMA test, since dev_to_node() returns -1
   for !CONFIG_NUMA anyway and the compiler will eliminate it.

2) No need to reset mempolicy to default (a bad idea anyway) since
   work_on_cpu is run from a workqueue.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci-driver.c |   52 ++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
 #include "pci.h"
 
 /*
@@ -183,32 +184,43 @@ static const struct pci_device_id *pci_m
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
+		int cpu;
 		node_to_cpumask_ptr(nodecpumask, node);
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
+
+		get_online_cpus();
+		cpu = cpumask_any_and(nodecpumask, cpu_online_mask);
+		if (cpu < nr_cpu_ids)
+			error = work_on_cpu(cpu, local_pci_probe, &ddi);
+		else
+			error = local_pci_probe(&ddi);
+		put_online_cpus();
+	} else
+		error = local_pci_probe(&ddi);
 	return error;
 }
 

