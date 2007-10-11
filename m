Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbXJKRI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbXJKRI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXJKRIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:08:51 -0400
Received: from lixom.net ([66.141.50.11]:52773 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbXJKRIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:08:50 -0400
Date: Thu, 11 Oct 2007 12:14:13 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulus@ozlabs.org, lethal@linux-sh.org,
       kyle@parisc-linux.org, grundler@parisc-linux.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/2] powerpc: Switch to generic WARN_ON()/BUG_ON()
Message-ID: <20071011171413.GC10877@lixom.net>
References: <20071011171211.GB10877@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011171211.GB10877@lixom.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
4K text on a ppc64_defconfig. The main reason seems to be that prepping
the arguments to the conditional trap instructions is more work than
just doing a compare and branch.

Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/include/asm-powerpc/bug.h b/include/asm-powerpc/bug.h
index 02e171c..966de9b 100644
--- a/include/asm-powerpc/bug.h
+++ b/include/asm-powerpc/bug.h
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
@@ -92,27 +72,8 @@
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
 #define HAVE_ARCH_BUG
 #define HAVE_ARCH_WARN
-#define HAVE_ARCH_BUG_ON
-#define HAVE_ARCH_WARN_ON
 #endif /* __ASSEMBLY __ */
 #endif /* CONFIG_BUG */
 
