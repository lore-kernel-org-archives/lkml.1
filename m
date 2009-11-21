Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbZKUHKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbZKUHKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 02:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZKUHKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 02:10:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:33113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZKUHKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 02:10:37 -0500
Date: Sat, 21 Nov 2009 07:10:06 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, rdunlap@xenotime.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, sfr@canb.auug.org.au, tglx@linutronix.de,
       rdunlap@xenotime.net, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091120171314.6715.30390.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091120171314.6715.30390.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: insn decoder test checks objdump version
Message-ID: <tip-6f5f67267dc4faecd9cba63894de92ca92a608b8@git.kernel.org>
Git-Commit-ID: 6f5f67267dc4faecd9cba63894de92ca92a608b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f5f67267dc4faecd9cba63894de92ca92a608b8
Gitweb:     http://git.kernel.org/tip/6f5f67267dc4faecd9cba63894de92ca92a608b8
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 20 Nov 2009 12:13:14 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Nov 2009 23:01:04 -0800

x86: insn decoder test checks objdump version

Check objdump version before using it for insn decoder build test,
because some older objdump can't decode AVX code correctly.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jim Keniston <jkenisto@us.ibm.com>
LKML-Reference: <20091120171314.6715.30390.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/tools/Makefile       |    5 ++++-
 arch/x86/tools/chkobjdump.awk |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index c80b079..f820826 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -12,8 +12,11 @@ else
   posttest_64bit = -n
 endif
 
+distill_awk = $(srctree)/arch/x86/tools/distill.awk
+chkobjdump = $(srctree)/arch/x86/tools/chkobjdump.awk
+
 quiet_cmd_posttest = TEST    $@
-      cmd_posttest = $(OBJDUMP) -d -j .text $(objtree)/vmlinux | $(AWK) -f $(srctree)/arch/x86/tools/distill.awk | $(obj)/test_get_len $(posttest_64bit) $(posttest_verbose)
+      cmd_posttest = ($(OBJDUMP) -v | $(AWK) -f $(chkobjdump)) || $(OBJDUMP) -d -j .text $(objtree)/vmlinux | $(AWK) -f $(distill_awk) | $(obj)/test_get_len $(posttest_64bit) $(posttest_verbose)
 
 posttest: $(obj)/test_get_len vmlinux
 	$(call cmd,posttest)
diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
new file mode 100644
index 0000000..0d13cd9
--- /dev/null
+++ b/arch/x86/tools/chkobjdump.awk
@@ -0,0 +1,23 @@
+# GNU objdump version checker
+#
+# Usage:
+# objdump -v | awk -f chkobjdump.awk
+BEGIN {
+	# objdump version 2.19 or later is OK for the test.
+	od_ver = 2;
+	od_sver = 19;
+}
+
+/^GNU/ {
+	split($4, ver, ".");
+	if (ver[1] > od_ver ||
+	    (ver[1] == od_ver && ver[2] >= od_sver)) {
+		exit 1;
+	} else {
+		printf("Warning: objdump version %s is older than %d.%d\n",
+		       $4, od_ver, od_sver);
+		print("Warning: Skipping posttest.");
+		# Logic is inverted, because we just skip test without error.
+		exit 0;
+	}
+}
