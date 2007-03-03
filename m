Return-Path: <linux-kernel-owner+w=401wt.eu-S1030341AbXCCUpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341AbXCCUpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030400AbXCCUpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:45:17 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:53596 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030341AbXCCUpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:45:16 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Andreas Laumann <al@authentidate.de>
Subject: Re: usbserial not working/oops on removal
Date: Sat, 3 Mar 2007 21:43:34 +0100
User-Agent: KMail/1.9.1
Cc: Kevin Fenzi <kevin@scrye.com>, linux-kernel@vger.kernel.org
References: <20070302193715.568098a6@ningauble.scrye.com> <200703031138.20582.oliver@neukum.org> <1172928441.3710.8.camel@justine.inexnet.de>
In-Reply-To: <1172928441.3710.8.camel@justine.inexnet.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703032143.34664.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH43ejgwwk=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 3. März 2007 14:27 schrieb Andreas Laumann:
> Unfortunately your fix  does not work.  The first one seems registered
> correctly, but after that it fails again for the next one.  

Unfortunately the last patch I sent you introduced a race. Could you test
this alternative patch?

	Regards
		Oliver

--- a/drivers/usb/serial/usb-serial.c	2007-03-03 16:28:22.000000000 +0100
+++ b/drivers/usb/serial/usb-serial.c	2007-03-03 21:37:27.000000000 +0100
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
@@ -847,7 +850,6 @@
 		port = kzalloc(sizeof(struct usb_serial_port), GFP_KERNEL);
 		if (!port)
 			goto probe_error;
-		port->number = i + serial->minor;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
 		mutex_init(&port->mutex);
