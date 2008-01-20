Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYATULe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYATULe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbYATUJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:09:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39131 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003AbYATUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:09:11 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] compiler.h: introduce __section()
Date: Sun, 20 Jan 2008 21:09:02 +0100
Message-Id: <1200859743-24037-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1200859743-24037-6-git-send-email-sam@ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org>
 <1200859743-24037-1-git-send-email-sam@ravnborg.org>
 <1200859743-24037-2-git-send-email-sam@ravnborg.org>
 <1200859743-24037-3-git-send-email-sam@ravnborg.org>
 <1200859743-24037-4-git-send-email-sam@ravnborg.org>
 <1200859743-24037-5-git-send-email-sam@ravnborg.org>
 <1200859743-24037-6-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new helper: __section() that makes a section definition
much shorter and more readable.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 include/linux/compiler.h |    5 +++++
 include/linux/init.h     |   26 +++++++++++++-------------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c68b67b..e0114a6 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -175,4 +175,9 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #define __cold
 #endif
 
+/* Simple shorthand for a section definition */
+#ifndef __section
+# define __section(S) __attribute__ ((__section__(#S)))
+#endif
+
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/init.h b/include/linux/init.h
index 5141381..9980768 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -40,10 +40,10 @@
 
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
-#define __init		__attribute__ ((__section__ (".init.text"))) __cold
-#define __initdata	__attribute__ ((__section__ (".init.data")))
-#define __exitdata	__attribute__ ((__section__(".exit.data")))
-#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
+#define __init		__section(.init.text) __cold
+#define __initdata	__section(.init.data)
+#define __exitdata	__section(.exit.data)
+#define __exit_call	__attribute_used__ __section(.exitcall.exit)
 
 /* modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
@@ -55,14 +55,14 @@
  * the init/exit section (code or data) is valid and will teach modpost
  * not to issue a warning.
  * The markers follow same syntax rules as __init / __initdata. */
-#define __init_refok     noinline __attribute__ ((__section__ (".text.init.refok")))
-#define __initdata_refok          __attribute__ ((__section__ (".data.init.refok")))
-#define __exit_refok     noinline __attribute__ ((__section__ (".exit.text.refok")))
+#define __init_refok     noinline __section(.text.init.refok)
+#define __initdata_refok          __section(.data.init.refok)
+#define __exit_refok     noinline __section(.exit.text.refok)
 
 #ifdef MODULE
-#define __exit		__attribute__ ((__section__(".exit.text"))) __cold
+#define __exit		__section(.exit.text) __cold
 #else
-#define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text"))) __cold
+#define __exit		__attribute_used__ __section(.exit.text) __cold
 #endif
 
 /* For assembly routines */
@@ -142,11 +142,11 @@ void prepare_namespace(void);
 
 #define console_initcall(fn) \
 	static initcall_t __initcall_##fn \
-	__attribute_used__ __attribute__((__section__(".con_initcall.init")))=fn
+	__attribute_used__ __section(.con_initcall.init)=fn
 
 #define security_initcall(fn) \
 	static initcall_t __initcall_##fn \
-	__attribute_used__ __attribute__((__section__(".security_initcall.init"))) = fn
+	__attribute_used__ __section(.security_initcall.init) = fn
 
 struct obs_kernel_param {
 	const char *str;
@@ -164,7 +164,7 @@ struct obs_kernel_param {
 	static char __setup_str_##unique_id[] __initdata __aligned(1) = str; \
 	static struct obs_kernel_param __setup_##unique_id	\
 		__attribute_used__				\
-		__attribute__((__section__(".init.setup")))	\
+		__section(.init.setup)				\
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }
 
@@ -242,7 +242,7 @@ void __init parse_early_param(void);
 #endif
 
 /* Data marked not to be saved by software suspend */
-#define __nosavedata __attribute__ ((__section__ (".data.nosave")))
+#define __nosavedata __section(.data.nosave)
 
 /* This means "can be init if no module support, otherwise module load
    may call it." */
-- 
1.5.4.rc3.14.g44397

