Return-Path: <linux-kernel-owner+w=401wt.eu-S1761892AbZBYPTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892AbZBYPTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760334AbZBYPJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:32 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56306 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754AbZBYPIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:44 -0500
Message-Id: <20090225150839.018436534@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:07:05 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 43/46] module function call optimization
Content-Disposition: inline; filename=142-module-branches.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Avoid the detour over the PLT if the branch target of a function call
in a module is in the range of the bras (16-bit) or brasl (32-bit)
instruction. The PLT is still generated but it is unused.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/module.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

Index: quilt-2.6/arch/s390/kernel/module.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/module.c
+++ quilt-2.6/arch/s390/kernel/module.c
@@ -310,15 +310,20 @@ apply_rela(Elf_Rela *rela, Elf_Addr base
 			info->plt_initialized = 1;
 		}
 		if (r_type == R_390_PLTOFF16 ||
-		    r_type == R_390_PLTOFF32
-		    || r_type == R_390_PLTOFF64
-			)
+		    r_type == R_390_PLTOFF32 ||
+		    r_type == R_390_PLTOFF64)
 			val = me->arch.plt_offset - me->arch.got_offset +
 				info->plt_offset + rela->r_addend;
-		else
-			val =  (Elf_Addr) me->module_core +
-				me->arch.plt_offset + info->plt_offset + 
-				rela->r_addend - loc;
+		else {
+			if (!((r_type == R_390_PLT16DBL &&
+			       val - loc + 0xffffUL < 0x1ffffeUL) ||
+			      (r_type == R_390_PLT32DBL &&
+			       val - loc + 0xffffffffULL < 0x1fffffffeULL)))
+				val = (Elf_Addr) me->module_core +
+					me->arch.plt_offset +
+					info->plt_offset;
+			val += rela->r_addend - loc;
+		}
 		if (r_type == R_390_PLT16DBL)
 			*(unsigned short *) loc = val >> 1;
 		else if (r_type == R_390_PLTOFF16)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

