Return-Path: <linux-kernel-owner+w=401wt.eu-S1764806AbYF0Vm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764806AbYF0Vm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764252AbYF0Vhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764230AbYF0Vhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:33 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 15/39] don't save ebx in putuser_32.S
Date: Fri, 27 Jun 2008 18:34:22 -0300
Message-Id: <1214602486-17080-16-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-15-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clobber it in the inline asm macros, and let the compiler do this for us.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/putuser_32.S    |   13 ++-----------
 include/asm-x86/uaccess_32.h |   10 +++++-----
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/x86/lib/putuser_32.S b/arch/x86/lib/putuser_32.S
index f58fba1..5b2a926 100644
--- a/arch/x86/lib/putuser_32.S
+++ b/arch/x86/lib/putuser_32.S
@@ -26,14 +26,8 @@
  */
 
 #define ENTER	CFI_STARTPROC ; \
-		pushl %ebx ; \
-		CFI_ADJUST_CFA_OFFSET 4 ; \
-		CFI_REL_OFFSET ebx, 0 ; \
 		GET_THREAD_INFO(%ebx)
-#define EXIT	popl %ebx ; \
-		CFI_ADJUST_CFA_OFFSET -4 ; \
-		CFI_RESTORE ebx ; \
-		ret ; \
+#define EXIT	ret ; \
 		CFI_ENDPROC
 
 .text
@@ -81,10 +75,7 @@ ENTRY(__put_user_8)
 ENDPROC(__put_user_8)
 
 bad_put_user:
-	CFI_STARTPROC simple
-	CFI_DEF_CFA esp, 2*4
-	CFI_OFFSET eip, -1*4
-	CFI_OFFSET ebx, -2*4
+	CFI_STARTPROC
 	movl $-14,%eax
 	EXIT
 END(bad_put_user)
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 6a8adec..94d201b 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -188,23 +188,23 @@ extern void __put_user_8(void);
 
 #define __put_user_1(x, ptr)					\
 	asm volatile("call __put_user_1" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
 #define __put_user_2(x, ptr)					\
 	asm volatile("call __put_user_2" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
 #define __put_user_4(x, ptr)					\
 	asm volatile("call __put_user_4" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
 #define __put_user_8(x, ptr)					\
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
-		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr))
+		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
 #define __put_user_X(x, ptr)					\
 	asm volatile("call __put_user_X" : "=a" (__ret_pu)	\
-		     : "c" (ptr))
+		     : "c" (ptr): "ebx")
 
 /**
  * put_user: - Write a simple value into user space.
-- 
1.5.5.1

