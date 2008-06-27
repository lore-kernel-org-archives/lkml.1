Return-Path: <linux-kernel-owner+w=401wt.eu-S1765469AbYF0Vu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765469AbYF0Vu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764266AbYF0Vih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764379AbYF0Vig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:36 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 35/39] turn __put_user_check directly into put_user.
Date: Fri, 27 Jun 2008 18:34:42 -0300
Message-Id: <1214602486-17080-36-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-35-git-send-email-gcosta@redhat.com>
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
 <1214602486-17080-33-git-send-email-gcosta@redhat.com>
 <1214602486-17080-34-git-send-email-gcosta@redhat.com>
 <1214602486-17080-35-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We also check user pointer in x86_64 put_user, the way i386 does.

in a separate patch for bisecting purposes.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess_64.h |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 42a9769..9139854 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -23,9 +23,6 @@ extern void __put_user_bad(void);
 		     :"c" (ptr),"a" (x)					\
 		     :"ebx")
 
-#define put_user(x, ptr)						\
-	__put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
-
 #define __get_user(x, ptr)						\
 	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
 #define __put_user(x, ptr)						\
@@ -34,11 +31,12 @@ extern void __put_user_bad(void);
 #define __get_user_unaligned __get_user
 #define __put_user_unaligned __put_user
 
-#define __put_user_check(x, ptr, size)				\
+#define put_user(x, ptr)					\
 ({								\
 	int __pu_err;						\
 	typeof(*(ptr)) __user *__pu_addr = (ptr);		\
-	switch (size) {						\
+	__chk_user_ptr(ptr);					\
+	switch (sizeof(*(ptr))) {				\
 	case 1:							\
 		__put_user_x(1, __pu_err, x, __pu_addr);	\
 		break;						\
-- 
1.5.5.1

