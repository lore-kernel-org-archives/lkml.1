Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXJYLBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXJYLBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbXJYLBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:01:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49170 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbXJYLBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:01:16 -0400
Date: Thu, 25 Oct 2007 13:02:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Permit silencing of __deprecated warnings.
Message-ID: <20071025110250.GC10536@uranus.ravnborg.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:06:13AM -0400, Jeff Garzik wrote:
> The __deprecated marker is quite useful in highlighting the remnants of
> old APIs that want removing.
> 
> However, it is quite normal for one or more years to pass, before the
> (usually ancient, bitrotten) code in question is either updated or
> deleted.

Reminded me of a patch I have had floating around for far too long time.

Snippet from the mail:
--------------------------
From: Arnd Bergmann <arnd@arndb.de>

On Sünndag 07 August 2005 20:26, Martin J. Bligh wrote:
> Oh, I'm being an idiot and looking at the wrong tree. It's __deprecated,
> but I still can't think of a clean way to locally undefine that for
> just EXPORT_SYMBOL.

We could in theory create a new EXPORT_SYMBOL variant that does not
reference the symbol directly. This does a little less compile-time
checks but helps reduce the noise. The big advantage of this
would be that we could once again build kernels with -Werror on
developer machines.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -182,21 +182,26 @@ void *__symbol_get_gpl(const char *symbo
 #endif
 
 /* For every exported symbol, place a struct in the __ksymtab section */
-#define __EXPORT_SYMBOL(sym, sec)				\
-	__CRC_SYMBOL(sym, sec)					\
-	static const char __kstrtab_##sym[]			\
+#define __EXPORT_SYMBOL(name, sym, sec)				\
+	__CRC_SYMBOL(name, sec)					\
+	static const char __kstrtab_##name[]			\
 	__attribute__((section("__ksymtab_strings")))		\
-	= MODULE_SYMBOL_PREFIX #sym;                    	\
-	static const struct kernel_symbol __ksymtab_##sym	\
+	= MODULE_SYMBOL_PREFIX #name;                    	\
+	static const struct kernel_symbol __ksymtab_##name	\
 	__attribute_used__					\
 	__attribute__((section("__ksymtab" sec), unused))	\
-	= { (unsigned long)&sym, __kstrtab_##sym }
+	= { (unsigned long)&sym, __kstrtab_##name }
 
 #define EXPORT_SYMBOL(sym)					\
-	__EXPORT_SYMBOL(sym, "")
+	__EXPORT_SYMBOL(sym, sym, "")
 
 #define EXPORT_SYMBOL_GPL(sym)					\
-	__EXPORT_SYMBOL(sym, "_gpl")
+	__EXPORT_SYMBOL(sym, sym, "_gpl")
+
+#define EXPORT_DEPRECATED_SYMBOL(sym)				\
+	extern void __deprecated_ ## sym 			\
+			__attribute__((alias(#sym)));		\
+	__EXPORT_SYMBOL(sym, __deprecated_ ## sym, "_gpl")
 
 #endif
 
------------------------

Obviously it does not apply today but it does not make sense
to warn about the old API symbol being exported.
Do you see something wrong in the approach Arnd used?

I just never came around to look at it.

	Sam
