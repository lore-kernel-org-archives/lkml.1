Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0BYDnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:43:01 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37233 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab0BYDmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:42:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cRK/6LT7WNwe3bSFop3uaEg/097CnHTZPUTelfXZoxRiIgbk8DBBLBIWnwfx49d1HX
         gn4m5FjlYcrXV+3usoFG9ySgUfY1ZksxIOdTcVrrRcuLIY+nl1ZZJQ64NHV9DlgbyB1L
         Gp1zvjR/AjzvAU3IOlfwfZl6CDRGupgYtnHIQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/10] perf/scripts: Remove unnecessary PyTuple resizes
Date: Thu, 25 Feb 2010 04:42:39 +0100
Message-Id: <1267069361-10909-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
References: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

If we know the size of a tuple in advance, there's no need to resize
it - start out with the known size in the first place.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1266822779.6426.4.camel@tropicana>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 .../util/scripting-engines/trace-event-python.c    |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index d402f64..33a414b 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -68,7 +68,7 @@ static void define_value(enum print_arg_type field_type,
 	if (field_type == PRINT_SYMBOL)
 		handler_name = "define_symbolic_value";
 
-	t = PyTuple_New(MAX_FIELDS);
+	t = PyTuple_New(4);
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
 
@@ -79,9 +79,6 @@ static void define_value(enum print_arg_type field_type,
 	PyTuple_SetItem(t, n++, PyInt_FromLong(value));
 	PyTuple_SetItem(t, n++, PyString_FromString(field_str));
 
-	if (_PyTuple_Resize(&t, n) == -1)
-		Py_FatalError("error resizing Python tuple");
-
 	handler = PyDict_GetItemString(main_dict, handler_name);
 	if (handler && PyCallable_Check(handler)) {
 		retval = PyObject_CallObject(handler, t);
@@ -116,7 +113,10 @@ static void define_field(enum print_arg_type field_type,
 	if (field_type == PRINT_SYMBOL)
 		handler_name = "define_symbolic_field";
 
-	t = PyTuple_New(MAX_FIELDS);
+	if (field_type == PRINT_FLAGS)
+		t = PyTuple_New(3);
+	else
+		t = PyTuple_New(2);
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
 
@@ -125,9 +125,6 @@ static void define_field(enum print_arg_type field_type,
 	if (field_type == PRINT_FLAGS)
 		PyTuple_SetItem(t, n++, PyString_FromString(delim));
 
-	if (_PyTuple_Resize(&t, n) == -1)
-		Py_FatalError("error resizing Python tuple");
-
 	handler = PyDict_GetItemString(main_dict, handler_name);
 	if (handler && PyCallable_Check(handler)) {
 		retval = PyObject_CallObject(handler, t);
-- 
1.6.2.3

