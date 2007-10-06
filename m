Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbXJFIHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbXJFIHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 04:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbXJFIHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 04:07:25 -0400
Received: from mpd.laptop.org ([18.85.46.35]:36353 "EHLO bender.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752288AbXJFIHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 04:07:23 -0400
X-Greylist: delayed 3593 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2007 04:07:22 EDT
From: Bernardo Innocenti <bernie@codewiz.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Richard Smith <richard@laptop.org>, Andres Salomon <dilinger@laptop.org>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Francesco Sacchi <batt@develer.com>,
       Bernardo Innocenti <bernie@codewiz.org>
Subject: [PATCH] ftdi_sio: fix FT232RL support for TIOCMGET
Date: Sat,  6 Oct 2007 03:07:25 -0400
Message-Id: <1191654445-17135-1-git-send-email-bernie@codewiz.org>
X-Mailer: git-send-email 1.5.3.4.206.g58ba4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francesco Sacchi <batt@develer.com>

Reading serial port status lines was broken on the FT232RL since when it
has been detected as a separate chip (2.6.22+).  Previously, it would work
because it was just handled as an FT232BM.

Additionally, we were also forgetting to remove the dev_attr_latency_timer
sysfs file in the FT232RL case.

Note by Bernardo Innocenti: the ftdi_sio maintainer appears to have stepped
down, so I'm sending this to Greg Kroah-Hartman as the generic USB serial
maintainer.  Please, let me know if this is not appropriate.

Signed-Off-By: Francesco Sacchi <batt@develer.com>
Signed-Off-By: Bernardo Innocenti <bernie@codewiz.org>

---
 drivers/usb/serial/ftdi_sio.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 2d04585..940b0c4 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -892,7 +892,7 @@ static __u32 get_ftdi_divisor(struct usb_serial_port * port)
 		break;
 	case FT232BM: /* FT232BM chip */
 	case FT2232C: /* FT2232C chip */
-	case FT232RL:
+	case FT232RL: /* FT232RL chip */
 		if (baud <= 3000000) {
 			div_value = ftdi_232bm_baud_to_divisor(baud);
 		} else {
@@ -1169,7 +1169,9 @@ static void remove_sysfs_attrs(struct usb_serial_port *port)
 	/* XXX see create_sysfs_attrs */
 	if (priv->chip_type != SIO) {
 		device_remove_file(&port->dev, &dev_attr_event_char);
-		if (priv->chip_type == FT232BM || priv->chip_type == FT2232C) {
+		if (priv->chip_type == FT232BM ||
+		    priv->chip_type == FT2232C ||
+		    priv->chip_type == FT232RL) {
 			device_remove_file(&port->dev, &dev_attr_latency_timer);
 		}
 	}
@@ -2102,6 +2104,7 @@ static int ftdi_tiocmget (struct usb_serial_port *port, struct file *file)
 	case FT8U232AM:
 	case FT232BM:
 	case FT2232C:
+	case FT232RL:
 		/* the 8U232AM returns a two byte value (the sio is a 1 byte value) - in the same
 		   format as the data returned from the in point */
 		if ((ret = usb_control_msg(port->serial->dev,
-- 
1.5.2.3

