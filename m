Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0BVHTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 02:19:07 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:59526 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0BVHTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 02:19:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bomZGVhrXMxLn/ydNX1UgxIdAGBXjMO4fLd4C3oQDsnd3T/U3z8Pda6Pes0tMke0kK
         6cdJYqFhvylPZQdxpD7tTthsH5hLyStY8jF0fRdq5PL/bizGrVsCluuYEGiqYNMFbeV0
         zHQSmW/oywO9DQJPOoiU1YfLyBYYFcAfb3fzc=
Subject: Re: [PATCH 06/12] perf trace/scripting: add Python scripting engine
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
In-Reply-To: <20100222022735.GC8791@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
	 <1264580883-15324-7-git-send-email-tzanussi@gmail.com>
	 <20100222022735.GC8791@nowhere>
Content-Type: text/plain
Date: Mon, 22 Feb 2010 01:12:59 -0600
Message-Id: <1266822779.6426.4.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 03:27 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 27, 2010 at 02:27:57AM -0600, Tom Zanussi wrote:
> > +static void define_value(enum print_arg_type field_type,
> > +			 const char *ev_name,
> > +			 const char *field_name,
> > +			 const char *field_value,
> > +			 const char *field_str)
> > +{
> > +	const char *handler_name = "define_flag_value";
> > +	PyObject *handler, *t, *retval;
> > +	unsigned long long value;
> > +	unsigned n = 0;
> > +
> > +	if (field_type == PRINT_SYMBOL)
> > +		handler_name = "define_symbolic_value";
> > +
> > +	t = PyTuple_New(MAX_FIELDS);
> > +	if (!t)
> > +		Py_FatalError("couldn't create Python tuple");
> > +
> > +	value = eval_flag(field_value);
> > +
> > +	PyTuple_SetItem(t, n++, PyString_FromString(ev_name));
> > +	PyTuple_SetItem(t, n++, PyString_FromString(field_name));
> > +	PyTuple_SetItem(t, n++, PyInt_FromLong(value));
> > +	PyTuple_SetItem(t, n++, PyString_FromString(field_str));
> > +
> > +	if (_PyTuple_Resize(&t, n) == -1)
> > +		Py_FatalError("error resizing Python tuple");
> 
> 
> 
> Why are creating a tuple of 64 fields while you are always using
> 4?
> 
> 
> 
> > +
> > +	handler = PyDict_GetItemString(main_dict, handler_name);
> > +	if (handler && PyCallable_Check(handler)) {
> > +		retval = PyObject_CallObject(handler, t);
> > +		if (retval == NULL)
> > +			handler_call_die(handler_name);
> > +	}
> > +
> > +	Py_DECREF(t);
> > +}
> > +
> > +
> 
> [...]
> 
> > +static void define_field(enum print_arg_type field_type,
> > +			 const char *ev_name,
> > +			 const char *field_name,
> > +			 const char *delim)
> > +{
> > +	const char *handler_name = "define_flag_field";
> > +	PyObject *handler, *t, *retval;
> > +	unsigned n = 0;
> > +
> > +	if (field_type == PRINT_SYMBOL)
> > +		handler_name = "define_symbolic_field";
> > +
> > +	t = PyTuple_New(MAX_FIELDS);
> > +	if (!t)
> > +		Py_FatalError("couldn't create Python tuple");
> > +
> > +	PyTuple_SetItem(t, n++, PyString_FromString(ev_name));
> > +	PyTuple_SetItem(t, n++, PyString_FromString(field_name));
> > +	if (field_type == PRINT_FLAGS)
> > +		PyTuple_SetItem(t, n++, PyString_FromString(delim));
> > +
> > +	if (_PyTuple_Resize(&t, n) == -1)
> > +		Py_FatalError("error resizing Python tuple");
> 
> 
> 
> Same here (except you may or may not have a PRINT_FLAGS type).
> 

Good point - no reason to resize if we don't have to.  Here's a patch to
change that.

Thanks,

Tom

[PATCH] perf trace/scripting: remove unnecessary PyTuple resizes

If we know the size of a tuple in advance, there's no need to resize
it - start out with the known size in the first place.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
1.6.4.GIT




