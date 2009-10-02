Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZJBBpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZJBBpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZJBBpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:45:01 -0400
Received: from kroah.org ([198.145.64.141]:33359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbZJBBdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:21 2009
Message-Id: <20091002012420.941931626@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [089/136] tty: USB hangup is racy
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=tty-usb-hangup-is-racy.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit d2b391822a11302add9e46476f3da4e18e6de84c upstream.

The USB layer uses tty_hangup to deal with unplugs of the physical hardware
(analogous to loss of carrier) and then frees the resources. However the
tty_hangup is asynchronous. As the hangup can sleep we can use tty_vhangup
which is the non async version to avoid freeing resources too early.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1161,10 +1161,7 @@ void usb_serial_disconnect(struct usb_in
 		if (port) {
 			struct tty_struct *tty = tty_port_tty_get(&port->port);
 			if (tty) {
-				/* The hangup will occur asynchronously but
-				   the object refcounts will sort out all the
-				   cleanup */
-				tty_hangup(tty);
+				tty_vhangup(tty);
 				tty_kref_put(tty);
 			}
 			kill_traffic(port);


