Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZCEX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZCEX2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbZCEX17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:27:59 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47828 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342AbZCEX15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:27:57 -0500
Message-Id: <20090305225518.148142886@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 29/41] LTTng menus
Content-Disposition: inline; filename=lttng-menus.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng build Kconfig and makefiles.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 ltt/Kconfig  |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ltt/Makefile |   14 ++++++
 2 files changed, 141 insertions(+)

Index: linux-2.6-lttng/ltt/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/Kconfig	2009-03-05 16:09:08.000000000 -0500
@@ -0,0 +1,127 @@
+menuconfig LTT
+	bool "Linux Trace Toolkit Next Generation (LTTng)"
+	depends on EXPERIMENTAL
+	select MARKERS
+	select TRACEPOINTS
+	default y
+	help
+	  It is possible for the kernel to log important events to a trace
+	  facility. Doing so enables the use of the generated traces in order
+	  to reconstruct the dynamic behavior of the kernel, and hence the
+	  whole system.
+
+	  The tracing process contains 4 parts :
+	      1) The logging of events by key parts of the kernel.
+	      2) The tracer that keeps the events in a data buffer (uses
+	         relay).
+	      3) A trace daemon that interacts with the tracer and is
+	         notified every time there is a certain quantity of data to
+	         read from the tracer.
+	      4) A trace event data decoder that reads the accumulated data
+	         and formats it in a human-readable format.
+
+	  If you say Y, the first component will be built into the kernel.
+
+	  For more information on kernel tracing, lttctl, lttd or lttv,
+	  please check the following address :
+	       http://ltt.polymtl.ca
+
+if LTT
+
+config LTT_RELAY_ALLOC
+	def_bool n
+
+config LTT_RELAY_LOCKED
+	tristate "Linux Trace Toolkit Lock-Protected Data Relay"
+	select DEBUG_FS
+	select LTT_RELAY_ALLOC
+	depends on LTT_TRACER
+	default n
+	help
+	  Support using the slow spinlock and interrupt disable algorithm to log
+	  the data obtained through LTT.
+
+config LTT_RELAY_CHECK_RANDOM_ACCESS
+	bool "Debug check for random access in ltt relay buffers"
+	depends on LTT_RELAY_ALLOC
+	default n
+	help
+	  Add checks for random access to LTTng relay buffers. Given those
+	  buffers are a linked list, such access are rather slow. Rare accesses
+	  are OK; they can be caused by large writes (more than a page large) or
+	  by reentrancy (e.g. interrupt nesting over the tracing code).
+
+config LTT_SERIALIZE
+	tristate "Linux Trace Toolkit Serializer"
+	depends on LTT_RELAY_ALLOC
+	default y
+	help
+	  Library for serializing information from format string and argument
+	  list to the trace buffers.
+
+config LTT_FAST_SERIALIZE
+	tristate "Linux Trace Toolkit Custom Serializer"
+	depends on LTT_RELAY_ALLOC
+	default y
+	help
+	  Library for serializing information from custom, efficient, tracepoint
+	  probes.
+
+config LTT_TRACE_CONTROL
+	tristate "Linux Trace Toolkit Trace Controller"
+	depends on LTT_TRACER
+	default m
+	help
+	  If you enable this option, the debugfs-based Linux Trace Toolkit Trace
+	  Controller will be either built in the kernel or as module.
+
+config LTT_TRACER
+	tristate "Linux Trace Toolkit Tracer"
+	default y
+	help
+	  If you enable this option, the Linux Trace Toolkit Tracer will be
+	  either built in the kernel or as module.
+
+	  Critical parts of the kernel will call upon the kernel tracing
+	  function. The data is then recorded by the tracer if a trace daemon
+	  is running in user-space and has issued a "start" command.
+
+	  For more information on kernel tracing, the trace daemon or the event
+	  decoder, please check the following address :
+	       http://www.opersys.com/ltt
+	  See also the experimental page of the project :
+	       http://ltt.polymtl.ca
+
+config LTT_ALIGNMENT
+	bool "Align Linux Trace Toolkit Traces"
+	default n
+	help
+	  This option enables dynamic alignment of data in buffers. The
+	  alignment is made on the smallest size between architecture size
+	  and the size of the value to be written.
+
+	  Dynamically calculating the offset of the data has a performance cost,
+	  but it is more efficient on some architectures (especially 64 bits) to
+	  align data than to write it unaligned.
+
+config LTT_CHECK_ARCH_EFFICIENT_UNALIGNED_ACCESS
+	def_bool y
+	select LTT_ALIGNMENT if !HAVE_EFFICIENT_UNALIGNED_ACCESS
+
+config LTT_DEBUG_EVENT_SIZE
+	bool "Add event size field to LTT events for tracer debugging"
+	default n
+	help
+	  Tracer-internal option to help debugging event type encoding problems.
+
+config LTT_VMCORE
+	bool "Support trace extraction from crash dump"
+	default y
+	help
+	  If you enable this option, the Linux Trace Toolkit Tracer will
+	  support extacting ltt log from vmcore, which can be generated with
+	  kdump or LKCD tools.
+
+	  Special crash extension should be used to extract ltt buffers.
+
+endif # LTT
Index: linux-2.6-lttng/ltt/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/Makefile	2009-03-05 16:09:20.000000000 -0500
@@ -0,0 +1,14 @@
+#
+# Makefile for the LTT objects.
+#
+
+obj-$(CONFIG_MARKERS)			+= ltt-channels.o
+obj-$(CONFIG_LTT)			+= ltt-core.o
+obj-$(CONFIG_LTT_TRACER)		+= ltt-tracer.o
+obj-$(CONFIG_LTT_TRACE_CONTROL)		+= ltt-marker-control.o
+obj-$(CONFIG_LTT_RELAY_LOCKED)		+= ltt-relay-locked.o
+obj-$(CONFIG_LTT_RELAY_ALLOC)		+= ltt-relay-alloc.o
+obj-$(CONFIG_LTT_SERIALIZE)		+= ltt-serialize.o
+obj-$(CONFIG_LTT_STATEDUMP)		+= ltt-statedump.o
+obj-$(CONFIG_LTT_FAST_SERIALIZE)	+= ltt-type-serializer.o
+obj-$(CONFIG_LTT_TRACE_CONTROL)		+= ltt-trace-control.o

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
