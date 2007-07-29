Return-Path: <linux-kernel-owner+w=401wt.eu-S934937AbXG2PX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937AbXG2PX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765902AbXG2PFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:05:25 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:46128 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765944AbXG2PFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:05:23 -0400
Date: Sun, 29 Jul 2007 11:03:29 -0400
From: Adam Kropelin <akropel1@rochester.rr.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Nick Pasich <NewsLetters@NickAndBarb.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-usb-devel @ lists. sourceforge. net" 
	<linux-usb-devel@lists.sourceforge.net>,
       Al Borchers <alborchers@steinerpoint.com>,
       "linux-kernel @ vger. kernel. org" <linux-kernel@vger.kernel.org>,
       Peter Berger <pberger@brimson.com>
Subject: [PATCH] usb-serial: Fix edgeport regression on non-EPiC devices
Message-ID: <20070729150329.GA14873@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix serious regression on non-EPiC edgeport usb-serial devices. Baud 
rate and MCR/LCR registers are not being written on these models due 
to apparent copy-n-paste errors introduced with EPiC support.

Failure reported by Nick Pasich <Nick@NickAndBarb.net>.

Signed-off-by: Adam Kropelin <akropel1@rochester.rr.com>

--
Assuming this is a right and proper fix, it should go in the -stable
tree ASAP.

--- linux-2.6.22.1/drivers/usb/serial/io_edgeport.c	2007-07-10 14:56:30.000000000 -0400
+++ linux-2.6.22.1.new/drivers/usb/serial/io_edgeport.c	2007-07-29 09:45:18.000000000 -0400
@@ -2366,9 +2366,8 @@
 	int status;
 	unsigned char number = edge_port->port->number - edge_port->port->serial->minor;
 
-	if ((!edge_serial->is_epic) ||
-	    ((edge_serial->is_epic) &&
-	     (!edge_serial->epic_descriptor.Supports.IOSPSetBaudRate))) {
+	if (edge_serial->is_epic &&
+	    !edge_serial->epic_descriptor.Supports.IOSPSetBaudRate) {
 		dbg("SendCmdWriteBaudRate - NOT Setting baud rate for port = %d, baud = %d",
 		    edge_port->port->number, baudRate);
 		return 0;
@@ -2461,18 +2460,16 @@
 
 	dbg("%s - write to %s register 0x%02x", (regNum == MCR) ? "MCR" : "LCR", __FUNCTION__, regValue);
 
-	if ((!edge_serial->is_epic) ||
-	    ((edge_serial->is_epic) &&
-	     (!edge_serial->epic_descriptor.Supports.IOSPWriteMCR) &&
-	     (regNum == MCR))) {
+	if (edge_serial->is_epic &&
+	    !edge_serial->epic_descriptor.Supports.IOSPWriteMCR &&
+	    regNum == MCR) {
 		dbg("SendCmdWriteUartReg - Not writing to MCR Register");
 		return 0;
 	}
 
-	if ((!edge_serial->is_epic) ||
-	    ((edge_serial->is_epic) &&
-	     (!edge_serial->epic_descriptor.Supports.IOSPWriteLCR) &&
-	     (regNum == LCR))) {
+	if (edge_serial->is_epic &&
+	    !edge_serial->epic_descriptor.Supports.IOSPWriteLCR &&
+	    regNum == LCR) {
 		dbg ("SendCmdWriteUartReg - Not writing to LCR Register");
 		return 0;
 	}
