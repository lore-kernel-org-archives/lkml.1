Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbZFJRAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbZFJRAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbZFJRAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:00:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbZFJQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:59:58 -0400
Message-Id: <20090610165959.360669328@goodmis.org>
References: <20090610165306.794813861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 12:53:10 -0400
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
 kernel/trace/trace_read_binary.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
index 4ac31f5..4378350 100644
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
@@ -59,6 +59,10 @@ static struct trace_seq buffer;
  *              DELIM will separate the different masks.
  *  sym       : Print out the name of a matching value. This is similar to
  *              mask, but only one value may print.
+ *  major     : Given a 'device number' value, this will convert it to its
+ *              major number.
+ *  minor     : Given a 'device number' value, this will convert it to its
+ *              minor number.
  */
 
 #define TOK_SIZE 32
@@ -74,6 +78,8 @@ enum field_types {
 	FIELD_IS_STRING,
 	FIELD_IS_STRARRAY,
 	FIELD_IS_HEX,
+	FIELD_IS_MINOR,
+	FIELD_IS_MAJOR,
 	FIELD_IS_NSEC2SEC,
 	FIELD_IS_NSEC2USEC,
 	FIELD_IS_NSEC2MSEC,
@@ -405,6 +411,8 @@ handle_field(struct ftrace_event_call *event,
 	case FIELD_IS_UINT:
 	case FIELD_IS_PTR:
 	case FIELD_IS_HEX:
+	case FIELD_IS_MINOR:
+	case FIELD_IS_MAJOR:
 	case FIELD_IS_STRING:
 	case FIELD_IS_STRARRAY:
 		field = find_field(event, fmt, end - fmt);
@@ -605,6 +613,12 @@ ftrace_initialize_print(struct ftrace_event_call *event, const char *fmt, ...)
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
 
@@ -772,6 +786,8 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 		case FIELD_IS_UINT:
 		case FIELD_IS_HEX:
 		case FIELD_IS_PTR:
+		case FIELD_IS_MAJOR:
+		case FIELD_IS_MINOR:
 			field = info->data.field;
 			goto skip_if;
 
@@ -813,6 +829,16 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 
 			case FIELD_IS_UINT:
 				trace_seq_printf(s, "%llu", val);
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
 			default:
 				/* hex should only print the size specified */
 				if (mask)
-- 
1.6.3.1

-- 
