Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab0BQNab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:30:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38577 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932349Ab0BQNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:30:28 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/5] tty: Add a function to insert a string of characters with
	the same flag
To: greg@kroah.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Date: Wed, 17 Feb 2010 13:06:30 +0000
Message-ID: <20100217130604.16008.86393.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB drivers often want to insert a series of bytes all with the same
flag set - provide a helper for this case.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_buffer.c |   12 +++++++-----
 include/linux/tty_flip.h  |    7 ++++++-
 2 files changed, 13 insertions(+), 6 deletions(-)


diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 8402eda..af8d977 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -231,9 +231,10 @@ int tty_buffer_request_room(struct tty_struct *tty, size_t size)
 EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 
 /**
- *	tty_insert_flip_string	-	Add characters to the tty buffer
+ *	tty_insert_flip_string_fixed_flag - Add characters to the tty buffer
  *	@tty: tty structure
  *	@chars: characters
+ *	@flag: flag value for each character
  *	@size: size
  *
  *	Queue a series of bytes to the tty buffering. All the characters
@@ -242,18 +243,19 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
  *	Locking: Called functions may take tty->buf.lock
  */
 
-int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
-				size_t size)
+int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
+		const unsigned char *chars, char flag, size_t size)
 {
 	int copied = 0;
 	do {
+		int goal = min(size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0))
 			break;
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
-		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
+		memset(tb->flag_buf_ptr + tb->used, flag, space);
 		tb->used += space;
 		copied += space;
 		chars += space;
@@ -262,7 +264,7 @@ int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
 	} while (unlikely(size > copied));
 	return copied;
 }
-EXPORT_SYMBOL(tty_insert_flip_string);
+EXPORT_SYMBOL(tty_insert_flip_string_fixed_flag);
 
 /**
  *	tty_insert_flip_string_flags	-	Add characters to the tty buffer
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index eb677cf..9239d03 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -2,8 +2,8 @@
 #define _LINUX_TTY_FLIP_H
 
 extern int tty_buffer_request_room(struct tty_struct *tty, size_t size);
-extern int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars, size_t size);
 extern int tty_insert_flip_string_flags(struct tty_struct *tty, const unsigned char *chars, const char *flags, size_t size);
+extern int tty_insert_flip_string_fixed_flag(struct tty_struct *tty, const unsigned char *chars, char flag, size_t size);
 extern int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars, size_t size);
 extern int tty_prepare_flip_string_flags(struct tty_struct *tty, unsigned char **chars, char **flags, size_t size);
 void tty_schedule_flip(struct tty_struct *tty);
@@ -20,4 +20,9 @@ static inline int tty_insert_flip_char(struct tty_struct *tty,
 	return tty_insert_flip_string_flags(tty, &ch, &flag, 1);
 }
 
+static inline int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars, size_t size)
+{
+	return tty_insert_flip_string_fixed_flag(tty, chars, TTY_NORMAL, size);
+}
+
 #endif /* _LINUX_TTY_FLIP_H */

