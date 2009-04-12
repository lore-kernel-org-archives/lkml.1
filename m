Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZDLJ2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZDLJ2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 05:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbZDLJ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 05:28:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:55170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451AbZDLJ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 05:28:32 -0400
Date: Sun, 12 Apr 2009 09:27:58 GMT
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, tytso@mit.edu, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, tytso@mit.edu, mingo@elte.hu
In-Reply-To: <1239479479-2603-3-git-send-email-tytso@mit.edu>
References: <1239479479-2603-3-git-send-email-tytso@mit.edu>
Subject: [tip:tracing/core] tracing: Document the event tracing system
Message-ID: <tip-1542263998a2d143596972b2776c59c9247578a7@git.kernel.org>
Git-Commit-ID: 1542263998a2d143596972b2776c59c9247578a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 09:28:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1542263998a2d143596972b2776c59c9247578a7
Gitweb:     http://git.kernel.org/tip/1542263998a2d143596972b2776c59c9247578a7
Author:     Theodore Ts'o <tytso@mit.edu>
AuthorDate: Sat, 11 Apr 2009 15:51:18 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 11:23:48 +0200

tracing: Document the event tracing system

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1239479479-2603-3-git-send-email-tytso@mit.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/trace/events.txt |  132 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
new file mode 100644
index 0000000..122522f
--- /dev/null
+++ b/Documentation/trace/events.txt
@@ -0,0 +1,132 @@
+			     Event Tracing
+
+		 Documentation written by Theodore Ts'o
+
+Introduction
+============
+
+Tracepoints (see Documentation/tracing/tracepoints.txt) can be used
+without creating custom kernel modules to register probe functions using
+the event tracing infrastructure.
+
+Not all tracepoints can be traced using the event tracing system; the
+kernel developer must provide code snippets which define how the tracing
+information is saved into the tracing buffer, and how the the tracing
+information should be printed.
+
+Using Event Tracing
+===================
+
+The events which are available for tracing can be found in the file
+/sys/kernel/debug/tracing/available_events.
+
+To enable a particular event, such as 'sched_wakeup', simply echo it to
+/sys/debug/tracing/set_event.  For example:
+
+	# echo sched_wakeup > /sys/kernel/debug/tracing/set_event
+
+To disable an event, echo the event name to the set_event file prefixed
+with an exclamation point:
+
+	# echo '!sched_wakeup' >> /sys/kernel//debug/tracing/set_event
+
+To disable events, echo an empty line to the set_event file:
+
+	# echo > /sys/kernel/debug/tracing/set_event
+
+The events are organized into subsystems, such as ext4, irq, sched,
+etc., and a full event name looks like this: <subsystem>:<event>.  The
+subsystem name is optional, but it is displayed in the available_events
+file.  All of the events in a subsystem can be specified via the syntax
+"<subsystem>:*"; for example, to enable all irq events, you can use the
+command:
+
+	# echo 'irq:*' > /sys/kernel/debug/tracing/set_event
+
+Defining an event-enabled tracepoint
+------------------------------------
+
+A kernel developer which wishes to define an event-enabled tracepoint
+must declare the tracepoint using TRACE_EVENT instead of DECLARE_TRACE.
+This is done via two header files in include/trace.  For example, to
+event-enable the jbd2 subsystem, we must create two files,
+include/trace/jbd2.h and include/trace/jbd2_event_types.h.  The
+include/trace/jbd2.h file should be included by kernel source files that
+will have a tracepoint inserted, and might look like this:
+
+#ifndef _TRACE_JBD2_H
+#define _TRACE_JBD2_H
+
+#include <linux/jbd2.h>
+#include <linux/tracepoint.h>
+
+#include <trace/jbd2_event_types.h>
+
+#endif
+
+In a file that utilizes a jbd2 tracepoint, this header file would be
+included.  Note that you still have to use DEFINE_TRACE().  So for
+example, if fs/jbd2/commit.c planned to use the jbd2_start_commit
+tracepoint, it would have the following near the beginning of the file:
+
+#include <trace/jbd2.h>
+
+DEFINE_TRACE(jbd2_start_commit);
+
+Then in the function that would call the tracepoint, it would call the
+tracepoint function.  (For more information, please see the tracepoint
+documentation in Documentation/trace/tracepoints.txt):
+
+	trace_jbd2_start_commit(journal, commit_transaction);
+
+The code snippets which allow jbd2_start_commit to be an event-enabled
+tracepoint are placed in the file include/trace/jbd2_event_types.h:
+
+/* use <trace/jbd2.h> instead */
+#ifndef TRACE_EVENT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM jbd2
+
+#include <linux/jbd2.h>
+
+TRACE_EVENT(jbd2_start_commit,
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+	TP_ARGS(journal, commit_transaction),
+	TP_STRUCT__entry(
+		__array(	char,	devname, BDEVNAME_SIZE+24 )
+		__field(	int,	transaction		  )
+	),
+	TP_fast_assign(
+		memcpy(__entry->devname, journal->j_devname, BDEVNAME_SIZE+24);
+		__entry->transaction	= commit_transaction->t_tid;
+	),
+	TP_printk("dev %s transaction %d",
+		  __entry->devname, __entry->transaction)
+);
+
+The TP_PROTO and TP_ARGS are unchanged from DECLARE_TRACE.  The new
+arguments to TRACE_EVENT are TP_STRUCT__entry, TP_fast_assign, and
+TP_printk.
+
+TP_STRUCT__entry defines the data structure which will be stored in the
+trace buffer.  Normally, fields in __entry will be arrays or simple
+types.  It is possible to place data structures in __entry --- however,
+pointers in the data structure can not be trusted, since they will be
+accessed sometime later by TP_printk, and if the data structure contains
+fields that will not or cannot be used by TP_printk, this will waste
+space in the trace buffer.  In general, data structures should be
+avoided, unless they do only contain non-pointer types and all of the
+fields will be used by TP_printk.
+
+TP_fast_assign defines the code snippet which saves information into the
+__entry data structure, using the passed-in arguments defined in
+TP_PROTO and TP_ARGS.
+
+Finally, TP_printk will print the __entry data structure.   At the time
+when code snippet defined by TP_printk is executed, it will not have
+access to the TP_ARGS arguments; it can only use the information saved
+in the __entry data structure.
