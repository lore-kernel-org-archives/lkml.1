Return-Path: <linux-kernel-owner+w=401wt.eu-S934323AbXHHNbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbXHHNbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763728AbXHHNbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:31:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46657 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764934AbXHHNbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:31:19 -0400
Date: Wed, 8 Aug 2007 14:38:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Scott_Kilau@digi.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jsm: Remove further unneeded crud
Message-ID: <20070808143849.7b970df1@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some remaining vestiges of the old hacks jsm had to work around
the old tty buffering. With the new tty buffering it simply doesn't
matter any more.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/drivers/serial/jsm/jsm_tty.c linux-2.6.23rc1-mm1/drivers/serial/jsm/jsm_tty.c
--- linux.vanilla-2.6.23rc1-mm1/drivers/serial/jsm/jsm_tty.c	2007-07-26 15:01:46.000000000 +0100
+++ linux-2.6.23rc1-mm1/drivers/serial/jsm/jsm_tty.c	2007-08-08 11:49:49.000000000 +0100
@@ -500,7 +500,6 @@
 {
 	struct jsm_board *bd;
 	struct tty_struct *tp;
-	struct tty_ldisc *ld;
 	u32 rmask;
 	u16 head;
 	u16 tail;
@@ -574,45 +573,13 @@
 
 	jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "start 2\n");
 
-	/*
-	 * If the rxbuf is empty and we are not throttled, put as much
-	 * as we can directly into the linux TTY buffer.
-	 *
-	 */
-	flip_len = TTY_FLIPBUF_SIZE;
-
-	len = min(data_len, flip_len);
-	len = min(len, (N_TTY_BUF_SIZE - 1) - tp->read_cnt);
-	ld = tty_ldisc_ref(tp);
-
-	/*
-	 * If we were unable to get a reference to the ld,
-	 * don't flush our buffer, and act like the ld doesn't
-	 * have any space to put the data right now.
-	 */
-	if (!ld) {
-		len = 0;
-	} else {
-		/*
-		 * If ld doesn't have a pointer to a receive_buf function,
-		 * flush the data, then act like the ld doesn't have any
-		 * space to put the data right now.
-		 */
-		if (!ld->receive_buf) {
-				ch->ch_r_head = ch->ch_r_tail;
-				len = 0;
-		}
-	}
-
-	if (len <= 0) {
+	if (data_len <= 0) {
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
 		jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "jsm_input 1\n");
-		if (ld)
-			tty_ldisc_deref(ld);
 		return;
 	}
 
-	len = tty_buffer_request_room(tp, len);
+	len = tty_buffer_request_room(tp, data_len);
 	n = len;
 
 	/*
@@ -647,7 +614,7 @@
 				else if (*(ch->ch_equeue +tail +i) & UART_LSR_FE)
 					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_FRAME);
 				else
-				tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
+					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
 			}
 		} else {
 			tty_insert_flip_string(tp, ch->ch_rqueue + tail, s) ;
@@ -666,9 +633,6 @@
 	/* Tell the tty layer its okay to "eat" the data now */
 	tty_flip_buffer_push(tp);
 
-	if (ld)
-		tty_ldisc_deref(ld);
-
 	jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev, "finish\n");
 }
 
