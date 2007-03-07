Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbXCGNV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbXCGNV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXCGNV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:21:57 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1157 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbXCGNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:21:56 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Cc: Andrew Morton <akpm@osdl.org>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] i386 alternative_io implementation
References: <200703071254.03014.marc.dietrich@ap.physik.uni-giessen.de>
InReply-To: <200703071254.03014.marc.dietrich@ap.physik.uni-giessen.de>
Message-ID: <8aa4496d067c1f95c7bacb0849cacf50@pinky>
Date: Wed, 07 Mar 2007 13:21:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add an i386 implementation of alternative_io modelled on
the x86_64 version.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---

	Ok, this seems to fix things up here.  I have only boot
	tested this on an SMP so I'd not call that 'heavily tested'
	in any real sense but it might get you going until akpm
	has a chance to comment.

	-apw

---
diff --git a/include/asm-i386/alternative.h b/include/asm-i386/alternative.h
index 4a77e93..8b6d9ed 100644
--- a/include/asm-i386/alternative.h
+++ b/include/asm-i386/alternative.h
@@ -100,6 +100,23 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
 		      ".previous" :: "i" (feature), ##input)
 
+#define alternative_io(oldinstr, newinstr, feature, output, input...)	\
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
+		      ".section .altinstructions,\"a\"\n"		\
+		      "  .align 4\n"					\
+		      "  .long 661b\n"            /* label */		\
+		      "  .long 663f\n"		  /* new instruction */ \
+		      "  .long 0x00\n"					\
+		      "  .byte %c[feat]\n"        /* feature bit */	\
+		      "  .byte 0x00\n"					\
+		      "  .byte 662b-661b\n"       /* sourcelen */	\
+		      "  .byte 664f-663f\n"       /* replacementlen */ 	\
+		      "  .byte 0x00\n"					\
+		      ".previous\n"					\
+		      ".section .altinstr_replacement,\"ax\"\n"		\
+		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
+		      ".previous" : output : [feat] "i" (feature), ##input)
+
 /* Like alternative_io, but supports 2 possible alternatives */
 #define alternative_io_two(oldinstr, newinstr, feat, newinstr2, feat2,\
 		output, input...) \
diff --git a/include/asm-i386/tsc.h b/include/asm-i386/tsc.h
index 3469766..a031b56 100644
--- a/include/asm-i386/tsc.h
+++ b/include/asm-i386/tsc.h
@@ -6,6 +6,7 @@
 #ifndef _ASM_i386_TSC_H
 #define _ASM_i386_TSC_H
 
+#include <asm/alternative.h>
 #include <asm/processor.h>
 
 /*
