Return-Path: <linux-kernel-owner+w=401wt.eu-S1763302AbZLQA4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763302AbZLQA4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762105AbZLQAz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:55:58 -0500
Received: from kroah.org ([198.145.64.141]:44542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761952AbZLQAyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:09 2009
Message-Id: <20091217004709.114459571@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:46:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tony Cook <tony-cook@bigpond.com>
Subject: [15/18] USB: fix mos7840 problem with minor numbers
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tony Cook <tony-cook@bigpond.com>

commit 37768adf9a1d49aeac0db1ba3dc28b3274b7b789 upstream

This patch fixes a problem with any mos7840 device where the use of the
field "minor" before it is initialised results in all the devices being
overlaid in memory (minor = 0 for all instances)

Contributed by: Phillip Branch

Backported to .27 by Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>

Signed-off-by: Tony Cook <tony-cook@bigpond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/serial/mos7840.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2453,9 +2453,14 @@ static int mos7840_startup(struct usb_se
 		mos7840_set_port_private(serial->port[i], mos7840_port);
 		spin_lock_init(&mos7840_port->pool_lock);
 
-		mos7840_port->port_num = ((serial->port[i]->number -
-					   (serial->port[i]->serial->minor)) +
-					  1);
+		/* minor is not initialised until later by
+		 * usb-serial.c:get_free_serial() and cannot therefore be used
+		 * to index device instances */
+		mos7840_port->port_num = i + 1;
+		dbg ("serial->port[i]->number = %d", serial->port[i]->number);
+		dbg ("serial->port[i]->serial->minor = %d", serial->port[i]->serial->minor);
+		dbg ("mos7840_port->port_num = %d", mos7840_port->port_num);
+		dbg ("serial->minor = %d", serial->minor);
 
 		if (mos7840_port->port_num == 1) {
 			mos7840_port->SpRegOffset = 0x0;
@@ -2666,10 +2671,12 @@ static void mos7840_disconnect(struct us
 
 	for (i = 0; i < serial->num_ports; ++i) {
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
-		spin_lock_irqsave(&mos7840_port->pool_lock, flags);
-		mos7840_port->zombie = 1;
-		spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
-		usb_kill_urb(mos7840_port->control_urb);
+		if (mos7840_port) {
+			spin_lock_irqsave(&mos7840_port->pool_lock, flags);
+			mos7840_port->zombie = 1;
+			spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
+			usb_kill_urb(mos7840_port->control_urb);
+		}
 	}
 
 	dbg("%s\n", "Thank u ::");


