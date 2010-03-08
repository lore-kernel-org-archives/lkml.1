Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0CHPWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:22:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:47477 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0CHPWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:22:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] usb-serial: Fix usb serial console open/close regression
Date: Mon,  8 Mar 2010 09:21:38 -0600
Message-Id: <1268061698-9846-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 08 Mar 2010 15:21:44.0316 (UTC) FILETIME=[0FA26BC0:01CABED3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e1108a63e10d344284011cccc06328b2cd3e5da3 ("usb_serial: Use the
shutdown() operation") breaks the ability to use a usb console
starting in 2.6.32.  This was observed when using
console=ttyUSB0,115200 as a boot argument with an FTDI device.  The
error is:

ftdi_sio ttyUSB0: ftdi_submit_read_urb - failed submitting read urb, error -22

The handling of the ASYNCB_INITIALIZED changed in 2.6.32 such that in
tty_port_shutdown() it always clears the flag if it is set.  As a work
around the usb console must reset this flag, in order for the hw to
stay open.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/usb/serial/usb-serial.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -287,10 +287,13 @@ static void serial_down(struct tty_port 
 	struct usb_serial_driver *drv = port->serial->type;
 	/*
 	 * The console is magical.  Do not hang up the console hardware
-	 * or there will be tears.
+	 * or there will be tears.  If this is a console the initialized
+	 * flag is reset.
 	 */
-	if (port->console)
+	if (port->console) {
+		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 		return;
+	}
 	if (drv->close)
 		drv->close(port);
 }
