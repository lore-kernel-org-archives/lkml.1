Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbZFMObR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbZFMObR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZFMObK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:31:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52797 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZFMObJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:31:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic: uaccess: fix up local access_ok() usage
Date: Sat, 13 Jun 2009 10:30:46 -0400
Message-Id: <1244903447-23579-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason that I can see to use the short __access_ok() form
directly when the access_ok() is clearer in intent and for more people,
expands to the same C code (i.e. always specify the first field -- access
type).  Not all no-mmu systems lack memory protection, so the read/write
could feasibly be checked.

Also, the strnlen_user() function was missing a access_ok() check on the
pointer given.  We've had cases on Blackfin systems where test cases
caused kernel crashes here because userspace passed up a NULL/-1 pointer
and the kernel gladly attempted to run strlen() on it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/uaccess.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index 6d8cab2..705410b 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -163,7 +163,7 @@ static inline __must_check long __copy_to_user(void __user *to,
 #define put_user(x, ptr)					\
 ({								\
 	might_sleep();						\
-	__access_ok(ptr, sizeof (*ptr)) ?			\
+	access_ok(VERIFY_WRITE, ptr, sizeof (*ptr)) ?			\
 		__put_user(x, ptr) :				\
 		-EFAULT;					\
 })
@@ -219,7 +219,7 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 #define get_user(x, ptr)					\
 ({								\
 	might_sleep();						\
-	__access_ok(ptr, sizeof (*ptr)) ?			\
+	access_ok(VERIFY_READ, ptr, sizeof (*ptr)) ?			\
 		__get_user(x, ptr) :				\
 		-EFAULT;					\
 })
@@ -244,7 +244,7 @@ static inline long copy_from_user(void *to,
 		const void __user * from, unsigned long n)
 {
 	might_sleep();
-	if (__access_ok(from, n))
+	if (access_ok(VERIFY_READ, from, n))
 		return __copy_from_user(to, from, n);
 	else
 		return n;
@@ -254,7 +254,7 @@ static inline long copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
 	might_sleep();
-	if (__access_ok(to, n))
+	if (access_ok(VERIFY_WRITE, to, n))
 		return __copy_to_user(to, from, n);
 	else
 		return n;
@@ -278,7 +278,7 @@ __strncpy_from_user(char *dst, const char __user *src, long count)
 static inline long
 strncpy_from_user(char *dst, const char __user *src, long count)
 {
-	if (!__access_ok(src, 1))
+	if (!access_ok(VERIFY_READ, src, 1))
 		return -EFAULT;
 	return __strncpy_from_user(dst, src, count);
 }
@@ -291,6 +291,8 @@ strncpy_from_user(char *dst, const char __user *src, long count)
 #ifndef strnlen_user
 static inline long strnlen_user(const char __user *src, long n)
 {
+	if (!access_ok(VERIFY_READ, src, 1))
+		return 0;
 	return strlen((void * __force)src) + 1;
 }
 #endif
@@ -316,7 +318,7 @@ static inline __must_check unsigned long
 clear_user(void __user *to, unsigned long n)
 {
 	might_sleep();
-	if (!__access_ok(to, n))
+	if (!access_ok(VERIFY_WRITE, to, n))
 		return n;
 
 	return __clear_user(to, n);
-- 
1.6.3.1

