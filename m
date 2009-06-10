Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbZFJRBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbZFJRBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbZFJRAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:00:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZFJQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:59:58 -0400
Message-Id: <20090610165959.132532814@goodmis.org>
References: <20090610165306.794813861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 12:53:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 03/11] tracing: add nsec2sec print formats
Content-Disposition: inline; filename=0003-tracing-add-nsec2sec-print-formats.patch
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
 kernel/trace/trace_read_binary.c |   95 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 94 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
index 0ed7a1f..4ac31f5 100644
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
@@ -47,6 +49,10 @@ static struct trace_seq buffer;
  *              otherwise print FALSE text.
  *  ifmask    : If the bit in MASK in the field is set,
  *              then print the TRUE text, otherwise print FALSE text.
+ *  nsec2sec  : Convert a nsec field into secs in the format:
+ *              printf("%lu.%0Plu", field), where PRECISION defines what 'P' is.
+ *  nsec2usec : Same as nsec2sec but will convert to usec.
+ *  nsec2usec : Same as nsec2sec but will convert to msec.
  *  mask      : Print out the values of a bit mask. Each matching mask will
  *              print its name. The order does matter. Mask of '0' is special
  *              for it will print only if the value matches zero. The given
@@ -68,6 +74,9 @@ enum field_types {
 	FIELD_IS_STRING,
 	FIELD_IS_STRARRAY,
 	FIELD_IS_HEX,
+	FIELD_IS_NSEC2SEC,
+	FIELD_IS_NSEC2USEC,
+	FIELD_IS_NSEC2MSEC,
 	FIELD_IS_MASK,
 	FIELD_IS_SYMBOL,
 };
@@ -100,6 +109,10 @@ struct print_info {
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
@@ -236,6 +249,22 @@ add_if(struct ftrace_event_call *call, enum field_types type,
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
@@ -364,6 +393,7 @@ handle_field(struct ftrace_event_call *event,
 	const char *end, *tok, *delim;
 	unsigned long long mask;
 	unsigned int delim_len;
+	unsigned long precision;
 	int ret;
 
 	end = strchr(fmt, '>');
@@ -412,6 +442,26 @@ handle_field(struct ftrace_event_call *event,
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
@@ -537,6 +587,15 @@ ftrace_initialize_print(struct ftrace_event_call *event, const char *fmt, ...)
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
 
@@ -687,6 +746,7 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 	struct print_info *info;
 	char *start = s->buffer + s->len;
 	struct ftrace_event_field *field;
+	unsigned long divisor, rem;
 	void *p;
 	int len;
 
@@ -798,6 +858,39 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
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
 			field = info->sym_mask.field;
-- 
1.6.3.1

-- 
