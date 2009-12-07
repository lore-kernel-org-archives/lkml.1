Return-Path: <linux-kernel-owner+w=401wt.eu-S934481AbZLGA3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbZLGA3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbZLGANE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:04 -0500
Received: from kroah.org ([198.145.64.141]:34349 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758410AbZLGAM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:46 2009
Message-Id: <20091207000646.768823232@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [040/119] tty: cp210x: Fix carrier handling
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=tty-cp210x-fix-carrier-handling.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit d94c7bd4c1361cab58a21d530078c5673863dcc2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -51,6 +51,8 @@ static int cp210x_tiocmset_port(struct u
 static void cp210x_break_ctl(struct tty_struct *, int);
 static int cp210x_startup(struct usb_serial *);
 static void cp210x_disconnect(struct usb_serial *);
+static void cp210x_dtr_rts(struct usb_serial_port *p, int on);
+static int cp210x_carrier_raised(struct usb_serial_port *p);
 
 static int debug;
 
@@ -144,6 +146,8 @@ static struct usb_serial_driver cp210x_d
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_startup,
 	.disconnect		= cp210x_disconnect,
+	.dtr_rts		= cp210x_dtr_rts,
+	.carrier_raised		= cp210x_carrier_raised
 };
 
 /* Config request types */
@@ -748,6 +752,14 @@ static int cp210x_tiocmset_port(struct u
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
@@ -770,6 +782,15 @@ static int cp210x_tiocmget (struct tty_s
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


