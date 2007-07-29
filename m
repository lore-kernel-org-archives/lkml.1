Return-Path: <linux-kernel-owner+w=401wt.eu-S1763487AbXG2OFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487AbXG2OFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762555AbXG2OFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:05:44 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:47012 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762439AbXG2OFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:05:43 -0400
Message-ID: <008001c7d1e9$6a8625b0$03c8a8c0@kroptech.com>
From: "Adam Kropelin" <akropel1@rochester.rr.com>
To: "Nick Pasich" <NewsLetters@NickAndBarb.net>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Pasich" <NewsLetters@NickAndBarb.net>,
       <linux-usb-devel@lists.sourceforge.net>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       "Al Borchers" <alborchers@steinerpoint.com>,
       <linux-kernel@vger.kernel.org>, "Peter Berger" <pberger@brimson.com>
References: <20070727203708.GA10839@NICK2> <20070727152254.202959c1.akpm@linux-foundation.org> <003701c7d16c$8c72b7b0$03c8a8c0@kroptech.com> <20070729124813.GA30633@69.17.112.251>
Subject: Re: [linux-usb-devel] Edgeport UPS Monitoring Problems
Date: Sun, 29 Jul 2007 10:04:44 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_007D_01C7D1C7.E357FD00"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_007D_01C7D1C7.E357FD00
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit

From: "Nick Pasich" <NewsLetters@NickAndBarb.net>
> Here's the dmesg output ......
>
> [...]
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: LCR - 
> write to send_cmd_write_uart_register register 0x03
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> SendCmdWriteUartReg - Not writing to MCR Register
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: MCR - 
> write to send_cmd_write_uart_register register 0x0b
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> SendCmdWriteUartReg - Not writing to MCR Register
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> change_port_settings - baud rate = 9600
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> SendCmdWriteBaudRate - NOT Setting baud rate for port = 0, baud = 9600

Yup, there's what I expected. Not setting the baud rate and not writing 
status registers is unlikely to produce working results. This 9600 must 
be the default setting being applied.

> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> SendCmdWriteUartReg - Not writing to MCR Register
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: MCR - 
> write to send_cmd_write_uart_register register 0x0b
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> SendCmdWriteUartReg - Not writing to MCR Register
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> change_port_settings - baud rate = 2400
> Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> SendCmdWriteBaudRate - NOT Setting baud rate for port = 0, baud = 2400

Here's apcupsd trying to set 2400 baud.

Please try the attached patch (against 2.6.22.1). This will allow 
writing to the baud rate and MCR/LCR registers on non-EPIC adapters. I 
suspect the previous code was a copy-paste error.

--Adam

------=_NextPart_000_007D_01C7D1C7.E357FD00
Content-Type: application/octet-stream;
	name="usb-serial-edgeport-non-epic-baud-rate-fix.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="usb-serial-edgeport-non-epic-baud-rate-fix.patch"

--- linux-2.6.22.1/drivers/usb/serial/io_edgeport.c	2007-07-10 =
14:56:30.000000000 -0400=0A=
+++ linux-2.6.22.1.new/drivers/usb/serial/io_edgeport.c	2007-07-29 =
09:45:18.000000000 -0400=0A=
@@ -2366,9 +2366,8 @@=0A=
 	int status;=0A=
 	unsigned char number =3D edge_port->port->number - =
edge_port->port->serial->minor;=0A=
 =0A=
-	if ((!edge_serial->is_epic) ||=0A=
-	    ((edge_serial->is_epic) &&=0A=
-	     (!edge_serial->epic_descriptor.Supports.IOSPSetBaudRate))) {=0A=
+	if (edge_serial->is_epic &&=0A=
+	    !edge_serial->epic_descriptor.Supports.IOSPSetBaudRate) {=0A=
 		dbg("SendCmdWriteBaudRate - NOT Setting baud rate for port =3D %d, =
baud =3D %d",=0A=
 		    edge_port->port->number, baudRate);=0A=
 		return 0;=0A=
@@ -2461,18 +2460,16 @@=0A=
 =0A=
 	dbg("%s - write to %s register 0x%02x", (regNum =3D=3D MCR) ? "MCR" : =
"LCR", __FUNCTION__, regValue);=0A=
 =0A=
-	if ((!edge_serial->is_epic) ||=0A=
-	    ((edge_serial->is_epic) &&=0A=
-	     (!edge_serial->epic_descriptor.Supports.IOSPWriteMCR) &&=0A=
-	     (regNum =3D=3D MCR))) {=0A=
+	if (edge_serial->is_epic &&=0A=
+	    !edge_serial->epic_descriptor.Supports.IOSPWriteMCR &&=0A=
+	    regNum =3D=3D MCR) {=0A=
 		dbg("SendCmdWriteUartReg - Not writing to MCR Register");=0A=
 		return 0;=0A=
 	}=0A=
 =0A=
-	if ((!edge_serial->is_epic) ||=0A=
-	    ((edge_serial->is_epic) &&=0A=
-	     (!edge_serial->epic_descriptor.Supports.IOSPWriteLCR) &&=0A=
-	     (regNum =3D=3D LCR))) {=0A=
+	if (edge_serial->is_epic &&=0A=
+	    !edge_serial->epic_descriptor.Supports.IOSPWriteLCR &&=0A=
+	    regNum =3D=3D LCR) {=0A=
 		dbg ("SendCmdWriteUartReg - Not writing to LCR Register");=0A=
 		return 0;=0A=
 	}=0A=

------=_NextPart_000_007D_01C7D1C7.E357FD00--

