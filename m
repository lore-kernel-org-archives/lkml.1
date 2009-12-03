Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZLCVMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZLCVMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbZLCVMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:12:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbZLCVMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:12:33 -0500
Date: Thu, 3 Dec 2009 22:12:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/pat for v2.6.33
Message-ID: <20091203211222.GA2317@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-pat-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-pat-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      x86: Relegate CONFIG_PAT and CONFIG_MTRR configurability to EMBEDDED

Xiaotian Feng (2):
      x86: pat: Clean up req_type special case for reserve_memtype()
      x86: pat: Remove ioremap_default()


 arch/x86/Kconfig      |    7 +++++--
 arch/x86/mm/ioremap.c |   26 +-------------------------
 arch/x86/mm/pat.c     |    7 +------
 3 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c876bac..a67363b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1321,7 +1321,9 @@ config MATH_EMULATION
 	  kernel, it won't hurt.
 
 config MTRR
-	bool "MTRR (Memory Type Range Register) support"
+	bool
+	default y
+	prompt "MTRR (Memory Type Range Register) support" if EMBEDDED
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
 	  the Memory Type Range Registers (MTRRs) may be used to control
@@ -1387,7 +1389,8 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
 
 config X86_PAT
 	bool
-	prompt "x86 PAT support"
+	default y
+	prompt "x86 PAT support" if EMBEDDED
 	depends on MTRR
 	---help---
 	  Use PAT attributes to setup page level cache control.
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..3af10de 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -283,30 +283,6 @@ void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_cache);
 
-static void __iomem *ioremap_default(resource_size_t phys_addr,
-					unsigned long size)
-{
-	unsigned long flags;
-	void __iomem *ret;
-	int err;
-
-	/*
-	 * - WB for WB-able memory and no other conflicting mappings
-	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
-	 * - Inherit from confliting mappings otherwise
-	 */
-	err = reserve_memtype(phys_addr, phys_addr + size,
-				_PAGE_CACHE_WB, &flags);
-	if (err < 0)
-		return NULL;
-
-	ret = __ioremap_caller(phys_addr, size, flags,
-			       __builtin_return_address(0));
-
-	free_memtype(phys_addr, phys_addr + size);
-	return ret;
-}
-
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
 				unsigned long prot_val)
 {
@@ -382,7 +358,7 @@ void *xlate_dev_mem_ptr(unsigned long phys)
 	if (page_is_ram(start >> PAGE_SHIFT))
 		return __va(phys);
 
-	addr = (void __force *)ioremap_default(start, PAGE_SIZE);
+	addr = (void __force *)ioremap_cache(start, PAGE_SIZE);
 	if (addr)
 		addr = (void *)((unsigned long)addr | (phys & ~PAGE_MASK));
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e78cd0e..81fb753 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -355,9 +355,6 @@ static int free_ram_pages_type(u64 start, u64 end)
  * - _PAGE_CACHE_UC_MINUS
  * - _PAGE_CACHE_UC
  *
- * req_type will have a special case value '-1', when requester want to inherit
- * the memory type from mtrr (if WB), existing PAT, defaulting to UC_MINUS.
- *
  * If new_type is NULL, function will return an error if it cannot reserve the
  * region with req_type. If new_type is non-NULL, function will return
  * available type in new_type in case of no error. In case of any error
@@ -377,9 +374,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	if (!pat_enabled) {
 		/* This is identical to page table setting without PAT */
 		if (new_type) {
-			if (req_type == -1)
-				*new_type = _PAGE_CACHE_WB;
-			else if (req_type == _PAGE_CACHE_WC)
+			if (req_type == _PAGE_CACHE_WC)
 				*new_type = _PAGE_CACHE_UC_MINUS;
 			else
 				*new_type = req_type & _PAGE_CACHE_MASK;
