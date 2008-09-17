Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYIQHLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYIQHLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 03:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYIQHKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 03:10:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:9438 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYIQHKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 03:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kTgOcFXSagEvzaSEPdG0IUMuaPKctHvHYFvsWKrXie5syOajrxfHY/6CRz0Tf7a/8U
         ZzF0u9/8UcF2OWz/29vLObuHUD4TCmpBb2uKncFtTCIaczZk0Ql0hcaqIrjZWbuCSoxq
         dXb2PXoTNWTJqIZ1ndtSCYXdHfenX2JIrO/Lw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/6] add DEFINE_LOGLEVEL_SETUP v6
Date: Wed, 17 Sep 2008 00:10:10 -0700
Message-Id: <1221635415-14859-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could make subsys easy to add loglevel and xxx_printk
v2: make it more genric, so subsys user only need to two line macro
v3: add back nameStr, so could find out iommu: and iommu_gart: and etc
v4: use printk intead of pci_printk
v5: fix checkpatch error and warning
v6: add DEFINE_LOGLEVEL_SETUP_DEF to take default

usage:
	in .h to have
		#define KERN_PCI "<pci>"
	in .c to have
		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
	then could use
		printk(KERN_DEBUG KERN_PCI fmt, ...);
	and command line
		loglevel=pci:8

you can add different printk to different files of one subsys if you like

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/vmlinux_32.lds.S  |    1 
 arch/x86/kernel/vmlinux_64.lds.S  |    2 
 include/asm-generic/vmlinux.lds.h |    8 +++
 include/linux/init.h              |   22 ++++++++++
 include/linux/kernel.h            |    9 ++++
 init/main.c                       |   77 +++++++++++++++++++++++++++++++++++++-
 kernel/printk.c                   |   28 +++++++++++--
 7 files changed, 142 insertions(+), 5 deletions(-)

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
+	.loglevel_setup.init : AT(ADDR(.loglevel_setup.init) - LOAD_OFFSET) { \
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
@@ -251,6 +251,28 @@ struct obs_kernel_param {
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
 
+struct loglevel_setup {
+	char *name;
+	char *tag;
+	int level;
+};
+
+extern struct loglevel_setup *__loglevel_setup_start[], *__loglevel_setup_end[];
+
+#define DEFINE_LOGLEVEL_SETUP_DEF(nameX, tagX, nameStr, levelX)		\
+	static struct loglevel_setup __loglevel_setup_##nameX __initdata = \
+	{							\
+		.tag = tagX,					\
+		.name = nameStr,				\
+		.level = levelX,				\
+	};							\
+	static struct loglevel_setup *__loglevel_setup_ptr_##nameX __used \
+	__attribute__((__section__(".loglevel_setup.init"))) =	\
+		&__loglevel_setup_##nameX
+
+#define DEFINE_LOGLEVEL_SETUP(nameX, tagX, nameStr)		\
+	DEFINE_LOGLEVEL_SETUP_DEF(nameX, tagX, nameStr, 0)		\
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
 
+struct tag_console_loglevel {
+	char tag[32];
+	char name[32];
+	int level;
+};
+
+extern struct tag_console_loglevel tag_level[];
+extern int tag_level_nr;
+
 struct completion;
 struct pt_regs;
 struct user;
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -248,9 +248,84 @@ static int __init quiet_kernel(char *str
 early_param("debug", debug_kernel);
 early_param("quiet", quiet_kernel);
 
+struct tag_console_loglevel tag_level[32];
+int tag_level_nr;
+
+static int __init save_tag_name_level(const char *tag, const char *name,
+					int level)
+{
+	int len;
+
+	if (tag_level_nr > 32)
+		return -1;
+
+	len = sizeof(tag_level[tag_level_nr].tag);
+	strncpy(tag_level[tag_level_nr].tag, tag, len - 1);
+	len = sizeof(tag_level[tag_level_nr].name);
+	strncpy(tag_level[tag_level_nr].name, name, len - 1);
+	tag_level[tag_level_nr].level = level;
+
+	tag_level_nr++;
+
+	return 0;
+}
+
+static void __init tag_name_level_setup(void)
+{
+	struct loglevel_setup **la;
+	int level = default_console_loglevel;
+
+	if (level != console_loglevel)
+		level = console_loglevel;
+
+	for (la = __loglevel_setup_start ; la < __loglevel_setup_end; la++) {
+		struct loglevel_setup *l = *la;
+
+		save_tag_name_level(l->tag, l->name, l->level ? : level);
+	}
+
+}
+
+static char __init *real_loglevel_setup(char *str)
+{
+	int i;
+
+	for (i = 0; i < tag_level_nr; i++) {
+		struct tag_console_loglevel *tl;
+		int len;
+
+		tl = &tag_level[i];
+		len = strlen(tl->name);
+		if (!strncmp(str, tl->name, len)) {
+			int level;
+
+			str += len;
+			get_option(&str, &level);
+			tl->level = level;
+			str = NULL;
+			break;
+		}
+	}
+
+	return str;
+}
+
 static int __init loglevel(char *str)
 {
-	get_option(&str, &console_loglevel);
+	tag_name_level_setup();
+
+	while (str) {
+		char *k = strchr(str, ',');
+		if (k)
+			*k++ = 0;
+		if (*str) {
+			str = real_loglevel_setup(str);
+			if (str && *str)
+				get_option(&str, &console_loglevel);
+		}
+		str = k;
+	}
+
 	return 0;
 }
 
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -457,9 +457,9 @@ early_param("ignore_loglevel", ignore_lo
  * Write out chars from start to end - 1 inclusive
  */
 static void _call_console_drivers(unsigned start,
-				unsigned end, int msg_log_level)
+				unsigned end, int msg_log_level, int level)
 {
-	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
+	if ((msg_log_level < level || ignore_loglevel) &&
 			console_drivers && start != end) {
 		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
 			/* wrapped write */
@@ -481,21 +481,40 @@ static void call_console_drivers(unsigne
 {
 	unsigned cur_index, start_print;
 	static int msg_level = -1;
+	int level = console_loglevel;
 
 	BUG_ON(((int)(start - end)) > 0);
 
 	cur_index = start;
 	start_print = start;
 	while (cur_index != end) {
+		int i;
+
 		if (msg_level < 0 && ((end - cur_index) > 2) &&
 				LOG_BUF(cur_index + 0) == '<' &&
 				LOG_BUF(cur_index + 1) >= '0' &&
 				LOG_BUF(cur_index + 1) <= '7' &&
 				LOG_BUF(cur_index + 2) == '>') {
 			msg_level = LOG_BUF(cur_index + 1) - '0';
+			level = console_loglevel;
 			cur_index += 3;
 			start_print = cur_index;
 		}
+		/* handle tag here */
+		for (i = 0; i < tag_level_nr; i++) {
+			struct tag_console_loglevel *tl;
+			int len;
+
+			tl = &tag_level[i];
+			len = strlen(tl->tag);
+			if ((end - cur_index) > (len - 1) &&
+			    !strncmp(&LOG_BUF(cur_index), tl->tag, len)) {
+				level = tl->level;
+				cur_index += len;
+				start_print = cur_index;
+				break;
+			}
+		}
 		while (cur_index != end) {
 			char c = LOG_BUF(cur_index);
 
@@ -510,14 +529,15 @@ static void call_console_drivers(unsigne
 					 */
 					msg_level = default_message_loglevel;
 				}
-				_call_console_drivers(start_print, cur_index, msg_level);
+				_call_console_drivers(start_print, cur_index,
+							msg_level, level);
 				msg_level = -1;
 				start_print = cur_index;
 				break;
 			}
 		}
 	}
-	_call_console_drivers(start_print, end, msg_level);
+	_call_console_drivers(start_print, end, msg_level, level);
 }
 
 static void emit_log_char(char c)
