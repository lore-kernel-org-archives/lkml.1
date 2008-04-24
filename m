Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYDXFBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYDXFBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 01:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYDXFB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:01:26 -0400
Received: from ozlabs.org ([203.10.76.45]:37183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYDXFBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:01:25 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 24 Apr 2008 00:01:15 -0500
Subject: [PATCH 2/6] reduce module image and resident size
Cc: Jan Beulich <jbeulich@novell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241501.16116.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resulting reduction (x86-64, gcc 4.1.2) with my (special purpose, i.e.
much reduced) configurations:
- 16k kernel resident size
- 180k module resident size 
- 10k module image size

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |    2 +-
 kernel/module.c        |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -u
--- linux-2.6.25-rc5/include/linux/module.h	2008-03-10 13:24:33.000000000 
+0100
+++ 2.6.25-rc5-module-reduce-size/include/linux/module.h	2008-03-04 
11:26:17.000000000 +0100
@@ -190,7 +190,7 @@ void *__symbol_get_gpl(const char *symbo
 	extern typeof(sym) sym;					\
 	__CRC_SYMBOL(sym, sec)					\
 	static const char __kstrtab_##sym[]			\
-	__attribute__((section("__ksymtab_strings")))		\
+	__attribute__((section("__ksymtab_strings"), aligned(1))) \
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
 	static const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
--- linux-2.6.25-rc5/kernel/module.c	2008-03-10 13:24:35.000000000 +0100
+++ 2.6.25-rc5-module-reduce-size/kernel/module.c	2008-03-04 
11:26:17.000000000 +0100
@@ -1815,8 +1815,9 @@ static struct module *load_module(void _
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
 
-	/* Don't keep modinfo section */
+	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	sechdrs[versindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #ifdef CONFIG_KALLSYMS
 	/* Keep symbol and string tables for decoding later. */
 	sechdrs[symindex].sh_flags |= SHF_ALLOC;



--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


