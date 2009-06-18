Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbZFRCU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbZFRCU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbZFRCUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:20:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:55092 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbZFRCUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:20:23 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/3] usb-serial: regression fix to move sysrq from hot path
Date: Wed, 17 Jun 2009 21:20:08 -0500
Message-Id: <1245291609-14871-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1245291609-14871-2-git-send-email-jason.wessel@windriver.com>
References: <1245291609-14871-1-git-send-email-jason.wessel@windriver.com>
 <1245291609-14871-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Jun 2009 02:20:16.0015 (UTC) FILETIME=[516339F0:01C9EFBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A performance regression was introduced by commit:
98fcb5f78165b8a3d93870ad7afd4d9ebbb8b43a

The sysrq handling should only get executed if the attached usb serial
device is acting as a serial system console.  A serial system console
has a very low input throughput vs a 3g usb modem which pushes bytes
through the same interface at a high rate.

Entire strings of output can be processed via the tty input when the
device is not a console.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/generic.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 932d624..82b8883 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -425,11 +425,19 @@ static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
 		goto done;
 
 	/* Push data to tty */
-	for (i = 0; i < urb->actual_length; i++, ch++) {
-		if (!usb_serial_handle_sysrq_char(port, *ch))
-			tty_insert_flip_char(tty, *ch, TTY_NORMAL);
+	if (port->console) {
+		for (i = 0; i < urb->actual_length; i++, ch++) {
+			if (!usb_serial_handle_sysrq_char(port, *ch))
+				tty_insert_flip_char(tty, *ch, TTY_NORMAL);
+		}
+		tty_flip_buffer_push(tty);
+	} else if (urb->actual_length) {
+		i = tty_buffer_request_room(tty, urb->actual_length);
+		if (i) {
+			tty_insert_flip_string(tty, urb->transfer_buffer, i);
+			tty_flip_buffer_push(tty);
+		}
 	}
-	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 done:
 	usb_serial_generic_resubmit_read_urb(port, GFP_ATOMIC);
-- 
1.6.3.1.9.g95405b

