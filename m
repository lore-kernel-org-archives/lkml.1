Return-Path: <linux-kernel-owner+w=401wt.eu-S1751802AbZFNGAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbZFNGAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZFNGAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:00:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55579 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbZFNGAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:00:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] asm-generic: uaccess: do not expand args multiple times
Date: Sun, 14 Jun 2009 02:00:01 -0400
Message-Id: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While it's debatable whether {get,put}_user() should be called with
arguments that have side effects, macro's should be written safely in the
first place.  In this case, a slightly off version of put_user() ended up
causing random userspace corruption and these things aren't trivial to
track down.

While some of these conversions aren't strictly necessary, I think it's
better to do all of them so as to be proactive in people accidently
screwing it up in the future.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/uaccess.h |   49 ++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index 6d8cab2..cf3cb73 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -143,15 +143,16 @@ static inline __must_check long __copy_to_user(void __user *to,
 #define __put_user(x, ptr) \
 ({								\
 	__typeof__(*(ptr)) __x = (x);				\
+	__typeof__(*(ptr)) *__p = (ptr);			\
 	int __pu_err = -EFAULT;					\
-        __chk_user_ptr(ptr);                                    \
-	switch (sizeof (*(ptr))) {				\
+	__chk_user_ptr(__p);					\
+	switch (sizeof(*__p)) {					\
 	case 1:							\
 	case 2:							\
 	case 4:							\
 	case 8:							\
-		__pu_err = __put_user_fn(sizeof (*(ptr)),	\
-					 ptr, &__x);		\
+		__pu_err = __put_user_fn(sizeof(*__p),		\
+					 __p, &__x);		\
 		break;						\
 	default:						\
 		__put_user_bad();				\
@@ -162,9 +163,11 @@ static inline __must_check long __copy_to_user(void __user *to,
 
 #define put_user(x, ptr)					\
 ({								\
+	__typeof__(*(ptr)) _x = (x);				\
+	__typeof__(*(ptr)) *_p = (ptr);				\
 	might_sleep();						\
-	__access_ok(ptr, sizeof (*ptr)) ?			\
-		__put_user(x, ptr) :				\
+	__access_ok(_p, sizeof(*_p)) ?				\
+		__put_user(_x, _p) :				\
 		-EFAULT;					\
 })
 
@@ -178,35 +181,36 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 
 #define __get_user(x, ptr)					\
 ({								\
+	__typeof__(*(ptr)) *__p = (ptr);			\
 	int __gu_err = -EFAULT;					\
-	__chk_user_ptr(ptr);					\
-	switch (sizeof(*(ptr))) {				\
+	__chk_user_ptr(__p);					\
+	switch (sizeof(*__p)) {					\
 	case 1: {						\
 		unsigned char __x;				\
-		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
-					 ptr, &__x);		\
-		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
+		__gu_err = __get_user_fn(sizeof(*__p),		\
+					 __p, &__x);		\
+		(x) = *(__force __typeof__(*__p) *) &__x;	\
 		break;						\
 	};							\
 	case 2: {						\
 		unsigned short __x;				\
-		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
-					 ptr, &__x);		\
-		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
+		__gu_err = __get_user_fn(sizeof(*__p),		\
+					 __p, &__x);		\
+		(x) = *(__force __typeof__(*__p) *) &__x;	\
 		break;						\
 	};							\
 	case 4: {						\
 		unsigned int __x;				\
-		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
-					 ptr, &__x);		\
-		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
+		__gu_err = __get_user_fn(sizeof(*__p),		\
+					 __p, &__x);		\
+		(x) = *(__force __typeof__(*__p) *) &__x;	\
 		break;						\
 	};							\
 	case 8: {						\
 		unsigned long long __x;				\
-		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
-					 ptr, &__x);		\
-		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
+		__gu_err = __get_user_fn(sizeof(*__p),		\
+					 __p, &__x);		\
+		(x) = *(__force __typeof__(*__p) *) &__x;	\
 		break;						\
 	};							\
 	default:						\
@@ -218,9 +222,10 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 
 #define get_user(x, ptr)					\
 ({								\
+	__typeof__(*(ptr)) *_p = (ptr);				\
 	might_sleep();						\
-	__access_ok(ptr, sizeof (*ptr)) ?			\
-		__get_user(x, ptr) :				\
+	__access_ok(_p, sizeof(*_p)) ?				\
+		__get_user(x, _p) :				\
 		-EFAULT;					\
 })
 
-- 
1.6.3.1

