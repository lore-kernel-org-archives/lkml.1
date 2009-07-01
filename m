Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbZGACc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbZGACc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbZGACbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:31:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:29001 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757388AbZGACbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,320,1243839600"; 
   d="scan'208";a="704014454"
Message-ID: <4A4ACA6E.6080702@intel.com>
Date: Tue, 30 Jun 2009 19:31:10 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org
CC: chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, joseph.cihula@intel.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: [RFC v6][PATCH 4/4] intel_txt: force IOMMU on for Intel(R) TXT launch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tboot module will DMA protect all of memory in order to ensure the that
kernel will be able to initialize without compromise (from DMA).  Consequently,
the kernel must enable Intel(R) Virtualization Technology for Directed I/O
(VT-d or Intel IOMMU) in order to replace this broad protection with the
appropriate page-granular protection.  Otherwise DMA devices will be unable
to read or write from memory and the kernel will eventually panic.

Because runtime IOMMU support is configurable by command line options, this
patch will force it to be enabled regardless of the options specified, and will
log a message if it was required to force it on.


 dmar.c        |    7 +++++++
 intel-iommu.c |   17 +++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by: Shane Wang <shane.wang@intel.com>

---

diff -uprN -X linus-2.6.git-0629/Documentation/dontdiff linus-2.6.git-0629/drivers/pci/dmar.c linus-2.6.git-0629-txt/drivers/pci/dmar.c
--- linus-2.6.git-0629/drivers/pci/dmar.c	2009-06-29 21:57:21.000000000 -0700
+++ linus-2.6.git-0629-txt/drivers/pci/dmar.c	2009-06-30 16:15:53.000000000 -0700
@@ -33,6 +33,7 @@
 #include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <asm/tboot.h>
 
 #undef PREFIX
 #define PREFIX "DMAR:"
@@ -413,6 +414,12 @@ parse_dmar_table(void)
 	 */
 	dmar_table_detect();
 
+	/*
+	 * ACPI tables may not be DMA protected by tboot, so use DMAR copy
+	 * SINIT saved in SinitMleData in TXT heap (which is DMA protected)
+	 */
+	dmar_tbl = tboot_get_dmar_table(dmar_tbl);
+
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
 	if (!dmar)
 		return -ENODEV;
diff -uprN -X linus-2.6.git-0629/Documentation/dontdiff linus-2.6.git-0629/drivers/pci/intel-iommu.c linus-2.6.git-0629-txt/drivers/pci/intel-iommu.c
--- linus-2.6.git-0629/drivers/pci/intel-iommu.c	2009-06-29 21:57:21.000000000 -0700
+++ linus-2.6.git-0629-txt/drivers/pci/intel-iommu.c	2009-06-30 17:17:43.000000000 -0700
@@ -38,6 +38,7 @@
 #include <linux/intel-iommu.h>
 #include <linux/sysdev.h>
 #include <asm/cacheflush.h>
+#include <asm/tboot.h>
 #include <asm/iommu.h>
 #include "pci.h"
 
@@ -3113,12 +3114,22 @@ static int __init init_iommu_sysfs(void)
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
+	int force_on = 0;
 
-	if (dmar_table_init())
+	/* VT-d is required for a TXT/tboot launch, so enforce that */
+	force_on = tboot_force_iommu();
+
+	if (dmar_table_init()) {
+		if (force_on)
+			panic("tboot: Failed to initialize DMAR table\n");
 		return 	-ENODEV;
+	}
 
-	if (dmar_dev_scope_init())
+	if (dmar_dev_scope_init()) {
+		if (force_on)
+			panic("tboot: Failed to initialize DMAR device scope\n");
 		return 	-ENODEV;
+	}
 
 	/*
 	 * Check the need for DMA-remapping initialization now.
@@ -3134,6 +3145,8 @@ int __init intel_iommu_init(void)
 
 	ret = init_dmars();
 	if (ret) {
+		if (force_on)
+			panic("tboot: Failed to initialize DMARs\n");
 		printk(KERN_ERR "IOMMU: dmar init failed\n");
 		put_iova_domain(&reserved_iova_list);
 		iommu_exit_mempool();

