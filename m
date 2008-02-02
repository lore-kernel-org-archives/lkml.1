Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbYBBJIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbYBBJIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbYBBJHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:07:00 -0500
Received: from gw.goop.org ([64.81.55.164]:56627 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbYBBJG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:06:56 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 7] x86: put paravirt stubs into common asm/pgalloc.h
X-Mercurial-Node: 57edacf98e79109c981bf99df65c4fec60086165
Message-Id: <57edacf98e79109c981b.1201943115@localhost>
In-Reply-To: <patchbomb.1201943112@localhost>
Date: Sat, 02 Feb 2008 01:05:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pageattr.c       |    2 --
 include/asm-x86/pgalloc.h    |   11 +++++++++++
 include/asm-x86/pgalloc_32.h |   10 ----------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -249,9 +249,7 @@
 	address = __pa(address);
 	addr = address & LARGE_PAGE_MASK;
 	pbase = (pte_t *)page_address(base);
-#ifdef CONFIG_X86_32
 	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
-#endif
 
 	pgprot_val(ref_prot) &= ~_PAGE_NX;
 	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE)
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -4,6 +4,16 @@
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define paravirt_alloc_pt(mm, pfn) do { } while (0)
+#define paravirt_alloc_pd(mm, pfn) do { } while (0)
+#define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) do { } while (0)
+#define paravirt_release_pt(pfn) do { } while (0)
+#define paravirt_release_pd(pfn) do { } while (0)
+#endif
 
 /*
  * Allocate and free page tables.
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -1,15 +1,5 @@
 #ifndef _I386_PGALLOC_H
 #define _I386_PGALLOC_H
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define paravirt_alloc_pt(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) do { } while (0)
-#define paravirt_release_pt(pfn) do { } while (0)
-#define paravirt_release_pd(pfn) do { } while (0)
-#endif
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 				       pmd_t *pmd, pte_t *pte)


