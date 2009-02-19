Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZBSSis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZBSSis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZBSSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:38:39 -0500
Received: from mx1.suse.de ([195.135.220.2]:34736 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZBSSii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:38:38 -0500
Subject: [PATCH] x86: remove unneeded endless loop in BUG()
From: Petr Tesarik <ptesarik@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Thu, 19 Feb 2009 19:38:33 +0100
Message-Id: <1235068713.15053.99.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since __builtin_trap() will always generate an illegal instruction, we
can replace the explicit asm("ud2") with it.

This way gcc will understand that the function never returns, plus it
won't emit any extra instructions.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index d9cf1cd..9b7c50a 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -4,6 +4,13 @@
 #ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
 
+#define DO_BUG()						\
+do {								\
+	__builtin_trap();					\
+	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
+	panic("BUG!");						\
+} while(0)
+
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 
 #ifdef CONFIG_X86_32
@@ -14,7 +21,7 @@
 
 #define BUG()							\
 do {								\
-	asm volatile("1:\tud2\n"				\
+	asm volatile("1:\n"					\
 		     ".pushsection __bug_table,\"a\"\n"		\
 		     __BUG_C0					\
 		     "\t.word %c1, 0\n"				\
@@ -22,15 +29,11 @@ do {								\
 		     ".popsection"				\
 		     : : "i" (__FILE__), "i" (__LINE__),	\
 		     "i" (sizeof(struct bug_entry)));		\
-	for (;;) ;						\
+	DO_BUG();					\
 } while (0)
 
 #else
-#define BUG()							\
-do {								\
-	asm volatile("ud2");					\
-	for (;;) ;						\
-} while (0)
+#define BUG	DO_BUG
 #endif
 
 #endif /* !CONFIG_BUG */


