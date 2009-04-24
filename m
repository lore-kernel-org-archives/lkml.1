Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZDXEcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZDXEcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZDXEbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:31:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40426 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZDXEbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:31:16 -0400
Message-Id: <20090424043114.991222530@goodmis.org>
References: <20090424043005.338878133@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 24 Apr 2009 00:30:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/6] tracing: fix cut and paste macro error
Content-Disposition: inline; filename=0005-tracing-fix-cut-and-paste-macro-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In case a module uses the TRACE_EVENT macro for creating automated
events in ftrace, it may choose to use a different file name
than the defined system name, or choose to use a different path than
the default "include/trace/events" include path.

If this is done, then before including trace/define_trace.h the
header would define either "TRACE_INCLUDE_FILE" for the file
name or "TRACE_INCLUDE_PATH" for the include path.

If it does not define these, then the define_trace.h defines them
instead. If define trace defines them, then define_trace.h should
also undefine them before exiting. To do this a macro is used
to note this:

 #ifndef TRACE_INCLUDE_FILE
 # define TRACE_INCLUDE_FILE TRACE_SYSTEM
 # define UNDEF_TRACE_INCLUDE_FILE
 #endif

[...]

 #ifdef UNDEF_TRACE_INCLUDE_FILE
 # undef TRACE_INCLUDE_FILE
 # undef UNDEF_TRACE_INCLUDE_FILE
 #endif

The UNDEF_TRACE_INCLUDE_FILE acts as a CPP variable to know to undef
the TRACE_INCLUDE_FILE before leaving define_trace.h.

Unfortunately, due to cut and paste errors, the macros between
FILE and PATH got mixed up.

[ Impact: undef TRACE_INCLUDE_FILE and/or TRACE_INCLUDE_PATH when needed ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/define_trace.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 7f1f23d..abc611f 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -44,7 +44,7 @@
 
 #ifndef TRACE_INCLUDE_PATH
 # define __TRACE_INCLUDE(system) <trace/events/system.h>
-# define UNDEF_TRACE_INCLUDE_FILE
+# define UNDEF_TRACE_INCLUDE_PATH
 #else
 # define __TRACE_INCLUDE(system) __stringify(TRACE_INCLUDE_PATH/system.h)
 #endif
@@ -64,13 +64,13 @@
 
 /* Only undef what we defined in this file */
 #ifdef UNDEF_TRACE_INCLUDE_FILE
-# undef TRACE_INCLUDE_PATH
+# undef TRACE_INCLUDE_FILE
 # undef UNDEF_TRACE_INCLUDE_FILE
 #endif
 
-#ifdef UNDEF_TRACE_INCLUDE_FILE
+#ifdef UNDEF_TRACE_INCLUDE_PATH
 # undef TRACE_INCLUDE_PATH
-# undef UNDEF_TRACE_INCLUDE_FILE
+# undef UNDEF_TRACE_INCLUDE_PATH
 #endif
 
 /* We may be processing more files */
-- 
1.6.2.1

-- 
