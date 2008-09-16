Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYIPIxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYIPIxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYIPIxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:53:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:22158 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYIPIxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lOwvLPYnfereR1D38CFK96mKcYDk80LhixHyKeXBoJgQQvtUvxQhNY+igD9FNQpfJT
         +gJ8LXjOzeUORzL8V+0YKjhLZMHC9zqWikdKQJR/xZJ3OHjNY/XlemR5lfWudHi/+CJ6
         Il251AMySBmnE8RnDBBIdl0btIMJRHx/70//8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/5] add DEFINE_LOGLEVEL_SETUP v2
Date: Tue, 16 Sep 2008 01:52:50 -0700
Message-Id: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could make subsys easy to add loglevel and xxx_printk
v2: make it more genric, so subsys user only need to two line macro

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/vmlinux_32.lds.S  |    1 +
 arch/x86/kernel/vmlinux_64.lds.S  |    2 ++
 include/asm-generic/vmlinux.lds.h |    8 ++++++++
 include/linux/init.h              |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h            |    9 +++++++++
 init/main.c                       |   28 +++++++++++++++++++++++++++-
 6 files changed, 83 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
@@ -145,6 +145,7 @@ SECTIONS
 	*(.x86_cpu_dev.init)
 	__x86_cpu_dev_end = .;
   }
+  LOGLEVEL_SETUP_INIT(8)
   DYN_ARRAY_INIT(8)
   SECURITY_INIT
   . = ALIGN(4);
Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
@@ -174,6 +174,8 @@ SECTIONS
   }
   __x86_cpu_dev_end = .;
 
+  LOGLEVEL_SETUP_INIT(8)
+
   DYN_ARRAY_INIT(8)
 
   SECURITY_INIT
Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6/include/asm-generic/vmlinux.lds.h
@@ -222,6 +222,14 @@
  * All archs are supposed to use RO_DATA() */
 #define RODATA RO_DATA(4096)
 
+#define LOGLEVEL_SETUP_INIT(align)					\
+	. = ALIGN((align));						\
+	.loglevel_setup.init : AT(ADDR(.loglevel_setup.init) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__loglevel_setup_start) = .;		\
+		*(.loglevel_setup.init)					\
+		VMLINUX_SYMBOL(__loglevel_setup_end) = .;		\
+	}
+
 #define DYN_ARRAY_INIT(align)							\
 	. = ALIGN((align));						\
 	.dyn_array.init : AT(ADDR(.dyn_array.init) - LOAD_OFFSET) {	\
Index: linux-2.6/include/linux/init.h
===================================================================
--- linux-2.6.orig/include/linux/init.h
+++ linux-2.6/include/linux/init.h
@@ -251,6 +251,42 @@ struct obs_kernel_param {
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
 
+#define DECLARE_LOGLEVEL(nameX)					\
+	extern int loglevel_##nameX;				\
+	extern int nameX##_printk(int v, const char *fmt, ...)
+
+struct loglevel_setup {
+	char *name;
+	void (*setup)(char *);
+};
+
+extern struct loglevel_setup *__loglevel_setup_start[], *__loglevel_setup_end[];
+
+#define DEFINE_LOGLEVEL_SETUP(nameX)				\
+	int loglevel_##nameX;					\
+	int nameX##_printk(int v, const char *fmt, ...)		\
+	{							\
+		va_list args;					\
+		int r;						\
+		if (v > loglevel_##nameX)			\
+			return 0;				\
+		va_start(args, fmt);				\
+		r = vprintk(fmt, args);				\
+		va_end(args);					\
+		return r;					\
+	}							\
+	static void __init setup_loglevel_##nameX(char *str)	\
+	{							\
+		get_option(&str, &loglevel_##nameX);		\
+	}							\
+	static struct loglevel_setup __loglevel_setup_##nameX __initdata = \
+	{	.name = #nameX,					\
+		.setup = setup_loglevel_##nameX,		\
+	};							\
+	static struct loglevel_setup *__loglevel_setup_ptr_##nameX __used \
+	__attribute__((__section__(".loglevel_setup.init"))) =	\
+		&__loglevel_setup_##nameX
+
 struct dyn_array {
 	void **name;
 	unsigned long size;
Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -104,6 +104,15 @@ extern int console_printk[];
 #define minimum_console_loglevel (console_printk[2])
 #define default_console_loglevel (console_printk[3])
 
+#define	KERN_LOG_EMERG	0	/* system is unusable			*/
+#define	KERN_LOG_ALERT	1	/* action must be taken immediately	*/
+#define	KERN_LOG_CRIT	2	/* critical conditions			*/
+#define	KERN_LOG_ERR	3	/* error conditions			*/
+#define	KERN_LOG_WARNING	4	/* warning conditions			*/
+#define	KERN_LOG_NOTICE	5	/* normal but significant condition	*/
+#define	KERN_LOG_INFO	6	/* informational			*/
+#define	KERN_LOG_DEBUG	7	/* debug-level messages			*/
+
 struct completion;
 struct pt_regs;
 struct user;
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -248,9 +248,35 @@ static int __init quiet_kernel(char *str
 early_param("debug", debug_kernel);
 early_param("quiet", quiet_kernel);
 
+static char __init *real_loglevel_setup(char *str)
+{
+	struct loglevel_setup **la;
+
+	for (la = __loglevel_setup_start ; la < __loglevel_setup_end; la++) {
+		struct loglevel_setup *l = *la;
+		int len = strlen(l->name);
+
+		if (!strncmp(str, l->name, len)) {
+			/* skip one : */
+			l->setup(str + len + 1);
+			str = NULL;
+			break;
+		}
+	}
+
+	return str;
+}
 static int __init loglevel(char *str)
 {
-	get_option(&str, &console_loglevel);
+	while (str) {
+		char *k = strchr(str, ',');
+		if (k)
+			*k++ = 0;
+		if (*str && (str = real_loglevel_setup(str)) && *str) {
+			get_option(&str, &console_loglevel);
+		}
+		str = k;
+	}
 	return 0;
 }
 
