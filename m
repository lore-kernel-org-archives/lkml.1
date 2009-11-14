Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZKNAPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZKNAPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbZKNAPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:15:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48404 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbZKNAPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:15:04 -0500
Date: Sat, 14 Nov 2009 01:15:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-mm@kvack.org, gerald.schaefer@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow memory hotplug and hibernation in the same kernel
Message-ID: <20091114001509.GH30880@basil.fritz.box>
References: <20091113105944.GA16028@basil.fritz.box> <200911132116.02659.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911132116.02659.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This also is going to affect suspend to RAM, which kind of makes sense BTW,
> so I'd not put it under the #ifdef.  Also, the names should reflect the fact
> that suspend is affected too.  What about block|unblock_system_sleep()?

Here's a updated version with that rename.

-Andi

---

Allow memory hotplug and hibernation in the same kernel v2

Memory hotplug and hibernation was excluded in Kconfig. This is obviously
a problem for distribution kernels who want to support both in the same
image.

After some discussions with Rafael and others the only problem is 
with parallel memory hotadd or removal while a hibernation operation
is in process. It was also working for s390 before.

This patch removes the Kconfig level exclusion, and simply
makes the memory add / remove functions grab the pm_mutex
to exclude against hibernation.

This is a 2.6.32 candidate.

v2: Rename lock_hibernation to lock_system_sleep

Cc: gerald.schaefer@de.ibm.com
Cc: rjw@sisk.pl

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/suspend.h |   21 +++++++++++++++++++--
 mm/Kconfig              |    5 +----
 mm/memory_hotplug.c     |   21 +++++++++++++++++----
 3 files changed, 37 insertions(+), 10 deletions(-)

Index: linux-2.6.32-rc6-ak/include/linux/suspend.h
===================================================================
--- linux-2.6.32-rc6-ak.orig/include/linux/suspend.h
+++ linux-2.6.32-rc6-ak/include/linux/suspend.h
@@ -301,6 +301,8 @@ static inline int unregister_pm_notifier
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 #endif /* !CONFIG_PM_SLEEP */
 
+extern struct mutex pm_mutex;
+
 #ifndef CONFIG_HIBERNATION
 static inline void register_nosave_region(unsigned long b, unsigned long e)
 {
@@ -308,8 +310,23 @@ static inline void register_nosave_regio
 static inline void register_nosave_region_late(unsigned long b, unsigned long e)
 {
 }
-#endif
 
-extern struct mutex pm_mutex;
+static inline void lock_system_sleep(void) {}
+static inline void unlock_system_sleep(void) {}
+
+#else
+
+/* Let some subsystems like memory hotadd exclude hibernation */
+
+static inline void lock_system_sleep(void)
+{
+	mutex_lock(&pm_mutex);
+}
+
+static inline void unlock_system_sleep(void)
+{
+	mutex_unlock(&pm_mutex);
+}
+#endif
 
 #endif /* _LINUX_SUSPEND_H */
Index: linux-2.6.32-rc6-ak/mm/Kconfig
===================================================================
--- linux-2.6.32-rc6-ak.orig/mm/Kconfig
+++ linux-2.6.32-rc6-ak/mm/Kconfig
@@ -128,12 +128,9 @@ config SPARSEMEM_VMEMMAP
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
-	depends on HOTPLUG && !(HIBERNATION && !S390) && ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
 
-comment "Memory hotplug is currently incompatible with Software Suspend"
-	depends on SPARSEMEM && HOTPLUG && HIBERNATION && !S390
-
 config MEMORY_HOTPLUG_SPARSE
 	def_bool y
 	depends on SPARSEMEM && MEMORY_HOTPLUG
Index: linux-2.6.32-rc6-ak/mm/memory_hotplug.c
===================================================================
--- linux-2.6.32-rc6-ak.orig/mm/memory_hotplug.c
+++ linux-2.6.32-rc6-ak/mm/memory_hotplug.c
@@ -26,6 +26,7 @@
 #include <linux/migrate.h>
 #include <linux/page-isolation.h>
 #include <linux/pfn.h>
+#include <linux/suspend.h>
 
 #include <asm/tlbflush.h>
 
@@ -484,14 +485,18 @@ int __ref add_memory(int nid, u64 start,
 	struct resource *res;
 	int ret;
 
+	lock_system_sleep();
+
 	res = register_memory_resource(start, size);
+	ret = -EEXIST;
 	if (!res)
-		return -EEXIST;
+		goto out;
 
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);
+		ret = -ENOMEM;
 		if (!pgdat)
-			return -ENOMEM;
+			goto out;
 		new_pgdat = 1;
 	}
 
@@ -514,7 +519,8 @@ int __ref add_memory(int nid, u64 start,
 		BUG_ON(ret);
 	}
 
-	return ret;
+	goto out;
+
 error:
 	/* rollback pgdat allocation and others */
 	if (new_pgdat)
@@ -522,6 +528,8 @@ error:
 	if (res)
 		release_memory_resource(res);
 
+out:
+	unlock_system_sleep();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
@@ -758,6 +766,8 @@ int offline_pages(unsigned long start_pf
 	if (!test_pages_in_a_zone(start_pfn, end_pfn))
 		return -EINVAL;
 
+	lock_system_sleep();
+
 	zone = page_zone(pfn_to_page(start_pfn));
 	node = zone_to_nid(zone);
 	nr_pages = end_pfn - start_pfn;
@@ -765,7 +775,7 @@ int offline_pages(unsigned long start_pf
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn);
 	if (ret)
-		return ret;
+		goto out;
 
 	arg.start_pfn = start_pfn;
 	arg.nr_pages = nr_pages;
@@ -843,6 +853,7 @@ repeat:
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
+	unlock_system_sleep();
 	return 0;
 
 failed_removal:
@@ -852,6 +863,8 @@ failed_removal:
 	/* pushback to free area */
 	undo_isolate_page_range(start_pfn, end_pfn);
 
+out:
+	unlock_system_sleep();
 	return ret;
 }
 
