Return-Path: <linux-kernel-owner+w=401wt.eu-S935861AbXHGU46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935861AbXHGU46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964804AbXHGUtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:49:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56182 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935431AbXHGUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:49:21 -0400
Date: Tue, 7 Aug 2007 13:44:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Adam Kropelin <akropel1@rochester.rr.com>
Subject: [2.6.22.2 review 22/84] usb-serial: Fix edgeport regression on
	non-EPiC devices
Message-ID: <20070807204446.GW23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-serial-fix-edgeport-regression-on-non-epic-devices.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adam Kropelin <akropel1@rochester.rr.com>

Fix serious regression on non-EPiC edgeport usb-serial devices. Baud
rate and MCR/LCR registers are not being written on these models due
to apparent copy-n-paste errors introduced with EPiC support.

Failure reported by Nick Pasich <Nick@NickAndBarb.net>.

Signed-off-by: Adam Kropelin <akropel1@rochester.rr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/io_edgeport.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2366,9 +2366,8 @@ static int send_cmd_write_baud_rate (str
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
@@ -2461,18 +2460,16 @@ static int send_cmd_write_uart_register 
 
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

-- 
