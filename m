Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344Ab0AWAS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0AWAS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282Ab0AWASu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:18:50 -0500
Received: from kroah.org ([198.145.64.141]:35050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab0AWASs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:11 2010
Message-Id: <20100123001111.509618217@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>, Greg KH <greg@kroah.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [10/29] usb: serial: fix memory leak in generic driver
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2591530204a76fecc843529ade56afe865dd2657 upstream.

Fix a regression introduced by commit
715b1dc01fe44537e8fce9566e4bb48d6821d84b ("USB: usb_debug,
usb_generic_serial: implement multi urb write").

URB transfer buffer was never freed when using multi-urb writes.
Currently the only driver enabling multi-urb writes is usb_debug.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/generic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -489,6 +489,8 @@ void usb_serial_generic_write_bulk_callb
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->serial->type->max_in_flight_urbs) {
+		kfree(urb->transfer_buffer);
+
 		spin_lock_irqsave(&port->lock, flags);
 		--port->urbs_in_flight;
 		port->tx_bytes_flight -= urb->transfer_buffer_length;


