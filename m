Return-Path: <linux-kernel-owner+w=401wt.eu-S1765382AbYF0VtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765382AbYF0VtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764208AbYF0ViZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764124AbYF0ViX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:23 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 30/39] don't always use EFAULT on __put_user_size.
Date: Fri, 27 Jun 2008 18:34:37 -0300
Message-Id: <1214602486-17080-31-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-30-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the user of the macro specify the desired return.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess_64.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 8130876..6532d63 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -37,7 +37,7 @@ extern void __put_user_bad(void);
 #define __put_user_nocheck(x, ptr, size)		\
 ({							\
 	int __pu_err;					\
-	__put_user_size((x), (ptr), (size), __pu_err);	\
+	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
 	__pu_err;					\
 })
 
@@ -65,22 +65,22 @@ extern void __put_user_bad(void);
 	__pu_err;						\
 })
 
-#define __put_user_size(x, ptr, size, retval)				\
+#define __put_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
 	case 1:								\
-		__put_user_asm(x, ptr, retval, "b", "b", "iq", -EFAULT);\
+		__put_user_asm(x, ptr, retval, "b", "b", "iq", errret);\
 		break;							\
 	case 2:								\
-		__put_user_asm(x, ptr, retval, "w", "w", "ir", -EFAULT);\
+		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);\
 		break;							\
 	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "k", "ir", -EFAULT);\
+		__put_user_asm(x, ptr, retval, "l", "k", "ir", errret);\
 		break;							\
 	case 8:								\
-		__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT);	\
+		__put_user_asm(x, ptr, retval, "q", "", "Zr", errret);	\
 		break;							\
 	default:							\
 		__put_user_bad();					\
-- 
1.5.5.1

