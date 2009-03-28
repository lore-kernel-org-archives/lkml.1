Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZC2Iwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZC2Iwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZC2IwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:52:02 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40090 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbZC2Iv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:51:57 -0400
References: <git-1238272225-65c24491b4fef017c64e39ec64384fde5e05e0a0@dyn-67.arm.linux.org.uk>
Message-ID: <git-1238272225-4731f8b66dd34ebf0e67ca6ba9162b0e509bec06@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: stable@kernel.org,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Mar 2009 20:30:26 +0000
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: [PATCH] [ARM] 5428/1: Module relocation update for R_ARM_V4BX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Silverstone <dsilvers@simtec.co.uk>

It would seem when building kernel modules with modern binutils
(required by modern GCC) for ARM v4T targets (specifically observed
with the Samsung 24xx SoC which is an 920T) R_ARM_V4BX relocations
are emitted for function epilogues.

This manifests at module load time with an "unknown relocation: 40"
error message.

The following patch adds the R_ARM_V4BX relocation to the ARM kernel
module loader. The relocation operation is taken from that within the
binutils bfd library.

Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/include/asm/elf.h |    1 +
 arch/arm/kernel/module.c   |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index a58378c..ce3b36e 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -50,6 +50,7 @@ typedef struct user_fp elf_fpregset_t;
 #define R_ARM_ABS32	2
 #define R_ARM_CALL	28
 #define R_ARM_JUMP24	29
+#define R_ARM_V4BX	40
 
 /*
  * These are used to set parameters in the core dumps.
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index dab48f2..9f509fd 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -132,6 +132,15 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			*(u32 *)loc |= offset & 0x00ffffff;
 			break;
 
+	       case R_ARM_V4BX:
+		       /* Preserve Rm and the condition code. Alter
+			* other bits to re-code instruction as
+			* MOV PC,Rm.
+			*/
+		       *(u32 *)loc &= 0xf000000f;
+		       *(u32 *)loc |= 0x01a0f000;
+		       break;
+
 		default:
 			printk(KERN_ERR "%s: unknown relocation: %u\n",
 			       module->name, ELF32_R_TYPE(rel->r_info));
