Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0BYKJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:09:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:47579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab0BYKJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:09:08 -0500
Date: Thu, 25 Feb 2010 10:08:27 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266822779.6426.4.camel@tropicana>
References: <1266822779.6426.4.camel@tropicana>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/scripts: Remove unnecessary PyTuple resizes
Message-ID: <tip-44ad9cd8f0893b9ae0ac729a7dc2a1ebcd170ac6@git.kernel.org>
Git-Commit-ID: 44ad9cd8f0893b9ae0ac729a7dc2a1ebcd170ac6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:08:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44ad9cd8f0893b9ae0ac729a7dc2a1ebcd170ac6
Gitweb:     http://git.kernel.org/tip/44ad9cd8f0893b9ae0ac729a7dc2a1ebcd170ac6
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Mon, 22 Feb 2010 01:12:59 -0600
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 25 Feb 2010 04:07:49 +0100

perf/scripts: Remove unnecessary PyTuple resizes

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
