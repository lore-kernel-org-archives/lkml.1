Return-Path: <linux-kernel-owner+w=401wt.eu-S934925AbZLGUWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925AbZLGUWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934887AbZLGUWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:22:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964899AbZLGUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:22:04 -0500
Message-Id: <20091207202209.349568674@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Dec 2009 15:19:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/4] [PATCH 3/4] tracing: Add full state to trace_seq
References: <20091207201903.864817226@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-full-state-to-trace_seq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

The trace_seq buffer might fill up, and right now one needs to check the
return value of each printf into the buffer to check for that.

Instead, have the buffer keep track of whether it is full or not, and
reject more input if it is full or would have overflowed with an input
that wasn't added.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h   |    2 +
 kernel/trace/trace_output.c |   61 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 48d81df..dd38678 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -14,6 +14,7 @@ struct trace_seq {
 	unsigned char		buffer[PAGE_SIZE];
 	unsigned int		len;
 	unsigned int		readpos;
+	int			full;
 };
 
 static inline void
@@ -21,6 +22,7 @@ trace_seq_init(struct trace_seq *s)
 {
 	s->len = 0;
 	s->readpos = 0;
+	s->full = 0;
 }
 
 /*
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index e5cf90f..8e46b33 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -93,7 +93,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	va_list ap;
 	int ret;
 
-	if (!len)
+	if (s->full || !len)
 		return 0;
 
 	va_start(ap, fmt);
@@ -101,8 +101,10 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	va_end(ap);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	if (ret >= len) {
+		s->full = 1;
 		return 0;
+	}
 
 	s->len += ret;
 
@@ -127,14 +129,16 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	int len = (PAGE_SIZE - 1) - s->len;
 	int ret;
 
-	if (!len)
+	if (s->full || !len)
 		return 0;
 
 	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	if (ret >= len) {
+		s->full = 1;
 		return 0;
+	}
 
 	s->len += ret;
 
@@ -147,14 +151,16 @@ int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 	int len = (PAGE_SIZE - 1) - s->len;
 	int ret;
 
-	if (!len)
+	if (s->full || !len)
 		return 0;
 
 	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	if (ret >= len) {
+		s->full = 1;
 		return 0;
+	}
 
 	s->len += ret;
 
@@ -175,9 +181,14 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 {
 	int len = strlen(str);
 
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (s->full)
 		return 0;
 
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
+		return 0;
+	}
+
 	memcpy(s->buffer + s->len, str, len);
 	s->len += len;
 
@@ -186,9 +197,14 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 
 int trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
-	if (s->len >= (PAGE_SIZE - 1))
+	if (s->full)
 		return 0;
 
+	if (s->len >= (PAGE_SIZE - 1)) {
+		s->full = 1;
+		return 0;
+	}
+
 	s->buffer[s->len++] = c;
 
 	return 1;
@@ -196,9 +212,14 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 
 int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 {
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (s->full)
 		return 0;
 
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
+		return 0;
+	}
+
 	memcpy(s->buffer + s->len, mem, len);
 	s->len += len;
 
@@ -211,6 +232,9 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
 	const unsigned char *data = mem;
 	int i, j;
 
+	if (s->full)
+		return 0;
+
 #ifdef __BIG_ENDIAN
 	for (i = 0, j = 0; i < len; i++) {
 #else
@@ -228,8 +252,13 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 {
 	void *ret;
 
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (s->full)
+		return 0;
+
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
 		return NULL;
+	}
 
 	ret = s->buffer + s->len;
 	s->len += len;
@@ -241,8 +270,14 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 {
 	unsigned char *p;
 
-	if (s->len >= (PAGE_SIZE - 1))
+	if (s->full)
 		return 0;
+
+	if (s->len >= (PAGE_SIZE - 1)) {
+		s->full = 1;
+		return 0;
+	}
+
 	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
 	if (!IS_ERR(p)) {
 		p = mangle_path(s->buffer + s->len, p, "\n");
@@ -255,6 +290,7 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 		return 1;
 	}
 
+	s->full = 1;
 	return 0;
 }
 
@@ -381,6 +417,9 @@ int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 	unsigned long vmstart = 0;
 	int ret = 1;
 
+	if (s->full)
+		return 0;
+
 	if (mm) {
 		const struct vm_area_struct *vma;
 
-- 
1.6.5


