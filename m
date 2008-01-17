Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYAQA7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYAQA7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYAQA6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:58:44 -0500
Received: from lixom.net ([66.141.50.11]:57147 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbYAQA6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:58:43 -0500
Date: Wed, 16 Jan 2008 19:09:15 -0600
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       paulus@samba.org
Subject: [patch 2/3] [POWERPC] switch to generic WARN_ON / BUG_ON
Message-ID: <20080117010915.GB24766@lixom.net>
References: <20080117010130.GA24663@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117010130.GA24663@lixom.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
4K text on a ppc64_defconfig.  The main reason seems to be that prepping
the arguments to the conditional trap instructions is more work than just
doing a compare and branch.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: <linux-arch@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
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
 


