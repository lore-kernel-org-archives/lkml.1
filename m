Return-Path: <linux-kernel-owner+w=401wt.eu-S1760989AbZE0HSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989AbZE0HSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbZE0HQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:16:59 -0400
Received: from claw.goop.org ([74.207.240.146]:41417 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759432AbZE0HQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:16:58 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/16] xen/dom0: Use host E820 map
Date: Wed, 27 May 2009 00:15:30 -0700
Message-Id: <1243408538-21100-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243408538-21100-1-git-send-email-jeremy@goop.org>
References: <1243408538-21100-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Unlike the non-paravirt Xen port we do not have distinct psuedo-physical
and I/O memory resource-spaces and therefore resources in the two
can clash. Fix this by registering a memory map which matches the
underlying I/O map. Currently this wastes the memory in the reserved
regions. Eventually we should remap this memory to the end of the
address space.

[ Impact: synthesize virtual E820 using real one as template ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/setup.c           |   45 +++++++++++++++++++++++++++++++++++++--
 include/xen/interface/memory.h |   29 +++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index dc55171..805ae53 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -19,6 +19,7 @@
 
 #include <xen/page.h>
 #include <xen/interface/callback.h>
+#include <xen/interface/memory.h>
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
 
@@ -36,16 +37,54 @@ extern void xen_syscall32_target(void);
 /**
  * machine_specific_memory_setup - Hook for machine specific memory setup.
  **/
-
 char * __init xen_memory_setup(void)
 {
 	unsigned long max_pfn = xen_start_info->nr_pages;
+	unsigned long long mem_end;
+	int rc;
+	struct xen_memory_map memmap;
+	/*
+	 * This is rather large for a stack variable but this early in
+	 * the boot process we know we have plenty slack space.
+	 */
+	struct e820entry map[E820MAX];
+	int op = xen_initial_domain() ?
+		XENMEM_machine_memory_map :
+		XENMEM_memory_map;
+	int i;
 
 	max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
+	mem_end = PFN_PHYS((u64)max_pfn);
+
+	memmap.nr_entries = E820MAX;
+	set_xen_guest_handle(memmap.buffer, map);
+
+	rc = HYPERVISOR_memory_op(op, &memmap);
+	if (rc == -ENOSYS) {
+		memmap.nr_entries = 1;
+		map[0].addr = 0ULL;
+		map[0].size = mem_end;
+		/* 8MB slack (to balance backend allocations). */
+		map[0].size += 8ULL << 20;
+		map[0].type = E820_RAM;
+		rc = 0;
+	}
+	BUG_ON(rc);
 
 	e820.nr_map = 0;
-
-	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
+	for (i = 0; i < memmap.nr_entries; i++) {
+		unsigned long long end = map[i].addr + map[i].size;
+		if (map[i].type == E820_RAM) {
+			if (map[i].addr > mem_end)
+				continue;
+			if (end > mem_end) {
+				/* Truncate region to max_mem. */
+				map[i].size -= end - mem_end;
+			}
+		}
+		if (map[i].size > 0)
+			e820_add_region(map[i].addr, map[i].size, map[i].type);
+	}
 
 	/*
 	 * Even though this is normal, usable memory under Xen, reserve
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index af36ead..e6c6bcb 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -142,4 +142,33 @@ struct xen_translate_gpfn_list {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_translate_gpfn_list);
 
+/*
+ * Returns the pseudo-physical memory map as it was when the domain
+ * was started (specified by XENMEM_set_memory_map).
+ * arg == addr of struct xen_memory_map.
+ */
+#define XENMEM_memory_map           9
+struct xen_memory_map {
+    /*
+     * On call the number of entries which can be stored in buffer. On
+     * return the number of entries which have been stored in
+     * buffer.
+     */
+    unsigned int nr_entries;
+
+    /*
+     * Entries in the buffer are in the same format as returned by the
+     * BIOS INT 0x15 EAX=0xE820 call.
+     */
+    GUEST_HANDLE(void) buffer;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
+
+/*
+ * Returns the real physical memory map. Passes the same structure as
+ * XENMEM_memory_map.
+ * arg == addr of struct xen_memory_map.
+ */
+#define XENMEM_machine_memory_map   10
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
-- 
1.6.0.6

