Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZKPXHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZKPXHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZKPXHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:07:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbZKPXGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:06:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -next 2/3] x86: Show symbol name if insn decoder test failed
To: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Date: Mon, 16 Nov 2009 18:06:24 -0500
Message-ID: <20091116230624.5250.49813.stgit@harusame>
In-Reply-To: <20091116230611.5250.86656.stgit@harusame>
References: <20091116230611.5250.86656.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show symbol name if insn decoder test find a difference.
This will help us to find out where the issue is.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
