Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZGTRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZGTRwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZGTRwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:52:18 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50215 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbZGTRwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:52:17 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@linux.intel.com>,
       linux-usb@vger.kernel.org
Subject: [PATCH] [usb-serial] fix Ooops on uplug
Date: Mon, 20 Jul 2009 19:51:53 +0200
Message-Id: <1248112313-7842-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090720155502.50b84ae9@lxorguk.ukuu.org.uk>
References: <20090720155502.50b84ae9@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an USB serial adapter is disconnected and <Enter> is pressed on a
connection still open on it (cu, minicom, ...), the kernel crashes.

The reason is that the serial port's resources are freed upon disconnect
(in serial_hangup()) but the tty device layer is not made aware of that.
Hence, the close callback will later access the resources again.

Fix that by postponing the resources freeing to the close callback and
remove it from the hangup callback.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/serial/usb-serial.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index bd7581b..77cb3cd 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -355,7 +355,6 @@ static void serial_hangup(struct tty_struct *tty)
 	struct usb_serial_port *port = tty->driver_data;
 	serial_do_down(port);
 	tty_port_hangup(&port->port);
-	serial_do_free(port);
 }
 
 static int serial_write(struct tty_struct *tty, const unsigned char *buf,
-- 
1.6.3.1

