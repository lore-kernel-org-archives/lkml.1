Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbZH1WMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbZH1WMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZH1WMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZH1WMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:12:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 1/2] x86: Allow x86-32 instruction
	decoder selftest on x86-64
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 28 Aug 2009 18:13:19 -0400
Message-ID: <20090828221319.8778.88508.stgit@localhost.localdomain>
In-Reply-To: <20090827163533.GA30268@elte.hu>
References: <20090827163533.GA30268@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass $(CONFIG_64BIT) to the x86 insn decoder selftest for decoding 32bit code
on x86-64, which will happen when building kernel with ARCH=i386 on x86-64.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/tools/Makefile       |    2 +-
 arch/x86/tools/test_get_len.c |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index 95e9cc4..1bd006c 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -1,6 +1,6 @@
 PHONY += posttest
 quiet_cmd_posttest = TEST    $@
-      cmd_posttest = $(OBJDUMP) -d -j .text $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/tools/distill.awk | $(obj)/test_get_len
+      cmd_posttest = $(OBJDUMP) -d -j .text $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/tools/distill.awk | $(obj)/test_get_len $(CONFIG_64BIT)
 
 posttest: $(obj)/test_get_len vmlinux
 	$(call cmd,posttest)
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index 1e81adb..a3273f4 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -45,7 +45,7 @@ const char *prog;
 static void usage(void)
 {
 	fprintf(stderr, "Usage: objdump -d a.out | awk -f distill.awk |"
-		" ./test_get_len\n");
+		" %s [y|n](64bit flag)\n", prog);
 	exit(1);
 }
 
@@ -63,11 +63,15 @@ int main(int argc, char **argv)
 	unsigned char insn_buf[16];
 	struct insn insn;
 	int insns = 0;
+	int x86_64 = 0;
 
 	prog = argv[0];
-	if (argc > 1)
+	if (argc > 2)
 		usage();
 
+	if (argc == 2 && argv[1][0] == 'y')
+		x86_64 = 1;
+
 	while (fgets(line, BUFSIZE, stdin)) {
 		char copy[BUFSIZE], *s, *tab1, *tab2;
 		int nb = 0;
@@ -93,11 +97,7 @@ int main(int argc, char **argv)
 				break;
 		}
 		/* Decode an instruction */
-#ifdef __x86_64__
-		insn_init(&insn, insn_buf, 1);
-#else
-		insn_init(&insn, insn_buf, 0);
-#endif
+		insn_init(&insn, insn_buf, x86_64);
 		insn_get_length(&insn);
 		if (insn.length != nb) {
 			fprintf(stderr, "Error: %s", line);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
