Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbYGCHFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbYGCHFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYGCG5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:65205 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbYGCCZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:25:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,741,1204531200"; 
   d="scan'208";a="584545888"
Subject: [RFC PATCH 3/4] x86_64: mark ACPI NVS memory region
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 10:24:36 +0800
Message-Id: <1215051876.5628.35.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86_64: Mark ACPI NVS memory region.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 arch/x86/kernel/e820_64.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c	2008-06-19 15:09:52.000000000 +0800
+++ linux-2.6/arch/x86/kernel/e820_64.c	2008-06-19 15:11:45.000000000 +0800
@@ -19,6 +19,8 @@
 #include <linux/mm.h>
 #include <linux/suspend.h>
 #include <linux/pfn.h>
+#include <linux/efi.h>
+#include <linux/acpi.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -377,6 +379,33 @@
 	}
 }
 
+#ifdef CONFIG_HIBERNATION
+/* Mark ACPI NVS region, so that OS can save/restore it during hibernation */
+static int __init e820_mark_nvs_memory(void)
+{
+	int i;
+
+	if (efi_enabled)
+		return 0;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		unsigned long start, end;
+
+		if (ei->type != E820_NVS)
+			continue;
+		start = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
+		end = round_down(ei->addr + ei->size, PAGE_SIZE) >> PAGE_SHIFT;
+		if (start >= end)
+			continue;
+
+		acpi_mark_nvs_region(start, end - 1);
+	}
+	return 0;
+}
+core_initcall(e820_mark_nvs_memory);
+#endif
+
 /*
  * Finds an active region in the address range from start_pfn to end_pfn and
  * returns its range in ei_startpfn and ei_endpfn for the e820 entry.


