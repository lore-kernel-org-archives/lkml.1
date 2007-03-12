Return-Path: <linux-kernel-owner+w=401wt.eu-S1030351AbXCLP1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbXCLP1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030403AbXCLP1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:27:37 -0400
Received: from ns.suse.de ([195.135.220.2]:46535 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030351AbXCLP1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:27:36 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
Date: Mon, 12 Mar 2007 16:27:29 +0100
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca>
In-Reply-To: <45F56E37.9050506@rtr.ca>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jFX9FiFbazgjj0P"
Message-Id: <200703121627.31332.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_jFX9FiFbazgjj0P
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 12. M=C3=A4rz 2007 16:13 schrieb Mark Lord:
> Oliver Neukum wrote:
> > Am Montag, 12. M=C3=A4rz 2007 15:56 schrieb Mark Lord:
> >> Still no improvement on the b0rken usb-serial resume support in -rc*.
> >=20
> > Have you applied the fixes in Greg's current tree?
>=20
> I don't know anything about any "current tree"
> other than the 2.6.21-rc3-git* on kernel.org.
>=20
> Greg hasn't suggested anything for this yet,
> mostly because he's been busy keeping the 2.6.20.xx
> point releases sane.

Sorry, try these in the chronological order the names imply.
If it still happens, let me know.

	Regards
		Oliver

--Boundary-00=_jFX9FiFbazgjj0P
Content-Type: text/x-diff;
  charset="utf-8";
  name="serial20070305.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="serial20070305.patch"

--- a/drivers/usb/serial/usb-serial.c	2007-03-05 14:43:20.000000000 +0100
+++ b/drivers/usb/serial/usb-serial.c	2007-03-05 15:18:53.000000000 +0100
@@ -99,9 +99,12 @@
 			continue;
 
 		*minor = i;
+		j = 0;
 		dbg("%s - minor base = %d", __FUNCTION__, *minor);
-		for (i = *minor; (i < (*minor + num_ports)) && (i < SERIAL_TTY_MINORS); ++i)
+		for (i = *minor; (i < (*minor + num_ports)) && (i < SERIAL_TTY_MINORS); ++i) {
 			serial_table[i] = serial;
+			serial->port[j++]->number = i;
+		}
 		spin_unlock(&table_lock);
 		return serial;
 	}
@@ -848,7 +851,6 @@
 		port = kzalloc(sizeof(struct usb_serial_port), GFP_KERNEL);
 		if (!port)
 			goto probe_error;
-		port->number = i + serial->minor;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
 		mutex_init(&port->mutex);
@@ -1035,9 +1037,6 @@
 		kfree(port->interrupt_out_buffer);
 	}
 
-	/* return the minor range that this device had */
-	return_serial (serial);
-
 	/* free up any memory that we allocated */
 	for (i = 0; i < serial->num_port_pointers; ++i)
 		kfree(serial->port[i]);

--Boundary-00=_jFX9FiFbazgjj0P
Content-Type: text/x-diff;
  charset="utf-8";
  name="usbserial20070227.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="usbserial20070227.patch"

--- linux-2.6.21-rc1/drivers/usb/serial/usb-serial.c.alt	2007-02-21 05:32:30.000000000 +0100
+++ linux-2.6.21-rc1/drivers/usb/serial/usb-serial.c	2007-02-26 15:32:50.000000000 +0100
@@ -826,7 +826,6 @@
 			num_ports = type->num_ports;
 	}
 
-	serial->minor = minor;
 	serial->num_ports = num_ports;
 	serial->num_bulk_in = num_bulk_in;
 	serial->num_bulk_out = num_bulk_out;
@@ -980,6 +979,7 @@
 		dev_err(&interface->dev, "No more free serial devices\n");
 		goto probe_error;
 	}
+	serial->minor = minor;
 
 	/* register all of the individual ports with the driver core */
 	for (i = 0; i < num_ports; ++i) {

--Boundary-00=_jFX9FiFbazgjj0P--
