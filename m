Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZHSWoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZHSWoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZHSWoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:44:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38839 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753254AbZHSWoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:44:05 -0400
Date: Wed, 19 Aug 2009 18:44:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090819225034.470c52e8@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0908191834180.26174-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Alan Cox wrote:

> > So Alan, what's the explanation?  An unsuccessful open method call
> > should not lead to a close method call.
> 
> For tty it always has since back in 0.9x, and most drivers depend upon
> this behaviour.

Curiouser and curiouser...

Okay Bruno, try out this patch and let's see if it helps.  It should 
fix the problem with the pl2303.  I'm not so sure about the FTDI device 
because that driver maintains its own reference count for its private 
data.

Alan Stern


Index: usb-2.6/drivers/usb/serial/usb-serial.c
===================================================================
--- usb-2.6.orig/drivers/usb/serial/usb-serial.c
+++ usb-2.6/drivers/usb/serial/usb-serial.c
@@ -209,8 +209,13 @@ static int serial_open (struct tty_struc
 	 * to be acquired while serial->disc_mutex is held.
 	 */
 	mutex_unlock(&serial->disc_mutex);
+
+	/* For reasons that have been lost in antiquity, the TTY layer calls
+	 * our close method even if the open call fails.  Hence we must not
+	 * drop the reference obtained by usb_serial_get_by_index().
+	 */
 	if (retval)
-		goto bailout_serial_put;
+		return retval;
 
 	if (mutex_lock_interruptible(&port->mutex)) {
 		retval = -ERESTARTSYS;
@@ -276,8 +281,6 @@ bailout_mutex_unlock:
 	mutex_unlock(&port->mutex);
 bailout_port_put:
 	put_device(&port->dev);
-bailout_serial_put:
-	usb_serial_put(serial);
 	return retval;
 }
 

