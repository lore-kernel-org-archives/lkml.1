Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZA2Ttc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZA2Ttc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZA2TtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:49:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:60293 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZA2TtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:49:22 -0500
Message-ID: <4982083E.50200@ct.jp.nec.com>
Date: Thu, 29 Jan 2009 11:49:18 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: uaccess: fix compilation error on CONFIG_M386
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: fix compilation error

In case of !CONFIG_X86_WP_WORKS_OK, __put_user_size_ex() is not defined.
Add macros for !CONFIG_X86_WP_WORKS_OK case.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/uaccess.h |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 0ec6de4..b9a2415 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -525,8 +525,6 @@ struct __large_struct { unsigned long buf[100]; };
  */
 #define get_user_try		uaccess_try
 #define get_user_catch(err)	uaccess_catch(err)
-#define put_user_try		uaccess_try
-#define put_user_catch(err)	uaccess_catch(err)
 
 #define get_user_ex(x, ptr)	do {					\
 	unsigned long __gue_val;					\
@@ -534,9 +532,29 @@ struct __large_struct { unsigned long buf[100]; };
 	(x) = (__force __typeof__(*(ptr)))__gue_val;			\
 } while (0)
 
+#ifdef CONFIG_X86_WP_WORKS_OK
+
+#define put_user_try		uaccess_try
+#define put_user_catch(err)	uaccess_catch(err)
+
 #define put_user_ex(x, ptr)						\
 	__put_user_size_ex((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
+#else /* !CONFIG_X86_WP_WORKS_OK */
+
+#define put_user_try		do {		\
+	int __uaccess_err = 0;
+
+#define put_user_catch(err)			\
+	(err) |= __uaccess_err;			\
+} while (0)
+
+#define put_user_ex(x, ptr)	do {		\
+	__uaccess_err |= __put_user(x, ptr);	\
+} while (0)
+
+#endif /* CONFIG_X86_WP_WORKS_OK */
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
-- 
1.6.0.4

