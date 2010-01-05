Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154Ab0AENal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0AENal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0AENak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:30:40 -0500
Received: from www84.your-server.de ([213.133.104.84]:43446 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0AENaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:30:39 -0500
Subject: [tip:urgent] fix USB serial fix kfifo_len locking
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Johan Hovold <jhovold@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org
References: <20100104174352.GA26606@localhost>
	 <1262632804.4814.17.camel@wall-e> <20100105004344.082bb69f@redhat.com>
	 <20100105110418.GA10442@localhost> <1262689759.21020.2.camel@wall-e>
	 <20100105111401.GB10442@localhost> <1262690734.22009.3.camel@wall-e>
	 <20100105113525.GA19371@localhost> <1262692881.23577.15.camel@wall-e>
In-Reply-To: <1262692881.23577.15.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jan 2010 14:30:31 +0100
Message-ID: <1262698231.4532.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a possible race bug in drivers/usb/serial/generic with
the new kfifo API.

Please apply it to the 2.6.33-rc* tree.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 generic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.33-rc2.orig/drivers/usb/serial/generic.c	2009-12-27 23:37:03.566060210 +0100
+++ linux-2.6.33-rc2.new/drivers/usb/serial/generic.c	2010-01-04 20:15:38.023351711 +0100
@@ -386,12 +386,12 @@ int usb_serial_generic_chars_in_buffer(s
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (serial->type->max_in_flight_urbs) {
-		spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
+	if (serial->type->max_in_flight_urbs)
 		chars = port->tx_bytes_flight;
-		spin_unlock_irqrestore(&port->lock, flags);
-	} else if (serial->num_bulk_out)
+	else if (serial->num_bulk_out)
 		chars = kfifo_len(&port->write_fifo);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	dbg("%s - returns %d", __func__, chars);
 	return chars;


