Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbYHSUEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbYHSUEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYHSUDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:03:14 -0400
Received: from gw.goop.org ([64.81.55.164]:38800 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYHSUDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:03:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 3] redefine resource_size_t as phys_addr_t
X-Mercurial-Node: 969978031590c7a8b64ee838b5e0372f6b480993
Message-Id: <969978031590c7a8b64e.1219176172@localhost>
In-Reply-To: <patchbomb.1219176169@localhost>
Date: Tue, 19 Aug 2008 13:02:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ehabkost@redhat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no good reason why a resource_size_t shouldn't just be a
physical address, so simply redefine it in terms of phys_addr_t.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/platforms/Kconfig.cputype |    1 -
 arch/powerpc/sysdev/ppc4xx_pci.c       |   16 ++++++----------
 arch/x86/Kconfig                       |    1 -
 arch/x86/kernel/e820.c                 |    4 +---
 drivers/pci/setup-bus.c                |    9 ++++-----
 include/linux/types.h                  |    8 ++------
 6 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -135,7 +135,6 @@
 config PHYS_64BIT
 	bool 'Large physical address support' if E500
 	depends on 44x || E500
-	select RESOURCES_64BIT
 	default y if 44x
 	---help---
 	  This option enables kernel support for larger than 32-bit physical
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -41,13 +41,10 @@
 #define U64_TO_U32_LOW(val)	((u32)((val) & 0x00000000ffffffffULL))
 #define U64_TO_U32_HIGH(val)	((u32)((val) >> 32))
 
-#ifdef CONFIG_RESOURCES_64BIT
-#define RES_TO_U32_LOW(val)	U64_TO_U32_LOW(val)
-#define RES_TO_U32_HIGH(val)	U64_TO_U32_HIGH(val)
-#else
-#define RES_TO_U32_LOW(val)	(val)
-#define RES_TO_U32_HIGH(val)	(0)
-#endif
+#define RES_TO_U32_LOW(val)	\
+	((sizeof(resource_size_t) > sizeof(u32)) ? U64_TO_U32_LOW(val) : (val))
+#define RES_TO_U32_HIGH(val)	\
+	((sizeof(resource_size_t) > sizeof(u32)) ? U64_TO_U32_HIGH(val) : (0))
 
 static inline int ppc440spe_revA(void)
 {
@@ -145,12 +142,11 @@
 
 		/* Use that */
 		res->start = pci_addr;
-#ifndef CONFIG_RESOURCES_64BIT
 		/* Beware of 32 bits resources */
-		if ((pci_addr + size) > 0x100000000ull)
+		if (sizeof(resource_size_t) == sizeof(u32) &&
+		    (pci_addr + size) > 0x100000000ull)
 			res->end = 0xffffffff;
 		else
-#endif
 			res->end = res->start + size - 1;
 		break;
 	}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -931,7 +931,6 @@
 	def_bool n
 	prompt "PAE (Physical Address Extension) Support"
 	depends on X86_32 && !HIGHMEM4G
-	select RESOURCES_64BIT
 	help
 	  PAE is required for NX support, and furthermore enables
 	  larger swapspace support for non-overcommit purposes. It
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1276,12 +1276,10 @@
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
-#ifndef CONFIG_RESOURCES_64BIT
-		if (end > 0x100000000ULL) {
+		if (end != (resource_size_t)end) {
 			res++;
 			continue;
 		}
-#endif
 		res->name = e820_type_to_string(e820.map[i].type);
 		res->start = e820.map[i].addr;
 		res->end = end;
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -377,11 +377,10 @@
 	align = 0;
 	min_align = 0;
 	for (order = 0; order <= max_order; order++) {
-#ifdef CONFIG_RESOURCES_64BIT
-		resource_size_t align1 = 1ULL << (order + 20);
-#else
-		resource_size_t align1 = 1U << (order + 20);
-#endif
+		resource_size_t align1 = 1;
+
+		align1 <<= (order + 20);
+
 		if (!align)
 			min_align = align1;
 		else if (ALIGN(align + min_align, min_align) < align1)
diff --git a/include/linux/types.h b/include/linux/types.h
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -191,17 +191,13 @@
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 
-#ifdef CONFIG_RESOURCES_64BIT
-typedef u64 resource_size_t;
-#else
-typedef u32 resource_size_t;
-#endif
-
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 phys_addr_t;
 #else
 typedef u32 phys_addr_t;
 #endif
+
+typedef phys_addr_t resource_size_t;
 
 struct ustat {
 	__kernel_daddr_t	f_tfree;


