Return-Path: <linux-kernel-owner+w=401wt.eu-S1766592AbXEDTmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766592AbXEDTmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766588AbXEDTmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:42:11 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:44001
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766592AbXEDTmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:42:10 -0400
Subject: [PATCH] tty_set_ldisc receive_room fix
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 04 May 2007 14:42:02 -0500
Message-Id: <1178307722.3743.8.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix tty_set_ldisc in tty_io.c so that tty->receive_room is
only cleared if actually changing line disciplines.

Without this fix a problem occurs when requesting the line
discipline to change to the same line discipline. In this case
tty->receive_room is cleared but ldisc->open() is not called
to set tty->receive_room back to a sane value. The result
is that tty->receive_room is stuck at 0 preventing the tty
flip buffer from passing receive data to the line discipline.

For example: a switch from N_TTY to N_TTY followed by
a select() call for read input results in data never being
received because tty->receive_room is stuck at zero.

A switch from N_TTY to N_TTY followed by
a read() call works because the read() call itself
sets tty->receive_room correctly (but select does not).

Previously (< 2.6.18) this was not a problem because
the tty flip buffer pushed data to the line discipline
without regard for tty->receive room.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>


--- a/drivers/char/tty_io.c	2007-04-25 22:08:32.000000000 -0500
+++ b/drivers/char/tty_io.c	2007-05-04 14:25:08.000000000 -0500
@@ -936,13 +936,6 @@ restart:
 		return -EINVAL;
 
 	/*
-	 *	No more input please, we are switching. The new ldisc
-	 *	will update this value in the ldisc open function
-	 */
-
-	tty->receive_room = 0;
-
-	/*
 	 *	Problem: What do we do if this blocks ?
 	 */
 
@@ -953,6 +946,13 @@ restart:
 		return 0;
 	}
 
+	/*
+	 *	No more input please, we are switching. The new ldisc
+	 *	will update this value in the ldisc open function
+	 */
+
+	tty->receive_room = 0;
+
 	o_ldisc = tty->ldisc;
 	o_tty = tty->link;
 


