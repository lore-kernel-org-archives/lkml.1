Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215Ab0CMBXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:23:55 -0500
Received: from kroah.org ([198.145.64.141]:60721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934873Ab0CMAUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:16 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.163332880@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Elina Pasheva <epasheva@sierrawireless.com>
Subject: [patch 057/123] USB: serial: sierra driver indat_callback fix
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Elina Pasheva <epasheva@sierrawireless.com>

commit b87c6e86dac1bb5222279cc8ff7e09529e1c4ed9 upstream.

A crash has been reported with sierra driver on disconnect with
Ubuntu/Lucid distribution based on kernel-2.6.32.
The cause of the crash was determined as "NULL tty pointer was being
referenced" and the NULL pointer was passed by sierra_indat_callback().

This patch modifies sierra_indat_callback() function to check for NULL
tty structure pointer. This modification prevents a crash from happening
when the device is disconnected.

This patch fixes the bug reported in Launchpad:
  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/511157

Signed-off-by: Elina Pasheva <epasheva@sierrawireless.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -604,14 +604,17 @@ static void sierra_indat_callback(struct
 	} else {
 		if (urb->actual_length) {
 			tty = tty_port_tty_get(&port->port);
+			if (tty) {
+				tty_buffer_request_room(tty,
+					urb->actual_length);
+				tty_insert_flip_string(tty, data,
+					urb->actual_length);
+				tty_flip_buffer_push(tty);
 
-			tty_buffer_request_room(tty, urb->actual_length);
-			tty_insert_flip_string(tty, data, urb->actual_length);
-			tty_flip_buffer_push(tty);
-
-			tty_kref_put(tty);
-			usb_serial_debug_data(debug, &port->dev, __func__,
-				urb->actual_length, data);
+				tty_kref_put(tty);
+				usb_serial_debug_data(debug, &port->dev,
+					__func__, urb->actual_length, data);
+			}
 		} else {
 			dev_dbg(&port->dev, "%s: empty read urb"
 				" received\n", __func__);


