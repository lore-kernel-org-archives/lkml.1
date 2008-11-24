Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbYKXJVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbYKXJVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYKXJVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:21:09 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:41139 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751372AbYKXJVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:21:08 -0500
Date: Mon, 24 Nov 2008 09:20:48 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
Message-ID: <20081124092048.GA21665@linux-mips.org>
References: <49260E4C.8080500@caviumnetworks.com> <20081121150023.032f7b5b.akpm@linux-foundation.org> <20081123095818.GU30453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123095818.GU30453@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 10:58:18AM +0100, Ingo Molnar wrote:

> yes - the total image effect is significantly - recently looked at how 
> much larger !CONFIG_BUG builds would get if we inserted an infinite 
> loop into them - it was in the 50K text range (!).
> 
> but in the x86 ud2 case we could guarantee that we wont ever return 
> from that exception. Mind sending a patch with a signoff, a 
> description and an infinite loop in the u2d handler?

The infinite loop is necessary to keep gcc from creating pointless warnings.
But I did play a bit further with bug.h, this time on x86.  Result below.

  Ralf

[PATCH] x86: Optimize BUG() codesize.

Turning the i386 BUG() into an inline function shaves off 4064 bytes for
a defconfig kernel and 16 bytes for the same kernel with
CONFIG_DEBUG_BUGVERBOSE cleared.  Tested with gcc 4.3.0.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 3def206..3b3bf2a 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -1,9 +1,10 @@
 #ifndef _ASM_X86_BUG_H
 #define _ASM_X86_BUG_H
 
-#ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
+#include <asm-generic/bug.h>
 
+#ifdef CONFIG_BUG
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 
 #ifdef CONFIG_X86_32
@@ -12,28 +13,27 @@
 # define __BUG_C0	"2:\t.quad 1b, %c0\n"
 #endif
 
-#define BUG()							\
-do {								\
-	asm volatile("1:\tud2\n"				\
-		     ".pushsection __bug_table,\"a\"\n"		\
-		     __BUG_C0					\
-		     "\t.word %c1, 0\n"				\
-		     "\t.org 2b+%c2\n"				\
-		     ".popsection"				\
-		     : : "i" (__FILE__), "i" (__LINE__),	\
-		     "i" (sizeof(struct bug_entry)));		\
-	for (;;) ;						\
-} while (0)
+static inline void BUG(void)
+{
+	asm volatile("1:\tud2\n"
+		     ".pushsection __bug_table,\"a\"\n"
+		     __BUG_C0
+		     "\t.word %c1, 0\n"	
+		     "\t.org 2b+%c2\n"
+		     ".popsection"
+		     : : "i" (__FILE__), "i" (__LINE__),
+		     "i" (sizeof(struct bug_entry)));
+	for (;;) ;
+}
 
 #else
-#define BUG()							\
-do {								\
-	asm volatile("ud2");					\
-	for (;;) ;						\
-} while (0)
+static inline void BUG(void)
+{
+	asm volatile("ud2");
+	for (;;) ;
+}
 #endif
 
 #endif /* !CONFIG_BUG */
 
-#include <asm-generic/bug.h>
 #endif /* _ASM_X86_BUG_H */
