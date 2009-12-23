Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbZLWWal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbZLWWal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZLWWaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:30:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35114 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZLWWai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:30:38 -0500
Date: Thu, 24 Dec 2009 09:30:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>
Subject: linux-next: manual merge of the usb tree with Linus' tree
Message-Id: <20091224093036.2ba1ecf5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/generic.c between commit
119eecc831a42bd090543568932e440c6831f1bb ("Fix usb_serial_probe() problem
introduced by the recent kfifo changes") from Linus' tree and commit
40b2ba0dfb62bed0f7cc6f699053d18ca4553e91 ("USB: serial: mct_usb232: add
drain on close") from the usb tree.

I fixed it up (see below) and can carry the fix for a while.  The result
needs checking.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/generic.c
index f1ea3a3,3eea1d8..0000000
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@@ -386,12 -386,15 +386,15 @@@ int usb_serial_generic_chars_in_buffer(
  
  	dbg("%s - port %d", __func__, port->number);
  
+ 	spin_lock_irqsave(&port->lock, flags);
  	if (serial->type->max_in_flight_urbs) {
- 		spin_lock_irqsave(&port->lock, flags);
  		chars = port->tx_bytes_flight;
- 		spin_unlock_irqrestore(&port->lock, flags);
- 	} else if (serial->num_bulk_out)
+ 	} else if (serial->num_bulk_out) {
+ 		/* This overcounts badly, but is good enough for drain wait. */
 -		chars = __kfifo_len(port->write_fifo);
 +		chars = kfifo_len(&port->write_fifo);
+ 		chars += port->write_urb_busy * port->bulk_out_size;
+ 	}
+ 	spin_unlock_irqrestore(&port->lock, flags);
  
  	dbg("%s - returns %d", __func__, chars);
  	return chars;
