Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZGFEfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZGFEfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 00:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZGFEe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 00:34:57 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:29585 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZGFEe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 00:34:56 -0400
X-IronPort-AV: E=Sophos;i="4.42,354,1243828800"; 
   d="scan'208";a="1112435"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] usb_serial: only allow sysrq on a console port
Date: Mon, 6 Jul 2009 00:38:18 -0400
User-Agent: KMail/1.9.5
CC: greg@kroah.com, "Jason Wessel" <jason.wessel@windriver.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com> <200907051254.41964.rgetz@blackfin.uclinux.org> <20090705191751.6bbf594c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090705191751.6bbf594c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907060038.18323.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Jul 2009 04:34:59.0099 (UTC) FILETIME=[1EB776B0:01C9FDF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 5 Jul 2009 14:17, Alan Cox pondered:
> > If Jason's patch is necessary () - should this be fixed up for
> > standard UARTs too?
> 
> I think so yes, although I'd not realised it wasn't protected currently
> ?

Hmm - try as I may - I can't get this to fail - so it must be protected 
somewhere....

Ahh---

It is in include/linux/serial_core.h:uart_handle_break() - never checked the 
header for the magic before I bugged you... sorry about that...

> > The above patch would sync the (seemlying duplicated) code between
> > drivers/usb/serial/generic.c and include/linux/serial_core.h
> 
> There is a lot of near duplicate code like this. That is one reason for
> adding struct tty_port. In theory both could be collapsed into
> 
> 	int tty_port_handle_sysrq(struct tty_port *port, unsigned int ch)
> 	{
> 	}
> 
> at this point as both USB and serial layer UARTs now have a port object.
> That would just need port->sysrq collapsing into the tty_port.
> port->console sort of already is.

It appears that the usb serial doesn't handle breaks like serial_core does. (I 
don't see any support for SAK in usb_serial either?)

Maybe _that_ is the real problem that Jason is trying to work around???


> > drivers/usb/serial/generic.c
> > int usb_serial_handle_sysrq_char(struct usb_serial_port *port,
> unsigned int ch)
> > {
> >         if (port->sysrq && port->console) {
> >                 if (ch && time_before(jiffies, port->sysrq)) {
> >                         handle_sysrq(ch,
> tty_port_tty_get(&port->port));
> >                         port->sysrq = 0;
> >                         return 1;
> 
> That also looks wrong - tty_port_tty_get takes a tty kref. I will check
> that Monday and look at collapsing these int one as you note.

