Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYAFDPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYAFDPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYAFDOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:14:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57789 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbYAFDN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:13:59 -0500
Date: Sat, 5 Jan 2008 19:12:45 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
Subject: [patch 5/5] PowerPC: switch to generic WARN_ON / BUG_ON
Message-ID: <20080105191245.06cb2d8a@laptopd505.fenrus.org>
In-Reply-To: <20080105190713.73745ec6@laptopd505.fenrus.org>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
4K text on a ppc64_defconfig.  The main reason seems to be that prepping
the arguments to the conditional trap instructions is more work than just
doing a compare and branch.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: <linux-arch@vger.kernel.org>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/bug.h |   37 -------------------------------------
 1 file changed, 37 deletions(-)

Index: linux-2.6.24-rc6/include/asm-powerpc/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-powerpc/bug.h
+++ linux-2.6.24-rc6/include/asm-powerpc/bug.h
@@ -54,12 +54,6 @@
 	".previous\n"
 #endif
 
-/*
- * BUG_ON() and WARN_ON() do their best to cooperate with compile-time
- * optimisations. However depending on the complexity of the condition
- * some compiler versions may not produce optimal results.
- */
-
 #define BUG() do {						\
 	__asm__ __volatile__(					\
 		"1:	twi 31,0,0\n"				\
@@ -69,20 +63,6 @@
 	for(;;) ;						\
 } while (0)
 
-#define BUG_ON(x) do {						\
-	if (__builtin_constant_p(x)) {				\
-		if (x)						\
-			BUG();					\
-	} else {						\
-		__asm__ __volatile__(				\
-		"1:	"PPC_TLNEI"	%4,0\n"			\
-		_EMIT_BUG_ENTRY					\
-		: : "i" (__FILE__), "i" (__LINE__), "i" (0),	\
-		  "i" (sizeof(struct bug_entry)),		\
-		  "r" ((__force long)(x)));			\
-	}							\
-} while (0)
-
 #define __WARN() do {						\
 	__asm__ __volatile__(					\
 		"1:	twi 31,0,0\n"				\
@@ -92,23 +72,6 @@
 		  "i" (sizeof(struct bug_entry)));		\
 } while (0)
 
-#define WARN_ON(x) ({						\
-	int __ret_warn_on = !!(x);				\
-	if (__builtin_constant_p(__ret_warn_on)) {		\
-		if (__ret_warn_on)				\
-			__WARN();				\
-	} else {						\
-		__asm__ __volatile__(				\
-		"1:	"PPC_TLNEI"	%4,0\n"			\
-		_EMIT_BUG_ENTRY					\
-		: : "i" (__FILE__), "i" (__LINE__),		\
-		  "i" (BUGFLAG_WARNING),			\
-		  "i" (sizeof(struct bug_entry)),		\
-		  "r" (__ret_warn_on));				\
-	}							\
-	unlikely(__ret_warn_on);				\
-})
-
 #endif /* __ASSEMBLY __ */
 #endif /* CONFIG_BUG */
 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
