Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZI2F5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZI2F5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZI2F5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:57:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:65157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZI2F5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:57:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,471,1249282800"; 
   d="scan'208";a="554601490"
Subject: Re: [PATCH 0/9] Add vsprintf extension %pU to print UUID/GUIDs and
 use it
From: Huang Ying <ying.huang@intel.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Adrian Hunter <adrian.hunter@nokia.com>, Alex Elder <aelder@sgi.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>,
       Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>
In-Reply-To: <cover.1254193019.git.joe@perches.com>
References: <cover.1254193019.git.joe@perches.com>
Content-Type: multipart/mixed; boundary="=-0fXqN1+NEECetIsfZ5sW"
Date: Tue, 29 Sep 2009 13:57:32 +0800
Message-Id: <1254203852.15717.1506.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0fXqN1+NEECetIsfZ5sW
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi, Joe,

Thanks for the patch. I think that is a good idea.

For your patch. I think you need a changelog for each patch.

It seems that the binary representation of UUID can be little-endian
(used by most kernel components) or big-endian (defined by RFC4122, used
in network?). Maybe we should consider about that.

In fact, I find there are many different UUID/GUID definitions in
kernel, such as that in efi, many file systems, some drivers, etc. It
seems that every kernel components need UUID/GUID has its own
definition, so I think we should unify all the UUID/GUID definitions in
kernel too. The file attached is a draft unified UUID/GUID definition,
with byte-order issue in mind.

Any comment?

Best Regards,
Huang Ying


--=-0fXqN1+NEECetIsfZ5sW
Content-Disposition: attachment; filename="0010-uuid.patch"
Content-Type: text/x-patch; name="0010-uuid.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

From: Huang Ying <ying.huang@intel.com>
Date: Fri, 7 Aug 2009 15:03:15 +0800
Subject: [PATCH] Unified UUID/GUID definition

There are many different UUID/GUID definitions in kernel, such as that
in efi, many file systems, some drivers, etc. Every kernel components
need UUID/GUID has its own definition. This patch provides a unified
definition for UUID/GUID.

The binary representation of UUID/GUID can be little-endian (used by
EFI, etc) or big-endian (defined by RFC4122), so both is defined.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/uuid.h |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile         |    2 -
 lib/uuid.c           |   33 ++++++++++++++++
 3 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/uuid.h
 create mode 100644 lib/uuid.c

--- /dev/null
+++ b/include/linux/uuid.h
@@ -0,0 +1,101 @@
+/*
+ *  Unified UUID/GUID definition
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
+	u8 b[16];
+} luuid_t;
+
+typedef struct {
+	u8 b[16];
+} buuid_t;
+
+#define LUUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+((luuid_t)								\
+{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
+   (b) & 0xff, ((b) >> 8) & 0xff,					\
+   (c) & 0xff, ((c) >> 8) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+
+#define BUUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+((luuid_t)								\
+{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
+   ((b) >> 8) & 0xff, (b) & 0xff,					\
+   ((c) >> 8) & 0xff, (c) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+
+#define NULL_UUID							\
+	LUUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+	      0x00, 0x00, 0x00, 0x00)
+
+static inline int luuid_cmp(luuid_t g1, luuid_t g2)
+{
+	return memcmp(&g1, &g2, sizeof(luuid_t));
+}
+
+static inline int buuid_cmp(buuid_t g1, buuid_t g2)
+{
+	return memcmp(&g1, &g2, sizeof(buuid_t));
+}
+
+static inline char *luuid_to_str(char *str, const luuid_t *g)
+{
+	sprintf(str, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
+		"%02x%02x%02x%02x%02x%02x",
+		g->b[3], g->b[2], g->b[1], g->b[0],
+		g->b[5], g->b[4], g->b[7], g->b[6],
+		g->b[8], g->b[9], g->b[10], g->b[11],
+		g->b[12], g->b[13], g->b[14], g->b[15]);
+	return str;
+}
+
+static inline char *buuid_to_str(char *str, const buuid_t *g)
+{
+	sprintf(str, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
+		"%02x%02x%02x%02x%02x%02x",
+		g->b[0], g->b[1], g->b[2], g->b[3],
+		g->b[4], g->b[5], g->b[6], g->b[7],
+		g->b[8], g->b[9], g->b[10], g->b[11],
+		g->b[12], g->b[13], g->b[14], g->b[15]);
+	return str;
+}
+
+static inline void luuid_to_buuid(buuid_t *bg, const luuid_t *lg)
+{
+	bg->b[0] = lg->b[3];
+	bg->b[1] = lg->b[2];
+	bg->b[2] = lg->b[1];
+	bg->b[3] = lg->b[0];
+	bg->b[4] = lg->b[5];
+	bg->b[5] = lg->b[4];
+	bg->b[6] = lg->b[7];
+	bg->b[7] = lg->b[6];
+}
+
+static inline void buuid_to_luuid(luuid_t *lg, const buuid_t *bg)
+{
+	lg->b[0] = bg->b[3];
+	lg->b[1] = bg->b[2];
+	lg->b[2] = bg->b[1];
+	lg->b[3] = bg->b[0];
+	lg->b[4] = bg->b[5];
+	lg->b[5] = bg->b[4];
+	lg->b[6] = bg->b[7];
+	lg->b[7] = bg->b[6];
+}
+
+extern void luuid_gen(luuid_t *g);
+extern void buuid_gen(buuid_t *g);
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
@@ -0,0 +1,33 @@
+/*
+ *  Unified UUID/GUID definition
+ *
+ * Copyright (C) 2009, Intel Corp.
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/uuid.h>
+#include <linux/random.h>
+
+static void uuid_gen_common(u8 b[16])
+{
+	get_random_bytes(b, 16);
+	/* reversion 0b10 */
+	b[8] = (b[8] & 0x3F) | 0x80;
+}
+
+void luuid_gen(luuid_t *lg)
+{
+	uuid_gen_common(lg->b);
+	/* version 4 : random generation */
+	lg->b[7] = (lg->b[7] & 0x0F) | 0x40;
+}
+
+void buuid_gen(buuid_t *bg)
+{
+	uuid_gen_common(bg->b);
+	/* version 4 : random generation */
+	bg->b[6] = (bg->b[6] & 0x0F) | 0x40;
+}

--=-0fXqN1+NEECetIsfZ5sW--

