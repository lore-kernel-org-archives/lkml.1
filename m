Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYIRATg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYIRATg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 20:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYIRATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 20:19:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:43250 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYIRATI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 20:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k4nSAM4WHe9hWtezj0JG54PT9An4LsXUuC3p/eEWSZU5+rwANn7YYqpdopSHGIHXfi
         qNykk+DmHnnl2ljKe9IOTGudweCVvRcVvLMWkeMgrWkymm5+V31j4ry1uhxkSsNSCySQ
         ZjFZmh9o+z8cxOEd4eZN6emQh9ODPtXhlhrCY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/7] add DEFINE_LOGLEVEL_SETUP
Date: Wed, 17 Sep 2008 17:18:25 -0700
Message-Id: <1221697112-21814-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could make subsys easy to add loglevel and xxx_printk
v2: make it more genric, so subsys user only need to two line macro
v3: add back nameStr, so could find out iommu: and iommu_gart: and etc
v4: use printk intead of pci_printk
v5: fix checkpatch error and warning
v6: add DEFINE_LOGLEVEL_SETUP_DEF to take default
v7: call tag_loglevel_setup only one time, so could take several loglevel like
   loglevel=4 loglevel=acpi:8 loglevel=pci:8 loglevel=apic:8 is the same as
   loglevel=4,acpi:8,pci:8,apic:8
v8: add _SPEW, _EXTRA
    expand msg_level to 2 digi bits
    call tag_name_level_setup second time if user change console_loglevel
    add get_tag_level, so could use it to find out current level of spcified tag

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
 include/asm-generic/vmlinux.lds.h |    8 +
 include/linux/init.h              |   22 +++++
 include/linux/kernel.h            |    4 
 init/main.c                       |  156 ++++++++++++++++++++++++++++++++++++--
 kernel/printk.c                   |   90 ++++++++++++++++++---
 7 files changed, 259 insertions(+), 24 deletions(-)

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
+	DEFINE_LOGLEVEL_SETUP_DEF(nameX, tagX, nameStr, 0)
+
 struct dyn_array {
 	void **name;
 	unsigned long size;
Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -89,6 +89,8 @@ extern const char linux_proc_banner[];
 #define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
 #define	KERN_INFO	"<6>"	/* informational			*/
 #define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
+#define	KERN_SPEW	"<8>"	/* spew messages			*/
+#define	KERN_EXTRA	"<9>"	/* extra messages			*/
 
 /*
  * Annotation for a "continued" line of log printout (only done after a
@@ -104,6 +106,8 @@ extern int console_printk[];
 #define minimum_console_loglevel (console_printk[2])
 #define default_console_loglevel (console_printk[3])
 
+extern int get_tag_level(char *str, int *slen);
+
 struct completion;
 struct pt_regs;
 struct user;
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -233,29 +233,168 @@ unsigned long loops_per_jiffy = (1<<12);
 
 EXPORT_SYMBOL(loops_per_jiffy);
 
-static int __init debug_kernel(char *str)
-{
-	console_loglevel = 10;
+struct tag_console_loglevel {
+	char tag[32];
+	char name[32];
+	int level;
+};
+
+#define CONSOLE_TAG_LEVEL_NR	32
+static struct tag_console_loglevel tag_level[CONSOLE_TAG_LEVEL_NR];
+static int tag_level_nr;
+
+static int __init add_tag_name_level(const char *tag, const char *name,
+					int level)
+{
+	int len;
+
+	if (tag_level_nr > CONSOLE_TAG_LEVEL_NR)
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
 	return 0;
 }
 
-static int __init quiet_kernel(char *str)
+static int __init update_tag_name_level(const char *tag, const char *name,
+					int level)
 {
-	console_loglevel = 4;
+	int i;
+	int len;
+
+	for (i = 0; i < tag_level_nr; i++) {
+		len = strlen(tag_level[i].tag);
+		if (strncmp(tag_level[i].tag, tag, len))
+			continue;
+		if (name) {
+			len = sizeof(tag_level[i].name);
+			strncpy(tag_level[i].name, name, len - 1);
+		}
+		tag_level[i].level = level;
+
+		return 1;
+	}
+
 	return 0;
 }
 
-early_param("debug", debug_kernel);
-early_param("quiet", quiet_kernel);
+static int __init save_tag_name_level(const char *tag, const char *name,
+					int level)
+{
+	int ret;
+
+	ret = update_tag_name_level(tag, name, level);
+
+	/* not found, add a new one */
+	if (!ret)
+		ret = add_tag_name_level(tag, name, level);
+
+	return ret;
+}
+
+int get_tag_level(char *str, int *slen)
+{
+	int i;
+	int level = 0;
+
+	/* handle tag here */
+	for (i = 0; i < tag_level_nr; i++) {
+		struct tag_console_loglevel *tl;
+		int len;
+
+		tl = &tag_level[i];
+		len = strlen(tl->tag);
+		if (*slen > (len - 1) && !strncmp(str, tl->tag, len)) {
+			level = tl->level;
+			*slen = len;
+			break;
+		}
+	}
+
+	return level;
+}
+
+static void __init tag_loglevel_setup(void)
+{
+	struct loglevel_setup **la;
+	int level = console_loglevel;
+
+	for (la = __loglevel_setup_start ; la < __loglevel_setup_end; la++) {
+		struct loglevel_setup *l = *la;
+
+		save_tag_name_level(l->tag, l->name, l->level ? : level);
+	}
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
 
 static int __init loglevel(char *str)
 {
-	get_option(&str, &console_loglevel);
+	while (str) {
+		char *k = strchr(str, ',');
+
+		if (k)
+			*k++ = 0;
+		if (*str) {
+			str = real_loglevel_setup(str);
+			if (str && *str) {
+				get_option(&str, &console_loglevel);
+				tag_loglevel_setup();
+			}
+		}
+		str = k;
+	}
+
 	return 0;
 }
 
 early_param("loglevel", loglevel);
 
+static int __init debug_kernel(char *str)
+{
+	console_loglevel = 10;
+	tag_loglevel_setup();
+	return 0;
+}
+
+static int __init quiet_kernel(char *str)
+{
+	console_loglevel = 4;
+	tag_loglevel_setup();
+	return 0;
+}
+
+early_param("debug", debug_kernel);
+early_param("quiet", quiet_kernel);
+
 /*
  * Unknown boot options get handed to init, unless they look like
  * failed parameters
@@ -581,6 +720,7 @@ asmlinkage void __init start_kernel(void
 	page_address_init();
 	printk(KERN_NOTICE);
 	printk(linux_banner);
+	tag_loglevel_setup();
 	setup_arch(&command_line);
 	pre_alloc_dyn_array();
 	mm_init_owner(&init_mm, &init_task);
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
@@ -481,21 +481,55 @@ static void call_console_drivers(unsigne
 {
 	unsigned cur_index, start_print;
 	static int msg_level = -1;
+	int level = console_loglevel;
 
 	BUG_ON(((int)(start - end)) > 0);
 
 	cur_index = start;
 	start_print = start;
 	while (cur_index != end) {
-		if (msg_level < 0 && ((end - cur_index) > 2) &&
-				LOG_BUF(cur_index + 0) == '<' &&
-				LOG_BUF(cur_index + 1) >= '0' &&
-				LOG_BUF(cur_index + 1) <= '7' &&
-				LOG_BUF(cur_index + 2) == '>') {
-			msg_level = LOG_BUF(cur_index + 1) - '0';
-			cur_index += 3;
+		int tag_level;
+		int tag_len;
+
+		if (msg_level < 0) {
+			int len = 0;
+
+			if (((end - cur_index) > 2) &&
+					LOG_BUF(cur_index + 0) == '<' &&
+					LOG_BUF(cur_index + 1) >= '0' &&
+					LOG_BUF(cur_index + 1) <= '9' &&
+					LOG_BUF(cur_index + 2) == '>') {
+				msg_level = LOG_BUF(cur_index + 1) - '0';
+				len = 3;
+			} else if (((end - cur_index) > 3) &&
+					LOG_BUF(cur_index + 0) == '<' &&
+					LOG_BUF(cur_index + 1) >= '0' &&
+					LOG_BUF(cur_index + 1) <= '9' &&
+					LOG_BUF(cur_index + 2) >= '0' &&
+					LOG_BUF(cur_index + 2) <= '9' &&
+					LOG_BUF(cur_index + 3) == '>') {
+				msg_level = LOG_BUF(cur_index + 1) - '0';
+				msg_level *= 10;
+				msg_level += LOG_BUF(cur_index + 2) - '0';
+				len = 4;
+			}
+
+			if (len) {
+				level = console_loglevel;
+				cur_index += len;
+				start_print = cur_index;
+			}
+		}
+
+		/* handle tag here */
+		tag_len = end - cur_index;
+		tag_level = get_tag_level(&LOG_BUF(cur_index), &tag_len);
+		if (tag_level) {
+			level = tag_level;
+			cur_index += tag_len;
 			start_print = cur_index;
 		}
+
 		while (cur_index != end) {
 			char c = LOG_BUF(cur_index);
 
@@ -510,14 +544,15 @@ static void call_console_drivers(unsigne
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
@@ -712,19 +747,42 @@ asmlinkage int vprintk(const char *fmt,
 	 */
 	for (p = printk_buf; *p; p++) {
 		if (new_text_line) {
+			int len = 0;
+
 			/* If a token, set current_log_level and skip over */
-			if (p[0] == '<' && p[1] >= '0' && p[1] <= '7' &&
+			if (p[0] == '<' && p[1] >= '0' && p[1] <= '9' &&
 			    p[2] == '>') {
 				current_log_level = p[1] - '0';
-				p += 3;
-				printed_len -= 3;
+				len = 3;
+			} else if (p[0] == '<' && p[1] >= '0' && p[1] <= '9' &&
+				   p[2] >= '0' && p[2] <= '9' && p[3] == '>') {
+				current_log_level = p[1] - '0';
+				current_log_level *= 10;
+				current_log_level += p[2] - '0';
+				len = 4;
+			}
+
+			if (len) {
+				p += len;
+				printed_len -= len;
 			}
 
 			/* Always output the token */
 			emit_log_char('<');
-			emit_log_char(current_log_level + '0');
+			if (current_log_level < 10) {
+				emit_log_char(current_log_level + '0');
+				len = 3;
+			} else {
+				int temp;
+
+				temp = current_log_level/10;
+				emit_log_char(temp + '0');
+				temp *= 10;
+				emit_log_char(current_log_level - temp + '0');
+				len = 4;
+			}
 			emit_log_char('>');
-			printed_len += 3;
+			printed_len += len;
 			new_text_line = 0;
 
 			if (printk_time) {
