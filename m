Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXJKRG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXJKRG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXJKRGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:06:49 -0400
Received: from lixom.net ([66.141.50.11]:57993 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbXJKRGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:06:49 -0400
Date: Thu, 11 Oct 2007 12:12:11 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulus@ozlabs.org, lethal@linux-sh.org,
       kyle@parisc-linux.org, grundler@parisc-linux.org
Subject: [PATCH 1/2] bug.h: Introduce HAVE_ARCH_WARN
Message-ID: <20071011171211.GB10877@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HAVE_ARCH_WARN is used to determine if an arch already has a __WARN()
macro, or if a generic one is needed.

With this, some of the arch-specific WARN_ON() implementations can be
made common instead (see follow-up patch for powerpc).

Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index d56fedb..c6b8386 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -31,14 +31,19 @@ struct bug_entry {
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
+#ifndef HAVE_ARCH_WARN
+#define __WARN() do {							\
+	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
+		__LINE__, __FUNCTION__);				\
+	dump_stack();							\
+} while (0)
+#endif
+
 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
-			__LINE__, __FUNCTION__);			\
-		dump_stack();						\
-	}								\
+	if (unlikely(__ret_warn_on))					\
+		__WARN();						\
 	unlikely(__ret_warn_on);					\
 })
 #endif
diff --git a/include/asm-parisc/bug.h b/include/asm-parisc/bug.h
index 8cfc553..3f68100 100644
--- a/include/asm-parisc/bug.h
+++ b/include/asm-parisc/bug.h
@@ -8,6 +8,7 @@
 
 #ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
+#define HAVE_ARCH_WARN
 #define HAVE_ARCH_WARN_ON
 
 /* the break instruction is used as BUG() marker.  */
diff --git a/include/asm-powerpc/bug.h b/include/asm-powerpc/bug.h
index e55d1f6..02e171c 100644
--- a/include/asm-powerpc/bug.h
+++ b/include/asm-powerpc/bug.h
@@ -110,6 +110,7 @@
 })
 
 #define HAVE_ARCH_BUG
+#define HAVE_ARCH_WARN
 #define HAVE_ARCH_BUG_ON
 #define HAVE_ARCH_WARN_ON
 #endif /* __ASSEMBLY __ */
diff --git a/include/asm-sh/bug.h b/include/asm-sh/bug.h
index a78d482..4ea415b 100644
--- a/include/asm-sh/bug.h
+++ b/include/asm-sh/bug.h
@@ -5,6 +5,7 @@
 
 #ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
+#define HAVE_ARCH_WARN
 #define HAVE_ARCH_WARN_ON
 
 /**
