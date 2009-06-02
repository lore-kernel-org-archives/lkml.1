Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbZFBAfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbZFBAfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbZFBAev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:34:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496AbZFBAer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:34:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v9 2/7] x86: x86 instruction decoder build-time selftest
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 01 Jun 2009 20:37:25 -0400
Message-ID: <20090602003725.29255.84686.stgit@localhost.localdomain>
In-Reply-To: <20090602003709.29255.48248.stgit@localhost.localdomain>
References: <20090602003709.29255.48248.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a user-space selftest of x86 instruction decoder at kernel build time.
When CONFIG_X86_DECODER_SELFTEST=y, Kbuild builds a test harness of x86
instruction decoder and performs it after building vmlinux.
The test compares the results of objdump and x86 instruction decoder
code and check there are no differences.

Changes from v7:
- Add data, addr, rep, lock prefixes to skip instructions list.
- Add license comments.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Sam Ravnborg <sam@ravnborg.org>
---

 arch/x86/Kconfig.debug          |    9 ++++
 arch/x86/Makefile               |    3 +
 arch/x86/include/asm/inat.h     |    2 +
 arch/x86/include/asm/insn.h     |    2 +
 arch/x86/lib/inat.c             |    2 +
 arch/x86/lib/insn.c             |    2 +
 arch/x86/scripts/Makefile       |   19 +++++++
 arch/x86/scripts/distill.awk    |   42 +++++++++++++++++
 arch/x86/scripts/test_get_len.c |   99 +++++++++++++++++++++++++++++++++++++++
 arch/x86/scripts/user_include.h |   49 +++++++++++++++++++
 10 files changed, 229 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/scripts/Makefile
 create mode 100644 arch/x86/scripts/distill.awk
 create mode 100644 arch/x86/scripts/test_get_len.c
 create mode 100644 arch/x86/scripts/user_include.h

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 9a88937..430aab4 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -179,6 +179,15 @@ config X86_DS_SELFTEST
 config HAVE_MMIOTRACE_SUPPORT
 	def_bool y
 
+config X86_DECODER_SELFTEST
+     bool "x86 instruction decoder selftest"
+     depends on DEBUG_KERNEL
+	---help---
+	 Perform x86 instruction decoder selftests at build time.
+	 This option is useful for checking the sanity of x86 instruction
+	 decoder code.
+	 If unsure, say "N".
+
 #
 # IO delay types:
 #
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..7046556 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -154,6 +154,9 @@ all: bzImage
 KBUILD_IMAGE := $(boot)/bzImage
 
 bzImage: vmlinux
+ifeq ($(CONFIG_X86_DECODER_SELFTEST),y)
+	$(Q)$(MAKE) $(build)=arch/x86/scripts posttest
+endif
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
 	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
 	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/$@
diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index 01e079a..9090665 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -20,7 +20,9 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  */
+#ifdef __KERNEL__
 #include <linux/types.h>
+#endif
 
 /* Instruction attributes */
 typedef u32 insn_attr_t;
diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 5b50fa3..5736404 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -20,7 +20,9 @@
  * Copyright (C) IBM Corporation, 2009
  */
 
+#ifdef __KERNEL__
 #include <linux/types.h>
+#endif
 /* insn_attr_t is defined in inat.h */
 #include <asm/inat.h>
 
diff --git a/arch/x86/lib/inat.c b/arch/x86/lib/inat.c
index d6a34be..564ecbd 100644
--- a/arch/x86/lib/inat.c
+++ b/arch/x86/lib/inat.c
@@ -18,7 +18,9 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  */
+#ifdef __KERNEL__
 #include <linux/module.h>
+#endif
 #include <asm/insn.h>
 
 /* Attribute tables are generated from opcode map */
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 254c848..3b9451a 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -18,8 +18,10 @@
  * Copyright (C) IBM Corporation, 2002, 2004, 2009
  */
 
+#ifdef __KERNEL__
 #include <linux/string.h>
 #include <linux/module.h>
+#endif
 #include <asm/inat.h>
 #include <asm/insn.h>
 
diff --git a/arch/x86/scripts/Makefile b/arch/x86/scripts/Makefile
new file mode 100644
index 0000000..f08859e
--- /dev/null
+++ b/arch/x86/scripts/Makefile
@@ -0,0 +1,19 @@
+PHONY += posttest
+quiet_cmd_posttest = TEST    $@
+      cmd_posttest = objdump -d $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/scripts/distill.awk | $(obj)/test_get_len
+
+posttest: $(obj)/test_get_len vmlinux
+	$(call cmd,posttest)
+
+test_get_len_SRC = $(srctree)/arch/x86/scripts/test_get_len.c $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c
+test_get_len_INC = $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
+
+quiet_cmd_test_get_len = CC      $@
+      cmd_test_get_len = $(CC) -Wall $(test_get_len_SRC) -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include -include $(srctree)/arch/x86/scripts/user_include.h -o $@
+
+
+$(obj)/test_get_len: $(test_get_len_SRC) $(test_get_len_INC)
+	$(call cmd,test_get_len)
+
+clean-files := test_get_len
+
diff --git a/arch/x86/scripts/distill.awk b/arch/x86/scripts/distill.awk
new file mode 100644
index 0000000..d433619
--- /dev/null
+++ b/arch/x86/scripts/distill.awk
@@ -0,0 +1,42 @@
+#!/bin/awk -f
+# Usage: objdump -d a.out | awk -f distill.awk | ./test_get_len
+# Distills the disassembly as follows:
+# - Removes all lines except the disassembled instructions.
+# - For instructions that exceed 1 line (7 bytes), crams all the hex bytes
+# into a single line.
+# - Remove bad(or prefix only) instructions
+
+BEGIN {
+	prev_addr = ""
+	prev_hex = ""
+	prev_mnemonic = ""
+	bad_expr = "(\\(bad\\)|^rex|^.byte|^rep(z|nz)$|^lock$|^es$|^cs$|^ss$|^ds$|^fs$|^gs$|^data(16|32)$|^addr(16|32|64))"
+	fwait_expr = "^9b "
+	fwait_str="9b\tfwait"
+}
+
+/^ *[0-9a-f]+:/ {
+	if (split($0, field, "\t") < 3) {
+		# This is a continuation of the same insn.
+		prev_hex = prev_hex field[2]
+	} else {
+		# Skip bad instructions
+		if (match(prev_mnemonic, bad_expr))
+			prev_addr = ""
+		# Split fwait from other f* instructions
+		if (match(prev_hex, fwait_expr) && prev_mnemonic != "fwait") {
+			printf "%s\t%s\n", prev_addr, fwait_str
+			sub(fwait_expr, "", prev_hex)
+		}
+		if (prev_addr != "")
+			printf "%s\t%s\t%s\n", prev_addr, prev_hex, prev_mnemonic
+		prev_addr = field[1]
+		prev_hex = field[2]
+		prev_mnemonic = field[3]
+	}
+}
+
+END {
+	if (prev_addr != "")
+		printf "%s\t%s\t%s\n", prev_addr, prev_hex, prev_mnemonic
+}
diff --git a/arch/x86/scripts/test_get_len.c b/arch/x86/scripts/test_get_len.c
new file mode 100644
index 0000000..0f702e8
--- /dev/null
+++ b/arch/x86/scripts/test_get_len.c
@@ -0,0 +1,99 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <assert.h>
+
+#include <asm/insn.h>
+
+/*
+ * Test of instruction analysis in general and insn_get_length() in
+ * particular.  See if insn_get_length() and the disassembler agree
+ * on the length of each instruction in an elf disassembly.
+ *
+ * usage: test_get_len < distilled_disassembly
+ */
+
+const char *prog;
+
+static void usage()
+{
+	fprintf(stderr, "usage: %s < distilled_disassembly\n", prog);
+	exit(1);
+}
+
+static void malformed_line(const char *line, int line_nr)
+{
+	fprintf(stderr, "%s: malformed line %d:\n%s", prog, line_nr, line);
+	exit(3);
+}
+
+#define BUFSIZE 256
+
+int main(int argc, char **argv)
+{
+	char line[BUFSIZE];
+	unsigned char insn_buf[16];
+	struct insn insn;
+	int insns = 0;
+
+	prog = argv[0];
+	if (argc > 1)
+		usage();
+
+	while (fgets(line, BUFSIZE, stdin)) {
+		char copy[BUFSIZE], *s, *tab1, *tab2;
+		int nb = 0;
+		unsigned b;
+
+		insns++;
+		memset(insn_buf, 0, 16);
+		strcpy(copy, line);
+		tab1 = strchr(copy, '\t');
+		if (!tab1)
+			malformed_line(line, insns);
+		s = tab1 + 1;
+		s += strspn(s, " ");
+		tab2 = strchr(s, '\t');
+		if (!tab2)
+			malformed_line(line, insns);
+		*tab2 = '\0';	/* Characters beyond tab2 aren't examined */
+		while (s < tab2) {
+			if (sscanf(s, "%x", &b) == 1) {
+				insn_buf[nb++] = (unsigned char) b;
+				s += 3;
+			} else
+				break;
+		}
+		/* Decode an instruction */
+		kernel_insn_init(&insn, insn_buf);
+		insn_get_length(&insn);
+		if (insn.length != nb) {
+			fprintf(stderr, "Error: %s", line);
+			fprintf(stderr, "Error: objdump says %d bytes, but "
+				"insn_get_length() says %d (attr:%x)\n", nb,
+				insn.length, insn.attr);
+			exit(2);
+		}
+	}
+	fprintf(stderr, "Succeed: decoded and checked %d instructions\n",
+		insns);
+	return 0;
+}
diff --git a/arch/x86/scripts/user_include.h b/arch/x86/scripts/user_include.h
new file mode 100644
index 0000000..3bdcc55
--- /dev/null
+++ b/arch/x86/scripts/user_include.h
@@ -0,0 +1,49 @@
+#ifndef __USER_TYPES_H
+#define __USER_TYPES_H
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ */
+
+#include <string.h>
+
+#ifdef __x86_64__
+#define CONFIG_X86_64
+#else
+#define CONFIG_X86_32
+#endif
+typedef unsigned char u8;
+typedef unsigned short u16;
+typedef unsigned int u32;
+typedef unsigned long long u64;
+
+typedef signed char s8;
+typedef short s16;
+typedef int s32;
+typedef long long s64;
+
+typedef enum bool { false = 0, true } bool;
+
+/* any harmless file-scope decl */
+#define NOP_DECL struct __nop
+#define EXPORT_SYMBOL_GPL(symbol) NOP_DECL
+#define MODULE_LICENSE(gpl) NOP_DECL
+
+#define WARN_ON(cond) do { } while (0)
+#define unlikely(cond) (cond)
+
+#endif /* __USER_TYPES_H */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
