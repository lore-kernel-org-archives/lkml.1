Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZGVJls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZGVJls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZGVJlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:41:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47733 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbZGVJlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:41:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: Fix a USB serial crash/scribble
To: daniel@caiaq.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       stern@rowland.harvard.edu
Date: Wed, 22 Jul 2009 10:39:51 +0100
Message-ID: <20090722093735.27118.36158.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See if this one looks sensible. It does leave a tiny race window but that
semes wiser than hacking up the tty kref_put path in the middle of an -rc
series.

Thanks to Daniel and Alan Stern for chasing this down and getting traces. Also
to Daniel for being persistent when I took it as a random odd "only seen by one
user" error which it wasn't.

---

From: Alan Cox <alan@linux.intel.com>

The port lock is used to protect the port state. However the port structure
is freed on a hangup, then the lock taken on a close. The right fix is to
drop the port on tty->shutdown() but we can't yet do that due to sleep v
non-sleeping rules. Instead do the next best thing and fix it up when we are
not in -rc season.

Reported-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/usb-serial.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index bd7581b..228d77c 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -340,6 +340,22 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 
 	dbg("%s - port %d", __func__, port->number);
 
+	/* FIXME:
+	   This leaves a very narrow race. Really we should do the
+	   serial_do_free() on tty->shutdown(), but tty->shutdown can
+	   be called from IRQ context and serial_do_free can sleep.
+
+	   The right fix is probably to make the tty free (which is rare)
+	   and thus tty->shutdown() occur via a work queue and simplify all
+	   the drivers that use it.
+	*/
+	if (tty_hung_up_p(filp)) {
+		/* serial_hangup already called serial_down at this point.
+		   Another user may have already reopened the port but 
+		   serial_do_free is refcounted */
+		serial_do_free(port);
+		return;
+	}
 
 	if (tty_port_close_start(&port->port, tty, filp) == 0)
 		return;
@@ -355,7 +371,8 @@ static void serial_hangup(struct tty_struct *tty)
 	struct usb_serial_port *port = tty->driver_data;
 	serial_do_down(port);
 	tty_port_hangup(&port->port);
-	serial_do_free(port);
+	/* We must not free port yet - the USB serial layer depends on it's
+	   continued existence */
 }
 
 static int serial_write(struct tty_struct *tty, const unsigned char *buf,

