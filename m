Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYHGTMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYHGTMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYHGTMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:12:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43609 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYHGTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:12:46 -0400
Subject: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Cc: Zachary Amsden <zach@vmware.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 07 Aug 2008 12:12:45 -0700
Message-Id: <1218136365.23770.52.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The patch below fixes VMI for 2.6.27-rc..

There were these 2 commits which made their way in 2.6.27-rc1 which
broke VMI.

x86: move fix mapping page table range early
commit e7b3789524eecc96213dd69d6686efd429235051
Author: Yinghai Lu <yhlu.kernel@gmail.com>

x86: use acpi_numa_init to parse on 32-bit numa
commit 1c6e55032e24ff79668581a0f296c278ef7edd4e
Author: Yinghai Lu <yhlu.kernel@gmail.com>

VMI relies on relocating the fixmap area to make room for the
hypervisor. These 2 commits started accessing the fixmap area's and
using them before VMI got a chance to check if it wants to relocate the
fixmap area. Once VMI got to the point of relocating the fixmap area's
it resulted in BUG's.

The patch below moves the vmi_init call right after max_low_pfn
is initialized and before we touch the fixmap areas. Also added some
comment so that people know that VMI may relocate the fixmaps.

Please apply.

Thanks,
Alok

--

From: Alok N Kataria <akataria@vmware.com>

Move the vmi_init call right after max_low_pfn is initialized and before
we touch the fixmap areas. Also, document the fact that VMI may relocate
the fixmaps, so that the next programmer doesn't accidently break VMI.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>

---

 arch/x86/kernel/setup.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)


diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2d88858..132b8cd 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -742,6 +742,17 @@ void __init setup_arch(char **cmdline_p)
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
 #endif
 
+#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
+	/*
+	 * Must be after max_low_pfn is determined, and before kernel
+	 * pagetables are setup.
+	 * Also if a VMI ROM is found we relocate the fixmap area to reserve
+	 * space for the hypervisor, make sure this is done before we start
+	 * playing with the fixmap areas. 
+	 */
+	vmi_init();
+#endif
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
@@ -817,14 +828,6 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
-	/*
-	 * Must be after max_low_pfn is determined, and before kernel
-	 * pagetables are setup.
-	 */
-	vmi_init();
-#endif
-
 	paravirt_pagetable_setup_start(swapper_pg_dir);
 	paging_init();
 	paravirt_pagetable_setup_done(swapper_pg_dir);


