Return-Path: <linux-kernel-owner+w=401wt.eu-S1763040AbZJOVPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763040AbZJOVPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbZJOVPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:15:46 -0400
Received: from kroah.org ([198.145.64.141]:43140 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbZJOVPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:15:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct 15 14:10:20 2009
Message-Id: <20091015211019.922487164@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Oct 2009 11:54:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [1/3] usb-serial: fix crash when sub-driver updates firmware
References: <20091015185430.128674330@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-fix-crash-when-sub-driver-updates-firmware.patch
In-Reply-To: <20091015211112.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 0a3c8549ea7e94d74a41096d42bc6cdf43d183bf upstream.

This patch (as1244) fixes a crash in usb-serial that occurs when a
sub-driver returns a positive value from its attach method, indicating
that new firmware was loaded and the device will disconnect and
reconnect.  The usb-serial core then skips the step of registering the
port devices; when the disconnect occurs, the attempt to unregister
the ports fails dramatically.

This problem shows up with Keyspan devices and it might affect others
as well.

When the attach method returns a positive value, the patch sets
num_ports to 0.  This tells usb_serial_disconnect() not to try
unregistering any of the ports; instead they are cleaned up by
destroy_serial().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -973,6 +973,7 @@ int usb_serial_probe(struct usb_interfac
 		if (retval > 0) {
 			/* quietly accept this device, but don't bind to a
 			   serial port as it's about to disappear */
+			serial->num_ports = 0;
 			goto exit;
 		}
 	}


