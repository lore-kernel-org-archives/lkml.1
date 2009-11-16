Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZKPXGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZKPXGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZKPXGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:06:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbZKPXGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:06:43 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -next 1/3] x86: Add verbose option to insn decoder test
To: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Date: Mon, 16 Nov 2009 18:06:18 -0500
Message-ID: <20091116230618.5250.18762.stgit@harusame>
In-Reply-To: <20091116230611.5250.86656.stgit@harusame>
References: <20091116230611.5250.86656.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add verbose option to insn decoder test. This dumps decoded
instruction when building kernel with V=1.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
---

 arch/x86/tools/Makefile       |    9 ++++-
 arch/x86/tools/test_get_len.c |   74 +++++++++++++++++++++++++++++++++++------
 2 files changed, 71 insertions(+), 12 deletions(-)

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index 5e295d9..4688f90 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -1,6 +1,13 @@
 PHONY += posttest
+
+ifeq ($(KBUILD_VERBOSE),1)
+  postest_verbose = -v
+else
+  postest_verbose =
+endif
+
 quiet_cmd_posttest = TEST    $@
-      cmd_posttest = $(OBJDUMP) -d -j .text $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/tools/distill.awk | $(obj)/test_get_len $(CONFIG_64BIT)
+      cmd_posttest = $(OBJDUMP) -d -j .text $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/tools/distill.awk | $(obj)/test_get_len -$(CONFIG_64BIT) $(posttest_verbose)
 
 posttest: $(obj)/test_get_len vmlinux
 	$(call cmd,posttest)
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index 376d338..5743e51 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -20,6 +20,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <assert.h>
+#include <unistd.h>
 
 #define unlikely(cond) (cond)
 
@@ -36,11 +37,16 @@
  */
 
 const char *prog;
+static int verbose;
+static int x86_64;
 
 static void usage(void)
 {
 	fprintf(stderr, "Usage: objdump -d a.out | awk -f distill.awk |"
-		" %s [y|n](64bit flag)\n", prog);
+		" %s [-y|-n] [-v] \n", prog);
+	fprintf(stderr, "\t-y	64bit mode\n");
+	fprintf(stderr, "\t-n	32bit mode\n");
+	fprintf(stderr, "\t-v	verbose mode\n");
 	exit(1);
 }
 
@@ -50,6 +56,56 @@ static void malformed_line(const char *line, int line_nr)
 	exit(3);
 }
 
+static void dump_field(FILE *fp, const char *name, const char *indent,
+		       struct insn_field *field)
+{
+	fprintf(fp, "%s.%s = {\n", indent, name);
+	fprintf(fp, "%s\t.value = %d, bytes[] = {%x, %x, %x, %x},\n",
+		indent, field->value, field->bytes[0], field->bytes[1],
+		field->bytes[2], field->bytes[3]);
+	fprintf(fp, "%s\t.got = %d, .nbytes = %d},\n", indent,
+		field->got, field->nbytes);
+}
+
+static void dump_insn(FILE *fp, struct insn *insn)
+{
+	fprintf(fp, "Instruction = { \n");
+	dump_field(fp, "prefixes", "\t",	&insn->prefixes);
+	dump_field(fp, "rex_prefix", "\t",	&insn->rex_prefix);
+	dump_field(fp, "vex_prefix", "\t",	&insn->vex_prefix);
+	dump_field(fp, "opcode", "\t",		&insn->opcode);
+	dump_field(fp, "modrm", "\t",		&insn->modrm);
+	dump_field(fp, "sib", "\t",		&insn->sib);
+	dump_field(fp, "displacement", "\t",	&insn->displacement);
+	dump_field(fp, "immediate1", "\t",	&insn->immediate1);
+	dump_field(fp, "immediate2", "\t",	&insn->immediate2);
+	fprintf(fp, "\t.attr = %x, .opnd_bytes = %d, .addr_bytes = %d,\n",
+		insn->attr, insn->opnd_bytes, insn->addr_bytes);
+	fprintf(fp, "\t.length = %d, .x86_64 = %d, .kaddr = %p}\n",
+		insn->length, insn->x86_64, insn->kaddr);
+}
+
+static void parse_args(int argc, char **argv)
+{
+	int c;
+	prog = argv[0];
+	while ((c = getopt(argc, argv, "ynv")) != -1) {
+		switch (c) {
+		case 'y':
+			x86_64 = 1;
+			break;
+		case 'n':
+			x86_64 = 0;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			usage();
+		}
+	}
+}
+
 #define BUFSIZE 256
 
 int main(int argc, char **argv)
@@ -57,15 +113,9 @@ int main(int argc, char **argv)
 	char line[BUFSIZE];
 	unsigned char insn_buf[16];
 	struct insn insn;
-	int insns = 0;
-	int x86_64 = 0;
-
-	prog = argv[0];
-	if (argc > 2)
-		usage();
+	int insns = 0, c;
 
-	if (argc == 2 && argv[1][0] == 'y')
-		x86_64 = 1;
+	parse_args(argc, argv);
 
 	while (fgets(line, BUFSIZE, stdin)) {
 		char copy[BUFSIZE], *s, *tab1, *tab2;
@@ -97,8 +147,10 @@ int main(int argc, char **argv)
 		if (insn.length != nb) {
 			fprintf(stderr, "Error: %s", line);
 			fprintf(stderr, "Error: objdump says %d bytes, but "
-				"insn_get_length() says %d (attr:%x)\n", nb,
-				insn.length, insn.attr);
+				"insn_get_length() says %d\n", nb,
+				insn.length);
+			if (verbose)
+				dump_insn(stderr, &insn);
 			exit(2);
 		}
 	}


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
