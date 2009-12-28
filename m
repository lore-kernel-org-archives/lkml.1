Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZL1SAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZL1SAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 13:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZL1SAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 13:00:05 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58693 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZL1SAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 13:00:01 -0500
Message-ID: <4B38F21B.2020504@us.ibm.com>
Date: Mon, 28 Dec 2009 09:59:55 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Cleanup 64-bit handling for python wrapper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 45afc359aa81cbce7a5ea559dc9625489d343f5f Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Mon, 28 Dec 2009 09:36:30 -0800
Subject: [PATCH] trace-cmd: Cleanup 64-bit handling for python wrapper

Wrap pevent_read_number_field() with a more intelligent wrapper that
returns None on error and a python long on success. Eliminate the hi/lo
64 bit marshalling junk.

Use a typemap to get automatic struct accessors (ie record_ts_get()) to
return a python long for unsigned long long fields rather than
truncating to 32-bits.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 ctracecmd.i |   20 +++++++++++---------
 tracecmd.py |   15 +++------------
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/ctracecmd.i b/ctracecmd.i
index 20a681c..4b17327 100644
--- a/ctracecmd.i
+++ b/ctracecmd.i
@@ -6,19 +6,21 @@
 #include "trace-cmd.h"
 %}
 
-/* typemaps must come before the implementation of wrapped functions */
-extern int pevent_read_number_field_32(struct format_field *f, void *data,
-                                       unsigned long *OUTPUT, unsigned long *OUTPUT);
+%typemap(out) unsigned long long {
+$result = PyLong_FromUnsignedLongLong((unsigned long long) $1);
+} 
 
 %inline %{
-int pevent_read_number_field_32(struct format_field *f, void *data, unsigned long *hi, unsigned long *lo)
+PyObject *pevent_read_number_field_py(struct format_field *f, void *data)
 {
-        unsigned long long val64;
+        unsigned long long val;
         int ret;
-        ret = pevent_read_number_field(f, data, &val64);
-        *hi = (unsigned long)(val64>>32);
-        *lo = (unsigned long)((val64<<32)>>32);
-        return ret;
+
+        ret = pevent_read_number_field(f, data, &val);
+        if (ret)
+                Py_RETURN_NONE;
+        else
+                return PyLong_FromUnsignedLongLong(val);
 }
 %}
 
diff --git a/tracecmd.py b/tracecmd.py
index 6520a48..f9a2708 100644
--- a/tracecmd.py
+++ b/tracecmd.py
@@ -31,13 +31,6 @@ and it is recommended applications not use it directly.
 TODO: consider a complete class hierarchy of ftrace events...
 """
 
-def _pevent_read_number_field(field, data):
-    ret,hi,lo = pevent_read_number_field_32(field, data)
-    if ret == 0:
-        return ret,long(long(hi).__lshift__(32)+lo)
-    return ret,None
-
-
 class Event(object):
     def __init__(self, trace, record):
         self.trace = trace
@@ -46,8 +39,8 @@ class Event(object):
         self.ec = pevent_data_event_from_type(trace.pe, type)
 
     def __str__(self):
-        return "%f %s: pid=%d comm=%s type=%d" % \
-               (self.ts, self.name, self.num_field("common_pid"), self.comm, self.type)
+        return "%d.%d %s: pid=%d comm=%s type=%d" % \
+               (self.ts/1000000000, self.ts%1000000000, self.name, self.num_field("common_pid"), self.comm, self.type)
 
 
     # TODO: consider caching the results of the properties
@@ -65,7 +58,6 @@ class Event(object):
 
     @property
     def ts(self):
-        # FIXME: this currently returns a float instead of a 64bit nsec value
         return record_ts_get(self.rec)
 
     @property
@@ -73,9 +65,8 @@ class Event(object):
         return pevent_data_type(self.trace.pe, self.rec)
 
     def num_field(self, name):
-        # FIXME: need to find an elegant way to handle 64bit fields
         f = pevent_find_any_field(self.ec, name)
-        ret,val = _pevent_read_number_field(f, record_data_get(self.rec))
+        val = pevent_read_number_field_py(f, record_data_get(self.rec))
         return val
 
 
-- 
1.6.3.3
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
