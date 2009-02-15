Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZBOSVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZBOSVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbZBOSUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:20:38 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:41661 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbZBOSUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:20:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LQ3ON5w0yqt9X4W6od/dQJUyU5t2yI+Tju0T2WN0gsGCEdioQc3Slrevu1riX2juhn
         HbL0PAYt2wpYZF1r2yUeurJCAdWn9wukRz7payBtCkAK/MdptYskajIo/rehJYTxw9xN
         UV4wSImiOp/h6m3tHZ/kYpnLgjVHCXOR1IwKQ=
From: Andreas Robinson <andr345@gmail.com>
To: sam@ravnborg.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/6] module: add module ELF section with module_init() pointer
Date: Sun, 15 Feb 2009 19:20:24 +0100
Message-Id: <1234722028-8110-3-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1234722028-8110-1-git-send-email-andr345@gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linker script will append this section to the end of the list
of initcalls so that init/main.c:do_initcalls() can find it.
---
 include/asm-generic/vmlinux.lds.h |    3 ++-
 include/linux/init.h              |   11 ++++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c61fab1..d3c0787 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -428,7 +428,8 @@
   	*(.initcall6.init)						\
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
-  	*(.initcall7s.init)
+  	*(.initcall7s.init)						\
+  	*(.mod_initcall.init)
 
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
diff --git a/include/linux/init.h b/include/linux/init.h
index 68cb026..62b854f 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -284,11 +284,20 @@ void __init parse_early_param(void);
 
 #define security_initcall(fn)		module_init(fn)
 
+#ifdef CONFIG_MODULE_STATIC
+#define module_initcall(fn) \
+	static initcall_t __initcall_##fn \
+	__used __section(.mod_initcall.init) = fn
+#else
+#define module_initcall(fn)
+#endif
+
 /* Each module must use one module_init(). */
 #define module_init(initfn)					\
 	static inline initcall_t __inittest(void)		\
 	{ return initfn; }					\
-	int init_module(void) __attribute__((alias(#initfn)));
+	int init_module(void) __attribute__((alias(#initfn)));	\
+	module_initcall(initfn);
 
 /* This is only required if you want to be unloadable. */
 #define module_exit(exitfn)					\
-- 
1.5.6.3

