Return-Path: <linux-kernel-owner+w=401wt.eu-S936450AbZLQS3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936450AbZLQS3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935554AbZLQS3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:29:34 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52409 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935493AbZLQS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:29:33 -0500
Message-ID: <4B2A7878.6060209@us.ibm.com>
Date: Thu, 17 Dec 2009 10:29:12 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: [PATCH V3] tracecmd: Start of a tracecmd swig wrapper for python
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e284c90944b6362bc9dd0b3f53a35ece66590d97 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 16 Dec 2009 15:25:30 -0800
Subject: [PATCH V3] tracecmd: Start of a tracecmd swig wrapper for python

Introduce a python ctracecmd module for use in rapidly prototyping
tracing applications. The interface description is provided in
ctracecmd.i, it identifies which functions are available from within
python. A test python script is provided as tracecmd-test.py.

These bindings are expected to change significantly. Eventually I
would like to wrap this automated binding with more pythonic objects,
most likely including Trace and Event objects which merge the
functionality of tracecmd-input, pevent, record, and event structures.
This will make development of python apps much more accessible to many
application developers.

For now, this is mostly a proof of concept and is no where near
complete. It can however open a trace file and read all the events from
it, displaying them by CPU in chronological order.

V2: o Simplified interface file with SWIG ifdefs in the header files
V3: o Move attribute removal to interface file
    o Remove proxy classes and rename module to ctracecmd
    o Use the Makefile with a phony python target instead of swig.sh

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 Makefile         |   10 +++++++++-
 ctracecmd.i      |   17 +++++++++++++++++
 parse-events.h   |    2 --
 trace-cmd.h      |    2 ++
 tracecmd-test.py |   36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 64 insertions(+), 3 deletions(-)
 create mode 100644 ctracecmd.i
 create mode 100755 tracecmd-test.py

diff --git a/Makefile b/Makefile
index 42cb7ad..313ff99 100644
--- a/Makefile
+++ b/Makefile
@@ -83,6 +83,14 @@ plugin_mac80211.o: plugin_mac80211.c parse-events.h
 plugin_mac80211.so: plugin_mac80211.o
 	$(CC) -shared -nostartfiles -o $@ $<
 
+
+.PHONY: python
+python:	$(TCMD_LIB_OBJS) trace-cmd.o trace-read.o
+	swig -Wall -python -noproxy ctracecmd.i
+	gcc -fpic -c  -I/usr/include/python2.6/ -I/usr/lib/python2.6/config ctracecmd_wrap.c
+	$(CC) --shared $^ ctracecmd_wrap.o -o ctracecmd.so
+
+
 .PHONY: force
 force:
 
@@ -90,4 +98,4 @@ TAGS:	force
 	find . -name '*.[ch]' | xargs etags
 
 clean:
-	$(RM) *.o *~ $(TARGETS) *.a *.so
+	$(RM) *.o *~ $(TARGETS) *.a *.so ctracecmd_wrap.c
diff --git a/ctracecmd.i b/ctracecmd.i
new file mode 100644
index 0000000..80fface
--- /dev/null
+++ b/ctracecmd.i
@@ -0,0 +1,17 @@
+// tracecmd.i
+%module ctracecmd
+
+%{
+#include "trace-cmd.h"
+%}
+
+%inline %{
+%}
+
+/* SWIG can't grok these, define them to nothing */
+#define __trace
+#define __attribute__(x)
+#define __thread
+
+%include "trace-cmd.h"
+%include "parse-events.h"
diff --git a/parse-events.h b/parse-events.h
index e6f5806..9a2c608 100644
--- a/parse-events.h
+++ b/parse-events.h
@@ -275,8 +275,6 @@ struct pevent {
 	struct format_field *bprint_buf_field;
 };
 
-void parse_set_info(struct pevent *pevent, int nr_cpus, int long_sz);
-
 void die(char *fmt, ...);
 void *malloc_or_die(unsigned int size);
 void warning(char *fmt, ...);
diff --git a/trace-cmd.h b/trace-cmd.h
index 1c4d359..6f645c5 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -83,8 +83,10 @@ int tracecmd_set_cpu_to_timestamp(struct tracecmd_input *handle,
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle);
 struct pevent *tracecmd_get_pevent(struct tracecmd_input *handle);
 
+#ifndef SWIG
 /* hack for function graph work around */
 extern __thread struct tracecmd_input *tracecmd_curr_thread_handle;
+#endif
 
 
 /* --- Creating and Writing the trace.dat file --- */
diff --git a/tracecmd-test.py b/tracecmd-test.py
new file mode 100755
index 0000000..094ce81
--- /dev/null
+++ b/tracecmd-test.py
@@ -0,0 +1,36 @@
+#!/usr/bin/env python
+
+from ctracecmd import *
+
+# Let's move the following into a new Trace object constructor
+filename = "trace.dat"
+trace_file = open(filename)
+handle = tracecmd_open(trace_file.fileno())
+tracecmd_read_headers(handle)
+tracecmd_init_data(handle)
+
+# These should be members, i.e. Trace.cpus
+pe = tracecmd_get_pevent(handle)
+cpus = tracecmd_cpus(handle)
+print "Trace %s contains data for %d cpus" % (filename, cpus) 
+
+# FIXME: this doesn't print anything...
+tracecmd_print_events(handle)
+
+print "Cycling through the events for each CPU"
+for cpu in range(0,cpus):
+    print "CPU", cpu
+    rec = tracecmd_read_data(handle, cpu)
+    while True:
+        if rec:
+            # these should be members of a Record object
+            pid = pevent_data_pid(pe, rec)
+            comm = pevent_data_comm_from_pid(pe, pid)
+            type = pevent_data_type(pe, rec)
+            event = pevent_data_event_from_type(pe, type)
+            print "\t%f %s: pid=%d comm=%s type=%d" % \
+                  (record_ts_get(rec), event_name_get(event), pid, comm, type)
+
+            rec = tracecmd_read_data(handle, cpu)
+        else:
+            break
-- 
1.6.3.3
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
