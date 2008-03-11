Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYCKVIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYCKVIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYCKVIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:08:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:23422 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYCKVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mxLqPEMtdaUhJGeKkYVSIqqnqYCW23xIEsIJaYPkJg0unjNzo8wDxg5G9BoRC3dCSDd/Fq3Dw2S8fS8JcAn6wfjIFYto70y+vIn9S2ymSZurwYZ3bwt71Y0mWvq8eOIsycJkP6caYYnSWVEqKhPVsrDiNUkq0xFeenPN/qrmhbI=
Subject: [RFC][PATCH] n_tty : Loss of sync following a buffer overflow
From: Rupesh Sugathan <rupesh.sugathan@gmail.com>
Reply-To: rupesh.sugathan@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 11 Mar 2008 13:42:19 -0700
Message-Id: <1205268139.29731.0.camel@estonia>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Sugathan <Rupesh.Sugathan@gmail.com>

There seems to be a synchronization issue with the n_tty.c driver when
working in canonical mode.
The n_tty rightly discards data received following a buffer overflow and
hence the tty->read_cnt is not updated. However, the newline characters
received following a buffer overflow seems to increment the tty-
>canon_data index. This may result in a loss of sync between the tty-
>canon_data & tty->read_cnt while processing read in the read_chan().
This loss of sync might be irrecoverable even when the data is later
received at a slower rate.

----
I am not very sure if there is any deliberate rationale to process the
newlines even when the buffer has overflown. Please comment and review
the patch

diff -pu a/drivers/char/n_tty.c b/drivers/char/n_tty.c

--- a/drivers/char/n_tty.c	2008-03-10 17:11:54.000000000 -0700
+++ b/drivers/char/n_tty.c	2008-03-10 16:49:23.000000000 -0700
@@ -838,15 +838,17 @@ send_signal:
 				put_tty_queue(c, tty);
 
 		handle_newline:
-			spin_lock_irqsave(&tty->read_lock, flags);
-			set_bit(tty->read_head, tty->read_flags);
-			put_tty_queue_nolock(c, tty);
-			tty->canon_head = tty->read_head;
-			tty->canon_data++;
-			spin_unlock_irqrestore(&tty->read_lock, flags);
-			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
-			if (waitqueue_active(&tty->read_wait))
-				wake_up_interruptible(&tty->read_wait);
+			if (tty->read_cnt < N_TTY_BUF_SIZE) {
+				spin_lock_irqsave(&tty->read_lock, flags);
+				set_bit(tty->read_head, tty->read_flags);
+				put_tty_queue_nolock(c, tty);
+				tty->canon_head = tty->read_head;
+				tty->canon_data++;
+				spin_unlock_irqrestore(&tty->read_lock, flags);
+				kill_fasync(&tty->fasync, SIGIO, POLL_IN);
+				if (waitqueue_active(&tty->read_wait))
+					wake_up_interruptible(&tty->read_wait);
+			}
 			return;
 		}
 	}

Signed-off-by: Rupesh Sugathan <Rupesh.Sugathan@gmail.com>



