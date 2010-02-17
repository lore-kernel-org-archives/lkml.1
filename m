Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab0BQNbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:31:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38593 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933561Ab0BQNbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:31:11 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/5] tty: Fix up char drivers request_room usage
To: greg@kroah.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Date: Wed, 17 Feb 2010 13:07:13 +0000
Message-ID: <20100217130711.16008.88930.stgit@localhost.localdomain>
In-Reply-To: <20100217130604.16008.86393.stgit@localhost.localdomain>
References: <20100217130604.16008.86393.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't change them all but quite a few misuse it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/nozomi.c        |    2 --
 drivers/char/serial167.c     |    3 +--
 drivers/char/specialix.c     |    2 --
 drivers/serial/icom.c        |    1 -
 drivers/serial/ioc3_serial.c |    3 +--
 5 files changed, 2 insertions(+), 9 deletions(-)


diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 584910f..a3f32a1 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -853,8 +853,6 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 		goto put;
 	}
 
-	tty_buffer_request_room(tty, size);
-
 	while (size > 0) {
 		read_mem32((u32 *) buf, addr + offset, RECEIVE_BUF_MAX);
 
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index aee3c0d..1ec3d5c 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -658,8 +658,7 @@ static irqreturn_t cd2401_rx_interrupt(int irq, void *dev_id)
 			info->mon.char_max = char_count;
 		info->mon.char_last = char_count;
 #endif
-		len = tty_buffer_request_room(tty, char_count);
-		while (len--) {
+		while (char_count--) {
 			data = base_addr[CyRDR];
 			tty_insert_flip_char(tty, data, TTY_NORMAL);
 #ifdef CYCLOM_16Y_HACK
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 268e17f..07ac14d 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -646,8 +646,6 @@ static void sx_receive(struct specialix_board *bp)
 	dprintk(SX_DEBUG_RX, "port: %p: count: %d\n", port, count);
 	port->hits[count > 8 ? 9 : count]++;
 
-	tty_buffer_request_room(tty, count);
-
 	while (count--)
 		tty_insert_flip_char(tty, sx_in(bp, CD186x_RDR), TTY_NORMAL);
 	tty_flip_buffer_push(tty);
diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 6e715b7..53a4682 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -751,7 +751,6 @@ static void recv_interrupt(u16 port_int_reg, struct icom_port *icom_port)
 		trace(icom_port, "FID_STATUS", status);
 		count = cpu_to_le16(icom_port->statStg->rcv[rcv_buff].leLength);
 
-                count = tty_buffer_request_room(tty, count);
 		trace(icom_port, "RCV_COUNT", count);
 
 		trace(icom_port, "REAL_COUNT", count);
diff --git a/drivers/serial/ioc3_serial.c b/drivers/serial/ioc3_serial.c
index 85dc041..23ba6b4 100644
--- a/drivers/serial/ioc3_serial.c
+++ b/drivers/serial/ioc3_serial.c
@@ -1411,8 +1411,7 @@ static int receive_chars(struct uart_port *the_port)
 	read_count = do_read(the_port, ch, MAX_CHARS);
 	if (read_count > 0) {
 		flip = 1;
-		read_room = tty_buffer_request_room(tty, read_count);
-		tty_insert_flip_string(tty, ch, read_room);
+		read_room = tty_insert_flip_string(tty, ch, read_count);
 		the_port->icount.rx += read_count;
 	}
 	spin_unlock_irqrestore(&the_port->lock, pflags);

