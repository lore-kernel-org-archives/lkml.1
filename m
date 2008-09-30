Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYI3DTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYI3DTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYI3DTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:19:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:2935 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYI3DT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="53008299"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 29 Sep 2008 20:19:27 -0700
Message-ID: <20080930031927.22950.4692.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:19:27.0356 (UTC) FILETIME=[58561BC0:01C922AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

> I did some snooping around, and while doing so I noticed that the PCI
> mmap code for x86 doesn't do one bit of range checking on the size, or
> any other aspect of the request, wrt. the MMIO regions actually mapped
> in the BARs of the PCI device.

Here's a patch that adds range checking to the sysfs mappings at
least.  This patch should catch the case where X (or some other
process) tries to map beyond the specific BAR it's (supposedly)
trying to access, making things safer in general.  FWIW both my
F9 and development versions of X start up fine with this patch
applied.

DaveM, will this work for you on sparc?  It looked like your code
was allowing bridge window mappings, but that behavior should be
preserved as long as your bridge devices reflect their window
sizes correctly in their pdev->resources?

If we add similar code to the procfs stuff we wouldn't need to do
any checking in the arches.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/pci/pci-sysfs.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c71858..4d1aa6e 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -16,6 +16,7 @@
 
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/stat.h>
 #include <linux/topology.h>
@@ -502,6 +503,8 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	struct resource *res = (struct resource *)attr->private;
 	enum pci_mmap_state mmap_type;
 	resource_size_t start, end;
+	unsigned long map_len = vma->vm_end - vma->vm_start;
+	unsigned long map_offset = vma->vm_pgoff << PAGE_SHIFT;
 	int i;
 
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
@@ -510,6 +513,17 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
+	/*
+	 * Make sure the range the user is trying to map falls within
+	 * the resource
+	 */
+	if (map_offset + map_len > pci_resource_len(pdev, i)) {
+		WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on BAR %d (size 0x%08lx)\n",
+		     current->comm, map_offset, map_offset + map_len, i,
+		     (unsigned long)pci_resource_len(pdev, i));
+		return -EINVAL;
+	}
+
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is
 	 * different from the resource itself, arch will do necessary fixup.

