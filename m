Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYDSNYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYDSNYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYDSNYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:24:42 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:62800 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbYDSNYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:24:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAE+PCUhMROPA/2dsb2JhbACBYKk1
Date: Sat, 19 Apr 2008 09:24:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC patch 16/27] Immediate Values Support init
Message-ID: <20080419132435.GA19416@Krystal>
References: <20080416213426.298498397@polymtl.ca> <20080416213553.343331418@polymtl.ca> <20080419192334.A8FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080419192334.A8FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:13:15 up 50 days,  9:24,  3 users,  load average: 0.44, 0.26,
	0.15
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> >  #else
> >  
> > @@ -73,7 +76,9 @@ extern void imv_update_range(const struc
> >  
> >  static inline void core_imv_update(void) { }
> >  static inline void module_imv_update(void) { }
> > -
> > +static inline void imv_unref_core_init(void) { }
> > +static inline void imv_unref_init(struct __imv *begin, struct __imv *end,
> > +		void *init, unsigned long init_size) { }
> >  #endif
> 
> err.
> When turn off CONFIG_IMMEDIATE, "struct __imv" is not defined.
> is cause following warnings.
> 
> include/linux/immediate.h:81: warning: 'struct __imv' declared inside parameter list
> include/linux/immediate.h:81: warning: its scope is only this definition or declaration, \
> which is probably not what you want
> 
> 
> and
> 
> > +extern void imv_unref(struct __imv *begin, struct __imv *end, void *start,
> > +		unsigned long size);
> >  
> >  #else
> >
> > (snip)  
> > +static inline void imv_unref_init(struct __imv *begin, struct __imv *end,
> > +		void *init, unsigned long init_size) { }
> >  #endif
> 
> if CONFIG_IMMEDIATE is on, imv_unref() is declared.
> but if CONFIG_IMMEDIATE is off, imv_unref_init() is declared instead imv_unref()
> it cause following error.
> 
> 
>   CC      kernel/module.o
> kernel/module.c: In function 'sys_init_module':
> kernel/module.c:2211: error: implicit declaration of function 'imv_unref'
> kernel/module.c:2211: error: 'struct module' has no member named 'immediate'
> kernel/module.c:2211: error: 'struct module' has no member named 'immediate'
> kernel/module.c:2211: error: 'struct module' has no member named 'num_immediate'
> make[1]: *** [kernel/module.o] Error 1
> 
> 
> and, 
> 
> in kernel/module.c#sys_init_module(),
> immediate member of struct module is used though CONFIG_IMMEDIATE is off.
> 
> >        imv_unref(mod->immediate, mod->immediate + mod->num_immediate,
> >                mod->module_init, mod->init_size);
> 
> it cause following error.
> 
>   CC      kernel/module.o
> kernel/module.c: In function 'sys_init_module':
> kernel/module.c:2211: error: 'struct module' has no member named 'immediate'
> kernel/module.c:2211: error: 'struct module' has no member named 'immediate'
> kernel/module.c:2211: error: 'struct module' has no member named 'num_immediate'
> make[1]: *** [kernel/module.o] Error 1
> 
> 
> bellow patch fixed these.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> ---
>  include/linux/immediate.h |    8 ++++++--
>  include/linux/module.h    |   21 +++++++++++++++++++++
>  kernel/module.c           |    3 ++-
>  3 files changed, 29 insertions(+), 3 deletions(-)
> 
> Index: b/include/linux/immediate.h
> ===================================================================
> --- a/include/linux/immediate.h	2008-04-19 19:53:03.000000000 +0900
> +++ b/include/linux/immediate.h	2008-04-19 20:04:58.000000000 +0900
> @@ -56,6 +56,10 @@ extern void imv_unref(struct __imv *begi
>   * Generic immediate values: a simple, standard, memory load.
>   */
>  
> +/* empty declaration for avoid warning */
> +struct __imv {
> +};
> +

I prefer to add an ifdef CONFIG_IMMEDIATE to module.c to follow what I
have already done previously. Defining this empty structure is a bit
odd. Here is the updated patch.

Thanks for testing/reporting this.

Mathieu


Immediate Values Support init

Supports placing immediate values in init code

We need to put the immediate values in RW data section so we can edit them
before init section unload.

This code puts NULL pointers in lieu of original pointer referencing init code
before the init sections are freed, both in the core kernel and in modules.

TODO : support __exit section.

Changelog:
- Fix !CONFIG_IMMEDIATE

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/immediate.txt       |    8 ++++----
 include/asm-generic/vmlinux.lds.h |    8 ++++----
 include/asm-powerpc/immediate.h   |    4 ++--
 include/asm-x86/immediate.h       |    6 +++---
 include/linux/immediate.h         |    4 ++++
 include/linux/module.h            |    2 +-
 init/main.c                       |    1 +
 kernel/immediate.c                |   31 +++++++++++++++++++++++++++++--
 kernel/module.c                   |    4 ++++
 9 files changed, 52 insertions(+), 16 deletions(-)

Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/immediate.c	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/kernel/immediate.c	2008-04-19 09:20:53.000000000 -0400
@@ -22,6 +22,7 @@
 #include <linux/cpu.h>
 #include <linux/stop_machine.h>
 
+#include <asm/sections.h>
 #include <asm/cacheflush.h>
 
 /*
@@ -30,8 +31,8 @@
 static int imv_early_boot_complete;
 static int wrote_text;
 
-extern const struct __imv __start___imv[];
-extern const struct __imv __stop___imv[];
+extern struct __imv __start___imv[];
+extern struct __imv __stop___imv[];
 
 static int stop_machine_imv_update(void *imv_ptr)
 {
@@ -118,6 +119,8 @@ void imv_update_range(const struct __imv
 	int ret;
 	for (iter = begin; iter < end; iter++) {
 		mutex_lock(&imv_mutex);
+		if (!iter->imv)	/* Skip removed __init immediate values */
+			goto skip;
 		ret = apply_imv_update(iter);
 		if (imv_early_boot_complete && ret)
 			printk(KERN_WARNING
@@ -126,6 +129,7 @@ void imv_update_range(const struct __imv
 				"instruction at %p, size %hu\n",
 				(void *)iter->imv,
 				(void *)iter->var, iter->size);
+skip:
 		mutex_unlock(&imv_mutex);
 	}
 }
@@ -143,6 +147,29 @@ void core_imv_update(void)
 }
 EXPORT_SYMBOL_GPL(core_imv_update);
 
+/**
+ * imv_unref
+ *
+ * Deactivate any immediate value reference pointing into the code region in the
+ * range start to start + size.
+ */
+void imv_unref(struct __imv *begin, struct __imv *end, void *start,
+		unsigned long size)
+{
+	struct __imv *iter;
+
+	for (iter = begin; iter < end; iter++)
+		if (iter->imv >= (unsigned long)start
+			&& iter->imv < (unsigned long)start + size)
+			iter->imv = 0UL;
+}
+
+void imv_unref_core_init(void)
+{
+	imv_unref(__start___imv, __stop___imv, __init_begin,
+		(unsigned long)__init_end - (unsigned long)__init_begin);
+}
+
 void __init imv_init_complete(void)
 {
 	imv_early_boot_complete = 1;
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2008-04-19 09:20:55.000000000 -0400
@@ -2208,6 +2208,10 @@ sys_init_module(void __user *umod,
 	/* Drop initial reference. */
 	module_put(mod);
 	unwind_remove_table(mod->unwind_info, 1);
+#ifdef CONFIG_IMMEDIATE
+	imv_unref(mod->immediate, mod->immediate + mod->num_immediate,
+		mod->module_init, mod->init_size);
+#endif
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2008-04-19 09:20:46.000000000 -0400
@@ -357,7 +357,7 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 #ifdef CONFIG_IMMEDIATE
-	const struct __imv *immediate;
+	struct __imv *immediate;
 	unsigned int num_immediate;
 #endif
 #ifdef CONFIG_MARKERS
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2008-04-19 09:10:20.000000000 -0400
@@ -52,7 +52,10 @@
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
-	VMLINUX_SYMBOL(__stop___markers) = .;
+	VMLINUX_SYMBOL(__stop___markers) = .;				\
+	VMLINUX_SYMBOL(__start___imv) = .;				\
+	*(__imv)		/* Immediate values: pointers */ 	\
+	VMLINUX_SYMBOL(__stop___imv) = .;
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -61,9 +64,6 @@
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
-		VMLINUX_SYMBOL(__start___imv) = .;			\
-		*(__imv)		/* Immediate values: pointers */ \
-		VMLINUX_SYMBOL(__stop___imv) = .;			\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/immediate.h	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/include/linux/immediate.h	2008-04-19 09:21:34.000000000 -0400
@@ -46,6 +46,9 @@ struct __imv {
 extern void core_imv_update(void);
 extern void imv_update_range(const struct __imv *begin,
 	const struct __imv *end);
+extern void imv_unref_core_init(void);
+extern void imv_unref(struct __imv *begin, struct __imv *end, void *start,
+		unsigned long size);
 
 #else
 
@@ -73,6 +76,7 @@ extern void imv_update_range(const struc
 
 static inline void core_imv_update(void) { }
 static inline void module_imv_update(void) { }
+static inline void imv_unref_core_init(void) { }
 
 #endif
 
Index: linux-2.6-lttng/init/main.c
===================================================================
--- linux-2.6-lttng.orig/init/main.c	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/init/main.c	2008-04-19 09:10:20.000000000 -0400
@@ -776,6 +776,7 @@ static void run_init_process(char *init_
  */
 static int noinline init_post(void)
 {
+	imv_unref_core_init();
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
Index: linux-2.6-lttng/include/asm-x86/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/immediate.h	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2008-04-19 09:20:54.000000000 -0400
@@ -33,7 +33,7 @@
 		BUILD_BUG_ON(sizeof(value) > 8);			\
 		switch (sizeof(value)) {				\
 		case 1:							\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
 				".byte %c2\n\t"				\
 				".previous\n\t"				\
@@ -45,7 +45,7 @@
 			break;						\
 		case 2:							\
 		case 4:							\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
 				".byte %c2\n\t"				\
 				".previous\n\t"				\
@@ -60,7 +60,7 @@
 				value = name##__imv;			\
 				break;					\
 			}						\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
 				".byte %c2\n\t"				\
 				".previous\n\t"				\
Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/immediate.h	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2008-04-19 09:20:54.000000000 -0400
@@ -26,7 +26,7 @@
 		BUILD_BUG_ON(sizeof(value) > 8);			\
 		switch (sizeof(value)) {				\
 		case 1:							\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 					PPC_LONG "%c1, ((1f)-1)\n\t"	\
 					".byte 1\n\t"			\
 					".previous\n\t"			\
@@ -36,7 +36,7 @@
 				: "i" (&name##__imv));			\
 			break;						\
 		case 2:							\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 					PPC_LONG "%c1, ((1f)-2)\n\t"	\
 					".byte 2\n\t"			\
 					".previous\n\t"			\
Index: linux-2.6-lttng/Documentation/immediate.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/immediate.txt	2008-04-19 09:10:20.000000000 -0400
+++ linux-2.6-lttng/Documentation/immediate.txt	2008-04-19 09:10:20.000000000 -0400
@@ -42,10 +42,10 @@ The immediate mechanism supports inserti
 immediate. Immediate values can be put in inline functions, inlined static
 functions, and unrolled loops.
 
-If you have to read the immediate values from a function declared as __init or
-__exit, you should explicitly use _imv_read(), which will fall back on a
-global variable read. Failing to do so will leave a reference to the __init
-section after it is freed (it would generate a modpost warning).
+If you have to read the immediate values from a function declared as __exit, you
+should explicitly use _imv_read(), which will fall back on a global variable
+read. Failing to do so will leave a reference to the __exit section in kernel
+without module unload support. imv_read() in the __init section is supported.
 
 You can choose to set an initial static value to the immediate by using, for
 instance:

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
