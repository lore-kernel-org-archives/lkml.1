Return-Path: <linux-kernel-owner+w=401wt.eu-S1763462AbZLQAfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763462AbZLQAfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762867AbZLQAfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:35:50 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38086 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762864AbZLQAft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:35:49 -0500
Message-ID: <4B297CE3.6040600@us.ibm.com>
Date: Wed, 16 Dec 2009 16:35:47 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] RFC: Use opaque record type in pevent accessor functions
References: <4B297C79.2090004@us.ibm.com>
In-Reply-To: <4B297C79.2090004@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1f76a9521a63e456a950f1a57e69d9dfc36ab001 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 16 Dec 2009 15:25:30 -0800
Subject: [PATCH 2/2] RFC: Start of a tracecmd swig wrapper for python

Introduce a python tracecmd module for use in rapidly prototyping
tracing applications. The interface description is provided in
tracecmd.i, it identifies which functions are available from within
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

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 swig.sh          |   18 ++++++++++++++++++
 tracecmd-test.py |   35 +++++++++++++++++++++++++++++++++++
 tracecmd.i       |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100755 swig.sh
 create mode 100755 tracecmd-test.py
 create mode 100644 tracecmd.i

diff --git a/swig.sh b/swig.sh
new file mode 100755
index 0000000..c53e7a2
--- /dev/null
+++ b/swig.sh
@@ -0,0 +1,18 @@
+#!/bin/sh
+
+# Temporary hack of a build script, eventually we'll incoroporate this
+# into the Makefile. You may have to update the includes to point to your
+# python installation.
+
+rm tracecmd_wrap.c tracecmd_wrap.o _tracecmd.so &> /dev/null
+
+swig -python tracecmd.i
+
+gcc -fpic -c  -I/usr/include/python2.6/ -I/usr/lib/python2.6/config \
+    trace-ftrace.c trace-seq.c trace-util.c \
+    trace-input.c parse-events.c tracecmd_wrap.c
+
+gcc -shared trace-ftrace.o trace-seq.o trace-util.o \
+    trace-input.o parse-events.o \
+    tracecmd_wrap.o -o _tracecmd.so
+
diff --git a/tracecmd-test.py b/tracecmd-test.py
new file mode 100755
index 0000000..1ad2ea4
--- /dev/null
+++ b/tracecmd-test.py
@@ -0,0 +1,35 @@
+#!/usr/bin/env python
+
+from tracecmd import *
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
+        rec = tracecmd_read_data(handle, cpu)
+        if rec:
+            # these should be members of a Record object
+            pid = pevent_data_pid(pe, rec)
+            comm = pevent_data_comm_from_pid(pe, pid)
+            type = pevent_data_type(pe, rec)
+            event = pevent_data_event_from_type(pe, type)
+            print "\t%f %s: pid=%d comm=%s type=%d" % \
+                  (record_ts(rec), event_name(event), pid, comm, type)
+        else:
+            break
diff --git a/tracecmd.i b/tracecmd.i
new file mode 100644
index 0000000..f43a90b
--- /dev/null
+++ b/tracecmd.i
@@ -0,0 +1,39 @@
+// tracecmd.i
+%module tracecmd
+%{
+/* The following functions provide accessors to the C struct members
+ * we want to eliminate these if at all possible with changes to the
+ * tracecmd API.
+ */
+#include "parse-events.h"
+char *event_name(struct event *e) {
+        return e->name;
+}
+
+/* Python can't handle long long, convert to double in seconds */
+double record_ts(struct record *rec) {
+        return (double)(rec->ts) / 1000000000;
+}
+%}
+
+/* tracecmd functions */
+struct tracecmd_input *tracecmd_open(int fd);
+int tracecmd_read_headers(struct tracecmd_input *handle);
+int tracecmd_init_data(struct tracecmd_input *handle);
+int tracecmd_cpus(struct tracecmd_input *handle);
+struct pevent *tracecmd_get_pevent(struct tracecmd_input *handle);
+/* FIXME: this didn't print anything */
+void tracecmd_print_events(struct tracecmd_input *handle);
+/* FIXME: need a way to free the record */
+struct record *tracecmd_read_data(struct tracecmd_input *handle, int cpu);
+
+/* pevent, record, event functions */
+int pevent_data_pid(struct pevent *pevent, struct record *rec);
+int pevent_data_type(struct pevent *pevent, struct record *rec);
+struct event *pevent_data_event_from_type(struct pevent *pevent, int type);
+const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
+
+
+/* custom wrappers to account for opaque pointers */
+char *event_name(struct event *e);
+double record_ts(struct record *rec);
-- 
1.6.3.3

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
