Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbZFMPjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbZFMPjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 11:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZFMPjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 11:39:24 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62425 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZFMPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 11:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vf2hs55PN81VQ79dgKxTWIgrzyCVU1odirErwWsUM+6bAjG78RsXFmB/CTGC17sG5k
         xYvXfihB/Y9EgIY1Tg3/msbIa5KdZXCpb2DSRFlouJ0yY4rRT6rwwdudUKytYPWYktat
         hzPW5tY09J1tG8QY8n9QZYM64jaDC8rxvIE4k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perfcounters: Fixes for filename:line displays
Date: Sat, 13 Jun 2009 17:39:23 +0200
Message-Id: <1244907563-7820-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- fix addr2line on userspace binary: don't only check kernel image.
- fix string allocation size for path: missing ending null char room
- fix overflow in symbol extra info

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-annotate.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7a5b278..94cea67 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -1116,7 +1116,7 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 		if (offset < len)
 			hits = sym->hist[offset];
 
-		if (sym_ext) {
+		if (offset < len && sym_ext) {
 			path = sym_ext[offset].path;
 			percent = sym_ext[offset].percent;
 		} else if (sym->hist_sum)
@@ -1190,7 +1190,8 @@ static void free_source_line(struct symbol *sym, int len)
 }
 
 /* Get the filename:line for the colored entries */
-static void get_source_line(struct symbol *sym, __u64 start, int len)
+static void
+get_source_line(struct symbol *sym, __u64 start, int len, char *filename)
 {
 	int i;
 	char cmd[PATH_MAX * 2];
@@ -1216,7 +1217,7 @@ static void get_source_line(struct symbol *sym, __u64 start, int len)
 			continue;
 
 		offset = start + i;
-		sprintf(cmd, "addr2line -e %s %016llx", vmlinux, offset);
+		sprintf(cmd, "addr2line -e %s %016llx", filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
 			continue;
@@ -1224,7 +1225,7 @@ static void get_source_line(struct symbol *sym, __u64 start, int len)
 		if (getline(&path, &line_len, fp) < 0 || !line_len)
 			goto next;
 
-		sym_ext[i].path = malloc(sizeof(char) * line_len);
+		sym_ext[i].path = malloc(sizeof(char) * line_len + 1);
 		if (!sym_ext[i].path)
 			goto next;
 
@@ -1285,7 +1286,7 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	len = sym->end - sym->start;
 
 	if (print_line) {
-		get_source_line(sym, start, len);
+		get_source_line(sym, start, len, filename);
 		print_summary(filename);
 	}
 
-- 
1.6.2.3

