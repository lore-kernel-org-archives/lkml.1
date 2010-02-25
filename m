Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0BYDnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:43:50 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37233 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0BYDmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MbFUH4nJQPTOy42lp1ZzjucbgKCbDJTTGM65sVy218G+a+KznZJVyGktYqHf02+nJJ
         G2L5s6bLFen9U7BQ1FALV1t2lGNSmxjEUg9DaIeYdtKCjiT54IscPDdmG0XdjgQV0rCg
         qWjeucJG7sitcQ55uTZ+vk6TDredUUSA/+8Vc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/10] perf/scripts: Add Python scripting engine
Date: Thu, 25 Feb 2010 04:42:37 +0100
Message-Id: <1267069361-10909-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
References: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

Add base support for Python scripting to perf trace.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1264580883-15324-6-git-send-email-tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile                                |   21 +
 tools/perf/builtin-trace.c                         |    1 +
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |   88 +++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   91 +++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   25 +
 .../util/scripting-engines/trace-event-python.c    |  576 ++++++++++++++++++++
 tools/perf/util/trace-event-scripting.c            |   61 ++
 tools/perf/util/trace-event.h                      |    1 +
 8 files changed, 864 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Context.c
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
 create mode 100644 tools/perf/util/scripting-engines/trace-event-python.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0a3c0c8..1427316 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -522,6 +522,19 @@ else
 	LIB_OBJS += scripts/perl/Perf-Trace-Util/Context.o
 endif
 
+ifndef NO_LIBPYTHON
+PYTHON_EMBED_LDOPTS = `python-config --ldflags 2>/dev/null`
+PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
+endif
+
+ifneq ($(shell sh -c "(echo '\#include <Python.h>'; echo 'int main(void) { Py_Initialize(); return 0; }') | $(CC) -x c - $(PYTHON_EMBED_CCOPTS) -o /dev/null $(PYTHON_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
+	BASIC_CFLAGS += -DNO_LIBPYTHON
+else
+	ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
+	LIB_OBJS += util/scripting-engines/trace-event-python.o
+	LIB_OBJS += scripts/python/Perf-Trace-Util/Context.o
+endif
+
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
@@ -899,6 +912,12 @@ util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-pe
 scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o scripts/perl/Perf-Trace-Util/Context.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
 
+util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o util/scripting-engines/trace-event-python.o -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+
+scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o scripts/python/Perf-Trace-Util/Context.o -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+
 perf-%$X: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
 
@@ -1012,6 +1031,8 @@ install: all
 	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
 	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
 
 ifdef BUILT_INS
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d5d20c3..5db687f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -44,6 +44,7 @@ static void setup_scripting(void)
 	perf_set_argv_exec_path(perf_exec_path());
 
 	setup_perl_scripting();
+	setup_python_scripting();
 
 	scripting_ops = &default_scripting_ops;
 }
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Context.c b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
new file mode 100644
index 0000000..957085d
--- /dev/null
+++ b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
@@ -0,0 +1,88 @@
+/*
+ * Context.c.  Python interfaces for perf trace.
+ *
+ * Copyright (C) 2010 Tom Zanussi <tzanussi@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <Python.h>
+#include "../../../perf.h"
+#include "../../../util/trace-event.h"
+
+PyMODINIT_FUNC initperf_trace_context(void);
+
+static PyObject *perf_trace_context_common_pc(PyObject *self, PyObject *args)
+{
+	static struct scripting_context *scripting_context;
+	PyObject *context;
+	int retval;
+
+	if (!PyArg_ParseTuple(args, "O", &context))
+		return NULL;
+
+	scripting_context = PyCObject_AsVoidPtr(context);
+	retval = common_pc(scripting_context);
+
+	return Py_BuildValue("i", retval);
+}
+
+static PyObject *perf_trace_context_common_flags(PyObject *self,
+						 PyObject *args)
+{
+	static struct scripting_context *scripting_context;
+	PyObject *context;
+	int retval;
+
+	if (!PyArg_ParseTuple(args, "O", &context))
+		return NULL;
+
+	scripting_context = PyCObject_AsVoidPtr(context);
+	retval = common_flags(scripting_context);
+
+	return Py_BuildValue("i", retval);
+}
+
+static PyObject *perf_trace_context_common_lock_depth(PyObject *self,
+						      PyObject *args)
+{
+	static struct scripting_context *scripting_context;
+	PyObject *context;
+	int retval;
+
+	if (!PyArg_ParseTuple(args, "O", &context))
+		return NULL;
+
+	scripting_context = PyCObject_AsVoidPtr(context);
+	retval = common_lock_depth(scripting_context);
+
+	return Py_BuildValue("i", retval);
+}
+
+static PyMethodDef ContextMethods[] = {
+	{ "common_pc", perf_trace_context_common_pc, METH_VARARGS,
+	  "Get the common preempt count event field value."},
+	{ "common_flags", perf_trace_context_common_flags, METH_VARARGS,
+	  "Get the common flags event field value."},
+	{ "common_lock_depth", perf_trace_context_common_lock_depth,
+	  METH_VARARGS,	"Get the common lock depth event field value."},
+	{ NULL, NULL, 0, NULL}
+};
+
+PyMODINIT_FUNC initperf_trace_context(void)
+{
+	(void) Py_InitModule("perf_trace_context", ContextMethods);
+}
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
new file mode 100644
index 0000000..1dc464e
--- /dev/null
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
@@ -0,0 +1,91 @@
+# Core.py - Python extension for perf trace, core functions
+#
+# Copyright (C) 2010 by Tom Zanussi <tzanussi@gmail.com>
+#
+# This software may be distributed under the terms of the GNU General
+# Public License ("GPL") version 2 as published by the Free Software
+# Foundation.
+
+from collections import defaultdict
+
+def autodict():
+    return defaultdict(autodict)
+
+flag_fields = autodict()
+symbolic_fields = autodict()
+
+def define_flag_field(event_name, field_name, delim):
+    flag_fields[event_name][field_name]['delim'] = delim
+
+def define_flag_value(event_name, field_name, value, field_str):
+    flag_fields[event_name][field_name]['values'][value] = field_str
+
+def define_symbolic_field(event_name, field_name):
+    # nothing to do, really
+    pass
+
+def define_symbolic_value(event_name, field_name, value, field_str):
+    symbolic_fields[event_name][field_name]['values'][value] = field_str
+
+def flag_str(event_name, field_name, value):
+    string = ""
+
+    if flag_fields[event_name][field_name]:
+	print_delim = 0
+        keys = flag_fields[event_name][field_name]['values'].keys()
+        keys.sort()
+        for idx in keys:
+            if not value and not idx:
+                string += flag_fields[event_name][field_name]['values'][idx]
+                break
+            if idx and (value & idx) == idx:
+                if print_delim and flag_fields[event_name][field_name]['delim']:
+                    string += " " + flag_fields[event_name][field_name]['delim'] + " "
+                string += flag_fields[event_name][field_name]['values'][idx]
+                print_delim = 1
+                value &= ~idx
+
+    return string
+
+def symbol_str(event_name, field_name, value):
+    string = ""
+
+    if symbolic_fields[event_name][field_name]:
+        keys = symbolic_fields[event_name][field_name]['values'].keys()
+        keys.sort()
+        for idx in keys:
+            if not value and not idx:
+		string = symbolic_fields[event_name][field_name]['values'][idx]
+                break
+	    if (value == idx):
+		string = symbolic_fields[event_name][field_name]['values'][idx]
+                break
+
+    return string
+
+trace_flags = { 0x00: "NONE", \
+                    0x01: "IRQS_OFF", \
+                    0x02: "IRQS_NOSUPPORT", \
+                    0x04: "NEED_RESCHED", \
+                    0x08: "HARDIRQ", \
+                    0x10: "SOFTIRQ" }
+
+def trace_flag_str(value):
+    string = ""
+    print_delim = 0
+
+    keys = trace_flags.keys()
+
+    for idx in keys:
+	if not value and not idx:
+	    string += "NONE"
+	    break
+
+	if idx and (value & idx) == idx:
+	    if print_delim:
+		string += " | ";
+	    string += trace_flags[idx]
+	    print_delim = 1
+	    value &= ~idx
+
+    return string
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
new file mode 100644
index 0000000..83e9143
--- /dev/null
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
@@ -0,0 +1,25 @@
+# Util.py - Python extension for perf trace, miscellaneous utility code
+#
+# Copyright (C) 2010 by Tom Zanussi <tzanussi@gmail.com>
+#
+# This software may be distributed under the terms of the GNU General
+# Public License ("GPL") version 2 as published by the Free Software
+# Foundation.
+
+NSECS_PER_SEC    = 1000000000
+
+def avg(total, n):
+    return total / n
+
+def nsecs(secs, nsecs):
+    return secs * NSECS_PER_SEC + nsecs
+
+def nsecs_secs(nsecs):
+    return nsecs / NSECS_PER_SEC
+
+def nsecs_nsecs(nsecs):
+    return nsecs % NSECS_PER_SEC
+
+def nsecs_str(nsecs):
+    str = "%5u.%09u" % (nsecs_secs(nsecs), nsecs_nsecs(nsecs)),
+    return str
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
new file mode 100644
index 0000000..d402f64
--- /dev/null
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -0,0 +1,576 @@
+/*
+ * trace-event-python.  Feed trace events to an embedded Python interpreter.
+ *
+ * Copyright (C) 2010 Tom Zanussi <tzanussi@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <Python.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+
+#include "../../perf.h"
+#include "../util.h"
+#include "../trace-event.h"
+
+PyMODINIT_FUNC initperf_trace_context(void);
+
+#define FTRACE_MAX_EVENT				\
+	((1 << (sizeof(unsigned short) * 8)) - 1)
+
+struct event *events[FTRACE_MAX_EVENT];
+
+#define MAX_FIELDS	64
+#define N_COMMON_FIELDS	7
+
+extern struct scripting_context *scripting_context;
+
+static char *cur_field_name;
+static int zero_flag_atom;
+
+static PyObject *main_module, *main_dict;
+
+static void handler_call_die(const char *handler_name)
+{
+	PyErr_Print();
+	Py_FatalError("problem in Python trace event handler");
+}
+
+static void define_value(enum print_arg_type field_type,
+			 const char *ev_name,
+			 const char *field_name,
+			 const char *field_value,
+			 const char *field_str)
+{
+	const char *handler_name = "define_flag_value";
+	PyObject *handler, *t, *retval;
+	unsigned long long value;
+	unsigned n = 0;
+
+	if (field_type == PRINT_SYMBOL)
+		handler_name = "define_symbolic_value";
+
+	t = PyTuple_New(MAX_FIELDS);
+	if (!t)
+		Py_FatalError("couldn't create Python tuple");
+
+	value = eval_flag(field_value);
+
+	PyTuple_SetItem(t, n++, PyString_FromString(ev_name));
+	PyTuple_SetItem(t, n++, PyString_FromString(field_name));
+	PyTuple_SetItem(t, n++, PyInt_FromLong(value));
+	PyTuple_SetItem(t, n++, PyString_FromString(field_str));
+
+	if (_PyTuple_Resize(&t, n) == -1)
+		Py_FatalError("error resizing Python tuple");
+
+	handler = PyDict_GetItemString(main_dict, handler_name);
+	if (handler && PyCallable_Check(handler)) {
+		retval = PyObject_CallObject(handler, t);
+		if (retval == NULL)
+			handler_call_die(handler_name);
+	}
+
+	Py_DECREF(t);
+}
+
+static void define_values(enum print_arg_type field_type,
+			  struct print_flag_sym *field,
+			  const char *ev_name,
+			  const char *field_name)
+{
+	define_value(field_type, ev_name, field_name, field->value,
+		     field->str);
+
+	if (field->next)
+		define_values(field_type, field->next, ev_name, field_name);
+}
+
+static void define_field(enum print_arg_type field_type,
+			 const char *ev_name,
+			 const char *field_name,
+			 const char *delim)
+{
+	const char *handler_name = "define_flag_field";
+	PyObject *handler, *t, *retval;
+	unsigned n = 0;
+
+	if (field_type == PRINT_SYMBOL)
+		handler_name = "define_symbolic_field";
+
+	t = PyTuple_New(MAX_FIELDS);
+	if (!t)
+		Py_FatalError("couldn't create Python tuple");
+
+	PyTuple_SetItem(t, n++, PyString_FromString(ev_name));
+	PyTuple_SetItem(t, n++, PyString_FromString(field_name));
+	if (field_type == PRINT_FLAGS)
+		PyTuple_SetItem(t, n++, PyString_FromString(delim));
+
+	if (_PyTuple_Resize(&t, n) == -1)
+		Py_FatalError("error resizing Python tuple");
+
+	handler = PyDict_GetItemString(main_dict, handler_name);
+	if (handler && PyCallable_Check(handler)) {
+		retval = PyObject_CallObject(handler, t);
+		if (retval == NULL)
+			handler_call_die(handler_name);
+	}
+
+	Py_DECREF(t);
+}
+
+static void define_event_symbols(struct event *event,
+				 const char *ev_name,
+				 struct print_arg *args)
+{
+	switch (args->type) {
+	case PRINT_NULL:
+		break;
+	case PRINT_ATOM:
+		define_value(PRINT_FLAGS, ev_name, cur_field_name, "0",
+			     args->atom.atom);
+		zero_flag_atom = 0;
+		break;
+	case PRINT_FIELD:
+		if (cur_field_name)
+			free(cur_field_name);
+		cur_field_name = strdup(args->field.name);
+		break;
+	case PRINT_FLAGS:
+		define_event_symbols(event, ev_name, args->flags.field);
+		define_field(PRINT_FLAGS, ev_name, cur_field_name,
+			     args->flags.delim);
+		define_values(PRINT_FLAGS, args->flags.flags, ev_name,
+			      cur_field_name);
+		break;
+	case PRINT_SYMBOL:
+		define_event_symbols(event, ev_name, args->symbol.field);
+		define_field(PRINT_SYMBOL, ev_name, cur_field_name, NULL);
+		define_values(PRINT_SYMBOL, args->symbol.symbols, ev_name,
+			      cur_field_name);
+		break;
+	case PRINT_STRING:
+		break;
+	case PRINT_TYPE:
+		define_event_symbols(event, ev_name, args->typecast.item);
+		break;
+	case PRINT_OP:
+		if (strcmp(args->op.op, ":") == 0)
+			zero_flag_atom = 1;
+		define_event_symbols(event, ev_name, args->op.left);
+		define_event_symbols(event, ev_name, args->op.right);
+		break;
+	default:
+		/* we should warn... */
+		return;
+	}
+
+	if (args->next)
+		define_event_symbols(event, ev_name, args->next);
+}
+
+static inline struct event *find_cache_event(int type)
+{
+	static char ev_name[256];
+	struct event *event;
+
+	if (events[type])
+		return events[type];
+
+	events[type] = event = trace_find_event(type);
+	if (!event)
+		return NULL;
+
+	sprintf(ev_name, "%s__%s", event->system, event->name);
+
+	define_event_symbols(event, ev_name, event->print_fmt.args);
+
+	return event;
+}
+
+static void python_process_event(int cpu, void *data,
+				 int size __unused,
+				 unsigned long long nsecs, char *comm)
+{
+	PyObject *handler, *retval, *context, *t;
+	static char handler_name[256];
+	struct format_field *field;
+	unsigned long long val;
+	unsigned long s, ns;
+	struct event *event;
+	unsigned n = 0;
+	int type;
+	int pid;
+
+	t = PyTuple_New(MAX_FIELDS);
+	if (!t)
+		Py_FatalError("couldn't create Python tuple");
+
+	type = trace_parse_common_type(data);
+
+	event = find_cache_event(type);
+	if (!event)
+		die("ug! no event found for type %d", type);
+
+	pid = trace_parse_common_pid(data);
+
+	sprintf(handler_name, "%s__%s", event->system, event->name);
+
+	s = nsecs / NSECS_PER_SEC;
+	ns = nsecs - s * NSECS_PER_SEC;
+
+	scripting_context->event_data = data;
+
+	context = PyCObject_FromVoidPtr(scripting_context, NULL);
+
+	PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
+	PyTuple_SetItem(t, n++,
+			PyCObject_FromVoidPtr(scripting_context, NULL));
+	PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
+	PyTuple_SetItem(t, n++, PyInt_FromLong(s));
+	PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
+	PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
+	PyTuple_SetItem(t, n++, PyString_FromString(comm));
+
+	for (field = event->format.fields; field; field = field->next) {
+		if (field->flags & FIELD_IS_STRING) {
+			int offset;
+			if (field->flags & FIELD_IS_DYNAMIC) {
+				offset = *(int *)(data + field->offset);
+				offset &= 0xffff;
+			} else
+				offset = field->offset;
+			PyTuple_SetItem(t, n++,
+				PyString_FromString((char *)data + offset));
+		} else { /* FIELD_IS_NUMERIC */
+			val = read_size(data + field->offset, field->size);
+			if (field->flags & FIELD_IS_SIGNED) {
+				PyTuple_SetItem(t, n++, PyInt_FromLong(val));
+			} else {
+				PyTuple_SetItem(t, n++, PyInt_FromLong(val));
+			}
+		}
+	}
+
+	if (_PyTuple_Resize(&t, n) == -1)
+		Py_FatalError("error resizing Python tuple");
+
+	handler = PyDict_GetItemString(main_dict, handler_name);
+	if (handler && PyCallable_Check(handler)) {
+		retval = PyObject_CallObject(handler, t);
+		if (retval == NULL)
+			handler_call_die(handler_name);
+	} else {
+		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
+		if (handler && PyCallable_Check(handler)) {
+			if (_PyTuple_Resize(&t, N_COMMON_FIELDS) == -1)
+				Py_FatalError("error resizing Python tuple");
+
+			retval = PyObject_CallObject(handler, t);
+			if (retval == NULL)
+				handler_call_die("trace_unhandled");
+		}
+	}
+
+	Py_DECREF(t);
+}
+
+static int run_start_sub(void)
+{
+	PyObject *handler, *retval;
+	int err = 0;
+
+	main_module = PyImport_AddModule("__main__");
+	if (main_module == NULL)
+		return -1;
+	Py_INCREF(main_module);
+
+	main_dict = PyModule_GetDict(main_module);
+	if (main_dict == NULL) {
+		err = -1;
+		goto error;
+	}
+	Py_INCREF(main_dict);
+
+	handler = PyDict_GetItemString(main_dict, "trace_begin");
+	if (handler == NULL || !PyCallable_Check(handler))
+		goto out;
+
+	retval = PyObject_CallObject(handler, NULL);
+	if (retval == NULL)
+		handler_call_die("trace_begin");
+
+	Py_DECREF(retval);
+	return err;
+error:
+	Py_XDECREF(main_dict);
+	Py_XDECREF(main_module);
+out:
+	return err;
+}
+
+/*
+ * Start trace script
+ */
+static int python_start_script(const char *script, int argc, const char **argv)
+{
+	const char **command_line;
+	char buf[PATH_MAX];
+	int i, err = 0;
+	FILE *fp;
+
+	command_line = malloc((argc + 1) * sizeof(const char *));
+	command_line[0] = script;
+	for (i = 1; i < argc + 1; i++)
+		command_line[i] = argv[i - 1];
+
+	Py_Initialize();
+
+	initperf_trace_context();
+
+	PySys_SetArgv(argc + 1, (char **)command_line);
+
+	fp = fopen(script, "r");
+	if (!fp) {
+		sprintf(buf, "Can't open python script \"%s\"", script);
+		perror(buf);
+		err = -1;
+		goto error;
+	}
+
+	err = PyRun_SimpleFile(fp, script);
+	if (err) {
+		fprintf(stderr, "Error running python script %s\n", script);
+		goto error;
+	}
+
+	err = run_start_sub();
+	if (err) {
+		fprintf(stderr, "Error starting python script %s\n", script);
+		goto error;
+	}
+
+	free(command_line);
+	fprintf(stderr, "perf trace started with Python script %s\n\n",
+		script);
+
+	return err;
+error:
+	Py_Finalize();
+	free(command_line);
+
+	return err;
+}
+
+/*
+ * Stop trace script
+ */
+static int python_stop_script(void)
+{
+	PyObject *handler, *retval;
+	int err = 0;
+
+	handler = PyDict_GetItemString(main_dict, "trace_end");
+	if (handler == NULL || !PyCallable_Check(handler))
+		goto out;
+
+	retval = PyObject_CallObject(handler, NULL);
+	if (retval == NULL)
+		handler_call_die("trace_end");
+	else
+		Py_DECREF(retval);
+out:
+	Py_XDECREF(main_dict);
+	Py_XDECREF(main_module);
+	Py_Finalize();
+
+	fprintf(stderr, "\nperf trace Python script stopped\n");
+
+	return err;
+}
+
+static int python_generate_script(const char *outfile)
+{
+	struct event *event = NULL;
+	struct format_field *f;
+	char fname[PATH_MAX];
+	int not_first, count;
+	FILE *ofp;
+
+	sprintf(fname, "%s.py", outfile);
+	ofp = fopen(fname, "w");
+	if (ofp == NULL) {
+		fprintf(stderr, "couldn't open %s\n", fname);
+		return -1;
+	}
+	fprintf(ofp, "# perf trace event handlers, "
+		"generated by perf trace -g python\n");
+
+	fprintf(ofp, "# Licensed under the terms of the GNU GPL"
+		" License version 2\n\n");
+
+	fprintf(ofp, "# The common_* event handler fields are the most useful "
+		"fields common to\n");
+
+	fprintf(ofp, "# all events.  They don't necessarily correspond to "
+		"the 'common_*' fields\n");
+
+	fprintf(ofp, "# in the format files.  Those fields not available as "
+		"handler params can\n");
+
+	fprintf(ofp, "# be retrieved using Python functions of the form "
+		"common_*(context).\n");
+
+	fprintf(ofp, "# See the perf-trace-python Documentation for the list "
+		"of available functions.\n\n");
+
+	fprintf(ofp, "import os\n");
+	fprintf(ofp, "import sys\n\n");
+
+	fprintf(ofp, "sys.path.append(os.environ['PERF_EXEC_PATH'] + \\\n");
+	fprintf(ofp, "\t'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')\n");
+	fprintf(ofp, "\nfrom perf_trace_context import *\n");
+	fprintf(ofp, "from Core import *\n\n\n");
+
+	fprintf(ofp, "def trace_begin():\n");
+	fprintf(ofp, "\tprint \"in trace_begin\"\n\n");
+
+	fprintf(ofp, "def trace_end():\n");
+	fprintf(ofp, "\tprint \"in trace_end\"\n\n");
+
+	while ((event = trace_find_next_event(event))) {
+		fprintf(ofp, "def %s__%s(", event->system, event->name);
+		fprintf(ofp, "event_name, ");
+		fprintf(ofp, "context, ");
+		fprintf(ofp, "common_cpu,\n");
+		fprintf(ofp, "\tcommon_secs, ");
+		fprintf(ofp, "common_nsecs, ");
+		fprintf(ofp, "common_pid, ");
+		fprintf(ofp, "common_comm,\n\t");
+
+		not_first = 0;
+		count = 0;
+
+		for (f = event->format.fields; f; f = f->next) {
+			if (not_first++)
+				fprintf(ofp, ", ");
+			if (++count % 5 == 0)
+				fprintf(ofp, "\n\t");
+
+			fprintf(ofp, "%s", f->name);
+		}
+		fprintf(ofp, "):\n");
+
+		fprintf(ofp, "\t\tprint_header(event_name, common_cpu, "
+			"common_secs, common_nsecs,\n\t\t\t"
+			"common_pid, common_comm)\n\n");
+
+		fprintf(ofp, "\t\tprint \"");
+
+		not_first = 0;
+		count = 0;
+
+		for (f = event->format.fields; f; f = f->next) {
+			if (not_first++)
+				fprintf(ofp, ", ");
+			if (count && count % 3 == 0) {
+				fprintf(ofp, "\" \\\n\t\t\"");
+			}
+			count++;
+
+			fprintf(ofp, "%s=", f->name);
+			if (f->flags & FIELD_IS_STRING ||
+			    f->flags & FIELD_IS_FLAG ||
+			    f->flags & FIELD_IS_SYMBOLIC)
+				fprintf(ofp, "%%s");
+			else if (f->flags & FIELD_IS_SIGNED)
+				fprintf(ofp, "%%d");
+			else
+				fprintf(ofp, "%%u");
+		}
+
+		fprintf(ofp, "\\n\" %% \\\n\t\t(");
+
+		not_first = 0;
+		count = 0;
+
+		for (f = event->format.fields; f; f = f->next) {
+			if (not_first++)
+				fprintf(ofp, ", ");
+
+			if (++count % 5 == 0)
+				fprintf(ofp, "\n\t\t");
+
+			if (f->flags & FIELD_IS_FLAG) {
+				if ((count - 1) % 5 != 0) {
+					fprintf(ofp, "\n\t\t");
+					count = 4;
+				}
+				fprintf(ofp, "flag_str(\"");
+				fprintf(ofp, "%s__%s\", ", event->system,
+					event->name);
+				fprintf(ofp, "\"%s\", %s)", f->name,
+					f->name);
+			} else if (f->flags & FIELD_IS_SYMBOLIC) {
+				if ((count - 1) % 5 != 0) {
+					fprintf(ofp, "\n\t\t");
+					count = 4;
+				}
+				fprintf(ofp, "symbol_str(\"");
+				fprintf(ofp, "%s__%s\", ", event->system,
+					event->name);
+				fprintf(ofp, "\"%s\", %s)", f->name,
+					f->name);
+			} else
+				fprintf(ofp, "%s", f->name);
+		}
+
+		fprintf(ofp, "),\n\n");
+	}
+
+	fprintf(ofp, "def trace_unhandled(event_name, context, "
+		"common_cpu, common_secs, common_nsecs,\n\t\t"
+		"common_pid, common_comm):\n");
+
+	fprintf(ofp, "\t\tprint_header(event_name, common_cpu, "
+		"common_secs, common_nsecs,\n\t\tcommon_pid, "
+		"common_comm)\n\n");
+
+	fprintf(ofp, "def print_header("
+		"event_name, cpu, secs, nsecs, pid, comm):\n"
+		"\tprint \"%%-20s %%5u %%05u.%%09u %%8u %%-20s \" %% \\\n\t"
+		"(event_name, cpu, secs, nsecs, pid, comm),\n");
+
+	fclose(ofp);
+
+	fprintf(stderr, "generated Python script: %s\n", fname);
+
+	return 0;
+}
+
+struct scripting_ops python_scripting_ops = {
+	.name = "Python",
+	.start_script = python_start_script,
+	.stop_script = python_stop_script,
+	.process_event = python_process_event,
+	.generate_script = python_generate_script,
+};
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 9e37196..7ea983a 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -44,6 +44,67 @@ static void process_event_unsupported(int cpu __unused,
 {
 }
 
+static void print_python_unsupported_msg(void)
+{
+	fprintf(stderr, "Python scripting not supported."
+		"  Install libpython and rebuild perf to enable it.\n"
+		"For example:\n  # apt-get install python-dev (ubuntu)"
+		"\n  # yum install python-devel (Fedora)"
+		"\n  etc.\n");
+}
+
+static int python_start_script_unsupported(const char *script __unused,
+					   int argc __unused,
+					   const char **argv __unused)
+{
+	print_python_unsupported_msg();
+
+	return -1;
+}
+
+static int python_generate_script_unsupported(const char *outfile __unused)
+{
+	print_python_unsupported_msg();
+
+	return -1;
+}
+
+struct scripting_ops python_scripting_unsupported_ops = {
+	.name = "Python",
+	.start_script = python_start_script_unsupported,
+	.stop_script = stop_script_unsupported,
+	.process_event = process_event_unsupported,
+	.generate_script = python_generate_script_unsupported,
+};
+
+static void register_python_scripting(struct scripting_ops *scripting_ops)
+{
+	int err;
+	err = script_spec_register("Python", scripting_ops);
+	if (err)
+		die("error registering Python script extension");
+
+	err = script_spec_register("py", scripting_ops);
+	if (err)
+		die("error registering py script extension");
+
+	scripting_context = malloc(sizeof(struct scripting_context));
+}
+
+#ifdef NO_LIBPYTHON
+void setup_python_scripting(void)
+{
+	register_python_scripting(&python_scripting_unsupported_ops);
+}
+#else
+struct scripting_ops python_scripting_ops;
+
+void setup_python_scripting(void)
+{
+	register_python_scripting(&python_scripting_ops);
+}
+#endif
+
 static void print_perl_unsupported_msg(void)
 {
 	fprintf(stderr, "Perl scripting not supported."
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index aaf2da2..c3269b9 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -280,6 +280,7 @@ struct scripting_ops {
 int script_spec_register(const char *spec, struct scripting_ops *ops);
 
 void setup_perl_scripting(void);
+void setup_python_scripting(void);
 
 struct scripting_context {
 	void *event_data;
-- 
1.6.2.3

