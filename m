Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYE1Xib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYE1Xib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 19:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYE1XiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 19:38:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:25954 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYE1XiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 19:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DMT8EaLmepbN4a7j0y1ZWmqk/KWGwfuSowYvgKJiaxHIKhcBnZ3WqUh00XJ0SFFT6nTvqN0Cz2e3fX5lSRTRcHtYd7zZMtfb1JM6otuGLlX5ueReovggtl/zzlV/t8BEtGVUHKeSyu59zlqYUSrPbS9r7VHgjDJdHDvrHX4Mb40=
Subject: [PATCH] sh: module.c use kernel unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 16:38:17 -0700
Message-Id: <1212017897.20781.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the COPY_UNALIGNED_WORD helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sh/kernel/module.c |   39 +++++----------------------------------
 1 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/arch/sh/kernel/module.c b/arch/sh/kernel/module.c
index b3d0a03..5482e65 100644
--- a/arch/sh/kernel/module.c
+++ b/arch/sh/kernel/module.c
@@ -30,6 +30,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <asm/unaligned.h>
 
 void *module_alloc(unsigned long size)
 {
@@ -56,34 +57,6 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 	return 0;
 }
 
-#ifdef CONFIG_SUPERH32
-#define COPY_UNALIGNED_WORD(sw, tw, align) \
-{ \
-	void *__s = &(sw), *__t = &(tw); \
-	unsigned short *__s2 = __s, *__t2 = __t; \
-	unsigned char *__s1 = __s, *__t1 = __t; \
-	switch ((align)) \
-	{ \
-	case 0: \
-		*(unsigned long *) __t = *(unsigned long *) __s; \
-		break; \
-	case 2: \
-		*__t2++ = *__s2++; \
-		*__t2 = *__s2; \
-		break; \
-	default: \
-		*__t1++ = *__s1++; \
-		*__t1++ = *__s1++; \
-		*__t1++ = *__s1++; \
-		*__t1 = *__s1; \
-		break; \
-	} \
-}
-#else
-/* One thing SHmedia doesn't screw up! */
-#define COPY_UNALIGNED_WORD(sw, tw, align)	{ (tw) = (sw); }
-#endif
-
 int apply_relocate_add(Elf32_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
@@ -96,7 +69,6 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	Elf32_Addr relocation;
 	uint32_t *location;
 	uint32_t value;
-	int align;
 
 	pr_debug("Applying relocate section %u to %u\n", relsec,
 		 sechdrs[relsec].sh_info);
@@ -109,7 +81,6 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr
 			+ ELF32_R_SYM(rel[i].r_info);
 		relocation = sym->st_value + rel[i].r_addend;
-		align = (int)location & 3;
 
 #ifdef CONFIG_SUPERH64
 		/* For text addresses, bit2 of the st_other field indicates
@@ -122,15 +93,15 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 
 		switch (ELF32_R_TYPE(rel[i].r_info)) {
 		case R_SH_DIR32:
-			COPY_UNALIGNED_WORD (*location, value, align);
+			value = get_unaligned(location);
 			value += relocation;
-			COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		case R_SH_REL32:
 			relocation = (relocation - (Elf32_Addr) location);
-			COPY_UNALIGNED_WORD (*location, value, align);
+			value = get_unaligned(location);
 			value += relocation;
-			COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		case R_SH_IMM_LOW16:
 			*location = (*location & ~0x3fffc00) |
-- 
1.5.6.rc0.277.g804cf



