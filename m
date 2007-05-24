Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbXEXM2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbXEXM2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXEXM2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:28:25 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:34386 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754084AbXEXM2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:28:25 -0400
Message-id: <23207103161692929650@wsc.cz>
Subject: [PATCH 1/1] Char: n_hdlc, allow RESTARTSYS retval of tty write
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Paul Fulghum <paulkf@microgate.com>
Date: Thu, 24 May 2007 14:28:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

n_hdlc, allow RESTARTSYS retval of tty write

Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 119ce83eb190c70d50ed7558c7b67b400ea00ec7
tree d334650d032ded74085a6951c0a1d3e3268fb7db
parent 221eebee5eedfa7c2463dcbfb545b92595512310
author Jiri Slaby <jirislaby@gmail.com> Wed, 23 May 2007 17:55:46 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 23 May 2007 17:55:46 +0200

 drivers/char/n_hdlc.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index 37f7d34..e8332f3 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -400,7 +400,12 @@ static void n_hdlc_send_frames(struct n_hdlc *n_hdlc, struct tty_struct *tty)
 		/* Send the next block of data to device */
 		tty->flags |= (1 << TTY_DO_WRITE_WAKEUP);
 		actual = tty->driver->write(tty, tbuf->buf, tbuf->count);
-		    
+
+		/* rollback was possible and has been done */
+		if (actual == -ERESTARTSYS) {
+			n_hdlc->tbuf = tbuf;
+			break;
+		}
 		/* if transmit error, throw frame away by */
 		/* pretending it was accepted by driver */
 		if (actual < 0)
