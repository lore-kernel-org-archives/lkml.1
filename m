Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXDKJhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXDKJhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXDKJhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:37:37 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:24488 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXDKJhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:37:35 -0400
X-IronPort-AV: i="4.14,393,1170651600"; 
   d="scan'208"; a="26949329:sNHT26206481"
Subject: [PATCH 2/5] blackfin arch: fix bug data cannot be put into L1 DATA
	SRAM bank B
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 11 Apr 2007 17:40:01 +0800
Message-Id: <1176284401.29581.27.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] blackfin arch: fix bug data cannot be put into L1 DATA SRAM bank B

Don't allocate Bank B data sram in l1_data_A_sram_alloc ().
Add l1_data_sram_alloc (), which allocates data sram from either Bank A
or Bank B. Change all the code which call to l1_data_A_sram_alloc ()
to use l1_data_sram_alloc () if appropriate.
Likewise for l1_data_A_sram_free ().

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/bfin_ksyms.c  |    2 +
 arch/blackfin/kernel/module.c      |    8 ++--
 arch/blackfin/kernel/setup.c       |   31 +++++++++++------
 arch/blackfin/mm/blackfin_sram.c   |   64 +++++++++++++++++++----------------
 include/asm-blackfin/bfin-global.h |    3 +-
 5 files changed, 63 insertions(+), 45 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index bcd21ee..f64ecb6 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -115,3 +115,5 @@ EXPORT_SYMBOL(_ebss_l1);
 EXPORT_SYMBOL(_stext_l1);
 EXPORT_SYMBOL(_etext_l1);
 EXPORT_SYMBOL(_sdata_l1);
+EXPORT_SYMBOL(_ebss_b_l1);
+EXPORT_SYMBOL(_sdata_b_l1);
diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index 2e753d5..372f756 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -183,7 +183,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			((strcmp(".data", secstrings + s->sh_name)==0) &&
 			 (hdr->e_flags & FLG_DATA_IN_L1) && (s->sh_size > 0))) {
 			mod->arch.data_a_l1 = s;
-			dest = l1_data_A_sram_alloc(s->sh_size);
+			dest = l1_data_sram_alloc(s->sh_size);
 			if (dest == NULL) {
 				printk(KERN_ERR
 					"module %s: L1 data memory allocation failed\n",
@@ -198,7 +198,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			((strcmp(".bss", secstrings + s->sh_name)==0) &&
 			 (hdr->e_flags & FLG_DATA_IN_L1) && (s->sh_size > 0))) {
 			mod->arch.bss_a_l1 = s;
-			dest = l1_data_A_sram_alloc(s->sh_size);
+			dest = l1_data_sram_alloc(s->sh_size);
 			if (dest == NULL) {
 				printk(KERN_ERR
 					"module %s: L1 data memory allocation failed\n",
@@ -419,9 +419,9 @@ void module_arch_cleanup(struct module *mod)
 	if ((mod->arch.text_l1) && (mod->arch.text_l1->sh_addr))
 		l1_inst_sram_free((void*)mod->arch.text_l1->sh_addr);
 	if ((mod->arch.data_a_l1) && (mod->arch.data_a_l1->sh_addr))
-		l1_data_A_sram_free((void*)mod->arch.data_a_l1->sh_addr);
+		l1_data_sram_free((void*)mod->arch.data_a_l1->sh_addr);
 	if ((mod->arch.bss_a_l1) && (mod->arch.bss_a_l1->sh_addr))
-		l1_data_A_sram_free((void*)mod->arch.bss_a_l1->sh_addr);
+		l1_data_sram_free((void*)mod->arch.bss_a_l1->sh_addr);
 	if ((mod->arch.data_b_l1) && (mod->arch.data_b_l1->sh_addr))
 		l1_data_B_sram_free((void*)mod->arch.data_b_l1->sh_addr);
 	if ((mod->arch.bss_b_l1) && (mod->arch.bss_b_l1->sh_addr))
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 7d24229..9e0c3fa 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -90,25 +90,34 @@ void __init bf53x_cache_init(void)
 
 void bf53x_relocate_l1_mem(void)
 {
-	unsigned long l1_length;
+	unsigned long l1_code_length;
+	unsigned long l1_data_a_length;
+	unsigned long l1_data_b_length;
 
-	l1_length = _etext_l1 - _stext_l1;
-	if (l1_length > L1_CODE_LENGTH)
-		l1_length = L1_CODE_LENGTH;
+	l1_code_length = _etext_l1 - _stext_l1;
+	if (l1_code_length > L1_CODE_LENGTH)
+		l1_code_length = L1_CODE_LENGTH;
 	/* cannot complain as printk is not available as yet.
 	 * But we can continue booting and complain later!
 	 */
 
 	/* Copy _stext_l1 to _etext_l1 to L1 instruction SRAM */
-	dma_memcpy(_stext_l1, _l1_lma_start, l1_length);
+	dma_memcpy(_stext_l1, _l1_lma_start, l1_code_length);
 
-	l1_length = _ebss_l1 - _sdata_l1;
-	if (l1_length > L1_DATA_A_LENGTH)
-		l1_length = L1_DATA_A_LENGTH;
+	l1_data_a_length = _ebss_l1 - _sdata_l1;
+	if (l1_data_a_length > L1_DATA_A_LENGTH)
+		l1_data_a_length = L1_DATA_A_LENGTH;
+
+	/* Copy _sdata_l1 to _ebss_l1 to L1 data bank A SRAM */
+	dma_memcpy(_sdata_l1, _l1_lma_start + l1_code_length, l1_data_a_length);
+
+	l1_data_b_length = _ebss_b_l1 - _sdata_b_l1;
+	if (l1_data_b_length > L1_DATA_B_LENGTH)
+		l1_data_b_length = L1_DATA_B_LENGTH;
 
-	/* Copy _sdata_l1 to _ebss_l1 to L1 instruction SRAM */
-	dma_memcpy(_sdata_l1, _l1_lma_start + (_etext_l1 - _stext_l1),
-		   l1_length);
+	/* Copy _sdata_b_l1 to _ebss_b_l1 to L1 data bank B SRAM */
+	dma_memcpy(_sdata_b_l1, _l1_lma_start + l1_code_length +
+			l1_data_a_length, l1_data_b_length);
 
 }
 
diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index 16bb452..dd0c650 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -283,12 +283,6 @@ void *l1_data_A_sram_alloc(size_t size)
 	addr = _l1_sram_alloc(size, l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
 #endif
 
-#if L1_DATA_B_LENGTH != 0
-	if (!addr)
-		addr = _l1_sram_alloc(size, l1_data_B_sram,
-				   ARRAY_SIZE(l1_data_B_sram));
-#endif
-
 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1_data_sram_lock, flags);
 
@@ -307,17 +301,11 @@ int l1_data_A_sram_free(const void *addr)
 	/* add mutex operation */
 	spin_lock_irqsave(&l1_data_sram_lock, flags);
 
-#if L1_DATA_B_LENGTH != 0
-	if (L1_DATA_B_START == ((unsigned long)addr & ~0x0000FFFF))
-		ret = _l1_sram_free(addr,
-				   l1_data_B_sram, ARRAY_SIZE(l1_data_B_sram));
-	else
-#endif
 #if L1_DATA_A_LENGTH != 0
-		ret = _l1_sram_free(addr,
-				   l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
+	ret = _l1_sram_free(addr,
+			   l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
 #else
-		ret = -1;
+	ret = -1;
 #endif
 
 	/* add mutex operation */
@@ -327,20 +315,6 @@ int l1_data_A_sram_free(const void *addr)
 }
 EXPORT_SYMBOL(l1_data_A_sram_free);
 
-void *l1_data_sram_zalloc(size_t size)
-{
-	void *addr = l1_data_A_sram_alloc(size);
-	memset(addr, 0x00, size);
-	return addr;
-}
-EXPORT_SYMBOL(l1_data_sram_zalloc);
-
-int l1_data_sram_free(const void *addr)
-{
-	return l1_data_A_sram_free(addr);
-}
-EXPORT_SYMBOL(l1_data_sram_free);
-
 void *l1_data_B_sram_alloc(size_t size)
 {
 #if L1_DATA_B_LENGTH != 0
@@ -386,6 +360,38 @@ int l1_data_B_sram_free(const void *addr)
 }
 EXPORT_SYMBOL(l1_data_B_sram_free);
 
+void *l1_data_sram_alloc(size_t size)
+{
+	void *addr = l1_data_A_sram_alloc(size);
+
+	if (!addr)
+		addr = l1_data_B_sram_alloc(size);
+
+	return addr;
+}
+EXPORT_SYMBOL(l1_data_sram_alloc);
+
+void *l1_data_sram_zalloc(size_t size)
+{
+	void *addr = l1_data_sram_alloc(size);
+
+	if (addr)
+		memset(addr, 0x00, size);
+
+	return addr;
+}
+EXPORT_SYMBOL(l1_data_sram_zalloc);
+
+int l1_data_sram_free(const void *addr)
+{
+	int ret;
+	ret = l1_data_A_sram_free(addr);
+	if (ret == -1)
+		ret = l1_data_B_sram_free(addr);
+	return ret;
+}
+EXPORT_SYMBOL(l1_data_sram_free);
+
 void *l1_inst_sram_alloc(size_t size)
 {
 #if L1_DATA_A_LENGTH != 0
diff --git a/include/asm-blackfin/bfin-global.h b/include/asm-blackfin/bfin-global.h
index 5e4db3a..e37f816 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -70,6 +70,7 @@ extern void bfin_gpio_interrupt_setup(int irq, int irq_pfx, int type);
 extern void *l1_data_A_sram_alloc(size_t);
 extern void *l1_data_B_sram_alloc(size_t);
 extern void *l1_inst_sram_alloc(size_t);
+extern void *l1_data_sram_alloc(size_t);
 extern void *l1_data_sram_zalloc(size_t);
 extern int l1_data_A_sram_free(const void*);
 extern int l1_data_B_sram_free(const void*);
@@ -108,7 +109,7 @@ extern char _start;
 extern unsigned long _ramstart, _ramend, _rambase;
 extern unsigned long memory_start, memory_end, physical_mem_end;
 extern char _stext_l1[], _etext_l1[], _sdata_l1[], _edata_l1[], _sbss_l1[],
-    _ebss_l1[], _l1_lma_start[];
+    _ebss_l1[], _l1_lma_start[], _sdata_b_l1[], _ebss_b_l1[];
 
 #ifdef CONFIG_MTD_UCLINUX
 extern unsigned long memory_mtd_start, memory_mtd_end, mtd_size;
-- 
1.5.0.5

