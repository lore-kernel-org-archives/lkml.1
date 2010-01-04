Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468Ab0ADO7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0ADO7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0ADO7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:59:34 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:37817 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0ADO7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:59:34 -0500
From: David John <davidjon@xenontk.org>
To: jbarnes@virtuousgeek.org, rusty@rustcorp.com.au
Cc: andreas.herrmann3@amd.com, rjw@sisk.pl, jin.dongming@np.css.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH v3] Check the node argument passed to cpumask_of_node
Date: Mon,  4 Jan 2010 20:28:57 +0530
Message-Id: <1262617137-3321-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: BlackWidow
In-Reply-To: <4B41D42A.9040008@xenontk.org>
References: <4B41D42A.9040008@xenontk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e0cd516 "PCI: derive nearby CPUs from device's instead of bus' NUMA information"
causes an null pointer dereference when reading from the sysfs attributes local_cpu*
on Intel machines with no ACPI NUMA proximity info, since dev->numa_node gets set to -1
for all PCI devices, which then gets passed to cpumask_of_node.

Add a check to prevent this.

Signed-off-by: David John <davidjon@xenontk.org>

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index c5df94e..807224e 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -75,7 +75,8 @@ static ssize_t local_cpus_show(struct device *dev,
 	int len;
 
 #ifdef CONFIG_NUMA
-	mask = cpumask_of_node(dev_to_node(dev));
+	mask = (dev_to_node(dev) == -1) ? cpu_online_mask :
+					  cpumask_of_node(dev_to_node(dev));
 #else
 	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
 #endif
@@ -93,7 +94,8 @@ static ssize_t local_cpulist_show(struct device *dev,
 	int len;
 
 #ifdef CONFIG_NUMA
-	mask = cpumask_of_node(dev_to_node(dev));
+	mask = (dev_to_node(dev) == -1) ? cpu_online_mask :
+					  cpumask_of_node(dev_to_node(dev));
 #else
 	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
 #endif
