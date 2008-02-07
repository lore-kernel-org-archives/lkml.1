Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbYBGSeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbYBGSeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYBGSdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:33:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbYBGSdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:33:53 -0500
Message-ID: <47AB4F0E.3050907@redhat.com>
Date: Thu, 07 Feb 2008 13:33:50 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: section breakage on ppc64 (aka __devinitconst is broken by design)
References: <20080203130844.GS27894@ZenIV.linux.org.uk>
In-Reply-To: <20080203130844.GS27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2008 08:08 AM, Al Viro wrote:
>
> The reason why it didn't visibly bite us before is that usually __devinit...
> just expanded to nothing (unless you disable HOTPLUG, which requires
> EMBEDDED, which wasn't apparently common enough for ppc64 builds).
>
> Suggestions?

This ugly hackset was needed to get 2.6.24 to build with GCC 4.3. It would
be nice to get a real fix...


--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -62,6 +62,15 @@ struct kparam_array
 	void *elem;
 };

+/* On some platforms relocations to global data cannot go into read-only
+   sections, so 'const' makes no sense and even causes compile failures
+   with some compilers. */
+#if defined(CONFIG_ALPHA) || defined(CONFIG_IA64) || defined(CONFIG_PPC64)
+#define __moduleparam_const
+#else
+#define __moduleparam_const const
+#endif
+
 /* This is the fundamental function for registering boot/module
    parameters.  perm sets the visibility in sysfs: 000 means it's
    not there, read bits mean it's readable, write bits mean it's
@@ -71,7 +80,7 @@ struct kparam_array
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
 	static const char __param_str_##name[] = prefix #name;		\
-	static struct kernel_param const __param_##name			\
+	static struct kernel_param __moduleparam_const __param_##name	\
 	__attribute_used__						\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
 	= { __param_str_##name, perm, set, get, { arg } }
--- linux-2.6.24.noarch.orig/include/linux/module.h
+++ linux-2.6.24.noarch/include/linux/module.h
@@ -30,6 +30,15 @@

 #define MODULE_NAME_LEN (64 - sizeof(unsigned long))

+/* On some platforms relocations to global data cannot go into read-only
+   sections, so 'const' makes no sense and even causes compile failures
+   with some compilers. */
+#if defined(CONFIG_ALPHA) || defined(CONFIG_IA64) || defined(CONFIG_PPC64)
+#define __ksym_const
+#else
+#define __ksym_const const
+#endif
+
 struct kernel_symbol
 {
 	unsigned long value;
@@ -192,7 +201,7 @@ void *__symbol_get_gpl(const char *symbo
 	static const char __kstrtab_##sym[]			\
 	__attribute__((section("__ksymtab_strings")))		\
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
-	static const struct kernel_symbol __ksymtab_##sym	\
+	static __ksym_const struct kernel_symbol __ksymtab_##sym	\
 	__attribute_used__					\
 	__attribute__((section("__ksymtab" sec), unused))	\
 	= { (unsigned long)&sym, __kstrtab_##sym }
