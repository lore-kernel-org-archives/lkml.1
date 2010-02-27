Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030937Ab0B0Xw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 18:52:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:48625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030914Ab0B0XwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 18:52:25 -0500
Date: Sat, 27 Feb 2010 23:51:55 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ian.campbell@citrix.com, jeremy@goop.org, tglx@linutronix.de,
       akataria@vmware.com, mingo@elte.hu
Reply-To: jeremy@goop.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, ian.campbell@citrix.com,
       akataria@vmware.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267204562-11844-2-git-send-email-ian.campbell@citrix.com>
References: <1267204562-11844-2-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, vmi: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y
Message-ID: <tip-3249b7e1df6380e9d7bb3238f64f445bf614f787@git.kernel.org>
Git-Commit-ID: 3249b7e1df6380e9d7bb3238f64f445bf614f787
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 23:51:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3249b7e1df6380e9d7bb3238f64f445bf614f787
Gitweb:     http://git.kernel.org/tip/3249b7e1df6380e9d7bb3238f64f445bf614f787
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Fri, 26 Feb 2010 17:16:01 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 27 Feb 2010 14:41:16 -0800

x86, vmi: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y

Preventing HIGHPTE allocations under VMI will allow us to remove the
kmap_atomic_pte paravirt op.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
LKML-Reference: <1267204562-11844-2-git-send-email-ian.campbell@citrix.com>
Acked-by: Alok Kataria <akataria@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/vmi_32.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index d430e4c..58aca86 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -33,6 +33,7 @@
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <asm/apic.h>
+#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/timer.h>
 #include <asm/vmi_time.h>
@@ -272,19 +273,11 @@ static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
 	void *va = kmap_atomic(page, type);
 
 	/*
-	 * Internally, the VMI ROM must map virtual addresses to physical
-	 * addresses for processing MMU updates.  By the time MMU updates
-	 * are issued, this information is typically already lost.
-	 * Fortunately, the VMI provides a cache of mapping slots for active
-	 * page tables.
-	 *
-	 * We use slot zero for the linear mapping of physical memory, and
-	 * in HIGHPTE kernels, slot 1 and 2 for KM_PTE0 and KM_PTE1.
-	 *
-	 *  args:                 SLOT                 VA    COUNT PFN
+	 * We disable highmem allocations for page tables so we should never
+	 * see any calls to kmap_atomic_pte on a highmem page.
 	 */
-	BUG_ON(type != KM_PTE0 && type != KM_PTE1);
-	vmi_ops.set_linear_mapping((type - KM_PTE0)+1, va, 1, page_to_pfn(page));
+
+	BUG_ON(PageHighmem(page));
 
 	return va;
 }
@@ -640,6 +633,12 @@ static inline int __init activate_vmi(void)
 	u64 reloc;
 	const struct vmi_relocation_info *rel = (struct vmi_relocation_info *)&reloc;
 
+	/*
+	 * Prevent page tables from being allocated in highmem, even if
+	 * CONFIG_HIGHPTE is enabled.
+	 */
+	__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
+
 	if (call_vrom_func(vmi_rom, vmi_init) != 0) {
 		printk(KERN_ERR "VMI ROM failed to initialize!");
 		return 0;
