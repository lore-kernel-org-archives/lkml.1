Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbZLQXvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbZLQXvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZLQXvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:51:07 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34775 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZLQXvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:51:00 -0500
Message-ID: <4B2AC3E1.1010301@us.ibm.com>
Date: Thu, 17 Dec 2009 15:50:57 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracecmd: Add initial python tracecmd API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 31d6e865d4cdcd2ba7583bfefb9aa4df090d383d Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Thu, 17 Dec 2009 13:07:34 -0800
Subject: [PATCH] tracecmd: Add initial python tracecmd API

Add an object oriented python API in a new tracecmd.py module. This
module contains a self test that duplicates the behavior of the
tracecmd-test.py, so it has been removed.

This API is far from complete and only implements enough functionality
to list the events on each CPU.

SWIG doesn't handle long longs so we have to add a wrapper, a
typemapper, and a marshaller to get a 64bit integer out of the record
data. This is a first take, comments welcome. We'll need to do something
similar with the timestamp values.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 ctracecmd.i      |   15 ++++++
 tracecmd-test.py |   36 --------------
 tracecmd.py      |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 150 insertions(+), 36 deletions(-)
 delete mode 100755 tracecmd-test.py
 create mode 100644 tracecmd.py

diff --git a/ctracecmd.i b/ctracecmd.i
index 80fface..20a681c 100644
--- a/ctracecmd.i
+++ b/ctracecmd.i
@@ -1,13 +1,28 @@
 // tracecmd.i
 %module ctracecmd
+%include typemaps.i
 
 %{
 #include "trace-cmd.h"
 %}
 
+/* typemaps must come before the implementation of wrapped functions */
+extern int pevent_read_number_field_32(struct format_field *f, void *data,
+                                       unsigned long *OUTPUT, unsigned long *OUTPUT);
+
 %inline %{
+int pevent_read_number_field_32(struct format_field *f, void *data, unsigned long *hi, unsigned long *lo)
+{
+        unsigned long long val64;
+        int ret;
+        ret = pevent_read_number_field(f, data, &val64);
+        *hi = (unsigned long)(val64>>32);
+        *lo = (unsigned long)((val64<<32)>>32);
+        return ret;
+}
 %}
 
+
 /* SWIG can't grok these, define them to nothing */
 #define __trace
 #define __attribute__(x)
diff --git a/tracecmd-test.py b/tracecmd-test.py
deleted file mode 100755
index 094ce81..0000000
--- a/tracecmd-test.py
+++ /dev/null
@@ -1,36 +0,0 @@
-#!/usr/bin/env python
-
-from ctracecmd import *
-
-# Let's move the following into a new Trace object constructor
-filename = "trace.dat"
-trace_file = open(filename)
-handle = tracecmd_open(trace_file.fileno())
-tracecmd_read_headers(handle)
-tracecmd_init_data(handle)
-
-# These should be members, i.e. Trace.cpus
-pe = tracecmd_get_pevent(handle)
-cpus = tracecmd_cpus(handle)
-print "Trace %s contains data for %d cpus" % (filename, cpus) 
-
-# FIXME: this doesn't print anything...
-tracecmd_print_events(handle)
-
-print "Cycling through the events for each CPU"
-for cpu in range(0,cpus):
-    print "CPU", cpu
-    rec = tracecmd_read_data(handle, cpu)
-    while True:
-        if rec:
-            # these should be members of a Record object
-            pid = pevent_data_pid(pe, rec)
-            comm = pevent_data_comm_from_pid(pe, pid)
-            type = pevent_data_type(pe, rec)
-            event = pevent_data_event_from_type(pe, type)
-            print "\t%f %s: pid=%d comm=%s type=%d" % \
-                  (record_ts_get(rec), event_name_get(event), pid, comm, type)
-
-            rec = tracecmd_read_data(handle, cpu)
-        else:
-            break
diff --git a/tracecmd.py b/tracecmd.py
new file mode 100644
index 0000000..6520a48
--- /dev/null
+++ b/tracecmd.py
@@ -0,0 +1,135 @@
+#
+# Copyright (C) International Business Machines  Corp., 2009
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# 2009-Dec-17:	Initial version by Darren Hart <dvhltc@us.ibm.com>
+#
+
+from ctracecmd import *
+
+"""
+Python interface to the tracecmd library for parsing ftrace traces
+
+Python tracecmd applications should be written to this interface. It will be
+updated as the tracecmd C API changes and try to minimze the impact to python
+applications. The ctracecmd Python module is automatically generated using SWIG
+and it is recommended applications not use it directly.
+
+TODO: consider a complete class hierarchy of ftrace events...
+"""
+
+def _pevent_read_number_field(field, data):
+    ret,hi,lo = pevent_read_number_field_32(field, data)
+    if ret == 0:
+        return ret,long(long(hi).__lshift__(32)+lo)
+    return ret,None
+
+
+class Event(object):
+    def __init__(self, trace, record):
+        self.trace = trace
+        self.rec = record
+        type = pevent_data_type(trace.pe, record)
+        self.ec = pevent_data_event_from_type(trace.pe, type)
+
+    def __str__(self):
+        return "%f %s: pid=%d comm=%s type=%d" % \
+               (self.ts, self.name, self.num_field("common_pid"), self.comm, self.type)
+
+
+    # TODO: consider caching the results of the properties
+    @property
+    def comm(self):
+        return self.trace.comm_from_pid(self.pid)
+
+    @property
+    def name(self):
+        return event_name_get(self.ec)
+
+    @property
+    def pid(self):
+        return pevent_data_pid(self.trace.pe, self.rec)
+
+    @property
+    def ts(self):
+        # FIXME: this currently returns a float instead of a 64bit nsec value
+        return record_ts_get(self.rec)
+
+    @property
+    def type(self):
+        return pevent_data_type(self.trace.pe, self.rec)
+
+    def num_field(self, name):
+        # FIXME: need to find an elegant way to handle 64bit fields
+        f = pevent_find_any_field(self.ec, name)
+        ret,val = _pevent_read_number_field(f, record_data_get(self.rec))
+        return val
+
+
+class Trace(object):
+    """
+    Trace object represents the trace file it is created with.
+
+    The Trace object aggregates the tracecmd structures and functions that are
+    used to manage the trace and extract events from it.
+    """
+    def __init__(self, filename):
+        self.handle = None
+        self.pe = None
+
+        try:
+            file = open(filename)
+            self.handle = tracecmd_open(file.fileno())
+            print "self.handle: ", self.handle
+            #FIXME: check if these throw exceptions automatically or if we have
+            #       to check return codes manually
+            tracecmd_read_headers(self.handle)
+            tracecmd_init_data(self.handle)
+            self.pe = tracecmd_get_pevent(self.handle)
+        except:
+            return None
+
+    @property
+    def cpus(self):
+        return tracecmd_cpus(self.handle)
+
+    def read_event(self, cpu):
+        rec = tracecmd_read_data(self.handle, cpu)
+        if rec:
+            return Event(self, rec)
+        return None
+
+    def peek_event(self, cpu):
+        pass
+
+    def comm_from_pid(self, pid):
+        return pevent_data_comm_from_pid(self.pe, pid)
+
+
+# Basic builtin test, execute module directly
+if __name__ == "__main__":
+    t = Trace("trace.dat")
+    print "Trace contains data for %d cpus" % (t.cpus)
+
+    for cpu in range(0, t.cpus):
+        print "CPU %d" % (cpu)
+        ev = t.read_event(cpu)
+        while ev:
+            print "\t%s" % (ev)
+            ev = t.read_event(cpu)
+
+
+
-- 
1.6.3.3
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
