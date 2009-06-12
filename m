Return-Path: <linux-kernel-owner+w=401wt.eu-S1765430AbZFLQ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765430AbZFLQ0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764397AbZFLQY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:24:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39065 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760693AbZFLQY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 04/27] Blackfin: add support for GENERIC_BUG
Date: Fri, 12 Jun 2009 12:24:22 -0400
Message-Id: <1244823885-22410-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig              |    4 ++
 arch/blackfin/include/asm/bug.h    |   57 ++++++++++++++++++++++++++++++++----
 arch/blackfin/kernel/traps.c       |   30 +++++++++++++++++++
 arch/blackfin/kernel/vmlinux.lds.S |   16 +++++++++-
 4 files changed, 99 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index c56fd3e..74cdcf3 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -28,6 +28,10 @@ config BLACKFIN
 	select HAVE_OPROFILE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
+config GENERIC_BUG
+	def_bool y
+	depends on BUG
+
 config ZONE_DMA
 	bool
 	default y
diff --git a/arch/blackfin/include/asm/bug.h b/arch/blackfin/include/asm/bug.h
index 6d3e11b..655e495 100644
--- a/arch/blackfin/include/asm/bug.h
+++ b/arch/blackfin/include/asm/bug.h
@@ -2,13 +2,58 @@
 #define _BLACKFIN_BUG_H
 
 #ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
 
-#define BUG() do { \
-	dump_bfin_trace_buffer(); \
-	printk(KERN_EMERG "BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
-	panic("BUG!"); \
-} while (0)
+#define BFIN_BUG_OPCODE	0xefcd
+
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+
+#define _BUG_OR_WARN(flags)						\
+	asm volatile(							\
+		"1:	.hword	%0\n"					\
+		"	.section __bug_table,\"a\",@progbits\n"		\
+		"2:	.long	1b\n"					\
+		"	.long	%1\n"					\
+		"	.short	%2\n"					\
+		"	.short	%3\n"					\
+		"	.org	2b + %4\n"				\
+		"	.previous"					\
+		:							\
+		: "i"(BFIN_BUG_OPCODE), "i"(__FILE__),			\
+		  "i"(__LINE__), "i"(flags),				\
+		  "i"(sizeof(struct bug_entry)))
+
+#else
+
+#define _BUG_OR_WARN(flags)						\
+	asm volatile(							\
+		"1:	.hword	%0\n"					\
+		"	.section __bug_table,\"a\",@progbits\n"		\
+		"2:	.long	1b\n"					\
+		"	.short	%1\n"					\
+		"	.org	2b + %2\n"				\
+		"	.previous"					\
+		:							\
+		: "i"(BFIN_BUG_OPCODE), "i"(flags),			\
+		  "i"(sizeof(struct bug_entry)))
+
+#endif /* CONFIG_DEBUG_BUGVERBOSE */
+
+#define BUG()								\
+	do {								\
+		_BUG_OR_WARN(0);					\
+		for (;;);						\
+	} while (0)
+
+#define WARN_ON(condition)							\
+	({								\
+		int __ret_warn_on = !!(condition);			\
+		if (unlikely(__ret_warn_on))				\
+			_BUG_OR_WARN(BUGFLAG_WARNING);			\
+		unlikely(__ret_warn_on);				\
+	})
+
+#define HAVE_ARCH_BUG
+#define HAVE_ARCH_WARN_ON
 
 #endif
 
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index aa76dfb..2405f19 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -27,6 +27,7 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/bug.h>
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
@@ -381,6 +382,23 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	/* 0x20 - Reserved, Caught by default */
 	/* 0x21 - Undefined Instruction, handled here */
 	case VEC_UNDEF_I:
+#ifdef CONFIG_BUG
+		if (kernel_mode_regs(fp)) {
+			switch (report_bug(fp->pc, fp)) {
+			case BUG_TRAP_TYPE_NONE:
+				break;
+			case BUG_TRAP_TYPE_WARN:
+				dump_bfin_trace_buffer();
+				fp->pc += 2;
+				goto traps_done;
+			case BUG_TRAP_TYPE_BUG:
+				/* call to panic() will dump trace, and it is
+				 * off at this point, so it won't be clobbered
+				 */
+				panic("BUG()");
+			}
+		}
+#endif
 		info.si_code = ILL_ILLOPC;
 		sig = SIGILL;
 		verbose_printk(KERN_NOTICE EXC_0x21(KERN_NOTICE));
@@ -792,6 +810,18 @@ void dump_bfin_trace_buffer(void)
 }
 EXPORT_SYMBOL(dump_bfin_trace_buffer);
 
+#ifdef CONFIG_BUG
+int is_valid_bugaddr(unsigned long addr)
+{
+	unsigned short opcode;
+
+	if (!get_instruction(&opcode, (unsigned short *)addr))
+		return 0;
+
+	return opcode == BFIN_BUG_OPCODE;
+}
+#endif
+
 /*
  * Checks to see if the address pointed to is either a
  * 16-bit CALL instruction, or a 32-bit CALL instruction
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 8b67167..119fbdb 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -166,6 +166,20 @@ SECTIONS
 	}
 	PERCPU(4)
 	SECURITY_INIT
+
+	/* we have to discard exit text and such at runtime, not link time, to
+	 * handle embedded cross-section references (alt instructions, bug
+	 * table, eh_frame, etc...)
+	 */
+	.exit.text :
+	{
+		EXIT_TEXT
+	}
+	.exit.data :
+	{
+		EXIT_DATA
+	}
+
 	.init.ramfs :
 	{
 		. = ALIGN(4);
@@ -264,8 +278,6 @@ SECTIONS
 
 	/DISCARD/ :
 	{
-		EXIT_TEXT
-		EXIT_DATA
 		*(.exitcall.exit)
 	}
 }
-- 
1.6.3.1

