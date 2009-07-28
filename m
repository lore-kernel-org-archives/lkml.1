Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbZG1MfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbZG1MfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZG1MfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:35:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36816 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbZG1MfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:35:04 -0400
Date: Tue, 28 Jul 2009 22:35:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the ttydev tree with the
 usb.current tree
Message-Id: <20090728223504.6a6ae8e7.sfr@canb.auug.org.au>
In-Reply-To: <20090728132911.03ff78ea@lxorguk.ukuu.org.uk>
References: <20090728140110.7cfe7c22.sfr@canb.auug.org.au>
	<20090728112608.09a494e0@lxorguk.ukuu.org.uk>
	<200907281410.41449.oliver@neukum.org>
	<20090728132911.03ff78ea@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Tue, 28 Jul 2009 13:29:11 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> I need to look at the actual diff, but the combination looks completely
> bogus unless I'm misreading the fixup which is possible.

Below is the actual patch from the usb.current tree.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

>From oliver@neukum.org  Sat Jul 18 15:45:44 2009
From: Oliver Neukum <oliver@neukum.org>
Date: Sat, 18 Jul 2009 15:47:17 +0200
Subject: USB: fix usage count in usb serial generic open regarding autoresume
To: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Message-ID: <200907181547.17813.oliver@neukum.org>
Content-Disposition: inline


The resume handler has to resubmit the reading URBs if the device is
resumed while opened. But the open() method bumps the counter before
it resumes a device. The fix is to increment the counter only after
the resumption or if no resumption is attempted.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Tested-by: Matthew Garrett <mjg@redhat.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/serial/usb-serial.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -214,15 +214,13 @@ static int serial_open (struct tty_struc
 		goto bailout_port_put;
 	}
 
-	++port->port.count;
-
 	/* set up our port structure making the tty driver
 	 * remember our port object, and us it */
 	tty->driver_data = port;
 	tty_port_tty_set(&port->port, tty);
 
 	/* If the console is attached, the device is already open */
-	if (port->port.count == 1 && !port->console) {
+	if (!port->port.count && !port->console) {
 
 		/* lock this module before we call it
 		 * this may fail, which means we must bail out,
@@ -240,12 +238,16 @@ static int serial_open (struct tty_struc
 		if (retval)
 			goto bailout_module_put;
 
+		++port->port.count;
+
 		/* only call the device specific open if this
 		 * is the first time the port is opened */
 		retval = serial->type->open(tty, port, filp);
 		if (retval)
 			goto bailout_interface_put;
 		mutex_unlock(&serial->disc_mutex);
+	} else {
+		++port->port.count;
 	}
 	mutex_unlock(&port->mutex);
 	/* Now do the correct tty layer semantics */
