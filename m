Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZKRBEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZKRBEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZKRBEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:04:37 -0500
Received: from kroah.org ([198.145.64.141]:38463 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbZKRBEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:04:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] tty: cp210x: Fix carrier handling
Date: Tue, 17 Nov 2009 17:01:30 -0800
Message-Id: <1258506090-16802-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091118010047.GA16719@kroah.com>
References: <20091118010047.GA16719@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Original discussion:
http://thread.gmane.org/gmane.linux.usb.general/23217/focus=23248
or
http://marc.info/?l=linux-usb&m=125553790714133&w=2

9a68e39d4a701fb3be03cae9b462408664ebd205 broke carrier handling so that a
cp210x setup which needed the carrier lines set up (non CLOCAL) which did
not make a call which set the termios bits left the lines down even if
CLOCAL was not asserted.

Fix this not by reverting but by adding the proper dtr_rts and
carrier_raised methods. This both sets the modem lines properly and also
implements the correct blocking semantics for the port as required by
POSIX.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Karl Hiramoto <karl@hiramoto.org>
Tested-by:  Karl Hiramoto <karl@hiramoto.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/cp210x.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 698252a..bd254ec 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -50,6 +50,8 @@ static int cp210x_tiocmset_port(struct usb_serial_port *port, struct file *,
 static void cp210x_break_ctl(struct tty_struct *, int);
 static int cp210x_startup(struct usb_serial *);
 static void cp210x_disconnect(struct usb_serial *);
+static void cp210x_dtr_rts(struct usb_serial_port *p, int on);
+static int cp210x_carrier_raised(struct usb_serial_port *p);
 
 static int debug;
 
@@ -143,6 +145,8 @@ static struct usb_serial_driver cp210x_device = {
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_startup,
 	.disconnect		= cp210x_disconnect,
+	.dtr_rts		= cp210x_dtr_rts,
+	.carrier_raised		= cp210x_carrier_raised
 };
 
 /* Config request types */
@@ -746,6 +750,14 @@ static int cp210x_tiocmset_port(struct usb_serial_port *port, struct file *file,
 	return cp210x_set_config(port, CP210X_SET_MHS, &control, 2);
 }
 
+static void cp210x_dtr_rts(struct usb_serial_port *p, int on)
+{
+	if (on)
+		cp210x_tiocmset_port(p, NULL,  TIOCM_DTR|TIOCM_RTS, 0);
+	else
+		cp210x_tiocmset_port(p, NULL,  0, TIOCM_DTR|TIOCM_RTS);
+}
+
 static int cp210x_tiocmget (struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -768,6 +780,15 @@ static int cp210x_tiocmget (struct tty_struct *tty, struct file *file)
 	return result;
 }
 
+static int cp210x_carrier_raised(struct usb_serial_port *p)
+{
+	unsigned int control;
+	cp210x_get_config(p, CP210X_GET_MDMSTS, &control, 1);
+	if (control & CONTROL_DCD)
+		return 1;
+	return 0;
+}
+
 static void cp210x_break_ctl (struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
-- 
1.6.4.2

