Return-Path: <linux-kernel-owner+w=401wt.eu-S1751226AbZIEVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbZIEVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZIEVJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:09:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:33327 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZIEVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:09:46 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de, torvalds@linux-foundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/2] usb console: pass initial console baud on to first tty open
Date: Sat,  5 Sep 2009 16:08:38 -0500
Message-Id: <1252184918-9577-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1252184918-9577-2-git-send-email-jason.wessel@windriver.com>
References: <1252184918-9577-1-git-send-email-jason.wessel@windriver.com>
 <1252184918-9577-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Sep 2009 21:09:07.0399 (UTC) FILETIME=[1B127D70:01CA2E6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first open of the usb serial HW has the termios initialized to the
default of 9600 baud, and this will override what ever was setup via
the original console initialization.

The solution is to save the console baud rate and re-use it later on
the first open, so as to allow the use of baud rates other than 9600
for the usb serial console.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>

---
 drivers/usb/serial/console.c    |    1 +
 drivers/usb/serial/usb-serial.c |    4 +++-
 include/linux/usb/serial.h      |    1 +
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 0e4f2e4..35ba616 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -175,6 +175,7 @@ static int usb_console_setup(struct console *co, char *options)
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
 	port->console = 1;
+	port->console_init_baud = baud;
 	retval = 0;
 
 out:
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 7ca4ced..7ec5e0c 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -245,7 +245,9 @@ static int serial_open (struct tty_struct *tty, struct file *filp)
 		 * first time the port is opened and it is not a
 		 * console port where the HW has already been
 		 * initialized */
-		if (!port->console) {
+		if (port->console) {
+			tty_encode_baud_rate(tty, port->console_init_baud, port->console_init_baud);
+		} else {
 			retval = serial->type->open(tty, port, filp);
 			if (retval)
 				goto bailout_interface_put;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 0ec50ba..d5e586f 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -107,6 +107,7 @@ struct usb_serial_port {
 	char			throttled;
 	char			throttle_req;
 	char			console;
+	int			console_init_baud;
 	unsigned long		sysrq; /* sysrq timeout */
 	struct device		dev;
 	enum port_dev_state	dev_state;
-- 
1.6.3.1.9.g95405b

