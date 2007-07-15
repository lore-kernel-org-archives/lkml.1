Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbXGOBgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbXGOBgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762825AbXGOBgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:36:13 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:39095 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762105AbXGOBgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:36:12 -0400
Date: Sat, 14 Jul 2007 21:36:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Immediate Values - Architecture Independent Code - kerneldoc
Message-ID: <20070715013611.GF23209@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.231272637@polymtl.ca> <20070714225925.GC18674@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714225925.GC18674@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:35:26 up 7 days, 15:40,  2 users,  load average: 0.22, 0.24, 0.16
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - Architecture Independent Code - kerneldoc

Add kerneldoc to Immediate Values API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 include/linux/immediate.h |   66 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/immediate.h	2007-07-14 20:27:40.000000000 -0400
+++ linux-2.6-lttng/include/linux/immediate.h	2007-07-14 20:40:40.000000000 -0400
@@ -19,18 +19,64 @@
 
 struct module;
 
+/**
+ * immediate_read - read immediate variable
+ * @var: pointer of type immediate_*_t
+ *
+ * Reads the value of @var.
+ */
 #define immediate_read(var)		_immediate_read(var)
+
+/**
+ * immediate_set - set immediate variable (with locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var, taking the module_mutex if required by
+ * the architecture.
+ */
 #define immediate_set(var, i)		((var)->value = (i))
+
+/**
+ * _immediate_set - set immediate variable (without locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Must be called with module_mutex held.
+ */
 #define _immediate_set(var, i)		immediate_set(var, i)
+
+/**
+ * immediate_set_early - set immediate variable at early boot
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Should be used for early boot updates.
+ */
 #define immediate_set_early(var, i)	immediate_set(var, i)
+
+/**
+ * immediate_if - if () statement depending on an immediate value
+ * @var: pointer of type immediate_*_t
+ *
+ * Use as an if () statement depending on an immediate value.
+ */
 #define immediate_if(var)		if (immediate_read(var))
 
+/*
+ * Internal update functions.
+ */
 static inline void module_immediate_setup(struct module *mod) { }
 static inline void immediate_update_early(void) { }
 #endif
 
-/*
- * Always access this type with the provided functions.
+/**
+ * DEFINE_IMMEDIATE_TYPE - Define an immediate type
+ * @type: type that the immediate should hold
+ * @name: name of the immediate type
+ *
+ * Define new immediate types. Naming scheme is immediate_*_t.
+ * Always access these types with the provided functions.
  */
 #define DEFINE_IMMEDIATE_TYPE(type, name) \
 	typedef struct { type value; } name
@@ -44,18 +90,28 @@ DEFINE_IMMEDIATE_TYPE(int, immediate_int
 DEFINE_IMMEDIATE_TYPE(long, immediate_long_t);
 DEFINE_IMMEDIATE_TYPE(void*, immediate_void_ptr_t);
 
-/*
- * Use this macro to initialize an immediate value to an initial static value.
+/**
+ * IMMEDIATE_INIT - Static initialization of an immediate variable
+ * @i: required value
+ *
+ * Use this macro to initialize an immediate value to an initial static
+ * value.
  */
 #define IMMEDIATE_INIT(i)		{ (i) }
 
-/*
+/**
+ * _immediate_read - Read immediate value with standard memory load.
+ * @var: pointer of type immediate_*_t
+ *
  * Force a data read of the immediate value instead of the immediate value
  * based mechanism. Useful for __init and __exit section data read.
  */
 #define _immediate_read(var)		(var)->value
 
 /*
+ * _immediate_if - if () statement depending on immediate value (memory load)
+ * @var: pointer of type immediate_*_t
+ *
  * Force the use of a normal if () statement depending on an immediate value.
  */
 #define _immediate_if(var)		if (_immediate_read(var))
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
