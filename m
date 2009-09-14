Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbZINUSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbZINUSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbZINUIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54035 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933498AbZINUI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:29 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 20/72] Blackfin: cleanup module section checking
Date: Mon, 14 Sep 2009 16:07:24 -0400
Message-Id: <1252958896-25150-21-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current module section handling code has a lot of verbose statements
copied and pasted throughout which makes it pretty hard to digest at a
glance.  By unifying all of these up front, it is a lot easier to quickly
get an idea of what is actually going on.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/module.c |  111 ++++++++++++++++++++++-------------------
 1 files changed, 60 insertions(+), 51 deletions(-)

diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index 50d7fbf..2ad805e 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -53,7 +53,7 @@ void module_free(struct module *mod, void *module_region)
 
 /* Transfer the section to the L1 memory */
 int
-module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
+module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			  char *secstrings, struct module *mod)
 {
 	/*
@@ -64,12 +64,18 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 	 * NOTE: this breaks the semantic of mod->arch structure.
 	 */
 	Elf_Shdr *s, *sechdrs_end = sechdrs + hdr->e_shnum;
-	void *dest = NULL;
+	void *dest;
 
 	for (s = sechdrs; s < sechdrs_end; ++s) {
-		if ((strcmp(".l1.text", secstrings + s->sh_name) == 0) ||
-		    ((strcmp(".text", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & EF_BFIN_CODE_IN_L1) && (s->sh_size > 0))) {
+		const char *shname = secstrings + s->sh_name;
+
+		if (s->sh_size == 0)
+			continue;
+
+		if (!strcmp(".l1.text", shname) ||
+		    (!strcmp(".text", shname) &&
+		     (hdr->e_flags & EF_BFIN_CODE_IN_L1))) {
+
 			dest = l1_inst_sram_alloc(s->sh_size);
 			mod->arch.text_l1 = dest;
 			if (dest == NULL) {
@@ -78,12 +84,11 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 				return -1;
 			}
 			dma_memcpy(dest, (void *)s->sh_addr, s->sh_size);
-			s->sh_flags &= ~SHF_ALLOC;
-			s->sh_addr = (unsigned long)dest;
-		}
-		if ((strcmp(".l1.data", secstrings + s->sh_name) == 0) ||
-		    ((strcmp(".data", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & EF_BFIN_DATA_IN_L1) && (s->sh_size > 0))) {
+
+		} else if (!strcmp(".l1.data", shname) ||
+		           (!strcmp(".data", shname) &&
+		            (hdr->e_flags & EF_BFIN_DATA_IN_L1))) {
+
 			dest = l1_data_sram_alloc(s->sh_size);
 			mod->arch.data_a_l1 = dest;
 			if (dest == NULL) {
@@ -92,12 +97,11 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
-			s->sh_flags &= ~SHF_ALLOC;
-			s->sh_addr = (unsigned long)dest;
-		}
-		if (strcmp(".l1.bss", secstrings + s->sh_name) == 0 ||
-		    ((strcmp(".bss", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & EF_BFIN_DATA_IN_L1) && (s->sh_size > 0))) {
+
+		} else if (!strcmp(".l1.bss", shname) ||
+		           (!strcmp(".bss", shname) &&
+		            (hdr->e_flags & EF_BFIN_DATA_IN_L1))) {
+
 			dest = l1_data_sram_zalloc(s->sh_size);
 			mod->arch.bss_a_l1 = dest;
 			if (dest == NULL) {
@@ -105,10 +109,9 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 					mod->name);
 				return -1;
 			}
-			s->sh_flags &= ~SHF_ALLOC;
-			s->sh_addr = (unsigned long)dest;
-		}
-		if (strcmp(".l1.data.B", secstrings + s->sh_name) == 0) {
+
+		} else if (!strcmp(".l1.data.B", shname)) {
+
 			dest = l1_data_B_sram_alloc(s->sh_size);
 			mod->arch.data_b_l1 = dest;
 			if (dest == NULL) {
@@ -117,10 +120,9 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
-			s->sh_flags &= ~SHF_ALLOC;
-			s->sh_addr = (unsigned long)dest;
-		}
-		if (strcmp(".l1.bss.B", secstrings + s->sh_name) == 0) {
+
+		} else if (!strcmp(".l1.bss.B", shname)) {
+
 			dest = l1_data_B_sram_alloc(s->sh_size);
 			mod->arch.bss_b_l1 = dest;
 			if (dest == NULL) {
@@ -129,12 +131,11 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 				return -1;
 			}
 			memset(dest, 0, s->sh_size);
-			s->sh_flags &= ~SHF_ALLOC;
-			s->sh_addr = (unsigned long)dest;
-		}
-		if ((strcmp(".l2.text", secstrings + s->sh_name) == 0) ||
-		    ((strcmp(".text", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & EF_BFIN_CODE_IN_L2) && (s->sh_size > 0))) {
+
+		} else if (!strcmp(".l2.text", shname) ||
+		           (!strcmp(".text", shname) &&
+		            (hdr->e_flags & EF_BFIN_CODE_IN_L2))) {
+
 			dest = l2_sram_alloc(s->sh_size);
 			mod->arch.text_l2 = dest;
 			if (dest == NULL) {
@@ -143,12 +144,11 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
-			s->sh_flags &= ~SHF_ALLOC;
-			s->sh_addr = (unsigned long)dest;
-		}
-		if ((strcmp(".l2.data", secstrings + s->sh_name) == 0) ||
-		    ((strcmp(".data", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & EF_BFIN_DATA_IN_L2) && (s->sh_size > 0))) {
+
+		} else if (!strcmp(".l2.data", shname) ||
+		           (!strcmp(".data", shname) &&
+		            (hdr->e_flags & EF_BFIN_DATA_IN_L2))) {
+
 			dest = l2_sram_alloc(s->sh_size);
 			mod->arch.data_l2 = dest;
 			if (dest == NULL) {
@@ -157,12 +157,11 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
-			s->sh_flags &= ~SHF_ALLOC;
-			s->sh_addr = (unsigned long)dest;
-		}
-		if (strcmp(".l2.bss", secstrings + s->sh_name) == 0 ||
-		    ((strcmp(".bss", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & EF_BFIN_DATA_IN_L2) && (s->sh_size > 0))) {
+
+		} else if (!strcmp(".l2.bss", shname) ||
+		           (!strcmp(".bss", shname) &&
+		            (hdr->e_flags & EF_BFIN_DATA_IN_L2))) {
+
 			dest = l2_sram_zalloc(s->sh_size);
 			mod->arch.bss_l2 = dest;
 			if (dest == NULL) {
@@ -170,10 +169,14 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 					mod->name);
 				return -1;
 			}
-			s->sh_flags &= ~SHF_ALLOC;
-			s->sh_addr = (unsigned long)dest;
-		}
+
+		} else
+			continue;
+
+		s->sh_flags &= ~SHF_ALLOC;
+		s->sh_addr = (unsigned long)dest;
 	}
+
 	return 0;
 }
 
@@ -295,22 +298,28 @@ module_finalize(const Elf_Ehdr * hdr,
 	for (i = 1; i < hdr->e_shnum; i++) {
 		const char *strtab = (char *)sechdrs[strindex].sh_addr;
 		unsigned int info = sechdrs[i].sh_info;
+		const char *shname = secstrings + sechdrs[i].sh_name;
 
 		/* Not a valid relocation section? */
 		if (info >= hdr->e_shnum)
 			continue;
 
-		if ((sechdrs[i].sh_type == SHT_RELA) &&
-		    ((strcmp(".rela.l2.text", secstrings + sechdrs[i].sh_name) == 0) ||
-		    (strcmp(".rela.l1.text", secstrings + sechdrs[i].sh_name) == 0) ||
-		    ((strcmp(".rela.text", secstrings + sechdrs[i].sh_name) == 0) &&
-			(hdr->e_flags & (EF_BFIN_CODE_IN_L1|EF_BFIN_CODE_IN_L2))))) {
+		/* Only support RELA relocation types */
+		if (sechdrs[i].sh_type != SHT_RELA)
+			continue;
+
+		if (!strcmp(".rela.l2.text", shname) ||
+		    !strcmp(".rela.l1.text", shname) ||
+		    (!strcmp(".rela.text", shname) &&
+			 (hdr->e_flags & (EF_BFIN_CODE_IN_L1 | EF_BFIN_CODE_IN_L2)))) {
+
 			err = apply_relocate_add((Elf_Shdr *) sechdrs, strtab,
 					   symindex, i, mod);
 			if (err < 0)
 				return -ENOEXEC;
 		}
 	}
+
 	return 0;
 }
 
-- 
1.6.4.2

