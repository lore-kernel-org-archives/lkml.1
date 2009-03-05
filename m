Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZCEXYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZCEXYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbZCEXYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:24:25 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33238 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102AbZCEXYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:24:24 -0500
Message-Id: <20090305225516.812374558@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:51 -0500
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
Subject: [RFC patch 23/41] Immediate Values Stub header
Content-Disposition: inline; filename=immediate-value-stub-header.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Markers tree integration.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/immediate.h |   94 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/immediate.h	2009-02-06 15:20:17.000000000 -0500
@@ -0,0 +1,94 @@
+#ifndef _LINUX_IMMEDIATE_H
+#define _LINUX_IMMEDIATE_H
+
+/*
+ * Immediate values, can be updated at runtime and save cache lines.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifdef CONFIG_IMMEDIATE
+
+struct __imv {
+	unsigned long var;	/* Pointer to the identifier variable of the
+				 * immediate value
+				 */
+	unsigned long imv;	/*
+				 * Pointer to the memory location of the
+				 * immediate value within the instruction.
+				 */
+	unsigned char size;	/* Type size. */
+} __attribute__ ((packed));
+
+#include <asm/immediate.h>
+
+/**
+ * imv_set - set immediate variable (with locking)
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name, taking the module_mutex if required by
+ * the architecture.
+ */
+#define imv_set(name, i)						\
+	do {								\
+		name##__imv = (i);					\
+		core_imv_update();					\
+		module_imv_update();					\
+	} while (0)
+
+/*
+ * Internal update functions.
+ */
+extern void core_imv_update(void);
+extern void imv_update_range(const struct __imv *begin,
+	const struct __imv *end);
+
+#else
+
+/*
+ * Generic immediate values: a simple, standard, memory load.
+ */
+
+/**
+ * imv_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ */
+#define imv_read(name)			_imv_read(name)
+
+/**
+ * imv_set - set immediate variable (with locking)
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name, taking the module_mutex if required by
+ * the architecture.
+ */
+#define imv_set(name, i)		(name##__imv = (i))
+
+static inline void core_imv_update(void) { }
+static inline void module_imv_update(void) { }
+
+#endif
+
+#define DECLARE_IMV(type, name) extern __typeof__(type) name##__imv
+#define DEFINE_IMV(type, name)  __typeof__(type) name##__imv
+
+#define EXPORT_IMV_SYMBOL(name) EXPORT_SYMBOL(name##__imv)
+#define EXPORT_IMV_SYMBOL_GPL(name) EXPORT_SYMBOL_GPL(name##__imv)
+
+/**
+ * _imv_read - Read immediate value with standard memory load.
+ * @name: immediate value name
+ *
+ * Force a data read of the immediate value instead of the immediate value
+ * based mechanism. Useful for __init and __exit section data read.
+ */
+#define _imv_read(name)		(name##__imv)
+
+#endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
