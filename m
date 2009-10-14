Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZJNGa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZJNGa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZJNGa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:30:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:52050 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbZJNGa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:30:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,555,1249282800"; 
   d="scan'208";a="198717092"
Subject: [RFC 1/2] Unified UUID/GUID definition
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 14:30:05 +0800
Message-Id: <1255501805.6047.1192.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many different UUID/GUID definitions in kernel, such as that
in EFI, many file systems, some drivers, etc. Every kernel components
need UUID/GUID has its own definition. This patch provides a unified
definition for UUID/GUID.

UUID is defined via typedef. This makes that UUID appears more like a
preliminary type, and makes the data type explicit (comparing with
implicit "u8 uuid[16]").

The binary representation of UUID/GUID can be little-endian (used by
EFI, etc) or big-endian (defined by RFC4122), so both is defined.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/uuid.h |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile         |    2 -
 lib/uuid.c           |   36 +++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/uuid.h
 create mode 100644 lib/uuid.c

--- /dev/null
+++ b/include/linux/uuid.h
@@ -0,0 +1,59 @@
+/*
+ * Unified UUID/GUID definition
+ *
+ * Copyright (C) 2009, Intel Corp.
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _LINUX_UUID_H_
+#define _LINUX_UUID_H_
+
+#include <linux/types.h>
+#include <linux/string.h>
+
+typedef struct {
+	__u8 b[16];
+} uuid_le;
+
+typedef struct {
+	__u8 b[16];
+} uuid_be;
+
+#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+((uuid_le)								\
+{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
+   (b) & 0xff, ((b) >> 8) & 0xff,					\
+   (c) & 0xff, ((c) >> 8) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+
+#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+((uuid_be)								\
+{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
+   ((b) >> 8) & 0xff, (b) & 0xff,					\
+   ((c) >> 8) & 0xff, (c) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+
+#define NULL_UUID_LE							\
+	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+		0x00, 0x00, 0x00, 0x00)
+
+#define NULL_UUID_BE							\
+	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+		0x00, 0x00, 0x00, 0x00)
+
+static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
+{
+	return memcmp(&u1, &u2, sizeof(uuid_le));
+}
+
+static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
+{
+	return memcmp(&u1, &u2, sizeof(uuid_be));
+}
+
+extern void uuid_le_gen(uuid_le *u);
+extern void uuid_be_gen(uuid_be *u);
+
+#endif
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o
+	 string_helpers.o gcd.o uuid.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
--- /dev/null
+++ b/lib/uuid.c
@@ -0,0 +1,36 @@
+/*
+ * Unified UUID/GUID definition
+ *
+ * Copyright (C) 2009, Intel Corp.
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uuid.h>
+#include <linux/random.h>
+
+static void __uuid_gen_common(__u8 b[16])
+{
+	get_random_bytes(b, 16);
+	/* reversion 0b10 */
+	b[8] = (b[8] & 0x3F) | 0x80;
+}
+
+void uuid_le_gen(uuid_le *lu)
+{
+	__uuid_gen_common(lu->b);
+	/* version 4 : random generation */
+	lu->b[7] = (lu->b[7] & 0x0F) | 0x40;
+}
+EXPORT_SYMBOL_GPL(uuid_le_gen);
+
+void uuid_be_gen(uuid_be *bu)
+{
+	__uuid_gen_common(bu->b);
+	/* version 4 : random generation */
+	bu->b[6] = (bu->b[6] & 0x0F) | 0x40;
+}
+EXPORT_SYMBOL_GPL(uuid_be_gen);


