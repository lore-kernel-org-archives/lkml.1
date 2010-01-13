Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765Ab0AMKhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0AMKhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932083Ab0AMKg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:36:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:38496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab0AMKgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:36:54 -0500
Date: Wed, 13 Jan 2010 10:35:15 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100105224724.19431.56271.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224724.19431.56271.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Enhance glob string matching
Message-ID: <tip-6964cd2c8efe6e048401f1fe3952a06c563c34c1@git.kernel.org>
Git-Commit-ID: 6964cd2c8efe6e048401f1fe3952a06c563c34c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:35:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6964cd2c8efe6e048401f1fe3952a06c563c34c1
Gitweb:     http://git.kernel.org/tip/6964cd2c8efe6e048401f1fe3952a06c563c34c1
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 5 Jan 2010 17:47:24 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:09:14 +0100

perf tools: Enhance glob string matching

Enhance strglobmatch() for supporting character classes([CHARS],
complementation and ranges are also supported) and escaped
special characters (\*, \? etc).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20100105224724.19431.56271.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
