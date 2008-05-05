Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbYEES2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbYEES2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760480AbYEES0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:26:31 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:32881 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759467AbYEES0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:26:30 -0400
Date: Mon, 5 May 2008 21:25:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] media/video/cx18/: possible cleanups
Message-ID: <20080505182522.GN17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- cx18-i2c.c should #include "cx18-i2c.h" for getting the prototypes of
  it's global functions
- make the following needlessly global functions static:
  - cx18-fileops.c:cx18_claim_stream()
  - cx18-fileops.c:cx18_release_stream()
  - cx18-queue.c:cx18_queue_move()
- remove the following unused functions:
  - cx18-driver.c:cx18_waitq()
  - cx18-queue.c:cx18_buf_copy_from_user()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/cx18/cx18-driver.c  |   10 ----------
 drivers/media/video/cx18/cx18-driver.h  |    3 ---
 drivers/media/video/cx18/cx18-fileops.c |    4 ++--
 drivers/media/video/cx18/cx18-fileops.h |    9 ---------
 drivers/media/video/cx18/cx18-i2c.c     |    1 +
 drivers/media/video/cx18/cx18-queue.c   |   16 +++-------------
 drivers/media/video/cx18/cx18-queue.h   |    4 ----
 7 files changed, 6 insertions(+), 41 deletions(-)

fb75860982d54ff1b4eb4744b75a58d0cc6556d2 diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 8f5ed9b..e10df69 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -164,16 +164,6 @@ MODULE_LICENSE("GPL");
 
 MODULE_VERSION(CX18_VERSION);
 
-int cx18_waitq(wait_queue_head_t *waitq)
-{
-	DEFINE_WAIT(wait);
-
-	prepare_to_wait(waitq, &wait, TASK_INTERRUPTIBLE);
-	schedule();
-	finish_wait(waitq, &wait);
-	return signal_pending(current) ? -EINTR : 0;
-}
-
 /* Generic utility functions */
 int cx18_msleep_timeout(unsigned int msecs, int intr)
 {
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index 2ee9391..a2a6c58 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -444,9 +444,6 @@ extern spinlock_t cx18_cards_lock;
 /* Return non-zero if a signal is pending */
 int cx18_msleep_timeout(unsigned int msecs, int intr);
 
-/* Wait on queue, returns -EINTR if interrupted */
-int cx18_waitq(wait_queue_head_t *waitq);
-
 /* Read Hauppauge eeprom */
 struct tveeprom; /* forward reference */
 void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv);
diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
index 6930306..91eff6e 100644
--- a/drivers/media/video/cx18/cx18-fileops.c
+++ b/drivers/media/video/cx18/cx18-fileops.c
@@ -39,7 +39,7 @@
    associated VBI streams are also automatically claimed.
    Possible error returns: -EBUSY if someone else has claimed
    the stream or 0 on success. */
-int cx18_claim_stream(struct cx18_open_id *id, int type)
+static int cx18_claim_stream(struct cx18_open_id *id, int type)
 {
 	struct cx18 *cx = id->cx;
 	struct cx18_stream *s = &cx->streams[type];
@@ -87,7 +87,7 @@ int cx18_claim_stream(struct cx18_open_id *id, int type)
 
 /* This function releases a previously claimed stream. It will take into
    account associated VBI streams. */
-void cx18_release_stream(struct cx18_stream *s)
+static void cx18_release_stream(struct cx18_stream *s)
 {
 	struct cx18 *cx = s->cx;
 	struct cx18_stream *s_vbi;
diff --git a/drivers/media/video/cx18/cx18-fileops.h b/drivers/media/video/cx18/cx18-fileops.h
index 16cdafb..46da028 100644
--- a/drivers/media/video/cx18/cx18-fileops.h
+++ b/drivers/media/video/cx18/cx18-fileops.h
@@ -34,12 +34,3 @@ void cx18_stop_capture(struct cx18_open_id *id, int gop_end);
 void cx18_mute(struct cx18 *cx);
 void cx18_unmute(struct cx18 *cx);
 
-/* Utilities */
-
-/* Try to claim a stream for the filehandle. Return 0 on success,
-   -EBUSY if stream already claimed. Once a stream is claimed, it
-   remains claimed until the associated filehandle is closed. */
-int cx18_claim_stream(struct cx18_open_id *id, int type);
-
-/* Release a previously claimed stream. */
-void cx18_release_stream(struct cx18_stream *s);
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index 18c88d1..4f08a40 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -25,6 +25,7 @@
 #include "cx18-cards.h"
 #include "cx18-gpio.h"
 #include "cx18-av-core.h"
+#include "cx18-i2c.h"
 
 #include <media/ir-kbd-i2c.h>
 
diff --git a/drivers/media/video/cx18/cx18-queue.c b/drivers/media/video/cx18/cx18-queue.c
index 65af1bb..73f9550 100644
--- a/drivers/media/video/cx18/cx18-queue.c
+++ b/drivers/media/video/cx18/cx18-queue.c
@@ -26,17 +26,6 @@
 #include "cx18-queue.h"
 #include "cx18-scb.h"
 
-int cx18_buf_copy_from_user(struct cx18_stream *s, struct cx18_buffer *buf,
-		const char __user *src, int copybytes)
-{
-	if (s->buf_size - buf->bytesused < copybytes)
-		copybytes = s->buf_size - buf->bytesused;
-	if (copy_from_user(buf->buf + buf->bytesused, src, copybytes))
-		return -EFAULT;
-	buf->bytesused += copybytes;
-	return copybytes;
-}
-
 void cx18_buf_swap(struct cx18_buffer *buf)
 {
 	int i;
@@ -159,8 +148,9 @@ static void cx18_queue_move_buf(struct cx18_stream *s, struct cx18_queue *from,
    -ENOMEM is returned if the buffers could not be obtained, 0 if all
    buffers where obtained from the 'from' list and if non-zero then
    the number of stolen buffers is returned. */
-int cx18_queue_move(struct cx18_stream *s, struct cx18_queue *from,
-	struct cx18_queue *steal, struct cx18_queue *to, int needed_bytes)
+static int cx18_queue_move(struct cx18_stream *s, struct cx18_queue *from,
+			   struct cx18_queue *steal, struct cx18_queue *to,
+			   int needed_bytes)
 {
 	unsigned long flags;
 	int rc = 0;
diff --git a/drivers/media/video/cx18/cx18-queue.h b/drivers/media/video/cx18/cx18-queue.h
index f86c8a6..91423b9 100644
--- a/drivers/media/video/cx18/cx18-queue.h
+++ b/drivers/media/video/cx18/cx18-queue.h
@@ -39,8 +39,6 @@ static inline void cx18_buf_sync_for_device(struct cx18_stream *s,
 				s->buf_size, s->dma);
 }
 
-int cx18_buf_copy_from_user(struct cx18_stream *s, struct cx18_buffer *buf,
-	const char __user *src, int copybytes);
 void cx18_buf_swap(struct cx18_buffer *buf);
 
 /* cx18_queue utility functions */
@@ -48,8 +46,6 @@ void cx18_queue_init(struct cx18_queue *q);
 void cx18_enqueue(struct cx18_stream *s, struct cx18_buffer *buf,
 	struct cx18_queue *q);
 struct cx18_buffer *cx18_dequeue(struct cx18_stream *s, struct cx18_queue *q);
-int cx18_queue_move(struct cx18_stream *s, struct cx18_queue *from,
-       struct cx18_queue *steal, struct cx18_queue *to, int needed_bytes);
 struct cx18_buffer *cx18_queue_find_buf(struct cx18_stream *s, u32 id,
 	u32 bytesused);
 void cx18_flush_queues(struct cx18_stream *s);

