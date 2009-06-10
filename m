Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZFJFoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZFJFoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZFJFm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:42:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZFJFmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:52 -0400
Message-Id: <20090610054253.523693381@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:10 -0400
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
Subject: [PATCH 04/11] tracing: add major and minor tags for print format
Content-Disposition: inline; filename=0004-tracing-add-major-and-minor-tags-for-print-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Create the tags <major:field> and <minor:field> for trace format prints.

Given a field (should be of type dev_t) these tags will extract the
major or minor number from the field.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_read_binary.c |   44 +++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
index e2cb6c4..a4b5eaa 100644
--- a/kernel/trace/trace_read_binary.c
+++ b/kernel/trace/trace_read_binary.c
@@ -23,7 +23,7 @@ static struct trace_seq buffer;
  * COMMAND := <TYPE:FIELD> | <mask:FIELD:DELIM:MASKS> | <sym:FIELD:SYMBOLS> |
  *            <if:FIELD:TRUE:FALSE> | <ifmask:FIELD:MASK:TRUE:FALSE> |
  *            <nsec2sec:PRECISION:FIELD> | <nsec2usec:PRECISION:FIELD> |
- *            <nsec2msec:PRECISION:FIELD>
+ *            <nsec2msec:PRECISION:FIELD> | <major:FIELD> | <minor:FIELD>
  * TYPE := int | uint | hex | ptr | string | strarray
  * FIELD := defined by the event structure
  * MASKS := MASK=NAME,MASKS | MASK=NAME
@@ -59,7 +59,10 @@ static struct trace_seq buffer;
  *              DELIM will separate the different masks.
  *  sym       : Print out the name of a matching value. This is similar to
  *              mask, but only one value may print.
- *
+ *  major     : Given a 'device number' value, this will convert it to its
+ *              major number.
+ *  minor     : Given a 'device number' value, this will convert it to its
+ *              minor number.
  */
 
 #define TOK_SIZE 32
@@ -75,6 +78,8 @@ enum field_types {
 	FIELD_IS_STRING,
 	FIELD_IS_STRARRAY,
 	FIELD_IS_HEX,
+	FIELD_IS_MINOR,
+	FIELD_IS_MAJOR,
 	FIELD_IS_NSEC2SEC,
 	FIELD_IS_NSEC2USEC,
 	FIELD_IS_NSEC2MSEC,
@@ -405,6 +410,8 @@ handle_field(struct ftrace_event_call *event,
 	case FIELD_IS_UINT:
 	case FIELD_IS_PTR:
 	case FIELD_IS_HEX:
+	case FIELD_IS_MINOR:
+	case FIELD_IS_MAJOR:
 	case FIELD_IS_STRING:
 	case FIELD_IS_STRARRAY:
 		field = find_field(event, fmt, end - fmt);
@@ -605,6 +612,12 @@ ftrace_initialize_print(struct ftrace_event_call *event, const char *fmt, ...)
 		else if (strncmp(fmt, "strarray:", 9) == 0)
 			field_type = FIELD_IS_STRARRAY;
 
+		else if (strncmp(fmt, "major:", 6) == 0)
+			field_type = FIELD_IS_MAJOR;
+
+		else if (strncmp(fmt, "minor:", 6) == 0)
+			field_type = FIELD_IS_MINOR;
+
 		else
 			goto err_format;
 
@@ -758,6 +771,8 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 		case FIELD_IS_UINT:
 		case FIELD_IS_HEX:
 		case FIELD_IS_PTR:
+		case FIELD_IS_MAJOR:
+		case FIELD_IS_MINOR:
 			field = info->data.field;
 			goto skip_if;
 
@@ -775,8 +790,9 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 				return start;
 			}
 
-			if (info->type == FIELD_IS_IF ||
-			    info->type == FIELD_IS_IFMASK) {
+			switch (info->type) {
+			case FIELD_IS_IF:
+			case FIELD_IS_IFMASK:
 
 				if (info->type == FIELD_IS_IFMASK)
 					val &= info->cond.mask;
@@ -789,11 +805,25 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 					trace_seq_putmem(s, event->print_text +
 							 info->cond.false_text,
 							 info->cond.false_len);
-			} else if (info->type == FIELD_IS_INT)
+				break;
+
+			case FIELD_IS_INT:
 				trace_seq_printf(s, "%lld", val);
-			else if (info->type == FIELD_IS_UINT)
+				break;
+
+			case FIELD_IS_UINT:
 				trace_seq_printf(s, "%llu", val);
-			else {
+				break;
+
+			case FIELD_IS_MAJOR:
+				trace_seq_printf(s, "%u", MAJOR(val));
+				break;
+
+			case FIELD_IS_MINOR:
+				trace_seq_printf(s, "%u", MINOR(val));
+				break;
+
+			default:
 				/* hex should only print the size specified */
 				if (mask)
 					val &= mask;
-- 
1.6.3.1

-- 
