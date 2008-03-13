Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYCMJBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYCMJBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYCMJBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:01:42 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:26045
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbYCMJBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:01:38 -0400
Message-Id: <47D8FBA9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Thu, 13 Mar 2008 09:02:17 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] reduce module image and resident size
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resulting reduction (x86-64, gcc 4.1.2) with my (special purpose, i.e.
much reduced) configurations:
- 16k kernel resident size
- 180k module resident size 
- 10k module image size

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/linux/module.h |    2 +-
 kernel/module.c        |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.25-rc5/include/linux/module.h	2008-03-10 13:24:33.000000000 +0100
+++ 2.6.25-rc5-module-reduce-size/include/linux/module.h	2008-03-04 11:26:17.000000000 +0100
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
+++ 2.6.25-rc5-module-reduce-size/kernel/module.c	2008-03-04 11:26:17.000000000 +0100
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



