Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbZKYHQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbZKYHQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZKYHQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:16:12 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:33707 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZKYHQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Md39KNqqkSEgUO+J1uA++BYl00ApA1DTdrovKMS50oCmayfO7/AOPqFAXGgQTehiyv
         qj7cpUtLSqoCveqdcsxEdphKmef5z4N/ybbmJvP/fmt5/dbLqmPEZZC5r6KnHKV9sugW
         dkf4SST2ZKq9/6ZxED53g7FmaSJi9Gr9q90Gw=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [RFC][PATCH 6/7] perf trace: Add Documentation for perf trace Perl support
Date: Wed, 25 Nov 2009 01:15:51 -0600
Message-Id: <1259133352-23685-7-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds perf-trace-perl Documentation and a link to it from the
perf-trace page.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Documentation/perf-trace-perl.txt |  219 ++++++++++++++++++++++++++
 tools/perf/Documentation/perf-trace.txt      |   11 ++-
 2 files changed, 229 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-trace-perl.txt

diff --git a/tools/perf/Documentation/perf-trace-perl.txt b/tools/perf/Documentation/perf-trace-perl.txt
new file mode 100644
index 0000000..c5f55f4
--- /dev/null
+++ b/tools/perf/Documentation/perf-trace-perl.txt
@@ -0,0 +1,219 @@
+perf-trace-perl(1)
+==================
+
+NAME
+----
+perf-trace-perl - Process trace data with a Perl script
+
+SYNOPSIS
+--------
+[verse]
+'perf trace' [-s [lang]:script[.ext] ]
+
+DESCRIPTION
+-----------
+
+This perf trace option is used to process perf trace data using perf's
+built-in Perl interpreter.  It reads and processes the input file and
+displays the results of the trace analysis implemented in the given
+Perl script, if any.
+
+STARTER SCRIPTS
+---------------
+
+You can avoid reading the rest of this document by running 'perf trace
+-g perl' in the same directory as an existing perf.data trace file.
+That will generate a starter script containing a handler for each of
+the event types in the trace file; it simply prints every available
+field for each event in the trace file.
+
+You can also look at the existing scripts in
+~/libexec/perf-core/scripts/perl for typical examples showing how to
+do basic things like aggregate event data, print results, etc.  Also,
+the check-perf-trace.pl script, while not interesting for its results,
+attempts to exercise all of the main scripting features.
+
+EVENT HANDLERS
+--------------
+
+When perf trace is invoked using a trace script, a user-defined
+'handler function' is called for each event in the trace.  If there's
+no handler function defined for a given event type, the event is
+ignored (or passed to a 'trace_handled' function, see below) and the
+next event is processed.
+
+Most of the event's field values are passed as arguments to the
+handler function; some of the less common ones aren't - those are
+available as calls back into the perf executable (see below).
+
+As an example, the following perf record command can be used to record
+all sched_wakeup events in the system:
+
+ # perf record -c 1 -f -a -M -R -e sched:sched_wakeup
+
+Traces meant to be processed using a script should be recorded with
+the above options: -c 1 says to sample every event, -a to enable
+system-wide collection, -M to multiplex the output, and -R to collect
+raw samples.
+
+The format file for the sched_wakep event defines the following fields
+(see /sys/kernel/debug/tracing/events/sched/sched_wakeup/format):
+
+----
+ format:
+        field:unsigned short common_type;
+        field:unsigned char common_flags;
+        field:unsigned char common_preempt_count;
+        field:int common_pid;
+        field:int common_lock_depth;
+
+        field:char comm[TASK_COMM_LEN];
+        field:pid_t pid;
+        field:int prio;
+        field:int success;
+        field:int target_cpu;
+----
+
+The handler function for this event would be defined as:
+
+----
+sub sched::sched_wakeup
+{
+   my ($event_name, $context, $common_cpu, $common_secs,
+       $common_nsecs, $common_pid, $common_comm,
+       $comm, $pid, $prio, $success, $target_cpu) = @_;
+}
+----
+
+The handler function takes the form subsystem::event_name.
+
+The $common_* arguments in the handler's argument list are the set of
+arguments passed to all event handlers; some of the fields correspond
+to the common_* fields in the format file, but some are synthesized,
+and some of the common_* fields aren't common enough to to be passed
+to every event as arguments but are available as library functions.
+
+Here's a brief description of each of the invariant event args:
+
+ $event_name 	  	    the name of the event as text
+ $context		    an opaque 'cookie' used in calls back into perf
+ $common_cpu		    the cpu the event occurred on
+ $common_secs		    the secs portion of the event timestamp
+ $common_nsecs		    the nsecs portion of the event timestamp
+ $common_pid		    the pid of the current task
+ $common_comm		    the name of the current process
+
+All of the remaining fields in the event's format file have
+counterparts as handler function arguments of the same name, as can be
+seen in the example above.
+
+The above provides the basics needed to directly access every field of
+every event in a trace, which covers 90% of what you need to know to
+write a useful trace script.  The sections below cover the rest.
+
+SCRIPT LAYOUT
+-------------
+
+Every perf trace Perl script should start by setting up a Perl module
+search path and 'use'ing a few support modules (see module
+descriptions below):
+
+----
+ use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+ use lib "./Perf-Trace-Util/lib";
+ use Perf::Trace::Core;
+ use Perf::Trace::Context;
+ use Perf::Trace::Util;
+----
+
+The rest of the script can contain handler functions and support
+functions in any order.
+
+Aside from the event handler functions discussed above, every script
+can implement a set of optional functions:
+
+*trace_begin*, if defined, is called before any event is processed and
+gives scripts a chance to do setup tasks:
+
+----
+ sub trace_begin
+ {
+ }
+----
+
+*trace_end*, if defined, is called after all events have been
+ processed and gives scripts a chance to do end-of-script tasks, such
+ as display results:
+
+----
+sub trace_end
+{
+}
+----
+
+*trace_unhandled*, if defined, is called after for any event that
+ doesn't have a handler explicitly defined for it.  The standard set
+ of common arguments are passed into it:
+
+----
+sub trace_unhandled
+{
+    my ($event_name, $context, $common_cpu, $common_secs,
+        $common_nsecs, $common_pid, $common_comm) = @_;
+}
+----
+
+The remaining sections provide descriptions of each of the available
+built-in perf trace Perl modules and their associated functions.
+
+AVAILABLE MODULES AND FUNCTIONS
+-------------------------------
+
+The following sections describe the functions and variables available
+via the various Perf::Trace::* Perl modules.  To use the functions and
+variables from the given module, add the corresponding 'use
+Perf::Trace::XXX' line to your perf trace script.
+
+Perf::Trace::Core Module
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+These functions provide some essential functions to user scripts.
+
+The *flag_str* and *symbol_str* functions provide human-readable
+strings for flag and symbolic fields.  These correspond to the strings
+and values parsed from the 'print fmt' fields of the event format
+files:
+
+  flag_str($event_name, $field_name, $field_value) - returns the string represention corresponding to $field_value for the flag field $field_name of event $event_name
+  symbol_str($event_name, $field_name, $field_value) - returns the string represention corresponding to $field_value for the symbolic field $field_name of event $event_name
+
+Perf::Trace::Context Module
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Some of the 'common' fields in the event format file aren't all that
+common, but need to be made accessible to user scripts nonetheless.
+
+Perf::Trace::Context defines a set of functions that can be used to
+access this data in the context of the current event.  Each of these
+functions expects a $context variable, which is the same as the
+$context variable passed into every event handler as the second
+argument.
+
+ common_pc($context) - returns common_preempt count for the current event
+ common_flags($context) - returns common_flags for the current event
+ common_lock_depth($context) - returns common_lock_depth for the current event
+
+Perf::Trace::Util Module
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+Various utility functions for use with perf trace:
+
+  nsecs($secs, $nsecs) - returns total nsecs given secs/nsecs pair
+  nsecs_secs($nsecs) - returns whole secs portion given nsecs
+  nsecs_nsecs($nsecs) - returns nsecs remainder given nsecs
+  nsecs_str($nsecs) - returns printable string in the form secs.nsecs
+  avg($total, $n) - returns average given a sum and a total number of values
+
+SEE ALSO
+--------
+linkperf:perf-trace[1]
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 41ed753..07065ef 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -20,6 +20,15 @@ OPTIONS
 --dump-raw-trace=::
         Display verbose dump of the trace data.
 
+-s::
+--script=::
+        Process trace data with the given script ([lang]:script[.ext]).
+
+-g::
+--gen-script=::
+        Generate perf-trace.[ext] starter script for given language,
+        using current perf.data.
+
 SEE ALSO
 --------
-linkperf:perf-record[1]
+linkperf:perf-record[1], linkperf:perf-trace-perl[1]
-- 
1.6.4.GIT

