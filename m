Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZKPQLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZKPQLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZKPQLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:11:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:41346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbZKPQLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:11:43 -0500
Date: Mon, 16 Nov 2009 16:10:19 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       arjan@infradead.org, npiggin@suse.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: npiggin@suse.de, arjan@infradead.org, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258382538-30979-1-git-send-email-fweisbec@gmail.com>
References: <1258382538-30979-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Add missing might_fault() checks to copy_{to,from}_user()
Message-ID: <tip-3c93ca00eeeb774c7dd666cc7286a9e90c53e998@git.kernel.org>
Git-Commit-ID: 3c93ca00eeeb774c7dd666cc7286a9e90c53e998
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c93ca00eeeb774c7dd666cc7286a9e90c53e998
Gitweb:     http://git.kernel.org/tip/3c93ca00eeeb774c7dd666cc7286a9e90c53e998
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 16 Nov 2009 15:42:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 16:09:52 +0100

x86: Add missing might_fault() checks to copy_{to,from}_user()

On x86-64, copy_[to|from]_user() rely on assembly routines that
never call might_fault(), making us missing various lockdep
checks.

This doesn't apply to __copy_from,to_user() that explicitly
handle these calls, neither is it a problem in x86-32 where
copy_to,from_user() rely on the "__" prefixed versions that
also call might_fault().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1258382538-30979-1-git-send-email-fweisbec@gmail.com>
[ v2: fix module export ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uaccess_64.h |   10 +++++++++-
 arch/x86/kernel/x8664_ksyms_64.c  |    2 +-
 arch/x86/lib/copy_user_64.S       |    4 ++--
 3 files changed, 12 insertions(+), 4 deletions(-)

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
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index cd54276..a102976 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -31,7 +31,7 @@ EXPORT_SYMBOL(__put_user_8);
 EXPORT_SYMBOL(copy_user_generic);
 EXPORT_SYMBOL(__copy_user_nocache);
 EXPORT_SYMBOL(_copy_from_user);
-EXPORT_SYMBOL(copy_to_user);
+EXPORT_SYMBOL(_copy_to_user);
 
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
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
