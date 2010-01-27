Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799Ab0A0I22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0A0I22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752Ab0A0I2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:28:24 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:47235 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0A0I2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LN3tPdwWjWBLe8KgYAH8sQYuFTLESwnJLyxVmrGGlt0zNDrHQz4oorqKx158Z0up3X
         xj6/n5Nb/rideCXoc9FGUk5jDMlMgsIodZ1dVTJuWi7qWOcHSAfXAh1OfbVnqQSvLRSv
         hwdCoCiedFBv9leVBbhsY8Jk364RrT/I99a8M=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 10/12] perf trace/scripting: make the syscall map available as a Python dict
Date: Wed, 27 Jan 2010 02:28:01 -0600
Message-Id: <1264580883-15324-11-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a Python extension that makes the perf syscall map into a
Python dict.

New instances of the syscall dict can be retrieved at any time by by
calling the Python function get_syscall_names().

Also adds a new utility function that makes uses of the syscall name
dict:

syscall_name(syscall_nr)

which returns a syscall name given a syscall_nr, or the number itself
if the syscall wasn't found in the map (or 'undefined' if the value
passed in was bogus).

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |   22 ++++++++++++++++++++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   12 ++++++++++
 .../perf/scripts/python/failed-syscalls-by-pid.py  |    3 +-
 tools/perf/scripts/python/syscall-counts-by-pid.py |    3 +-
 tools/perf/scripts/python/syscall-counts.py        |    3 +-
 5 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Context.c b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
index 957085d..ebdcc35 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
@@ -72,6 +72,26 @@ static PyObject *perf_trace_context_common_lock_depth(PyObject *self,
 	return Py_BuildValue("i", retval);
 }
 
+static PyObject *perf_trace_context_get_syscall_names(PyObject *self,
+						      PyObject *args)
+{
+	const struct syscall_metadata *meta;
+	PyObject *dict;
+	int i;
+
+	dict = PyDict_New();
+	if (!dict)
+		return NULL;
+
+	for (i = 0; i < nr_syscalls(); i++) {
+		meta = syscall_at_idx(i);
+		PyDict_SetItem(dict, PyInt_FromLong(meta->nr),
+			       PyString_FromString(meta->name));
+	}
+
+	return dict;
+}
+
 static PyMethodDef ContextMethods[] = {
 	{ "common_pc", perf_trace_context_common_pc, METH_VARARGS,
 	  "Get the common preempt count event field value."},
@@ -79,6 +99,8 @@ static PyMethodDef ContextMethods[] = {
 	  "Get the common flags event field value."},
 	{ "common_lock_depth", perf_trace_context_common_lock_depth,
 	  METH_VARARGS,	"Get the common lock depth event field value."},
+	{ "get_syscall_names", perf_trace_context_get_syscall_names,
+	  METH_NOARGS,	"Get the syscall_nr->syscall_name dict."},
 	{ NULL, NULL, 0, NULL}
 };
 
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
index 83e9143..08d7d8e 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
@@ -6,6 +6,8 @@
 # Public License ("GPL") version 2 as published by the Free Software
 # Foundation.
 
+from perf_trace_context import *
+
 NSECS_PER_SEC    = 1000000000
 
 def avg(total, n):
@@ -23,3 +25,13 @@ def nsecs_nsecs(nsecs):
 def nsecs_str(nsecs):
     str = "%5u.%09u" % (nsecs_secs(nsecs), nsecs_nsecs(nsecs)),
     return str
+
+syscall_name_map = get_syscall_names()
+
+def syscall_name(id):
+	if id == -1:
+		return "undefined"
+	try:
+		return syscall_name_map[id]
+	except KeyError:
+		return str(id)
diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/perf/scripts/python/failed-syscalls-by-pid.py
index 0ca0227..007e959 100644
--- a/tools/perf/scripts/python/failed-syscalls-by-pid.py
+++ b/tools/perf/scripts/python/failed-syscalls-by-pid.py
@@ -13,6 +13,7 @@ sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 
 from perf_trace_context import *
 from Core import *
+from Util import *
 
 usage = "perf trace -s syscall-counts-by-pid.py [comm]\n";
 
@@ -62,7 +63,7 @@ def print_error_totals():
 		    print "\n%s [%d]\n" % (comm, pid),
 		    id_keys = syscalls[comm][pid].keys()
 		    for id in id_keys:
-			    print "  syscall: %-16d\n" % (id),
+			    print "  syscall: %-16s\n" % (syscall_name(id)),
 			    ret_keys = syscalls[comm][pid][id].keys()
 			    for ret, val in sorted(syscalls[comm][pid][id].iteritems(), key = lambda(k, v): (v, k),  reverse = True):
 				    print "    err = %-20d  %10d\n" % (ret, val),
diff --git a/tools/perf/scripts/python/syscall-counts-by-pid.py b/tools/perf/scripts/python/syscall-counts-by-pid.py
index af722d6..fffe0d6 100644
--- a/tools/perf/scripts/python/syscall-counts-by-pid.py
+++ b/tools/perf/scripts/python/syscall-counts-by-pid.py
@@ -13,6 +13,7 @@ sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 
 from perf_trace_context import *
 from Core import *
+from Util import *
 
 usage = "perf trace -s syscall-counts-by-pid.py [comm]\n";
 
@@ -61,4 +62,4 @@ def print_syscall_totals():
 		    id_keys = syscalls[comm][pid].keys()
 		    for id, val in sorted(syscalls[comm][pid].iteritems(), \
 				  key = lambda(k, v): (v, k),  reverse = True):
-			    print "  %-38d  %10d\n" % (id, val),
+			    print "  %-38s  %10d\n" % (syscall_name(id), val),
diff --git a/tools/perf/scripts/python/syscall-counts.py b/tools/perf/scripts/python/syscall-counts.py
index f977e85..a641c6f 100644
--- a/tools/perf/scripts/python/syscall-counts.py
+++ b/tools/perf/scripts/python/syscall-counts.py
@@ -13,6 +13,7 @@ sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 
 from perf_trace_context import *
 from Core import *
+from Util import *
 
 usage = "perf trace -s syscall-counts.py [comm]\n";
 
@@ -55,4 +56,4 @@ def print_syscall_totals():
 
     for id, val in sorted(syscalls.iteritems(), key = lambda(k, v): (v, k), \
 				  reverse = True):
-	    print "%-40d  %10d\n" % (id, val),
+	    print "%-40s  %10d\n" % (syscall_name(id), val),
-- 
1.6.4.GIT

