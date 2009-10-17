Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbZJQP5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbZJQP5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZJQP5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:57:18 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:52246 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZJQP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=axJAa7jP2XIJ1z3US6VMrHZQoN2OESJc3ZGtaDUFBOyk/Q2nSgeeaBr09lMiTwn+sH
         gxOuSQf+ZfZb88Myc5ekRAk/6X91mzxFKEjb6FUlhedfoh6BWigBn55WIOb7Tfc63XFT
         2csl/H5n9boQeTXg2EH5JV2X8AiUqZ632rkCc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/2] perf tools: Use DECLARE_BITMAP instead of an open-coded array
Date: Sat, 17 Oct 2009 17:57:18 +0200
Message-Id: <1255795038-13751-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20091016074222.GD30019@elte.hu>
References: <20091016074222.GD30019@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DECLARE_BITMAP instead of an open coded array for our bitmap
of featured sections.

This makes the array an unsigned long instead of a u64 but since
we use a 256 bits bitmap, the array size shouldn't vary between
different boxes.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/header.c                  |   22 +++++++++-------------
 tools/perf/util/header.h                  |   11 +++--------
 tools/perf/util/include/asm/asm-offsets.h |    1 +
 tools/perf/util/include/linux/types.h     |    8 +++++++-
 4 files changed, 20 insertions(+), 22 deletions(-)
 create mode 100644 tools/perf/util/include/asm/asm-offsets.h

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 171d51b..622c60e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,8 +8,6 @@
 #include "../perf.h"
 #include "trace-event.h"
 
-#include <linux/bitmap.h>
-
 /*
  * Create new perf.data header attribute:
  */
@@ -143,12 +141,12 @@ struct perf_file_header {
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
 	struct perf_file_section	event_types;
-	feat_mask_t			adds_features;
+	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
 void perf_header__feat_trace_info(struct perf_header *header)
 {
-	set_bit(HEADER_TRACE_INFO, perf_header__adds_mask(header));
+	set_bit(HEADER_TRACE_INFO, header->adds_features);
 }
 
 static void do_write(int fd, void *buf, size_t size)
@@ -168,7 +166,7 @@ static void perf_header__adds_write(struct perf_header *self, int fd)
 {
 	struct perf_file_section trace_sec;
 	u64 cur_offset = lseek(fd, 0, SEEK_CUR);
-	unsigned long *feat_mask = perf_header__adds_mask(self);
+	unsigned long *feat_mask = self->adds_features;
 
 	if (test_bit(HEADER_TRACE_INFO, feat_mask)) {
 		/* Write trace info */
@@ -250,7 +248,7 @@ void perf_header__write(struct perf_header *self, int fd)
 		},
 	};
 
-	memcpy(&f_header.adds_features, &self->adds_features, sizeof(feat_mask_t));
+	memcpy(&f_header.adds_features, &self->adds_features, sizeof(self->adds_features));
 
 	lseek(fd, 0, SEEK_SET);
 	do_write(fd, &f_header, sizeof(f_header));
@@ -276,7 +274,7 @@ static void do_read(int fd, void *buf, size_t size)
 
 static void perf_header__adds_read(struct perf_header *self, int fd)
 {
-	const unsigned long *feat_mask = perf_header__adds_mask(self);
+	const unsigned long *feat_mask = self->adds_features;
 
 	if (test_bit(HEADER_TRACE_INFO, feat_mask)) {
 		struct perf_file_section trace_sec;
@@ -306,11 +304,9 @@ struct perf_header *perf_header__read(int fd)
 
 	if (f_header.size != sizeof(f_header)) {
 		/* Support the previous format */
-		if (f_header.size == offsetof(typeof(f_header), adds_features)) {
-			unsigned long *mask = (unsigned long *)(void *)
-					&f_header.adds_features;
-			bitmap_zero(mask, HEADER_FEAT_BITS);
-		} else
+		if (f_header.size == offsetof(typeof(f_header), adds_features))
+			bitmap_zero(f_header.adds_features, HEADER_FEAT_BITS);
+		else
 			die("incompatible file format");
 	}
 	nr_attrs = f_header.attrs.size / sizeof(f_attr);
@@ -346,7 +342,7 @@ struct perf_header *perf_header__read(int fd)
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
-	memcpy(&self->adds_features, &f_header.adds_features, sizeof(feat_mask_t));
+	memcpy(&self->adds_features, &f_header.adds_features, sizeof(f_header.adds_features));
 
 	perf_header__adds_read(self, fd);
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 0eb4a91..2ea9dfb 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -5,6 +5,8 @@
 #include <sys/types.h>
 #include "types.h"
 
+#include <linux/bitmap.h>
+
 struct perf_header_attr {
 	struct perf_event_attr attr;
 	int ids, size;
@@ -16,8 +18,6 @@ struct perf_header_attr {
 
 #define HEADER_FEAT_BITS			256
 
-typedef	typeof(u64[HEADER_FEAT_BITS / 8])	feat_mask_t;
-
 struct perf_header {
 	int			frozen;
 	int			attrs, size;
@@ -27,14 +27,9 @@ struct perf_header {
 	u64			data_size;
 	u64			event_offset;
 	u64			event_size;
-	feat_mask_t		adds_features;
+	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
-static inline unsigned long *perf_header__adds_mask(struct perf_header *self)
-{
-	return (unsigned long *)(void *)&self->adds_features;
-}
-
 struct perf_header *perf_header__read(int fd);
 void perf_header__write(struct perf_header *self, int fd);
 
diff --git a/tools/perf/util/include/asm/asm-offsets.h b/tools/perf/util/include/asm/asm-offsets.h
new file mode 100644
index 0000000..ed53894
--- /dev/null
+++ b/tools/perf/util/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+/* stub */
diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
index ed53894..858a38d 100644
--- a/tools/perf/util/include/linux/types.h
+++ b/tools/perf/util/include/linux/types.h
@@ -1 +1,7 @@
-/* stub */
+#ifndef _PERF_LINUX_TYPES_H_
+#define _PERF_LINUX_TYPES_H_
+
+#define DECLARE_BITMAP(name,bits) \
+	unsigned long name[BITS_TO_LONGS(bits)]
+
+#endif
-- 
1.6.2.3

