Return-Path: <linux-kernel-owner+w=401wt.eu-S2992897AbXDRWfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992897AbXDRWfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992899AbXDRWfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:35:24 -0400
Received: from av1.karneval.cz ([81.27.192.123]:27081 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992897AbXDRWfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:35:23 -0400
Message-id: <21144242611885323036@karneval.cz>
Subject: [RFC 1/1] Char: tty, add io tty_insert_flip_string variants
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 19 Apr 2007 00:35:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

don't you consider this useful for some drivers. There are many cases, when
tty_insert_flip_stringio might be used.

--

tty, add io tty_insert_flip_string variants

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a7dafceb31ff535b793227036f5b2b6a1e8cf233
tree 51e1bd24bfb9a2842bb12e097cec0b97a7bf3998
parent 71c2e9b72594f69e4e226006206ffa74b55c1642
author Jiri Slaby <jirislaby@gmail.com> Thu, 19 Apr 2007 00:27:22 +0200
committer Jiri Slaby <jirislaby@gmail.com> Thu, 19 Apr 2007 00:27:22 +0200

 drivers/char/tty_io.c   |  101 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 69 insertions(+), 32 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 959a616..6b215ed 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -95,6 +95,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 
+#include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
@@ -441,6 +442,25 @@ int tty_buffer_request_room(struct tty_struct *tty, size_t size)
 }
 EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 
+#define __tty_insert_flip_string(tty, chars, flags, size, chrfun, flfun) ({ \
+	int copied = 0;							\
+	do {								\
+		int space = tty_buffer_request_room(tty, size - copied);\
+		struct tty_buffer *tb = tty->buf.tail;			\
+		/* If there is no space then tb may be NULL */		\
+		if (unlikely(space == 0))				\
+			break;						\
+		chrfun(tb->char_buf_ptr + tb->used, chars, space);	\
+		flfun(tb->flag_buf_ptr + tb->used, flags, space);	\
+		tb->used += space;					\
+		copied += space;					\
+		chars += space;						\
+		/* There is a small chance that we need to split the data over \
+		   several buffers. If this is the case we must loop */	\
+	} while (unlikely(size > copied));				\
+	copied;								\
+})
+
 /**
  *	tty_insert_flip_string	-	Add characters to the tty buffer
  *	@tty: tty structure
@@ -456,26 +476,33 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
 				size_t size)
 {
-	int copied = 0;
-	do {
-		int space = tty_buffer_request_room(tty, size - copied);
-		struct tty_buffer *tb = tty->buf.tail;
-		/* If there is no space then tb may be NULL */
-		if(unlikely(space == 0))
-			break;
-		memcpy(tb->char_buf_ptr + tb->used, chars, space);
-		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
-		tb->used += space;
-		copied += space;
-		chars += space;
-		/* There is a small chance that we need to split the data over
-		   several buffers. If this is the case we must loop */
-	} while (unlikely(size > copied));
-	return copied;
+	return __tty_insert_flip_string(tty, chars, TTY_NORMAL, size,
+			memcpy, memset);
 }
 EXPORT_SYMBOL(tty_insert_flip_string);
 
 /**
+ *	tty_insert_flip_stringio	-	Add characters to the tty buffer
+ *	@tty: tty structure
+ *	@chars: characters
+ *	@size: size
+ *
+ *	Queue a series of bytes to the tty buffering from io memory. All the
+ *	characters passed are marked as without error. Returns the number
+ *	added.
+ *
+ *	Locking: Called functions may take tty->buf.lock
+ */
+
+int tty_insert_flip_stringio(struct tty_struct *tty,
+		const unsigned char __iomem *chars, size_t size)
+{
+	return __tty_insert_flip_string(tty, chars, TTY_NORMAL, size,
+			memcpy_fromio, memset);
+}
+EXPORT_SYMBOL(tty_insert_flip_stringio);
+
+/**
  *	tty_insert_flip_string_flags	-	Add characters to the tty buffer
  *	@tty: tty structure
  *	@chars: characters
@@ -492,27 +519,35 @@ EXPORT_SYMBOL(tty_insert_flip_string);
 int tty_insert_flip_string_flags(struct tty_struct *tty,
 		const unsigned char *chars, const char *flags, size_t size)
 {
-	int copied = 0;
-	do {
-		int space = tty_buffer_request_room(tty, size - copied);
-		struct tty_buffer *tb = tty->buf.tail;
-		/* If there is no space then tb may be NULL */
-		if(unlikely(space == 0))
-			break;
-		memcpy(tb->char_buf_ptr + tb->used, chars, space);
-		memcpy(tb->flag_buf_ptr + tb->used, flags, space);
-		tb->used += space;
-		copied += space;
-		chars += space;
-		flags += space;
-		/* There is a small chance that we need to split the data over
-		   several buffers. If this is the case we must loop */
-	} while (unlikely(size > copied));
-	return copied;
+	return __tty_insert_flip_string(tty, chars, flags, size,
+			memcpy, memcpy);
 }
 EXPORT_SYMBOL(tty_insert_flip_string_flags);
 
 /**
+ *	tty_insert_flip_string_flagsio	- Add characters to the tty buffer
+ *	@tty: tty structure
+ *	@chars: characters
+ *	@flags: flag bytes
+ *	@size: size
+ *
+ *	Queue a series of bytes to the tty buffering from io memory. For each
+ *	character the flags array indicates the status of the character.
+ *	Returns the number added.
+ *
+ *	Locking: Called functions may take tty->buf.lock
+ */
+
+int tty_insert_flip_string_flagsio(struct tty_struct *tty,
+		const unsigned char __iomem *chars, const char *flags,
+		size_t size)
+{
+	return __tty_insert_flip_string(tty, chars, flags, size,
+			memcpy_fromio, memcpy_fromio);
+}
+EXPORT_SYMBOL(tty_insert_flip_string_flagsio);
+
+/**
  *	tty_schedule_flip	-	push characters to ldisc
  *	@tty: tty to push from
  *
