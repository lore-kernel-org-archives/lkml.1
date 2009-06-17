Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbZFQVvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbZFQVvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZFQVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:51:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55499 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbZFQVvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:51:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Add support for new ELF relocs in kernel modules
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       Mark Salter <msalter@redhat.com>, David Howells <dhowells@redhat.com>
Date: Wed, 17 Jun 2009 22:51:11 +0100
Message-ID: <20090617215111.24987.17823.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

Add support for new relocs which may show up in MN10300 kernel modules due to
linker relaxation.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/elf.h |    2 ++
 arch/mn10300/kernel/module.c   |   39 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)


diff --git a/arch/mn10300/include/asm/elf.h b/arch/mn10300/include/asm/elf.h
index 4910546..75a70aa 100644
--- a/arch/mn10300/include/asm/elf.h
+++ b/arch/mn10300/include/asm/elf.h
@@ -28,6 +28,8 @@
 #define R_MN10300_PCREL8	6	/* PC-relative 8-bit signed.  */
 #define R_MN10300_24		9	/* Direct 24 bit.  */
 #define R_MN10300_RELATIVE	23	/* Adjust by program base.  */
+#define R_MN10300_SYM_DIFF	33	/* Adjustment when relaxing. */
+#define R_MN10300_ALIGN 	34	/* Alignment requirement. */
 
 /*
  * ELF register definitions..
diff --git a/arch/mn10300/kernel/module.c b/arch/mn10300/kernel/module.c
index 4fa0e36..6aea7fd 100644
--- a/arch/mn10300/kernel/module.c
+++ b/arch/mn10300/kernel/module.c
@@ -1,6 +1,6 @@
 /* MN10300 Kernel module helper routines
  *
- * Copyright (C) 2007, 2008 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2007, 2008, 2009 Red Hat, Inc. All Rights Reserved.
  * Written by Mark Salter (msalter@redhat.com)
  * - Derived from arch/i386/kernel/module.c
  *
@@ -103,10 +103,10 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 		       unsigned int relsec,
 		       struct module *me)
 {
-	unsigned int i;
+	unsigned int i, sym_diff_seen = 0;
 	Elf32_Rela *rel = (void *)sechdrs[relsec].sh_addr;
 	Elf32_Sym *sym;
-	Elf32_Addr relocation;
+	Elf32_Addr relocation, sym_diff_val = 0;
 	uint8_t *location;
 	uint32_t value;
 
@@ -126,6 +126,22 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 		/* this is the adjustment to be made */
 		relocation = sym->st_value + rel[i].r_addend;
 
+		if (sym_diff_seen) {
+			switch (ELF32_R_TYPE(rel[i].r_info)) {
+			case R_MN10300_32:
+			case R_MN10300_24:
+			case R_MN10300_16:
+			case R_MN10300_8:
+				relocation -= sym_diff_val;
+				sym_diff_seen = 0;
+				break;
+			default:
+				printk(KERN_ERR "module %s: Unexpected SYM_DIFF relocation: %u\n",
+				       me->name, ELF32_R_TYPE(rel[i].r_info));
+				return -ENOEXEC;
+			}
+		}
+
 		switch (ELF32_R_TYPE(rel[i].r_info)) {
 			/* for the first four relocation types, we simply
 			 * store the adjustment at the location given */
@@ -157,12 +173,29 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 			*location = relocation - (uint32_t) location;
 			break;
 
+		case R_MN10300_SYM_DIFF:
+			/* This is used to adjust the next reloc as required
+			 * by relaxation. */
+			sym_diff_seen = 1;
+			sym_diff_val = sym->st_value;
+			break;
+
+		case R_MN10300_ALIGN:
+			/* Just ignore the ALIGN relocs.
+			 * Only interesting if kernel performed relaxation. */
+			continue;
+
 		default:
 			printk(KERN_ERR "module %s: Unknown relocation: %u\n",
 			       me->name, ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
 	}
+	if (sym_diff_seen) {
+		printk(KERN_ERR "module %s: Nothing follows SYM_DIFF relocation: %u\n",
+				       me->name, ELF32_R_TYPE(rel[i].r_info));
+		return -ENOEXEC;
+	}
 	return 0;
 }
 

