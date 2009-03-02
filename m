Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbZCBIsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbZCBIsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbZCBIsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:48:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305AbZCBIsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:48:09 -0500
Date: Mon, 2 Mar 2009 09:47:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fixes
Message-ID: <20090302084748.GA8982@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/linux/io-mapping.h         # 5ce04e3: fix warning in io_mapping_map_wc(

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86: i915 needs pgprot_writecombine() and is_io_mapping_possible()

Pallipadi, Venkatesh (1):
      fix warning in io_mapping_map_wc()


 arch/x86/mm/iomap_32.c     |   15 ++++-----------
 arch/x86/mm/pat.c          |    2 ++
 include/linux/io-mapping.h |    5 ++++-
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 6c2b1af..04102d4 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -20,23 +20,16 @@
 #include <asm/pat.h>
 #include <linux/module.h>
 
-#ifdef CONFIG_X86_PAE
-int
-is_io_mapping_possible(resource_size_t base, unsigned long size)
-{
-	return 1;
-}
-#else
-int
-is_io_mapping_possible(resource_size_t base, unsigned long size)
+int is_io_mapping_possible(resource_size_t base, unsigned long size)
 {
+#ifndef CONFIG_X86_PAE
 	/* There is no way to map greater than 1 << 32 address without PAE */
 	if (base + size > 0x100000000ULL)
 		return 0;
-
+#endif
 	return 1;
 }
-#endif
+EXPORT_SYMBOL_GPL(is_io_mapping_possible);
 
 /* Map 'pfn' using fixed map 'type' and protections 'prot'
  */
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index aebbf67..e0ab173 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -11,6 +11,7 @@
 #include <linux/bootmem.h>
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
@@ -868,6 +869,7 @@ pgprot_t pgprot_writecombine(pgprot_t prot)
 	else
 		return pgprot_noncached(prot);
 }
+EXPORT_SYMBOL_GPL(pgprot_writecombine);
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index cbc2f0c..0adb0f9 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -91,8 +91,11 @@ io_mapping_unmap_atomic(void *vaddr)
 static inline void *
 io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 {
+	resource_size_t phys_addr;
+
 	BUG_ON(offset >= mapping->size);
-	resource_size_t phys_addr = mapping->base + offset;
+	phys_addr = mapping->base + offset;
+
 	return ioremap_wc(phys_addr, PAGE_SIZE);
 }
 
