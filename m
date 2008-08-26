Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYHZPCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYHZPCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 11:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbYHZPBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 11:01:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755496AbYHZPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 11:01:51 -0400
Date: Tue, 26 Aug 2008 11:01:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: amruth <amruth_pv@yahoo.com>
cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB Serial device disconnect causes IRQ disable after using
 ehci_info
In-Reply-To: <781960.93140.qm@web45208.mail.sp1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0808261036020.2493-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008, amruth wrote:

> Hi
> Alan

Please don't include old email messages at the bottom of your own 
messages.  It's annoying to read them.

> > That was the full-speed device.  Does it make any
> > difference if you use 
> > only one of them instead of both?
> > 
> The problem is seen when both are used.

That doesn't answer my question.  I already know that the problem is 
seen when both are used; the log you included before proves that.

What I don't know is whether the problem is seen when you use only 
the high-speed device.  Is it?

> > Try adding a statement saying:
> > 
> >ehci_info(ehci, "irq status %x masked %x\n",
> > status,
> >status & INTR_MASK);
> >> to ehci-hcd.c inside ehci_irq(), just before the line that
> > does 	status &= INTR_MASK;
> > 
> > Then let's see what happens.
> Here is the output after using ehci_info

> [  469.389759] usb 5-2: New USB device found, idVendor=0801, idProduct=2231
> [  469.389766] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  469.389772] usb 5-2: Product: STX
> [  469.389777] usb 5-2: Manufacturer: MagTek
> [  469.389781] usb 5-2: SerialNumber: STX001
> [  469.393023] ehci_hcd 0000:00:1d.7: irq status c028 masked 20
> [  507.575453] ehci_hcd 0000:00:1d.7: irq status 600b masked 3
> [  507.575465] ehci_hcd 0000:00:1d.7: devpath 2 ep2in 3strikes
> [  507.575470] drivers/usb/serial/magtek.c: magtek_read_int_callback - port 1
> [  507.575484] usb 5-2: unlink qh0-00ff/ded71100 start 0 [1/0 us]
> [  507.576084] usb 5-2: link qh0-00ff/ded71100 start 0 [1/0 us]
> [  507.576548] usb 5-2: unlink qh0-00ff/ded71100 start 0 [1/0 us]
> [  507.576548] ehci_hcd 0000:00:1d.7: HC died; cleaning up

For some reason this "HC died" line doesn't appear in your previous 
log.  I wonder why not?

> I have observed that IRQ status has changed to c028, how do I decode the irq
> status. This causes the IRQ disabled.Detailed log is below.

No, you're wrong.  Look at the timestamps.  The status was c028 when 
you plugged in the device; it changed to 600b when you unplugged it.
This didn't cause the the IRQ to be disabled, but it is an indication 
of where the problem really lies.

To decode the IRQ status values you need to consult the EHCI 
specification, section 2.3.2.

We need more information to track this down farther.  Add three copies
of this statement:

	ehci_info(ehci, "hcd state %d\n", hcd->state);

to the ehci_irq() function: one just before the line that says

	/* PCI errors [4.15.2.4] */

then below that just before the line that says

	spin_unlock (&ehci->lock);

and then just before the line that says

	return IRQ_HANDLED;

Make one other change as well, also in ehci-hcd.c.  In the function 
handshake_on_error_set_halt(), change these lines:

	if (error)
		ehci_to_hcd(ehci)->state = HC_STATE_HALT;

to this:

	if (error) {
		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
		ehci_err(ehci, "Handshake failed; controller halted\n");
		dump_stack();
	}

Maybe these will help us find where the problem comes from.

Alan Stern

