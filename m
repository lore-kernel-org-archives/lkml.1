Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZD3Hbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZD3Hbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZD3Hb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:31:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:55805 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZD3Hb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:31:27 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping around
Date: Thu, 30 Apr 2009 12:59:11 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
References: <200904291221.40361.knikanth@novell.com> <200904291533.07377.knikanth@novell.com> <20090429081558.acaa2a9a.akpm@linux-foundation.org>
In-Reply-To: <20090429081558.acaa2a9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301259.11413.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debug option to detect and warn when the 32-bit atomic_t wraps around
during atomic_inc and atomic_dec.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 85b46fb..92b898f 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -3,8 +3,10 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
+#include <asm/bug.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -77,6 +79,8 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
 	return c;
 }
 
+static inline int atomic_add_unless(atomic_t *v, int a, int u);
+
 /**
  * atomic_inc - increment atomic variable
  * @v: pointer of type atomic_t
@@ -85,8 +89,12 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
  */
 static inline void atomic_inc(atomic_t *v)
 {
+#if defined(CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP)
+	WARN_ON(atomic_add_unless(v, 1, INT_MAX) == 0);
+#else
 	asm volatile(LOCK_PREFIX "incl %0"
 		     : "+m" (v->counter));
+#endif
 }
 
 /**
@@ -97,8 +105,12 @@ static inline void atomic_inc(atomic_t *v)
  */
 static inline void atomic_dec(atomic_t *v)
 {
+#if defined(CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP)
+	WARN_ON(atomic_add_unless(v, -1, INT_MIN) == 0);
+#else
 	asm volatile(LOCK_PREFIX "decl %0"
 		     : "+m" (v->counter));
+#endif
 }
 
 /**
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index 8c21731..c34a6fa 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -2,8 +2,10 @@
 #define _ASM_X86_ATOMIC_64_H
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/bug.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -76,6 +78,8 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
 	return c;
 }
 
+static inline int atomic_add_unless(atomic_t *v, int a, int u);
+
 /**
  * atomic_inc - increment atomic variable
  * @v: pointer of type atomic_t
@@ -84,9 +88,13 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
  */
 static inline void atomic_inc(atomic_t *v)
 {
+#if defined(CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP)
+	WARN_ON(atomic_add_unless(v, 1, INT_MAX) == 0);
+#else
 	asm volatile(LOCK_PREFIX "incl %0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
+#endif
 }
 
 /**
@@ -97,9 +105,13 @@ static inline void atomic_inc(atomic_t *v)
  */
 static inline void atomic_dec(atomic_t *v)
 {
+#if defined(CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP)
+	WARN_ON(atomic_add_unless(v, -1, INT_MIN) == 0);
+#else
 	asm volatile(LOCK_PREFIX "decl %0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
+#endif
 }
 
 /**
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 812c282..a446a98 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -17,6 +17,13 @@ config ENABLE_WARN_DEPRECATED
 	  Disable this to suppress the "warning: 'foo' is deprecated
 	  (declared at kernel/power/somefile.c:1234)" messages.
 
+config ENABLE_WARN_ATOMIC_INC_WRAP
+	bool "Enable warning on atomic_inc()/atomic_dec() wrap"
+	default y
+	help
+	  Enable printing a warning when atomic_inc() or atomic_dec()
+	  operation wraps around the 32-bit value.
+
 config ENABLE_MUST_CHECK
 	bool "Enable __must_check logic"
 	default y

