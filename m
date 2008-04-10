Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYDJPAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYDJPAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYDJPA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:00:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbYDJPAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:00:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/5] FRV: Handle update_mmu_cache() being called when
	current->mm is NULL
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 10 Apr 2008 16:00:20 +0100
Message-ID: <20080410150020.30046.84293.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Handle update_mmu_cache() being called when current->mm is NULL.

We cache static TLB mappings for the current page table in DAMPR4 and DAMPR5
on the theory that the next data lookup is likely to be in the same general
region, and thus is likely to be mapped by the same page table.  However, we
can't get this information if we can't access the appropriate mm_struct.

If current->mm is NULL, we just clear the cache in the knowledge that the TLB
miss handlers will load it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Makefile                  |   11 ++++++-----
 include/asm-frv/pgtable.h |   19 ++++++++++++++-----
 2 files changed, 20 insertions(+), 10 deletions(-)


diff --git a/Makefile b/Makefile
index fec2a12..54d4fb2 100644
--- a/Makefile
+++ b/Makefile
@@ -501,11 +501,12 @@ endif # $(dot-config)
 # Defaults vmlinux but it is usually overridden in the arch makefile
 all: vmlinux
 
-ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-KBUILD_CFLAGS	+= -Os
-else
-KBUILD_CFLAGS	+= -O2
-endif
+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+#KBUILD_CFLAGS	+= -Os
+#else
+#KBUILD_CFLAGS	+= -O2
+#endif
+KBUILD_CFLAGS	+= -O1
 
 # Force gcc to behave correct even for buggy distributions
 # Arch Makefiles may override this setting
diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index 6c0682e..4e21904 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -507,13 +507,22 @@ static inline int pte_file(pte_t pte)
  */
 static inline void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
 {
+	struct mm_struct *mm;
 	unsigned long ampr;
-	pgd_t *pge = pgd_offset(current->mm, address);
-	pud_t *pue = pud_offset(pge, address);
-	pmd_t *pme = pmd_offset(pue, address);
 
-	ampr = pme->ste[0] & 0xffffff00;
-	ampr |= xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C | xAMPRx_V;
+	mm = current->mm;
+	if (mm) {
+		pgd_t *pge = pgd_offset(mm, address);
+		pud_t *pue = pud_offset(pge, address);
+		pmd_t *pme = pmd_offset(pue, address);
+
+		ampr = pme->ste[0] & 0xffffff00;
+		ampr |= xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C |
+			xAMPRx_V;
+	} else {
+		address = ULONG_MAX;
+		ampr = 0;
+	}
 
 	asm volatile("movgs %0,scr0\n"
 		     "movgs %0,scr1\n"

