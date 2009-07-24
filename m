Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZGXUFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZGXUFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZGXUFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:05:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55291 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbZGXUDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:03:14 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip -v13 02/11] x86: x86 instruction decoder build-time
	selftest
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Sam Ravnborg <sam@ravnborg.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>
Date: Fri, 24 Jul 2009 16:05:41 -0400
Message-ID: <20090724200541.25904.34800.stgit@localhost.localdomain>
In-Reply-To: <20090724200527.25904.2562.stgit@localhost.localdomain>
References: <20090724200527.25904.2562.stgit@localhost.localdomain>
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

Changes from v12:
 - Remove user_include.h.
 - Use $(OBJDUMP) instead of native objdump.
 - Use hostprogs-y and include insn.c and inat.c directly from test_gen_insn.c.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
---

 arch/x86/Kconfig.debug        |    9 +++
 arch/x86/Makefile             |    3 +
 arch/x86/tools/Makefile       |   15 +++++
 arch/x86/tools/distill.awk    |   42 +++++++++++++++
 arch/x86/tools/test_get_len.c |  113 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 182 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/tools/Makefile
 create mode 100644 arch/x86/tools/distill.awk
 create mode 100644 arch/x86/tools/test_get_len.c

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d105f29..7d0b681 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -186,6 +186,15 @@ config X86_DS_SELFTEST
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
index 1b68659..5fe16bf 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -154,6 +154,9 @@ all: bzImage
 KBUILD_IMAGE := $(boot)/bzImage
 
 bzImage: vmlinux
+ifeq ($(CONFIG_X86_DECODER_SELFTEST),y)
+	$(Q)$(MAKE) $(build)=arch/x86/tools posttest
+endif
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
 	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
 	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/$@
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
new file mode 100644
index 0000000..3dd626b
--- /dev/null
+++ b/arch/x86/tools/Makefile
@@ -0,0 +1,15 @@
+PHONY += posttest
+quiet_cmd_posttest = TEST    $@
+      cmd_posttest = $(OBJDUMP) -d $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/tools/distill.awk | $(obj)/test_get_len
+
+posttest: $(obj)/test_get_len vmlinux
+	$(call cmd,posttest)
+
+hostprogs-y	:= test_get_len
+
+# -I needed for generated C source and C source which in the kernel tree.
+HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/
+
+# Dependancies are also needed.
+$(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
+
diff --git a/arch/x86/tools/distill.awk b/arch/x86/tools/distill.awk
new file mode 100644
index 0000000..d433619
--- /dev/null
+++ b/arch/x86/tools/distill.awk
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
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
new file mode 100644
index 0000000..1e81adb
--- /dev/null
+++ b/arch/x86/tools/test_get_len.c
@@ -0,0 +1,113 @@
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
+#ifdef __x86_64__
+#define CONFIG_X86_64
+#else
+#define CONFIG_X86_32
+#endif
+#define unlikely(cond) (cond)
+
+#include <asm/insn.h>
+#include <inat.c>
+#include <insn.c>
+
+/*
+ * Test of instruction analysis in general and insn_get_length() in
+ * particular.  See if insn_get_length() and the disassembler agree
+ * on the length of each instruction in an elf disassembly.
+ *
+ * Usage: objdump -d a.out | awk -f distill.awk | ./test_get_len
+ */
+
+const char *prog;
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: objdump -d a.out | awk -f distill.awk |"
+		" ./test_get_len\n");
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
+		unsigned int b;
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
+#ifdef __x86_64__
+		insn_init(&insn, insn_buf, 1);
+#else
+		insn_init(&insn, insn_buf, 0);
+#endif
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
