Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZLXLno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZLXLno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZLXLni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:43:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45228 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389AbZLXLnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:43:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HWarnF8R4l2pfGL1MTfCcE77eHLzkmEtZnej3Mv7TEOEV3bJyCxHNNvK8VJtqiwz1+
         P10k4H/sNuwrEOn4RohTMagFv8iheED/RL+hiv//rfxeb+YLHDedbHmVByym1H2rneMW
         Mn0JU8p0A3RDDYWy3Neuq32IEoLkdhTBxr2iM=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matti Aarnio <matti.aarnio@zmailer.org>,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 5/5] USB: ftdi_sio: remove unnecessary initialisations
Date: Thu, 24 Dec 2009 12:42:11 +0100
Message-Id: <1261654931-31543-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6.rc4
In-Reply-To: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
References: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return values are being initialised to zero only to be unconditionally
assigned to a few instructions later. This may give the impression that
zero is returned on success, which is not the case.

Note also that ftdi_NDI_device_setup never reports errors.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 49c981f..9257743 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1123,7 +1123,7 @@ static int write_latency_timer(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	struct usb_device *udev = port->serial->dev;
-	int rv = 0;
+	int rv;
 	int l = priv->latency;
 
 	if (priv->flags & ASYNC_LOW_LATENCY)
@@ -1147,7 +1147,7 @@ static int read_latency_timer(struct usb_serial_port *port)
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	struct usb_device *udev = port->serial->dev;
 	unsigned char *buf;
-	int rv = 0;
+	int rv;
 
 	dbg("%s", __func__);
 
@@ -1341,7 +1341,7 @@ static void ftdi_set_max_packet_size(struct usb_serial_port *port)
 	struct usb_endpoint_descriptor *ep_desc = &interface->cur_altsetting->endpoint[1].desc;
 
 	unsigned num_endpoints;
-	int i = 0;
+	int i;
 
 	num_endpoints = interface->cur_altsetting->desc.bNumEndpoints;
 	dev_info(&udev->dev, "Number of endpoints %d\n", num_endpoints);
@@ -1393,7 +1393,7 @@ static ssize_t store_latency_timer(struct device *dev,
 	struct usb_serial_port *port = to_usb_serial_port(dev);
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	int v = simple_strtoul(valbuf, NULL, 10);
-	int rv = 0;
+	int rv;
 
 	priv->latency = v;
 	rv = write_latency_timer(port);
@@ -1411,7 +1411,7 @@ static ssize_t store_event_char(struct device *dev,
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	struct usb_device *udev = port->serial->dev;
 	int v = simple_strtoul(valbuf, NULL, 10);
-	int rv = 0;
+	int rv;
 
 	dbg("%s: setting event char = %i", __func__, v);
 
@@ -1598,7 +1598,6 @@ static int ftdi_NDI_device_setup(struct usb_serial *serial)
 {
 	struct usb_device *udev = serial->dev;
 	int latency = ndi_latency_timer;
-	int rv = 0;
 
 	if (latency == 0)
 		latency = 1;
@@ -1608,7 +1607,8 @@ static int ftdi_NDI_device_setup(struct usb_serial *serial)
 	dbg("%s setting NDI device latency to %d", __func__, latency);
 	dev_info(&udev->dev, "NDI device with a latency value of %d", latency);
 
-	rv = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+	/* FIXME: errors are not returned */
+	usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				FTDI_SIO_SET_LATENCY_TIMER_REQUEST,
 				FTDI_SIO_SET_LATENCY_TIMER_REQUEST_TYPE,
 				latency, 0, NULL, 0, WDR_TIMEOUT);
@@ -1699,7 +1699,7 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	struct usb_device *dev = port->serial->dev;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
-	int result = 0;
+	int result;
 
 	dbg("%s", __func__);
 
@@ -2118,7 +2118,7 @@ static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	__u16 urb_value = 0;
+	__u16 urb_value;
 
 	/* break_state = -1 to turn on break, and 0 to turn off break */
 	/* see drivers/char/tty_io.c to see it used */
-- 
1.6.6.rc4

