Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZKTRL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZKTRL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZKTRL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZKTRLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:11:24 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/2] x86: insn decoder test checks objdump version
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Date: Fri, 20 Nov 2009 12:13:14 -0500
Message-ID: <20091120171314.6715.30390.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091120171301.6715.24229.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091120171301.6715.24229.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check objdump version before using it for insn decoder build test,
because some older objdump can't decode AVX code correctly.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
---

 arch/x86/tools/Makefile       |    5 ++++-
 arch/x86/tools/chkobjdump.awk |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/tools/chkobjdump.awk

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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
