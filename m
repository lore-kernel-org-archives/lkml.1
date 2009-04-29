Return-Path: <linux-kernel-owner+w=401wt.eu-S933323AbZD3Px1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbZD3Px1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbZD3PnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:43:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbZD3PmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:03 -0400
Message-Id: <d68ce366f118ca01abaabbb2ee88dea34bc8ba71.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 29 Apr 2009 15:33:19 +0200
Subject: [PATCH 13/27] asm-generic: make uaccess.h usable by mmu archs
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX18TlAUpFRo4aRJLYnEtOdnbT7BkSCjHS1mdX0a
 sXjlc89PTOLp7PM7/kIObUR55JwT4aj6oZOam4BA2TdShzx77Z
 izYakLfXxla0X2bRHlGHQ==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to override some functions from uaccess.h
so that architectures with an mmu can provide assembly
versions of the functions with their own fixup logic.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/uaccess.h |  102 +++++++++++++++++++++++++---------------
 1 files changed, 64 insertions(+), 38 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index ebeacd9..e05f6a9 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -31,14 +31,14 @@ static inline void set_fs(mm_segment_t fs)
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
 
-#define access_ok(type, addr, size) _access_ok((unsigned long)(addr),(size))
+#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
 
 /*
  * The architecture should really override this if possible, at least
  * doing a check on the get_fs()
  */
-#ifndef _access_ok
-static inline int _access_ok(unsigned long addr, unsigned long size)
+#ifndef __access_ok
+static inline int __access_ok(unsigned long addr, unsigned long size)
 {
 	return 1;
 }
@@ -93,7 +93,7 @@ extern int __put_user_bad(void);
 #endif
 
 #define put_user(x, ptr) (				\
-	access_ok(VERIFY_WRITE, ptr, sizeof (*ptr)) ?	\
+	__access_ok(ptr, sizeof (*ptr)) ?		\
 		__put_user(x, ptr) :			\
 		-EFAULT)
 
@@ -120,45 +120,62 @@ extern int __get_user_bad(void);
 #endif
 
 #define get_user(x, ptr) (				\
-	access_ok(VERIFY_READ, ptr, sizeof (*ptr)) ?	\
+	__access_ok(ptr, sizeof (*ptr)) ?		\
 		__get_user(x, ptr) :			\
 		-EFAULT)
 
-#define __copy_from_user(to, from, n) (memcpy(to, from, n), 0)
-#define __copy_to_user(to, from, n) (memcpy(to, from, n), 0)
-#define __copy_to_user_inatomic __copy_to_user
-#define __copy_from_user_inatomic __copy_from_user
+#ifndef __copy_from_user
+static inline __must_check long __copy_from_user(void *to,
+		const void __user *from, unsigned long n)
+{
+	memcpy(to, (const void __force *)from, n);
+	return 0;
+}
+#endif
 
-#define copy_to_user_ret(to,from,n,retval) ({ if (copy_to_user(to,from,n)) return retval; })
+#ifndef __copy_to_user
+static inline __must_check long __copy_to_user(void __user *to,
+		const void *from, unsigned long n)
+{
+	memcpy((void __force *)to, from, n);
+	return 0;
+}
+#endif
+
+#ifndef __copy_from_user_inatomic
+#define __copy_from_user_inatomic __copy_from_user
+#endif
 
-#define copy_from_user_ret(to,from,n,retval) ({ if (copy_from_user(to,from,n)) return retval; })
+#ifndef __copy_to_user_inatomic
+#define __copy_to_user_inatomic __copy_to_user
+#endif
 
 static inline long copy_from_user(void *to,
-				  const void __user * from, unsigned long n)
+		const void __user * from, unsigned long n)
 {
-	if (access_ok(VERIFY_READ, from, n))
-		__copy_from_user(to, from, n);
+	might_sleep();
+	if (__access_ok(from, n))
+		return __copy_from_user(to, from, n);
 	else
 		return n;
-	return 0;
 }
 
-static inline long copy_to_user(void *to,
-				const void __user * from, unsigned long n)
+static inline long copy_to_user(void __user *to,
+		const void *from, unsigned long n)
 {
-	if (access_ok(VERIFY_WRITE, to, n))
-		__copy_to_user(to, from, n);
+	might_sleep();
+	if (__access_ok(to, n))
+		return __copy_to_user(to, from, n);
 	else
 		return n;
-	return 0;
 }
 
 /*
  * Copy a null terminated string from userspace.
  */
-
+#ifndef __strncpy_from_user
 static inline long
-__do_strncpy_from_user(char *dst, const char __user *src, long count)
+__strncpy_from_user(char *dst, const char __user *src, long count)
 {
 	char *tmp;
 	strncpy(dst, src, count);
@@ -166,19 +183,14 @@ __do_strncpy_from_user(char *dst, const char __user *src, long count)
 		;
 	return (tmp - dst);
 }
+#endif
 
 static inline long
 strncpy_from_user(char *dst, const char __user *src, long count)
 {
-	if (!access_ok(VERIFY_READ, src, 1))
+	if (!__access_ok(src, 1))
 		return -EFAULT;
-	return __do_strncpy_from_user(dst, src, count);
-}
-
-static inline long
-__strncpy_from_user(char *dst, const char __user *src, long count)
-{
-	return __do_strncpy_from_user(dst, src, count);
+	return __strncpy_from_user(dst, src, count);
 }
 
 /*
@@ -186,24 +198,38 @@ __strncpy_from_user(char *dst, const char __user *src, long count)
  *
  * Return 0 on exception, a value greater than N if too long
  */
-static inline long strnlen_user(const char *src, long n)
+#ifndef strnlen_user
+static inline long strnlen_user(const char __user *src, long n)
 {
-	return strlen(src) + 1;
+	return strlen((void * __force)src) + 1;
 }
+#endif
 
-#define strlen_user(str) strnlen_user(str, 32767)
+static inline long strlen_user(const char __user *src)
+{
+	return strnlen_user(src, 32767);
+}
 
 /*
  * Zero Userspace
  */
-
-static inline unsigned long
-__clear_user(void *to, unsigned long n)
+#ifndef __clear_user
+static inline __must_check unsigned long
+__clear_user(void __user *to, unsigned long n)
 {
-	memset(to, 0, n);
+	memset((void __force *)to, 0, n);
 	return 0;
 }
+#endif
 
-#define clear_user(to, n) __clear_user(to, n)
+static inline __must_check unsigned long
+clear_user(void __user *to, unsigned long n)
+{
+	might_sleep();
+	if (!__access_ok(to, n))
+		return n;
+
+	return __clear_user(to, n);
+}
 
 #endif /* __ASM_GENERIC_UACCESS_H */
-- 
1.5.6.3


