Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYE1Xa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYE1Xa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 19:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYE1Xat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 19:30:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:15349 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYE1Xas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 19:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=haXorgEiIaFZZGBUnDkeQ53AFHHnzTMDFGzB7nSGldGLJX1JjupRLzPzCsexCocjtGUtQQWsK0YizhSWvcESEnP4UNdDEacuDiS9vYRX8aiNKgJX6EVsr725EjUOudQtXtwsFrCMgcx22EkDTwNInMZHb+Ymo3xhmVnW5eFAM5s=
Subject: [PATCH] m32r: module.c use kernel-provided unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 May 2008 16:30:47 -0700
Message-Id: <1212017447.20781.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the hand-rolled COPY_UNALIGNED_WORD/HWORD

This also possibly fixes a bug in the ﻿R_M32R_16_RELA case as it was reading
2 bytes from hlocation, applying the relocation, but writing back 4 bytes
(perhaps it meant to use COPY_UNALIGNED_HWORD rather than _WORD) two bytes of
which were not calculated.  This patch writes back only two bytes as hvalue
is a short.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/m32r/kernel/module.c |  150 ++++++++++++++++-----------------------------
 1 files changed, 53 insertions(+), 97 deletions(-)

diff --git a/arch/m32r/kernel/module.c b/arch/m32r/kernel/module.c
index 8d42057..375ddf0 100644
--- a/arch/m32r/kernel/module.c
+++ b/arch/m32r/kernel/module.c
@@ -21,6 +21,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <asm/unaligned.h>
 
 #if 0
 #define DEBUGP printk
@@ -57,46 +58,6 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 	return 0;
 }
 
-#define COPY_UNALIGNED_WORD(sw, tw, align) \
-{ \
-	void *__s = &(sw), *__t = &(tw); \
-	unsigned short *__s2 = __s, *__t2 =__t; \
-	unsigned char *__s1 = __s, *__t1 =__t; \
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
-
-#define COPY_UNALIGNED_HWORD(sw, tw, align) \
-  { \
-    void *__s = &(sw), *__t = &(tw); \
-    unsigned short *__s2 = __s, *__t2 =__t; \
-    unsigned char *__s1 = __s, *__t1 =__t; \
-    switch ((align)) \
-    { \
-    case 0: \
-      *__t2 = *__s2; \
-      break; \
-    default: \
-      *__t1++ = *__s1++; \
-      *__t1 = *__s1; \
-      break; \
-    } \
-  }
-
 int apply_relocate_add(Elf32_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
@@ -112,7 +73,6 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	unsigned short *hlocation;
 	unsigned short hvalue;
 	int svalue;
-	int align;
 
 	DEBUGP("Applying relocate section %u to %u\n", relsec,
 	       sechdrs[relsec].sh_info);
@@ -125,102 +85,98 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr
 			+ ELF32_R_SYM(rel[i].r_info);
 		relocation = sym->st_value + rel[i].r_addend;
-		align = (int)location & 3;
 
 		switch (ELF32_R_TYPE(rel[i].r_info)) {
 		case R_M32R_32_RELA:
-	    		COPY_UNALIGNED_WORD (*location, value, align);
+			value = get_unaligned(location);
 			value += relocation;
-	    		COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		case R_M32R_HI16_ULO_RELA:
-	    		COPY_UNALIGNED_WORD (*location, value, align);
-                        relocation = (relocation >>16) & 0xffff;
+			value = get_unaligned(location);
+			relocation = (relocation >> 16) & 0xffff;
 			/* RELA must has 0 at relocation field. */
 			value += relocation;
-	    		COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		case R_M32R_HI16_SLO_RELA:
-	    		COPY_UNALIGNED_WORD (*location, value, align);
-			if (relocation & 0x8000) relocation += 0x10000;
-                        relocation = (relocation >>16) & 0xffff;
+			value = get_unaligned(location);
+			if (relocation & 0x8000)
+				relocation += 0x10000;
+			relocation = (relocation >> 16) & 0xffff;
 			/* RELA must has 0 at relocation field. */
 			value += relocation;
-	    		COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		case R_M32R_16_RELA:
 			hlocation = (unsigned short *)location;
-                        relocation = relocation & 0xffff;
+			relocation = relocation & 0xffff;
 			/* RELA must has 0 at relocation field. */
 			hvalue = relocation;
-	    		COPY_UNALIGNED_WORD (hvalue, *hlocation, align);
+			put_unaligned(hvalue, hlocation);
 			break;
 		case R_M32R_SDA16_RELA:
 		case R_M32R_LO16_RELA:
-	    		COPY_UNALIGNED_WORD (*location, value, align);
-                        relocation = relocation & 0xffff;
+			value = get_unaligned(location);
+			relocation = relocation & 0xffff;
 			/* RELA must has 0 at relocation field. */
 			value += relocation;
-	    		COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		case R_M32R_24_RELA:
-	    		COPY_UNALIGNED_WORD (*location, value, align);
-                        relocation = relocation & 0xffffff;
+			value = get_unaligned(location);
+			relocation = relocation & 0xffffff;
 			/* RELA must has 0 at relocation field. */
 			value += relocation;
-	    		COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		case R_M32R_18_PCREL_RELA:
-	  		relocation = (relocation - (Elf32_Addr) location);
-			if (relocation < -0x20000 || 0x1fffc < relocation)
-				{
-					printk(KERN_ERR "module %s: relocation overflow: %u\n",
-					me->name, relocation);
-					return -ENOEXEC;
-				}
-	    		COPY_UNALIGNED_WORD (*location, value, align);
-			if (value & 0xffff)
-				{
-					/* RELA must has 0 at relocation field. */
-					printk(KERN_ERR "module %s: illegal relocation field: %u\n",
-					me->name, value);
-					return -ENOEXEC;
-				}
-                        relocation = (relocation >> 2) & 0xffff;
+			relocation = (relocation - (Elf32_Addr) location);
+			if (relocation < -0x20000 || 0x1fffc < relocation) {
+				printk(KERN_ERR "module %s: relocation overflow: %u\n",
+				me->name, relocation);
+				return -ENOEXEC;
+			}
+			value = get_unaligned(location);
+			if (value & 0xffff) {
+				/* RELA must has 0 at relocation field. */
+				printk(KERN_ERR "module %s: illegal relocation field: %u\n",
+				me->name, value);
+				return -ENOEXEC;
+			}
+			relocation = (relocation >> 2) & 0xffff;
 			value += relocation;
-	    		COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		case R_M32R_10_PCREL_RELA:
 			hlocation = (unsigned short *)location;
-	  		relocation = (relocation - (Elf32_Addr) location);
-	    		COPY_UNALIGNED_HWORD (*hlocation, hvalue, align);
+			relocation = (relocation - (Elf32_Addr) location);
+			hvalue = get_unaligned(hlocation);
 			svalue = (int)hvalue;
 			svalue = (signed char)svalue << 2;
 			relocation += svalue;
-                        relocation = (relocation >> 2) & 0xff;
+			relocation = (relocation >> 2) & 0xff;
 			hvalue = hvalue & 0xff00;
 			hvalue += relocation;
-	    		COPY_UNALIGNED_HWORD (hvalue, *hlocation, align);
+			put_unaligned(hvalue, hlocation);
 			break;
 		case R_M32R_26_PCREL_RELA:
-	  		relocation = (relocation - (Elf32_Addr) location);
-			if (relocation < -0x2000000 || 0x1fffffc < relocation)
-				{
-					printk(KERN_ERR "module %s: relocation overflow: %u\n",
-					me->name, relocation);
-					return -ENOEXEC;
-				}
-	    		COPY_UNALIGNED_WORD (*location, value, align);
-			if (value & 0xffffff)
-				{
-					/* RELA must has 0 at relocation field. */
-					printk(KERN_ERR "module %s: illegal relocation field: %u\n",
-					me->name, value);
-					return -ENOEXEC;
-				}
-                        relocation = (relocation >> 2) & 0xffffff;
+			relocation = (relocation - (Elf32_Addr) location);
+			if (relocation < -0x2000000 || 0x1fffffc < relocation) {
+				printk(KERN_ERR "module %s: relocation overflow: %u\n",
+				me->name, relocation);
+				return -ENOEXEC;
+			}
+			value = get_unaligned(location);
+			if (value & 0xffffff) {
+				/* RELA must has 0 at relocation field. */
+				printk(KERN_ERR "module %s: illegal relocation field: %u\n",
+				me->name, value);
+				return -ENOEXEC;
+			}
+			relocation = (relocation >> 2) & 0xffffff;
 			value += relocation;
-	    		COPY_UNALIGNED_WORD (value, *location, align);
+			put_unaligned(value, location);
 			break;
 		default:
 			printk(KERN_ERR "module %s: Unknown relocation: %u\n",
-- 
1.5.6.rc0.277.g804cf



