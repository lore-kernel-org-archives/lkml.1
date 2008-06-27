Return-Path: <linux-kernel-owner+w=401wt.eu-S1752410AbYF0VnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbYF0VnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764230AbYF0Vhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764240AbYF0Vhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:35 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 16/39] user put_user_x instead of all variants.
Date: Fri, 27 Jun 2008 18:34:23 -0300
Message-Id: <1214602486-17080-17-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-16-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the pattern, and define a single put_user_x, instead
of defining macros for all available sizes. Exception is
put_user_8, since the "A" constraint does not give us enough
power to specify which register (a or d) to use in the 32-bit
common case.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess_32.h |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 94d201b..ff3443b 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -186,25 +186,14 @@ extern void __put_user_2(void);
 extern void __put_user_4(void);
 extern void __put_user_8(void);
 
-#define __put_user_1(x, ptr)					\
-	asm volatile("call __put_user_1" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
-
-#define __put_user_2(x, ptr)					\
-	asm volatile("call __put_user_2" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
-
-#define __put_user_4(x, ptr)					\
-	asm volatile("call __put_user_4" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+#define __put_user_x(size, x, ptr)				\
+	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
+		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
 #define __put_user_8(x, ptr)					\
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
-#define __put_user_X(x, ptr)					\
-	asm volatile("call __put_user_X" : "=a" (__ret_pu)	\
-		     : "c" (ptr): "ebx")
 
 /**
  * put_user: - Write a simple value into user space.
@@ -232,19 +221,19 @@ extern void __put_user_8(void);
 	__pu_val = x;						\
 	switch (sizeof(*(ptr))) {				\
 	case 1:							\
-		__put_user_1(__pu_val, ptr);			\
+		__put_user_x(1, __pu_val, ptr);			\
 		break;						\
 	case 2:							\
-		__put_user_2(__pu_val, ptr);			\
+		__put_user_x(2, __pu_val, ptr);			\
 		break;						\
 	case 4:							\
-		__put_user_4(__pu_val, ptr);			\
+		__put_user_x(4, __pu_val, ptr);			\
 		break;						\
 	case 8:							\
 		__put_user_8(__pu_val, ptr);			\
 		break;						\
 	default:						\
-		__put_user_X(__pu_val, ptr);			\
+		__put_user_x(X, __pu_val, ptr);			\
 		break;						\
 	}							\
 	__ret_pu;						\
-- 
1.5.5.1

