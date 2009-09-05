Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZIEVJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZIEVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZIEVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:09:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:33326 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZIEVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:09:46 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de, torvalds@linux-foundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] usb console: fix kernel crash on stty -a < /dev/ttyUSB0
Date: Sat,  5 Sep 2009 16:08:37 -0500
Message-Id: <1252184918-9577-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1252184918-9577-1-git-send-email-jason.wessel@windriver.com>
References: <1252184918-9577-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Sep 2009 21:09:06.0352 (UTC) FILETIME=[1A72BB00:01CA2E6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Boot with the kernel argument console=ttyUSB0,9600
* Run: stty -a < /dev/ttyUSB0
* Immediately you get an oops warning, which later leads to a hard
  kernel crash

The commit 335f8514f200e63d689113d29cb7253a5c282967 created the
original regression and commit
6e4061210150d1d6d388c5fba05f6b49a306a27e only fixed part of the
problem.

Only protect the serial->type->open() from getting executed when the
device is used as a console.

The wider scope of the console protection added in
6e4061210150d1d6d388c5fba05f6b49a306a27e causes the logic in
serial_open() to fall through and zero out the port->port.count with
the stty sys call.  Once the port.count is zeroed the HW will get
closed while other drivers still have call backs to a non-initialized
device which crashes the kernel.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>

---
 drivers/usb/serial/usb-serial.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 99188c9..7ca4ced 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -223,8 +223,7 @@ static int serial_open (struct tty_struct *tty, struct file *filp)
 	tty->driver_data = port;
 	tty_port_tty_set(&port->port, tty);
 
-	/* If the console is attached, the device is already open */
-	if (port->port.count == 1 && !port->console) {
+	if (port->port.count == 1) {
 		first = 1;
 		/* lock this module before we call it
 		 * this may fail, which means we must bail out,
@@ -242,11 +241,15 @@ static int serial_open (struct tty_struct *tty, struct file *filp)
 		if (retval)
 			goto bailout_module_put;
 
-		/* only call the device specific open if this
-		 * is the first time the port is opened */
-		retval = serial->type->open(tty, port, filp);
-		if (retval)
-			goto bailout_interface_put;
+		/* only call the device specific open if this is the
+		 * first time the port is opened and it is not a
+		 * console port where the HW has already been
+		 * initialized */
+		if (!port->console) {
+			retval = serial->type->open(tty, port, filp);
+			if (retval)
+				goto bailout_interface_put;
+		}
 		mutex_unlock(&serial->disc_mutex);
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 	}
-- 
1.6.3.1.9.g95405b

