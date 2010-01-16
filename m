Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0APQ50 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 11:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655Ab0APQ5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 11:57:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0APQ5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 11:57:24 -0500
Date: Sat, 16 Jan 2010 17:57:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20100116165714.GA9073@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
David Sharp (1):
      ring-buffer: Wrap a list.next reference with rb_list_head()

Jan Kiszka (1):
      tracing/x86: Derive arch from bits argument in recordmcount.pl

Li Zefan (7):
      ftrace: Fix MATCH_END_ONLY function filter
      tracing/filters: Fix MATCH_FRONT_ONLY filter matching
      tracing/filters: Fix MATCH_END_ONLY filter matching
      lib: Introduce strnstr()
      tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching
      tracing/filters: Fix MATCH_FULL filter matching for PTR_STRING
      tracing/filters: Add comment for match callbacks

Steven Rostedt (1):
      ring-buffer: Add rb_list_head() wrapper around new reader page next field


 include/linux/string.h             |    5 ++++-
 kernel/trace/ftrace.c              |    6 +++---
 kernel/trace/ring_buffer.c         |    4 ++--
 kernel/trace/trace_events_filter.c |   29 ++++++++++++++++++++---------
 lib/string.c                       |   27 ++++++++++++++++++++++++++-
 scripts/recordmcount.pl            |    2 +-
 6 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index 651839a..a716ee2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -72,7 +72,10 @@ static inline __must_check char *strstrip(char *str)
 }
 
 #ifndef __HAVE_ARCH_STRSTR
-extern char * strstr(const char *,const char *);
+extern char * strstr(const char *, const char *);
+#endif
+#ifndef __HAVE_ARCH_STRNSTR
+extern char * strnstr(const char *, const char *, size_t);
 #endif
 #ifndef __HAVE_ARCH_STRLEN
 extern __kernel_size_t strlen(const char *);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7968762..1e6640f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1690,7 +1690,7 @@ ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;
-	char *ptr;
+	int slen;
 
 	switch (type) {
 	case MATCH_FULL:
@@ -1706,8 +1706,8 @@ static int ftrace_match(char *str, char *regex, int len, int type)
 			matched = 1;
 		break;
 	case MATCH_END_ONLY:
-		ptr = strstr(str, regex);
-		if (ptr && (ptr[len] == 0))
+		slen = strlen(str);
+		if (slen >= len && memcmp(str + slen - len, regex, len) == 0)
 			matched = 1;
 		break;
 	}
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2326b04..edefe3b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2869,7 +2869,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
-	cpu_buffer->reader_page->list.next = reader->list.next;
+	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
 	/*
@@ -2906,7 +2906,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 *
 	 * Now make the new head point back to the reader page.
 	 */
-	reader->list.next->prev = &cpu_buffer->reader_page->list;
+	rb_list_head(reader->list.next)->prev = &cpu_buffer->reader_page->list;
 	rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
 
 	/* Finally update the reader page to the new head */
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 50504cb..e42af9a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -211,8 +211,9 @@ static int filter_pred_pchar(struct filter_pred *pred, void *event,
 {
 	char **addr = (char **)(event + pred->offset);
 	int cmp, match;
+	int len = strlen(*addr) + 1;	/* including tailing '\0' */
 
-	cmp = pred->regex.match(*addr, &pred->regex, pred->regex.field_len);
+	cmp = pred->regex.match(*addr, &pred->regex, len);
 
 	match = cmp ^ pred->not;
 
@@ -251,7 +252,18 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
 	return 0;
 }
 
-/* Basic regex callbacks */
+/*
+ * regex_match_foo - Basic regex callbacks
+ *
+ * @str: the string to be searched
+ * @r:   the regex structure containing the pattern string
+ * @len: the length of the string to be searched (including '\0')
+ *
+ * Note:
+ * - @str might not be NULL-terminated if it's of type DYN_STRING
+ *   or STATIC_STRING
+ */
+
 static int regex_match_full(char *str, struct regex *r, int len)
 {
 	if (strncmp(str, r->pattern, len) == 0)
@@ -261,23 +273,24 @@ static int regex_match_full(char *str, struct regex *r, int len)
 
 static int regex_match_front(char *str, struct regex *r, int len)
 {
-	if (strncmp(str, r->pattern, len) == 0)
+	if (strncmp(str, r->pattern, r->len) == 0)
 		return 1;
 	return 0;
 }
 
 static int regex_match_middle(char *str, struct regex *r, int len)
 {
-	if (strstr(str, r->pattern))
+	if (strnstr(str, r->pattern, len))
 		return 1;
 	return 0;
 }
 
 static int regex_match_end(char *str, struct regex *r, int len)
 {
-	char *ptr = strstr(str, r->pattern);
+	int strlen = len - 1;
 
-	if (ptr && (ptr[r->len] == 0))
+	if (strlen >= r->len &&
+	    memcmp(str + strlen - r->len, r->pattern, r->len) == 0)
 		return 1;
 	return 0;
 }
@@ -781,10 +794,8 @@ static int filter_add_pred(struct filter_parse_state *ps,
 			pred->regex.field_len = field->size;
 		} else if (field->filter_type == FILTER_DYN_STRING)
 			fn = filter_pred_strloc;
-		else {
+		else
 			fn = filter_pred_pchar;
-			pred->regex.field_len = strlen(pred->regex.pattern);
-		}
 	} else {
 		if (field->is_signed)
 			ret = strict_strtoll(pred->regex.pattern, 0, &val);
diff --git a/lib/string.c b/lib/string.c
index 9f75b4e..a1cdcfc 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -667,7 +667,7 @@ EXPORT_SYMBOL(memscan);
  */
 char *strstr(const char *s1, const char *s2)
 {
-	int l1, l2;
+	size_t l1, l2;
 
 	l2 = strlen(s2);
 	if (!l2)
@@ -684,6 +684,31 @@ char *strstr(const char *s1, const char *s2)
 EXPORT_SYMBOL(strstr);
 #endif
 
+#ifndef __HAVE_ARCH_STRNSTR
+/**
+ * strnstr - Find the first substring in a length-limited string
+ * @s1: The string to be searched
+ * @s2: The string to search for
+ * @len: the maximum number of characters to search
+ */
+char *strnstr(const char *s1, const char *s2, size_t len)
+{
+	size_t l1 = len, l2;
+
+	l2 = strlen(s2);
+	if (!l2)
+		return (char *)s1;
+	while (l1 >= l2) {
+		l1--;
+		if (!memcmp(s1, s2, l2))
+			return (char *)s1;
+		s1++;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(strnstr);
+#endif
+
 #ifndef __HAVE_ARCH_MEMCHR
 /**
  * memchr - Find a character in an area of memory.
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 92f09fe..ea6f6e3 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -194,7 +194,7 @@ sub check_objcopy
     }
 }
 
-if ($arch eq "x86") {
+if ($arch =~ /(x86(_64)?)|(i386)/) {
     if ($bits == 64) {
 	$arch = "x86_64";
     } else {
