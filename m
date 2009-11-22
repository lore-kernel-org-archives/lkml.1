Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZKVUZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZKVUZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 15:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZKVUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 15:25:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:27770 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZKVUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 15:25:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WNQkJUxsP9Gn/EeScUeh+19RVGCLbyqvHcIzT2VcrJv7F9O2AAlL2rziOm6hUqHmxZ
         ft29SCVEAAR0baoTOGyo0Y+TBLyQT/SH3loGB87PtNQUZmjnXs2Yhc4GNj+m0Pf4Zay/
         MEsehuVzSM8QV5Py47qnxa/QZ3K5Jau5LpZf4=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: ftdi_sio: fix initialisation of latency timeout
Date: Sun, 22 Nov 2009 21:25:20 +0100
Message-Id: <1258921520-22609-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latency timeout was read but never stored on port probe. When
ASYNC_LOW_LATENCY was cleared the device timeout would get set to 0
rather than the default 16ms.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9c60d6d..dd130f7 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1150,7 +1150,6 @@ static int read_latency_timer(struct usb_serial_port *port)
 	unsigned short latency = 0;
 	int rv = 0;
 
-
 	dbg("%s", __func__);
 
 	rv = usb_control_msg(udev,
@@ -1163,8 +1162,9 @@ static int read_latency_timer(struct usb_serial_port *port)
 	if (rv < 0) {
 		dev_err(&port->dev, "Unable to read latency timer: %i\n", rv);
 		return -EIO;
-	}
-	return latency;
+	} else
+		priv->latency = latency;
+	return rv;
 }
 
 static int get_serial_info(struct usb_serial_port *port,
@@ -1551,7 +1551,8 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 
 	ftdi_determine_type(port);
 	ftdi_set_max_packet_size(port);
-	read_latency_timer(port);
+	if (read_latency_timer(port) < 0)
+		priv->latency = 16;
 	create_sysfs_attrs(port);
 	return 0;
 }
-- 
1.6.5.3

