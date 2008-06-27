Return-Path: <linux-kernel-owner+w=401wt.eu-S1765129AbYF0Vqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765129AbYF0Vqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761264AbYF0ViG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764319AbYF0ViC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:02 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 24/39] commonize __range_not_ok
Date: Fri, 27 Jun 2008 18:34:31 -0300
Message-Id: <1214602486-17080-25-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-24-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For i386, __range_not_ok is a better name than __range_ok, since
it returns 0 when it is in fact okay. Other than that,
both versions does not need the word size specifiers, and we remove them.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess_32.h |    6 +++---
 include/asm-x86/uaccess_64.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index ff3443b..9884f50 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -56,11 +56,11 @@ extern struct movsl_mask {
  *
  * This needs 33-bit arithmetic. We have a carry...
  */
-#define __range_ok(addr, size)						\
+#define __range_not_ok(addr, size)					\
 ({									\
 	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
-	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0"		\
+	asm("add %3,%1 ; sbb %0,%0; cmp %1,%4; sbb $0,%0"		\
 	    :"=&r" (flag), "=r" (roksum)				\
 	    :"1" (addr), "g" ((int)(size)),				\
 	    "rm" (current_thread_info()->addr_limit.seg));		\
@@ -86,7 +86,7 @@ extern struct movsl_mask {
  * checks that the pointer is in the user space range - after calling
  * this function, memory access functions may still return -EFAULT.
  */
-#define access_ok(type, addr, size) (likely(__range_ok(addr, size) == 0))
+#define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
 
 /*
  * The exception table consists of pairs of addresses: the first is the
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 05bb246..d607fd0 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -42,7 +42,7 @@
 	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
 	asm("# range_ok\n\r"						\
-	    "addq %3,%1 ; sbbq %0,%0 ; cmpq %1,%4 ; sbbq $0,%0"		\
+	    "add %3,%1 ; sbb %0,%0 ; cmp %1,%4 ; sbb $0,%0"		\
 	    : "=&r" (flag), "=r" (roksum)				\
 	    : "1" (addr), "g" ((long)(size)),				\
 	      "g" (current_thread_info()->addr_limit.seg));		\
-- 
1.5.5.1

