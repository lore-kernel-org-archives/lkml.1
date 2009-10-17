Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZJQJ6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZJQJ6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZJQJ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:58:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:40377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZJQJ6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:58:50 -0400
Date: Sat, 17 Oct 2009 09:58:12 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, jkenisto@us.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090828221319.8778.88508.stgit@localhost.localdomain>
References: <20090828221319.8778.88508.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Allow x86-32 instruction decoder selftest on x86-64
Message-ID: <tip-50a482fbd96943516b7a2783900e8fe61a6425e7@git.kernel.org>
Git-Commit-ID: 50a482fbd96943516b7a2783900e8fe61a6425e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:58:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50a482fbd96943516b7a2783900e8fe61a6425e7
Gitweb:     http://git.kernel.org/tip/50a482fbd96943516b7a2783900e8fe61a6425e7
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 28 Aug 2009 18:13:19 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 4 Sep 2009 18:14:04 +0200

x86: Allow x86-32 instruction decoder selftest on x86-64

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
