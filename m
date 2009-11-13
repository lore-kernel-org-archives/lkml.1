Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZKML4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZKML4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZKML4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:56:19 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54273 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZKML4S convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Fri, 13 Nov 2009 06:56:18 -0500
Message-Id: <4AFD5778020000780001F8F4@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 13 Nov 2009 11:56:24 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, <v.mayatskih@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: __copy_from_user_inatomic() adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ad2fc2cd925300b8127cf682f5a1c7511ae9dd27 rendered
__copy_from_user_inatomic() identical to copy_user_generic(), yet
didn't make the former just call the latter from an inline function.

Commit b885808e185a4ec2dfe16c84434f79e95f0245b0 converted the return
type of __copy_to_user_inatomic() from unsigned long to int, but didn't
do the same to __copy_from_user_inatomic()

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>

---
 arch/x86/include/asm/uaccess_64.h |    7 +++++--
 arch/x86/kernel/x8664_ksyms_64.c  |    1 -
 arch/x86/lib/copy_user_64.S       |    6 ------
 3 files changed, 5 insertions(+), 9 deletions(-)

--- linux-2.6.32-rc7/arch/x86/include/asm/uaccess_64.h	2009-09-10 00:13:59.000000000 +0200
+++ 2.6.32-rc7-x86_64-copy_from_user_inatomic/arch/x86/include/asm/uaccess_64.h	2009-11-10 13:54:10.000000000 +0100
@@ -176,8 +176,11 @@ __must_check long strlen_user(const char
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
--- linux-2.6.32-rc7/arch/x86/kernel/x8664_ksyms_64.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.32-rc7-x86_64-copy_from_user_inatomic/arch/x86/kernel/x8664_ksyms_64.c	2009-11-10 12:47:22.000000000 +0100
@@ -32,7 +32,6 @@ EXPORT_SYMBOL(copy_user_generic);
 EXPORT_SYMBOL(__copy_user_nocache);
 EXPORT_SYMBOL(copy_from_user);
 EXPORT_SYMBOL(copy_to_user);
-EXPORT_SYMBOL(__copy_from_user_inatomic);
 
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
--- linux-2.6.32-rc7/arch/x86/lib/copy_user_64.S	2009-09-10 00:13:59.000000000 +0200
+++ 2.6.32-rc7-x86_64-copy_from_user_inatomic/arch/x86/lib/copy_user_64.S	2009-11-10 12:43:14.000000000 +0100
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



