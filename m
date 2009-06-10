Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZFJFns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZFJFns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZFJFmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:42:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45644 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZFJFmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:51 -0400
Message-Id: <20090610054253.057009329@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 02/11] tracing: add nsec2sec print formats
Content-Disposition: inline; filename=0002-tracing-add-nsec2sec-print-formats.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the tags nsec2sec, nsec2usec and nsec2msec tags that
will do the conversion of a nsec unsigned long long value into a
printf("%lu.%0*lu", precision, nsec) format.

The tags are:

  <nsec2sec:precision:field>
  <nsec2msec:precision:field>
  <nsec2usec:precision:field>

For example, having the field ns that holds an unsigned long long
nanosecond value, we can do:

  <nsec2sec:6:ns>

That will produce something like:

 23.123456  as a value, if ns was 23123456789.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_read_binary.c |  189 +++++++++++++++++++++++++++++++-------
 1 files changed, 154 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
index b47285d..e2cb6c4 100644
--- a/kernel/trace/trace_read_binary.c
+++ b/kernel/trace/trace_read_binary.c
@@ -21,7 +21,9 @@ static struct trace_seq buffer;
  *
  * FMT :=  constant string FMT | COMMAND FMT | empty
  * COMMAND := <TYPE:FIELD> | <mask:FIELD:DELIM:MASKS> | <sym:FIELD:SYMBOLS> |
- *               <if:FIELD:TRUE:FALSE> | <ifmask:FIELD:MASK:TRUE:FALSE>
+ *            <if:FIELD:TRUE:FALSE> | <ifmask:FIELD:MASK:TRUE:FALSE> |
+ *            <nsec2sec:PRECISION:FIELD> | <nsec2usec:PRECISION:FIELD> |
+ *            <nsec2msec:PRECISION:FIELD>
  * TYPE := int | uint | hex | ptr | string | strarray
  * FIELD := defined by the event structure
  * MASKS := MASK=NAME,MASKS | MASK=NAME
@@ -34,6 +36,30 @@ static struct trace_seq buffer;
  * NAME := the name to write when a match is found
  *
  * A '\<' would print '<'
+ *
+ * Commands:
+ *  int       : Print the field out as an signed integer. The size of the field
+ *              determines if it is a char, short, long, or long long.
+ *  uint      : Same as int, but for unsigned.
+ *  hex       : Print the field as a hex (ie. 0x4ab)
+ *  ptr       : Print the field as a hex but without the '0x'.
+ *  string    : Used with dynamic sized strings (__string)
+ *  strarray  : Used with static sized arrays (__array ( char , item, len)).
+ *  if        : If the field is non zero, print the TRUE text,
+ *              otherwise print FALSE text.
+ *  ifmask    : If the bit in MASK in the field is set,
+ *              then print the TRUE text, otherwise print FALSE text.
+ *  nsec2sec  : Convert a nsec field into secs in the format:
+ *              printf("%lu.%0Plu", field), where PRECISION defines what 'P' is.
+ *  nsec2usec : Same as nsec2sec but will convert to usec.
+ *  nsec2usec : Same as nsec2sec but will convert to msec.
+ *  mask      : Print out the values of a bit mask. Each matching mask will
+ *              print its name. The order does matter. Mask of '0' is special
+ *              for it will print only if the value matches zero. The given
+ *              DELIM will separate the different masks.
+ *  sym       : Print out the name of a matching value. This is similar to
+ *              mask, but only one value may print.
+ *
  */
 
 #define TOK_SIZE 32
@@ -49,6 +75,9 @@ enum field_types {
 	FIELD_IS_STRING,
 	FIELD_IS_STRARRAY,
 	FIELD_IS_HEX,
+	FIELD_IS_NSEC2SEC,
+	FIELD_IS_NSEC2USEC,
+	FIELD_IS_NSEC2MSEC,
 	FIELD_IS_MASK,
 	FIELD_IS_SYMBOL,
 };
@@ -81,6 +110,10 @@ struct print_info {
 		} cond;
 		struct {
 			struct ftrace_event_field	*field;
+			unsigned int			precision;
+		} time;
+		struct {
+			struct ftrace_event_field	*field;
 			struct list_head		masks;
 			unsigned short			delim;
 			unsigned short			len;
@@ -217,6 +250,22 @@ add_if(struct ftrace_event_call *call, enum field_types type,
 	return 0;
 }
 
+static int
+add_time(struct ftrace_event_call *call, enum field_types type,
+	 struct ftrace_event_field *field, unsigned int precision)
+{
+	struct print_info *info;
+
+	info = alloc_print_info(call, type);
+	if (!info)
+		return -ENOMEM;
+
+	info->time.field = field;
+	info->time.precision = precision;
+
+	return 0;
+}
+
 static int add_sym_mask(struct ftrace_event_call *call, struct list_head *list,
 			unsigned long long val,
 			const char *start, const char *end)
@@ -344,6 +393,7 @@ handle_field(struct ftrace_event_call *event,
 	const char *end, *tok, *delim;
 	unsigned long long mask;
 	unsigned int delim_len;
+	unsigned long precision;
 	int ret;
 
 	end = strchr(fmt, '>');
@@ -392,6 +442,26 @@ handle_field(struct ftrace_event_call *event,
 			return NULL;
 		break;
 
+	case FIELD_IS_NSEC2SEC:
+	case FIELD_IS_NSEC2USEC:
+	case FIELD_IS_NSEC2MSEC:
+		tok = strchr(fmt, ':');
+		if (!tok || tok > end)
+			goto out_err;
+
+		precision = simple_strtoul(fmt, NULL, 0);
+
+		fmt = tok + 1;
+
+		field = find_field(event, fmt, end - fmt);
+		if (!field)
+			goto out_err;
+
+		ret = add_time(event, field_type, field, precision);
+		if (ret)
+			return NULL;
+		break;
+
 	case FIELD_IS_MASK:
 	case FIELD_IS_SYMBOL:
 		tok = strchr(fmt, ':');
@@ -517,6 +587,15 @@ ftrace_initialize_print(struct ftrace_event_call *event, const char *fmt, ...)
 		else if (strncmp(fmt, "ifmask:", 7) == 0)
 			field_type = FIELD_IS_IFMASK;
 
+		else if (strncmp(fmt, "nsec2sec:", 9) == 0)
+			field_type = FIELD_IS_NSEC2SEC;
+
+		else if (strncmp(fmt, "nsec2usec:", 10) == 0)
+			field_type = FIELD_IS_NSEC2USEC;
+
+		else if (strncmp(fmt, "nsec2msec:", 10) == 0)
+			field_type = FIELD_IS_NSEC2MSEC;
+
 		else if (strncmp(fmt, "mask:", 5) == 0)
 			field_type = FIELD_IS_MASK;
 
@@ -613,6 +692,39 @@ trace_read_symbol(struct trace_seq *s, unsigned long long val,
 
 }
 
+#define BAD_SIZE	0xdeadbeaf
+
+static unsigned long long
+get_val(void *p, int size, unsigned long long *mask)
+{
+	unsigned long long val;
+
+	switch (size) {
+	case 1:
+		val = *(char *)p;
+		*mask =  0xffULL;
+		break;
+	case 2:
+		val = *(short *)p;
+		*mask =  0xffffULL;
+		break;
+	case 4:
+		val = *(int *)p;
+		*mask =  0xffffffffULL;
+		break;
+	case 8:
+		val = *(long long *)p;
+		*mask = 0;
+		break;
+	default:
+		/* pass back a bad mask on error */
+		*mask = BAD_SIZE;
+		return 0;
+	}
+
+	return val;
+}
+
 char *
 ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 		   struct trace_entry *entry)
@@ -621,6 +733,7 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 	struct print_info *info;
 	char *start = s->buffer + s->len;
 	struct ftrace_event_field *field;
+	unsigned long divisor, rem;
 	void *p;
 
 	if (!event->print_text) {
@@ -654,25 +767,8 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
  skip_if:
 			p += field->offset;
 
-			switch (field->size) {
-			case 1:
-				val = *(char *)p;
-				mask =  0xffULL;
-				break;
-			case 2:
-				val = *(short *)p;
-				mask =  0xffffULL;
-				break;
-			case 4:
-				val = *(int *)p;
-				mask =  0xffffffffULL;
-				break;
-			case 8:
-				val = *(long long *)p;
-				mask = 0;
-				break;
-
-			default:
+			val = get_val(p, field->size, &mask);
+			if (mask == BAD_SIZE) {
 				trace_seq_printf(s,
 					"<error: bad field size %d?>\n",
 					field->size);
@@ -723,32 +819,55 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 			trace_seq_puts(s, p);
 			break;
 
+		case FIELD_IS_NSEC2USEC:
+			divisor = NSEC_PER_USEC;
+			goto do_time;
+		case FIELD_IS_NSEC2MSEC:
+			divisor = NSEC_PER_MSEC;
+			goto do_time;
+		case FIELD_IS_NSEC2SEC:
+			divisor = NSEC_PER_SEC;
+
+ do_time:
+			field = info->time.field;
+
+			p += field->offset;
+
+			val = get_val(p, field->size, &mask);
+
+			if (mask == BAD_SIZE) {
+				trace_seq_printf(s,
+					"<error: bad field size %d?>\n",
+					field->size);
+				return start;
+			}
+
+			rem = do_div(val, divisor);
+			if (info->time.precision)
+				trace_seq_printf(s, "%llu.%0*lu",
+						 val, info->time.precision,
+						 rem);
+			else
+				trace_seq_printf(s, "%llu", val);
+
+			break;
+
 		case FIELD_IS_MASK:
 		case FIELD_IS_SYMBOL:
 
 			p += info->sym_mask.field->offset;
 
-			switch (info->sym_mask.field->size) {
-			case 1:
-				val = *(unsigned char *)p;
-				break;
-			case 2:
-				val = *(unsigned short *)p;
-				break;
-			case 4:
-				val = *(unsigned int *)p;
-				break;
-			case 8:
-				val = *(unsigned long long *)p;
-				break;
-
-			default:
+			val = get_val(p, info->sym_mask.field->size, &mask);
+
+			if (mask == BAD_SIZE) {
 				trace_seq_printf(s,
 					 "<error: bad field size %d?>\n",
 					 info->sym_mask.field->size);
 				return start;
 			}
 
+			val &= mask;
+
 			if (info->type == FIELD_IS_MASK)
 				trace_read_mask(s, val, info, event);
 			else
-- 
1.6.3.1

-- 
