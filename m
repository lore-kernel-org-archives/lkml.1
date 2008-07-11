Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbYGKFbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbYGKFbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYGKFaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:30:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:2252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbYGKFaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,342,1212390000"; 
   d="scan'208";a="353604457"
Subject: [linux-next] [PATCH V2 3/4] ACPI: mark ACPI NVS memory region
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 11 Jul 2008 13:29:12 +0800
Message-Id: <1215754152.1617.60.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mark ACPI NVS memory region during startup.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 arch/x86/kernel/e820.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: linux-next/arch/x86/kernel/e820.c
===================================================================
--- linux-next.orig/arch/x86/kernel/e820.c	2008-07-11 11:44:54.000000000 +0800
+++ linux-next/arch/x86/kernel/e820.c	2008-07-11 11:52:22.000000000 +0800
@@ -19,6 +19,8 @@
 #include <linux/mm.h>
 #include <linux/pfn.h>
 #include <linux/suspend.h>
+#include <linux/efi.h>
+#include <linux/acpi.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -623,6 +625,33 @@
 }
 #endif
 
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
+		start = PFN_UP(ei->addr);
+		end = PFN_DOWN(ei->addr + ei->size);
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
  * Early reserved memory areas.
  */


