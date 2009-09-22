Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZIVTmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZIVTmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZIVTin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:43 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39120 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbZIVTik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bqrNHmmm4dOw/BwrrCIercvAnYvRU+Q1mrSCCbvy4QfFhjpTC7Un8HYwqa22bxKVw5
         kG1FdraYgacELaNRLadCZVJooebtxZl9yn4/FlX6CqiaskUaxKJj6rHwO2/iWDG0coz5
         eh/SupTCkzD2WMQIQ5InmVbKGbUBkKrw4FPqY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/24] x86: Allow x86-32 instruction decoder selftest on x86-64
Date: Tue, 22 Sep 2009 21:38:05 +0200
Message-Id: <1253648302-5771-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Pass $(CONFIG_64BIT) to the x86 insn decoder selftest in case we are
decoding 32bit code on x86-64, which will happen when building kernel
with ARCH=i386 on x86-64.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090828221319.8778.88508.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.6.2.3

