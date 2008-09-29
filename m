Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYI2SNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYI2SNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYI2SDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:35 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36492 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754002AbYI2SCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:54 -0400
Message-Id: <20080929180253.258308000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:13 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 23/31] cpumask: clean pci files
Content-Disposition: inline; filename=clean-pci
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 drivers/pci/pci-driver.c |    7 ++++---
 drivers/pci/pci-sysfs.c  |    8 ++++----
 drivers/pci/probe.c      |    4 ++--
 include/asm-x86/pci.h    |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

--- struct-cpumasks.orig/drivers/pci/pci-driver.c
+++ struct-cpumasks/drivers/pci/pci-driver.c
@@ -180,11 +180,12 @@ static int pci_call_probe(struct pci_dri
 	   allocates its local memory on the right node without
 	   any need to change it. */
 	struct mempolicy *oldpol;
-	cpumask_t oldmask = current->cpus_allowed;
+	cpumask_var_t oldmask;
 	int node = dev_to_node(&dev->dev);
 
+	cpus_copy(oldmask, current->cpus_allowed);
 	if (node >= 0)
-		set_cpus_allowed(current, node_to_cpumask(node);
+		set_cpus_allowed(current, node_to_cpumask(node));
 
 	/* And set default memory allocation policy */
 	oldpol = current->mempolicy;
@@ -192,7 +193,7 @@ static int pci_call_probe(struct pci_dri
 #endif
 	error = drv->probe(dev, id);
 #ifdef CONFIG_NUMA
-	set_cpus_allowed(current, &oldmask);
+	set_cpus_allowed(current, oldmask);
 	current->mempolicy = oldpol;
 #endif
 	return error;
--- struct-cpumasks.orig/drivers/pci/pci-sysfs.c
+++ struct-cpumasks/drivers/pci/pci-sysfs.c
@@ -69,10 +69,10 @@ static ssize_t broken_parity_status_stor
 static ssize_t local_cpus_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {		
-	cpumask_t mask;
+	cpumask_var_t mask;
 	int len;
 
-	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
+	cpus_copy(mask, pcibus_to_cpumask(to_pci_dev(dev)->bus));
 	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
@@ -83,10 +83,10 @@ static ssize_t local_cpus_show(struct de
 static ssize_t local_cpulist_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 	int len;
 
-	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
+	cpus_copy(mask, pcibus_to_cpumask(to_pci_dev(dev)->bus));
 	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
--- struct-cpumasks.orig/drivers/pci/probe.c
+++ struct-cpumasks/drivers/pci/probe.c
@@ -119,9 +119,9 @@ static ssize_t pci_bus_show_cpuaffinity(
 					char *buf)
 {
 	int ret;
-	cpumask_t cpumask;
+	cpumask_var_t cpumask;
 
-	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
+	cpus_copy(cpumask, pcibus_to_cpumask(to_pci_bus(dev)));
 	ret = type?
 		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask):
 		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
--- struct-cpumasks.orig/include/asm-x86/pci.h
+++ struct-cpumasks/include/asm-x86/pci.h
@@ -107,7 +107,7 @@ static inline int __pcibus_to_node(struc
 	return sd->node;
 }
 
-static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
+static inline const_cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
 {
 	return node_to_cpumask(__pcibus_to_node(bus));
 }

-- 
