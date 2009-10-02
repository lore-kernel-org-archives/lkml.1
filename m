Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZJBOua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZJBOua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZJBOu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:50:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:45594 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbZJBOu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:50:26 -0400
Date: Fri, 2 Oct 2009 07:50:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: PATCH] x86: Add a Kconfig option to turn the copy_from_user
 warnings into errors
Message-ID: <20091002075050.4e9f7641@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ea558e6a4f5835f7cd1045caa5dce7c3940b7108 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 2 Oct 2009 07:35:27 -0700
Subject: [PATCH] x86: Add a Kconfig option to turn the copy_from_user warnings into errors

For automated testing it is useful to have the option to turn
the warnings on copy_from_user() etc checks into errors:

In function ‘copy_from_user’,
    inlined from ‘fd_copyin’ at drivers/block/floppy.c:3080,
    inlined from ‘fd_ioctl’ at drivers/block/floppy.c:3503:
/home/arjan/linux/arch/x86/include/asm/uaccess_32.h:213:
error: call to ‘copy_from_user_overflow’ declared with attribute error:
copy_from_user buffer size is not provably correct

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig.debug            |   14 ++++++++++++++
 arch/x86/include/asm/uaccess_32.h |    4 +++-
 include/linux/compiler-gcc4.h     |    1 +
 include/linux/compiler.h          |    3 +++
 4 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d105f29..1bd2e36 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -287,4 +287,18 @@ config OPTIMIZE_INLINING
 
 	  If unsure, say N.
 
+config DEBUG_STRICT_USER_COPY_CHECKS
+	bool "Strict copy size checks"
+	depends on DEBUG_KERNEL
+	---help---
+	  Enabling this option turns a certain set of sanity checks for user
+	  copy operations into compile time failures.
+
+	  The copy_from_user() etc checks are there to help test if there
+	  are sufficient security checks on the length argument of
+	  the copy operation, by having gcc prove that the argument is
+	  within bounds.
+
+	  If unsure, or if you run an older (pre 4.4) gcc, say N.
+
 endmenu
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 952f9e7..0c9825e 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -193,7 +193,9 @@ unsigned long __must_check _copy_from_user(void *to,
 
 
 extern void copy_from_user_overflow(void)
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+	__compiletime_error("copy_from_user() buffer size is not provably correct")
+#else
 	__compiletime_warning("copy_from_user() buffer size is not provably correct")
 #endif
 ;
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index f1709c1..77542c5 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -41,4 +41,5 @@
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #if __GNUC_MINOR__ >= 4
 #define __compiletime_warning(message) __attribute__((warning(message)))
+#define __compiletime_error(message) __attribute__((error(message)))
 #endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 241dfd8..d1cc9f0 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -192,6 +192,9 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #ifndef __compiletime_warning
 # define __compiletime_warning(message)
 #endif
+#ifndef __compiletime_error
+# define __compiletime_error(message)
+#endif
 
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
