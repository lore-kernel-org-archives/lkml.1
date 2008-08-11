Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYHKOje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYHKOje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYHKOjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:39:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYHKOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:39:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [RFC 1/3] add support for exporting symbols from .S files
Date: Mon, 11 Aug 2008 16:18:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       David Woodhouse <dwmw2@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, linuxppc-dev@ozlabs.org
References: <200808111606.44103.arnd@arndb.de>
In-Reply-To: <200808111606.44103.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808111618.08206.arnd@arndb.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19Gawkgsxg4R/bYmn8ZV0VZwIvPXGz16Ap02W0
 n72sp9d+6gyYOOHa188NCr4pBOg6aDJLuNGAOPt3/6emk3pRKJ
 MpjPRjawDp1YO9t8pZ/RQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to export symbols from assembly files, instead
of having to export them through an extra ksyms.c file.

I found this nicer to implement using a gas macro than a cpp macro.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -1,5 +1,7 @@
 #ifndef _LINUX_MODULE_H
 #define _LINUX_MODULE_H
+
+#ifndef __ASSEMBLY__
 /*
  * Dynamic loading of modules into the kernel.
  *
@@ -605,4 +607,54 @@ static inline void module_remove_modinfo_attrs(struct module *mod)
 
 #define __MODULE_STRING(x) __stringify(x)
 
+#else /* __ASSEMBLY__ */
+#include <asm/types.h>
+
+#ifdef CONFIG_MODULES
+.macro __EXPORT_SYMBOL sym section symtab strtab
+	.section \section,"a",@progbits
+	.type \symtab, @object
+	.ifeq BITS_PER_LONG-32
+	.align 3
+\symtab:
+	.long \sym
+	.long \strtab
+	.else
+	.align 4
+\symtab:
+	.quad \sym
+	.quad \strtab
+	.endif
+	.size \symtab,.-\symtab
+	.previous
+
+	.section __ksymtab_strings,"a",@progbits
+	.type \strtab, @object
+\strtab:
+	.string "\sym"
+	.size \strtab,.-\strtab
+	.previous
+	.endm
+
+#define EXPORT_SYMBOL(sym) \
+	 __EXPORT_SYMBOL sym,__ksymtab,__ksymtab_ ## sym,__kstrtab_ ## sym
+#define EXPORT_SYMBOL_GPL(sym) \
+	 __EXPORT_SYMBOL sym,__ksymtab_gpl,__ksymtab_ ## sym,__kstrtab_ ## sym
+#define EXPORT_SYMBOL_GPL_FUTURE(sym) \
+	 __EXPORT_SYMBOL sym,__ksymtab_gpl_future,__ksymtab_ ## sym,__kstrtab_ ## sym
+#define EXPORT_UNUSED_SYMBOL(sym) \
+	 __EXPORT_SYMBOL sym,__ksymtab_unused,__ksymtab_ ## sym,__kstrtab_ ## sym
+#define EXPORT_UNUSED_SYMBOL_GPL(sym) \
+	 __EXPORT_SYMBOL sym,__ksymtab_unused_gpl,__ksymtab_ ## sym,__kstrtab_ ## sym
+
+#else /* CONFIG_MODULES... */
+#define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
+#endif /* !CONFIG_MODULES... */
+
+#endif /* __ASSEMBLY__ */
+
 #endif /* _LINUX_MODULE_H */

