Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZI3LE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZI3LE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZI3LE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:04:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:46939 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZI3LEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:04:55 -0400
Date: Wed, 30 Sep 2009 13:05:23 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [PATCH] x86: Turn the copy_from_user check into an (optional)
 compile time warning
Message-ID: <20090930130523.348ae6c4@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 350cf3cd513e6759ae6852946532a47249f25600 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 30 Sep 2009 12:57:46 +0200
Subject: [PATCH] x86: Turn the copy_from_user check into an (optional) compile time warning

A previous patch added the buffer size check to copy_from_user().

One of the things learned from analyzing the result of the previous patch
is that in general, gcc is really good at proving that the code contains
sufficient security checks to not need to do a runtime check. But that
for those cases where gcc could not prove this, there was a relatively
high percentage of real security issues.

This patch turns the case of "gcc cannot prove" into a compile time
warning, as long as a sufficiently new gcc is in use that supports this.
The objective is that these warnings will trigger developers checking
new cases out before a security hole enters a linux kernel release.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/include/asm/uaccess_32.h |   12 +++++++++---
 arch/x86/lib/usercopy_32.c        |    6 ++++++
 include/linux/compiler-gcc4.h     |    3 +++
 include/linux/compiler.h          |    4 ++++
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 582d6ae..7826639 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -191,6 +191,13 @@ unsigned long __must_check _copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n);
 
+
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	__compiletime_warning("copy_from_user buffer size is not provably correct")
+#endif
+;
+
 static inline unsigned long __must_check copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n)
@@ -200,10 +207,9 @@ static inline unsigned long __must_check copy_from_user(void *to,
 
 	if (likely(sz == -1 || sz >= n))
 		ret = _copy_from_user(to, from, n);
-#ifdef CONFIG_DEBUG_VM
 	else
-		WARN(1, "Buffer overflow detected!\n");
-#endif
+		copy_from_user_overflow();
+
 	return ret;
 }
 
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 8498684..e218d5d 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -883,3 +883,9 @@ _copy_from_user(void *to, const void __user *from, unsigned long n)
 	return n;
 }
 EXPORT_SYMBOL(_copy_from_user);
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index a3aef5d..f1709c1 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -39,3 +39,6 @@
 #endif
 
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#if __GNUC_MINOR__ >= 4
+#define __compiletime_warning(message) __attribute__((warning(message)))
+#endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 9c42853..241dfd8 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -189,6 +189,10 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #ifndef __compiletime_object_size
 # define __compiletime_object_size(obj) -1
 #endif
+#ifndef __compiletime_warning
+# define __compiletime_warning(message)
+#endif
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.6.2.5


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
