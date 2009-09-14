Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbZINUW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbZINUW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933476AbZINUWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:22:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54030 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054AbZINUI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 17/72] Blackfin: reject outdated/unused/wrong relocation types
Date: Mon, 14 Sep 2009 16:07:21 -0400
Message-Id: <1252958896-25150-18-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

All kernel modules are required to be built with -mlong-calls and thus
should not generate any of these relocations.  If they do, it means the
module has not been compiled properly, so rather than trying to handle
them (and running into random run time errors) just error out on module
load to force the module to be compiled correctly.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/module.c |   42 +++++++---------------------------------
 1 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index d5aee36..bb94078 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -243,40 +243,6 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 #endif
 		switch (ELF32_R_TYPE(rel[i].r_info)) {
 
-		case R_BFIN_PCREL24:
-		case R_BFIN_PCREL24_JUMP_L:
-			/* Add the value, subtract its postition */
-			location16 =
-			    (uint16_t *) (sechdrs[sechdrs[relsec].sh_info].
-					  sh_addr + rel[i].r_offset - 2);
-			location32 = (uint32_t *) location16;
-			value -= (uint32_t) location32;
-			value >>= 1;
-			if ((value & 0xFF000000) != 0 &&
-			    (value & 0xFF000000) != 0xFF000000) {
-				printk(KERN_ERR "module %s: relocation overflow\n",
-				       mod->name);
-				return -ENOEXEC;
-			}
-			pr_debug("value is %x, before %x-%x after %x-%x\n", value,
-			       *location16, *(location16 + 1),
-			       (*location16 & 0xff00) | (value >> 16 & 0x00ff),
-			       value & 0xffff);
-			*location16 =
-			    (*location16 & 0xff00) | (value >> 16 & 0x00ff);
-			*(location16 + 1) = value & 0xffff;
-			break;
-		case R_BFIN_PCREL12_JUMP:
-		case R_BFIN_PCREL12_JUMP_S:
-			value -= (uint32_t) location32;
-			value >>= 1;
-			*location16 = (value & 0xfff);
-			break;
-		case R_BFIN_PCREL10:
-			value -= (uint32_t) location32;
-			value >>= 1;
-			*location16 = (value & 0x3ff);
-			break;
 		case R_BFIN_LUIMM16:
 			pr_debug("before %x after %x\n", *location16,
 				       (value & 0xffff));
@@ -302,6 +268,14 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 			pr_debug("before %x after %x\n", *location32, value);
 			*location32 = value;
 			break;
+		case R_BFIN_PCREL24:
+		case R_BFIN_PCREL24_JUMP_L:
+		case R_BFIN_PCREL12_JUMP:
+		case R_BFIN_PCREL12_JUMP_S:
+		case R_BFIN_PCREL10:
+			printk(KERN_ERR "module %s: Unsupported relocation: %u (no -mlong-calls?)\n"
+				mod->name, ELF32_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
 		default:
 			printk(KERN_ERR "module %s: Unknown relocation: %u\n",
 			       mod->name, ELF32_R_TYPE(rel[i].r_info));
-- 
1.6.4.2

