Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZISVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZISVwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZISVwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:52:32 -0400
Received: from kroah.org ([198.145.64.141]:50973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZISVkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:40:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kees Schoenmakers <k.schoenmakers@sigmae.nl>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/79] tty: usb_serial_mos7720: Fix get_lsr_info
Date: Sat, 19 Sep 2009 14:36:29 -0700
Message-Id: <1253396244-7885-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Schoenmakers <k.schoenmakers@sigmae.nl>

I made a correction for get_lsr_info, now it returns some meaningful
information. I tested it with two simultaneous simplex modem channels.

it is attached

Signed-off-by: Kees Schoenmakers <k.schoenmakers@sigmae.nl>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/mos7720.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 759cdd5..4342a8a 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -378,10 +378,14 @@ static int mos7720_open(struct tty_struct *tty,
 	 /* Initialize MCS7720 -- Write Init values to corresponding Registers
 	  *
 	  * Register Index
+	  * 0 : THR/RHR
 	  * 1 : IER
 	  * 2 : FCR
 	  * 3 : LCR
 	  * 4 : MCR
+	  * 5 : LSR
+	  * 6 : MSR
+	  * 7 : SPR
 	  *
 	  * 0x08 : SP1/2 Control Reg
 	  */
@@ -1250,15 +1254,22 @@ static void mos7720_set_termios(struct tty_struct *tty,
 static int get_lsr_info(struct tty_struct *tty,
 		struct moschip_port *mos7720_port, unsigned int __user *value)
 {
-	int count;
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned int result = 0;
+	unsigned char data = 0;
+	int port_number = port->number - port->serial->minor;
+	int count;
 
 	count = mos7720_chars_in_buffer(tty);
 	if (count == 0) {
-		dbg("%s -- Empty", __func__);
-		result = TIOCSER_TEMT;
+		send_mos_cmd(port->serial, MOS_READ, port_number,
+							UART_LSR, &data);
+		if ((data & (UART_LSR_TEMT | UART_LSR_THRE))
+					== (UART_LSR_TEMT | UART_LSR_THRE)) {
+			dbg("%s -- Empty", __func__);
+			result = TIOCSER_TEMT;
+		}
 	}
-
 	if (copy_to_user(value, &result, sizeof(int)))
 		return -EFAULT;
 	return 0;
-- 
1.6.4.2

