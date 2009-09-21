Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZIUB7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZIUB7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 21:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZIUB7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 21:59:14 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36215 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751793AbZIUB7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 21:59:14 -0400
Date: Sun, 20 Sep 2009 21:59:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tilman Schmidt <tilman@imap.cc>
cc: Matthias Geissert <matthias.geissert@web.de>, Greg KH <greg@kroah.com>,
       USB list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
In-Reply-To: <20090920181133.GA14366@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0909202152420.15304-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009, Greg KH wrote:

> Yes, I missed the fact that the ipaq driver needed to pay attention to
> this, my mistake :(
> 
> I'm pretty much not able to write any new patches until the end of next
> week, due to conferences I'm currently attending, so if someone wants to
> knock up a patch to fix this before then, it would be most appreciated.

Here's a patch which ought to fix the oops.  I trust it won't cause 
any existing devices to start misbehaving.  Tilman and Matthias, please 
verify that this works okay on your systems.

A better approach might be to test the bInterfaceClass value, but I 
don't know if that would work; there might be some devices using a 
strange value.

Alan Stern



Index: usb-2.6/drivers/usb/serial/ipaq.c
===================================================================
--- usb-2.6.orig/drivers/usb/serial/ipaq.c
+++ usb-2.6/drivers/usb/serial/ipaq.c
@@ -966,6 +966,15 @@ static int ipaq_calc_num_ports(struct us
 static int ipaq_startup(struct usb_serial *serial)
 {
 	dbg("%s", __func__);
+
+	/* Some of the devices in ipaq_id_table[] are composite, and we
+	 * shouldn't bind to all the interfaces.  This test will rule out
+	 * some obviously invalid possibilities.
+	 */
+	if (serial->num_bulk_in < serial->num_ports ||
+			serial->num_bulk_out < serial->num_ports)
+		return -ENODEV;
+
 	if (serial->dev->actconfig->desc.bConfigurationValue != 1) {
 		/*
 		 * FIXME: HP iPaq rx3715, possibly others, have 1 config that

