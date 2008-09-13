Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbYIMEx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbYIMEx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 00:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYIMEwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 00:52:54 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37682 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbYIMEwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 00:52:53 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC PATCH 4/9] Ksplice: Make needed symbol and module functions global
Date: Sat, 13 Sep 2008 00:49:50 -0400
Message-Id: <401afda17296e380049b129c92a9ae27e8e47fc3.1221280912.git.jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <bdf8d7b52e2cb9ff3bbed52cedd28294086c9f56.1221280912.git.jbarnold@mit.edu>
References: <1221281397-7045-1-git-send-email-jbarnold@mit.edu>
 <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
 <8cfda1c8f6c46e2f0fa9e9279aa2b2a213fba7a4.1221280912.git.jbarnold@mit.edu>
 <bdf8d7b52e2cb9ff3bbed52cedd28294086c9f56.1221280912.git.jbarnold@mit.edu>
In-Reply-To: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
References: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@mit.edu>

Make module_mutex, find_module(), find_symbol(), and use_module()
global.  Ksplice needs access to these functions from module.c in
order to resolve symbols and implement dependency handling.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 include/linux/module.h |   13 +++++++++++++
 kernel/module.c        |   18 +++++++++---------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index cd982cd..6ae0fc9 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -351,6 +351,8 @@ struct module
 #define MODULE_ARCH_INIT {}
 #endif
 
+extern struct mutex module_mutex;
+
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
    (IDE & SCSI) require entry into the module during init.*/
@@ -366,6 +368,16 @@ struct module *module_data_address(unsigned long addr);
 struct module *__module_data_address(unsigned long addr);
 int is_module_address(unsigned long addr);
 
+/* Search for module by name: must hold module_mutex. */
+struct module *find_module(const char *name);
+
+/* Search for an exported symbol by name. */
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn);
+
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
@@ -431,6 +443,7 @@ static inline void __module_get(struct module *module)
 #define symbol_put_addr(p) do { } while(0)
 
 #endif /* CONFIG_MODULE_UNLOAD */
+int use_module(struct module *a, struct module *b);
 
 /* This is a #define so the string doesn't get put in every .o file */
 #define module_name(mod)			\
diff --git a/kernel/module.c b/kernel/module.c
index 343c8f8..2acb646 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -62,7 +62,7 @@
 
 /* List of modules, protected by module_mutex or preempt_disable
  * (add/delete uses stop_machine). */
-static DEFINE_MUTEX(module_mutex);
+DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
 
 /* Waiting for a module to finish initializing? */
@@ -301,11 +301,11 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 
 /* Find a symbol and return it, along with, (optional) crc and
  * (optional) module which owns it */
-static const struct kernel_symbol *find_symbol(const char *name,
-					       struct module **owner,
-					       const unsigned long **crc,
-					       bool gplok,
-					       bool warn)
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn)
 {
 	struct find_symbol_arg fsa;
 
@@ -326,7 +326,7 @@ static const struct kernel_symbol *find_symbol(const char *name,
 }
 
 /* Search for module by name: must hold module_mutex. */
-static struct module *find_module(const char *name)
+struct module *find_module(const char *name)
 {
 	struct module *mod;
 
@@ -579,7 +579,7 @@ static int already_uses(struct module *a, struct module *b)
 }
 
 /* Module a uses b */
-static int use_module(struct module *a, struct module *b)
+int use_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
 	int no_warn, err;
@@ -874,7 +874,7 @@ static inline void module_unload_free(struct module *mod)
 {
 }
 
-static inline int use_module(struct module *a, struct module *b)
+int use_module(struct module *a, struct module *b)
 {
 	return strong_try_module_get(b) == 0;
 }
-- 
1.5.4.3

