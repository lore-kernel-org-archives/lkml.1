Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbYENPRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbYENPRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761970AbYENPPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48192 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761949AbYENPPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:42 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:40 -0700
Message-Id: <20080514151540.148486.31062.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 7/10] x86 boot: extend some internal memory map arrays to handle larger EFI input
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Extend internal boot time memory tables to allow for up to
three entries per node, which may be larger than the 128 E820MAX
entries handled by the legacy BIOS E820 interface.  The EFI
interface, if present, is capable of passing memory map
entries for these larger node counts.

This patch requires an earlier patch that rewrote code depending
on these array sizes from using E820MAX explicitly to size loops,
to instead using ARRAY_SIZE() of the applicable array.

Another patch following this one will provide the code to pick
up additional memory entries passed via the EFI interface from
the BIOS and insert them in the following, now enlarged, arrays.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/e820_32.c |    8 ++++----
 arch/x86/kernel/e820_64.c |    8 ++++----
 include/asm-x86/e820.h    |   37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 9 deletions(-)

--- 2.6.26-rc2-mm1.orig/include/asm-x86/e820.h	2008-05-14 03:07:02.719231446 -0700
+++ 2.6.26-rc2-mm1/include/asm-x86/e820.h	2008-05-14 08:03:45.138599021 -0700
@@ -2,6 +2,41 @@
 #define __ASM_E820_H
 #define E820MAP	0x2d0		/* our map */
 #define E820MAX	128		/* number of entries in E820MAP */
+
+/*
+ * Legacy E820 BIOS limits us to 128 (E820MAX) nodes due to the
+ * constrained space in the zeropage.  If we have more nodes than
+ * that, and if we've booted off EFI firmware, then the EFI tables
+ * passed us from the EFI firmware can list more nodes.  Size our
+ * internal memory map tables to have room for these additional
+ * nodes, based on up to three entries per node for which the
+ * kernel was built: MAX_NUMNODES == (1 << CONFIG_NODES_SHIFT),
+ * plus E820MAX, allowing space for the possible duplicate E820
+ * entries that might need room in the same arrays, prior to the
+ * call to sanitize_e820_map() to remove duplicates.  The allowance
+ * of three memory map entries per node is "enough" entries for
+ * the initial hardware platform motivating this mechanism to make
+ * use of additional EFI map entries.  Future platforms may want
+ * to allow more than three entries per node or otherwise refine
+ * this size.
+ */
+
+/*
+ * Odd: 'make headers_check' complains about numa.h if I try
+ * to collapse the next two #ifdef lines to a single line:
+ *	#if defined(__KERNEL__) && defined(CONFIG_EFI)
+ */
+#ifdef __KERNEL__
+#ifdef CONFIG_EFI
+#include <linux/numa.h>
+#define E820_X_MAX (E820MAX + 3 * MAX_NUMNODES)
+#else	/* ! CONFIG_EFI */
+#define E820_X_MAX E820MAX
+#endif
+#else	/* ! __KERNEL__ */
+#define E820_X_MAX E820MAX
+#endif
+
 #define E820NR	0x1e8		/* # entries in E820MAP */
 
 #define E820_RAM	1
@@ -18,7 +53,7 @@ struct e820entry {
 
 struct e820map {
 	__u32 nr_map;
-	struct e820entry map[E820MAX];
+	struct e820entry map[E820_X_MAX];
 };
 #endif /* __ASSEMBLY__ */
 
--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_32.c	2008-05-14 03:07:20.627524130 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_32.c	2008-05-14 07:56:55.307867050 -0700
@@ -21,10 +21,10 @@ struct change_member {
 	struct e820entry *pbios; /* pointer to original bios entry */
 	unsigned long long addr; /* address for this change point */
 };
-static struct change_member change_point_list[2*E820MAX] __initdata;
-static struct change_member *change_point[2*E820MAX] __initdata;
-static struct e820entry *overlap_list[E820MAX] __initdata;
-static struct e820entry new_bios[E820MAX] __initdata;
+static struct change_member change_point_list[2*E820_X_MAX] __initdata;
+static struct change_member *change_point[2*E820_X_MAX] __initdata;
+static struct e820entry *overlap_list[E820_X_MAX] __initdata;
+static struct e820entry new_bios[E820_X_MAX] __initdata;
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0x10000000;
 #ifdef CONFIG_PCI
--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_64.c	2008-05-14 03:07:20.643524392 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_64.c	2008-05-14 07:56:55.307867050 -0700
@@ -516,10 +516,10 @@ int __init sanitize_e820_map(struct e820
 		struct e820entry *pbios; /* pointer to original bios entry */
 		unsigned long long addr; /* address for this change point */
 	};
-	static struct change_member change_point_list[2*E820MAX] __initdata;
-	static struct change_member *change_point[2*E820MAX] __initdata;
-	static struct e820entry *overlap_list[E820MAX] __initdata;
-	static struct e820entry new_bios[E820MAX] __initdata;
+	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
+	static struct change_member *change_point[2*E820_X_MAX] __initdata;
+	static struct e820entry *overlap_list[E820_X_MAX] __initdata;
+	static struct e820entry new_bios[E820_X_MAX] __initdata;
 	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
 	unsigned long long last_addr;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
