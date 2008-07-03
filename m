Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYGCHF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYGCHF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYGCG5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:23231 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbYGCC0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,741,1204531200"; 
   d="scan'208";a="584545902"
Subject: [RFC PATCH 4/4] x86_32: mark ACPI NVS memory region
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 10:24:39 +0800
Message-Id: <1215051879.5628.36.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86_32: Mark ACPI NVS memory region.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 arch/x86/kernel/e820_32.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c	2008-07-01 09:32:27.000000000 +0800
+++ linux-2.6/arch/x86/kernel/e820_32.c	2008-07-03 09:00:37.000000000 +0800
@@ -10,6 +10,8 @@
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
+#include <linux/efi.h>
+#include <linux/acpi.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -253,6 +255,30 @@
 			break;
 	}
 }
+
+/* Mark ACPI NVS region so that OS can save/restore it during hibernation */
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
+		start = PFN_UP(ei->addr);
+		end = PFN_DOWN(ei->addr + ei->size);
+		if (start >= end)
+			continue;
+		acpi_mark_nvs_region(start, end - 1);
+	}
+	return 0;
+}
+core_initcall(e820_mark_nvs_memory);
 #endif
 
 void __init add_memory_region(unsigned long long start,


