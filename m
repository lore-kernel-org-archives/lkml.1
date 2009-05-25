Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZEYPRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZEYPRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZEYPRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:17:36 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50346 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752863AbZEYPRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:17:35 -0400
Date: Mon, 25 May 2009 11:17:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
In-Reply-To: <1243233792.24376.56.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0905251116250.23874-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009, Benjamin Herrenschmidt wrote:

> Found it. Patch below.
> 
> usb-serial: Fix crash when sub-driver attach() returns positive value
> 
> This fixes a crash in usb-serial that typically happens with keyspan USB
> devices, though it would happen potentially with anything that returns
> a positive value from the subdriver's attach() method to indicate that
> a FW was loaded and the device will disconnect and reconnect.
> 
> What happens is that we haven't yet initialized the struct device embedded
> inside the struct usb_serial_port when we call "exit:" and return
> from probe().
> 
> Later, when we get the disconnect() call, usb_serial_disconnect() tries
> to do a device_del() and put_device() on all the ports, despite the fact
> that in this case, the struct device wasn't initialized. This causes the
> device core to crash (right, it should be more robust).

Very clever.  Does this simpler patch also fix the problem?

Alan Stern


Index: usb-2.6/drivers/usb/serial/usb-serial.c
===================================================================
--- usb-2.6.orig/drivers/usb/serial/usb-serial.c
+++ usb-2.6/drivers/usb/serial/usb-serial.c
@@ -974,6 +974,7 @@ int usb_serial_probe(struct usb_interfac
 		if (retval > 0) {
 			/* quietly accept this device, but don't bind to a
 			   serial port as it's about to disappear */
+			serial->num_ports = 0;
 			goto exit;
 		}
 	}

