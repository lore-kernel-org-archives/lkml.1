Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbZFNGAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbZFNGAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZFNGAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:00:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55584 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZFNGAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:00:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] asm-generic: uaccess: fix up local access_ok() usage
Date: Sun, 14 Jun 2009 02:00:03 -0400
Message-Id: <1244959204-11269-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason that I can see to use the short __access_ok() form
directly when the access_ok() is clearer in intent and for most people,
expands to the same C code (i.e. always specify the first field -- access
type).  Not all no-mmu systems lack memory protection, so the read/write
could feasibly be checked.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/uaccess.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index d299557..d3a9519 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -166,7 +166,7 @@ static inline __must_check long __copy_to_user(void __user *to,
 	__typeof__(*(ptr)) _x = (x);				\
 	__typeof__(*(ptr)) *_p = (ptr);				\
 	might_sleep();						\
-	__access_ok(_p, sizeof(*_p)) ?				\
+	access_ok(VERIFY_WRITE, _p, sizeof(*_p)) ?		\
 		__put_user(_x, _p) :				\
 		-EFAULT;					\
 })
@@ -224,7 +224,7 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 ({								\
 	__typeof__(*(ptr)) *_p = (ptr);				\
 	might_sleep();						\
-	__access_ok(_p, sizeof(*_p)) ?				\
+	access_ok(VERIFY_READ, _p, sizeof(*_p)) ?		\
 		__get_user(x, _p) :				\
 		-EFAULT;					\
 })
@@ -249,7 +249,7 @@ static inline long copy_from_user(void *to,
 		const void __user * from, unsigned long n)
 {
 	might_sleep();
-	if (__access_ok(from, n))
+	if (access_ok(VERIFY_READ, from, n))
 		return __copy_from_user(to, from, n);
 	else
 		return n;
@@ -259,7 +259,7 @@ static inline long copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
 	might_sleep();
-	if (__access_ok(to, n))
+	if (access_ok(VERIFY_WRITE, to, n))
 		return __copy_to_user(to, from, n);
 	else
 		return n;
@@ -283,7 +283,7 @@ __strncpy_from_user(char *dst, const char __user *src, long count)
 static inline long
 strncpy_from_user(char *dst, const char __user *src, long count)
 {
-	if (!__access_ok(src, 1))
+	if (!access_ok(VERIFY_READ, src, 1))
 		return -EFAULT;
 	return __strncpy_from_user(dst, src, count);
 }
@@ -323,7 +323,7 @@ static inline __must_check unsigned long
 clear_user(void __user *to, unsigned long n)
 {
 	might_sleep();
-	if (!__access_ok(to, n))
+	if (!access_ok(VERIFY_WRITE, to, n))
 		return n;
 
 	return __clear_user(to, n);
-- 
1.6.3.1

