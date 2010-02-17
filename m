Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab0BQLm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:42:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:44890 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0BQLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:42:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Jpes8PQlQyVpdEmCRexyuFrapvMQA7vs5WkLknKYA5m2o4X3h8joqWyImeTGlP7IjB
         K6OgLYABdci/JJ2mOnF1blzL8mXaD+OUb04OzgYvG9nPTAn5uKio8APn3f2r0QXvN/ci
         LVENfUxHCJNZz0yMkmAYpEuB4MLgZuQYeekT4=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 01/10] x86: add support for multiple choice alternatives
Date: Wed, 17 Feb 2010 12:42:33 +0100
Message-Id: <1266406962-17463-2-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the x86 alternative macros to allow more than one
alternative code sequence.

This is done by simply adding multiple alternative patches, which are
applied in sequence, overwriting previous ones.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/alternative.h |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 69b74a7..42d41ac 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -73,23 +73,36 @@ static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_smp_switch(int smp) {}
 #endif	/* CONFIG_SMP */
 
-/* alternative assembly primitive: */
-#define ALTERNATIVE(oldinstr, newinstr, feature)			\
-									\
-      "661:\n\t" oldinstr "\n662:\n"					\
+#define ALTERNATIVE_PATCH(oldstart, oldend, newinstr, feature)			\
       ".section .altinstructions,\"a\"\n"				\
       _ASM_ALIGN "\n"							\
-      _ASM_PTR "661b\n"				/* label           */	\
+      _ASM_PTR oldstart "\n"				/* label	   */	\
       _ASM_PTR "663f\n"				/* new instruction */	\
       "	 .byte " __stringify(feature) "\n"	/* feature bit     */	\
-      "	 .byte 662b-661b\n"			/* sourcelen       */	\
+      "	 .byte (" oldend ")-(" oldstart ")\n"			/* sourcelen       */	\
       "	 .byte 664f-663f\n"			/* replacementlen  */	\
-      "	 .byte 0xff + (664f-663f) - (662b-661b)\n" /* rlen <= slen */	\
+      "	 .byte 0xff + (664f-663f) - ((" oldend ")-(" oldstart "))\n" /* rlen <= slen */	\
       ".previous\n"							\
       ".section .altinstr_replacement, \"ax\"\n"			\
       "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\
       ".previous"
 
+/* alternative assembly primitive: */
+#define ALTERNATIVE(oldinstr, newinstr, feature)			\
+      "661:\n\t" oldinstr "\n662:\n"					\
+      ALTERNATIVE_PATCH("661b", "662b", newinstr, feature)
+
+#define ALTERNATIVE3(oldinstr, newinstr1, feature1, newinstr2, feature2)			\
+      "661:\n\t" oldinstr "\n662:\n"					\
+      ALTERNATIVE_PATCH("661b", "662b", newinstr1, feature1) "\n" \
+      ALTERNATIVE_PATCH("661b", "662b", newinstr2, feature2)
+
+#define ALTERNATIVE4(oldinstr, newinstr1, feature1, newinstr2, feature2, newinstr3, feature3)			\
+      "661:\n\t" oldinstr "\n662:\n"					\
+      ALTERNATIVE_PATCH("661b", "662b", newinstr1, feature1) "\n" \
+      ALTERNATIVE_PATCH("661b", "662b", newinstr2, feature2) "\n" \
+      ALTERNATIVE_PATCH("661b", "662b", newinstr3, feature3)
+
 /*
  * Alternative instructions for different CPU types or capabilities.
  *
-- 
1.6.6.1.476.g01ddb

