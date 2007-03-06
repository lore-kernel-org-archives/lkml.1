Return-Path: <linux-kernel-owner+w=401wt.eu-S964863AbXCFTT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863AbXCFTT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbXCFTT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:19:26 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:46451 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbXCFTTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:19:24 -0500
Subject: [Patch 1/2] add for_each_substring() and match_substring()
From: Martin Peschke <mp3@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Wu Fengguang <wfg@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 20:19:23 +0100
Message-Id: <1173208763.5266.8.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds for_each_substring() and match_substring() to lib/parser.c.
Using these instead of strsep() and match_token() is more comfortable,
less error prone and safer.

strsep() is destructive; it changes the string it is working on.
match_token() needs strsep() to chop a large string up into smaller
\0-terminated pieces. Callers might need to create a working copy
of the string to be parsed.  

In contrast, match_substring() contents itself with non-\0-terminated
substrings provided by for_each_substring().

Converting users of strsep() / match_token() to for_each_substring() /
match_substring(), e.g. all the stuff in fs/, should not be difficult.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 include/linux/parser.h |    7 +++++++
 lib/parser.c           |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

Index: linux/include/linux/parser.h
===================================================================
--- linux.orig/include/linux/parser.h
+++ linux/include/linux/parser.h
@@ -26,9 +26,16 @@ typedef struct {
 } substring_t;
 
 int match_token(char *, match_table_t table, substring_t args[]);
+int match_substring(substring_t *, match_table_t table, substring_t args[]);
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
 void match_strcpy(char *, substring_t *);
 char *match_strdup(substring_t *);
+char *match_to(const char *cs, const char *ct);
 int match_s64(substring_t *, s64 *result, int);
+
+#define for_each_substring(s, start, delim) \
+	for ((s)->from = start, (s)->to = match_to((s)->from, delim); \
+	     (s)->to; \
+	     (s)->from = (s)->to + 1, (s)->to = match_to((s)->from, delim))
Index: linux/lib/parser.c
===================================================================
--- linux.orig/lib/parser.c
+++ linux/lib/parser.c
@@ -27,7 +27,7 @@ static int match_one(char *s, char *p, s
 	char *meta;
 	int argc = 0;
 
-	if (!p)
+	if (!p || !s)
 		return 1;
 
 	while(1) {
@@ -111,6 +111,36 @@ int match_token(char *s, match_table_t t
 }
 
 /**
+ * match_substring: - Find a token (and optional args) in a substring
+ * @sub: the substring to examine for token/argument pairs
+ * @table: match_table_t describing the set of allowed option tokens and the
+ * arguments that may be associated with them. Must be terminated with a
+ * &struct match_token whose pattern is set to the NULL pointer.
+ * @args: array of %MAX_OPT_ARGS &substring_t elements. Used to return match
+ * locations.
+ *
+ * Description: Detects which if any of a set of token strings has been passed
+ * to it. Tokens can include up to MAX_OPT_ARGS instances of basic c-style
+ * format identifiers which will be taken into account when matching the
+ * tokens, and whose locations will be returned in the @args array.
+ */
+int match_substring(substring_t *sub, match_table_t table, substring_t args[])
+{
+	char *s;
+	int token, i;
+
+	memset(args, 0, MAX_OPT_ARGS * sizeof(substring_t));
+	s = match_strdup(sub);
+	token = match_token(s, table, args);
+	for (i = 0; i < MAX_OPT_ARGS; i++) {
+		args[i].from += sub->from - s;
+		args[i].to += sub->from - s;
+	}
+	kfree(s);
+	return token;
+}
+
+/**
  * match_number: scan a number in the given base from a substring_t
  * @s: substring to be scanned
  * @result: resulting integer on success
@@ -237,6 +267,17 @@ char *match_strdup(substring_t *s)
 	return p;
 }
 
+char *match_to(const char *cs, const char *ct)
+{
+	char *delim = strpbrk(cs, ct);
+	if (delim)
+		return delim;
+	else if (*cs != '\0')
+		return (char *)(cs + strlen(cs));
+	else
+		return NULL;
+}
+
 EXPORT_SYMBOL(match_token);
 EXPORT_SYMBOL(match_int);
 EXPORT_SYMBOL(match_octal);
@@ -244,3 +285,5 @@ EXPORT_SYMBOL(match_hex);
 EXPORT_SYMBOL(match_strcpy);
 EXPORT_SYMBOL(match_strdup);
 EXPORT_SYMBOL(match_s64);
+EXPORT_SYMBOL(match_to);
+EXPORT_SYMBOL(match_substring);


