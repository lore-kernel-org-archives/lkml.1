Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbXGPUS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbXGPUS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXGPUST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:18:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:20008 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXGPUSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=sMxWV3+tC7z1cJY6n+F8PHjvwMRtVjfrOOYGzAt/5z6eGCH/zXDHCe5cpOOjkuiGo/oNR5I3T6Btx0nDqHo9G8QM+y+Bxqsw8m1dbIz+wZ+vQhZqnvc67KalQMM1P7rEBFQPPm5Z07hDfyygIllRRxviyBS2+hkRkgjgUHxUkXY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove pointless conditional in drivers/usb/serial/io_ti.c::edge_shutdown()
Date: Mon, 16 Jul 2007 22:17:25 +0200
User-Agent: KMail/1.9.7
Cc: Peter Berger <pberger@brimson.com>,
       Al Borchers <alborchers@steinerpoint.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707162217.25766.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity scan found (CID: 1708) this in 
drivers/usb/serial/io_ti.c::edge_shutdown() : 

...
2797 		for (i=0; i < serial->num_ports; ++i) {
2798 			edge_port = usb_get_serial_port_data(serial->port[i]);
2799 			edge_remove_sysfs_attrs(edge_port->port);
2800 			if (edge_port) {
2801 				edge_buf_free(edge_port->ep_out_buf);
2802 				kfree(edge_port);
2803 			}
2804 			usb_set_serial_port_data(serial->port[i], NULL);
2805 		}
...

It's complaining that we dereference 'edge_port' in line 2799 which 
makes the test of that pointer against NULL in 2800 pointless, since 
if edge_port was actually NULL we'd have crashed already before 
reaching line 2800.
Reading the edge_open() function it seems to me that the pointer 
returned by usb_get_serial_port_data(serial->port[i]) and stored in 
'edge_port' can never actually be NULL here, so the test is entirely 
superfluous (even if it could be NULL it would be pointless here, 
ignoring the then possible crash in that case, since both 
edge_buf_free() and kfree() can handle being passed NULL pointers.

This patch removes the pointless conditional (and also makes a few
tiny style corrections now that I was in the area anyway).


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/usb/serial/io_ti.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 0d39036..b867090 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2794,16 +2794,14 @@ static void edge_shutdown (struct usb_serial *serial)
 
 	dbg ("%s", __FUNCTION__);
 
-	for (i=0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i) {
 		edge_port = usb_get_serial_port_data(serial->port[i]);
 		edge_remove_sysfs_attrs(edge_port->port);
-		if (edge_port) {
-			edge_buf_free(edge_port->ep_out_buf);
-			kfree(edge_port);
-		}
+		edge_buf_free(edge_port->ep_out_buf);
+		kfree(edge_port);
 		usb_set_serial_port_data(serial->port[i], NULL);
 	}
-	kfree (usb_get_serial_data(serial));
+	kfree(usb_get_serial_data(serial));
 	usb_set_serial_data(serial, NULL);
 }
 


