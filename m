Return-Path: <linux-kernel-owner+w=401wt.eu-S933535AbZINUVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbZINUVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933553AbZINUVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:21:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54040 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933500AbZINUIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 21/72] Blackfin: fix module reloc handling for all memory regions
Date: Mon, 14 Sep 2009 16:07:25 -0400
Message-Id: <1252958896-25150-22-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current module relocation code has spotty handling wrt different
memory regions (like L1 instruction).  Rather than try to fix each
little spot, use the new common memory functions to greatly simplify
everything and make sure it is always correct.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/module.c |   62 ++++++++++++++++++++++------------------
 1 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index 2ad805e..67fc7a5 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -37,6 +37,7 @@
 #include <linux/kernel.h>
 #include <asm/dma.h>
 #include <asm/cacheflush.h>
+#include <asm/uaccess.h>
 
 void *module_alloc(unsigned long size)
 {
@@ -199,26 +200,23 @@ apply_relocate(Elf_Shdr * sechdrs, const char *strtab,
 /*            gas does not generate it.                                  */
 /*************************************************************************/
 int
-apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
+apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 		   unsigned int symindex, unsigned int relsec,
 		   struct module *mod)
 {
 	unsigned int i;
-	unsigned short tmp;
 	Elf32_Rela *rel = (void *)sechdrs[relsec].sh_addr;
 	Elf32_Sym *sym;
-	uint32_t *location32;
-	uint16_t *location16;
-	uint32_t value;
+	unsigned long location, value, size;
 
 	pr_debug("applying relocate section %u to %u\n", mod->name,
 		relsec, sechdrs[relsec].sh_info);
+
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
 		/* This is where to make the change */
-		location16 =
-		    (uint16_t *) (sechdrs[sechdrs[relsec].sh_info].sh_addr +
-				  rel[i].r_offset);
-		location32 = (uint32_t *) location16;
+		location = sechdrs[sechdrs[relsec].sh_info].sh_addr +
+		           rel[i].r_offset;
+
 		/* This is the symbol it is referring to. Note that all
 		   undefined symbols have been resolved. */
 		sym = (Elf32_Sym *) sechdrs[symindex].sh_addr
@@ -227,39 +225,28 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 		value += rel[i].r_addend;
 
 #ifdef CONFIG_SMP
-		if ((unsigned long)location16 >= COREB_L1_DATA_A_START) {
+		if (location >= COREB_L1_DATA_A_START) {
 			pr_err("cannot relocate in L1: %u (SMP kernel)",
 				mod->name, ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
 #endif
 
-		pr_debug("location is %lx, value is %x type is %d\n",
-			mod->name, (unsigned long)location32, value,
-			ELF32_R_TYPE(rel[i].r_info));
+		pr_debug("location is %lx, value is %lx type is %d\n",
+			mod->name, location, value, ELF32_R_TYPE(rel[i].r_info));
 
 		switch (ELF32_R_TYPE(rel[i].r_info)) {
 
-		case R_BFIN_LUIMM16:
-			tmp = (value & 0xffff);
-			if ((unsigned long)location16 >= L1_CODE_START) {
-				dma_memcpy(location16, &tmp, 2);
-			} else
-				*location16 = tmp;
-			break;
 		case R_BFIN_HUIMM16:
-			tmp = ((value >> 16) & 0xffff);
-			if ((unsigned long)location16 >= L1_CODE_START) {
-				dma_memcpy(location16, &tmp, 2);
-			} else
-				*location16 = tmp;
-			break;
+			value >>= 16;
+		case R_BFIN_LUIMM16:
 		case R_BFIN_RIMM16:
-			*location16 = (value & 0xffff);
+			size = 2;
 			break;
 		case R_BFIN_BYTE4_DATA:
-			*location32 = value;
+			size = 4;
 			break;
+
 		case R_BFIN_PCREL24:
 		case R_BFIN_PCREL24_JUMP_L:
 		case R_BFIN_PCREL12_JUMP:
@@ -268,12 +255,31 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 			pr_err("unsupported relocation: %u (no -mlong-calls?)\n",
 				mod->name, ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
+
 		default:
 			pr_err("unknown relocation: %u\n", mod->name,
 				ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
+
+		switch (bfin_mem_access_type(location, size)) {
+		case BFIN_MEM_ACCESS_CORE:
+		case BFIN_MEM_ACCESS_CORE_ONLY:
+			memcpy((void *)location, &value, size);
+			break;
+		case BFIN_MEM_ACCESS_DMA:
+			dma_memcpy((void *)location, &value, size);
+			break;
+		case BFIN_MEM_ACCESS_ITEST:
+			isram_memcpy((void *)location, &value, size);
+			break;
+		default:
+			pr_err("invalid relocation for %#lx\n",
+				mod->name, location);
+			return -ENOEXEC;
+		}
 	}
+
 	return 0;
 }
 
-- 
1.6.4.2

