Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZKQGfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZKQGfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:35:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZKQGfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:35:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:58769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbZKQGfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:35:00 -0500
Date: Tue, 17 Nov 2009 06:31:17 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, rdunlap@xenotime.net,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, rdunlap@xenotime.net,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20091116230624.5250.49813.stgit@harusame>
References: <20091116230624.5250.49813.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Show symbol name if insn decoder test failed
Message-ID: <tip-35039eb6b199749943547c8572be6604edf00229@git.kernel.org>
Git-Commit-ID: 35039eb6b199749943547c8572be6604edf00229
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35039eb6b199749943547c8572be6604edf00229
Gitweb:     http://git.kernel.org/tip/35039eb6b199749943547c8572be6604edf00229
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 16 Nov 2009 18:06:24 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:16:50 +0100

x86: Show symbol name if insn decoder test failed

Show symbol name if insn decoder test find a difference.
This will help us to find out where the issue is.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
LKML-Reference: <20091116230624.5250.49813.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/tools/distill.awk    |    5 +++++
 arch/x86/tools/test_get_len.c |   10 +++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/tools/distill.awk b/arch/x86/tools/distill.awk
index d433619..c13c0ee 100644
--- a/arch/x86/tools/distill.awk
+++ b/arch/x86/tools/distill.awk
@@ -15,6 +15,11 @@ BEGIN {
 	fwait_str="9b\tfwait"
 }
 
+/^ *[0-9a-f]+ <[^>]*>:/ {
+	# Symbol entry
+	printf("%s%s\n", $2, $1)
+}
+
 /^ *[0-9a-f]+:/ {
 	if (split($0, field, "\t") < 3) {
 		# This is a continuation of the same insn.
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index 5743e51..af75e07 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -110,7 +110,7 @@ static void parse_args(int argc, char **argv)
 
 int main(int argc, char **argv)
 {
-	char line[BUFSIZE];
+	char line[BUFSIZE], sym[BUFSIZE] = "<unknown>";
 	unsigned char insn_buf[16];
 	struct insn insn;
 	int insns = 0, c;
@@ -122,6 +122,12 @@ int main(int argc, char **argv)
 		int nb = 0;
 		unsigned int b;
 
+		if (line[0] == '<') {
+			/* Symbol line */
+			strcpy(sym, line);
+			continue;
+		}
+
 		insns++;
 		memset(insn_buf, 0, 16);
 		strcpy(copy, line);
@@ -145,6 +151,8 @@ int main(int argc, char **argv)
 		insn_init(&insn, insn_buf, x86_64);
 		insn_get_length(&insn);
 		if (insn.length != nb) {
+			fprintf(stderr, "Error: %s found a difference at %s\n",
+				prog, sym);
 			fprintf(stderr, "Error: %s", line);
 			fprintf(stderr, "Error: objdump says %d bytes, but "
 				"insn_get_length() says %d\n", nb,
