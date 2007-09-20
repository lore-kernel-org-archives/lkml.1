Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbXITOKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbXITOKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbXITOKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:10:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54251 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756894AbXITOKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:10:08 -0400
Date: Thu, 20 Sep 2007 15:17:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Bring the old cris driver back somewhere into the
 realm of new tty buffering
Message-ID: <20070920151720.2de8ab12@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23rc6-mm1/drivers/serial/crisv10.c linux-2.6.23rc6-mm1/drivers/serial/crisv10.c
--- linux.vanilla-2.6.23rc6-mm1/drivers/serial/crisv10.c	2007-09-18 15:32:57.000000000 +0100
+++ linux-2.6.23rc6-mm1/drivers/serial/crisv10.c	2007-09-18 16:28:13.000000000 +0100
@@ -514,6 +514,8 @@
  * TTY_THRESHOLD_THROTTLE/UNTHROTTLE=128
  * BUF_SIZE can't be > 128
  */
+#define CRIS_BUF_SIZE	512
+
 /* Currently 16 descriptors x 128 bytes = 2048 bytes */
 #define SERIAL_DESCR_BUF_SIZE 256
 
@@ -2497,55 +2499,18 @@
 		return;
 	}
 
-	length = tty->flip.count;
-	/* Don't flip more than the ldisc has room for.
-	 * The return value from ldisc.receive_room(tty) - might not be up to
-	 * date, the previous flip of up to TTY_FLIPBUF_SIZE might be on the
-	 * processed and not accounted for yet.
-	 * Since we use DMA, 1 SERIAL_DESCR_BUF_SIZE could be on the way.
-	 * Lets buffer data here and let flow control take care of it.
-	 * Since we normally flip large chunks, the ldisc don't react
-	 * with throttle until too late if we flip to much.
-	 */
-	max_flip_size = tty->ldisc.receive_room(tty);
-	if (max_flip_size < 0)
-		max_flip_size = 0;
-	if (max_flip_size <= (TTY_FLIPBUF_SIZE +         /* Maybe not accounted for */
-			      length + info->recv_cnt +  /* We have this queued */
-			      2*SERIAL_DESCR_BUF_SIZE +    /* This could be on the way */
-			      TTY_THRESHOLD_THROTTLE)) { /* Some slack */
-		/* check TTY_THROTTLED first so it indicates our state */
-		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags)) {
-			DFLOW(DEBUG_LOG(info->line,"flush_to_flip throttles room %lu\n", max_flip_size));
-			rs_throttle(tty);
-		}
-#if 0
-		else if (max_flip_size <= (TTY_FLIPBUF_SIZE +         /* Maybe not accounted for */
-					   length + info->recv_cnt +  /* We have this queued */
-					   SERIAL_DESCR_BUF_SIZE +    /* This could be on the way */
-					   TTY_THRESHOLD_THROTTLE)) { /* Some slack */
-			DFLOW(DEBUG_LOG(info->line,"flush_to_flip throttles again! %lu\n", max_flip_size));
-			rs_throttle(tty);
-		}
-#endif
-	}
-
-	if (max_flip_size > TTY_FLIPBUF_SIZE)
-		max_flip_size = TTY_FLIPBUF_SIZE;
-
-	while ((buffer = info->first_recv_buffer) && length < max_flip_size) {
+	while ((buffer = info->first_recv_buffer) != NULL) {
 		unsigned int count = buffer->length;
+			
+		count = tty_buffer_request_room(tty, count);
+		if (count == 0) /* Throttle ?? */
+			break;
 
-		if (length + count > max_flip_size)
-			count = max_flip_size - length;
-
-		memcpy(tty->flip.char_buf_ptr + length, buffer->buffer, count);
-		memset(tty->flip.flag_buf_ptr + length, TTY_NORMAL, count);
-		tty->flip.flag_buf_ptr[length] = buffer->error;
+		if (count > 1)
+			tty_insert_flip_strings(tty, buffer->buffer, count - 1);
+		tty_insert_flip_char(tty, buffer->buffer[count-1], buffer->error);
 
-		length += count;
 		info->recv_cnt -= count;
-		DFLIP(DEBUG_LOG(info->line,"flip: %i\n", length));
 
 		if (count == buffer->length) {
 			info->first_recv_buffer = buffer->next;
@@ -2560,14 +2525,6 @@
 	if (!info->first_recv_buffer)
 		info->last_recv_buffer = NULL;
 
-	tty->flip.count = length;
-	DFLIP(if (tty->ldisc.chars_in_buffer(tty) > 3500) {
-		DEBUG_LOG(info->line, "ldisc %lu\n",
-			  tty->ldisc.chars_in_buffer(tty));
-		DEBUG_LOG(info->line, "flip.count %lu\n",
-			  tty->flip.count);
-	      }
-	      );
 	restore_flags(flags);
 
 	DFLIP(
@@ -2722,17 +2679,17 @@
 		printk("!NO TTY!\n");
 		return info;
 	}
-	if (tty->flip.count >= TTY_FLIPBUF_SIZE - TTY_THRESHOLD_THROTTLE) {
+	if (tty->flip.count >= CRIS_BUF_SIZE - TTY_THRESHOLD_THROTTLE) {
 		/* check TTY_THROTTLED first so it indicates our state */
 		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags)) {
 			DFLOW(DEBUG_LOG(info->line, "rs_throttle flip.count: %i\n", tty->flip.count));
 			rs_throttle(tty);
 		}
 	}
-	if (tty->flip.count >= TTY_FLIPBUF_SIZE) {
+	if (tty->flip.count >= CRIS_BUF_SIZE) {
 		DEBUG_LOG(info->line, "force FLIP! %i\n", tty->flip.count);
 		tty->flip.work.func((void *) tty);
-		if (tty->flip.count >= TTY_FLIPBUF_SIZE) {
+		if (tty->flip.count >= CRIS_BUF_SIZE) {
 			DEBUG_LOG(info->line, "FLIP FULL! %i\n", tty->flip.count);
 			return info;		/* if TTY_DONT_FLIP is set */
 		}
