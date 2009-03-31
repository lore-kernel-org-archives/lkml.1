Return-Path: <linux-kernel-owner+w=401wt.eu-S1764396AbZCaXaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764396AbZCaXaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763451AbZCaXUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:54 -0400
Received: from sous-sol.org ([216.99.217.87]:33206 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756878AbZCaXUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:52 -0400
Message-Id: <20090331231640.914632087@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Daniel Silverstone <dsilvers@simtec.co.uk>,
       Simtec Linux Team <linux@simtec.co.uk>,
       Vincent Sanders <vince@simtec.co.uk>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 29/45] ARM: 5428/1: Module relocation update for R_ARM_V4BX
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=arm-5428-1-module-relocation-update-for-r_arm_v4bx.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Daniel Silverstone <dsilvers@simtec.co.uk>

upstream commit: 4731f8b66dd34ebf0e67ca6ba9162b0e509bec06

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/arm/include/asm/elf.h |    1 +
 arch/arm/kernel/module.c   |    9 +++++++++
 2 files changed, 10 insertions(+)

--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -50,6 +50,7 @@ typedef struct user_fp elf_fpregset_t;
 #define R_ARM_ABS32	2
 #define R_ARM_CALL	28
 #define R_ARM_JUMP24	29
+#define R_ARM_V4BX	40
 
 /*
  * These are used to set parameters in the core dumps.
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -132,6 +132,15 @@ apply_relocate(Elf32_Shdr *sechdrs, cons
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

