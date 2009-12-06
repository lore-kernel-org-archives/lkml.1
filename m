Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbZLFRmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbZLFRmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934006AbZLFRmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:42:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33423 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999AbZLFRmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GKj8je6cQqgMvzj7D37cpHEwJ8f64p7xFKG8KAxKr+6aQa0C1G+EgjeST3UUrFf85d
         2X6yPYVubqj1TN21zpbKasDFuk2nuemQBnT276pmWjSy9LCJaDuW7LztMZb23S9TexZT
         7ED2uQSV8Bgdz8PXbUcIyug0oR+lJtwIV8Kec=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: make bitfield annotations truly no-ops when disabled
Date: Sun,  6 Dec 2009 18:42:13 +0100
Message-Id: <1260121333-19642-1-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that even zero-sized struct members (int foo[0];) will affect
the struct layout, causing us in particular to lose 4 bytes in struct sock.

This patch fixes the regression in CONFIG_KMEMCHECK=n case.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/kmemcheck.h |  110 ++++++++++++++++++++++++---------------------
 1 files changed, 58 insertions(+), 52 deletions(-)

Andrew: Compile tested on x86_32 and x86_64, but because of my bad track
record when it comes to brown paper bugs, can you please keep this in -mm
for a little while? Thanks.

diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index e880d4c..08d7dc4 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -36,6 +36,56 @@ int kmemcheck_hide_addr(unsigned long address);
 
 bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size);
 
+/*
+ * Bitfield annotations
+ *
+ * How to use: If you have a struct using bitfields, for example
+ *
+ *     struct a {
+ *             int x:8, y:8;
+ *     };
+ *
+ * then this should be rewritten as
+ *
+ *     struct a {
+ *             kmemcheck_bitfield_begin(flags);
+ *             int x:8, y:8;
+ *             kmemcheck_bitfield_end(flags);
+ *     };
+ *
+ * Now the "flags_begin" and "flags_end" members may be used to refer to the
+ * beginning and end, respectively, of the bitfield (and things like
+ * &x.flags_begin is allowed). As soon as the struct is allocated, the bit-
+ * fields should be annotated:
+ *
+ *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
+ *     kmemcheck_annotate_bitfield(a, flags);
+ */
+#define kmemcheck_bitfield_begin(name)	\
+	int name##_begin[0];
+
+#define kmemcheck_bitfield_end(name)	\
+	int name##_end[0];
+
+#define kmemcheck_annotate_bitfield(ptr, name)				\
+	do {								\
+		int _n;							\
+									\
+		if (!ptr)						\
+			break;						\
+									\
+		_n = (long) &((ptr)->name##_end)			\
+			- (long) &((ptr)->name##_begin);		\
+		MAYBE_BUILD_BUG_ON(_n < 0);				\
+									\
+		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
+	} while (0)
+
+#define kmemcheck_annotate_variable(var)				\
+	do {								\
+		kmemcheck_mark_initialized(&(var), sizeof(var));	\
+	} while (0)							\
+
 #else
 #define kmemcheck_enabled 0
 
@@ -106,60 +156,16 @@ static inline bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
 	return true;
 }
 
-#endif /* CONFIG_KMEMCHECK */
-
-/*
- * Bitfield annotations
- *
- * How to use: If you have a struct using bitfields, for example
- *
- *     struct a {
- *             int x:8, y:8;
- *     };
- *
- * then this should be rewritten as
- *
- *     struct a {
- *             kmemcheck_bitfield_begin(flags);
- *             int x:8, y:8;
- *             kmemcheck_bitfield_end(flags);
- *     };
- *
- * Now the "flags_begin" and "flags_end" members may be used to refer to the
- * beginning and end, respectively, of the bitfield (and things like
- * &x.flags_begin is allowed). As soon as the struct is allocated, the bit-
- * fields should be annotated:
- *
- *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
- *     kmemcheck_annotate_bitfield(a, flags);
- *
- * Note: We provide the same definitions for both kmemcheck and non-
- * kmemcheck kernels. This makes it harder to introduce accidental errors. It
- * is also allowed to pass NULL pointers to kmemcheck_annotate_bitfield().
- */
-#define kmemcheck_bitfield_begin(name)	\
-	int name##_begin[0];
-
-#define kmemcheck_bitfield_end(name)	\
-	int name##_end[0];
+#define kmemcheck_bitfield_begin(name)
+#define kmemcheck_bitfield_end(name)
+#define kmemcheck_annotate_bitfield(ptr, name)	\
+	do {					\
+	} while (0)
 
-#define kmemcheck_annotate_bitfield(ptr, name)				\
-	do {								\
-		int _n;							\
-									\
-		if (!ptr)						\
-			break;						\
-									\
-		_n = (long) &((ptr)->name##_end)			\
-			- (long) &((ptr)->name##_begin);		\
-		MAYBE_BUILD_BUG_ON(_n < 0);				\
-									\
-		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
+#define kmemcheck_annotate_variable(var)	\
+	do {					\
 	} while (0)
 
-#define kmemcheck_annotate_variable(var)				\
-	do {								\
-		kmemcheck_mark_initialized(&(var), sizeof(var));	\
-	} while (0)							\
+#endif /* CONFIG_KMEMCHECK */
 
 #endif /* LINUX_KMEMCHECK_H */
-- 
1.6.0.6

