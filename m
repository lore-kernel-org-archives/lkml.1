Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbYDSLFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbYDSLFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 07:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYDSLFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 07:05:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59278 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbYDSLFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 07:05:30 -0400
Date: Sat, 19 Apr 2008 20:04:50 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC patch 16/27] Immediate Values Support init
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20080416213553.343331418@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca> <20080416213553.343331418@polymtl.ca>
Message-Id: <20080419192334.A8FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #else
>  
> @@ -73,7 +76,9 @@ extern void imv_update_range(const struc
>  
>  static inline void core_imv_update(void) { }
>  static inline void module_imv_update(void) { }
> -
> +static inline void imv_unref_core_init(void) { }
> +static inline void imv_unref_init(struct __imv *begin, struct __imv *end,
> +		void *init, unsigned long init_size) { }
>  #endif

err.
When turn off CONFIG_IMMEDIATE, "struct __imv" is not defined.
is cause following warnings.

include/linux/immediate.h:81: warning: 'struct __imv' declared inside parameter list
include/linux/immediate.h:81: warning: its scope is only this definition or declaration, \
which is probably not what you want


and

> +extern void imv_unref(struct __imv *begin, struct __imv *end, void *start,
> +		unsigned long size);
>  
>  #else
>
> (snip)  
> +static inline void imv_unref_init(struct __imv *begin, struct __imv *end,
> +		void *init, unsigned long init_size) { }
>  #endif

if CONFIG_IMMEDIATE is on, imv_unref() is declared.
but if CONFIG_IMMEDIATE is off, imv_unref_init() is declared instead imv_unref()
it cause following error.


  CC      kernel/module.o
kernel/module.c: In function 'sys_init_module':
kernel/module.c:2211: error: implicit declaration of function 'imv_unref'
kernel/module.c:2211: error: 'struct module' has no member named 'immediate'
kernel/module.c:2211: error: 'struct module' has no member named 'immediate'
kernel/module.c:2211: error: 'struct module' has no member named 'num_immediate'
make[1]: *** [kernel/module.o] Error 1


and, 

in kernel/module.c#sys_init_module(),
immediate member of struct module is used though CONFIG_IMMEDIATE is off.

>        imv_unref(mod->immediate, mod->immediate + mod->num_immediate,
>                mod->module_init, mod->init_size);

it cause following error.

  CC      kernel/module.o
kernel/module.c: In function 'sys_init_module':
kernel/module.c:2211: error: 'struct module' has no member named 'immediate'
kernel/module.c:2211: error: 'struct module' has no member named 'immediate'
kernel/module.c:2211: error: 'struct module' has no member named 'num_immediate'
make[1]: *** [kernel/module.o] Error 1


bellow patch fixed these.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/immediate.h |    8 ++++++--
 include/linux/module.h    |   21 +++++++++++++++++++++
 kernel/module.c           |    3 ++-
 3 files changed, 29 insertions(+), 3 deletions(-)

Index: b/include/linux/immediate.h
===================================================================
--- a/include/linux/immediate.h	2008-04-19 19:53:03.000000000 +0900
+++ b/include/linux/immediate.h	2008-04-19 20:04:58.000000000 +0900
@@ -56,6 +56,10 @@ extern void imv_unref(struct __imv *begi
  * Generic immediate values: a simple, standard, memory load.
  */
 
+/* empty declaration for avoid warning */
+struct __imv {
+};
+
 /**
  * imv_read - read immediate variable
  * @name: immediate value name
@@ -77,8 +81,8 @@ extern void imv_unref(struct __imv *begi
 static inline void core_imv_update(void) { }
 static inline void module_imv_update(void) { }
 static inline void imv_unref_core_init(void) { }
-static inline void imv_unref_init(struct __imv *begin, struct __imv *end,
-		void *init, unsigned long init_size) { }
+static inline void imv_unref(struct __imv *begin, struct __imv *end,
+			     void *start, unsigned long size) { }
 #endif
 
 #define DECLARE_IMV(type, name) extern __typeof__(type) name##__imv
Index: b/include/linux/module.h
===================================================================
--- a/include/linux/module.h	2008-04-19 19:53:03.000000000 +0900
+++ b/include/linux/module.h	2008-04-19 20:22:14.000000000 +0900
@@ -634,4 +634,25 @@ static inline void module_remove_modinfo
 
 #define __MODULE_STRING(x) __stringify(x)
 
+#ifdef CONFIG_IMMEDIATE
+static inline struct __imv* mod_immediate_address(struct module* mod)
+{
+	return mod->immediate;
+}
+static inline unsigned int  mod_num_immediate(struct module* mod)
+{
+	return mod->num_immediate;
+}
+#else
+static inline struct __imv* mod_immediate_address(struct module* mod)
+{
+	return NULL;
+}
+static inline unsigned int  mod_num_immediate(struct module* mod)
+{
+	return 0;
+}
+#endif
+
+
 #endif /* _LINUX_MODULE_H */
Index: b/kernel/module.c
===================================================================
--- a/kernel/module.c	2008-04-19 19:53:03.000000000 +0900
+++ b/kernel/module.c	2008-04-19 20:23:51.000000000 +0900
@@ -2208,7 +2208,8 @@ sys_init_module(void __user *umod,
 	/* Drop initial reference. */
 	module_put(mod);
 	unwind_remove_table(mod->unwind_info, 1);
-	imv_unref(mod->immediate, mod->immediate + mod->num_immediate,
+	imv_unref(mod_immediate_address(mod),
+		  mod_immediate_address(mod) + mod_num_immediate(mod),
 		mod->module_init, mod->init_size);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;



