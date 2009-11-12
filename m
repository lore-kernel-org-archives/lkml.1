Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZKLNPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZKLNPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZKLNPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:15:50 -0500
Received: from ozlabs.org ([203.10.76.45]:56700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZKLNPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:15:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build warning
Date: Thu, 12 Nov 2009 23:45:48 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
References: <20091112192114.dcf32d16.sfr@canb.auug.org.au>
In-Reply-To: <20091112192114.dcf32d16.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911122345.49100.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 06:51:14 pm Stephen Rothwell wrote:
> Hi Rusty,
> 
> Today's linux-next build (i386 defconfig) produced this warning:
> 
> kernel/module.c:1953: warning: 'crc_section_names' defined but not used
> 
> Introduced by commit 67260d90118a2394df528fe4e37e814d950ca5b5 ("module:
> refactor symbol tables and try to reduce code size of each_symbol()").
> This build has CONFIG_MODVERSIONS disabled.

Thanks.  I hit that warning in my config too, but didn't notice :(

Subject: Fix warning for CONFIG_MODVERSIONS=n:

linux-next Maestro Stephen Rothwell reports:
	Today's linux-next build (i386 defconfig) produced this warning:

	kernel/module.c:1953: warning: 'crc_section_names' defined but not used

	Introduced by commit 67260d90118a2394df528fe4e37e814d950ca5b5 ("module:
	refactor symbol tables and try to reduce code size of each_symbol()").
	This build has CONFIG_MODVERSIONS disabled.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1075,6 +1075,16 @@ static int try_to_force_load(struct modu
 }
 
 #ifdef CONFIG_MODVERSIONS
+static const char *crc_section_names[] = {
+	[EXPORT_TYPE_PLAIN] = "__kcrctab",
+	[EXPORT_TYPE_GPL] = "__kcrctab_gpl",
+#ifdef CONFIG_UNUSED_SYMBOLS
+	[EXPORT_TYPE_UNUSED] = "__kcrctab_unused",
+	[EXPORT_TYPE_UNUSED_GPL] = "__kcrctab_unused_gpl",
+#endif
+	[EXPORT_TYPE_GPL_FUTURE] = "__kcrctab_gpl_future",
+};
+
 static int check_version(Elf_Shdr *sechdrs,
 			 unsigned int versindex,
 			 const char *symname,
@@ -2103,16 +2113,6 @@ static const char *export_section_names[
 	[EXPORT_TYPE_GPL_FUTURE] = "__ksymtab_gpl_future",
 };
 
-static const char *crc_section_names[] = {
-	[EXPORT_TYPE_PLAIN] = "__kcrctab",
-	[EXPORT_TYPE_GPL] = "__kcrctab_gpl",
-#ifdef CONFIG_UNUSED_SYMBOLS
-	[EXPORT_TYPE_UNUSED] = "__kcrctab_unused",
-	[EXPORT_TYPE_UNUSED_GPL] = "__kcrctab_unused_gpl",
-#endif
-	[EXPORT_TYPE_GPL_FUTURE] = "__kcrctab_gpl_future",
-};
-
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
