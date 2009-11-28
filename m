Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZK1Ikj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZK1Ikj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 03:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZK1Iki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 03:40:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZK1Iki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 03:40:38 -0500
Message-ID: <4B10E1F0.80202@cn.fujitsu.com>
Date: Sat, 28 Nov 2009 16:40:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace_output: change struct trace_seq's size to PAGE_SIZE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's not very good that we allocate pages with page_order > 1.
So we change struct trace_seq's size to PAGE_SIZE.

Where we allocate a struct trace_seq:

kernel/trace/trace.c:3720:      s = kmalloc(sizeof(*s), GFP_KERNEL);
kernel/trace/trace_events.c:539:        s = kmalloc(sizeof(*s), GFP_KERNEL);
kernel/trace/trace_events.c:580:        s = kmalloc(sizeof(*s), GFP_KERNEL);
kernel/trace/trace_events.c:604:        s = kmalloc(sizeof(*s), GFP_KERNEL);
kernel/trace/trace_events.c:660:        s = kmalloc(sizeof(*s), GFP_KERNEL);
kernel/trace/trace_events.c:715:        s = kmalloc(sizeof(*s), GFP_KERNEL);
kernel/trace/trace_ksym.c:230:  s = kmalloc(sizeof(*s), GFP_KERNEL);

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 09077f6..128d86a 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -7,13 +7,24 @@
 
 /*
  * Trace sequences are used to allow a function to call several other functions
- * to create a string of data to use (up to a max of PAGE_SIZE).
+ * to create a string of data to use (up to a max of TRACE_SEQ_BUFFER_SIZE).
  */
 
 struct trace_seq {
-	unsigned char		buffer[PAGE_SIZE];
-	unsigned int		len;
-	unsigned int		readpos;
+	union {
+		struct {
+			unsigned int		len;
+			unsigned int		readpos;
+			unsigned char		buffer[];
+		};
+		unsigned char __make_it_PAGE_SIZE[PAGE_SIZE];
+	};
+};
+
+#define TRACE_SEQ_BUFFER_SIZE (PAGE_SIZE - offsetof(struct trace_seq, buffer))
+
+struct __check_trace_seq_size {
+	int __check[-!!(sizeof(struct trace_seq) - PAGE_SIZE)];
 };
 
 static inline void
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b6c12c6..578e347 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -25,7 +25,10 @@ static int next_event_type = __TRACE_LAST_TYPE + 1;
 
 void trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
-	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+	int len = s->len;
+
+	if (len >= TRACE_SEQ_BUFFER_SIZE)
+		len =  TRACE_SEQ_BUFFER_SIZE - 1;
 
 	seq_write(m, s->buffer, len);
 
@@ -81,7 +84,7 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
 int
 trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	int len = (TRACE_SEQ_BUFFER_SIZE - 1) - s->len;
 	va_list ap;
 	int ret;
 
@@ -116,7 +119,7 @@ EXPORT_SYMBOL_GPL(trace_seq_printf);
 int
 trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	int len = (TRACE_SEQ_BUFFER_SIZE - 1) - s->len;
 	int ret;
 
 	if (!len)
@@ -136,7 +139,7 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
 int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	int len = (TRACE_SEQ_BUFFER_SIZE - 1) - s->len;
 	int ret;
 
 	if (!len)
@@ -167,7 +170,7 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 {
 	int len = strlen(str);
 
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (len > ((TRACE_SEQ_BUFFER_SIZE - 1) - s->len))
 		return 0;
 
 	memcpy(s->buffer + s->len, str, len);
@@ -178,7 +181,7 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 
 int trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
-	if (s->len >= (PAGE_SIZE - 1))
+	if (s->len >= (TRACE_SEQ_BUFFER_SIZE - 1))
 		return 0;
 
 	s->buffer[s->len++] = c;
@@ -188,7 +191,7 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 
 int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 {
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (len > ((TRACE_SEQ_BUFFER_SIZE - 1) - s->len))
 		return 0;
 
 	memcpy(s->buffer + s->len, mem, len);
@@ -220,7 +223,7 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 {
 	void *ret;
 
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (len > ((TRACE_SEQ_BUFFER_SIZE - 1) - s->len))
 		return NULL;
 
 	ret = s->buffer + s->len;
@@ -233,9 +236,9 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 {
 	unsigned char *p;
 
-	if (s->len >= (PAGE_SIZE - 1))
+	if (s->len >= (TRACE_SEQ_BUFFER_SIZE - 1))
 		return 0;
-	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
+	p = d_path(path, s->buffer + s->len, TRACE_SEQ_BUFFER_SIZE - s->len);
 	if (!IS_ERR(p)) {
 		p = mangle_path(s->buffer + s->len, p, "\n");
 		if (p) {

