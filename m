Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZKOKaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZKOKaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZKOKaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:30:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:46995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZKOKaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:30:12 -0500
Date: Sun, 15 Nov 2009 10:28:52 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, arjan@infradead.org, jbeulich@novell.com,
       v.mayatskih@gmail.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, arjan@infradead.org, jbeulich@novell.com,
       JBeulich@novell.com, v.mayatskih@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AFD5778020000780001F8F4@vpn.id2.novell.com>
References: <4AFD5778020000780001F8F4@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: __copy_from_user_inatomic() adjustments
Message-ID: <tip-14722485830fe6baba738b91d96f06fbd6cf7a18@git.kernel.org>
Git-Commit-ID: 14722485830fe6baba738b91d96f06fbd6cf7a18
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14722485830fe6baba738b91d96f06fbd6cf7a18
Gitweb:     http://git.kernel.org/tip/14722485830fe6baba738b91d96f06fbd6cf7a18
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 13 Nov 2009 11:56:24 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Nov 2009 09:29:47 +0100

x86-64: __copy_from_user_inatomic() adjustments

This v2.6.26 commit:

    ad2fc2c: x86: fix copy_user on x86

rendered __copy_from_user_inatomic() identical to
copy_user_generic(), yet didn't make the former just call the
latter from an inline function.

Furthermore, this v2.6.19 commit:

    b885808: [PATCH] Add proper sparse __user casts to __copy_to_user_inatomic

converted the return type of __copy_to_user_inatomic() from
unsigned long to int, but didn't do the same to
__copy_from_user_inatomic().

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <v.mayatskih@gmail.com>
LKML-Reference: <4AFD5778020000780001F8F4@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uaccess_64.h |    7 +++++--
 arch/x86/kernel/x8664_ksyms_64.c  |    1 -
 arch/x86/lib/copy_user_64.S       |    6 ------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index ce6fec7..7adebac 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -193,8 +193,11 @@ __must_check long strlen_user(const char __user *str);
 __must_check unsigned long clear_user(void __user *mem, unsigned long len);
 __must_check unsigned long __clear_user(void __user *mem, unsigned long len);
 
-__must_check long __copy_from_user_inatomic(void *dst, const void __user *src,
-					    unsigned size);
+static __must_check __always_inline int
+__copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
+{
+	return copy_user_generic(dst, (__force const void *)src, size);
+}
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index a0cdd8c..cd54276 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -32,7 +32,6 @@ EXPORT_SYMBOL(copy_user_generic);
 EXPORT_SYMBOL(__copy_user_nocache);
 EXPORT_SYMBOL(_copy_from_user);
 EXPORT_SYMBOL(copy_to_user);
-EXPORT_SYMBOL(__copy_from_user_inatomic);
 
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 4be3c41..3936998 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -96,12 +96,6 @@ ENTRY(copy_user_generic)
 	CFI_ENDPROC
 ENDPROC(copy_user_generic)
 
-ENTRY(__copy_from_user_inatomic)
-	CFI_STARTPROC
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
-	CFI_ENDPROC
-ENDPROC(__copy_from_user_inatomic)
-
 	.section .fixup,"ax"
 	/* must zero dest */
 ENTRY(bad_from_user)
