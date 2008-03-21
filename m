Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbYCUXCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbYCUXCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763132AbYCUWvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:51:06 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59358 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763070AbYCUWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:01 -0400
Message-Id: <20080321224431.764658697@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kevin Vance <kvance@kvance.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 54/76] USB: ftdi_sio: Workaround for broken Matrix Orbital serial port
Content-Disposition: inline; filename=usb-ftdi_sio-workaround-for-broken-matrix-orbital-serial-port.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Kevin Vance <kvance@kvance.com>

Workaround for the FT232RL-based, Matrix Orbital VK204-25-USB serial port
added to the ftdi_sio driver.

The device has an invalid endpoint descriptor, which must be modified
before it can be used.

Signed-off-by: Kevin Vance <kvance@kvance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[chrisw@sous-sol.org: backport to 2.6.24.3 w/out ftdi_jtag_probe]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/ftdi_sio.c |   24 ++++++++++++++++++++++++
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 31 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -310,6 +310,7 @@ struct ftdi_sio_quirk {
 };
 
 static int   ftdi_olimex_probe		(struct usb_serial *serial);
+static int   ftdi_mtxorb_hack_setup	(struct usb_serial *serial);
 static void  ftdi_USB_UIRT_setup	(struct ftdi_private *priv);
 static void  ftdi_HE_TIRA1_setup	(struct ftdi_private *priv);
 
@@ -317,6 +318,10 @@ static struct ftdi_sio_quirk ftdi_olimex
 	.probe	= ftdi_olimex_probe,
 };
 
+static struct ftdi_sio_quirk ftdi_mtxorb_hack_quirk = {
+	.probe  = ftdi_mtxorb_hack_setup,
+};
+
 static struct ftdi_sio_quirk ftdi_USB_UIRT_quirk = {
 	.port_probe = ftdi_USB_UIRT_setup,
 };
@@ -379,6 +384,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_4_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_5_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_6_PID) },
+	{ USB_DEVICE(MTXORB_VK_VID, MTXORB_VK_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_mtxorb_hack_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_PERLE_ULTRAPORT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PIEGROUP_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TNC_X_PID) },
@@ -1301,6 +1308,23 @@ static int ftdi_olimex_probe(struct usb_
 	return 0;
 }
 
+/*
+ * The Matrix Orbital VK204-25-USB has an invalid IN endpoint.
+ * We have to correct it if we want to read from it.
+ */
+static int ftdi_mtxorb_hack_setup(struct usb_serial *serial)
+{
+	struct usb_host_endpoint *ep = serial->dev->ep_in[1];
+	struct usb_endpoint_descriptor *ep_desc = &ep->desc;
+
+	if (ep->enabled && ep_desc->wMaxPacketSize == 0) {
+		ep_desc->wMaxPacketSize = 0x40;
+		info("Fixing invalid wMaxPacketSize on read pipe");
+	}
+
+	return 0;
+}
+
 /* ftdi_shutdown is called from usbserial:usb_serial_disconnect
  *   it is called when the usb device is disconnected
  *
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -98,6 +98,13 @@
 #define FTDI_MTXORB_5_PID      0xFA05  /* Matrix Orbital Product Id */
 #define FTDI_MTXORB_6_PID      0xFA06  /* Matrix Orbital Product Id */
 
+/*
+ * The following are the values for the Matrix Orbital VK204-25-USB
+ * display, which use the FT232RL.
+ */
+#define MTXORB_VK_VID		0x1b3d
+#define MTXORB_VK_PID		0x0158
+
 /* Interbiometrics USB I/O Board */
 /* Developed for Interbiometrics by Rudolf Gugler */
 #define INTERBIOMETRICS_VID              0x1209

-- 
