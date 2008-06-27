Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbYF0Vnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbYF0Vnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764240AbYF0Vhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764223AbYF0Vhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:36 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 17/39] clobber rbx in putuser_64.S
Date: Fri, 27 Jun 2008 18:34:24 -0300
Message-Id: <1214602486-17080-18-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-17-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of clobbering r8, clobber rbx, which is the i386 way.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/putuser_64.S    |   18 +++++++++---------
 include/asm-x86/uaccess_64.h |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
index 940796f..0702885 100644
--- a/arch/x86/lib/putuser_64.S
+++ b/arch/x86/lib/putuser_64.S
@@ -18,7 +18,7 @@
  *
  * Outputs:	%rax is error code (0 or -EFAULT)
  *
- * %r8 is destroyed.
+ * %rbx is destroyed.
  *
  * These functions should not modify any other registers,
  * as they get called from within inline assembly.
@@ -34,8 +34,8 @@
 	.text
 ENTRY(__put_user_1)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	cmpq TI_addr_limit(%r8),%rcx
+	GET_THREAD_INFO(%rbx)
+	cmpq TI_addr_limit(%rbx),%rcx
 	jae bad_put_user
 1:	movb %dl,(%rcx)
 	xorl %eax,%eax
@@ -45,10 +45,10 @@ ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
+	GET_THREAD_INFO(%rbx)
 	addq $1,%rcx
 	jc 20f
-	cmpq TI_addr_limit(%r8),%rcx
+	cmpq TI_addr_limit(%rbx),%rcx
 	jae 20f
 	decq %rcx
 2:	movw %dx,(%rcx)
@@ -61,10 +61,10 @@ ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
+	GET_THREAD_INFO(%rbx)
 	addq $3,%rcx
 	jc 30f
-	cmpq TI_addr_limit(%r8),%rcx
+	cmpq TI_addr_limit(%rbx),%rcx
 	jae 30f
 	subq $3,%rcx
 3:	movl %edx,(%rcx)
@@ -77,10 +77,10 @@ ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
+	GET_THREAD_INFO(%rbx)
 	addq $7,%rcx
 	jc 40f
-	cmpq TI_addr_limit(%r8),%rcx
+	cmpq TI_addr_limit(%rbx),%rcx
 	jae 40f
 	subq $7,%rcx
 4:	movq %rdx,(%rcx)
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 9049f4e..8933ddb 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -131,7 +131,7 @@ extern void __put_user_bad(void);
 	asm volatile("call __put_user_" #size				\
 		     :"=a" (ret)					\
 		     :"c" (ptr),"d" (x)					\
-		     :"r8")
+		     :"ebx")
 
 #define put_user(x, ptr)						\
 	__put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
-- 
1.5.5.1

