Return-Path: <linux-kernel-owner+w=401wt.eu-S1765341AbYF0Vtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765341AbYF0Vtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764376AbYF0Vie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764351AbYF0Vid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:33 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 32/39] don't always use EFAULT on __get_user_size.
Date: Fri, 27 Jun 2008 18:34:39 -0300
Message-Id: <1214602486-17080-33-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-32-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
 <1214602486-17080-14-git-send-email-gcosta@redhat.com>
 <1214602486-17080-15-git-send-email-gcosta@redhat.com>
 <1214602486-17080-16-git-send-email-gcosta@redhat.com>
 <1214602486-17080-17-git-send-email-gcosta@redhat.com>
 <1214602486-17080-18-git-send-email-gcosta@redhat.com>
 <1214602486-17080-19-git-send-email-gcosta@redhat.com>
 <1214602486-17080-20-git-send-email-gcosta@redhat.com>
 <1214602486-17080-21-git-send-email-gcosta@redhat.com>
 <1214602486-17080-22-git-send-email-gcosta@redhat.com>
 <1214602486-17080-23-git-send-email-gcosta@redhat.com>
 <1214602486-17080-24-git-send-email-gcosta@redhat.com>
 <1214602486-17080-25-git-send-email-gcosta@redhat.com>
 <1214602486-17080-26-git-send-email-gcosta@redhat.com>
 <1214602486-17080-27-git-send-email-gcosta@redhat.com>
 <1214602486-17080-28-git-send-email-gcosta@redhat.com>
 <1214602486-17080-29-git-send-email-gcosta@redhat.com>
 <1214602486-17080-30-git-send-email-gcosta@redhat.com>
 <1214602486-17080-31-git-send-email-gcosta@redhat.com>
 <1214602486-17080-32-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the user of the macro specify the desired return.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess_64.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 42c01aa..e0875d7 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -61,27 +61,27 @@ extern void __put_user_bad(void);
 ({								\
 	int __gu_err;						\
 	unsigned long __gu_val;					\
-	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
+	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);\
 	(x) = (__force typeof(*(ptr)))__gu_val;			\
 	__gu_err;						\
 })
 
-#define __get_user_size(x, ptr, size, retval)				\
+#define __get_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
 	case 1:								\
-		__get_user_asm(x, ptr, retval, "b", "b", "=q", -EFAULT);\
+		__get_user_asm(x, ptr, retval, "b", "b", "=q", errret);\
 		break;							\
 	case 2:								\
-		__get_user_asm(x, ptr, retval, "w", "w", "=r", -EFAULT);\
+		__get_user_asm(x, ptr, retval, "w", "w", "=r", errret);\
 		break;							\
 	case 4:								\
-		__get_user_asm(x, ptr, retval, "l", "k", "=r", -EFAULT);\
+		__get_user_asm(x, ptr, retval, "l", "k", "=r", errret);\
 		break;							\
 	case 8:								\
-		__get_user_asm(x, ptr, retval, "q", "", "=r", -EFAULT);	\
+		__get_user_asm(x, ptr, retval, "q", "", "=r", errret);	\
 		break;							\
 	default:							\
 		(x) = __get_user_bad();					\
-- 
1.5.5.1

