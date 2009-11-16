Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZKPOmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZKPOmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZKPOmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:42:12 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:36938 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZKPOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:42:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZTAToEdlbjOAfJiypjwoWd9jvV4cK0ABiNV9cAczSB8N8ZK2tREp4bh8cSB4kwVreW
         Wxlgq1bQiuzZzdVsqNGaYIlDpi/lVxy3PPqY1BFXiqHONKC0x6lKinwvj7V99NXyVFov
         a/cPqE4Mw3x9UrYG/TKFkCY8u9Hm7hxvLov4U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] x86: Add missing might_fault() from copy_{to,from}_user()
Date: Mon, 16 Nov 2009 15:42:18 +0100
Message-Id: <1258382538-30979-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In x86-64, copy_to/from_user() rely on assembly routines that never
call might_fault(), making us missing various lockdep checks.

This doesn't apply to __copy_from,to_user() that explicitly handle
these calls, neither is it a problem in x86-32 where
copy_to,from_user() rely on the "__" prefixed versions that also call
might_fault().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/uaccess_64.h |   10 +++++++++-
 arch/x86/lib/copy_user_64.S       |    4 ++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 7adebac..46324c6 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -19,7 +19,7 @@ __must_check unsigned long
 copy_user_generic(void *to, const void *from, unsigned len);
 
 __must_check unsigned long
-copy_to_user(void __user *to, const void *from, unsigned len);
+_copy_to_user(void __user *to, const void *from, unsigned len);
 __must_check unsigned long
 _copy_from_user(void *to, const void __user *from, unsigned len);
 __must_check unsigned long
@@ -32,6 +32,7 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	int sz = __compiletime_object_size(to);
 	int ret = -EFAULT;
 
+	might_fault();
 	if (likely(sz == -1 || sz >= n))
 		ret = _copy_from_user(to, from, n);
 #ifdef CONFIG_DEBUG_VM
@@ -41,6 +42,13 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	return ret;
 }
 
+static __always_inline __must_check
+int copy_to_user(void __user *dst, const void *src, unsigned size)
+{
+	might_fault();
+
+	return _copy_to_user(dst, src, size);
+}
 
 static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 3936998..cf889d4 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -65,7 +65,7 @@
 	.endm
 
 /* Standard copy_to_user with segment limit checking */
-ENTRY(copy_to_user)
+ENTRY(_copy_to_user)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rax)
 	movq %rdi,%rcx
@@ -75,7 +75,7 @@ ENTRY(copy_to_user)
 	jae bad_to_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
-ENDPROC(copy_to_user)
+ENDPROC(_copy_to_user)
 
 /* Standard copy_from_user with segment limit checking */
 ENTRY(_copy_from_user)
-- 
1.6.2.3

