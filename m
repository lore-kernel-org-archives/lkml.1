Return-Path: <linux-kernel-owner+w=401wt.eu-S933745AbYCSUck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745AbYCSUck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbYCSTjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:16668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbYCSTiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="263474477"
Message-Id: <20080319000058.347398000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:13 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 01/13] x86: PAT documentation
Content-Disposition: inline; filename=pat_documentation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation about PAT related interfaces, intended usage and memory attribute
relationship.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/Documentation/x86/pat.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-x86.git/Documentation/x86/pat.txt	2008-03-17 05:05:53.000000000 -0700
@@ -0,0 +1,100 @@
+
+PAT (Page Attribute Table)
+
+x86 Page Attribute Table (PAT) allows for setting the memory attribute at the
+page level granularity. PAT is complementary to the MTRR settings which allows
+for setting of memory types over physical address ranges. However, PAT is
+more flexible than MTRR due to its capability to set attributes at page level
+and also due to the fact that there are no hardware limitations on number of
+such attribute settings allowed. Added flexibility comes with guidelines for
+not having memory type aliasing for the same physical memory with multiple
+virtual addresses.
+
+PAT allows for different types of memory attributes. The most commonly used
+ones that will be supported at this time are Write-back, Uncached,
+Write-combined and Uncached Minus.
+
+There are many different APIs in the kernel that allows setting of memory
+attributes at the page level. In order to avoid aliasing, these interfaces
+should be used thoughtfully. Below is a table of interfaces available,
+their intended usage and their memory attribute relationships. Internally,
+these APIs use a reserve_memtype()/free_memtype() interface on the physical
+address range to avoid any aliasing.
+
+
+-------------------------------------------------------------------
+API                    |    RAM   |  ACPI,...  |  Reserved/Holes  |
+-----------------------|----------|------------|------------------|
+                       |          |            |                  |
+ioremap                |    --    |    UC      |       UC         |
+                       |          |            |                  |
+ioremap_cache          |    --    |    WB      |       WB         |
+                       |          |            |                  |
+ioremap_nocache        |    --    |    UC      |       UC         |
+                       |          |            |                  |
+ioremap_wc             |    --    |    --      |       WC         |
+                       |          |            |                  |
+set_memory_uc          |    UC    |    --      |       --         |
+ set_memory_wb         |          |            |                  |
+                       |          |            |                  |
+set_memory_wc          |    WC    |    --      |       --         |
+ set_memory_wb         |          |            |                  |
+                       |          |            |                  |
+pci sysfs resource     |    --    |    --      |       UC         |
+                       |          |            |                  |
+pci sysfs resource_wc  |    --    |    --      |       WC         |
+ is IORESOURCE_PREFETCH|          |            |                  |
+                       |          |            |                  |
+pci proc               |    --    |    --      |       UC         |
+ !PCIIOC_WRITE_COMBINE |          |            |                  |
+                       |          |            |                  |
+pci proc               |    --    |    --      |       WC         |
+ PCIIOC_WRITE_COMBINE  |          |            |                  |
+                       |          |            |                  |
+/dev/mem               |    --    |    UC      |       UC         |
+ read-write            |          |            |                  |
+                       |          |            |                  |
+/dev/mem               |    --    |    UC      |       UC         |
+ mmap SYNC flag        |          |            |                  |
+                       |          |            |                  |
+/dev/mem               |    --    |  WB/WC/UC  |    WB/WC/UC      |
+ mmap !SYNC flag       |          |(from exist-|  (from exist-    |
+ and                   |          |  ing alias)|    ing alias)    |
+ any alias to this area|          |            |                  |
+                       |          |            |                  |
+/dev/mem               |    --    |    WB      |       WB         |
+ mmap !SYNC flag       |          |            |                  |
+ no alias to this area |          |            |                  |
+ and                   |          |            |                  |
+ MTRR says WB          |          |            |                  |
+                       |          |            |                  |
+/dev/mem               |    --    |    --      |    UC_MINUS      |
+ mmap !SYNC flag       |          |            |                  |
+ no alias to this area |          |            |                  |
+ and                   |          |            |                  |
+ MTRR says !WB         |          |            |                  |
+                       |          |            |                  |
+-------------------------------------------------------------------
+
+Notes:
+
+-- in the above table mean "Not suggested usage for the API". Some of the --'s
+are strictly enforced by the kernel. Some others are not really enforced
+today, but may be enforced in future.
+
+For ioremap and pci access through /sys or /proc - The actual type returned
+can be more restrictive, in case of any existing aliasing for that address.
+For example: If there is an existing uncached mapping, a new ioremap_wc can
+return uncached mapping in place of write-combine requested.
+
+set_memory_[uc|wc] and set_memory_wb should be used in pairs, where driver will
+first make a region uc or wc and switch it back to wb after use.
+
+Over time writes to /proc/mtrr will be deprecated in favor of using PAT based
+interfaces. Users writing to /proc/mtrr are suggested to use above interfaces.
+
+Drivers should use ioremap_[uc|wc] to access PCI BARs with [uc|wc] access
+types.
+
+Drivers should use set_memory_[uc|wc] to set access type for RAM ranges.
+

-- 
