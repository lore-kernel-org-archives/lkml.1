Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZGESSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZGESSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZGESSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:18:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48733 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753363AbZGESSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:18:11 -0400
Date: Sun, 5 Jul 2009 19:17:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: greg@kroah.com, "Jason Wessel" <jason.wessel@windriver.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb_serial: only allow sysrq on a console port
Message-ID: <20090705191751.6bbf594c@lxorguk.ukuu.org.uk>
In-Reply-To: <200907051254.41964.rgetz@blackfin.uclinux.org>
References: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com>
	<1243622057-17671-3-git-send-email-jason.wessel@windriver.com>
	<20090601143538.70b7a4e2@lxorguk.ukuu.org.uk>
	<200907051254.41964.rgetz@blackfin.uclinux.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If Jason's patch is necessary () - should this be fixed up for standard
> UARTs too?

I think so yes, although I'd not realised it wasn't protected currently ?
> 
> Make sure that only serial console (not _any_ serial port) responds to 
> sysrq (or should something else be ensuring that this isn't set when 
> the port !console? (I didn't see anything in serial_core.c?)

will check

> The above patch would sync the (seemlying duplicated) code between
> drivers/usb/serial/generic.c and include/linux/serial_core.h

There is a lot of near duplicate code like this. That is one reason for
adding struct tty_port. In theory both could be collapsed into

	int tty_port_handle_sysrq(struct tty_port *port, unsigned int ch)
	{
	}

at this point as both USB and serial layer UARTs now have a port object.
That would just need port->sysrq collapsing into the tty_port.
port->console sort of already is.

> Greg?
> 
> drivers/usb/serial/generic.c
> int usb_serial_handle_sysrq_char(struct usb_serial_port *port, unsigned int ch)
> {
>         if (port->sysrq && port->console) {
>                 if (ch && time_before(jiffies, port->sysrq)) {
>                         handle_sysrq(ch, tty_port_tty_get(&port->port));
>                         port->sysrq = 0;
>                         return 1;

That also looks wrong - tty_port_tty_get takes a tty kref. I will check
that Monday and look at collapsing these int one as you note.

Alan
