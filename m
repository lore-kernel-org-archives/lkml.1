Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbZIJFYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbZIJFYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZIJFYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:24:42 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:58039 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZIJFYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=brjFGeqika6tdFIrx4q0QpUYgnKWkCXCxFmMBMeChtNrGPGw0+aKJ0OvsLUihtPoCA
         PZPiooDLjr0bptvOv26fD6HDiHYW67LGYxBJQgy6AGPtf26rBo3rTu4CpCeK0Jo2cX6c
         sDWtLJg2JAyfTHBUH/yCSlTP3eEjL395bN9UQ=
Subject: [PATCH] tracing/filters: add filter Documentation
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 00:24:41 -0500
Message-Id: <1252560281.6431.38.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation for event filters and formats.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

---
 Documentation/trace/events.txt |  184 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 183 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 2bcc8d4..57e0a08 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -1,7 +1,7 @@
 			     Event Tracing
 
 		Documentation written by Theodore Ts'o
-			Updated by Li Zefan
+		Updated by Li Zefan and Tom Zanussi
 
 1. Introduction
 ===============
@@ -97,3 +97,185 @@ The format of this boot option is the same as described in section 2.1.
 
 See The example provided in samples/trace_events
 
+4. Event formats
+================
+
+Each trace event has a 'format' file associated with it that contains
+a description of each field in a logged event.  This information can
+be used to parse the binary trace stream, and is also the place to
+find the field names that can be used in event filters (see section 5).
+
+It also displays the format string that will be used to print the
+event in text mode, along with the event name and ID used for
+profiling.
+
+Every event has a set of 'common' fields associated with it; these are
+the fields prefixed with 'common_'.  The other fields vary between
+events and correspond to the fields defined in the TRACE_EVENT
+definition for that event.
+
+Each field in the format has the form:
+
+     field:field-type field-name; offset:N; size:N;
+
+where offset is the offset of the field in the trace record and size
+is the size of the data item, in bytes.
+
+For example, here's the information displayed for the 'sched_wakeup'
+event:
+
+# cat /debug/tracing/events/sched/sched_wakeup/format
+
+name: sched_wakeup
+ID: 60
+format:
+	field:unsigned short common_type;	offset:0;	size:2;
+	field:unsigned char common_flags;	offset:2;	size:1;
+	field:unsigned char common_preempt_count;	offset:3;	size:1;
+	field:int common_pid;	offset:4;	size:4;
+	field:int common_tgid;	offset:8;	size:4;
+
+	field:char comm[TASK_COMM_LEN];	offset:12;	size:16;
+	field:pid_t pid;	offset:28;	size:4;
+	field:int prio;	offset:32;	size:4;
+	field:int success;	offset:36;	size:4;
+	field:int cpu;	offset:40;	size:4;
+
+print fmt: "task %s:%d [%d] success=%d [%03d]", REC->comm, REC->pid,
+	   REC->prio, REC->success, REC->cpu
+
+This event contains 10 fields, the first 5 common and the remaining 5
+event-specific.  All the fields for this event are numeric, except for
+'comm' which is a string, a distinction important for event filtering.
+
+5. Event filtering
+==================
+
+Trace events can be filtered in the kernel by associating boolean
+'filter expressions' with them.  As soon as an event is logged into
+the trace buffer, its fields are checked against the filter expression
+associated with that event type.  An event with field values that
+'match' the filter will appear in the trace output, and an event whose
+values don't match will be discarded.  An event with no filter
+associated with it matches everything, and is the default when no
+filter has been set for an event.
+
+5.1 Expression syntax
+---------------------
+
+A filter expression consists of one or more 'predicates' that can be
+combined using the logical operators '&&' and '||'.  A predicate is
+simply a clause that compares the value of a field contained within a
+logged event with a constant value and returns either 0 or 1 depending
+on whether the field value matched (1) or didn't match (0):
+
+	  field-name relational-operator value
+
+Parentheses can be used to provide arbitrary logical groupings and
+double-quotes can be used to prevent the shell from interpreting
+operators as shell metacharacters.
+
+The field-names available for use in filters can be found in the
+'format' files for trace events (see section 4).
+
+The relational-operators depend on the type of the field being tested:
+
+The operators available for numeric fields are:
+    
+==, !=, <, <=, >, >=
+
+And for string fields they are:
+    
+==, !=
+
+Currently, only exact string matches are supported.
+
+Currently, the maximum number of predicates in a filter is set at 16.
+
+5.2 Setting filters
+-------------------
+
+A filter for an individual event is set by writing a filter expression
+to the 'filter' file for the given event.
+
+For example:
+
+# cd /debug/tracing/events/sched/sched_wakeup
+# echo "common_preempt_count > 4" > filter
+
+A slightly more involved example:
+
+# cd /debug/tracing/events/sched/sched_signal_send
+# echo "((sig >= 10 && sig < 15) || sig == 17) && comm != bash" > filter
+
+If there was an error in the expression, you'll get an 'Invalid
+argument' error when setting it, and the erroneous string along with
+an error message can be seen by looking at the filter e.g.:
+
+# cd /debug/tracing/events/sched/sched_signal_send
+# echo "((sig >= 10 && sig < 15) || dsig == 17) && comm != bash" > filter
+-bash: echo: write error: Invalid argument
+# cat filter
+((sig >= 10 && sig < 15) || dsig == 17) && comm != bash
+^
+parse_error: Field not found
+
+Currently the caret for an error always appears at the beginning of
+the filter string; the error message should still be useful though
+even without more accurate position info.
+
+5.3 Clearing filters
+--------------------
+    
+To clear the filter for an event, write a '0' to the event's filter
+file.
+
+To clear the filters for all events in a subsystem, write a '0' to the
+subsystem's filter file.
+
+5.3 Subsystem filters
+---------------------
+
+For convenience, filters for every event in a subsystem can be set or
+cleared as a group by writing a filter expression into the filter file
+at the root of the subsytem.  Note however, that if a filter for any
+event within the subsystem lacks a field specified in the subsystem
+filter, or if the filter can't be applied for any other reason, the
+filter for that event will retain its previous setting.  This can
+result in an unintended mixture of filters which could lead to
+confusing (to the user who might think different filters are in
+effect) trace output.  Only filters that reference just the common
+fields can be guaranteed to propagate successfully to all events.
+
+Here are a few subsystem filter examples that also illustrate the
+above points:
+
+Clear the filters on all events in the sched subsytem:
+
+# cd /sys/kernel/debug/tracing/events/sched
+# echo 0 > filter
+# cat sched_switch/filter
+none
+# cat sched_switch/filter
+none
+
+Set a filter using only common fields for all events in the sched
+subsytem (all events end up with the same filter):
+
+# cd /sys/kernel/debug/tracing/events/sched
+# echo common_pid == 0 > filter
+# cat sched_switch/filter
+common_pid == 0
+# cat sched_wakeup/filter
+common_pid == 0
+
+Attempt to set a filter using a non-common field for all events in the
+sched subsytem (all events but those that have a prev_pid field retain
+their old filters):
+
+# cd /sys/kernel/debug/tracing/events/sched
+# echo prev_pid == 0 > filter
+# cat sched_switch/filter
+prev_pid == 0
+# cat sched_wakeup/filter
+common_pid == 0
-- 
1.5.6.3



