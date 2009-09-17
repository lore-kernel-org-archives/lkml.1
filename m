Return-Path: <linux-kernel-owner+w=401wt.eu-S933573AbZIQDIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573AbZIQDIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbZIQDIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:08:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:54808 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbZIQDIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:08:18 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/3] usb console,usb-serial: pass initial console baud on to first tty open
Date: Wed, 16 Sep 2009 22:08:07 -0500
Message-Id: <1253156887-31597-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1253156887-31597-3-git-send-email-jason.wessel@windriver.com>
References: <1253156887-31597-1-git-send-email-jason.wessel@windriver.com>
 <1253156887-31597-2-git-send-email-jason.wessel@windriver.com>
 <1253156887-31597-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 17 Sep 2009 03:08:17.0869 (UTC) FILETIME=[1AB27FD0:01CA3744]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first open of the usb serial HW has the termios initialized to the
default of 9600 baud, and this will override what ever was setup via
the original console initialization.

The solution is to save the console baud rate and re-use it later on
the first tty open, so as to allow the use of baud rates other than
the default 9600 for the usb serial console.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>

---
 drivers/usb/serial/console.c    |    1 +
 drivers/usb/serial/usb-serial.c |    8 ++++++--
 include/linux/usb/serial.h      |    1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 166ba4e..4fd5b52 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -175,6 +175,7 @@ static int usb_console_setup(struct console *co, char *options)
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
 	port->console = 1;
+	port->console_init_baud = baud;
 	retval = 0;
 	mutex_unlock(&serial->disc_mutex);
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 3d35ed2..f931738 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -270,10 +270,14 @@ static int serial_open(struct tty_struct *tty, struct file *filp)
 		if (serial->disconnected) {
 			retval = -ENODEV;
 		} else {
-			if (port->console)
+			if (port->console) {
+				tty_encode_baud_rate(tty,
+				     port->console_init_baud,
+				     port->console_init_baud);
 				retval = 0;
-			else
+			} else {
 				retval = port->serial->type->open(tty, port);
+			}
 		}
 		mutex_unlock(&serial->disc_mutex);
 		mutex_unlock(&port->mutex);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index c17eb64..a7c8725 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -109,6 +109,7 @@ struct usb_serial_port {
 	char			throttled;
 	char			throttle_req;
 	char			console;
+	int			console_init_baud;
 	unsigned long		sysrq; /* sysrq timeout */
 	struct device		dev;
 	enum port_dev_state	dev_state;
-- 
1.6.4.rc1

