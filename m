Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab0BQN2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:28:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46231 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932602Ab0BQN2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:28:51 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] tty: Keep the default buffering to sub-page units
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Feb 2010 13:04:53 +0000
Message-ID: <20100217130405.15830.27197.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocate during interrupts so while our buffering is normally diced up
small anyway on some hardware at speed we can pressure the VM excessively
for page pairs. We don't really need big buffers to be linear so don't try
so hard.

In order to make this work well we will tidy up excess callers to request_room,
which cannot itself enforce this break up.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_buffer.c |    5 +++--
 include/linux/tty.h       |   10 ++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 66fa4e1..8402eda 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -247,7 +247,7 @@ int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
 {
 	int copied = 0;
 	do {
-		int space = tty_buffer_request_room(tty, size - copied);
+		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0))
@@ -283,7 +283,8 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
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

