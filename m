Return-Path: <linux-kernel-owner+w=401wt.eu-S1763903AbXEUKpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763903AbXEUKpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbXEUKpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:45:32 -0400
Received: from [216.16.235.2] ([216.16.235.2]:47344 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757872AbXEUKpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:45:31 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 21 May 2007 06:43:50 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Clean up the contents of module.h and moduleparam.h.
Message-ID: <Pine.LNX.4.64.0705210523180.30935@localhost.localdomain>
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


Shift the contents of module.h and moduleparam.h so that generic
module content is exclusively in module.h, while parameter-specific
content is in moduleparam.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

while this patch makes the contents of module.h and moduleparam.h
somewhat more organized, it still has the weird property that each of
those two files includes the other.  given the current state of
includes throughout the source tree, there's not much that can be done
about that at the moment.

compile-tested with "make allmodconfig" on x86.

 include/linux/module.h      |   19 +++++++++++++------
 include/linux/moduleparam.h |   16 +++++-----------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index e6e0f86..442d3bf 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -15,7 +15,7 @@
 #include <linux/elf.h>
 #include <linux/stringify.h>
 #include <linux/kobject.h>
-#include <linux/moduleparam.h>
+#include <linux/moduleparam.h>	/* In a perfect world, this wouldn't be here. */
 #include <asm/local.h>

 #include <asm/module.h>
@@ -88,6 +88,17 @@ extern struct module __this_module;
 #define THIS_MODULE ((struct module *)0)
 #endif

+#ifdef MODULE
+#define ___module_cat(a,b) __mod_ ## a ## b
+#define __module_cat(a,b) ___module_cat(a,b)
+#define __MODULE_INFO(tag, name, info)					\
+static const char __module_cat(name,__LINE__)[]				\
+  __maybe_unused							\
+  __attribute__((section(".modinfo"))) = __stringify(tag) "=" info
+#else  /* !MODULE */
+#define __MODULE_INFO(tag, name, info)
+#endif
+
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)

@@ -130,11 +141,6 @@ extern struct module __this_module;
 /* What your module does. */
 #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)

-/* One for each parameter, describing how to use it.  Some files do
-   multiple of these per line, so can't just use MODULE_INFO. */
-#define MODULE_PARM_DESC(_parm, desc) \
-	__MODULE_INFO(parm, _parm, #_parm ":" desc)
-
 #define MODULE_DEVICE_TABLE(type,name)		\
   MODULE_GENERIC_TABLE(type##_device,name)

@@ -576,6 +582,7 @@ struct device_driver;
 struct module;

 extern struct kset module_subsys;
+struct kernel_param;

 int mod_sysfs_init(struct module *mod);
 int mod_sysfs_setup(struct module *mod,
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index c83588c..e8f5960 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -4,6 +4,7 @@
 #include <linux/init.h>
 #include <linux/stringify.h>
 #include <linux/kernel.h>
+#include <linux/module.h>

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
+#define __MODULE_PARM_TYPE(name, _type)			\
   __MODULE_INFO(parmtype, name##type, #name ":" _type)

+#define MODULE_PARM_DESC(_parm, desc)			\
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
