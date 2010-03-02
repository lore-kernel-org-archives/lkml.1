Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0CBXiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:38:46 -0500
Received: from kroah.org ([198.145.64.141]:51655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab0CBXhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/36] tty: Keep the default buffering to sub-page units
Date: Tue,  2 Mar 2010 15:36:40 -0800
Message-Id: <1267573003-782-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We allocate during interrupts so while our buffering is normally diced up
small anyway on some hardware at speed we can pressure the VM excessively
for page pairs. We don't really need big buffers to be linear so don't try
so hard.

In order to make this work well we will tidy up excess callers to request_room,
which cannot itself enforce this break up.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_buffer.c |    6 ++++--
 include/linux/tty.h       |   10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 66fa4e1..f27c4d6 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -247,7 +247,8 @@ int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
 {
 	int copied = 0;
 	do {
-		int space = tty_buffer_request_room(tty, size - copied);
+		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0))
@@ -283,7 +284,8 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
 {
 	int copied = 0;
 	do {
-		int space = tty_buffer_request_room(tty, size - copied);
+		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0))
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 6abfcf5..d96e588 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -68,6 +68,16 @@ struct tty_buffer {
 	unsigned long data[0];
 };
 
+/*
+ * We default to dicing tty buffer allocations to this many characters
+ * in order to avoid multiple page allocations. We assume tty_buffer itself
+ * is under 256 bytes. See tty_buffer_find for the allocation logic this
+ * must match
+ */
+
+#define TTY_BUFFER_PAGE		((PAGE_SIZE  - 256) / 2)
+
+
 struct tty_bufhead {
 	struct delayed_work work;
 	spinlock_t lock;
-- 
1.7.0.1

