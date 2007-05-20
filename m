Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbXETTHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbXETTHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXETTHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:07:40 -0400
Received: from [216.16.235.2] ([216.16.235.2]:51855 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbXETTHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:07:39 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 20 May 2007 15:06:15 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Factor out common MODULE_INFO content from module*.h files.
Message-ID: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In order to eventually break the interdependency between the module.h
and moduleparam.h header files, factor out the common MODULE_INFO
content into a new header file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this patch doesn't actually start cleaning up the mess related to
module.h and moduleparam.h files, but it at least allows that cleanup
process to start.  a major goal would be to eventually remove that
inclusion of moduleparam.h from module.h, which simply shouldn't be
there.

  compile-tested with "make allmodconfig" on x86.


 include/linux/module.h      |   12 +++---------
 include/linux/moduleparam.h |   16 +++++-----------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index e6e0f86..d9a9a13 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -15,7 +15,8 @@
 #include <linux/elf.h>
 #include <linux/stringify.h>
 #include <linux/kobject.h>
-#include <linux/moduleparam.h>
+#include <linux/moduleparam.h>	/* Ideally, this shouldn't be necessary. */
+#include <linux/moduleinfo.h>
 #include <asm/local.h>

 #include <asm/module.h>
@@ -88,9 +89,6 @@ extern struct module __this_module;
 #define THIS_MODULE ((struct module *)0)
 #endif

-/* Generic info of form tag = "info" */
-#define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
-
 /* For userspace: you can also call me... */
 #define MODULE_ALIAS(_alias) MODULE_INFO(alias, _alias)

@@ -130,11 +128,6 @@ extern struct module __this_module;
 /* What your module does. */
 #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)

-/* One for each parameter, describing how to use it.  Some files do
-   multiple of these per line, so can't just use MODULE_INFO. */
-#define MODULE_PARM_DESC(_parm, desc) \
-	__MODULE_INFO(parm, _parm, #_parm ":" desc)
-
 #define MODULE_DEVICE_TABLE(type,name)		\
   MODULE_GENERIC_TABLE(type##_device,name)

@@ -576,6 +569,7 @@ struct device_driver;
 struct module;

 extern struct kset module_subsys;
+struct kernel_param;

 int mod_sysfs_init(struct module *mod);
 int mod_sysfs_setup(struct module *mod,
diff --git a/include/linux/moduleinfo.h b/include/linux/moduleinfo.h
new file mode 100644
index 0000000..cd9937b
--- /dev/null
+++ b/include/linux/moduleinfo.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_MODULEINFO_H
+#define _LINUX_MODULEINFO_H
+
+#ifdef MODULE
+#include <linux/stringify.h>
+#define ___module_cat(a,b) __mod_ ## a ## b
+#define __module_cat(a,b) ___module_cat(a,b)
+#define __MODULE_INFO(tag, name, info)				\
+static const char __module_cat(name,__LINE__)[]			\
+  __maybe_unused						\
+  __attribute__((section(".modinfo"))) = __stringify(tag) "=" info
+#else  /* !MODULE */
+#define __MODULE_INFO(tag, name, info)
+#endif
+
+#define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
+
+#endif // _LINUX_MODULEINFO_H
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index c83588c..650328d 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -4,6 +4,7 @@
 #include <linux/init.h>
 #include <linux/stringify.h>
 #include <linux/kernel.h>
+#include <linux/moduleinfo.h>

 /* You can override this manually, but generally this should match the
    module name. */
@@ -13,19 +14,12 @@
 #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
 #endif

-#ifdef MODULE
-#define ___module_cat(a,b) __mod_ ## a ## b
-#define __module_cat(a,b) ___module_cat(a,b)
-#define __MODULE_INFO(tag, name, info)					  \
-static const char __module_cat(name,__LINE__)[]				  \
-  __attribute_used__							  \
-  __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
-#else  /* !MODULE */
-#define __MODULE_INFO(tag, name, info)
-#endif
-#define __MODULE_PARM_TYPE(name, _type)					  \
+#define __MODULE_PARM_TYPE(name, _type)					\
   __MODULE_INFO(parmtype, name##type, #name ":" _type)

+#define MODULE_PARM_DESC(_parm, desc)					\
+  __MODULE_INFO(parm, _parm, #_parm ":" desc)
+
 struct kernel_param;

 /* Returns 0, or -errno.  arg is in kp->arg. */

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
