Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbZLGARu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbZLGARu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbZLGAN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:57 -0500
Received: from kroah.org ([198.145.64.141]:34666 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbZLGANp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:56 2009
Message-Id: <20091207000656.597883985@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [089/119] USB: ftdi_sio: Keep going when write errors are encountered.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-ftdi_sio-keep-going-when-write-errors-are-encountered.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric W. Biederman <ebiederm@xmission.com>

commit 0de6ab8b91f2e1e8e7fc66a8b5c5e8ca82ea16b7 upstream.

The use of urb->actual_length to update tx_outstanding_bytes
implicitly assumes that the number of bytes actually written is the
same as the number of bytes we tried to write.  On error that
assumption is violated so just use transfer_buffer_length the number
of bytes we intended to write to the device.

If an error occurs we need to fall through and call
usb_serial_port_softint to wake up processes waiting in
tty_wait_until_sent.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1939,7 +1939,7 @@ static void ftdi_write_bulk_callback(str
 		return;
 	}
 	/* account for transferred data */
-	countback = urb->actual_length;
+	countback = urb->transfer_buffer_length;
 	data_offset = priv->write_offset;
 	if (data_offset > 0) {
 		/* Subtract the control bytes */
@@ -1952,7 +1952,6 @@ static void ftdi_write_bulk_callback(str
 
 	if (status) {
 		dbg("nonzero write bulk status received: %d", status);
-		return;
 	}
 
 	usb_serial_port_softint(port);


