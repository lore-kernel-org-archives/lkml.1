Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXIYMkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXIYMkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXIYMkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:40:23 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:34398 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbXIYMkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:40:22 -0400
Message-Id: <20070925121252.555122610@polymtl.ca>
References: <20070925121145.262664884@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 08:11:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [patch 5/5] Linux Kernel Markers - Documentation
Content-Disposition: inline; filename=linux-kernel-markers-documentation.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 25 Sep 2007 12:39:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is some documentation explaining what is/how to use the Linux
Kernel Markers.

Changelog:
- Move the examples to a separate "samples" patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: "Frank Ch. Eigler" <fche@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
---

 Documentation/markers.txt |   81 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

Index: linux-2.6-lttng/Documentation/markers.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/Documentation/markers.txt	2007-09-24 17:44:56.000000000 -0400
@@ -0,0 +1,81 @@
+ 	             Using the Linux Kernel Markers
+
+			    Mathieu Desnoyers
+
+
+This document introduces Linux Kernel Markers and their use. It provides
+examples of how to insert markers in the kernel and connect probe functions to
+them and provides some examples of probe functions.
+
+
+* Purpose of markers
+
+A marker placed in code provides a hook to call a function (probe) that you can
+provide at runtime. A marker can be "on" (a probe is connected to it) or "off"
+(no probe is attached). When a marker is "off" it has no effect, except for
+adding a tiny time penalty (checking a condition for a branch) and space
+penalty (adding a few bytes for the function call at the end of the
+instrumented function and adds a data structure in a separate section).  When a
+marker is "on", the function you provide is called each time the marker is
+executed, in the execution context of the caller. When the function provided
+ends its execution, it returns to the caller (continuing from the marker site).
+
+You can put markers at important locations in the code. Markers are
+lightweight hooks that can pass an arbitrary number of parameters,
+described in a printk-like format string, to the attached probe function.
+
+They can be used for tracing and performance accounting.
+
+
+* Usage
+
+In order to use the macro trace_mark, you should include linux/marker.h.
+
+#include <linux/marker.h>
+
+And,
+
+trace_mark(subsystem_event, "%d %s", someint, somestring);
+Where :
+- subsystem_event is an identifier unique to your event
+    - subsystem is the name of your subsystem.
+    - event is the name of the event to mark.
+- "%d %s" is the formatted string for the serializer.
+- someint is an integer.
+- somestring is a char pointer.
+
+Connecting a function (probe) to a marker is done by providing a probe (function
+to call) for the specific marker through marker_probe_register() and can be
+activated by calling marker_arm(). Marker deactivation can be done by calling
+marker_disarm() as many times as marker_arm() has been called. Removing a probe
+is done through marker_probe_unregister(); it will disarm the probe and make
+sure there is no caller left using the probe when it returns. Probe removal is
+preempt-safe because preemption is disabled around the probe call. See the
+"Probe example" section below for a sample probe module.
+
+The marker mechanism supports inserting multiple instances of the same marker.
+Markers can be put in inline functions, inlined static functions, and
+unrolled loops as well as regular functions.
+
+The naming scheme "subsystem_event" is suggested here as a convention intended
+to limit collisions. Marker names are global to the kernel: they are considered
+as being the same whether they are in the core kernel image or in modules.
+Conflicting format strings for markers with the same name will cause the markers
+to be detected to have a different format string not to be armed and will output
+a printk warning which identifies the inconsistency:
+
+"Format mismatch for probe probe_name (format), marker (format)"
+
+
+* Probe / marker example
+
+See the example provided in samples/markers/src
+
+Compile them with your kernel.
+
+Run, as root :
+modprobe marker-example (insmod order is not important)
+modprobe probe-example
+cat /proc/marker-example (returns an expected error)
+rmmod marker-example probe-example
+dmesg

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
