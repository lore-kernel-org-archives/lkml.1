Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZGXQMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZGXQMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZGXQMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:12:48 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51198 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbZGXQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:46 -0400
Subject: [PATCH 6/8] kmemleak: Printing of the objects hex dump
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date: Fri, 24 Jul 2009 17:12:35 +0100
Message-ID: <20090724161235.5752.34490.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
References: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:35.0752 (UTC) FILETIME=[8EA95A80:01CA0C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>

Introducing printing of the objects hex dump to the seq file.
The number of lines to be printed is limited to HEX_MAX_LINES
to prevent seq file spamming. The actual number of printed
bytes is less than or equal to (HEX_MAX_LINES * HEX_ROW_SIZE).

(slight adjustments by Catalin Marinas)

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7dcb898..983f3f6 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -162,6 +162,15 @@ struct kmemleak_object {
 /* flag set on newly allocated objects */
 #define OBJECT_NEW		(1 << 3)
 
+/* number of bytes to print per line; must be 16 or 32 */
+#define HEX_ROW_SIZE		16
+/* number of bytes to print at a time (1, 2, 4, 8) */
+#define HEX_GROUP_SIZE		1
+/* include ASCII after the hex output */
+#define HEX_ASCII		1
+/* max number of lines to be printed */
+#define HEX_MAX_LINES		2
+
 /* the list of all allocated objects */
 static LIST_HEAD(object_list);
 /* the list of gray-colored objects (see color_gray comment below) */
@@ -259,6 +268,35 @@ static void kmemleak_disable(void);
 } while (0)
 
 /*
+ * Printing of the objects hex dump to the seq file. The number of lines to be
+ * printed is limited to HEX_MAX_LINES to prevent seq file spamming. The
+ * actual number of printed bytes depends on HEX_ROW_SIZE. It must be called
+ * with the object->lock held.
+ */
+static void hex_dump_object(struct seq_file *seq,
+			    struct kmemleak_object *object)
+{
+	const u8 *ptr = (const u8 *)object->pointer;
+	int i, len, remaining;
+	unsigned char linebuf[HEX_ROW_SIZE * 5];
+
+	/* limit the number of lines to HEX_MAX_LINES */
+	remaining = len =
+		min(object->size, (size_t)(HEX_MAX_LINES * HEX_ROW_SIZE));
+
+	seq_printf(seq, "  hex dump (first %d bytes):\n", len);
+	for (i = 0; i < len; i += HEX_ROW_SIZE) {
+		int linelen = min(remaining, HEX_ROW_SIZE);
+
+		remaining -= HEX_ROW_SIZE;
+		hex_dump_to_buffer(ptr + i, linelen, HEX_ROW_SIZE,
+				   HEX_GROUP_SIZE, linebuf, sizeof(linebuf),
+				   HEX_ASCII);
+		seq_printf(seq, "    %s\n", linebuf);
+	}
+}
+
+/*
  * Object colors, encoded with count and min_count:
  * - white - orphan object, not enough references to it (count < min_count)
  * - gray  - not orphan, not marked as false positive (min_count == 0) or
@@ -308,6 +346,7 @@ static void print_unreferenced(struct seq_file *seq,
 		   object->pointer, object->size);
 	seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
 		   object->comm, object->pid, object->jiffies);
+	hex_dump_object(seq, object);
 	seq_printf(seq, "  backtrace:\n");
 
 	for (i = 0; i < object->trace_len; i++) {

