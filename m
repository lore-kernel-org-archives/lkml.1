Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbYEIGZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbYEIGZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYEIGZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:25:32 -0400
Received: from ozlabs.org ([203.10.76.45]:42833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbYEIGZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:25:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] module: don't ignore vermagic string if module doesn't have modversions
Date: Fri, 9 May 2008 16:25:28 +1000
User-Agent: KMail/1.9.9
Cc: Jon Masters <jonathan@jonmasters.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200805091623.18127.rusty@rustcorp.com.au> <200805091624.21659.rusty@rustcorp.com.au>
In-Reply-To: <200805091624.21659.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805091625.28705.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus found a logic bug: we ignore the version number in a module's
vermagic string if we have CONFIG_MODVERSIONS set, but modversions
also lets through a module with no __versions section for modprobe
--force (with tainting, but still).

We should only ignore the start of the vermagic string if the module
actually *has* crcs to check.  Rather than (say) having an
entertaining hissy fit and creating a config option to work around the
buggy code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 init/Kconfig    |    6 +++---
 kernel/module.c |   16 ++++++++++------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -r 8805b380fdff init/Kconfig
--- a/init/Kconfig	Thu May 08 21:14:37 2008 +1000
+++ b/init/Kconfig	Thu May 08 21:16:20 2008 +1000
@@ -837,9 +837,9 @@ config MODULE_FORCE_LOAD
 	depends on MODULES
 	default n
 	help
-	  This option allows loading of modules even if that would set the
-          'F' (forced) taint, due to lack of version info.  Which is
-	  usually a really bad idea.
+	  Allow loading of modules without version information (ie. modprobe
+	  --force).  Forced module loading sets the 'F' (forced) taint flag and
+	  is usually a really bad idea.
 
 config MODULE_UNLOAD
 	bool "Module unloading"
diff -r 8805b380fdff kernel/module.c
--- a/kernel/module.c	Thu May 08 21:14:37 2008 +1000
+++ b/kernel/module.c	Thu May 08 21:16:20 2008 +1000
@@ -956,11 +956,14 @@ static inline int check_modstruct_versio
 	return check_version(sechdrs, versindex, "struct_module", mod, crc);
 }
 
-/* First part is kernel version, which we ignore. */
-static inline int same_magic(const char *amagic, const char *bmagic)
+/* First part is kernel version, which we ignore if module has crcs. */
+static inline int same_magic(const char *amagic, const char *bmagic,
+			     bool has_crcs)
 {
-	amagic += strcspn(amagic, " ");
-	bmagic += strcspn(bmagic, " ");
+	if (has_crcs) {
+		amagic += strcspn(amagic, " ");
+		bmagic += strcspn(bmagic, " ");
+	}
 	return strcmp(amagic, bmagic) == 0;
 }
 #else
@@ -980,7 +983,8 @@ static inline int check_modstruct_versio
 	return 1;
 }
 
-static inline int same_magic(const char *amagic, const char *bmagic)
+static inline int same_magic(const char *amagic, const char *bmagic,
+			     bool has_crcs)
 {
 	return strcmp(amagic, bmagic) == 0;
 }
@@ -1873,7 +1877,7 @@ static struct module *load_module(void _
 		err = try_to_force_load(mod, "magic");
 		if (err)
 			goto free_hdr;
-	} else if (!same_magic(modmagic, vermagic)) {
+	} else if (!same_magic(modmagic, vermagic, versindex)) {
 		printk(KERN_ERR "%s: version magic '%s' should be '%s'\n",
 		       mod->name, modmagic, vermagic);
 		err = -ENOEXEC;
