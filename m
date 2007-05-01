Return-Path: <linux-kernel-owner+w=401wt.eu-S1946508AbXEAEFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946508AbXEAEFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXEAEBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:06 -0400
Received: from mx1.suse.de ([195.135.220.2]:60929 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946476AbXEAD6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:13 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [14/30] i386: Implement alternative_io for i386
Message-Id: <20070501035812.0FF5613CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ported from x86-64.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/alternative.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux/include/asm-i386/alternative.h
===================================================================
--- linux.orig/include/asm-i386/alternative.h
+++ linux/include/asm-i386/alternative.h
@@ -82,6 +82,21 @@ static inline void alternatives_smp_swit
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
 		      ".previous" :: "i" (feature), ##input)
 
+/* Like alternative_input, but with a single output argument */
+#define alternative_io(oldinstr, newinstr, feature, output, input...) \
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
+		      ".section .altinstructions,\"a\"\n"		\
+		      "  .align 4\n"					\
+		      "  .long 661b\n"            /* label */		\
+		      "  .long 663f\n"		  /* new instruction */	\
+		      "  .byte %c[feat]\n"        /* feature bit */	\
+		      "  .byte 662b-661b\n"       /* sourcelen */	\
+		      "  .byte 664f-663f\n"       /* replacementlen */	\
+		      ".previous\n"					\
+		      ".section .altinstr_replacement,\"ax\"\n"		\
+		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
+		      ".previous" : output : [feat] "i" (feature), ##input)
+
 /*
  * Alternative inline assembly for SMP.
  *
