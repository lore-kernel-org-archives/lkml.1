Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYHUANd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYHUANd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYHUAMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:12:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:10491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbYHUAL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,242,1217833200"; 
   d="scan'208";a="430926498"
Message-Id: <20080820234604.732847000@intel.com>
References: <20080820234550.923970000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Aug 2008 16:45:54 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 4/4] x86: PAT documentation updates with debug info
Content-Disposition: inline; filename=pat_doc_updates.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation update for PAT. Reflect the latest API details.
Also, adds details about ways to get more info in order to debug PAT.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 Documentation/x86/pat.txt |   54 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 9 deletions(-)

Index: tip/Documentation/x86/pat.txt
===================================================================
--- tip.orig/Documentation/x86/pat.txt	2008-08-20 14:25:16.000000000 -0700
+++ tip/Documentation/x86/pat.txt	2008-08-20 14:26:43.000000000 -0700
@@ -14,6 +14,10 @@ PAT allows for different types of memory
 ones that will be supported at this time are Write-back, Uncached,
 Write-combined and Uncached Minus.
 
+
+PAT APIs
+--------
+
 There are many different APIs in the kernel that allows setting of memory
 attributes at the page level. In order to avoid aliasing, these interfaces
 should be used thoughtfully. Below is a table of interfaces available,
@@ -26,38 +30,38 @@ address range to avoid any aliasing.
 API                    |    RAM   |  ACPI,...  |  Reserved/Holes  |
 -----------------------|----------|------------|------------------|
                        |          |            |                  |
-ioremap                |    --    |    UC      |       UC         |
+ioremap                |    --    |    UC-     |       UC-        |
                        |          |            |                  |
 ioremap_cache          |    --    |    WB      |       WB         |
                        |          |            |                  |
-ioremap_nocache        |    --    |    UC      |       UC         |
+ioremap_nocache        |    --    |    UC-     |       UC-        |
                        |          |            |                  |
 ioremap_wc             |    --    |    --      |       WC         |
                        |          |            |                  |
-set_memory_uc          |    UC    |    --      |       --         |
+set_memory_uc          |    UC-   |    --      |       --         |
  set_memory_wb         |          |            |                  |
                        |          |            |                  |
 set_memory_wc          |    WC    |    --      |       --         |
  set_memory_wb         |          |            |                  |
                        |          |            |                  |
-pci sysfs resource     |    --    |    --      |       UC         |
+pci sysfs resource     |    --    |    --      |       UC-        |
                        |          |            |                  |
 pci sysfs resource_wc  |    --    |    --      |       WC         |
  is IORESOURCE_PREFETCH|          |            |                  |
                        |          |            |                  |
-pci proc               |    --    |    --      |       UC         |
+pci proc               |    --    |    --      |       UC-        |
  !PCIIOC_WRITE_COMBINE |          |            |                  |
                        |          |            |                  |
 pci proc               |    --    |    --      |       WC         |
  PCIIOC_WRITE_COMBINE  |          |            |                  |
                        |          |            |                  |
-/dev/mem               |    --    |    UC      |       UC         |
+/dev/mem               |    --    |  WB/WC/UC- |    WB/WC/UC-     |
  read-write            |          |            |                  |
                        |          |            |                  |
-/dev/mem               |    --    |    UC      |       UC         |
+/dev/mem               |    --    |    UC-     |       UC-        |
  mmap SYNC flag        |          |            |                  |
                        |          |            |                  |
-/dev/mem               |    --    |  WB/WC/UC  |    WB/WC/UC      |
+/dev/mem               |    --    |  WB/WC/UC- |    WB/WC/UC-     |
  mmap !SYNC flag       |          |(from exist-|  (from exist-    |
  and                   |          |  ing alias)|    ing alias)    |
  any alias to this area|          |            |                  |
@@ -68,7 +72,7 @@ pci proc               |    --    |    -
  and                   |          |            |                  |
  MTRR says WB          |          |            |                  |
                        |          |            |                  |
-/dev/mem               |    --    |    --      |    UC_MINUS      |
+/dev/mem               |    --    |    --      |       UC-        |
  mmap !SYNC flag       |          |            |                  |
  no alias to this area |          |            |                  |
  and                   |          |            |                  |
@@ -98,3 +102,35 @@ types.
 
 Drivers should use set_memory_[uc|wc] to set access type for RAM ranges.
 
+
+PAT debugging
+-------------
+
+With CONFIG_DEBUG_FS enabled, PAT memtype list can be examined by
+
+# mount -t debugfs debugfs /sys/kernel/debug
+# cat /sys/kernel/debug/x86/pat_memtype_list
+PAT memtype list:
+uncached-minus @ 0x7fadf000-0x7fae0000
+uncached-minus @ 0x7fb19000-0x7fb1a000
+uncached-minus @ 0x7fb1a000-0x7fb1b000
+uncached-minus @ 0x7fb1b000-0x7fb1c000
+uncached-minus @ 0x7fb1c000-0x7fb1d000
+uncached-minus @ 0x7fb1d000-0x7fb1e000
+uncached-minus @ 0x7fb1e000-0x7fb25000
+uncached-minus @ 0x7fb25000-0x7fb26000
+uncached-minus @ 0x7fb26000-0x7fb27000
+uncached-minus @ 0x7fb27000-0x7fb28000
+uncached-minus @ 0x7fb28000-0x7fb2e000
+uncached-minus @ 0x7fb2e000-0x7fb2f000
+uncached-minus @ 0x7fb2f000-0x7fb30000
+uncached-minus @ 0x7fb31000-0x7fb32000
+uncached-minus @ 0x80000000-0x90000000
+
+This list shows physical address ranges and various PAT settings used to
+access those physical address ranges.
+
+Another, more verbose way of getting PAT related debug messages is with
+"debugpat" boot parameter. With this parameter, various debug messages are
+printed to dmesg log.
+

-- 

