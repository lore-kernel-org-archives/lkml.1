Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408Ab0AEWmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0AEWmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384Ab0AEWmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:42:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab0AEWmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:42:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 7/8] perf tools: Enhance glob string matching
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Date: Tue, 05 Jan 2010 17:47:24 -0500
Message-ID: <20100105224724.19431.56271.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance strglobmatch() for supporting character classes([CHARS],
complementation and ranges are also supported) and escaped special
characters (\*, \? etc).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---

 tools/perf/util/string.c |   65 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 5352d7d..c397d4f 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -227,16 +227,73 @@ fail:
 	return NULL;
 }
 
-/* Glob expression pattern matching */
+/* Character class matching */
+static bool __match_charclass(const char *pat, char c, const char **npat)
+{
+	bool complement = false, ret = true;
+
+	if (*pat == '!') {
+		complement = true;
+		pat++;
+	}
+	if (*pat++ == c)	/* First character is special */
+		goto end;
+
+	while (*pat && *pat != ']') {	/* Matching */
+		if (*pat == '-' && *(pat + 1) != ']') {	/* Range */
+			if (*(pat - 1) <= c && c <= *(pat + 1))
+				goto end;
+			if (*(pat - 1) > *(pat + 1))
+				goto error;
+			pat += 2;
+		} else if (*pat++ == c)
+			goto end;
+	}
+	if (!*pat)
+		goto error;
+	ret = false;
+
+end:
+	while (*pat && *pat != ']')	/* Searching closing */
+		pat++;
+	if (!*pat)
+		goto error;
+	*npat = pat + 1;
+	return complement ? !ret : ret;
+
+error:
+	return false;
+}
+
+/**
+ * strglobmatch - glob expression pattern matching
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This returns true if the @str matches @pat. @pat can includes wildcards
+ * ('*','?') and character classes ([CHARS], complementation and ranges are
+ * also supported). Also, this supports escape character ('\') to use special
+ * characters as normal character.
+ *
+ * Note: if @pat syntax is broken, this always returns false.
+ */
 bool strglobmatch(const char *str, const char *pat)
 {
 	while (*str && *pat && *pat != '*') {
-		if (*pat == '?') {
+		if (*pat == '?') {	/* Matches any single character */
 			str++;
 			pat++;
-		} else
-			if (*str++ != *pat++)
+			continue;
+		} else if (*pat == '[')	/* Character classes/Ranges */
+			if (__match_charclass(pat + 1, *str, &pat)) {
+				str++;
+				continue;
+			} else
 				return false;
+		else if (*pat == '\\') /* Escaped char match as normal char */
+			pat++;
+		if (*str++ != *pat++)
+			return false;
 	}
 	/* Check wild card */
 	if (*pat == '*') {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
